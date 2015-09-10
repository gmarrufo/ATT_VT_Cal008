/*******************************************************************************
 * FileName		:  ChiScan.js
 * Description  :  This file contains all the java scripts for CHISCAN 
 ******************************************************************************/


function ChiScanExit(disp, type, num, dest)
{
      if(disp=='Transfer')
       {
		   return "VT_LOG:CallOutcome:Disposition=TRANSFER:Exit_Type="+type
                       +":Destination_Name="+dest
                       +":Destination_Number="+num;
	 }
       else if(disp=='Hangup')
       {
       	   return "VT_LOG:CallOutcome:Disposition=HANGUP:Exit_Type="+type
                       +":Destination_Name=Hangup";
       }
	 else
	 {
		   return "VT_LOG:CallOutcome:Disposition=ENDCALL:Exit_Type="+type
                       +":Destination_Name=Disconnect";
	 }
}

function ChiScanBegin(app_name, app_id, ani, dnis, date_last_modified, app_version)
{
    return "VT_LOG:Begin:Application_Name=" + app_name + ":Application_ID=" + app_id + ":Version=" + app_version + ":" +
        "DateLastModified=" + date_last_modified + ":ANI="+ ani +":DNIS=" + dnis;
}

function moduleStart(module)
{
	return "VT_LOG:ModuleStart:Module="+module;
}

function dataAccess(operation, status, result, inpList, outList)
{
	return "VT_LOG:HostAccess:Operation=" +operation+":Status="+status+":Result="+result+":Input="+inpList+":Output="+outList;
}

function eventChi(code) {

	return "VT_LOG:Event:Code="+code;
}
function callerinputnl(status,gr_name,asr_transcript, asr_op, score, interpretation, nl_score, ip_mode, bargein, uttfilename)
{
  var logstr = 'VT_LOG:Response';
  logstr +=':Status=' + status;
  logstr +=':ASR_GrammarName=' + gr_name;
  logstr +=':ASR_Transcript=' + asr_transcript;
  logstr +=':ASR_Output=' + asr_op;
  logstr +=':ASR_Score=' + score;
  logstr +=':Interpretation=' + interpretation;
  logstr +=':NL_Score=' + nl_score;
  logstr +=':InputMode=' + ip_mode;
  logstr +=':Bargein=' + bargein;
  logstr +=':Uttfile=' + uttfilename;

  return logstr;
}

function callerinput(gr_name,asr_transcript, asr_op, score, interpretation, ip_mode, bargein, uttfilename)
{
  var logstr = 'VT_LOG:Response';
  logstr +=':Status=success';
  logstr +=':ASR_GrammarName=' + gr_name;
  logstr +=':ASR_Transcript=' + asr_transcript;
  logstr +=':ASR_Output=' + asr_op;
  logstr +=':ASR_Score=' + score;
  logstr +=':Interpretation=' + interpretation;
  logstr +=':NL_Score=NA';
  logstr +=':InputMode=' + ip_mode;
  logstr +=':Bargein=' + bargein;
  logstr +=':Uttfile=' + uttfilename;

  return logstr;
}

function callerinputnm(gr_name,asr_transcript, asr_op, score, interpretation, ip_mode, bargein, uttfilename)
{
  var logstr = 'VT_LOG:Response';
  logstr +=':Status=nomatch';
  logstr +=':ASR_GrammarName=' + gr_name;
  logstr +=':ASR_Transcript=' + asr_transcript;
  logstr +=':ASR_Output=' + asr_op;
  logstr +=':ASR_Score=' + score;
  logstr +=':Interpretation=' + interpretation;
  logstr +=':NL_Score=NA';
  logstr +=':InputMode=' + ip_mode;
  logstr +=':Bargein=' + bargein;
  logstr +=':Uttfile=' + uttfilename;

  return logstr;
}

function callerinputni(gr_name)
{
  var logstr = 'VT_LOG:Response';
  logstr +=':Status=noinput';
  logstr +=':ASR_GrammarName=' + gr_name;
  logstr +=':ASR_Transcript=undefined';
  logstr +=':ASR_Output=undefined';
  logstr +=':ASR_Score=undefined';
  logstr +=':Interpretation=undefined';
  logstr +=':NL_Score=NA';
  logstr +=':InputMode=undefined';
  logstr +=':Bargein=undefined';
  logstr +=':Uttfile=undefined';

  return logstr;
}

/*****
function callerinput(interpretation) {

  return "VT_LOG:Response:Interpretation=" + interpretation;

}
*****/

function callerinputsecure(status,gr_name, score, interpretation, ip_mode, bargein ) {
  var logstr = 'VT_LOG:Response';
  logstr +=':Status=' + status;
  logstr +=':ASR_GrammarName=' + gr_name;
  logstr +=':ASR_Transcript=MASKED';
  logstr +=':ASR_Output=MASKED';
  logstr +=':ASR_Score=' + score;
  logstr +=':Interpretation=' + interpretation;
  logstr +=':InputMode=' + ip_mode;
  logstr +=':Bargein=' + bargein;

  return logstr;
}

/****************************************************************
        function to return the standard logging format
****************************************************************/
function LogFormat()
{
        return appid + "." + vxmlFileName + "." + formName;
}

