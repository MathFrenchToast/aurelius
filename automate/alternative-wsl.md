# Usage de WSL avec Cloud-Init (Windows)
Pour les utilisateurs Windows, il est possible de créer un environnement de développement isolé et automatisé en utilisant WSL 2 avec le support natif de **cloud-init** (disponible depuis Ubuntu 24.04).

Cette méthode permet de cloner une instance Ubuntu "propre" et de l'auto-configurer au premier lancement, tout comme une VM cloud.

---

## 1. Préparer l'environnement Windows
Assurez-vous d'avoir WSL 2 installé et à jour.

```powershell
# Mettre à jour WSL
wsl --update

# Définir WSL 2 par défaut
wsl --set-default-version 2
```

---

## 2. Télécharger l'image Rootfs (Ubuntu 24.04)
Au lieu d'utiliser le Microsoft Store, nous allons télécharger l'image officielle optimisée pour WSL.

```powershell
# Créer un dossier pour stocker vos images WSL (ex: C:\WSL)
mkdir C:\WSL

# Télécharger le rootfs Ubuntu 24.04 LTS (Noble Numbat)
Invoke-WebRequest -Uri "https://cloud-images.ubuntu.com/wsl/noble/current/ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz" -OutFile "C:\WSL\ubuntu-24.04-wsl.tar.gz"
```

---

## 3. Configurer Cloud-Init sur Windows
WSL cherche la configuration `cloud-init` dans votre profil utilisateur Windows.

1.  Créez le dossier de configuration :
    ```powershell
    mkdir "$env:USERPROFILE\.cloud-init"
    ```

2.  Créez le fichier de configuration. **Attention :** Le nom du fichier doit correspondre exactement au nom que vous donnerez à votre instance WSL (voir étape suivante).
    Fichier : `%USERPROFILE%\.cloud-init\n8n-sandbox.user-data`

    ```yaml
    #cloud-config
    users:
      - name: sandbox-admin
        groups: [sudo]
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL

    package_update: true
    packages:
      - git
      - curl
      - build-essential

    runcmd:
      # 1. Installer Node.js 20
      - curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
      - apt-get install -y nodejs
    
      # 2. Installer Gemini CLI
      - npm install -g @google/gemini-cli
    
      # 3. Installer uv
      - curl -LsSf https://astral.sh/uv/install.sh | sh
      - mv /root/.local/bin/uv /usr/local/bin/uv
    
      # 4. Installer n8n
      - npm install -g n8n

      # 5. Préparer le workspace
      - mkdir -p /home/sandbox-admin/workspace
      - chown sandbox-admin:sandbox-admin /home/sandbox-admin/workspace
    ```

---

## 4. Importer et Lancer l'image
L'importation crée une nouvelle instance isolée basée sur le fichier téléchargé.

```powershell
# Importer l'image
# Syntaxe : wsl --import <NomInstance> <DossierDestination> <FichierTarGz>
wsl --import n8n-sandbox C:\WSL\n8n-sandbox C:\WSL\ubuntu-24.04-wsl.tar.gz

# Lancer l'instance pour déclencher cloud-init
wsl -d n8n-sandbox
```

---

## 5. Vérification
Une fois dans le terminal WSL, vérifiez que le provisionnement est en cours :

```bash
# Attendre que cloud-init termine son travail
cloud-init status --wait

# Vérifier la présence des outils
n8n --version
gemini --help
```

---

## 6. Usage et Accès
Contrairement à une VM KVM, WSL partage l'interface réseau avec Windows.
*   **n8n :** Lancez n8n manuellement (`n8n`) ou créez un service. Il sera accessible sur `http://localhost:5678` directement depuis votre navigateur Windows.
*   **Fichiers :** Vous pouvez accéder aux fichiers de l'instance via l'explorateur Windows à l'adresse `\\wsl.localhost\n8n-sandbox\home\sandbox-admin\workspace`.

---

## 7. Gestion de l'instance
*   **Arrêter :** `wsl --terminate n8n-sandbox`
*   **Supprimer (Reset total) :** `wsl --unregister n8n-sandbox` (Attention : cela supprime TOUTES les données de l'instance).
*   **Exporter (Backup) :** `wsl --export n8n-sandbox C:\WSL\backups\n8n-sandbox.tar`
