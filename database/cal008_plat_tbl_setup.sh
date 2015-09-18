#!/bin/sh
SHELL=/bin/bash; export SHELL

### Purpose: script to provision userid and appid for FSU, ADDS, Reports
# Change History
#
# 073108   RK    Initial Version
# 111209   RK    Modified to allow multiple fsuID's, fsuLang
############

export ORACLE_HOME=/oracle
export ORACLE_SID=WEVS
export PATH=$PATH:$ORACLE_HOME/lib:$ORACLE_HOME/bin

# Using orautils to find the password
pw=`/usr/local/vtone/plat/orautils/bin/wevsbill 2>/dev/null`
if [ $? -ne 0 ]
then
	# Failed ... set to default
	pw=wevsbill
fi


###### Configurable parameters for each appid
###
appid='cal008'
appname='CA WIC'
customerid='cal'
custname='State of CA'
billingid='V0190'
serviceid='EC'
addsUploadType='XML'
addsTableNames=("cal008_zipcode_locations" "cal008_location_phrase" "cal008_marker_matrix");
fsuID=("20151104" "20151105" "20151106" "20151107" "20151108");
fsuLang=("english" "spanish" "vietnamese" "cantonese" "hmong");
fsuPhraseList=("5010-5014,5016-5017,5020-5039,5101-5103,5110-5113,5200-5201,5210,5220,5231-5237,5240-5247,5250-5252,5300-5302,5310,5320,5330-5332,5340,5350,6000-6199" "5010-5014,5016-5017,5020-5039,5101-5103,5110-5113,5200-5201,5210,5220,5231-5237,5240-5247,5250-5252,5300-5302,5310,5320,5330-5332,5340,5350,6000-6199" "5010-5014,5016-5017,5020-5039,5101-5103,5110-5113,5200-5201,5210,5220,5231-5237,5240-5247,5250-5252,5300-5302,5310,5320,5330-5332,5340,5350,6000-6199" "5010-5014,5016-5017,5020-5039,5101-5103,5110-5113,5200-5201,5210,5220,5231-5237,5240-5247,5250-5252,5300-5302,5310,5320,5330-5332,5340,5350,6000-6199" "5010-5014,5016-5017,5020-5039,5101-5103,5110-5113,5200-5201,5210,5220,5231-5237,5240-5247,5250-5252,5300-5302,5310,5320,5330-5332,5340,5350,6000-6199");
fsuUserList=("calusr:20150814" "attpm1cal:20150814" "attpmcal:20150814");

### configurable parameters ends
######

## provision userid and names nere. Make sure to put them in double quotes and they should be space separated
userid=("calusr" "attpm1cal" "attpmcal" "sr005u");
username=("CAL Test User" "Proj MGR CAL" "CAL LifeCycle Manager" "Susanta Routray");


tmpFile='/var/tmp/'${appid}'.out'
echo "" > $tmpFile;
chmod 755 ${tmpFile}

echo "tmpfile path and name is : $tmpFile"
echo "starting  provisioning configuration ... ";
echo "export ORACLE_HOME=/oracle" >> ${tmpFile};
echo "export ORACLE_SID=WEVS" >> ${tmpFile};
echo "export PATH=$PATH:$ORACLE_HOME/lib:$ORACLE_HOME/bin" >> ${tmpFile};
echo "/oracle/bin/sqlplus wevsbill/$pw@wevs <<!EOF " >> ${tmpFile};

###### Functions start from here
#####
######################
###### User Provisioning
######################
function userProv(){
echo "Provisioning User ${2} with userid: ${1}";
## there should be no space at begining for all sql commands otherwise it will result in error

echo "set termout on;" >> ${tmpFile}
echo "set trim on;" >> ${tmpFile}
echo "set heading off;" >> ${tmpFile}
echo "set feedback off;" >> ${tmpFile}

echo "UPDATE wevsbill.USER_INFO SET USERNAME='${2}' WHERE USERID='${1}';" >> ${tmpFile}
#echo "delete from wevsbill.USER_INFO where USERID = '${1}';" >> ${tmpFile}
echo "INSERT INTO wevsbill.USER_INFO (USERID, USERNAME, CUSTOMERID,  PASSWORD, LASTMODIFIED, AGINGDAYS,  USER_STATUS, INV_ATTEMPTS) VALUES ('${1}','${2}','${customerid}','',sysdate, '999','F', '0');" >> ${tmpFile}
echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',0);" >> ${tmpFile}
echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',1);" >> ${tmpFile}

###-- ADDS related
echo "INSERT INTO wevsplat.USER_ADDSWEB (USERID, APPID, SOURCE_DIR, APPNAME) VALUES ('${1}','${appid}','/usr/local/www/addsweb', '${appname}');" >> ${tmpFile}

echo "commit;" >> ${tmpFile}
}

######################
###### ADDS GUI Provisioning
######################
function addsGuiProv(){
  echo "-- ADDS GUI related" >> ${tmpFile}
  echo "INSERT INTO wevsplat.ADDS_USER_APP_TABLES(USERID,APPID,TABLE_NAME,SCHEMA_NAME) VALUES('${1}','${appid}','${2}','wevscust');" >> ${tmpFile}

}

######################
###### App related Provisioning
######################
function startProv(){
echo "updating tables Report, FSU, ADDS related platform tables for provisioning......"

echo "set termout on;" >> ${tmpFile}
echo "set trim on;" >> ${tmpFile}
echo "set heading off;" >> ${tmpFile}
echo "set feedback off;" >> ${tmpFile}

#echo "delete from wevsbill.user_apps where appid = '${appid}';" >> ${tmpFile};

echo "UPDATE wevsbill.CUST_NAME SET CUSTNAME='${custname}' WHERE CUSTOMERID='${customerid}';" >> ${tmpFile}
#echo "INSERT INTO wevsbill.CUST_NAME (CUSTOMERID,CUSTNAME,ADDS_UPLOAD_FILE_TYPE) VALUES ('${customerid}','${custname}','${addsUploadType}');" >> ${tmpFile}

echo "--  setup for all appid, userid for FSU,ADDS Reports " >> ${tmpFile}
echo "INSERT INTO wevsbill.app_name (APPID, APPNAME, PHONENUMBER, CUSTOMERID, BILLCODE) VALUES ('${appid}','${appname}','8663095849','${customerid}','${billingid}');" >> ${tmpFile}
echo "UPDATE wevsbill.app_name SET APPNAME='${appname}' WHERE APPID='${appid}';" >> ${tmpFile}
echo "INSERT INTO wevsbill.app_service (appid, serviceid) VALUES ('${appid}','${serviceid}');" >> ${tmpFile}

echo "-- ADD ROWS TO APP_REPORTS" >> ${tmpFile};
echo "set escape '\';" >> ${tmpFile}
echo "delete from wevsbill.app_reports where appid = '${appid}';" >> ${tmpFile};
echo "insert into wevsbill.app_reports(appid, reportid, reportname, reporturl) values ('${appid}',0,'Standard Report','/RPT/standard.jsp?appid=${appid}');" >> ${tmpFile};
echo "insert into wevsbill.app_reports(appid, reportid, reportname, reporturl) values ('${appid}',1,'CA WIC Call Path Analysis Report','/acweb/ReportInfoServlet?extrainfo=parameters/cal008_SdEdSort');" >> ${tmpFile};
echo "insert into wevsbill.app_reports(appid, reportid, reportname, reporturl) values ('${appid}',1,'CA WIC Zip Code By Location Report','/acweb/ReportInfoServlet?extrainfo=parameters/cal008_ZipLoc');" >> ${tmpFile};

echo "-- ADD ROWS TO ACTUATE_REPORTS" >> ${tmpFile};
echo " delete from wevsbill.actuate_reports where appid = '${appid}';" >> ${tmpFile};
echo "insert into wevsbill.actuate_reports(appid, reportid, actuserid, executablename, reporttitle) values ('${appid}',1,'rptuser','/rptuser/cal008_CPA.rox', 'CA WIC Call Path Analysis Report');" >> ${tmpFile};
echo "insert into wevsbill.actuate_reports(appid, reportid, actuserid, executablename, reporttitle) values ('${appid}',1,'rptuser','/rptuser/cal008_ZipLoc.rox', 'CA WIC Zip Code By Location Report');" >> ${tmpFile};

echo "commit;" >> ${tmpFile};
} ## ends start function

#############################
###########-- FSU related
#############################

function fsuUserProv(){
  echo "INSERT INTO wevsplat.FSU_ID (USERID, CUSTID) VALUES('${1}', '${2}');" >> ${tmpFile};
} 

###
function fsuIdProv(){
  echo "INSERT INTO wevsplat.CUST_FSU VALUES('${1}','${appid}','${2}');" >> ${tmpFile};
}

###
function fsuPhraseProv(){
  echo "INSERT INTO wevsplat.PHR_FSU (CUSTID, PHRID, LASTMODIFIED, PHR_DESC, PHR_SIZE) VALUES ('${1}','${2}',null,null,null);" >> ${tmpFile};
}

############ ALL Function Definitions Ends ###############

### call startProv function from here and then call userProv, then addsGuiProv and then fsuProv related calls.
####
startProv;

#echo " name arry elementlen: ${#userid[@]}";
#echo "1st name: ${userid[0]} ,  2nd name: ${userid[1]}";

for ((i=0; i < ${#userid[@]}; i++ ))
 do
  # echo " id: ${userid[$i]} and name: ${username[$i]} ";
   userProv "${userid[$i]}" "${username[$i]}";
 done

for ((i=0; i < ${#userid[@]}; i++ ))
 do
  echo "-- ADDS GUI related" >> ${tmpFile}
  # echo " id: ${userid[$i]} and name: ${username[$i]} ";
  for (( j=0; j < ${#addsTableNames[@]}; j++ ))
    do
      addsGuiProv ${userid[$i]} ${addsTableNames[j]};
    done
 done

### now call fsu provisioning related functions from here
echo "-- FSU ID Language provisioning" >> ${tmpFile};
for ((i=0; i < ${#fsuID[@]}; i++))
do
    #echo "fsuIdProv values: ${fsuID[$i]} for ${fsuLang[$i]}";
    fsuIdProv "${fsuID[$i]}" "${fsuLang[$i]}";
done

echo "-- FSU User related" >>  ${tmpFile};
for ((i=0; i < ${#fsuUserList[@]}; i++))
do
    str=(${fsuUserList[i]/:/ });
    #echo "fsuUserProv values:${str[0]} with custid:${str[1]} ";
    fsuUserProv "${str[0]}" "${str[1]}";
done

echo " -- FSU phrases ">> ${tmpFile};
for ((i=0; i < ${#fsuID[@]}; i++))
do
      IFS=","
      str=(${fsuPhraseList[i]});
      for (( k=0; k< ${#str[@]}; k++ ))
        do
          #echo "for fsuid:" ${fsuID[$i]} " got list as:" ${str[$k]};
          IFS="-"
          num=(${str[$k]});
          start=${num[0]};
          end=${num[1]};
          if [[ "$end" = "" ]]; then
            end=${start};
          fi
          #echo "for fsuid:" ${fsuID[$i]} " start:" ${start}  "and end:" ${end};
          while [[ $start -le $end ]]
            do
              fsuPhraseProv ${fsuID[$i]} $start;
              start=`expr $start + 1`
            done
        done
done

echo "commit;" >> ${tmpFile}

#############################
###########-- Voice Capture related
#############################

echo "insert into wevsplat.transcr_apps (appid, descr) values ('cal008', 'CAL009 Voice Capture');" >> ${tmpFile}

echo "insert into wevsplat.transcr_services (service, descr) values ('Workers_Comp', 'CAL009 Voice Capture');" >> ${tmpFile}

echo "insert into wevsplat.transcr_app_services (appid, service) values ('cal008', 'English');" >> ${tmpFile}

echo "insert into wevsplat.transcr_app_services (appid, service) values ('cal008', 'Spanish');" >> ${tmpFile}

echo "insert into wevsplat.transcr_users (userid) values ('calusr');" >> ${tmpFile}

echo "insert into wevsplat.transcr_user_apps (appid,userid) values ('cal008','calusr');" >> ${tmpFile}

echo "commit;" >> ${tmpFile}

echo "!EOF" >> ${tmpFile}

/oracle/bin/sqlplus wevsbill/$pw@wevs <<!EOF
!${tmpFile}
!EOF

	
echo " cal008 FSU/ADDS/Reports user provisioning steps are done...."
