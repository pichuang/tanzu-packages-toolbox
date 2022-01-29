#!/bin/bash
kubectl label node tanzu-worker node-role.kubernetes.io/infra=""
kubectl label node tanzu-worker2 node-role.kubernetes.io/worker=""
