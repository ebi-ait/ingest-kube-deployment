import argparse, json, requests, logging, os

def is_in_dcp(uuid):
    azul_proj_url = f'https://service.azul.data.humancellatlas.org/index/projects/{uuid}'
    if requests.get(azul_proj_url):
        logging.info(f'Project {uuid} is in DCP')
        return True
    return False

def get_publications_journal(project):
    # Use crossref API to get extra meta info
    # This should be replicated in ingest API endpoint when we have an endpoint
    # Not done on client side for speed
    publications = project["content"]["publications"]
    results = []
    for publication in publications:
        try:
            if not publication.get('doi'):
                logging.info(f"Project {project['uuid']['uuid']} has no doi")
                continue

            r = requests.get(f"https://api.crossref.org/works/{publication['doi']}")
            r.raise_for_status()
            crossref = r.json()['message']

            if len(crossref['container-title']) > 0:
                journal_title = crossref['container-title'][0]
            elif "name" in crossref['institution']:
                # BioRxiv is listed under institution
                journal_title = crossref['institution']['name']
            else:
                journal_title = crossref['publisher']

            results.append({
                "doi": publication['doi'],
                "url": crossref['URL'],
                "journalTitle": journal_title,
                "title": publication['title'],
                "authors": publication['authors']
            })
        except:
            logging.error(f"Something went wrong retrieving metainformation for publication {publication['doi']} for project {project['uuid']['uuid']}")
    return results


def get_project(uuid, base_url):
    project_url = f'{base_url}/projects/search/findByUuid?uuid={uuid}'
    try:
        response = requests.get(project_url)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        logging.error(f'Error getting project {uuid}: {e}')

def perform_patch(patch, url, token=None):
    headers={'Content-Type': 'application/json'}
    if token:
        headers['Authorization'] = token

    data = json.dumps(patch)
    r = requests.patch(url, data=data, headers=headers)
    r.raise_for_status()

def patch_project(uuid, project, token=None):
    try:
        update_url = f'{project["_links"]["self"]["href"]}?partial=true'
        project_patch = {}
        
        if project["wranglingState"] != "Published in DCP" and is_in_dcp(uuid):
            project_patch["wranglingState"] = "Published in DCP"

        if "publications" in project["content"]:
            publications_info = get_publications_journal(project)

            if "publicationsInfo" not in project or publications_info != project['publicationsInfo']:
                project_patch["publicationsInfo"] = publications_info
                
                # Remove all publicationsInfo first
                # Circumvents bug where authors are appended if they already exist
                # See dcp-363
                logging.info(f"Updating publications for project {uuid} and so removing existing publications first")
                perform_patch({ "publicationsInfo": None }, update_url, token)

        if not project_patch:
            logging.info(f"Patch unnecessary for project UUID: {uuid}")
        else:
            perform_patch(project_patch, update_url, token)
            logging.info(f"Successfully updated project {uuid} with patch: {project_patch}")

    except Exception as e:
        logging.error(f'Error patching project {uuid}: {e}')


def get_uuids_from_catalogue(base_url, count):
    catalogue_url = f'{base_url}/projects/search/catalogue?page=0&size={count}&sort=cataloguedDate,desc'
    res = requests.get(catalogue_url)
    res.raise_for_status()
    for project in res.json()['_embedded']['projects']:
        yield project['uuid']['uuid']

def get_token(input_file):
    with open(input_file, "r") as file:
        return file.read()
        

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