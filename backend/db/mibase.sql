


CREATE TABLE inventario (
    id SERIAL PRIMARY KEY,
    vin VARCHAR(17) UNIQUE NOT NULL, -- Número de identificación del vehículo
    modelo VARCHAR(100) NOT NULL,
    marca VARCHAR(100) NOT NULL,
    año int NOT NULL,
    cantidad INT DEFAULT 0,
    ubicacion VARCHAR(255),
    estado VARCHAR(50) -- Ej: 'Disponible', 'En tránsito', 'Reservado'
);

CREATE TABLE busqueda (
    id SERIAL PRIMARY KEY,
    usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    criterio_modelo VARCHAR(100),
    criterio_marca VARCHAR(100),
    criterio_año INT,
    criterio_estado VARCHAR(50)
);

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    vin VARCHAR(17) NOT NULL,
    cantidad INT NOT NULL,
    cliente VARCHAR(255) NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_pedido VARCHAR(50) DEFAULT 'Pendiente', -- Ej: 'Pendiente', 'Enviado', 'Entregado'
    FOREIGN KEY (vin) REFERENCES inventario(vin)
);


CREATE TABLE piezas (
  id INTEGER PRIMARY KEY,
  modelo TEXT NOT NULL,
  anio INTEGER NOT NULL,
  vin TEXT NOT NULL,
  cantidad INTEGER NOT NULL,
  ubicacion TEXT NOT NULL,
  estado TEXT NOT NULL
);

-- Datos de ejemplo:
INSERT INTO piezas (modelo, anio, vin, cantidad, ubicacion, estado,id) VALUES
('Toyota Corolla', 2018, '1HGCM82633A004352', 5, 'Almacén A1', 'Nuevo',1),
('Honda Civic', 2020, '2HGFA16558H332178', 3, 'Almacén B2', 'Usado',2),
('Ford Focus', 2017, '3FAHP0HA1CR271280', 7, 'Depósito C', 'Nuevo',3),
('Chevrolet Spark', 2015, 'KL8CD6S99EC481923', 4, 'Almacén A3', 'Reacondicionado',4),
('Nissan Sentra', 2019, 'JN8AS5MT9CW239832', 2, 'Zona Norte', 'Nuevo',5),
('Volkswagen Jetta', 2016, '3VWD07AJ5EM388395', 6, 'Almacén D1', 'Usado',6),
('Hyundai Elantra', 2021, '5NPD84LF9LH560203', 8, 'Estante E5', 'Nuevo',7),
('Kia Rio', 2014, 'KNADH4A39E6921923', 1, 'Sector B', 'Usado',8),
('Mazda 3', 2018, 'JM1BN1V7XJ1156271', 9, 'Almacén F2', 'Nuevo',9),
('Renault Logan', 2020, '9FBBCF8H9LM120384', 3, 'Depósito Z', 'Nuevo',10);


-- insert fake data




