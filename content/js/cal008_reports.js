/************************************************************************
 * FileName             :  cal006_reports.js                            *
 * Description          :  javascript helper functions needed in        *
 *                         to build report SQLs                         *
 ************************************************************************/
/*********************************************************
*        Report Globals Variable                         *
*********************************************************/
/********************************************************
*   Constants  for SQL query construction
*********************************************************/
var SQL_STR_TO_STR_DELIM        = '\',\'';
var SQL_STR_TO_NUM_DELIM        = '\',';
var SQL_NUM_TO_NUM_DELIM        = ',';
var SQL_NUM_TO_STR_DELIM        = ',\'';
var SQL_DATE_FORMAT    	        = '\', \'yyyy-mm-dd hh24:mi:ss\')';

/*******************************************************************************
 * Peg a marker and append it to a marker string This results in a | separated
 * marker string to be used for logging and reports.
 ******************************************************************************/
function pegMarker(mList, marker) {
	mList = mList + marker + "|";
	return (mList);
}

/************************************************************/
function removeSpaces(strInput)
{
  var retStr = "";

  if (strInput.length == 0)
    return strInput;

  retStr =  strInput.replace(/ /g,'');

  return retStr;
}

/***********************************************************/
function adjusted(intVal) {
		var strVal = "";

		if (intVal < 10) 
			strVal = "0" + intVal;
		else
			strVal = intVal;
				
		return strVal;
}

/************************************************************/
function aggr (mlist) {
 var Mstr = '';
 if (ISNULL(mlist))
	return Mstr;

 var tmpArr = mlist.split('|');
 var tmpArr1 = new Object();
 for (var i = 0; i < tmpArr.length; i++) {
	if(!ISNULL(tmpArr[i])){
 		tmpArr1[tmpArr[i]]=0;
	}
 }
 for (var j = 0; j < tmpArr.length; j++) {
	if(!ISNULL(tmpArr[j])){
 		tmpArr1['' + tmpArr[j]]++;
	}
 }
 
 for( x in tmpArr1) {
 	Mstr += '' + x + ':' + tmpArr1[x] + '|';
 }
return Mstr;
 
}

/************************************************************************************/
function buildCallActivitySQL(callid, startTime, endTime, lastMarker, markerString, termType, transferRtn){

  	var retCallActivitySQL = '';
	var finalMarkerStr     = '';
	var lMarkerString      = "";

	lMarkerString  = removeSpaces(markerString);

	
	finalMarkerStr = lMarkerString;

	if(markerString.lastIndexOf('M') > 0){
		lastMarker = lMarkerString.substr(markerString.lastIndexOf('M'), 8);
		if(lastMarker[lastMarker.length - 1] == '|'){
			lastMarker = lastMarker.substr(lastMarker,(lastMarker.length)-1);
		}
	}
	else{
		lastMarker = 'M000-00';
	}

	if(finalMarkerStr == '|'){
		MarkerStrWithCnt = '|M100-00:1|';
	}
	else{
		MarkerStrWithCnt = '|' + aggr(finalMarkerStr); // Output in the format |<Marker1>:<count>|<Marker2>:<count>|
	}
 	
  	retCallActivitySQL = 'insert into wevscust.cal006_call_activity (CALL_ID, START_TIME, END_TIME, ANI, DNIS, LAST_MARKER, MARKER_STRING, TERMINATION_TYPE, TRANSFER_RTN) values(' +
			'\'' + callid + '\',' +
			'to_date(\''+ startTime + SQL_DATE_FORMAT + 
			', to_date(\'' + endTime + SQL_DATE_FORMAT + 
			',\'' + cdh_ANI +
			SQL_STR_TO_STR_DELIM + cdh_DNIS +
			SQL_STR_TO_STR_DELIM + lastMarker +
			SQL_STR_TO_STR_DELIM + MarkerStrWithCnt +
			SQL_STR_TO_STR_DELIM + termType +
			SQL_STR_TO_STR_DELIM + transferRtn + '\')'

	
  	return retCallActivitySQL;
} 
