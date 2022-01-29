#!/bin/bash

# After you make any changes needed to your grafana-data-values.yaml file, remove all comments in it:
yq -i eval '... comments=""' grafana-data-values.yaml
