#!/bin/bash
kind create cluster --config kind-config.yaml -v 9
#kind get nodes --name tanzu | xargs ./kind-fix-networking.sh

sleep 30
kubectl get nodes --show-labels
