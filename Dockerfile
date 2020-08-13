FROM centos:centos8

ARG http_proxy
ARG https_proxy

ENV PUPPET_VERSION="5.5.21" \
    PATH=$PATH:/opt/puppetlabs/puppet/bin

# Require for CHE
# Change permissions to let any arbitrary user
ENV HOME=/home/theia
RUN mkdir /projects ${HOME} && \
    for f in "${HOME}" "/etc/passwd" "/projects"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done
ADD etc/entrypoint.sh /entrypoint.sh
    
# Puppet
RUN \
    rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm &&\
    yum install -y pdk puppet-agent-${PUPPET_VERSION}

# Clean image
RUN \
    yum clean all &&\
    rm -rf /tmp/*

WORKDIR "/projects"

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ${PLUGIN_REMOTE_ENDPOINT_EXECUTABLE}
