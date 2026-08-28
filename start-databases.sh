#!/bin/bash
echo "Starting all databases..."
docker compose -f mssql-compose.yml up -d
docker compose -f mysql-compose.yml up -d
docker compose -f postgres-compose.yml up -d
docker compose -f redis-compose.yml up -d
docker compose -f mongodb-compose.yml up -d
echo "All databases started!"
echo "UI's available at:"
echo "  MySQL phpMyAdmin: Port 8082"
echo "  PostgreSQL pgAdmin: Port 8084"
echo "  MongoDB Express: Port 8081"
echo "  Redis Insight: Port 8085"
echo "  Adminer: Port 8083"
