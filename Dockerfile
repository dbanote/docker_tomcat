FROM centos
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.37
ENV CATALINA_HOME /usr/local/tomcat
ENV JDK_VERSION 8u191
ENV PATH $CATALINA_HOME/bin:$PATH

ADD CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD run.sh /

RUN yum makecache && \
    yum install openssl openssh-server wget -y && \
    wget -P /tmp --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "https://download.oracle.com/otn-pub/java/jdk/$JDK_VERSION-b12/2787e4a523244c269598db4e85c51e0c/jdk-$JDK_VERSION-linux-x64.rpm" && \
    yum localinstall --nogpgcheck /tmp/jdk-$JDK_VERSION-linux-x64.rpm -y && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N "" && \
    curl -o /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz http://mirror.bit.edu.cn/apache/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    tar xpf /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz -C /usr/local/ && \
    mv /usr/local/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME && \
    echo "export LANG=en_US.utf8" >> /etc/profile && \
    rm -rf /tmp/* && yum clean all

WORKDIR $CATALINA_HOME
CMD ["/run.sh"]
