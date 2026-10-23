-- RED SOCIAL PASCUALINA - SCRIPT DDL MYSQL 9.0
-- Por: María Sofía Pabón Pabón


-- 1. LIMPIEZA
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS mentoria, seguir, reaccion, asistente_evento, 
miembro_grupo, estudiante_interes, estudiante_habilidad, interes, habilidad, 
evento, grupo, comentario, publicacion, perfil, estudiante;
SET FOREIGN_KEY_CHECKS = 1;

-- 2. CREACIÓN DE TABLAS

CREATE TABLE estudiante (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ultima_actividad DATETIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo' NOT NULL
) ENGINE=InnoDB;

CREATE TABLE perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL UNIQUE,
    area_estudio VARCHAR(100),
    biografia TEXT,
    programa VARCHAR(100) NOT NULL,
    semestre INT NOT NULL,
    ciudad VARCHAR(50),
    foto_perfil VARCHAR(255),
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_perfil_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE publicacion (
    id_publicacion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    contenido TEXT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    metadatos_bigdata JSON, -- Campo NoSQL para Big Data en MySQL
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_publicacion_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE comentario (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    id_publicacion INT NOT NULL,
    id_estudiante INT NOT NULL,
    comentario TEXT NOT NULL,
    fecha_comentario DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_comentario_publicacion FOREIGN KEY (id_publicacion) 
        REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_comentario_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE grupo (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    creador_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo' NOT NULL,
    CONSTRAINT fk_grupo_creador FOREIGN KEY (creador_id) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE evento (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo INT,
    organizador INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    ubicacion_iot JSON, -- Campo NoSQL para IoT en MySQL
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    lugar VARCHAR(150) NOT NULL,
    modalidad VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_evento_grupo FOREIGN KEY (id_grupo) 
        REFERENCES grupo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_evento_organizador FOREIGN KEY (organizador) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE interes (
    id_interes INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB;

CREATE TABLE habilidad (
    id_habilidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB;

CREATE TABLE estudiante_habilidad (
    id_estudiante INT NOT NULL,
    id_habilidad INT NOT NULL,
    nivel VARCHAR(20),
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_habilidad),
    CONSTRAINT fk_esthab_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_esthab_habilidad FOREIGN KEY (id_habilidad) 
        REFERENCES habilidad(id_habilidad) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE estudiante_interes (
    id_estudiante INT NOT NULL,
    id_interes INT NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_interes),
    CONSTRAINT fk_estint_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estint_interes FOREIGN KEY (id_interes) 
        REFERENCES interes(id_interes) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE miembro_grupo (
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    rol VARCHAR(30) DEFAULT 'miembro',
    PRIMARY KEY (id_estudiante, id_grupo),
    CONSTRAINT fk_mgrupo_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mgrupo_grupo FOREIGN KEY (id_grupo) 
        REFERENCES grupo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE asistente_evento (
    id_estudiante INT NOT NULL,
    id_evento INT NOT NULL,
    estado VARCHAR(30) DEFAULT 'confirmado',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_evento),
    CONSTRAINT fk_asist_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_asist_evento FOREIGN KEY (id_evento) 
        REFERENCES evento(id_evento) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE reaccion (
    id_estudiante INT NOT NULL,
    id_publicacion INT NOT NULL,
    tipo_reaccion VARCHAR(30) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_publicacion),
    CONSTRAINT fk_reac_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reac_publicacion FOREIGN KEY (id_publicacion) 
        REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE seguir (
    id_seguidor INT NOT NULL,
    id_seguido INT NOT NULL,
    fecha_seguimiento DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT fk_seguir_seguidor FOREIGN KEY (id_seguidor) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_seguir_seguido FOREIGN KEY (id_seguido) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE mentoria (
    id_mentor INT NOT NULL,
    id_aprendiz INT NOT NULL,
    tema VARCHAR(100) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    fecha_mentoria DATETIME NOT NULL,
    PRIMARY KEY (id_mentor, id_aprendiz),
    CONSTRAINT fk_mentoria_mentor FOREIGN KEY (id_mentor) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mentoria_aprendiz FOREIGN KEY (id_aprendiz) 
        REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. PRUEBAS
INSERT INTO estudiante (nombre, apellido, correo, password, ultima_actividad) 
VALUES ('Sofia', 'Pabon', 'sofia@pascualbravo.edu.co', 'hash123456', NOW());

INSERT INTO publicacion (id_estudiante, contenido, tipo, metadatos_bigdata)
VALUES (1, 'Prueba MySQL NoSQL', 'post', '{"dispositivo": "Web Chrome", "browser_lang": "es-CO"}');

SELECT * FROM publicacion;
