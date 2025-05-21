# AMI Automation Pipeline

## 🔧 Overview of the Automation Pipeline

### **Objective**
Create a scalable, repeatable, and secure pipeline to build OS images (Windows, Linux, macOS) and deploy them in AWS using:

- **Packer** for AMI creation
- **Ansible** for provisioning/configuration
- **Terraform** for infrastructure deployment and lifecycle management

---

## 📦 Packer: Building AMIs

### **Folder Structure Example**
```
image-pipeline/
│
├── packer/
│   ├── windows-base.json
│   ├── linux-base.json
│   ├── macos-base.json
│   └── scripts/
│       ├── install-utils.ps1
│       └── hardening.sh
├── ansible/
│   ├── roles/
│   ├── playbooks/
│   │   └── provision.yml
├── terraform/
│   ├── main.tf
│   └── variables.tf
└── .github/workflows/packer-build.yml
```

### **Packer Template Key Concepts**
- Each OS has its own Packer template.

#### Example: `linux-base.json`
```json
{
  "builders": [
    {
      "type": "amazon-ebs",
      "region": "us-west-2",
      "source_ami_filter": {
        "filters": {
          "name": "ubuntu/images/*20.04*",
          "virtualization-type": "hvm",
          "root-device-type": "ebs"
        },
        "owners": ["099720109477"],
        "most_recent": true
      },
      "instance_type": "t3.micro",
      "ssh_username": "ubuntu",
      "ami_name": "linux-base-{{timestamp}}"
    }
  ],
  "provisioners": [
    {
      "type": "ansible",
      "playbook_file": "../ansible/playbooks/provision.yml"
    }
  ]
}
```

#### Example: Windows AMI
- Use **winrm** communicator instead of SSH
- PowerShell provisioning
- Chocolatey for package management
- Install updates + security settings

#### Example: macOS
- Requires VMware Fusion and macOS licensing compliance
- Packer `vmware-iso` builder for local image creation
- Images may be uploaded manually or via AWS EC2 Mac instances

---

## 🧰 Ansible: Configuration Management

### **`provision.yml` Example**
```yaml
- hosts: all
  become: yes
  roles:
    - common
    - security_hardening
    - cloudwatch_agent
```

#### Role Examples:
- **common**: Update system, install monitoring tools, disable unused services
- **security_hardening**: CIS benchmark compliance, disable password auth, configure firewall
- **cloudwatch_agent**: Configure AWS CloudWatch Logs

**Tips:**
- Use `ansible.builtin.assemble` to harden SSH configs
- Parameterize with `group_vars` per OS

---

## 🏗 Terraform: Deploy AMIs

After building AMIs, use Terraform to automate infrastructure provisioning.

#### Example Resource
```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.latest.id
  instance_type = "t3.medium"
  tags = {
    Name = "web-linux"
  }
}
```

#### Dynamic AMI Fetching
```hcl
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["linux-base-*"]
  }
}
```

---

## 🚀 CI/CD Automation with GitHub Actions

Automate the end-to-end pipeline:

### **`.github/workflows/packer-build.yml` Example**
```yaml
name: Packer AMI Build

on:
  push:
    paths:
      - "packer/**"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Install dependencies
        run: |
          sudo apt-get install -y packer ansible

      - name: Run Packer
        run: |
          packer init packer/linux-base.json
          packer validate packer/linux-base.json
          packer build packer/linux-base.json
```

**Best Practices:**
- Add approvals, versioning, and tagging to enforce SDLC.

---

## 🔒 Security and Best Practices

- Use **KMS encryption** for AMIs
- Enforce **IAM roles with least privilege**
- Enable **image scanning** (Amazon Inspector, etc.)
- **Log builds** for traceability and auditing
- **Tag AMIs** with `packer_run_uuid`, `os_version`, `app_name`

---

## ✅ Final Outcome

You achieve:

- Standardized golden images for Windows, Linux, and macOS
- Secure, tested, reproducible builds
- CI/CD integrated with governance
- Scalable and maintainable image pipeline for multiple teams

---

**Happy Automating!**
