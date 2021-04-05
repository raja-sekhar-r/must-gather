# Copyright (c) 2021 Red Hat, Inc.
# Copyright Contributors to the Open Cluster Management project

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

ARG URL
RUN microdnf update -y \
    && microdnf install -y tar rsync findutils gzip iproute util-linux \
    && microdnf clean all

RUN set -ex; \
    if [ "$(uname -m)" = "s390x" ]; then URL="https://mirror.openshift.com/pub/openshift-v4/s390x/clients/ocp/latest/openshift-client-linux.tar.gz"; \
    elif [ "$(uname -m)" = "x86_64" ];  then URL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz"; \
    elif [ "$(uname -m)" = "ppc64le" ];  then URL="https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/latest/openshift-client-linux.tar.gz"; \
    fi \

# download oc binary
RUN cd /usr/bin && curl -sL $(URL) | tar -zx

# copy all collection scripts to /usr/bin
COPY collection-scripts/* /usr/bin/

ENTRYPOINT /usr/bin/gather
