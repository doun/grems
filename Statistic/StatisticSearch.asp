<%Response.Expires=-1%>
<script language=javascript src="../library/date.js"></script>
<script language=javascript>
function checkSearch(){
	if(document.form.Scale.value!=="0"){
		if(document.form.Scale_value.value==""){
		alert("����д����");
		document.form.Scale_value.focus();
		return false;
		}
		
	}
	if(document.form.person.value!=="0"){
		if(document.form.pname.value==""){
		alert("����д��ԱID��");
		document.form.pname.focus();
		return false;
		}
	}
	if(document.form.TimeType.value!=="0"){
		if(document.form.Time.value=="" | document.form.EndTime.value==""){
		alert("����д��ѯʱ��");
		document.form.Time.focus();
		return false;
		}
	}
	
}

function windowonload(){
	new oDateTime("dateTime")
} 

windowonload()
</script>
<script language=VBscript>
'function checkSearch()
'	dim sID,releaseType,Scale_info,fh,Scale_value,person,pname,TimeType,Time
'	sID=trim(window.sID.value) 
'	releaseType=trim(window.releaseType.value)
'	Scale_info=trim(window.Scale.value)
'	fh=trim(window.fh.value)
'	Scale_value=trim(window.Scale_value.value)
'	person=trim(window.person.value)
'	pname=trim(window.pname.value)
'	TimeType=trim(window.TimeType.value)
'	Time=trim(window.Time.value)
	
'	sendxml="<?xml version='1.0'?>"&_
'	"<searchinfo>"&_
'	"	<sID>"&sID&"</sID>"&_
'	"	<releaseType>"&releaseType&"</releaseType>"&_
'	"	<Scale_info>"&Scale_info&"</Scale_info>"&_
'	"	<fh>"&fh&"</fh>"&_
'	"	<Scale_value>"&Scale_value&"</Scale_value>"&_
'	"	<person>"&person&"</person>"&_
'	"	<pname>"&pname&"</pname>"&_
'	"	<TimeType>"&TimeType&"</TimeType>"&_
'	"	<Time>"&Time&"</Time>"&_
'	"</searchinfo>"
	
	'alert(sendxml)
'	set XMLHTTP=createobject("microsoft.xmlhttp")
'	XMLHTTP.open "post","http://lwserver0/grems/Statistic/StatisticSearch.asp",false
'	XMLHTTP.send sendxml
'	checkSearch=true
'end function
</script>
<%	
'set req=server.CreateObject("Microsoft.XMLDOM")
'req.async=false
'req.load(Request) 
'Response.End 
userid=trim(Request.Form("userid"))

dim sID,releaseType,Scale_info,fh,Scale_value,person,pname,TimeType,Time,EndTime
sID=trim(Request.Form("sID"))
releaseType=trim(Request.Form("releaseType"))
Scale_info=trim(Request.Form("Scale"))
fh=trim(Request.Form("fh"))
Scale_value=trim(Request.Form("Scale_value"))
person=trim(Request.Form("person"))
pname=trim(Request.Form("pname"))
TimeType=trim(Request.Form("TimeType"))
Time=trim(Request.Form("Time"))
EndTime=trim(Request.Form("EndTime"))'Add the condition of EndTime
submit=trim(Request.Form("submit"))
if TimeType<>"0" and TimeType<>"" and Time<>"" and submit<> "" then
	if not ( isdate(Time) or isdate(EndTime) ) then	 'EndTime
		Response.Write "<script language=javascript>"
		Response.Write "alert('�밴��ʽ xxxx-xx-xx ��д����');"
		Response.Write "window.history.go(-1);"
		Response.Write "</script>"
		Response.End 
	else
		select case TimeType
			case "Release_End_TIME"
				Timestr="�ŷ�ʱ��"
			case "Scale_Scale_DATE"
				Timestr="����ʱ��"
			case "Sample_Sample_DATE"
				Timestr="ȡ��ʱ��"
			case "Confirm_Confirm_DATE"
				Timestr="��׼ʱ��"
			case "APPLY_APPLY_DATE"
				Timestr="����ʱ��"
		end select
		session("selectstr1")=""&Timestr&" "&year(Time)&"��"&month(Time)&"��"&day(Time)&"��"
		session("selectstr1")=session("selectstr1")&" �� "&year(EndTime)&"��"&month(EndTime)&"��"&day(EndTime)&"��"	'EndTime
		syear1=year(Time)
		smonth1=right("0"&month(Time),2)
		sday1=right("0"&day(Time),2)
		'Time=DateAdd("d",1,Time)
		'syear2=year(Time)
		'smonth2=right("0"&month(Time),2)
		'sday2=right("0"&day(Time),2)
		'--------------------------------
		'STRsyear1=year(EndTime)
		'STRsmonth1=right("0"&month(EndTime),2)
		'STRsday1=right("0"&day(EndTime),2)
		syear2=year(EndTime)
		smonth2=right("0"&month(EndTime),2)
		sday2=right("0"&(day(EndTime)+1),2)
		
		'STRTime=DateAdd("d",1,EndTime)
		'STRsyear2=year(Time)
		'STRsmonth2=right("0"&month(EndTime),2)
		'STRsday2=right("0"&day(EndTime),2)
		'--------------------------------
		'sqlStr1=" And "&TimeType&"< to_date('"&syear2&"-"&smonth2&"-"&sday2&"','YYYY-MM-DD') And "&TimeType&"> to_date('"&syear1&"-"&smonth1&"-"&sday1&"','YYYY-MM-DD')"
		
		'sqlStr1=" And "&TimeType&"< '"&syear2&"-"&smonth2&"-"&sday2&"' And "&TimeType&"> '"&syear1&"-"&smonth1&"-"&sday1&"'"
		session("sqlStr1")=" And "&TimeType&"< '"&syear2&"-"&smonth2&"-"&sday2&"' And "&TimeType&">= '"&syear1&"-"&smonth1&"-"&sday1&"'"
	end if
elseif (TimeType="0" or TimeType="" or Time="") and submit<> "" then
	session("selectstr1")=""
	session("sqlStr1")=""
	'û�в�ѯ����������ʾ����ļ�¼
	'if submit="" then
	'if TimeType="0" then
	'selectstr="�ŷ�ʱ�� "&year(date())&"��"&month(date())&"��"&day(date())&"�� �� "&year(date())&"��"&month(date())&"��"&day(date())&"��"
	'sqlStr1=" And Release_Release_DATE like '"&year(date())&"-"&right("0"&month(date()),2)&"-"&right("0"&day(date()),2)&"%'"
	'sqlStr1=" And Release_Release_DATE = '"&year(date())&"-"&month(date())&"-1'"
	'sqlStr1=""
	'end if
end if



if sID<>"0" and sID<>"" and submit<> "" then
	session("selectstr2")="&nbsp&nbsp;&nbsp;"&sID&""&"ϵͳ"
	session("sqlStr2")=" And status_sys_type='"&sID&"'"
elseif ( sID="0" or sID="" ) and submit<>"" then
	session("selectstr2")=""
	session("sqlStr2") = ""
end if

if person<>"0" and person<>"" and pname<>"" and submit<> "" then
	pname=ucase(pname)
	select case person
		case "Scale_Scale_ID"
			scalename="������"
		case "Check_Check_ID"
			scalename="�����"
		case "Sample_Sample_UID"
			scalename="ȡ����"
		case "Confirm_Confirm_ID"
			scalename="��׼��"
		case "Release_Release_ID"
			scalename="�ŷ���"
		case "APPLY_APPLY_USRID"
			scalename="������"
	end select
	session("selectstr3")="&nbsp&nbsp;&nbsp;"&scalename&"��&nbsp;"&pname&""
	session("sqlStr3")=" And "&person&"='"&pname&"'"
elseif (person="0" or person="" or pname="") and submit <>"" then
	session("selectstr3")=""
	session("sqlStr3")=""
end if

if Scale_info<>"0" and Scale_info<>"" and Scale_value<>"" and submit<> "" then
	select case Scale_info
		case "Y"
			Scales="��"
		case "Tritium"
			Scales="�"
		case "I131"
			Scales="I-131"
		case "I133"
			Scales="I-133"
		case "Kr85"
			Scales="Kr-85"
		case "Kr88"
			Scales="Kr-88"
		case "Xe133"
			Scales="Xe-133"
		case "Xe135"
			Scales="Xe-135"
		case "Co58"
			Scales="Co-58"
		case "Co60"
			Scales="Co-60"
		case "Co134"
			Scales="Co-134"
		case "Co137"
			Scales="Co-137"
	end select
	session("selectstr4")="&nbsp&nbsp;&nbsp;"&Scales&""&fh&""&Scale_value&""

	session("sqlStr4")=" And Scale_"&Scale_info&""&fh&"'"&Scale_value&"'"
elseif ( Scale_info="0" or Scale_info="" or Scale_value="") and submit<> "" then
	session("selectstr4")=""
	session("sqlStr4")=""
end if

if releaseType<>"0" and releaseType<>"" and submit<> "" then
	if releaseType="normal" then
		sqlStr5=" Confirm_Special_Release is null AND Status_Info_Status_Info like '%�Ѿ����%'"
		release_info="�����ŷ�&nbsp;&nbsp;&nbsp;�Ѿ�����ŷ�"
	end if
	if releaseType="Special" then
		sqlStr5=" Confirm_Special_Release is not null AND Status_Info_Status_Info like '%�Ѿ����%'"
		release_info="�����ŷ�&nbsp;&nbsp;&nbsp;�Ѿ�����ŷ�"
	end if
	if releaseType="no" then
		sqlStr5="Status_Info_Status_Info not like '%�Ѿ����%'"
		release_info="δ��׼�ŷ�"
	end if
	if releaseType="All" then
		sqlStr5="Status_Info_Status_Info like '%�Ѿ����%'"
		release_info="�Ѿ�����ŷ�"
	end if
	session("sqlStr5")=sqlStr5
elseif  submit= "" then
	session("sqlStr5")="Status_Info_Status_Info like '%�Ѿ����%'"
	release_info="�Ѿ�����ŷ�"
elseif (releaseType="0" or releaseType="") and submit<> "" then
	release_info="�Ѿ�����ŷ�"
	session("sqlStr5")="Status_Info_Status_Info like '%�Ѿ����%'"
end if


session("selectstr")=session("selectstr1")&session("selectstr2")&session("selectstr3")&session("selectstr4")&"&nbsp;&nbsp;&nbsp;"&release_info&""

'sqlStr="A.ID=B.ID AND A.ID=C.ID AND A.ID=D.ID AND D.Current_Status=E.Current_Status AND A.ID=F.ID AND A.ID=G.ID AND A.ID=H.ID "
'sqlStr=sqlStr5&sqlStr2&sqlStr3&sqlStr4&sqlStr1
sqlStr=session("sqlStr5")&session("sqlStr2")&session("sqlStr3")&session("sqlStr4")&session("sqlStr1")&" and GREMS.vw_grems_all.Release_SUB_ID = '1' "
'Response.Write sqlStr&"-----"&submit&session("selectstr")

%>
<STYLE>
	select{BORDER:1px solid #3c3;color:white;background-color:#393}
	INPUT {BORDER:1px solid #3c3;color:black;}
</STYLE>
<script language=javascript>
	function trunpage(num){
		//alert(num)
		//document.form1.submit();  
		change_page(num);

	}
</script>
<form name=form1 method=post action="">
	<input type=hidden name=sID  value=<%=sID%>>
	<input type=hidden name=releaseType  value=<%=releaseType%>>
	<input type=hidden name=Scale  value=<%=Scale_info%>>
	<input type=hidden name=fh  value=<%=fh%>>
	<input type=hidden name=Scale_value  value=<%=Scale_value%>>
	<input type=hidden name=person  value=<%=person%>>
	<input type=hidden name=pname  value=<%=pname%>>
	<input type=hidden name=TimeType  value=<%=TimeType%>>
	<input type=hidden name=Time  value=<%=Time%>>
</form>
<!--#include file="../include/GridJS.asp"-->
	<table border=1 height=100% width=100% >
	<tr bgcolor=#339933><td  height=30>
	<table border=1 width=100%>
	<td>
	
	<form method=post action="" name=form>
	<table><tr><td>
	<select name='sID'>
	<option value='0'>--ϵͳ--</option>
	<option value='TER'>TER</option><option value='SEL'>SEL</option><option value='ETY'>ETY</option>
	<option value='TEG'>TEG</option><option value='LIQ'>����Һ��</option><option value='GAS'>������̬</option>
	</select>
	</td></tr></table>
	
	</td><td>
	<table><tr><td>
	<select  name=releaseType>
	<option value='0'>-�ŷ�����-</option>
	<option value='All'>������ŷ�</option><option value='Special'>�����ŷ�</option><option value='normal'>�����ŷ�</option>
	<option value='no'>δ��׼�ŷ�</option>
	</select>
	</td></tr></table>

	</td><td>
	<table><tr><td >
	<select  name='Scale'>
	<option value='0'>-����-</option>
	<option value='Y'>��</option><option value='Tritium'>�</option><option value='I131'>I-131</option>
	<option value='I133'>I-133</option><option value='Kr85'>Kr-85</option><option value='Kr88'>Kr-88</option>
	<option value='Xe133'>Xe-133</option><option value='Xe135'>Xe-135</option><option value='Co58'>Co-58</option>
	<option value='Co60'>Co-60</option><option value='Co134'>Co-134</option><option value='Co137'>Co-137</option>
	</select>
	<select  name='fh'>
	<option value='='>=</option><option value=' > '>></option><option value=' < '><</option>
	</select>
	<input type=text size=5 maxlength=10  name='Scale_value'>
	</td></tr></table>
	
	</td><td>
	<table><tr><td>
	<select  name='person'>
	<option value='0'>-��Ա-</option>
	<option value='Scale_Scale_ID'>������</option><option value='Check_Check_ID'>�����</option><option value='Sample_Sample_UID'>ȡ����</option>
	<option value='Confirm_Confirm_ID'>��׼��</option><option value='Release_Release_ID'>�ŷ���</option><option value=APPLY_APPLY_USRID>������</option>
	</select>
	<input type=text size=8 maxlength=10  name='pname'>
	</td></tr></table>
	
	</td><td>
	<table><tr><td>
	<select  name='TimeType'>
	<!--<option value='0'>--ʱ��--</option> -->
	
	<option value='Release_End_TIME'>�ŷ�ʱ��</option><option value='Scale_Scale_DATE'>����ʱ��</option><option value='Sample_Sample_DATE'>ȡ��ʱ��</option>
	
	<option value='Confirm_Confirm_DATE'>��׼ʱ��</option><option value='APPLY_APPLY_DATE'>����ʱ��</option>
	</select>
	<input type=text size=10 maxlength=16 name='Time' onmousedown="dateTime.calendar(this)" readonly>��
	<input type=text size=10 maxlength=16 name='EndTime' onmousedown="dateTime.calendar(this)" readonly>
	</td></tr></table>
	
	</td><td>
	<table><tr><td>
	<input type=submit value='��ѯ'  name=submit  onclick='return checkSearch()' value="selectbutton" style='border:1px solid #ffffff;background-color:#393;color:#ffffff;font-size:13px;height:18px'>
	</td></tr></table>
	
	</td></tr></table>
	</td></tr><tr bgcolor=#339933><td align=left height=30>
	<input type=hidden name=userid value=<%=userid%>>
	</form>
	<table border=1 height=100% >
	<tr><td >
		<table><tr style='text-align:left;color:#eeeeee'><td style='width:50pt'>&nbsp;��ѯ������</td><td><%=session("selectstr")%></td></tr></table>
	</td><td width=180>
		<table><tr style='text-align:left;color:#eeeeee'><td>&nbsp;<input type=button value="��ҳ" onclick="change_page(-2)">&nbsp;<input type=button value="��ҳ" id=button1 name=button1 onclick="change_page(-1)">&nbsp;<input type=button value="��ҳ" id=button2 name=button2 onclick="change_page(1)">&nbsp;<input type=button value="ĩҳ" id=button3 name=button3 onclick="change_page(2)"></td></tr></table>
	</td></tr>
	</table>	
	</td></tr><tr><td>
<%	
	set table=GetGrid()
	table.cName="�ŷŵ���"
	table.cFormat="style='width:100px'"
	table.cValue="ID"
	table.append()
	
	
	table.cName="�޺�"
	table.cValue="APPlY_BUCKET_NO"
	table.cFormat="style='width:80px'"
	table.append()
	
	table.cName="��ʼ�ŷ�ʱ��"
	table.cValue="Release_Release_DATE"
	table.cFormat="style='width:130px'"
	table.append()
	
	table.cName="Һλ/ѹ��"
	'table.cValue="Release_Bucket_Pressure"
	table.cValue="Apply_liqut_altitude"
	table.cFormat="style='width:70px'"
	table.append()
	
	table.cName="��"
	table.cValue="SCALE_Y"
	table.cFormat="style='width:60px'"	
	table.append()
	
	table.cName="�"
	table.cValue="SCALE_Tritium"
	table.cFormat="style='width:60px'"	
	table.append()
	
	table.cName="������"
	table.cValue="SCALE_Scale_ID"
	table.cFormat="style='width:70px'"	
	table.append()
	
	table.cName="״̬"
	table.cValue="Status_Info_Status_Info"
	table.cFormat="style='width:80px'"	
	table.append()
	
	table.cName="����ʱ��"
	table.cValue="APPLY_APPLY_DATE"
	table.cFormat="style='width:140px'"	
	table.append()
	
	table.PageSize=30
	table.tables=""&Application("DBOwner")&".vw_grems_all"
	'table.target_tables=""&Application("DBOwner")&".Grems_Confirm A,"&Application("DBOwner")&".Grems_Scale B,"&Application("DBOwner")&".Grems_Apply C,"&Application("DBOwner")&".GREMS_Status D,"&Application("DBOwner")&".GREMS_Status_info E,"&Application("DBOwner")&".Grems_Release F,"&Application("DBOwner")&".Grems_Check G,"&Application("DBOwner")&".Grems_Sample H"
	table.filter=""&sqlStr&""
	table.sort="substr(id,1,1) asc,apply_apply_DATE desc"
	table.rAttri="@onclick=ShowPage(^1^) onmouseover=setColor(this,1) onmouseout=setColor(this,0)"
	'table.circle("style1,style2")	
	table.limit="distinct"
	table.Build()
	set table=nothing
	

%>

<script language=javascript src="../Public/List.js"></script>
<script language=javascript>
</script>