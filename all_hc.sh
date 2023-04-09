#! /bin/ sh 
#DB Health Check Script 
# -----------------------------------------------------------------------
#Function Nane : db checks 
#Input : — does not required any input 
#Output :— Perform the DB Health checks including standby 
# -----------------------------------------------------------------------

db_checks()
{
echo  " "


$ORACLE_HOME/bin/sq1p1us -s "/ as sysdba" <<EOF
set serveroutput on 
set feedback off 
spool dbstatus.log 
declare
lv_db_role varchar2 (30); 
Iv_logmode varchar2 (30); 
Iv_dbnane varchar2 (30); 
Iv_dg_dbs number; 
lv_dg_config number;
Iv_nun number; 
begin 
dbms_output.put_line( CHR(13) || CHR(IO)); 
select name into lv_dbname from v_$database; 
dbms_output.put.line (' ');
dbms_output.put_line('Detailed report for '||lv_dbname||' database.') ;
dbms_output.put.line ('****************************************************************** ');
select log_mode into lv_logmode from v\$database; 
select database_role into Iv_db_role from v\$database; 
—-dbms_output.put.line('Database Name : '||lv_dbname);
—-dbms_output.put.line('Database Name : '||lv_db_role);
—-dbms_output.put.line('Database Log mode:- '||lv_dlv_logmodebname) ;
for x in ( select host name,db.name as name, instance_name, to char (startup_time, 'DD-MON—YYYY HH24:MI:SS') as started, 
logins, db.database_role as db_role, db.open_mode as open_mode, LOG_SWITCH_WAIT, INSTANCE_NUMBER, INSTANCE_ROLE, LOG MODE, version, 
FORCE_LOGGING, floor(sysdate — startup_time) || trunc( 24*((sysdate — startup_time)-trunc(sysdate — startup_time))) 
|| 'hour(s) ' || mod(trunc1440*((sysdate — startup_time)-trunc(sysdate — startup_time))), 60) ||' minute(s) '
|| mod(trunc(86400*((sysdate — startup_time)-trunc(sysdate — startup_time))), 60) ||' seconds' uptime
from gv\$instance, gv\$database db where gv_$instance.inst_id=db.inst_id ) 
loop
—dbms_output.put_line( CHR(13) || CHR(1O)); 
dbms_output.put_line('Hostname : '||x.host_name);
dbms_output.put_line('Database Name : '||x.name);
dbms_output.put_line('Database Role : '||x.db_role);
dbms_output.put_line('Open Mode : '||x.open_mode);
dbms_output.put_line('Instance # : '||x.instance_number);
dbms_output.put_line('Instance Name : '||x.instance_name);
dbms_output.put_line('Instance Role : '||x.instance_role);
dbms_output.put_line('Instance Version : '||x.version);
dbms_output.put_line('Log Mode : '||x.log_mode);
dbms_output.put_line('Force Logging : '||x.force_logging);
dbms_output.put_line('Started at : '||x.started);
dbms_output.put_line('Uptime : '||x.uptime);
--dbms_output.put_line('Standby DB Configured : YES');
--dbms_output.put_line( CHR(13) || CHR(1O)); 
end loop;
if(lv_db_role='PRIMARY')
then
select count(1) into lv_dg_config from v\$dataguard_config;
if (lv_dg_config > 1 )
then
--dbms_output.put_line( CHR(13) || CHR(1O)); 
dbms_output.put_line('Standby DB Configured : YES');
