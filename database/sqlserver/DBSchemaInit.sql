-- DBSchemaInit.sql

USE [master]
GO
/****** Object:  Database [Ocean]    Script Date: 2021/02/01 9:39:19 ******/
RESTORE DATABASE [Ocean] FROM  DISK = N'/sqlserver/beifen/Ocean.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10

/****** Object:  Database [OceanCms]    Script Date: 2021/02/01 9:39:19 ******/
RESTORE DATABASE [OceanCms] FROM  DISK = N'/sqlserver/beifen/OceanCms.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10

GO