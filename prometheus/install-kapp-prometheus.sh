#!/bin/bash
tanzu package install prometheus \
	--package-name prometheus.tanzu.vmware.com \
	--namespace monitoring \
	--version 2.27.0+vmware.1-tkg.1 \
	--create-namespace

