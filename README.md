# odoo-cicd-demo  (App Repo)

Odoo 18 custom Docker image with a Hospital Management module.

> **This repo is owned by developers.**
> GitOps config (ArgoCD apps, environment values) lives in `odoo-gitops`.

---

## Repos

| Repo | Owned by | Contains |
|---|---|---|
| **odoo-cicd-demo** (this) | Developers | App code, Dockerfile, Helm chart |
| **odoo-gitops** | DevOps | ArgoCD apps, environment values |

---

## Structure

```
odoo-cicd-demo/
├── hospital_module/        # Custom Odoo 18 addon
│   ├── models/             # patient, doctor, appointment
│   ├── views/              # list / form / calendar
│   └── security/
├── helm/odoo-hospital/     # Helm chart (templates + default values)
│   ├── Chart.yaml
│   ├── values.yaml         # Defaults only — env values live in odoo-gitops
│   └── templates/
├── docker/
│   ├── odoo.conf
│   └── entrypoint.sh
├── Dockerfile
└── docker-compose.yml      # Local dev without Kubernetes
```

---

## CI/CD Pipeline

```
Push to develop
    └─► lint → build → push sha-xxxxxxx → open PR on odoo-gitops (test)

Push to main
    └─► lint → build → push sha-xxxxxxx + latest → open PR on odoo-gitops (staging)

git tag v1.0.0
    └─► lint → build → push v1.0.0 → open PR on odoo-gitops (production)
```

Each PR updates the `tag:` field in the relevant `environments/values-*.yaml`
in the `odoo-gitops` repo. ArgoCD picks up the change after the PR is merged.

---

## GitHub Secrets required

| Secret | Value |
|---|---|
| `GITOPS_TOKEN` | GitHub PAT with `repo` scope on `odoo-gitops` |
| `ARGOCD_AUTH_TOKEN` | From bootstrap script output |
| `ARGOCD_SERVER_URL` | `http://localhost:8080` or your ArgoCD URL |

---

## Local dev (Docker Compose — no K8s)

```bash
cp .env.example .env
# Edit .env with your passwords
docker compose up -d --build
# Open http://localhost:8069
```

## Helm chart dev

```bash
# Dry-run render
helm template odoo-hospital helm/odoo-hospital/ \
  --set secrets.postgresPassword=dummy \
  --set secrets.odooMasterPassword=dummy

# Lint
helm lint helm/odoo-hospital/
```

---

## License
LGPL-3
