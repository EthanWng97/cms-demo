# Dockerfile

FROM postgres
LABEL maintainer="Yifan Wang <yifwang97@gmail.com>"
LABEL description="customized postgresql"

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=19971004
ENV POSTGRES_DB postgres

RUN mkdir postgresql

COPY DBSchemaInit.sql ./docker-entrypoint-initdb.d/DBSchemaInit.sql
COPY postgresql/springtb.csv ./postgresql/springtb.csv

RUN /etc/init.d/postgresql start

EXPOSE 5432
