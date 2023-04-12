#!/bin/bash
set -ex
${pre_bootstrap_user_data ~}

%{ if enable_bootstrap_user_data ~}
B64_CLUSTER_CA=${cluster_auth_base64}
API_SERVER_URL=${cluster_endpoint}
/etc/eks/bootstrap.sh ${cluster_name} ${bootstrap_extra_args} --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL
%{ endif ~}

${post_bootstrap_user_data ~}
