# Dockerfile

# Temboard
FROM postgres:14-bullseye AS temboard

ARG TEMBOARD_VERSION

# Repositorio interno
ENV PGPORT "5432"
ENV POSTGRES_PASSWORD "temboard"
ENV POSTGRES_USER "postgres"
ENV POSTGRES_DB "temboard"
ENV PGDATA "/var/lib/postgresql/data/pgdata"
ENV POSTGRES_NAME "temboard"

# Monitor
ENV PGUSER=postgres
ENV PGHOST=localhost
ENV LOGDIR=/home/temboard/log/temboard
ENV LOGFILE=/home/temboard/log/temboard/temboard-auto-configure.log
ENV ETCDIR=/home/temboard/etc
ENV VARDIR=/home/temboard/bin
ENV SYSUSER=root
ENV TEMBOARD_PORT=8888
ENV TEMBOARD_PASSWORD=temboard
ENV TEMBOARD_DATABASE=temboard
ENV TEMBOARD_LOGGING_LEVEL=INFO
ENV TEMBOARD_VERSION ${TEMBOARD_VERSION}

WORKDIR /home/temboard

RUN apt-get update -y && \
    apt-get install -y sudo python3-pip locales; \
	whereis python3 && ln -s /usr/bin/python3 /usr/bin/python && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8;

ENV LANG en_US.utf8
ENV TZ America/Bahia

COPY ./Temboard/db-config.sh /docker-entrypoint-initdb.d/

COPY ./Temboard/docker-entrypoint.sh /home/temboard/

RUN chmod +x /home/temboard/docker-entrypoint.sh

RUN mkdir -p /home/temboard/log/temboard; \
	mkdir -p /home/temboard/etc; \
	mkdir -p /home/temboard/bin; \
	echo '' > /home/temboard/log/temboard/temboard-auto-configure.log; \
	pip install temboard==${TEMBOARD_VERSION} psycopg2-binary && temboard --version;

ENTRYPOINT ["/home/temboard/docker-entrypoint.sh"]