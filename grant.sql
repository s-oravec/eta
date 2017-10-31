rem
rem grant privileges to either package or deployer schema
rem
rem Usage
rem     SQL > @grant.sql <packageSchema>
rem
rem Options
rem
rem     packageSchema - grant privileges to packageSchema before installing package
rem
set verify off
define l_schema_name = "&1"

rem Load package
@@package.sql

rem init SQL*Plus settings
@sqlplus_init.sql

prompt Grant grants
@module/dba/grant_schema.sql &&l_schema_name

rem finalize SQL*Plus
@@sqlplus_finalize.sql

rem undefine grants
undefine l_schema_name

rem undefine package globals
@@undefine_globals.sql
