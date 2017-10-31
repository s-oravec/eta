rem
rem Drops package schema/schemas
rem
rem Usage
rem     SQL > @drop.sql <configuration>
rem
rem Options
rem
rem     configuration - manual     - asks for configuration parameters
rem                   - configured - supplied configuration is used
rem
set verify off
define l_configuration = "&1"

rem Load package
@@package.sql

rem init SQL*Plus settings
@sqlplus_init.sql

prompt Drop schemas
@@module/dba/drop_&&l_configuration..sql

@@sqlplus_finalize.sql
rem finalize SQL*Plus

rem undefine script locals
undefine l_configuration

rem undefine package globals
@@undefine_globals.sql
