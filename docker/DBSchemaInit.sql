RESTORE DATABASE [Ocean] FROM  DISK = N'/sqlfiles/Ocean.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10
RESTORE DATABASE [OceanCms] FROM  DISK = N'/sqlfiles/OceanCms.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10