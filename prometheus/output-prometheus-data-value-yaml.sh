#!/bin/bash

# After you make any changes needed to your prometheus-data-values.yaml file, remove all comments in it:
yq -i eval '... comments=""' prometheus-data-values.yaml
