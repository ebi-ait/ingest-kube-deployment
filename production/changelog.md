# Production Changelog

## 26 January 2021
* Ontology 1.0.19
  - HCAO release 1.0.19 ebi-ait/hca-ebi-dev-team#376

* Validator
  - update ontology cache

## 25 January 2021
* Archiver d2021-01-23.1
  - Putting back the ontology search function for checking 10x

## 05 January 2021

* Broker f0fe879 d2021-01-05.1
  - Always use prod schema url for all ingest environments

## 04 January 2021

* UI 1d20d2f d2021-01-04.1 
  - Use state endpoints to set back metadata into Draft state

* Broker 4dfe50f d2021-01-04.2
  - Adjustments to core entity endpoint changes

* Core b7c9bf71 d2021-01-04.1
  - Point to prod schema env https://schema.humancellatlas.org/, the schema url for staging http://schema.staging.data.humancellatlas.org/ is now removed
  - Update dcpVersion everytime content is modified to export new version
  - Restrict fields that can be patched
  - Added additional timestamp fields contentLastModified, firstDcpVersion (needs migration)
  - Make payload consistent for all entity endpoints
  - Fix file error in total count
  - Preserve original behavior where submission envelope link value from index page is object instead of array
  - Updated the CORS Config to not use the deprecated WebMvcConfigurerAdapter

* State Tracker bc6bb2b d2021-01-04.1
  - Allow submission to be set back to Draft after Exported

* Validator 0f03549 d2021-01-04.1
  - Fix data file validation errors
  - Use quay.io/ebi-ait/fastq_utils:54bcf9f which should be consistent with dev and prod

* Broker 7a3dd98 d2021-01-04.1
  - Link metadata entities to a project
  - change in Dockerfile base image

## 07 December 2020
* Ontology 1.0.18
  - New release of HCAO and EFO slim

* Validator 634a37b6 d2020-11-27.1
  - same version, redeployed to pick up new ontology values

## 03 December 2020
* UI d2020-12-03.1 ddbdbf1
  - Changes to stop endless polling even after requests start failing.
  - Don't send JWT on unauthenticated requests
  - Fixes Elixir 100k+ requests

## 27 November 2020
* UI 59fbe10 d2020-11-27.1
    - Changes for validation error summary and file validation error type filtering
* Core 4fba6222 d2020-11-27.1
     - Changes for validation error summary and file validation error type filtering
     - All entities now have a link to a project
* Validator 5e77956 d2020-11-27.1
     - Changes for validation error summary and file validation error type filtering

## 03 November 2020
* Core 4122ce5 d2020-11-03.1
  - Re-implementation of generic search endpoints for all entity types

## 2 November 2020
* Archiver 11c4a6d d2020-11-02.1
    - Archive Organ and Organ Parts to BioSamples
* Core a3f0b3a6 d2020-11-02.1
    - Created generic search endpoints for protocols, processes and files
    - Secured Ingest API Endpoints
* UI d9f3514 d2020-11-02.1
    - Support updating of metadata links
    - Viewing of orphaned entities
    - Viewing of process details
    - Updating metadata
* Validator 8006c48 d2020-11-02.1
    - Validate file metadata before data file upload
* Broker c232971 d2020-11-02.1
    - Added internal endpoint for the UI to fetch the dereferenced schema
* Ontology 1.0.17 d2020-11-02.1
    - HCA ontology release 1.0.17

## 23 October 2020
* Exporter f7e1f16 d2020-10-22.1
 - Fix file descriptor content and file destination paths

## 08 October 2020

* UI 9ca1851, 8a90e5c, d2020-10-08.1
  - Changes to Template Generator questions
    - Text
    - Defaults
    - Help Text
    - Input Types
  - Migrate project.dataAccess.type to singleton
  - Change question text for technologies.
  - Add support for multiple root ontologies
  - View Mode & Other Fixes
  - Header and Footer Changes
  - Template Generation Logic
  - Google Analytics

* Broker ba82da3, 9fe11a, d2020-10-08.1
  - Spreadsheet template generator API
  - Allow empty Entities and Protocols
  - Decrease header row heights and dynamically adjust column widths

* Core 552aa5d, d2020-10-08.1
  - Migrate project.dataAccess.type to singleton

* Archiver 88523bd, 88523bd-cli, d2020-10-08.1_CLI, d2020-10-08.1
  - Remove passing of Ingest API url in the File Upload Plan for the File Archiver

* File Archiver 2391ca0, 
  - Remove handling of Ingest API url from File Upload Plan
  - Use AWS CLI for dowloading files from s3


## 09 September 2020
* Archiver 7e7f3f5, 7e7f3f5-cli, d2020-09-09.1_CLI, d2020-09-09.1
  - Treat CITE-seq as 10xV2

## 07 September 2020
* Core ad114033, d2020-09-07.1
  - Add new endpoint to uniquely search an archive entity

* Archiver e2244eb, d2020-09-07.1, e2244eb-cli, d2020-09-07.1_CLI
  - Return HTTP 409 for invalid api key in request headers
  - Fix completion of DSP submissions

* Validator (No version change)
  - Use new image version of fastq_utils d2020-09-07.1


## 26 August 2020
* Core 0bab5e4e, d2020-08-26.1
  - Removed unique index for archive entity alias
  - Fixes to archive entity endpoints
  - Delete archive entities when deleting archive submission
  - New ExportJob entities and endpoints
  - Update to exporter messages
  - Retry fix on delete submission

* Exporter a25f57f, d2020-08-26.1
  - Use GC Storage service to export files to Terra staging buckets
  - Tracking Export Job

* UI (No version change)
  - Prod UI url change to https://contribute.data.humancellatlas.org/

## 20 August 2020
* Archiver 3f05ce7, d2020-08-20.1, d2020-08-20.1_CLI
  - Support datasets with samples that have multiple "derived from" relationships

## 22 July 2020
* Archiver d2020-07-22.1 , d2020-07-22.1_CLI
  - Store accessions if present in DSP processing result
  - Fix cli way to complete submission
  - Fix population of metadataUuids field for sequencingRun archive entities
  - Remove setting of metadata back to Draft to not retrigger file validation

## 15 July 2020
* UI d2020-07-15.1 (635fda8)
  - Preserve the user's destination if interrupted by the login page
  - New Landing page
  - New Contributor Projects Dashboard
  - New Project Registration form for contributors

* Core d2020-07-15.1 (1f571f1)
  - Assigning Primary Wranglers to Projects
  - Project notifications
  - Remove Email Domain Check.

## 25 June 2020
* Core d2020-06-25.1 (855461a)
  - New endpoints for state transition changes
  - Tracking archiving entities
  - CI GitHub Workflow

* State Tracking d2020-06-25.1 (6801bf0)
  - Archiving to Exporting Flow

* Archiver d2020-06-25.1 (6df8dbd)
  - New archiving endpoints
  - Setting of Archived state
  - Tracking entities and accessions in Ingest

* Exporter d2020-06-25.1 (3a0ddba)
  - Exporting to Terra Data Repo
  - Changes to assay manifest generator
  - Notifying state tracker

* UI d2020-06-25.1 (93f55fa)
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
archiver.ingest.archive.data.humancellatlas.org
```

## 26 May 2020
* Core d2020-26-05.1 (1d97330)
  - Allow user to create project first before submission envelope
  - Account Registration
  - New Project attributes
  - Additional fields in the Project
  - Reorganised integration tests.

* UI d2020-26-05.1 (0847af4)
  - Use Visual Framework for UI components
  - New Project Registration form
  - Hide Wrangler UI elements for Non-Wranglers
  - Add “Dates” tab - to provide information on timelines for ingestion
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
  - New fields in project form: data access, identifying organism, technology
  - Added multiple select, select option fields with autocomplete
  - Added custom multiple select and select for ontology fields
  - Added tooltip for description of form tabs
  - Modify angular material theme to be "HCA blue"ish and typography to use VF fonts
  - Fix navigation header after registration / login
  - Refactored to recursively generate the form fields

~DCP Production Release Notes: https://github.com/HumanCellAtlas/dcp/blob/prod/RELEASE_NOTES.md~

## 17 February 2020
* Core v0.12.2:ae3f8fe
  - Bundle manifest endpoint fix
  - Added new Archiving submission state

* State Tracking v0.7.7:f6d4cbf
  - Added new Archiving submission state

* UI v0.12.2:e5ef66e
  - Display new Archiving submission state

* Exporter 21f7197 (not from MASTER)
  - Generate bundle manifest but do not submit to DSS


## 26 November 2019
* Broker v0.10.3
  - Updated schema processing
  - Importer fixes
  - New file search endpoint
* Core v0.11.1
  - Data migration
  - Delete submission
* State Tracking v0.7.6
  - Updated processing to limit to single submission envelope
* Validator v0.6.10
  - Single submission updates
  - Handling of ontology validation request error
* UI v0.11.4
  - Updates to metadata detail view
  - Submission deletion

## 05 November 2019
* UI v0.11.3
  - Security fixes
* Exporter v0.10.1
  - Pointing to latest ingest client version which is using new SchemaTemplate & SchemaParser
* Staging Manager v0.5.5
  - Pointing to latest ingest client version which is using new SchemaTemplate & SchemaParser
* Validator v0.6.9
  - Return INVALID ValidationReport when describedBy schema can't be retrieved

## 13 September 2019
* Core c54cf190
  - Tracking uuid of staged metadata files
  - Handling bundle manifest null fields
  - Logging unhandled exporting exceptions
  - Updated primary submission documentation

* Exporter 311950c
  - Fix simple updates issue when staging shared metadata files among bundles

## 20 August 2019

* Core v0.9.4
  - Memory-optimized findAssays() for stability
  - Updated primary and secondary submission documentation
  - New API endpoints for linking process to input bundle and input files

* Exporter v0.8.8
  - Exporting major/minor schema versions in provenance
  - Fix null:null submission error

* Validator v0.6.7
  - Fixed integration test failure

* UI v0.10.1
  - Display project uuid in submission view

## 30 July 2019

* Core v0.9.2
  - Put back authentication for PUT & PATCH requests

* Mongo
  - Set a size limit on in-memory caching to ensure cluster reliability

### Deployment Notes:
1. Redeploy the mongo helm chart:
  * `cd infra && make install-infra-helm-chart-mongo`

## 28 May 2019
* UI v0.9.4.rc:f00e018
  - Use Fusillade integration

## 15 May 2019 (hotfix)
* Exporter v0.8.1:6bb5cd5
  - Ignore failed processes trying to create duplicate bundles

## 30 April 2019
* Validator v0.6.4:39e6120 (hotfix)
  - Only perform file validation if the the File metadata document is valid

## 16 Apr 2019

* UI 2c7bfd3:v0.9.1
 - Presenting all validation errors

## 19 March 2019

* Validator v0.6.0
  - Typescript
  - Fixed bug where Files would be stuck in validating if metadata was missing(i.e files uploaded before complete spreadsheet import)
  - Asserting that Files aren't already validating before requesting file-validation
  - No longer triggering file-validation if a validation job has already been completed for the same checksums

* Core v0.8.5
  - Added ValidationJobs to track running/completed file-validation jobs
  - Bug fix attempting to parse property migration files from the Schemas bucket

* Ingress
  - Using HTTP->HTTPS redirection

## 12 March 2019

* Broker v0.8.8
  - minor fix to code
* Core  v0.8.4
  - authentication related security related patches

## 06 March 2019

* UI 4f3615c:v0.5.5 (hotfix)
  - Fix production configuration
  - Fix compilation errors for prod build due to Angular version upgrade

## 05 March 2019

* Broker 37e15b8:v0.8.7
  - Bug fixes in the importer: trailing space and number field conversion

* UI 987aaf7:v0.5.4
  - Show linking progress in the UI
  - Upgrade to component versions

## 20 February 2019

* Core v0.8.3
  - Added submission envelope field to track number of expected links/edges in the metadata graph
  - Hotfix to use different environment variables for user and service JWTs

* Broker v0.8.6
  - Utilizing submission envelope's link/edge counter

## 12 February 2019
* Broker v0.8.5
  - Reporting all import errors to the submission envelope

* Core v0.8.1
  - Bug fixes in JSON parsing upload-service messages
  - Logging auth failures

## 29 January 2019
* Core v0.8.0
  - Expose API endpoints for rabbitmq communication
  - Accept and verify JWT tokens from DCP Auth and GCP Service accounts
  - Point to schema https urls

* Exporter v0.7.7
  - Reporting export errors in submission envelope
  - Remove unused schema env var in the exporter

* UI v0.5.3
  - Use DCP Auth (Fusillade) for Authentication
  - Display submission errors
  - Display commit hash build


## 08 January 2019

* Exporter v0.7.6
  - Fix to DSS datetime version format
  - DSS API Authentication
  - More info on logs
  - Deploy new exporter secrets


## 18 December 2018
* Broker v0.8.4
  - Fix to connection reset error during spreadsheet import
  - Fix schema parsing, defaults to string if there is no items obj inside array field in schema
  - Added fix to ensure that import doesn't fail due to erroneous max_row count
  - Fixes to raising and logging error details

* Validator v0.6.0 (same version)
  - Config change: Point to the latest fastq validator image (fastq_utils:v0.1.0.rc) when requesting fastq validation jobs from the upload validation service

* Staging Manager v0.5.3
  - Remove 10s wait when creating upload area
Fix setting for retry policy, retrying for ~20min

* State-tracking v0.7.4
  - Addressed bug where a deleted state machine would be stored as null in the Redis database

* Ontology
  - Redeploying to pick up new ontology values


## 29 October 2018
* Core v0.7.7
  - Use indexing when finding files by UUID

## 23 October 2018

* State Tracker v0.7.3
  - Fixed bug determining the URI for persisted state machines
  - Fix to state tracking persistence
  - Ensuring envelopes go to the Cleanup state when more than the number of expected bundles are generated

* Exporter v0.7.5
  - Fix bug in analysis export, analysis bundles should reference same metadata file version from input bunlde
  - Reverted to 20 retries spaced a minute apart for operations on the DSS API
  - Using ingest's update timestamp for creating .json files in the DSS, averting needless duplicates
  - Polling DSS Files to confirm their full creation prior to creating a bundle containing said Files

* Broker v0.8.3
  - Fixed bug whereby file metadata updates fail if a file is uploaded prior spreadsheet upload
  - Fix to submission error message

* Core v0.7.6
  - Lazy load biomaterial dbrefs
  - Logging when submission envelope is created and submitted
  - Optimization in finding assay processes for export
  - Fix to slowdown cause by UUID generation
  - Bug fixes

* Staging Manager v0.5.2
  - Set to use HTTP HEAD when checking staging area


## 25 September 2018
* Core v0.7.3
  - Fix bug in sending messages to state tracker when adding reference files in a secondary submission
  - Reduce timeout when sending state tracking messages
  - Updated secondary submission documentation

* State Tracker v0.7.1
  - Reducing timeout before the actual submission state update happens
  - Concurrent hash map for document states

* Exporter v0.7.2
  - Use latest schema for links.json

* Broker v0.8.1
  - Added support for multiple ontology processing

## 18 September 2018

* Core v0.7.2
  - Optimizations regarding sending of unnecessary messages to the rabbit-mq broker
  - Integration with the state tracker’s HTTP API
  - Indexing on Process resources’ input and output biomaterials/files enabling faster bundle generation and export
  - Endpoint in monitoring state transitions of submission envelope
  - Added File indices in mongo for faster uploading of files metadata
  - Fixed bug when adding input bundle manifests for restructured bundles to processes
  - Added Submission Error entity and endpoints
  - State tracker optimizations
  - Core messaging optimizations
  - Added DRAFT transition controller methods for each metadata resource
  - Fixed schemas endpoint to correctly fetch latest schema
  - Addressed concurrency issues when sending messages in the core
  - Modified schema parser to use URI directly.
  - Set script to assemble package when running locally
  - Added SCHEMA_BASE_URI in docker compose script
  - Added triggersAnalysis flag in submission envelope
  - Replaced embedded web server to improve stability
  - Point schema url to s3 bucket url to get the xml file
  - Replaced embedded Tomcat server with Jetty
  - Set up to enable performance testing

* State Tracking v0.7.0
  - Race condition bug fix whereby state updates were processed out of order
  - Added a HTTP API for processing state update messages
  - Optimizations in sending state tracker messages
  - Fix to race condition when processing state tracker messages

* Exporter v0.7.1
  - Caching of previously retrieved documents for faster export time
  - Retrying 20 times with 1 minute between for idempotent requests to the DSS

* Accessioner v0.5.0
  - New Accessioner using Node.js

* Broker v0.8.0
  - Ability to upload supplementary files
  - Ability to Link entity to entity with same concrete type in the spreadsheet
  - Changes Submission report format
  - Configurable submission report
  - Error handling changes during spreadsheet upload
  - Support for additional project modules in spreadsheet
  - Handling schema /system links during spreadsheet upload
  - Upgraded dependencies for hca-ingest module
  - Fix bug in Schema template api to point to correct schema environment

* Validator v0.6.0
  - New JavaScript Validator
  - Support for Draft-07 JSON schema

* Staging Manager v0.5.1
  - Now waits for  for Ingest Core to come online before consuming messages

* Exporter v0.7.1
  - Using latest version of input data files in secondary bundle export
  - Bundles now contain supplementary files
  - Using latest version of links.json schema
  - Respecting the “triggerAnalysis” flag on envelopes to toggle triggering of analysis on primary submissions
  - Bundle restructure
  - Fixed bug when fetching documents from ingest-core
  - Remove hca dependency on the exporter listener and use the ingest-client version which uses hca v0.5

* UI v0.5.2
  - Fix submission dashboard pagination
