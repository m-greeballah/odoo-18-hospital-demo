# 🏥 Odoo 18 — Hospital Module CI/CD Demo

A demo project showing a complete **CI/CD pipeline** using **GitHub Actions** to build and publish a customized **Odoo 18** Docker image with a simple Hospital Management module.

---

## 📁 Project Structure

```
odoo-cicd-demo/
├── .github/
│   └── workflows/
│       └── ci-cd.yml            # GitHub Actions CI/CD pipeline
├── hospital_module/             # Custom Odoo 18 module
│   ├── __manifest__.py
│   ├── __init__.py
│   ├── models/
│   │   ├── __init__.py
│   │   ├── patient.py
│   │   ├── doctor.py
│   │   └── appointment.py
│   ├── views/
│   │   ├── patient_views.xml
│   │   ├── doctor_views.xml
│   │   ├── appointment_views.xml
│   │   └── menu_views.xml
│   ├── security/
│   │   └── ir.model.access.csv
│   └── data/
│       └── demo_data.xml
├── docker/
│   └── odoo.conf                # Odoo configuration
├── Dockerfile                   # Custom Odoo 18 image
├── docker-compose.yml           # Local development stack
└── README.md
```

---

## 🚀 CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci-cd.yml`) runs on every push/PR with 4 jobs:

```
[Push to GitHub]
      │
      ▼
┌─────────────┐
│  1. Lint    │  flake8 + XML validation + manifest check
└──────┬──────┘
       │ pass
       ▼
┌──────────────────┐
│  2. Build & Test │  docker buildx + smoke tests inside container
└──────┬───────────┘
       │ pass
       ▼
┌──────────────┐
│  3. Publish  │  push to ghcr.io (main branch only)
└──────┬───────┘
       │
       ▼
┌──────────────────┐
│  4. Deploy       │  SSH deploy to staging (optional)
│     Staging      │
└──────────────────┘
```

### Image Tags Published
| Event | Tags |
|-------|------|
| Push to `main` | `latest`, `main`, `sha-<commit>` |
| Push to `develop` | `develop`, `sha-<commit>` |
| Git tag `v1.2.3` | `1.2.3`, `1.2`, `1` |

---

## 🏥 Hospital Module Features

| Feature | Description |
|---------|-------------|
| **Patient Registration** | Full patient profile with auto-reference (PAT00001) |
| **Doctor Management** | Doctor profiles with specializations and availability |
| **Appointments** | Full lifecycle: Draft → Confirmed → In Progress → Done |
| **Calendar View** | Visual calendar of appointments by doctor |
| **Chatter** | Audit trail & messaging on all records |
| **Priority** | Star-based priority on appointments |

### Models
- `hospital.patient` — Patient records
- `hospital.doctor` — Doctor profiles  
- `hospital.appointment` — Appointment scheduling

---

## 🛠️ Local Development

### Prerequisites
- Docker & Docker Compose

### Start the Stack

```bash
# Clone the repo
git clone https://github.com/your-org/odoo-cicd-demo.git
cd odoo-cicd-demo

# Start Odoo + PostgreSQL
docker compose up -d

# Watch logs
docker compose logs -f odoo
```

### Access Odoo
- URL: http://localhost:8069
- Create a new database from the database manager
- Install the **Hospital Management** module from Apps

### Rebuild after Changes

```bash
docker compose build odoo
docker compose up -d odoo
```

---

## 📦 Use the Published Image

```bash
# Pull the latest image
docker pull ghcr.io/your-org/odoo-cicd-demo:latest

# Run with an existing PostgreSQL
docker run -d \
  -p 8069:8069 \
  -e HOST=your_db_host \
  -e USER=odoo \
  -e PASSWORD=odoo \
  ghcr.io/your-org/odoo-cicd-demo:latest
```

---

## ⚙️ GitHub Setup

### 1. Enable GitHub Container Registry
The workflow uses `GITHUB_TOKEN` automatically — no extra secrets needed for publishing.

### 2. Enable staging deploy (optional)
Add these secrets in **Settings → Secrets → Actions**:

| Secret | Description |
|--------|-------------|
| `SSH_HOST` | Staging server IP or hostname |
| `SSH_USER` | SSH username |
| `SSH_PRIVATE_KEY` | Private key for SSH access |

### 3. Set branch protection
Protect `main` to require the CI pipeline to pass before merging.

---

## 🔧 Extending the Module

To add a new model, follow this pattern:

1. Create `hospital_module/models/your_model.py`
2. Import it in `hospital_module/models/__init__.py`
3. Add views in `hospital_module/views/your_model_views.xml`
4. Add access rules to `security/ir.model.access.csv`
5. Register the view file in `__manifest__.py` under `data`

---

## 📄 License

LGPL-3
