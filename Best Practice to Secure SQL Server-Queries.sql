
-- info about BUILTIN\administrators

EXEC master..xp_logininfo
@acctname = 'Builtin\Administrators',
@option = 'members'

-- Drop the Builtin\Administrators

USE MASTER
IF EXISTS (SELECT * FROM sys.server_principals
WHERE name = N'BUILTIN\Administrators')
DROP LOGIN [BUILTIN\Administrators]
GO

-- Verify the Builtin\Administrators group has been dropped

EXEC master..xp_logininfo
@acctname = 'Builtin\Administrators',
@option = 'members'

-- Add Builtin\Administrators
EXEC sp_grantlogin 'Builtin\Administrators'
EXEC sp_addsrvrolemember 'BUILTIN\Administrators', 'sysadmin'

EXEC master..xp_logininfo
@acctname = 'Builtin\Administrators',
@option = 'members'


-- Enable Windows Authentication (requires a restart of services)

USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE',
N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMOde',
REG_DWORD, 1
GO


-- Enable MIxed Mode Authentication (Requires a restart of services)

USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE',
N'Software\Microsoft\MSSQLServer\MSSQLServer',
N'LoginMode', REG_DWORD, 2
GO


-- Get Info on all SQL Logins and Windows Users

SELECT name AS Login_Name, TYPE, type_desc AS Account_Type
FROM sys.server_principals
WHERE TYPE IN ('U', 'S', 'G')
ORDER BY name, type_desc


-- view all users that have access to SQL Server

SELECT name, type_desc, is_disabled
FROM sys.server_principals


-- make sure you have a login that is part of the sysadmin role before doing this!!!

USE [master]
GO
ALTER LOGIN [sa] WITH PASSWORD=N'Password#12345'
GO
ALTER LOGIN [sa] DISABLE
GO


USE [master]
GO
ALTER LOGIN [sa] WITH PASSWORD=N'Password#12345'
GO
ALTER LOGIN [sa] ENABLE
GO


-- Hide all databases

USE MASTER
GO
DENY VIEW ANY DATABASE TO PUBLIC
GO

-- unhide all databases
USE MASTER
GO 
GRANT VIEW ANY DATABASE TO PUBLIC
GO




















