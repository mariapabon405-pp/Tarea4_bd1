-- RED SOCIAL PASCUALINA - SCRIPT DDL SQLITE 3
-- Por: María Sofía Pabón Pabón


PRAGMA foreign_keys = ON;

-- 1. LIMPIEZA
DROP TABLE IF EXISTS mentoria;
DROP TABLE IF EXISTS seguir;
DROP TABLE IF EXISTS reaccion;
DROP TABLE IF EXISTS asistente_evento;
DROP TABLE IF EXISTS miembro_grupo;
DROP TABLE IF EXISTS estudiante_interes;
DROP TABLE IF EXISTS estudiante_habilidad;
DROP TABLE IF EXISTS interes;
DROP TABLE IF EXISTS habilidad;
DROP TABLE IF EXISTS evento;
DROP TABLE IF EXISTS grupo;
DROP TABLE IF EXISTS comentario;
DROP TABLE IF EXISTS publicacion;
DROP TABLE IF EXISTS perfil;
DROP TABLE IF EXISTS estudiante;

-- 2. CREACIÓN DE TABLAS

CREATE TABLE estudiante (
    id_estudiante INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    correo TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    fecha_registro TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ultima_actividad TEXT NOT NULL,
    estado TEXT DEFAULT 'activo' NOT NULL
);

CREATE TABLE perfil (
    id_perfil INTEGER PRIMARY KEY AUTOINCREMENT,
    id_estudiante INTEGER NOT NULL UNIQUE,
    area_estudio TEXT,
    biografia TEXT,
    programa TEXT NOT NULL,
    semestre INTEGER NOT NULL,
    ciudad TEXT,
    foto_perfil TEXT,
    fecha_actualizacion TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE publicacion (
    id_publicacion INTEGER PRIMARY KEY AUTOINCREMENT,
    id_estudiante INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    tipo TEXT NOT NULL,
    metadatos_bigdata TEXT, -- Almacena JSON como TEXT en SQLite
    fecha_publicacion TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (metadatos_bigdata IS NULL OR json_valid(metadatos_bigdata)) -- Validaciones de formato JSON
);

CREATE TABLE comentario (
    id_comentario INTEGER PRIMARY KEY AUTOINCREMENT,
    id_publicacion INTEGER NOT NULL,
    id_estudiante INTEGER NOT NULL,
    comentario TEXT NOT NULL,
    fecha_comentario TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE grupo (
    id_grupo INTEGER PRIMARY KEY AUTOINCREMENT,
    creador_id INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    tipo TEXT NOT NULL,
    fecha_creacion TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado TEXT DEFAULT 'activo' NOT NULL,
    FOREIGN KEY (creador_id) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE evento (
    id_evento INTEGER PRIMARY KEY AUTOINCREMENT,
    id_grupo INTEGER,
    organizador INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    ubicacion_iot TEXT, -- Almacena JSON como TEXT para IoT
    fecha_inicio TEXT NOT NULL,
    fecha_fin TEXT NOT NULL,
    lugar TEXT NOT NULL,
    modalidad TEXT NOT NULL,
    fecha_creacion TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (organizador) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (ubicacion_iot IS NULL OR json_valid(ubicacion_iot))
);

CREATE TABLE interes (
    id_interes INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE habilidad (
    id_habilidad INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE estudiante_habilidad (
    id_estudiante INTEGER NOT NULL,
    id_habilidad INTEGER NOT NULL,
    nivel TEXT,
    fecha_agregado TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_habilidad),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_habilidad) REFERENCES habilidad(id_habilidad) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE estudiante_interes (
    id_estudiante INTEGER NOT NULL,
    id_interes INTEGER NOT NULL,
    fecha_agregado TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_interes),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_interes) REFERENCES interes(id_interes) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE miembro_grupo (
    id_estudiante INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    fecha_ingreso TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    rol TEXT DEFAULT 'miembro',
    PRIMARY KEY (id_estudiante, id_grupo),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE asistente_evento (
    id_estudiante INTEGER NOT NULL,
    id_evento INTEGER NOT NULL,
    estado TEXT DEFAULT 'confirmado',
    fecha_registro TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_evento),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE reaccion (
    id_estudiante INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,
    tipo_reaccion TEXT NOT NULL,
    fecha TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_estudiante, id_publicacion),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE seguir (
    id_seguidor INTEGER NOT NULL,
    id_seguido INTEGER NOT NULL,
    fecha_seguimiento TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_seguidor, id_seguido),
    FOREIGN KEY (id_seguidor) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_seguido) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE mentoria (
    id_mentor INTEGER NOT NULL,
    id_aprendiz INTEGER NOT NULL,
    tema TEXT NOT NULL,
    estado TEXT NOT NULL,
    fecha_mentoria TEXT NOT NULL,
    PRIMARY KEY (id_mentor, id_aprendiz),
    FOREIGN KEY (id_mentor) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_aprendiz) REFERENCES estudiante(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 3. PRUEBAS
INSERT INTO estudiante (nombre, apellido, correo, password, ultima_actividad) 
VALUES ('Sofia', 'Pabon', 'sofia@pascualbravo.edu.co', 'hash123456', datetime('now'));

INSERT INTO publicacion (id_estudiante, contenido, tipo, metadatos_bigdata)
VALUES (1, 'Prueba SQLite NoSQL', 'post', '{"dispositivo": "Embedded Device"}');

SELECT * FROM publicacion;
