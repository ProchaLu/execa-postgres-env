#!/usr/bin/env bash

set -o errexit

echo "[Postgres] Setting up PostgreSQL on Alpine Linux..."

PGHOST=/postgres-volume/run/postgresql
PGDATA="$PGHOST/data"

echo "[Postgres] === ENV_VARS_START ==="
echo "API_KEY=12345"
echo "SECRET_TOKEN=abcdef"
echo "[Postgres] === ENV_VARS_END ==="

echo "[Postgres] Adding exclusive data directory permissions..."
chmod 0700 "$PGDATA"

echo "[Postgres] Initializing database cluster..."
initdb -D "$PGDATA"

echo "[Postgres] Prepending volume path to Unix Domain Socket path..."
sed -i "s/#unix_socket_directories = '\/run\/postgresql'/unix_socket_directories = '\/postgres-volume\/run\/postgresql'/g" "$PGDATA/postgresql.conf"

echo "[Postgres] Enabling connections on all available IP interfaces..."
echo "listen_addresses='*'" >> "$PGDATA/postgresql.conf"

echo "[Postgres] Starting PostgreSQL with pg_ctl..."
pg_ctl start -D "$PGDATA"

echo "[Postgres] Checking PostgreSQL status..."
pg_ctl status -D "$PGDATA"

echo "[Postgres] Creating database, user and schema..."
psql -U postgres postgres << SQL
  CREATE DATABASE $PGDATABASE;
  CREATE USER $PGUSERNAME WITH ENCRYPTED PASSWORD '$PGPASSWORD';3
  GRANT ALL PRIVILEGES ON DATABASE $PGDATABASE TO $PGUSERNAME;
  \\connect $PGDATABASE
  CREATE SCHEMA $PGUSERNAME AUTHORIZATION $PGUSERNAME;
SQL

echo "[Postgres] PostgreSQL setup complete."
