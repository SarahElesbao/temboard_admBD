#!/usr/bin/env bash

# Could have used pg_isready as-well..

	psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
		CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
	EOSQL
	
