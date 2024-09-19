# CC-Ansible-Workbook

# How to Set Up and Run an Ansible Playbook for Podman and Nginx

This guide will help you:

1. Save the Ansible playbook to install Podman and run an Nginx container.
2. Install and configure Ansible on your machine.
3. Run the playbook to automate the installation and deployment process.

---

## 1. Saving the Ansible Playbook

To save the playbook, follow these steps:

1. Open your terminal.
2. Navigate to the directory where you want to store the playbook.
3. Create a new file and open it with a text editor. For example, using `nano`:

    ```bash
    nano install_nginx_podman.yml
    ```

4. Copy and paste the following playbook into the file:

    ```yaml
    ---
    - name: Install Podman and deploy Nginx container
      hosts: all
      become: true  # Run the tasks with elevated privileges
      tasks:
        - name: Update the apt package manager cache
          apt:
            update_cache: yes

        - name: Install Podman
          apt:
            name: podman
            state: present

        - name: Pull the Nginx container image
          command: podman pull nginx
          register: nginx_image

        - name: Run the Nginx container
          command: podman run -d --name nginx_container -p 80:80 nginx
          when: nginx_image.changed

        - name: Ensure the Nginx container is running
          command: podman ps -q --filter "name=nginx_container"
          register: nginx_container_running

        - name: Restart Nginx container if not running
          command: podman restart nginx_container
          when: nginx_container_running.stdout == ""

        - name: Print success message
          debug:
            msg: "Podman and Nginx are successfully set up and running."
    ```

5. Save the file by pressing `Ctrl+O`, then press `Enter`.
6. Exit the editor with `Ctrl+X`.

---

## 2. Installing Ansible on Ubuntu

You need to install Ansible on your machine before running the playbook.

### Installation Steps:

1. Update your system’s package manager:

    ```bash
    sudo apt update
    ```

2. Install Ansible:

    ```bash
    sudo apt install ansible -y
    ```

3. Verify the installation:

    ```bash
    ansible --version
    ```

You should see the version information for Ansible if the installation was successful.

---

## 3. Configuring Ansible Inventory

An Ansible inventory file defines which machine(s) the playbook will target.

### For Localhost (If running the playbook on the same machine):

1. Create an inventory file:

    ```bash
    nano inventory.ini
    ```

2. Add the following content to target the local machine:

    ```ini
    localhost ansible_connection=local
    ```

### For Remote VM:

1. Create the same `inventory.ini` file:

    ```bash
    nano inventory.ini
    ```

2. Add the following content, replacing placeholders with your VM details:

    ```ini
    [nginx_vm]
    <your-remote-vm-ip> ansible_user=<your-username> ansible_ssh_private_key_file=<path-to-your-private-key>
    ```

This specifies that the remote machine should be accessed over SSH using a private key.

---

## 4. Running the Playbook

Once you have your playbook and inventory file, you can execute the playbook with the following command:

```bash
ansible-playbook -i inventory.ini install_nginx_podman.yml
```

### Explanation:

- `-i inventory.ini`: Specifies the inventory file.
- `install_nginx_podman.yml`: The playbook file to execute.

If everything is set up correctly, Ansible will install Podman, pull the Nginx container image, and run the Nginx container on the machine.

---

## Notes

- Make sure SSH access is properly configured if you're provisioning a remote VM.
- Ansible will prompt for your password if you haven't set up passwordless sudo or SSH keys.
- You can customize the playbook to add more tasks or adjust configurations as per your requirements.

---

### Troubleshooting:

- **Podman not installed correctly**: Ensure that your Ubuntu system’s package repositories are updated.
- **Playbook fails**: Check for any syntax errors in the YAML file. Ansible provides detailed error messages to help troubleshoot.
  
---

By following these steps, you should be able to automate the installation of Podman and deployment of an Nginx container using Ansible.
