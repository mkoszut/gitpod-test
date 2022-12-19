#!/bin/bash

error_message_command_not_found () {
    echo -e "\x1B[31m $1 not found";
    echo -e "\x1B[33m Please install $1 before you continue";
    exit 1
}

if ! [ -x "$(command -v kind)" ]; then
    error_message_command_not_found "kind"
fi

if ! [ -x "$(command -v kubectl)" ]; then
    error_message_command_not_found "kubectl"
fi

if ! [ -x "$(command -v helm)" ]; then
    error_message_command_not_found "helm"
fi

KIND_IMAGE="kindest/node:v1.23.6"
KUBECONFIG_PATH=./.tmp/kube.config
kind create cluster --image $KIND_IMAGE --name vsf-live-coding --kubeconfig $KUBECONFIG_PATH
kubectl --kubeconfig $KUBECONFIG_PATH cluster-info --context kind-vsf-live-coding

helm install --kubeconfig $KUBECONFIG_PATH --generate-name --create-namespace --namespace client-vuestorefrontcloud-io chart/vsf-live-coding
