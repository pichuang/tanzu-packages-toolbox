#!/bin/bash
tanzu package install contour \
	--package-name contour.tanzu.vmware.com \
	--namespace core-kapp \
	--version 1.17.2+vmware.1-tkg.2 \
    --values-file contour-data-values.yaml \
	--create-namespace

