# Staging Changelog

## 28 September 2018

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