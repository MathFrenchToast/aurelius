# use an ubuntu VM on ubuntu
Setting up an Ubuntu VM on an Ubuntu KVM host for sandboxing. It provides strong isolation for N8n and the  AI agents while maintaining near-native performance.

---

## 1. Prepare the Host Environment
Ensure your host has virtualization extensions enabled and the necessary tools installed.

```bash
# Install KVM and management tools
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-viewer

# Enable and start the libvirt service
sudo systemctl enable --now libvirtd

# Add your user to the libvirt group (requires logout/login to take effect)
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```

Logout/login for the new group to be applied, or run `newgrp libvirt` to apply it to your current shell immediately.
---

## 2. Download the Cloud Image
Instead of a bulky ISO, use the **Ubuntu Cloud Image**. These are optimized, minimal, and designed for automated deployments.

```bash
# Download the latest Ubuntu 24.04 LTS Cloud Image to the standard libvirt directory
sudo wget -P /var/lib/libvirt/images/ https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```

---

## 3. Create the Cloud-Init Configuration
Cloud-Init allows you to inject your SSH keys and user data so the VM is ready for your AI agent immediately.

Create a file named `ci-n8nai.yaml`:
```yaml
#cloud-config
users:
  - name: sandbox-admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3Nza... # Replace with your public key (~/.ssh/id_rsa.pub)

package_update: true
packages:
  - git
  - curl
  - build-essential

runcmd:
  # 1. Install Node.js (needed for n8n and gemini-cli)
  - curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  - apt-get install -y nodejs

  # 2. Install Gemini CLI globally
  - npm install -g @google/gemini-cli

  # 3. Install uv (Safe Python management - no system python conflicts)
  - curl -LsSf https://astral.sh/uv/install.sh | sh
  - mv /root/.local/bin/uv /usr/local/bin/uv

  # 4. Install n8n (pinned version for security and stability)
  - npm install -g n8n

  # 5. Install gh
  - apt-get install -y gh

  # 6. Optional: Create a systemd service for n8n to start on boot
  - |
    cat <<EOF > /etc/systemd/system/n8n.service
    [Unit]
    Description=n8n
    After=network.target

    [Service]
    Type=simple
    User=sandbox-admin
    # Ensure all n8n commands run in a safe workspace by default
    WorkingDirectory=/home/sandbox-admin/workspace
    Environment=N8N_PORT=5678
    Environment=N8N_SECURE_COOKIE=false
    Environment=N8N_BLOCK_NODES=[]
    ExecStart=/usr/local/bin/n8n
    Restart=always

    [Install]
    WantedBy=multi-user.target
    EOF
  # Create the workspace folder
  - mkdir -p /home/sandbox-admin/workspace
  - chown sandbox-admin:sandbox-admin /home/sandbox-admin/workspace
  - systemctl daemon-reload
  - systemctl enable n8n
  - systemctl start n8n
```

---

## 4. Launch the Virtual Machine
Use the following command to provision the VM. This script creates a 20GB disk based on the cloud image and applies your configuration.

```bash
# Refresh group membership if you haven't logged out
newgrp libvirt

# Create a copy of the image for this specific VM in the system pool
sudo cp /var/lib/libvirt/images/noble-server-cloudimg-amd64.img /var/lib/libvirt/images/sandbox-vm.qcow2
sudo qemu-img resize /var/lib/libvirt/images/sandbox-vm.qcow2 20G

# Launch the VM
virt-install \
  --name n8n-sandbox \
  --memory 4096 \
  --vcpus 2 \
  --os-variant ubuntu24.04 \
  --disk path=/var/lib/libvirt/images/sandbox-vm.qcow2,format=qcow2 \
  --import \
  --network network=default \
  --graphics none \
  --noautoconsole \
  --cloud-init user-data=ci-n8nai.yaml
```

---

## 5. Post-Installation & Access
Once the VM is provisioned, follow these steps to access your environment.

### Get the VM IP Address
Use `virsh` to find the IP assigned by the KVM bridge:
```bash
virsh domifaddr n8n-sandbox
# single line version
VM_IP=$(virsh domifaddr n8n-sandbox | awk '/ipv4/ {print $4}' | cut -d/ -f1)
```


### Access n8n UI
1. **Direct Access:** Open `http://<VM-IP>:5678` in your browser.
2. **SSH Tunneling (if remote):** If you cannot reach the VM IP directly:
   ```bash
   ssh -L 5678:localhost:5678 sandbox-admin@<VM-IP>
   ```
   Then open `http://localhost:5678` locally.

### Check Installation Progress
Cloud-init runs in the background. If n8n is not yet available, check the progress inside the VM:
```bash
# Inside the VM
tail -f /var/log/cloud-init-output.log
```

### connect inside the VM

ssh -i ~/.ssh/<your key>> sandbox-admin@<the vm ip>>

Start gemini for the first time and set up the auth
Connect to github, using: gh auth login

You can now go to: http://<ip>>:5678

---

## 6. Management & Persistence
KVM stores all VM data in the `/var/lib/libvirt/images/sandbox-vm.qcow2` file. You can stop the VM to save host resources without losing your n8n workflows or configurations.

### Stop the VM
Gracefully shut down the guest OS:
```bash
virsh shutdown n8n-sandbox
```

### Start the VM
Power it back on:
```bash
virsh start n8n-sandbox
```

### Check Status
See if the VM is running and get its ID:
```bash
virsh list --all
```

---

## 7. Best Practices for n8n + Gemini
To avoid permission errors and allow the AI to perform tasks, follow these guidelines:

### Use a Dedicated Workspace
Always run commands in a specific folder, never the root.
1. Create a workspace: `mkdir -p /home/sandbox-admin/workspace`.
2. In n8n "Execute Command", click **Add Option** > **Working Directory** and set it to `/home/sandbox-admin/workspace`.
   * *Pro-tip:* You can also just prefix your command: `cd /home/sandbox-admin/workspace && gemini ...`

### Enable "YOLO" Mode for Tools
If you want the AI to use tools (search the web, read files, run scripts), add the `--yolo` flag:
```bash
gemini --yolo --prompt "Your request here"
```
Without `--yolo`, the agent will fail when it tries to use its internal tools (like `run_shell_command`).

### Suppress Indexing Noise
The first time you run Gemini in a folder, it will index it. If you see "Skipping unreadable directory" warnings, ensure your **Working Directory** is set correctly to a folder you own.

---

## 8. Why this "Native" setup is best for Sandboxing:
* **Isolation:** The VM itself is the wall. You don't need Docker's overhead.
* **Python Safety:** By using `uv` instead of `apt install python3-pip`, you avoid breaking the Ubuntu system packages. `uv` will manage isolated venvs for any Python tasks the AI agent needs.
* **Direct Access:** Your scripts can call `gemini` or `git` directly without `docker exec` wrappers.
* **Persistence:** n8n data is stored in `/home/sandbox-admin/.n8n` inside the VM.
