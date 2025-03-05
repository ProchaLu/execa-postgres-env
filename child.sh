#!/usr/bin/env bash

set -o errexit

echo "[Postgres] Setting up PostgreSQL on Alpine Linux..."

PGDATA="/postgres-volume/run/postgresql/data"

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

echo "[Postgres] Starting PostgreSQL with pg_ctl..."
pg_ctl start -D "$PGDATA"

echo "[Postgres] PostgreSQL running..."
