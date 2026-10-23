--RED SOCIAL PASCUALINA SCRIPT DDL POSTGRESQL 17
--Por:María Sofía Pabón Pabón
--1.limpieza
--Borramos las tablas viejas para empezar con la base de datos limpia
DROP TABLE IF EXISTS mentoria, seguir, reaccion, asistente_evento, miembro_grupo, estudiante_interes, estudiante_habilidad, interes, habilidad, evento, grupo, comentario, publicacion, perfil, estudiante CASCADE;

--2.Procedemos a construir la estructura de la red social (las 15 tablas)

--1. TABLA: estudiante
CREATE TABLE estudiante (
    id_estudiante SERIAL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ultima_actividad TIMESTAMP NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo' NOT NULL,
    CONSTRAINT pk_estudiante PRIMARY KEY (id_estudiante),
    CONSTRAINT uk_estudiante_correo UNIQUE (correo)
);

-- 2. TABLA: perfil
CREATE TABLE perfil (
    id_perfil SERIAL,
    id_estudiante INT NOT NULL,
    area_estudio VARCHAR(100),
    biografia TEXT,
    programa VARCHAR(100) NOT NULL,
    semestre INT NOT NULL,
    ciudad VARCHAR(50),
    foto_perfil VARCHAR(255),
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_perfil PRIMARY KEY (id_perfil),
    CONSTRAINT uk_perfil_estudiante UNIQUE (id_estudiante),
    CONSTRAINT fk_perfil_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

-- TABLA PUBLICACION (Incluye metadatos_bigdata de tipo JSONB para Big Data)
CREATE TABLE publicacion (
    id_publicacion SERIAL,
    id_estudiante INT NOT NULL,
    contenido TEXT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    metadatos_bigdata JSONB, -- Campo NoSQL/Big Data: dispositivo, trazas, tags dinámicos
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
    CONSTRAINT fk_publicacion_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE

);

-- 4. TABLA: comentario
CREATE TABLE comentario (
    id_comentario SERIAL,
    id_publicacion INT NOT NULL,
    id_estudiante INT NOT NULL,
    comentario TEXT NOT NULL,
    fecha_comentario TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
    CONSTRAINT fk_comentario_publicacion FOREIGN KEY (id_publicacion) 
        REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_comentario_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 5. TABLA: grupo
CREATE TABLE grupo (
    id_grupo SERIAL,
    creador_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo' NOT NULL,
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT fk_grupo_creador FOREIGN KEY (creador_id) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

--6. TABLA EVENTO (Incluye ubicacion_iot de tipo JSONB para sensores e IoT)
CREATE TABLE evento (
    id_evento SERIAL,
    id_grupo INT,
    organizador INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    ubicacion_iot JSONB, -- Campo NoSQL/IoT: GPS exacto, sensores de aforo, sala_id
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NOT NULL,
    lugar VARCHAR(150) NOT NULL,
    modalidad VARCHAR(50) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT fk_evento_grupo FOREIGN KEY (id_grupo) 
        REFERENCES grupo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_evento_organizador FOREIGN KEY (organizador) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 7. TABLA: interes
CREATE TABLE interes (
    id_interes SERIAL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    CONSTRAINT pk_interes PRIMARY KEY (id_interes),
    CONSTRAINT uk_interes_nombre UNIQUE (nombre)
);

-- 8. TABLA: habilidad
CREATE TABLE habilidad (
    id_habilidad SERIAL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    CONSTRAINT pk_habilidad PRIMARY KEY (id_habilidad),
    CONSTRAINT uk_habilidad_nombre UNIQUE (nombre)
);

-- 9. TABLA INTERMEDIA: estudiante_habilidad
CREATE TABLE estudiante_habilidad (
    id_estudiante INT NOT NULL,
    id_habilidad INT NOT NULL,
    nivel VARCHAR(20),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_estudiante_habilidad PRIMARY KEY (id_estudiante, id_habilidad),
    CONSTRAINT fk_esthab_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_esthab_habilidad FOREIGN KEY (id_habilidad) 
        REFERENCES habilidad(id_habilidad) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 10. TABLA INTERMEDIA: estudiante_interes
CREATE TABLE estudiante_interes (
    id_estudiante INT NOT NULL,
    id_interes INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_estudiante_interes PRIMARY KEY (id_estudiante, id_interes),
    CONSTRAINT fk_estint_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estint_interes FOREIGN KEY (id_interes) 
        REFERENCES interes(id_interes) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 11. TABLA INTERMEDIA: miembro_grupo
CREATE TABLE miembro_grupo (
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    rol VARCHAR(30) DEFAULT 'miembro',
    CONSTRAINT pk_miembro_grupo PRIMARY KEY (id_estudiante, id_grupo),
    CONSTRAINT fk_mgrupo_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mgrupo_grupo FOREIGN KEY (id_grupo) 
        REFERENCES grupo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 12. TABLA INTERMEDIA: asistente_evento
CREATE TABLE asistente_evento (
    id_estudiante INT NOT NULL,
    id_evento INT NOT NULL,
    estado VARCHAR(30) DEFAULT 'confirmado',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_asistente_evento PRIMARY KEY (id_estudiante, id_evento),
    CONSTRAINT fk_asist_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_asist_evento FOREIGN KEY (id_evento) 
        REFERENCES evento(id_evento) ON UPDATE CASCADE ON DELETE CASCADE
);
-- 13. TABLA INTERMEDIA: reaccion
CREATE TABLE reaccion (
    id_estudiante INT NOT NULL,
    id_publicacion INT NOT NULL,
    tipo_reaccion VARCHAR(30) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_reaccion PRIMARY KEY (id_estudiante, id_publicacion),
    CONSTRAINT fk_reac_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reac_publicacion FOREIGN KEY (id_publicacion) 
        REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE
);
-- 14. TABLA INTERMEDIA: seguir
CREATE TABLE seguir (
    id_seguidor INT NOT NULL,
    id_seguido INT NOT NULL,
    fecha_seguimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_seguir PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT fk_seguir_seguidor FOREIGN KEY (id_seguidor) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_seguir_seguido FOREIGN KEY (id_seguido) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);
-- 15. TABLA INTERMEDIA: mentoria
CREATE TABLE mentoria (
    id_mentor INT NOT NULL,
    id_aprendiz INT NOT NULL,
    tema VARCHAR(100) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    fecha_mentoria TIMESTAMP NOT NULL,
    CONSTRAINT pk_mentoria PRIMARY KEY (id_mentor, id_aprendiz),
    CONSTRAINT fk_mentoria_mentor FOREIGN KEY (id_mentor) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mentoria_aprendiz FOREIGN KEY (id_aprendiz) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 3. PRUEBA CON DATOS HYBRID (JSON)
INSERT INTO estudiante (nombre, apellido, correo, password, ultima_actividad) 
VALUES ('Sofia', 'Pabon', 'sofia@pascualbravo.edu.co', 'hash123456', NOW());

INSERT INTO publicacion (id_estudiante, contenido, tipo, metadatos_bigdata)
VALUES (1, 'Hola a todos los usuarios en la Red Pascualina!', 'post', '{"dispositivo": "Mobile Android", "ip": "192.168.1.15", "tags": ["inicio", "bienvenida"]}'::jsonb);

INSERT INTO evento (organizador, nombre, descripcion, fecha_inicio, fecha_fin, lugar, modalidad, ubicacion_iot)
VALUES (1, 'Taller de Bases de Datos', 'Uso de JSON en PostgreSQL', NOW(), NOW() + INTERVAL '2 hours', 'Bloque 12 - Aula 201', 'Presencial', '{"gps": {"lat": 6.2442, "lon": -75.5812}, "sensor_aforo_id": "SEN-102", "aforo_max": 30}'::jsonb);

-- Consulta: Ver las publicaciones con su JSON de Big Data
SELECT * FROM publicacion;
