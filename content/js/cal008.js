/*****************************************************************
	Helper function to check a string for null/empty value
******************************************************************/
var i;

function ISNULL(strValue)
{
	if (typeof strValue == 'undefined' || typeof strValue == undefined)
		return true;
	else if ("" == strValue || " " == strValue || 'null' == strValue || 'NULL' == strValue || undefined == strValue || 'undefined' == strValue)
		return true;
	else
		return false;
}

/*****************************************************************
	Helper function get Phoneweb IP Address
*****************************************************************/
function getPWServerName()
{
	if (ISNULL(Phoneweb)){
		if (session.com.voicegenie.telephone.primarychan.length == 22){
			Phoneweb = _VGGetInfo('host_ip');
		}
		else{
			Phoneweb = session.com.voicegenie.instance.myself;
			if((i = Phoneweb.indexOf("$")) != -1 ) {
				Phoneweb = Phoneweb.substring( 0, i);
			}
		}
	}

  return Phoneweb;
}

/*****************************************************************/
/*** This function add spaces in between chars of a userid *******/
/*** Ex: aa1234 gets converted to a a 1 2 3 4               *******/
/*****************************************************************/
function addSpaces(name) {
        var namestr = "";

        for (var i=0; i<name.length; i++) {
         namestr=namestr+" "+name.charAt(i);
        }
return namestr;
}

/****************************************************************
 * ValidatePhone - The requirement is 10 digit are valid as long
 * as they are not all the same digits.
 ***************************************************************/
function ValidatePhone(number) {
    // remove non-digits
    var re=new RegExp('[^0-9]','g');
    var tempNum = (number+'').replace(re,'');

    // remove if the whole number is same digit repeated
    re=new RegExp('^0+$|^1+$|^2+$|^3+$|^4+$|^5+$|^6+$|^7+$|^8+$|^9+$','');
    tempNum=tempNum.replace(re,'');
 
    if (tempNum.length == 10 )
       return true;
    else
       return false;
}

/****************************************************************
        Global function to generate default alarm ids and url
****************************************************************/
function getAlarmUrl(sevLevel, appid, message, alarmid) {
                var url = "/PlatServlets/GenAlarm?";
                url += "appid=" + appid + "&";
                url += "sevLevel=" + sevLevel + "&";
                url += "alarmid=" + alarmid + "&";
                url += "outputType=wave&";
                url += "errorMessage=" + message ;
                return url;
}

/****************************************************************
        Global function to calculate the call duration 
****************************************************************/
function CalcCDHDuration(in_start, in_end) {
  // convert start time to seconds
  if (in_start.length != 19) return -1;

  var my_startyear   = in_start.substring(0,4);
  var my_startmonth  = in_start.substring(5,7);
  var my_startday    = in_start.substring(8,10);
  var my_starthour   = in_start.substring(11,13);
  var my_startmin    = in_start.substring(14,16);
  var my_startsec    = in_start.substring(17,19);

  if (isNaN(my_startyear))  return -1;
  if (isNaN(my_startmonth)) return -1;
  if (isNaN(my_startday))   return -1;
  if (isNaN(my_starthour))  return -1;
  if (isNaN(my_startmin))   return -1;
  if (isNaN(my_startsec))   return -1;

  var my_startdate = new Date (my_startyear, my_startmonth - 1, my_startday, my_starthour, my_startmin, my_startsec, 0);

  var my_startutc = my_startdate.getTime() / 1000;

  // convert end time to seconds
  if (in_end.length != 19) return -1;

  var my_endyear  = in_end.substring(0,4);
  var my_endmonth = in_end.substring(5,7);
  var my_endday   = in_end.substring(8,10);
  var my_endhour  = in_end.substring(11,13);
  var my_endmin   = in_end.substring(14,16);
  var my_endsec   = in_end.substring(17,19);

  if (isNaN(my_endyear))  return -1;
  if (isNaN(my_endmonth)) return -1;
  if (isNaN(my_endday))   return -1;
  if (isNaN(my_endhour))  return -1;
  if (isNaN(my_endmin))   return -1;
  if (isNaN(my_endsec))   return -1;

  var my_enddate = new Date (my_endyear, my_endmonth - 1, my_endday, my_endhour, my_endmin, my_endsec, 0);

  var my_endutc = my_enddate.getTime() / 1000;
  var duration;
  var minute;
  var sec;

  duration = Math.abs(my_endutc - my_startutc);
  minute = Math.floor(duration/60);
  sec = duration - minute * 60;

  return (minute + ":" + zeroFilled(sec));

}

function zeroFilled(inValue) {
    if (inValue > 9)
      return "" + inValue;
    else
      return "0" + inValue;
}

//******************************************

