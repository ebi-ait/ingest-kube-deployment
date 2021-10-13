import argparse, json, requests, logging, os

def is_in_dcp(uuid):
    azul_proj_url = f'https://service.azul.data.humancellatlas.org/index/projects/{uuid}'
    if requests.get(azul_proj_url):
        logging.info(f'Project {uuid} is in DCP')
        return True
    return False


def get_project(uuid, base_url):
    project_url = f'{base_url}/projects/search/findByUuid?uuid={uuid}'
    try:
        response = requests.get(project_url)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        logging.error(f'Error getting project {uuid}: {e}')
    

def patch_project(uuid, project, token=None):
    project_patch = {}
    
    if project["wranglingState"] != "Published in DCP" and is_in_dcp(uuid):
        project_patch["wranglingState"] = "Published in DCP"

    if not project_patch:
        logging.info(f"Patch unnecessary for project UUID: {uuid}")
        return None

    try:
        update_url = f'{project["_links"]["self"]["href"]}?partial=true'
        headers={'Content-Type': 'application/json'}    
        data = json.dumps(project_patch)
        r = requests.patch(update_url, data=data, headers=headers)
        r.raise_for_status()
        logging.info(f"Successfully updated project {uuid} with patch: {project_patch}")
    except Exception as e:
        logging.error(f'Error patching project {uuid}: {e}')


def get_uuids_from_catalogue(base_url, count):
    catalogue_url = f'{base_url}/projects/search/catalogue?page=0&size={count}&sort=cataloguedDate,desc'
    res = requests.get(catalogue_url)
    res.raise_for_status()
    for project in res.json()['_embedded']['projects']:
        yield project['uuid']['uuid']
        

if __name__ == "__main__":
    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)

    description = "Update projects in ingest that are in the catalogue to have the correct wrangling status if they are in the DCP"
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("-c", "--count", help="Number of projects to pull to check for updates", default=50, type=int)
    
    # Args for running this script locally
    parser.add_argument("-u", "--url", help="Base URL for Ingest API", default=None)
    parser.add_argument("-t", "--token", help="Text file containing an ingest token. Used for local testing purposes", default=None)
    parser.add_argument("-i", "--uuid", help="Comma seperated list of UUIDs to use instead of querying the catalogue. Used for testing", default=None)

    args =  args = parser.parse_args()
    
    if args.url:
        url = args.url
    else:
        # Build the url from internal service IP
        # See: https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#environment-variables
        local_core_ip = os.getenv("INGEST_CORE_SERVICE_SERVICE_HOST")
        local_core_port = int(os.getenv("INGEST_CORE_SERVICE_SERVICE_PORT"))
        url = f'http://{ local_core_ip }:{ local_core_port }'

    logging.info(f'Using base url {url}')

    token = get_token(args.token) if args.token else None
    uuids = args.uuid.split(",") if args.uuid else get_uuids_from_catalogue(url, args.count)
    
    logging.info(f'Querying {args.count} projects...')

    for uuid in uuids:
        project = get_project(uuid, url)
        if project:
            patch_project(uuid, project, token)