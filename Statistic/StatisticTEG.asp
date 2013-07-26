<%Response.Expires=-1%>
<!--#include file="../include/ModeRule.asp"-->
<!--#include file="../include/ModeCheckVB.asp"-->
<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<STYLE>
	select{BORDER:1px solid #3c3;color:white;background-color:#393}
</STYLE>
<script language=javascript>
function schange(){
		document.sform.action="StatisticTEG.asp";
		document.sform.submit();
}

function checkGrant(sID,sMode)
{
	if(sID==null||sID==""||(""+sID).substring(0,1)!="P") return false
	return (""+Application("USER_GRANT")).match(eval("/[:,]"+sMode+",[^:]*"+sID+"/"))!=null
}
	
</script>
<!--#include file="Statistic.asp"-->
<%
mm_year=trim(Request.Form("mm_year"))
content=trim(Request.QueryString("content"))
if mm_year="" then
	if content="" then
		mdate=date()
	else
		mdate=content
	end if
else
	mdate=mm_year&"-12-31"
end if
mm_date=(year(mdate)+1)&"-01-01"
ii_date=(year(mdate)-1)&"-12-31"
mmonht=month(mdate)




LastSQL= " from "&Application("DBOwner")&".vw_grems_all"&_
		 " where Status_Info_Status_Info like '%已经完成%'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time < '"&mm_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time >= '"&ii_date&"'"

TEGSQL="select "&Application("DBOwner")&".vw_grems_all.ID,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Scale_TRITIUM,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Start_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_End_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Release_liquid,"&_
		 ""&Application("DBOwner")&".vw_grems_all.sample_pubnum2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.release_sub_id"&_
		 LastSQL
TEGCountSQL="select count("&Application("DBOwner")&".vw_grems_all.ID)"&LastSQL


LastSQL_Count= " from "&Application("DBOwner")&".vw_grems_all"&_
		 " where Status_Info_Status_Info like '%已经完成%'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time < '"&mm_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time >= '"&ii_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.release_sub_ID = '1'"
		 
TEGSQL_Count="select "&Application("DBOwner")&".vw_grems_all.ID,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Scale_TRITIUM,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Start_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_End_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Release_liquid,"&_
		 ""&Application("DBOwner")&".vw_grems_all.sample_pubnum2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.release_sub_id"&_
		 LastSQL_Count
		

		 
TEGCountSQL_Count="select count("&Application("DBOwner")&".vw_grems_all.ID)"&LastSQL_Count

'sql="select "&Application("DBOwner")&".Grems_Release.ID,"&_
'	""&Application("DBOwner")&".Grems_Release.Start_time,"&_
'	""&Application("DBOwner")&".Grems_Release.End_time,"&_
'	""&Application("DBOwner")&".Grems_Release.Release_liquid,"&_
'	""&Application("DBOwner")&".Grems_Sample.PUBNUM2,"&_
'	""&Application("DBOwner")&".Grems_Scale.TRITIUM,"&_
'	""&Application("DBOwner")&".Grems_Release.Release_DATE"&_
'	" from "&Application("DBOwner")&".Grems_Release,"&Application("DBOwner")&".Grems_Sample,"&Application("DBOwner")&".Grems_Scale"&_
'	" where "&Application("DBOwner")&".Grems_Release.Release_DATE<to_date('"&mm_date&"','YYYY-MM-DD')"&_
'	" and to_date('"&ii_date&"','YYYY-MM-DD')<"&Application("DBOwner")&".Grems_Release.Release_DATE"&_
'	" and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Sample .ID"&_
'	" and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Scale .ID"
'sqlcount="select count("&Application("DBOwner")&".Grems_Release.ID)"&_
'		 " from "&Application("DBOwner")&".Grems_Release,"&Application("DBOwner")&".Grems_Sample,"&Application("DBOwner")&".Grems_Scale"&_
'		 " where "&Application("DBOwner")&".Grems_Release.Release_DATE<to_date('"&mm_date&"','YYYY-MM-DD')"&_
'		 " and "&Application("DBOwner")&".Grems_Release.Release_DATE>to_date('"&ii_date&"','YYYY-MM-DD')"&_
'		 " and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Sample .ID"&_
'		 " and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Scale .ID"
'p sql
'Response.End 
call dbQuery(TEGSQL,TEGCountSQL,ssArray,ssRows)
call dbQuery(TEGSQL_Count,TEGCountSQL_Count,ssArray_Count,ssRows_Count)


	LinkStr="num1="&ID_num_E_TER("GNPS","TEG",1)&"&num2="&ID_num_E_TER("GNPS","TEG",2)&"&num3="&ID_num_E_TER("GNPS","TEG",3)&""
	LinkStr=LinkStr&"&num4="&ID_num_E_TER("GNPS","TEG",4)&"&num5="&ID_num_E_TER("GNPS","TEG",5)&"&num6="&ID_num_E_TER("GNPS","TEG",6)&""
	LinkStr=LinkStr&"&num7="&ID_num_E_TER("GNPS","TEG",7)&"&num8="&ID_num_E_TER("GNPS","TEG",8)&"&num9="&ID_num_E_TER("GNPS","TEG",9)&""
	LinkStr=LinkStr&"&num10="&ID_num_E_TER("GNPS","TEG",10)&"&num11="&ID_num_E_TER("GNPS","TEG",11)&"&num12="&ID_num_E_TER("GNPS","TEG",12)&""
	LinkStr=LinkStr&"&Lum1="&ID_num_E_TER("LNPS","TEG",1)&"&Lum2="&ID_num_E_TER("LNPS","TEG",2)&"&Lum3="&ID_num_E_TER("LNPS","TEG",3)&""
	LinkStr=LinkStr&"&Lum4="&ID_num_E_TER("LNPS","TEG",4)&"&Lum5="&ID_num_E_TER("LNPS","TEG",5)&"&Lum6="&ID_num_E_TER("LNPS","TEG",6)&""
	LinkStr=LinkStr&"&Lum7="&ID_num_E_TER("LNPS","TEG",7)&"&Lum8="&ID_num_E_TER("LNPS","TEG",8)&"&Lum9="&ID_num_E_TER("LNPS","TEG",9)&""
	LinkStr=LinkStr&"&Lum10="&ID_num_E_TER("LNPS","TEG",10)&"&Lum11="&ID_num_E_TER("LNPS","TEG",11)&"&Lum12="&ID_num_E_TER("LNPS","TEG",12)&""
	LinkStr=LinkStr&"&content="&mdate&"&name=TEG&Stimes=Y"
	
	
	LinkStrT="num1="&Timers_num_E("GNPS","TEG",1)&"&num2="&Timers_num_E("GNPS","TEG",2)&"&num3="&Timers_num_E("GNPS","TEG",3)&""
	LinkStrT=LinkStrT&"&num4="&Timers_num_E("GNPS","TEG",4)&"&num5="&Timers_num_E("GNPS","TEG",5)&"&num6="&Timers_num_E("GNPS","TEG",6)&""
	LinkStrT=LinkStrT&"&num7="&Timers_num_E("GNPS","TEG",7)&"&num8="&Timers_num_E("GNPS","TEG",8)&"&num9="&Timers_num_E("GNPS","TEG",9)&""
	LinkStrT=LinkStrT&"&num10="&Timers_num_E("GNPS","TEG",10)&"&num11="&Timers_num_E("GNPS","TEG",11)&"&num12="&Timers_num_E("GNPS","TEG",12)&""
	LinkStrT=LinkStrT&"&Lum1="&Timers_num_E("LNPS","TEG",1)&"&Lum2="&Timers_num_E("LNPS","TEG",2)&"&Lum3="&Timers_num_E("LNPS","TEG",3)&""
	LinkStrT=LinkStrT&"&Lum4="&Timers_num_E("LNPS","TEG",4)&"&Lum5="&Timers_num_E("LNPS","TEG",5)&"&Lum6="&Timers_num_E("LNPS","TEG",6)&""
	LinkStrT=LinkStrT&"&Lum7="&Timers_num_E("LNPS","TEG",7)&"&Lum8="&Timers_num_E("LNPS","TEG",8)&"&Lum9="&Timers_num_E("LNPS","TEG",9)&""
	LinkStrT=LinkStrT&"&Lum10="&Timers_num_E("LNPS","TEG",10)&"&Lum11="&Timers_num_E("LNPS","TEG",11)&"&Lum12="&Timers_num_E("LNPS","TEG",12)&""
	LinkStrT=LinkStrT&"&content="&mdate&"&name=TEG&Ttimes=Y"
	

	p "<table border=0 height=100% width=100% >"
	p "<tr bgcolor=#339933>"
	p "<td height=30>&nbsp;<font color=yellow>矩形图表</font>&nbsp;<a href='StatisticShapeEach.asp?"&LinkStr&"'><font color=yellow>次数</font></a>&nbsp;<a href='StatisticShapeEach.asp?"&LinkStrT&"'><font color=yellow>时间</font></a>&nbsp;<a href='StatisticTEG_E.asp?content="&mdate&"' onclick='return openWin(this.href)'><font color=yellow>输出Excel</font></a>&nbsp;&nbsp;<a href='StatisticTEGp.asp?content="&mdate&"' onclick='return openWin(this.href)'><font color=yellow>我要打印</font></a></td>"
	p "<td align=right ><form name=sform method=post><input type=hidden name=userid value="&userid&">"
	p "<select name=mm_year onchange='return schange()'>"
	for i=2003 to year(date())
		if i=year(mdate) then
			p "<option value="&i&" selected>"&i&"</option>"
		else
			p "<option value="&i&">"&i&"</option>"
		end if
	next
	p "</select>"
	p "&nbsp;&nbsp;"
	p "1月&nbsp;至&nbsp;"&mmonht&"月"
	p "&nbsp;&nbsp;&nbsp;<font color=yellow><b>TEG</b></font> 系统放射性流出物排放结果&nbsp;&nbsp;&nbsp;&nbsp;"
	p "</td></tr>"
	p "<tr><td align=right colspan=2 bgcolor=#ffffff>"
	
	p "<table border=1 height=100% width=100% cellspacing=0 cellpadding=0 >"
	p "<tr height=25 align=center bgcolor='#339933'>"
	p "<td width=10% >&nbsp;</td>"
	p "<td width=10% >&nbsp;</td>"
	p "<td width=6% >1月</td>"
	p "<td width=6% >2月</td>"
	p "<td width=6% >3月</td>"
	p "<td width=6% >4月</td>"
	p "<td width=6% >5月</td>"
	p "<td width=6% >6月</td>"
	p "<td width=6% >7月</td>"
	p "<td width=6% >8月</td>"
	p "<td width=6% >9月</td>"
	p "<td width=6% >10月</td>"
	p "<td width=6% >11月</td>"
	p "<td width=6% >12月</td>"
	p "<td width=8% >全年</td>"
	p "</tr>"
	
	call ListMain("GNPS")
	call ListMain("LNPS")
	call ListMain("GNP")
	
	p "</table>"
	p "</td></tr>"
	p "</table></form>"
	
	ReDim ssArray(0)
	ReDim ssArray_count(0)
	sub ListMain(Name)
		p "<tr style='color:black;text-align:center'><td rowspan=2 valign=top style='FONT-SIZE: 14px'><b>"&Name&"</b></td>"
		p "<td style='FONT-SIZE: 13px'>&nbsp;次数&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TEG",1)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TEG",2)&"&nbsp;</td>"
		P "<td>&nbsp;"&ID_num_E_TER(Name,"TEG",3)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TEG",4)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TEG",5)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TEG",6)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TEG",7)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TEG",8)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TEG",9)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TEG",10)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TEG",11)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TEG",12)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TEG",0)&"&nbsp;</td></tr>"
		p "<tr style='color:black;text-align:center'><td style='FONT-SIZE: 13px'>&nbsp;时间&nbsp;</td>"
		p "<td>&nbsp;"&Timers_num_E(Name,"TEG",1)&"&nbsp;</td><td>&nbsp;"&Timers_num_E(Name,"TEG",2)&"&nbsp;</td>"
		p "<td>&nbsp;"&Timers_num_E(Name,"TEG",3)&"&nbsp;</td><td>&nbsp;"&Timers_num_E(Name,"TEG",4)&"&nbsp;</td>"
		p "<td>&nbsp;"&Timers_num_E(Name,"TEG",5)&"&nbsp;</td><td>&nbsp;"&Timers_num_E(Name,"TEG",6)&"&nbsp;</td>"
		p "<td>&nbsp;"&Timers_num_E(Name,"TEG",7)&"&nbsp;</td><td>&nbsp;"&Timers_num_E(Name,"TEG",8)&"&nbsp;</td>"
		p "<td>&nbsp;"&Timers_num_E(Name,"TEG",9)&"&nbsp;</td><td>&nbsp;"&Timers_num_E(Name,"TEG",10)&"&nbsp;</td>"
		p "<td>&nbsp;"&Timers_num_E(Name,"TEG",11)&"&nbsp;</td><td>&nbsp;"&Timers_num_E(Name,"TEG",12)&"&nbsp;</td>"
		p "<td>&nbsp;"&Timers_num_E(Name,"TEG",0)&"&nbsp;</td></tr>"
		
	end sub
%>