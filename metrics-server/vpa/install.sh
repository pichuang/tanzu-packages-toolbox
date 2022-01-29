#!/bin/bash
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler
git checkout vertical-pod-autoscaler-0.10.0
./hack/vpa-up.sh


