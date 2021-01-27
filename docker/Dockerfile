# Dockerfile

FROM microsoft/mssql-server-linux
LABEL maintainer="Yifan Wang <yifwang97@gmail.com>"
LABEL description="customized sqlserver"

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Wyf&19971004
ENV PATH=${PATH}:/opt/mssql/bin:/opt/mssql-tools/bin

EXPOSE 1433

RUN mkdir sqlfiles
RUN mkdir sqlfiles/data

COPY DBSchemaInit.sql ./sqlfiles/DBSchemaInit.sql
COPY Ocean.sql ./sqlfiles/Ocean.sql
COPY OceanCms.sql ./sqlfiles/OceanCms.sql
COPY setup-database.sh ./sqlfiles/setup-database.sh
COPY entrypoint.sh ./sqlfiles/entrypoint.sh
COPY Ocean.bak ./sqlfiles/Ocean.bak
COPY OceanCms.bak ./sqlfiles/OceanCms.bak
COPY data/OceanCms.mdf ./sqlfiles/data/OceanCms.mdf
COPY data/OceanCms_1.ldf ./sqlfiles/data/OceanCms_1.ldf
COPY data/Ocean.mdf ./sqlfiles/data/Ocean.mdf
COPY data/Ocean_1.ldf ./sqlfiles/data/Ocean_1.ldf

RUN chmod a+x ./sqlfiles/setup-database.sh
RUN chmod a+x ./sqlfiles/entrypoint.sh

CMD bash ./sqlfiles/entrypoint.sh
