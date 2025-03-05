#!/usr/bin/env node

import { execa } from 'execa';

console.log(`Setting up PostgreSQL database...`);

await execa`mkdir -p /postgres-volume/run/postgresql/data`;
await execa`chown -R postgres:postgres /postgres-volume/run/postgresql`;

console.log(`Starting child script...`);

const postgresUid = Number((await execa`id -u postgres`).stdout);

console.log(`Starting PostgreSQL setup script as UID ${postgresUid}...`);

// Run as the postgres user
const postgresProcess = execa({
  uid: postgresUid,
  stdout: 'pipe',
})`bash ./child.sh`;

console.log(`PostgreSQL process started, capturing stdout...`);

postgresProcess.stdout.on('data', (data) => {
  console.log(`[PIPE DEBUG] ${data.toString()}`);
});

console.log('stdout: ', (await postgresProcess).stdout);
