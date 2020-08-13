FROM centos:centos8

ARG http_proxy
ARG https_proxy

ENV PUPPET_VERSION="5.5.21" \
    PATH=$PATH:/opt/puppetlabs/puppet/bin

# Required for che
ADD https://raw.githubusercontent.com/disaster37/che-scripts/master/centos.sh /tmp/centos.sh
RUN sh /tmp/centos.sh
    
# Puppet
RUN \
    rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm &&\
    yum install -y pdk puppet-agent-${PUPPET_VERSION}

# Clean image
RUN \
    yum clean all &&\
    rm -rf /tmp/*

WORKDIR "/projects"

CMD ["sleep", "infinity"]
