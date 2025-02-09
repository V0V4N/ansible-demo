# ansible-demo

This repository contains an Ansible-based automation project that configures a server with the following roles:

- **CPU**: Configures CPU power settings, including frequency governors and C-states.
- **Disk**: Encrypts a secondary disk and/or a partition adjacent to the root partition.
- **Network**: Renames the primary network interface using an alternative name (`net0`).

## Requirements

- **Python 3.10+** (3.13 recommended as it was used in the initial development process)
- virtual env usage is strongly encouraged
- pip packages outlined in requirements.txt
- `ansible.posix` collection from ansible-galaxy
- SSH access to target host with privilege escalation capabilities (root access)

You can also opt in to run the project inside a Docker container, see Dockerfile and docker-compose.yml files for reference.

## Directory tree

The project currently uses the following directory structure. You can use it as a reference when navigating its contents:

```
├── bootstrap.yml
├── inventory.yml
├── host_vars/
│   ├── localhost.yml
│   ├── remote_host.yml
├── roles/
│   ├── cpu/
│   │   ├── tasks/
│   │   ├── handlers/
│   │   ├── README.md
│   ├── disk/
│   │   ├── tasks/
│   │   ├── README.md
│   ├── network/
│   │   ├── tasks/
│   │   ├── handlers/
│   │   ├── README.md
├── README.md
```

## Usage scenarios

### 1. Run directly from a user device (non-Docker), execution target - remote host

#### 1. Prepare the execution environment

```sh
git clone https://github.com/V0V4N/ansible-demo.git
cd ansible-demo
python3 -m venv venv
source venv/bin/activate
ansible-galaxy collection install ansible.posix
```

Then, you should place your SSH RSA private key into `.ssh` directory of this project and run `chmod 400 .ssh/id_rsa`. Don't worry, this file is ignored by git, hence you're not going to accidentally commit it into repo.

After that, you should edit `host_vars/remote_host.yml`, replacing the placeholders with relevant contents, for example:

```yaml
ansible_host: 192.168.228.228
ansible_user: ubuntu
disk_to_encrypt: "/dev/sdb"
```

Lastly, if you want to run disk encryption, you should set the desired password for LUKS as an environment variable. One way of the ways to do that could be:

```sh
export LUKS_PASSWORD="MyDemoPassword1337"
```

#### 2. Run the Playbook
Execute the bootstrap playbook:

```sh
ansible-playbook --private-key=.ssh/id_rsa -i inventory.yml -l remote_host bootstrap.yml
```

#### 3. Run Specific Roles
To run only a specific role:

```sh
ansible-playbook --private-key=.ssh/id_rsa -i inventory.yml -l remote_host bootstrap.yml -t cpu  # Run CPU configuration
ansible-playbook --private-key=.ssh/id_rsa -i inventory.yml -l remote_host bootstrap.yml -t disk  # Run Disk encryption
ansible-playbook --private-key=.ssh/id_rsa -i inventory.yml -l remote_host bootstrap.yml -t network  # Run Network renaming
```

### 2. Run from a Docker container on a user device, execution target - remote host

#### 1. Prepare the execution environment

Given that Docker and Docker-compose are already installed (on newer versions, compose is part of docker by default):

```sh
git clone https://github.com/V0V4N/ansible-demo.git
cd ansible-demo
```

Then, you should place your SSH RSA private key into `.ssh` directory of this project and run `chmod 400 .ssh/id_rsa`. Don't worry, this file is ignored by git, hence you're not going to accidentally commit it into repo.

After that, you should edit `host_vars/remote_host.yml`, replacing the placeholders with relevant contents, for example:

```yaml
ansible_host: 192.168.228.228
ansible_user: ubuntu
disk_to_encrypt: "/dev/sdb"
```

Lastly, if you want to run disk encryption, you should set the desired password for LUKS as an environment variable. One way of the ways to do that could be:

```sh
export LUKS_PASSWORD="MyDemoPassword1337"
```

**Note:** this environment variable is passed to the docker container. You can either set it up before running the container itself, or you can opt in for a more safer option of setting it inside the container.

In order to run the container, use

```sh
docker compose run --rm --build ansible # newer docker versions
docker-compose run --rm --build ansible # older versions, separate docker-compose package
```

#### 2. Run the Playbook
Execute the bootstrap playbook:

```sh
ansible-playbook -i inventory.yml -l remote_host bootstrap.yml
```

#### 3. Run Specific Roles
To run only a specific role:

```sh
ansible-playbook -i inventory.yml -l remote_host bootstrap.yml -t cpu  # Run CPU configuration
ansible-playbook -i inventory.yml -l remote_host bootstrap.yml -t disk  # Run Disk encryption
ansible-playbook -i inventory.yml -l remote_host bootstrap.yml -t network  # Run Network renaming
```

### 3. Run from a remote host, execution target - the server itself

#### 1. Prepare the execution environment

```sh
git clone https://github.com/V0V4N/ansible-demo.git
cd ansible-demo
python3 -m venv venv
source venv/bin/activate
ansible-galaxy collection install ansible.posix
```

After that, you should edit `host_vars/localhost.yml`, replacing the placeholder with relevant contents, for example:

```
disk_to_encrypt: "/dev/sdb"
```

Lastly, if you want to run disk encryption, you should set the desired password for LUKS as an environment variable. One way of the ways to do that could be:

```sh
export LUKS_PASSWORD="MyDemoPassword1337"
```

#### 2. Run the Playbook
Execute the bootstrap playbook:

```sh
ansible-playbook -i inventory.yml -l localhost bootstrap.yml
```

#### 3. Run Specific Roles
To run only a specific role:

```sh
ansible-playbook -i inventory.yml -l localhost bootstrap.yml -t cpu  # Run CPU configuration
ansible-playbook -i inventory.yml -l localhost bootstrap.yml -t disk  # Run Disk encryption
ansible-playbook -i inventory.yml -l localhost bootstrap.yml -t network  # Run Network renaming
```

### Evaluation of execution results

If you want to check the results of execution, you can refer to the execution logs - they're already quite verbose.

However to double check, you can always refer to checking the host system itself. For example:

```sh
cat /sys/devices/system/cpu/cpu0/cpuidle/state0/disable # to check the state of C-states
cpufreq-info -p # to check CPU governor
cryptsetup isLuks <target partition> # to check if partition is encrypted
ip link show net0 # to check if network interface is available under a new name
```
