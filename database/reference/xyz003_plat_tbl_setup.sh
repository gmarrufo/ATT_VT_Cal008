#!/bin/sh
SHELL=/bin/bash; export SHEL

### Purpose: script to provision userid and appid for FSU, ADDS, Reports
############

export ORACLE_HOME=/oracle
export ORACLE_SID=WEVS
export PATH=$PATH:$ORACLE_HOME/lib:$ORACLE_HOME/bin


###### Configurable parameters for each appid
### appname - max 20 chars
###
appid='xyz003'
appname='XYZ003 Outbound'
phonenum='8002224357'
customerid='xyz'
billingid='V0157'
serviceid='EC'
addsUploadType='CHKDBU'
addsTableNames=("XYZ003_CLUB");
fsuID=("10242012");
fsuLang=("english");
fsuPhraseList=("5000,5001,5002,5005,5006,5007,5008,5010,5011,5012,5015,5020,5021,5022,5031,5032,5033,5100,5101,8001,8002,8003");
fsuUserList=("xyz3usr:10242012" "attpm1xyz:10242012" "attpmxyz:10242012");

### configurable parameters ends
######

## provision userid and names nere. Make sure to put them in double quotes and they should be space separated
userid=("xyz3usr" "attpm1xyz" "attpmxyz");
username=("XYZ003 User" "Proj Mgr XYZ" "LifeCycleMgr XYZ");


### DO Not change anything below this line  ####

tmpFile='/tmp/'${appid}'.out'

echo "tmpfile path and name is : $tmpFile"
echo "export ORACLE_HOME=/oracle" > ${tmpFile};
echo "export ORACLE_SID=WEVS" >> ${tmpFile};
echo "export PATH=$PATH:$ORACLE_HOME/lib:$ORACLE_HOME/bin" >> ${tmpFile};
pw=`/usr/local/vtone/plat/orautils/bin/wevsbill 2>/dev/null`
if [ $? -ne 0 ]
then
      # Failed ... set to default
      pw=wevsbill
fi
echo "/oracle/bin/sqlplus wevsbill/$pw@wevs <<!EOF " >> ${tmpFile};

chmod 755 ${tmpFile}

###### Functions start from here
#####
######################
###### User Provisioning
######################
function userProv(){
echo "Provisioning User ${2} with appid: ${1}";
## there should be no space at begining for all sql commands otherwise it will result in error

echo "set termout on;" >> ${tmpFile}
echo "set trim on;" >> ${tmpFile}
echo "set heading off;" >> ${tmpFile}
echo "set feedback off;" >> ${tmpFile}

echo "INSERT INTO wevsbill.USER_INFO (USERID, USERNAME, CUSTOMERID,  PASSWORD, LASTMODIFIED, AGINGDAYS,  USER_STATUS, INV_ATTEMPTS) VALUES ('${1}','${2}','${customerid}','',sysdate, '90','F', '0');" >> ${tmpFile}
echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',0);" >> ${tmpFile}
#echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',1);" >> ${tmpFile}
#echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',2);" >> ${tmpFile}
#echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',3);" >> ${tmpFile}
#echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',4);" >> ${tmpFile}
#echo "INSERT INTO wevsbill.USER_APPS (USERID, APPID, REPORTID) VALUES ('${1}','${appid}',5);" >> ${tmpFile}

###-- ADDS related
echo "INSERT INTO wevsplat.USER_ADDSWEB (USERID, APPID, SOURCE_DIR, APPNAME) VALUES ('${1}','${appid}','/usr/local/www/addsweb', '${appname}');" >> ${tmpFile}

###-- WCR related
#echo "INSERT INTO wevsplat.wcrweb_user_apps values ('${1}','${appid}');" >> ${tmpFile}

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

echo "--  setup for all appid, userid for FSU,ADDS Reports " >> ${tmpFile}
echo "delete from wevsbill.app_name where APPID='${appid}';" >> ${tmpFile}
echo "INSERT INTO wevsbill.app_name (APPID, APPNAME, PHONENUMBER, CUSTOMERID, BILLCODE) VALUES ('${appid}','${appname}','${phonenum}','${customerid}','${billingid}');" >> ${tmpFile}

echo "INSERT INTO wevsbill.app_service (appid, serviceid) VALUES ('${appid}','${serviceid}');" >> ${tmpFile}
#echo "delete from wevsbill.CUST_NAME where CUSTOMERID='${customerid}';" >> ${tmpFile}
#echo "INSERT INTO wevsbill.CUST_NAME (CUSTOMERID,CUSTNAME,ADDS_UPLOAD_FILE_TYPE) VALUES ('${customerid}','${appname}','${addsUploadType}');" >> ${tmpFile}

echo "-- ADD ROWS TO APP_REPORTS" >> ${tmpFile};
echo "set escape '\';" >> ${tmpFile}
echo "-- delete from wevsbill.app_reports where appid = '${appid}';" >> ${tmpFile};
echo "insert into wevsbill.app_reports(appid, reportid, reportname, reporturl) values ('${appid}',0,'Standard Report','/RPT/standard.jsp?appid=${appid}');" >> ${tmpFile};

#echo "-- insert into wevsbill.app_reports(appid, reportid, reportname, reporturl) values ('${appid}',1,'Daily Summary','/acweb/ReportInfoServlet?extrainfo=parameters/xyz003_SdEd');" >> ${tmpFile};

echo "insert into wevsplat.VT_WCR_UC_CONFIG (APPID, WCR_PERCENT, UC_PERCENT, APP_DATA) values ('${appid}',1.0,5.0,'');" >> ${tmpFile};

#echo "-- ADD ROWS TO ACTUATE_REPORTS" >> ${tmpFile};
#echo "-- delete from wevsbill.actuate_reports where appid = '${appid}';" >> ${tmpFile};
#echo "-- insert into wevsbill.actuate_reports(appid, reportid, actuserid, executablename, reporttitle) values ('${appid}',1,'rptuser','/rptuser/xyz003_DailySummary.rox', 'Daily Summary Report');" >> ${tmpFile};

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
  echo "INSERT INTO wevsplat.PHR_FSU (CUSTID, PHRID, LASTMODIFIED, PHR_DESC, PHR_SIZE) VALUES ('${1}','${2}',null,null,null);" >> ${tmpFile}
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
echo "-- FSU ID -Language provisioning" >> ${tmpFile};
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
         # echo "for fsuid:" ${fsuID[$i]} " got list as:" ${str[$k]};
	  IFS="-"
          num=(${str[$k]});
          start=${num[0]};
          end=${num[1]};
          if [[ "$end" = "" ]]; then
            end=${start};
          fi
         # echo "for fsuid:" ${fsuID[$i]} " start:" ${start}  "and end:" ${end};
          while [[ $start -le $end ]] 
            do
              fsuPhraseProv ${fsuID[$i]} $start;
              start=`expr $start + 1`
            done	
        done
done
echo "commit;" >> ${tmpFile}
echo "!EOF" >> ${tmpFile}

pw=`/usr/local/vtone/plat/orautils/bin/wevsbill 2>/dev/null`
if [ $? -ne 0 ]
then
      # Failed ... set to default
      pw=wevsbill
fi
/oracle/bin/sqlplus wevsbill/$pw@wevs <<!EOF
!${tmpFile}
!EOF

	
echo "Database updates are done...."
