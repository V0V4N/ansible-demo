# Network Role

This role renames the active network interface by assigning an alternative name (`net0`).

## Features
- Detects the primary active network interface.
- Sets an alternative name (`net0`) to the interface.
- Ensures persistence using `udev` rules.

## Usage

### 1. Add to Playbook

Include the Network role in your Ansible playbook:

```yaml
- name: Rename Network Interface
  hosts: all
  become: true
  roles:
    - network
```

### 2. Run the Role

```sh
ansible-playbook -i inventory.yml bootstrap.yml -t network
```

### 3. Verify Interface Renaming

After execution, check if `net0` was assigned:

```sh
ip link show  # List network interfaces
udevadm test /sys/class/net/$(ip route show default | awk '{print $5}')  # Test udev rule
```

## Logs & Debugging

Enable verbose mode for debugging:

```sh
ansible-playbook -i inventory.yml bootstrap.yml -t network -vv
```

If errors occur, check logs:

```sh
journalctl -xe  # Check system logs
udevadm control --reload-rules && udevadm trigger  # Reload udev rules
```
