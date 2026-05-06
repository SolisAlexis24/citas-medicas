-- ============================================================
-- CREAR USUARIO ADMINISTRADOR DE BASE DE DATOS EN POSTGRESQL
-- ============================================================
-- Este script crea un usuario con permisos para administrar
-- objetos de una base de datos, pero sin ser superusuario

\echo 'Creando usuarios'

-- 1. CREAR EL USUARIO ADMINISTRADOR
CREATE USER admin_bd WITH PASSWORD 'admin-citas';
ALTER USER admin_bd WITH LOGIN;
GRANT USAGE ON SCHEMA public TO admin_bd;
GRANT CREATE ON SCHEMA public TO admin_bd;

-- 2. CREA EL USUARIO DE APLICACION
CREATE USER app_user WITH PASSWORD 'app-user';
ALTER USER app_user WITH LOGIN;
GRANT USAGE ON SCHEMA public TO app_user;

-- ============================================================
-- PERMISOS POR DEFECTO PARA OBJETOS FUTUROS
-- ============================================================

-- Tablas, vistas, etc. que se creen en el futuro
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO admin_bd;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO admin_bd;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO admin_bd;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TYPES TO admin_bd;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO app_user;


-- ============================================================
-- VERIFICAR PERMISOS OTORGADOS
-- ============================================================

-- Ver usuarios y sus atributos
\du

-- Ver permisos en la BD
\l

\echo 'Creación de usuarios finalizada'