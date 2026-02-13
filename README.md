# Sistema de Reservas Cloud-Native: Arquitectura DevOps y Nube
Este proyecto implementa una plataforma de gestión de reservas de instalaciones deportivas basada en una arquitectura de microservicios, desplegada de forma automatizada en **Amazon Web Services (AWS)** utilizando principios de **Infraestructura como Código (IaC)**, **Gestión de Configuración** y **Pipelines de CI/CD** avanzados.

El enfoque principal ha sido la eliminación de la configuración manual, garantizando despliegues idempotentes, seguros y trazables mediante la automatización total del ciclo de vida del software.

---

## 1. Resumen del proyecto

Desarrollo de aplicación web para la reservas de pistas de un polideportivo municipal. La aplicación ha sido desarrollada con **Angular** y **SpringBoot**, desplegada haciendo uso de **AWS** como cloud y **terraform** junto a **ansible** como IaC

### Tecnologías Utilizadas

| Layer | Tecnología | Uso |
| :--- | :--- | :--- |
| **Frontend** | Angular | Desarrollo de aplicación web. |
| **Backend** | Spring Boot | API REST y validación lógica compleja. |
| **Base de datos** | Amazon RDS | Persistencia gestionada (MySQL) con aislamiento de red. |
| **IaC** | Terraform | Aprovisionamiento modular de VPC, EC2, RDS y Security Groups. |
| **Config Mgmt** | Ansible | Automatización de runtime, despliegue de Docker y Nginx. |
| **CI/CD** | GitHub Actions | Pipelines automatizados de Build, Push y Deploy remoto. |
| **Cloud** | AWS | Hosting cloud robusto |

---

## 2. Arquitectura

La arquitectura se basa en un modelo de **N-Tier** dentro de una **VPC personalizada** diseñada para la seguridad perimetral:

* **Networking**: VPC segmentada en Subnets Públicas y Privadas.
* **Bastion Host (VM1)**: Único punto de entrada público que actúa como Proxy Inverso con **Nginx**, redirigiendo el tráfico al backend.
* **Application Server (VM2)**: Instancia en subred privada que ejecuta el contenedor del backend (Spring Boot), aislada completamente del tráfico externo directo.
* **Database Layer**: **Amazon RDS MySQL** en subred privada, accesible únicamente desde la IP interna de la VM de aplicación.

> **Decisión Técnica**: Se ha implementado un patrón de arquitectura de "Salto" (Jump Server) para minimizar la superficie de ataque, manteniendo la persistencia y la lógica de negocio fuera del alcance de internet público.

---

## 3. Infrastructure as Code (Terraform)

La infraestructura se gestiona de forma modular para garantizar la reproducibilidad y consistencia entre entornos.

### Estructura de Módulos
```hcl
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "ec2" {
  source     = "./modules/ec2"
  subnet_ids = module.vpc.public_subnets
  instance_type = "t3.micro"
}
```
>En su respectivo repositorio puedes encontrar todo el código completo

## Gestión del Estado

**Flujo de ejecución**:

`terraform init`: Inicialización de providers y descarga de módulos.

`terraform plan`: Generación de plan de ejecución para previsualizar cambios.

`terraform apply`: Ejecución del aprovisionamiento en la cuenta de AWS.

---

## 4. Configuration Management (Ansible)

Ansible se encarga de la configuración del sistema operativo y el despliegue de servicios una vez que Terraform entrega la infraestructura base.

Automatización: Instalación de Docker Engine, configuración de redes Docker internas y despliegue del Proxy Nginx.

Idempotencia: Los playbooks garantizan que el sistema siempre esté en el estado deseado sin importar cuántas veces se ejecuten.

```bash
# Ejemplo de ejecución del despliegue
ansible-playbook -i inventory.ini site.yml --extra-vars "db_host=${RDS_ENDPOINT}"
```

## 5. CI/CD Pipeline (GitHub Actions)

Se han implementado workflows automatizados que integran el ciclo de vida completo desde el código hasta la producción.

Triggers: El pipeline se dispara ante cualquier push en la rama main.

Build: Compilación del proyecto con Maven y generación de artefactos.

Dockerization: Creación de imagen Docker y publicación en Docker Hub.

Deploy: Conexión SSH segura a través del Bastion para realizar un pull de la imagen en la VM privada y reinicio del contenedor.

Gestión de Secretos: Todas las credenciales críticas (SSH Keys, DB Passwords, Docker Tokens) se gestionan de forma segura mediante GitHub Secrets.

---

## 6. Backend (Spring Boot)


---

## 7. Frontend (Angular)



---

## 9. Escalabilidad y mejoras

Escalabilidad Horizontal: La arquitectura es compatible con un Application Load Balancer (ALB) y grupos de auto-escalado, con el fin de mejorar la disponibilidad de la infraestructura.

Observabilidad: Se contempla la integración de Amazon CloudWatch para monitoreo de logs y métricas.

Automatización: Se plantea aplicar sofwares que faciliten la comprobación y verificación de correos electronicos (n8n)



