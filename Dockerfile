FROM williamyeh/ansible:ubuntu16.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y apt-utils \
    && apt-get install -y sudo unzip vim git curl wget net-tools openssh-server \
    && mkdir /workspace \
    && mkdir -p /var/run/sshd \
    && useradd -d /home/ansible -m -s /bin/bash ansible \
    && useradd -G ansible bidule \
    && echo "ansible:ansible" | chpasswd \
    && if [ ! -d "/etc/sudoers.d"]; then mkdir /etc/sudoers.d; fi \
    && echo "ansible    ALL=(ALL)   NOPASSWD: ALL" > /etc/sudoers.d/ansible \
    && su -c "mkdir -p /home/ansible/.ssh" ansible \
    && su -c "ssh-keygen -t rsa -N '' -f /home/ansible/.ssh/id_rsa" ansible \
    && su -c "mkdir /home/ansible/workspace" ansible \
    && service ssh start \
    && service ssh status \
    && service ssh stop

ADD ./files/ansible.cfg /home/ansible/ansible.cfg

# change default ansible configuraiton file which is currently root's ownership
RUN chown ansible:ansible /home/ansible/ansible.cfg

CMD ["sudo", "/usr/sbin/sshd", "-D"]

EXPOSE 22

USER ansible
WORKDIR /home/ansible/workspace
