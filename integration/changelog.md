# Integration Changelog

## 11 July 2018

* Core
  - UUID index for Submission Envelope collection in Ingest database

* Broker
  - Fix for phantom entries in Spreadsheets during import

## 4 July 2018

* Core
  - Data File UUID
  - Find Process by input Bundle UUID
  - Idempotent Analysis File reference

* Broker
  - Process details support

## 27 June 2018

* ingest-ui
  - Display of UUIDs
  - User must be redirected to login page when session expires
  - Fix to disappearing loading icon when doing a submission upload
  - Fix default active tab on submission upload

* ingest-core
  - Files metadata are being created upon upload
  - New file resource endpoint with file name
  - Additional findByUuid endpoints
  - New findBySubmissionEnvelopesContaining and findBySubmissionAndValidationState endpoints for each metadata entity
  - Fix to optimistic lock error on adding input bundle using ResourceLinker service

* ingest-broker
  - new api endpoints for getting the project and submission summary
  - piecemeal submissions and ability to use UUID references in spreadsheet

* ingest-validator
  - Fix to have user friendly validation error message when a schema url doesn't exist

* ingest-accessioner
  - no change

* ingest-archiver
  - no change

* ingest-exporter
  - no change

* ingest-state-tracking
  - no change

* ingest-staging-manager
  - no change
