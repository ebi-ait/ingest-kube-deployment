# Production Changelog

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
