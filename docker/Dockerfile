# Dockerfile

FROM microsoft/mssql-server-linux
LABEL maintainer="Yifan Wang <yifwang97@gmail.com>"
LABEL description="customized sqlserver"

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Wyf&19971004
ENV PATH=${PATH}:/opt/mssql/bin:/opt/mssql-tools/bin

EXPOSE 1433

RUN mkdir sqlfiles
RUN mkdir sqlserver

COPY DBSchemaInit.sql ./sqlfiles/DBSchemaInit.sql
COPY setup-database.sh ./sqlfiles/setup-database.sh
COPY entrypoint.sh ./sqlfiles/entrypoint.sh
COPY sqlserver/beifen/ocean.bak ./sqlserver/beifen/Ocean.bak
COPY sqlserver/beifen/OceanCms.bak ./sqlserver/beifen/OceanCms.bak
COPY sqlserver/data/OceanCms.mdf ./sqlserver/data/OceanCms.mdf
COPY sqlserver/data/OceanCms_1.ldf ./sqlserver/data/OceanCms_1.ldf
COPY sqlserver/data/Ocean.mdf ./sqlserver/data/Ocean.mdf
COPY sqlserver/data/Ocean_1.ldf ./sqlserver/data/Ocean_1.ldf

RUN chmod a+x ./sqlfiles/setup-database.sh
RUN chmod a+x ./sqlfiles/entrypoint.sh

CMD bash ./sqlfiles/entrypoint.sh
