
## Tests

Suponiendo que uses Jest:


# Ejecuta todos los tests
npm test

## Microservicios

busqueda:
automotive-microservices/
├── search-service/
│   ├── src/
│   ├── pom.xml
│   └── README.md

inventario:
├── inventory-service/
│   ├── src/
│   ├── pom.xml
│   └── README.md

pedidos:
└── order-service/
    ├── src/
    ├── pom.xml
    └── README.md

##1. Microservicio de Búsqueda 
Descripción: Este microservicio permite buscar vehículos en función de criterios como marca, modelo y año.

Tecnologías:

Spring Boot

Spring Web

Spring Data JPA

Base de datos H2 (para desarrollo)


Endpoints:

GET /vehicles/search: Busca vehículos según parámetros de consulta.


Ejemplo de uso:

curl -X GET "http://localhost:8081/vehicles/search?brand=Toyota&model=Corolla&year=2020"


##2. Microservicio de Inventario 
Descripción: Gestiona el inventario de vehículos disponibles en stock. Permite consultar la cantidad disponible y actualizar el stock.

Tecnologías:

Spring Boot

Spring Web

Spring Data JPA

Base de datos H2


Endpoints:

GET /inventory/{vehicleId}: Obtiene la cantidad disponible de un vehículo específico.

POST /inventory/update: Actualiza el stock de un vehículo.
GitHub

Ejemplo de uso:

curl -X GET "http://localhost:8082/inventory/12345"
curl -X POST -H "Content-Type: application/json" -d '{"vehicleId": 12345, "quantity": 10}' "http://localhost:8082/inventory/update"


3. Microservicio de Pedidos 
Descripción: Gestiona los pedidos de vehículos realizados por los clientes. Permite crear nuevos pedidos y consultar el estado de los mismos.

Tecnologías:

Spring Boot

Spring Web

Spring Data JPA

Base de datos H2

Endpoints:

POST /orders: Crea un nuevo pedido.

GET /orders/{orderId}: Obtiene el estado de un pedido específico.

Ejemplo de uso:

curl -X POST -H "Content-Type: application/json" -d '{"vehicleId": 12345, "customerId": 67890, "quantity": 1}' "http://localhost:8083/orders"
curl -X GET "http://localhost:8083/orders/1"
