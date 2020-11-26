# Staging Changelog
# 26 November 2020
- UI 4bdf96a
    - Few tweaks for error summary

# 26 November 2020
- Core 3567ad1
    - Add counts for each type of invalid file in summary


## 25 November 2020
* UI 59fbe10
    - Changes for validation error summary and file validation error type filtering
* Core 4fba6222
     - Changes for validation error summary and file validation error type filtering
* Validator 5e77956
     - Changes for validation error summary and file validation error type filtering

## 19 November 2020
* UI 6f81bc9
   - Project view changes
* Archiver 79fcb19
   - changes in ontology lookup for all ontology fields


## 09 November 2020
* UI c41f3f0
    - Start using nginx server instead of ng serve command
* Exporter 9eff2dd
    - Put uploads into project subdirectory

## 03 November 2020
* Core 4122ce5
  - Re-implementation of generic search endpoints for all entity types

## 29 October 2020
* Core a3f0b3a6
  - Created generic search endpoints for protocols, processes and files
* UI d9f3514
  - Support updating of metadata links

## 28 October 2020
* Archiver 11c4a6d (ebi-ait/dcp-ingest-central#60)
  - Archive Organ and Organ Parts to BioSamples

## 21 October 2020
* Validator 8006c48 (ebi-ait/dcp-ingest-central#7)
  - Validate file metadata before data file upload

## 20 October 2020
* UI 970f3b2
  - Viewing of orphaned entities
  - Viewing of process details
  - Updating metadata

* Core fa042076
  - Retrieving if a biomaterial or file has links
  - Added endpoint to search biomaterials by metadata fields

* Broker c232971
  - Added internal endpoint for the UI to fetch the dereferenced schema


## 13 October 2020
* UI 0e831ba (#53)
  - Linting and Observables Fixups
  - Improved Error handling

## 8 October 2020
* Core 7344588c
  - Secured Ingest API Endpoints
* Exporter f7e1f16
  - Fix to bucket destination paths and file descriptor json

## 6 October 2020
* UI 9ca1851 (#54)
  - Changes to Template Generator questions
    - Text
    - Defaults
    - Help Text
    - Input Types
* Broker ba82da3 (#8)
* Client a263d14 (#6)
  - Decrease header row heights and dynamically adjust column widths
## 25 September 2020
* Core 552aa5d (#38)
  - Migrate project.dataAccess.type to singleton
* UI 8cbd695 (#52)
  - Migrate project.dataAccess.type to singleton
  - Change question text for technologies.
  - Add support for multiple root ontologies
  - View Mode & Other Fixes
## 17 September 2020
* Archiver 88523bd, 88523bd-cli
  - Remove passing of Ingest API url in the File Upload Plan for the File Archiver
* File Archiver 2391ca0
  - Remove handling of Ingest API url from File Upload Plan

## 16 September 2020
* UI 8a90e5c
  - Header and Footer Changes
  - Template Generation Logic
  - Google Analytics
* Broker 9fe11a6
  - Allow empty Entities and Protocols

## 8 September 2020
* Archiver 7e7f3f5
  - Use 10xV2 bam conversion for CITE-seq sequencing experiments

## 7 September 2020
* Core ad114033
  - Add new endpoint to uniquely search an archive entity

* Exporter a25f57f
  - Bringing down prod hotfix from last week

* Archiver e2244eb
  - Return HTTP 409 for invalid api key in request headers
  - Fix completion of DSP submissions

## 28 August 2020
* UI b627c09
  - Text changes to the landing page and project registration page
  - Mark technology field in project registration form required
  - Added footer
  - Pinning VF version

## 26 August 2020
* Core 7fd19efc
  - Update to exporter messages
  - Retry fix on delete submission
  - Use assay process uuid and its dcp version as bundle/experiment uuid and version for the exporter message

* Broker b6282da
  - Spreadsheet template generation
  - Updated python dependencies

* Exporter fe24d69
  - File Descriptor changes
  - Use GCP transfer service to export files to GCP

* UI 3886edd
  - Spreadsheet template generation integration with backend
  - Updates to Landing page
  - Do not filter out test projects in all projects page
  - Always display the last archive submission

* Validator 6f4bf1e
  - Updated config for file extensions to validate

## 20 August 2020
* Archiver 4de2754
  - Securing archiver service endpoints with an api key
  - Support datasets with samples that have multiple "derived from" relationships.

## 13 August 2020
* Core 877f9e0
  - Migration Fix-up
  - Exporter creates Export Job to orchestrate Exporter logs.

## 12 August 2020
* Core f3bc743
  - New ExportJobs ExportEntities data model for tracking export and archiving attempts and relevant data
  - `/submissionEnvelope/{sub_id}/exportJobs`
  - `/exportJobs/{job_id}/entities/{entity_id}`

## 10 August 2020
* Core e90bafc
  - Removed ArchiveEntities uniqueness constraint.
  - ArchiveSubmission for SubmissionEnvelope endpoint returns list.
  - Deleting an Archive Submission first deletes the entities that are linked to it.

## 22 July 2020
* Archiver 529b61a , 529b61a-cli
  - Store accessions if present in DSP processing result
  - Fix cli way to complete submission
  - Fix population of metadataUuids field for sequencingRun archive entities
  - Remove setting of metadata back to Draft to not retrigger file validation

## 21 July 2020
* UI 1fb93f0
  - Spreadsheet Template Questionnaire (Disconnected).

## 10 July 2020
* UI 635fda8
  - Preserve the user's destination if interrupted by the login page.

* Core 1f571f1
  - Remove Email Domain Check.

## 8 July 2020
* UI 2422199
  - New Landing page
  - New Contributor Projects Dashboard
  - New Project Registration form for contributors

* Core e3129c5
  - Assigning Primary Wranglers to Projects
  - Project notifications

## 24 June 2020
* Core 855461a
  - New endpoints for state transition changes
  - Tracking archiving entities
  - CI GitHub Workflow

* State Tracking 6801bf0
  - Archiving to Exporting Flow

* Archiver 6df8dbd
  - New archiving endpoints
  - Setting of Archived state
  - Tracking entities and accessions in Ingest

* Exporter 3a0ddba
  - Exporting to Terra Data Repo
  - Changes to assay manifest generator
  - Notifying state tracker

* UI 93f55fa
  - Submission view changes
  - Display New Submission States in UI
  - Give user checkbox options when submitting : archive, export, cleanup
  - The user must select at least one of archive (Submit to Archives) and export (Submit to HCA)
  - User won't be able to untick the cleanup checkbox if export is unticked.
  - Checkboxes are all checked by default
  - When waiting at Archived the submit button should display Export to HCA
  - When waiting at Exported, the submit button should display Delete Upload Area

### Deployment notes:
* Update ingress
```
$ cd infra
$ make setup-ingress-<env>

# double check if archiver service endpoint is configured
$ kubectl get ingress ingest-ingress -o yaml
```
* Redeploy secrets
```
$ cd app
$ make deploy-secrets
```
* Deploy new images

* Add archiver endpoint in route 53
```
archiver.ingest.staging.archive.data.humancellatlas.org
```

## 20 May 2020
* Core 1d97330
  - Additional fields in the Project
  - Reorganised integration tests.

* UI 6ba4833
  - New fields in project form: data access, identifying organism, technology
  - Added multiple select, select option fields with autocomplete
  - Added custom multiple select and select for ontology fields
  - Added tooltip for description of form tabs
  - Modify angular material theme to be "HCA blue"ish and typography to use VF fonts
  - Fix navigation header after registration / login
  - Refactored to recursively generate the form fields

## 13 May 2020
* Core 9499ba1
  - Account Registration
  - New Project attributes

* UI f65396a
  - Hide Wrangler UI elements for Non-Wranglers
  - Add “Dates” tab - to provide information on timelines for ingestion
  - Fix delete project
  - Project Form changes:
     - Change ‘save and continue’ to give “expected action”
     - Edit project button retains which page you were viewing of a project
     - Support for “array of strings” fields (e.g. publication authors, project accession fields)
     - Add in missing project fields: supplementary_links, accession fields, pmid
     - Remove work in progress banners
     - Change order of project fields
     - Make optional versus required fields more obvious and indicate the blue star means required.
     - Some module fields are required only if added. Remove the module fields initially in the form.
     - Added project role ontology field

~DCP Staging Release Notes: https://github.com/HumanCellAtlas/dcp/blob/staging/RELEASE_NOTES.md~

## 14 February 2020
* Core ae3f8fe
  - Bundle manifest endpoint fix
  - Added new Archiving submission state

* State Tracking f6d4cbf
  - Added new Archiving submission state

* UI e5ef66e
  - Display new Archiving submission state

* Exporter 21f7197 (not from MASTER)
  - Generate bundle manifest but do not submit to DSS

## 27 November 2019

* Core f31fcbd
  - Security configuration
  - JWT user credentials inspection
  - Mongo feature compatibility run check

* Ontology 1.0.12
  - Latest ontology release

## 11 September 2019

* Core c54cf190
  - Tracking uuid of staged metadata files
  - Handling bundle manifest null fields
  - Logging unhandled exporting exceptions
  - Updated primary submission documentation

* Exporter 311950c
  - Fix simple updates issue when staging shared metadata files among bundles

* Validator e52fafb
  - Fix retrying of file validation
  - Security Fixes

* UI f42dac1
  - Remove unnecessary logging
  - Added link to project view from the submission view

## 14 August 2019

* Core v0.9.4.rc: 49f7c09
  - Memory-optimized findAssays() for stability
  - Updated primary and secondary submission documentation
  - New API endpoints for linking process to input bundle and input files

* Exporter v0.8.8.rc:1f5adad
  - Exporting major/minor schema versions in provenance
  - Fix null:null submission error

* UI v0.10.1.rc:8a25c14
  - Display project uuid in submission view

## 30 July 2019

* Broker v0.9.2.rc: e650e6f
  - Fix reporting of submission error

* Core v0.9.3.rc: 487b1cf
  - Fix failure in POSTing submission endpoint

* UI v0.9.7.rc: 8f5010e
  - Removing button to do retry when metadata is invalid

* Exporter v0.8.7.rc: 5388780
  - Reinstantiate DSS client to prevent token expiration

* Validator v0.6.6.rc: a28e364
  - Multiple file validation jobs fix

## 24 July 2019
* Core v0.9.2.rc
  - Put back authentication for PUT & PATCH requests

* Mongo
  - Set a size limit on in-memory caching to ensure cluster reliability

### Deployment Notes:
1. Redeploy the mongo helm chart:
  * `cd infra && make install-infra-helm-chart-mongo`


## 17 July 2019
* Exporter v0.8.6.rc: c195f09
  - Fix date format check
* Validator v0.6.5.rc: 599b12c
  - (same version) fastq subprocess fix
* Broker v0.9.1.rc: eb4393a
  - Fix updating of file metadata when data file is uploaded first

## 15 July 2019
* Core v0.9.2.rc: 9b7a381
  - APIs for performing simple updates to bundles
  - APIs for viewing JSONPatch diffs when performing updates
  - Search submissions by project
  - Disabled “Submit” button when linking hasn’t yet been completed(spreadsheet submissions only)
  - Now using Java 11, Spring boot 2

* Exporter v0.8.5.rc: 41387a7
  - Handles update submissions and performs simple bundle updates as necessary
  - Separate AMQP listener for update messages
  - duplicate links in links.json fix

* Broker v0.9.0.rc: 0d85bbf
  - Handles update spreadsheets
  - Providing a mechanism for generating and downloading update-spreadsheets from submitted spreadsheets

* UI v0.9.6.rc: 4d58809
  - Widgets for uploading and downloading an update-spreadsheet
  - Paginated project dashboard
  - Widget to search for projects by title, shortname, etc.
  - Submissions table view inside the projects tab

* Validator v0.6.5.rc: 599b12c
  - Added ontology validation keyword
  - Ontology service updates

* Staging manager v0.5.4.rc: 7791e6c
  - ingest-client library updates, refactoring

* State tracker v0.7.5.rc: 38a399c
  - Now using Java 11

### Deployment Notes:
1. Delete deployment of ingest-node-accessioner
2. Deploy persistence volume claim before redeploying ingest-broker
  * `make setup-retained-storage-staging`
  * `helm delete ingest-broker`
2. Redeploy core after state tracker
3. Redeploy validator after ontology service
4. Update mongo database:
* Need to apply these changes so that the latest codes will work for existing documents. It is important that the queries are executed one at a time and monitor the RAM usage of mongo during execution using top. If the RES value in top output is reaching 4-5gb, restart the mongo pod (`kubectl delete pod mongo-0`) to reset the RES value to minimum value.

```
// optional

db.project.find({ "isUpdate": null }).count()

db.biomaterial.find({ "isUpdate": null }).count()

db.protocol.find({ "isUpdate": null }).count()

db.process.find({ "isUpdate": null }).count()

db.file.find({ "isUpdate": null }).count()

//
db.project.update(
    { "isUpdate": null },
    { "$set": { "isUpdate": false } }, false, true
)

db.biomaterial.update(
    { "isUpdate": null },
    { "$set": { "isUpdate": false } }, false, true
)

db.process.update(
    { "isUpdate": null },
    { "$set": { "isUpdate": false } }, false, true
)

db.file.update(
    { "isUpdate": null },
    { "$set": { "isUpdate": false } }, false, true
)

db.protocol.update(
    { "isUpdate": null },
    { "$set": { "isUpdate": false } }, false, true
)

```

## 07 June 2019
* Core v0.9.1.rc:f17bc84
  - New endpoints for searching primary and analysis bundle manifests

## 05 Jun 2019
* Exporter v0.8.3.rc:be11bc4
  - Fix submissions stuck in Processing due to failed state tracker bundle complete notification

* UI v0.9.5.rc:bb98f1c
  - Make Fusillade url configurable thru env var
  - Fix greetings and picture display

## 29 May 2019
* Exporter 0.8.2.rc
  - Minor changes to prevent creation of Pika connections unncessarily.

## 22 May 2019
* Exporter v0.8.1.rc:6bb5cd5
  - Do not inform user when there’s a failure creating a duplicate bundle

* UI v0.9.4.rc:f00e018
  - Use Fusillade integration

## 30 April 2019
* Validator v0.6.4.rc:39e6120 (hotfix)
  - Only perform file validation if the the File metadata document is valid

## 20 March 2019
* Core v0.8.5.rc
  - Exclude property_migrations file when retrieving latest schemas from s3 bucket listing
  - Log INFO messages
  - Fix intermittent issue where file validation fails due to many validation events
  - Find by validation ID using the ID of the validation job
  - Always setting to DRAFT when updating a file's cloudUrl/checksums

* Validator v0.6.2.rc
  - Bug fix validating files which do not trigger job
  - Handling errors
  - Added checking of checksum when triggering validation job
  - Added methods in ingest-client for fetching file checksum info
  - Bug fix when refusing to validate File resources with no content/metadata
  - Security patches
  - Targetting a newer version of the fastq validation image

## 13 March 2019

* Core 3bd05d0:v0.8.5.rc
  - Exclude property_migrations file when retrieving latest schemas from s3 bucket listing
  - Log INFO messages
  - Fix intermittent issue where file validation fails due to many validation events
  - Find by validation ID using the ID of the validation job
  - Always setting to DRAFT when updating a file's cloudUrl/checksums

* Validator f512fd8:v0.6.1.rc
  - Bug fix validating files which do not trigger job
  - Handling errors
  - Added checking of checksum when triggering validation job
  - Added methods in ingest-client for fetching file checksum info
  - Bug fix when refusing to validate File resources with no content/metadata
  - Security patches
  - Targetting a newer version of the fastq validation image

* Ingress
  - Redeploy to enable http -> https redirects to Ingest endpoints

* RabbitMQ
  - Redeploy to restrict access

* Mongo
  - Delete validationId index in File collection `db.file.dropIndex("validationId")`

## 06 March 2019

* Broker 704e5a7:v0.8.8.rc
  - minor fix to code
* Core f7e85be:v0.8.4.rc
  - authentication related security related patches


## 21 February 2019

* Broker 37e15b8:v0.8.7.rc
  - Bug fixes in the importer: trailing space and number field conversion

* UI c074e10:v0.5.4.rc
  - Show linking progress in the UI
  - Upgrade to component versions


## 13 February 2019

* Core v0.8.2.rc
  - Added submission envelope field to track number of expected links/edges in the metadata graph

* Broker v0.8.6.rc
  - Utilizing submission envelope's link/edge counter

## 30 January 2019

* Broker v0.8.5.rc
  - Reporting all import errors to the submission envelope

* Core v0.8.1.rc
  - Bug fixes in JSON parsing upload-service messages
  - Logging auth failures

## 23 January 2019

* Core v0.8.0.rc
  - Expose API endpoints for rabbitmq communication
  - Accept and verify JWT tokens from DCP Auth and GCP Service accounts
  - Point to schema https urls

* Exporter v0.7.7.rc
  - Reporting export errors in submission envelope
  - Remove unused schema env var in the exporter

* Ontology
  - Redeploying to pick up new ontology values

* UI v0.5.3.rc
  - Use DCP Auth (Fusillade) for Authentication
  - Display submission errors
  - Display commit hash build

## 12 December 2018

* Broker v0.8.4.rc
  - Fix to connection reset error during spreadsheet import
  - Fix schema parsing, defaults to string if there is no items obj inside array field in schema
  - Added fix to ensure that import doesn't fail due to erroneous max_row count
  - Fixes to raising and logging error details

* Exporter v0.7.6.rc
  - Fix to DSS datetime version format
  - DSS API Authentication
  - More info on logs
  - Deploy new exporter secrets

* Validator v0.6.0.rc (same version)
  - Deployment config change to make validator point to the latest fastq validator image (fastq_utils:v0.1.0.rc)

* Staging Manager v0.5.3.rc
  - Remove 10s wait when creating upload area
  - Fix setting for retry policy, retrying for ~20min

* Ontology
  - Redeploying to pick up new ontology values

## 24 October 2018

* Core v0.7.7.rc
  - simplified findByUuid

## 19 October 2018

* State Tracker V0.7.3.rc
  - Fixed bug determining the URI for persisted state machines

* Exporter v0.7.5.rc
  - Fix bug in analysis export, analysis bundles should reference same metadata file version from input bundle

## 17 October 2018

* Broker v0.8.3.rc
  - Fixed bug whereby file metadata updates fail if a file is uploaded prior spreadsheet upload

## 16 October 2018

* Core v0.7.6.rc
  - Lazy load biomaterial dbrefs

## 15 October 2018

* Core v0.7.5.rc
  - Fix to slowdown cause by UUID generation

* State Tracking v0.7.2.rc
  - Fix to state tracking persistence
  - Ensuring envelopes go to the Cleanup state when more than the number of expected bundles are generated

## 11 October 2018

* Core v0.7.4.rc
  - Logging when submission envelope is created and submitted
  - Optimization in finding assay processes for export
  - Bug fixes

## 03 October 2018

* Broker v0.8.2.rc
  - Fix to submission error message

* Exporter v0.7.4.rc
  - Reverted to 20 retries spaced a minute apart for operations on the DSS API
  - Using ingest's update timestamp for creating .json files in the DSS, averting needless duplicates
  - Polling DSS Files to confirm their full creation prior to creating a bundle containing said Files

* Staging Manager v0.5.2.rc
  - Set to use HTTP HEAD when checking staging area

## 19 September 2018

* Core v0.7.3.rc
  - Fix bug in sending messages to state tracker when adding reference files in a secondary submission
  - Reduce timeout when sending state tracking messages
  - Updated secondary submission documentation

* State Tracker v0.7.1.rc
  - Reducing timeout before the actual submission state update happens
  - Concurrent hash map for document states

* Exporter v0.7.2.rc
  - Use latest schema for links.json

* Broker v0.8.1.rc
  - Added support for multiple ontology processing

## 12 September 2018

* Core v0.7.2.rc
  - Optimizations regarding sending of unnecessary messages to the rabbit-mq broker
  - Integration with the state tracker’s HTTP API
  - Indexing on Process resources’ input and output biomaterials/files enabling faster bundle generation and export

* State Tracker v0.7.0.rc
  - Race condition bug fix whereby state updates were processed out of order
  - Added a HTTP API for processing state update messages

* Exporter v0.7.1.rc
  - Caching of previously retrieved documents for faster export time
  - Retrying 20 times with 1 minute between for idempotent requests to the DSS

## 07 September 2018

* Accessioner v0.5.0.rc
  - New Accessioner using Node.js

* Core v0.7.1.rc
  - Endpoint in monitoring state transitions of submission envelope
  - Added File indices in mongo for faster uploading of files metadata

* Broker v0.8.0.rc
  - Ability to upload supplementary files
  - Ability to Link entity to entity with same concrete type in the spreadsheet
  - Changes Submission report format
  - Configurable submission report
  - Error handling changes during spreadsheet upload
  - Support for additional project modules in spreadsheet

* State Tracker v0.6.1.rc
  - Optimizations in sending state tracker messages
  - Fix to race condition when processing state tracker messages

* Validator v0.6.0.rc
  - New JavaScript Validator
  - Support for Draft-07 JSON schema

* UI v0.5.2.rc
  - Fix submission dashboard pagination
