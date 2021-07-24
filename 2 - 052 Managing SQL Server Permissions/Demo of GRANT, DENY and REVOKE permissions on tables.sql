/*
	Demo of GRANT, DENY and REVOKE permissions on tables
*/

-- GRANT Select on table to Peter

use [AdventureWorks2012]
GO
GRANT SELECT ON [HumanResources].[Department] TO [Peter]

-- GRANT Select on table to Robert
use [AdventureWorks2012]
GO
GRANT SELECT ON [HumanResources].[Department] TO [Robert]
GO


-- GRANT Select on table #2 to Peter

use [AdventureWorks2012]
GO
GRANT SELECT ON [HumanResources].[Employees] TO [Peter], [Robert] --<< can give permission to multiple logins
GO

-- Revoke Peter and Robert from table Employees

use [AdventureWorks2012]
GO
REVOKE SELECT ON [HumanResources].[Employees] TO [Peter], [Robert] AS [dbo]
GO

-- Revoke Peter and Robert from table Dapartment

use [AdventureWorks2012]
GO
REVOKE SELECT ON [HumanResources].[Department] TO [Peter], [Robert] AS [dbo]
GO



-- Add Peter to Role db_datareader, thus he can view ALL tables

USE [AdventureWorks2012]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Peter]
GO


-- DENY select on Product Table
-- He will NOT be able to view the data for table Product!! (even though he is part of the Role datareader)
-- Any DENY permission SUPERSEDES other collective permissions

USE [AdventureWorks2012]
GO
DENY SELECT ON [Production].[Product] TO [Peter]
GO


-- Revoke the DENY on Product Table (he can view Product table again)

USE [AdventureWorks2012]
GO
REVOKE SELECT ON [Production].[Product] TO [Peter]
GO



-- Drop member from the Role db_datareader
USE [AdventureWorks2012]
GO
ALTER ROLE [db_datareader] DROP MEMBER [Peter]
GO


-- Deny Server ROLE

USE [master]
GO

CREATE SERVER ROLE [ServerRole-20151112-213054]
GO

ALTER SERVER ROLE [ServerRole-20151112-213054] ADD MEMBER [Peter]
GO
ALTER SERVER ROLE [ServerRole-20151112-213054] ADD MEMBER [Robert]
GO


use [master]
GO
DENY VIEW ANY DATABASE TO [ServerRole-20151112-213054]
GO

-- Revoke the CONNECT for Peter (HE CANNOT CONNECT TO THE DATABASE)

use [AdventureWorks2012]
GO
DENY CONNECT TO [Peter], [Robert]
GO

-- GRANT CONNECT to the database again

use [AdventureWorks2012]
GO
GRANT CONNECT TO [Peter], [Robert]
GO


-- Drop Peter to view the DATABASE

ALTER SERVER ROLE [ServerRole-20151112-213054]
DROP MEMBER [Peter], [Robert]
GO


