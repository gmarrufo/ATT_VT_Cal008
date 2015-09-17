ORACLE_HOME=/oracle

export ORACLE_HOME
PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME/lib
export PATH

echo "Uninstalling xyz003 FSU, ADDS, Voice Capture, WCR-UC, Reports and dropping app tables"
echo "Output is in /tmp/xyz003_db_uninstall.log"

pw=`/usr/local/vtone/plat/orautils/bin/wevscust 2>/dev/null`
if [ $? -ne 0 ]
then
      # Failed ... set to default
      pw=wevscust
fi
retval=`sqlplus -s wevscust/$pw@wevs <<!EOF

spool /tmp/xyz003_db_uninstall.log

-- FSU Backout Provisioning
DELETE FROM WEVSPLAT.PHR_FSU WHERE CUSTID = '10242012';
DELETE FROM WEVSPLAT.FSU_ID WHERE CUSTID = '10242012';
DELETE FROM WEVSPLAT.CUST_FSU WHERE CUSTID = '10242012';

-- ADDS Backout Provisioning
delete from wevsplat.USER_ADDSWEB where appid='xyz003';
delete from wevsplat.adds_register where appid='xyz003';
delete from wevsplat.ADDS_USER_APP_TABLES where appid='xyz003';

-- Voice Capture Backout Provisioning
delete from wevsplat.TRANSCR_FILES where APPID = 'xyz003';
delete from wevsplat.transcr_app_services where appid = 'xyz003';
--delete from wevsplat.transcr_user_apps where appid = 'xyz003';
delete from wevsplat.transcr_services where service = 'xyz003feedback';
--delete from wevsplat.transcr_users where userid = 'xyz3usr';
delete from wevsplat.transcr_apps where appid = 'xyz003';

-- WCR_UC Backout Provisioning
--delete from wevsplat.wcrweb_user_apps where APPID='xyz003';
delete from wevsplat.VT_WCR_UC_CONFIG where APPID='xyz003';

-- Reports Backout Provisioning
DELETE FROM WEVSBILL.APP_REPORTS WHERE APPID = 'xyz003';
--DELETE FROM WEVSBILL.ACTUATE_REPORTS WHERE APPID = 'xyz003';

-- App Backout 
DELETE FROM WEVSBILL.user_apps WHERE APPID='xyz003';
DELETE FROM WEVSBILL.user_info WHERE USERID='xyz3usr';

delete from wevsbill.app_service where appid='xyz003';
delete from wevsbill.app_name where appid='xyz003';
--delete from wevsbill.CUST_NAME where CUSTOMERID='xyz';

commit;

-- Drop app tables
drop table WEVSCUST.XYZ003_CLUB;
drop table WEVSCUST.XYZ003_OB_CALLDATA;
drop table WEVSCUST.XYZ003_OB_ALARM;
drop table WEVSCUST.XYZ003_CONFIG;

commit;

--DROP ALL THE FUNCTIONS AND TRIGGERS
DROP TRIGGER wevscust.xyz003_ob_calldata_insert;
DROP FUNCTION wevscust.xyz003_RandomNumber;
DROP FUNCTION wevscust.xyz003_ReplaceSpecialChars;
DROP FUNCTION wevscust.xyz003_CleanupPhone;
--DROP PROCEDURE wevscust.xyz003_CleanUp;

commit;

spool off
!EOF`

exit 0

