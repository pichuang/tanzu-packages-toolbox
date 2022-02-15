#!/bin/bash

tanzu package installed delete contour -n tanzu-package-repo-global
kubectl delete secret contour-tanzu-package-repo-global-values -n tanzu-package-repo-global
kubectl delete sa contour-tanzu-package-repo-global-sa -n tanzu-package-repo-global
