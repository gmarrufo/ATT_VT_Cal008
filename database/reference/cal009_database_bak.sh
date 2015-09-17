# Using orautils to find the password
pw=`/usr/local/vtone/plat/orautils/bin/wevscust 2>/dev/null`
if [ $? -ne 0 ]
then
	# Failed ... set to default
	pw=wevscust
fi

sqlplus wevscust/$pw@wevs <<!EOF
spool /var/tmp/cal009_database_bak.log

  drop table cal009_sum_cpa;
  drop table cal009_marker_matrix;
  drop table cal009_zipcode_mapping;
  drop table cal009_call_activity;
  commit;

  delete from wevsbill.user_apps where APPID='cal009';
  delete from wevsplat.adds_register2 where APPID='cal009';
  delete from wevsplat.adds_register where APPID='cal009';
  delete from wevsplat.user_addsweb where APPID='cal009';
  delete from wevsplat.adds_user_app_tables where APPID='cal009';
  commit;
  delete from wevsbill.app_reports where APPID='cal009';
  delete from wevsbill.actuate_reports where APPID='cal009';
  commit;

  delete from wevsplat.transcr_files where appid='cal009';
  delete from wevsplat.transcr_user_apps where appid='cal009';
  delete from wevsplat.transcr_app_services where appid='cal009';
  delete from wevsplat.transcr_services where descr='CAL009 Voice Capture';
  delete from wevsplat.transcr_apps where appid='cal009';
  commit;

  delete from wevsplat.phr_fsu where CUSTID='20150814';
  commit;
  delete from wevsplat.fsu_id where CUSTID='20150814';
  commit;

  delete from wevsplat.cust_fsu where APPID='cal009';
  delete from wevsbill.app_service where APPID='cal009';
  delete from wevsbill.app_name where APPID='cal009';
  commit;

spool off


!EOF
