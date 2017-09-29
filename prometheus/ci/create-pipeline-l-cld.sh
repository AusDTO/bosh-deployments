#!/bin/bash

set -e
set -x

fly --target l.cld.gov.au set-pipeline --config pipeline.yml --pipeline prometheus -n -l credentials-l.yml
fly --target l.cld.gov.au unpause-pipeline -p prometheus
