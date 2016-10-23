FROM centos:7

MAINTAINER Alexey Bannov <alexy.bannov@gmail.com>

ENV container docker

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in ; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -fR /lib/systemd/system/multi-user.target.wants/;\
rm -f /etc/systemd/system/.wants/;\
rm -f /lib/systemd/system/local-fs.

RUN yum -y install yum-utils wget epel-release;

RUN yum -y install nano htop; \
    yum -y install httpd; \
    systemctl start httpd; \
    systemctl enable httpd; \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm; \
    yum -y install php70w php-mysqli; \
    wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm; \
    yum localinstall -y mysql57-community-release-el7-7.noarch.rpm; \
    yum -y install mysql-community-server;


VOLUME ["/sys/fs/cgroup"]
VOLUME ["/var/lib/mysql"]

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/init"]

