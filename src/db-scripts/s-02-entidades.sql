

\connect postgres admin_bd

\echo 'Comenzando creacion de entidades'

-- Script SQL para PostgreSQL - Sistema de Gestión de Citas Médicas
-- ============================================================================

-- Tabla: paciente
-- Almacena la información de los pacientes del sistema
CREATE TABLE paciente (
    id_paciente SERIAL PRIMARY KEY,
    poliza CHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    email VARCHAR(254),
    telefono VARCHAR(10),
    CONSTRAINT chk_sexo CHECK (sexo = 'f' OR sexo = 'm')
);

-- Tabla: medico
-- Almacena la información de los médicos disponibles
CREATE TABLE medico (
    id_medico SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacimiento DATE NOT NULL,
    especialidad VARCHAR(70) NOT NULL,
    cédula_profesional CHAR(12) NOT NULL,
    telefono VARCHAR(10),
    ruta_foto VARCHAR(10),
    CONSTRAINT uk_cedula_profesional UNIQUE (cédula_profesional)
);

-- Tabla: consultorio
-- Almacena la información de los consultorios disponibles
CREATE TABLE consultorio (
    id_consultorio SERIAL PRIMARY KEY,
    id_medico INTEGER NOT NULL,
    numero VARCHAR(100) NOT NULL,
    equipamiento TEXT,
    CONSTRAINT fk_consultorio_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla: credencial_medico
-- Almacena las credenciales de acceso para los médicos
CREATE TABLE credencial_medico (
    id_credencial SERIAL PRIMARY KEY,
    id_medico INTEGER NOT NULL,
    hash_contrasena VARCHAR(200) NOT NULL,
    actualizacion TIMESTAMP NOT NULL,
    CONSTRAINT fk_credencial_medico_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uk_id_medico_credencial UNIQUE (id_medico)
);

-- Tabla: credencial_paciente
-- Almacena las credenciales de acceso para los pacientes
CREATE TABLE credencial_paciente (
    id_credencial SERIAL PRIMARY KEY,
    id_paciente INTEGER NOT NULL,
    hash_contrasena VARCHAR(200) NOT NULL,
    actualizacion TIMESTAMP NOT NULL,
    CONSTRAINT fk_credencial_paciente_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uk_id_paciente_credencial UNIQUE (id_paciente)
);

-- Tabla: catalogo_estado
-- Catálogo de estados válidos para las citas
CREATE TABLE catalogo_estado (
    id_estado SERIAL PRIMARY KEY,
    estado VARCHAR(20) NOT NULL
);

-- Tabla: disponibilidad
-- Almacena la disponibilidad horaria de los médicos
CREATE TABLE disponibilidad (
    id_disponibilidad SERIAL PRIMARY KEY,
    id_medico INTEGER NOT NULL,
    dia_semana NUMERIC(1) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    CONSTRAINT fk_disponibilidad_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_dia_semana CHECK (dia_semana BETWEEN 1 AND 7)
);

-- Tabla: cita
-- Almacena la información de las citas médicas
CREATE TABLE cita (
    id_cita SERIAL PRIMARY KEY,
    id_paciente INTEGER NOT NULL,
    id_medico INTEGER NOT NULL,
    id_estado INTEGER NOT NULL,
    creacion TIMESTAMP NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    motivo TEXT,
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cita_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cita_estado FOREIGN KEY (id_estado) REFERENCES catalogo_estado(id_estado) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================================
-- Índices para optimizar consultas frecuentes
-- ============================================================================

CREATE INDEX idx_cita_paciente ON cita(id_paciente);
CREATE INDEX idx_cita_medico ON cita(id_medico);
CREATE INDEX idx_cita_estado ON cita(id_estado);
CREATE INDEX idx_cita_fecha ON cita(fecha);
CREATE INDEX idx_disponibilidad_medico ON disponibilidad(id_medico);
CREATE INDEX idx_consultorio_medico ON consultorio(id_medico);

-- ============================================================================
-- Inserciones de datos iniciales en el catálogo de estados
-- ============================================================================

INSERT INTO catalogo_estado (estado) VALUES
    ('Agendada'),
    ('Confirmada'),
    ('Cancelada'),
    ('Completada'),
    ('No Presentado');

-- ============================================================================
-- Fin del script
-- ============================================================================