# CPU Role

This role configures CPU power settings, including CPU frequency governors and C-states.

## Features
- Ensures the required CPU frequency package is installed.
- Sets the CPU governor to performance mode.
- Disables CPU C-states to reduce latency.
- Ensures settings persist after reboot via GRUB configuration.

## Usage

### 1. Add to Playbook

Include the CPU role in your Ansible playbook:

```yaml
- name: Configure CPU Settings
  hosts: all
  become: true
  roles:
    - cpu
```

### 2. Run the Role

```sh
ansible-playbook -i inventory.yml bootstrap.yml -t cpu
```

### 3. Verify Configuration

After execution, check the applied settings:

```sh
cpufreq-info  # Verify CPU governor
cat /sys/devices/system/cpu/cpu*/cpuidle/state*/disable  # Check C-state status
grep "GRUB_CMDLINE_LINUX" /etc/default/grub  # Check GRUB persistence
```

## Logs & Debugging

Enable verbose mode for debugging:

```sh
ansible-playbook -i inventory.yml bootstrap.yml -t cpu -vv
```

If errors occur, check system logs:

```sh
journalctl -xe
```
