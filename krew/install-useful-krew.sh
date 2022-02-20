#!/bin/bash
kubectl krew update
kubectl krew upgrade
kubectl krew install ns
kubectl krew install ctx
kubectl krew install get-all
kubectl krew install images
kubectl krew install whoami
kubectl krew install rbac-lookup
kubectl krew install grep
kubectl krew install iexec
kubectl krew install tree
kubectl krew install view-utilization
kubectl krew install tail
kubectl krew install access-matrix
kubectl krew install doctor
kubectl krew install resource-capacity
kubectl krew install df-pv
kubectl krew install view-secret
kubectl krew install neat
kubectl krew index add kvaps https://github.com/kvaps/krew-index
kubectl krew install kvaps/node-shell
kubectl krew install pod-lens
