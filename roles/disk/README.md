# Disk Role

This role encrypts a secondary disk or a partition adjacent to the root partition using LUKS2.

## Features
- Detects the secondary disk and/or an adjacent root partition.
- Encrypts the target using LUKS2.
- Configures persistence via `/etc/crypttab` and `/etc/fstab`.
- Automatically mounts the encrypted partition.

## Usage

### 1. Add to Playbook

Include the Disk role in your Ansible playbook:

```yaml
- name: Encrypt Disk or Partition
  hosts: all
  become: true
  roles:
    - disk
```

### 2. Define Target in the host_vars

In `host_vars`, specify the disk or partition to encrypt:

```yaml
disk_to_encrypt: "/dev/sdb"
```

### 3. Run the Role

```sh
ansible-playbook -i inventory.yml bootstrap.yml -t disk
```

### 4. Verify Encryption

After execution, verify the encrypted disk:

```sh
lsblk  # Check encrypted partitions
cryptsetup status encrypted_target  # Check LUKS status
cat /etc/crypttab  # Ensure persistence
```

## Logs & Debugging

Enable verbose mode for debugging:

```sh
ansible-playbook -i inventory.yml bootstrap.yml -t disk -vv
```

If errors occur, check logs:

```sh
journalctl -xe
```
