Proyecto: Base de Datos de Supermercado con PostgreSQL y Docker
Este proyecto establece un entorno de base de datos relacional completo para un sistema de supermercado, utilizando Docker para la contenerización de servicios. El objetivo es demostrar las mejores prácticas en modelado de datos, operaciones CRUD, optimización y automatización directamente en una base de datos PostgreSQL.

El sistema se gestiona a través de la interfaz visual de pgAdmin, y toda la lógica (creación de tablas, inserción de datos, triggers, procedimientos) está contenida en scripts SQL.

Tecnologías Utilizadas
Contenerización: Docker, Docker Compose

Base de Datos: PostgreSQL

Administración de DB: pgAdmin 4

Lenguaje de Base de Datos: SQL (PL/pgSQL para funciones y procedimientos)

Estructura del Proyecto
/
├── data/
│   ├── creacion_de_tablas.sql
│   ├── llenado_de_tablas.sql
│   └── todas_las_querys_en_pgadmin.sql
├── .gitignore
├── docker-compose.yml
├── esquema_supermercado.sql
├── README.md
└── requirements.txt

docker-compose.yml: Define y orquesta los servicios de PostgreSQL y pgAdmin.

/data: Contiene los scripts SQL modulares para las diferentes etapas del proyecto.

creacion_de_tablas.sql: Define el esquema inicial de la base de datos.

llenado_de_tablas.sql: Inserta los datos de ejemplo en las tablas.

todas_las_querys_en_pgadmin.sql: Script consolidado con todas las operaciones (CRUD, optimización, automatización).

esquema_supermercado.sql: Exportación completa del esquema final de la base de datos, generado con pg_dump.

.gitignore: Especifica los archivos y directorios que deben ser ignorados por Git para mantener el repositorio limpio.

requirements.txt: Lista de las dependencias de Python. Aunque este proyecto no incluye scripts de Python activos, se mantiene para futuras expansiones (ej. análisis con pandas).

Guía de Instalación y Uso
Sigue estos pasos para levantar el entorno y explorar la base de datos en tu máquina local.

Prerrequisitos
Tener instalado Docker Desktop.

Pasos
Clonar el Repositorio

git clone https://github.com/AleHerreraSoria/supermercado_db.git
cd supermercado_db

Levantar los Servicios con Docker
Asegúrate de que Docker Desktop esté en ejecución. Luego, desde la raíz del proyecto, ejecuta:

docker-compose up -d

Este comando creará e iniciará un contenedor para PostgreSQL y otro para pgAdmin.

Configurar y Poblar la Base de Datos

Abre tu navegador y ve a http://localhost:5050 para acceder a pgAdmin.

Inicia sesión. Las credenciales por defecto son admin@admin.com y admin.

Registra un nuevo servidor en pgAdmin:

Pestaña General -> Name: supermercado_db (o el nombre que prefieras).

Pestaña Connection -> Host name/address: postgres-db.

Pestaña Connection -> Username: admin.

Pestaña Connection -> Password: password123.

Guarda la conexión.

Una vez conectado, expande el servidor y localiza la base de datos supermercado_db.

Abre la "Query Tool" y ejecuta el contenido del archivo /data/todas_las_querys_en_pgadmin.sql (o los scripts individuales en orden) para crear las tablas, insertar los datos y configurar las automatizaciones.

¡Listo! El entorno de la base de datos está completamente configurado y listo para ser explorado.
