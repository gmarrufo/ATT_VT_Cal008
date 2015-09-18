# Using orautils to find the password
pw=`/usr/local/vtone/plat/orautils/bin/wevscust 2>/dev/null`
if [ $? -ne 0 ]
then
	# Failed ... set to default
	pw=wevscust
fi

sqlplus wevscust/$pw@wevs <<!EOF
spool /var/tmp/cal008_database_bak.log

  drop table cal008_zipcode_locations;
  drop table cal008_location_phrase;
  commit;

  delete from wevsbill.user_apps where APPID='cal008';
  delete from wevsplat.adds_register2 where APPID='cal008';
  delete from wevsplat.user_addsweb where APPID='cal008';
  delete from wevsplat.adds_user_app_tables where APPID='cal008';
  commit;
  delete from wevsbill.app_reports where APPID='cal008';
  delete from wevsbill.actuate_reports where APPID='cal008';
  commit;

  delete from wevsplat.phr_fsu where CUSTID in ('20151104', '20151105', '20151106', '20151107', '20151108');
  commit;
  delete from wevsplat.fsu_id where CUSTID in ('20151104', '20151105', '20151106', '20151107', '20151108');
  commit;

  delete from wevsplat.cust_fsu where APPID='cal008';
  delete from wevsbill.app_service where APPID='cal008';
  delete from wevsbill.app_name where APPID='cal008';
  commit;

spool off


!EOF
