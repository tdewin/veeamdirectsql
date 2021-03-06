/*
//A hosts can be the backup server, vsphere, repository server, proxy server ..
SELECT  [id]
      ,[name]
FROM [VeeamBackup].[dbo].[Hosts]
*/

/* 
//Represents the repositories
SELECT  [id]
      ,[name]
      ,[host_id]
      ,[path]
FROM [VeeamBackup].[dbo].[BackupRepositories]
*/

/*
//ExtRepos defines the relationship between sobr-cluster, backend repository. The main id is used in ExtStorage. This is pretty weird stuff
//[dependant_repo_id] is the ref to the pk of the backend repository
SELECT  [id]
      ,[meta_repo_id]
      ,[dependant_repo_id]
FROM [VeeamBackup].[dbo].[Backup.ExtRepo.ExtRepos]
*/

/*
//ExtStorages makes the connection between a storage and extrepos (repository in scale-out)
//[dependant_repo_id] is the ref to the pk in [Backup.ExtRepo.ExtRepos]
SELECT  [storage_id]
      ,[dependant_repo_id]
FROM [VeeamBackup].[dbo].[Backup.ExtRepo.Storages]
*/

/*
//A storage is a physical file on disk like a VBK, VIB
//backup_id is the ref to the pk in [Backup.Model.Backups]
SELECT [id],[file_path],[backup_id]
FROM [VeeamBackup].[dbo].[Backup.Model.Storages]
*/


/*
//A backup is a collection of files (result of multiple job runs)
SELECT [id],[job_id],[job_name],[dir_path]
FROM [VeeamBackup].[dbo].[Backup.Model.Backups]
*/

SELECT [stgs].[id] as StorageID,
		[file_path] as StorageFilePath,
		[job_name] as JobName,
		[normhost].[name] as DirectRepositoryHost,
		[normrepo].[name] as RepositoryName,
		[dir_path] as DirectoryPathInRepository,
		[bghost].[name] as ExtentRepositoryHost,
		[bgrepo].[name] as ExtentRepositoryName,
		[bgrepo].[path] as ExtentRepositoryPath
FROM [VeeamBackup].[dbo].[Backup.Model.Storages] AS stgs
LEFT JOIN [VeeamBackup].[dbo].[Backup.Model.Backups] AS backups ON [backups].[id] = [stgs].[backup_id]
LEFT JOIN [VeeamBackup].[dbo].[BackupRepositories] AS normrepo ON [normrepo].[id] = [backups].[repository_id]
LEFT JOIN [VeeamBackup].[dbo].[Hosts] AS normhost on [normrepo].[host_id] = [normhost].[id]
LEFT JOIN [VeeamBackup].[dbo].[Backup.ExtRepo.Storages] AS extstgs ON [extstgs].[storage_id] = [stgs].[id]
LEFT JOIN [VeeamBackup].[dbo].[Backup.ExtRepo.ExtRepos] AS extrepos ON [extrepos].[id] = [extstgs].[dependant_repo_id]
LEFT JOIN [VeeamBackup].[dbo].[BackupRepositories] AS bgrepo ON [bgrepo].[id] = [extrepos].[dependant_repo_id]
LEFT JOIN [VeeamBackup].[dbo].[Hosts] AS bghost on [bgrepo].[host_id] = [bghost].[id]
/*WHERE [job_name] LIKE '%lin-sobr%'*/

