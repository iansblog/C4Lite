# C4Lite

## Overview
This project is a Docker-based setup for running Structurizr Lite, Mermaid Live Editor, and MkDocs Material. It includes PowerShell scripts to manage the Docker services and create backups. Here is a breakdown of the key components.

## Helpfull Visual Studio Code Extentions
- [https://marketplace.visualstudio.com/items?itemName=ciarant.vscode-structurizr](https://marketplace.visualstudio.com/items?itemName=ciarant.vscode-structurizr)
- [https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)

## Project Structure

## Overview
This project uses Docker to run multiple services for documentation and diagram creation. Below is the detailed structure and configuration.

## Files and Directories
```
.
├── docker-compose.yml      # Defines Docker services for Structurizr Lite, Mermaid Live Editor, MkDocs Material, and Nginx.
├── docker-compose-ARM.yml      # Defines Docker services for Structurizr Lite, Mermaid Live Editor, MkDocs Material, and Nginx for the ARM.
├── up.ps1                  # PowerShell script to start the Docker services and open Structurizr Lite service in a browser.
├── down.ps1                # PowerShell script to stop the Docker services and create backups of the DSL files.
├── Backup/                 # Directory where backups are stored.
└── README.md               # Documentation for the project.
```

## Docker Compose Configuration
The `docker-compose.yml` file defines the following services:

- **structurizrlite**: 
  - Runs Structurizr Lite for creating and editing C4-style architecture diagrams.
  
- **mermaid-live-editor**: 
  - Runs Mermaid Live Editor for creating diagrams using Mermaid.js.
  
- **mkdocs-material**: 
  - Runs MkDocs Material for generating and serving static documentation sites.
  
- **nginx**: 
  - Runs Nginx to serve a splash page that links to the other services.

```mermaid
graph TD
  B["structurizrlite
     Image: structurizr/lite
     Volume: ./dsl:/usr/local/structurizr
     Port: 8080:8080"] --> A[app_network]
     
  C["mermaid-live-editor
     Image: ghcr.io/mermaid-js/mermaid-live-editor
     Volume: ./mermaid:/app/data
     Port: 8081:8080"] --> A[app_network]
     
  D["mkdocs-material
     Build: context: ., dockerfile: customMkdocsBuild
     Volume: ./mkdocs:/docs
     Port: 8083:8000"] --> A[app_network]
     
  E["nginx
     Image: nginx:latest
     Volume: ./splash:/usr/share/nginx/html
             ./nginx/nginx.conf:/etc/nginx/nginx.conf
     Port: 80:80"] --> A[app_network]
     
  E --> |Depends on| B
  E --> |Depends on| C
  E --> |Depends on| D

```


## PowerShell Scripts
### up.ps1:

Starts the Docker services.
Opens the dsl directory in Visual Studio Code.
Waits for the Nginx service to be available and opens it in a browser.

```mermaid

graph TD
    A[Get-Location and set PORT to 80] --> B[Supports-ARM Function]
    B --> C{ARM architecture detected?}
    C -- Yes --> D[docker-compose -f docker-compose-ARM.yml up -d]
    C -- No --> E[docker-compose up -d]
    A --> F[Split-Path and Set-Location]
    F --> G[Check DSL directory]
    G -- Found --> H[Open DSL directory in VS Code]
    G -- Not Found --> I[Output: DSL directory not found]
    A --> J[Check mkdocs/docs directory]
    J -- Found --> K[Open mkdocs/docs directory in VS Code]
    J -- Not Found --> L[Output: mkdocs/docs directory not found]
    A --> M[Wait-ForService Function]
    M --> N{Service started?}
    N -- Yes --> O[Open the service URL]
    N -- No --> P[Output: Failed to access the service]
```

### down.ps1:
Stops the Docker services.
Creates a timestamped backup directory.
Copies the workspace.dsl and workspace.json files to the backup directory.

```mermaid
graph LR

    A[Start] --> B[Get current directory and set date format]
    B --> C[Create backup folder]
    C --> D[Stop Docker Compose services]
    D --> E[DSL Backup]
    E --> F[Create DSL backup folder]
    F --> G[Copy workspace.dsl]
    F --> H[Copy workspace.json]
    G --> I[Print DSL Backup completed]
    H --> I
    I --> J[MkDocs Backup]
    J --> K[Create MkDocs backup folder]
    K --> L[Copy MkDocs source]
    L --> M[Print Backup completed]

```

## Usage Instructions

1. **Start the Service**:
   Run the `up.ps1` script:
   ```powershell
   .\up.ps1
   ```
   This script will start the servicves, monitor it, and open it in your default browser once available.

2. **Stop the Service**:
   Run the `down.ps1` script:
   ```powershell
   .\down.ps1
   ```
   This will stop the service and create a timestamped backup of key files.

---

## Notes
- Ensure Docker and Docker Compose are installed and configured.
- Backup files are stored in the `Backup` directory under a timestamped folder.
- The site runs at [http://localhost:80](http://localhost:80) by default.

