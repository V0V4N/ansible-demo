FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    openssh-client sshpass \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir ansible-core==2.16.2 ansible-lint && ansible-galaxy collection install ansible.posix

COPY ansible.cfg /etc/ansible/ansible.cfg

WORKDIR /etc/ansible

CMD ["/bin/bash"]
