<%Response.Expires=-1
Response.ContentType = "application/vnd.ms-excel"
%>

<title>月度统计表</title>

<!--#include file="Statistic.asp"-->
<%
mm_year=trim(Request.Form("mm_year"))
mm_month=trim(Request.Form("mm_month"))
content=trim(Request("content"))
if mm_month="" and mm_year="" then
	if content="" then
		mdate=date()
	else
		mdate=content
	end if
else
	mdate=mm_year&"-"&mm_month&"-01"
end if
mm_date=year(mdate)&"-"&right("0"&month(mdate),2)&"-01"
min_date=DateAdd("d",0,mm_date)
min_date=year(min_date)&"-"&right("0"&month(min_date),2)&"-"&right("0"&day(min_date),2)
max_date=DateAdd("m",1,mm_date)
'max_date=DateAdd("d",-1,max_date)
max_date=year(max_date)&"-"&right("0"&month(max_date),2)&"-"&right("0"&day(max_date),2)
'-----------------------------'
dim sInputYear,sInputMonth
sInputYear=year(mdate)
sInputMonth=month(mdate)
'-----------------------------'

LastSQL= " from "&Application("DBOwner")&".vw_grems_all"&_
		 " where Status_Info_Status_Info like '%已经完成%'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time < '"&max_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time >= '"&min_date&"'"

MonthSQL="select "&Application("DBOwner")&".vw_grems_all.ID,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Scale_TRITIUM,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Start_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_End_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Release_liquid,"&_
		 ""&Application("DBOwner")&".vw_grems_all.sample_pubnum2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.release_sub_id"&_
		 LastSQL
MonthCountSQL="select count("&Application("DBOwner")&".vw_grems_all.ID)"&LastSQL


LastSQL_Count= " from "&Application("DBOwner")&".vw_grems_all"&_
		 " where Status_Info_Status_Info like '%已经完成%'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time < '"&max_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time >= '"&min_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.release_sub_ID = '1'"
		 
MonthSQL_Count="select "&Application("DBOwner")&".vw_grems_all.ID,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Scale_TRITIUM,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Start_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_End_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Release_liquid,"&_
		 ""&Application("DBOwner")&".vw_grems_all.sample_pubnum2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.release_sub_id"&_
		 LastSQL_Count
		
'Response.Write MonthSQL_Count
		 
MonthCountSQL_Count="select count("&Application("DBOwner")&".vw_grems_all.ID)"&LastSQL_Count
'Response.End 
'sql="select "&Application("DBOwner")&".Grems_Release.ID,"&_
'	""&Application("DBOwner")&".Grems_Release.Start_time,"&_
'	""&Application("DBOwner")&".Grems_Release.End_time,"&_
'	""&Application("DBOwner")&".Grems_Release.Release_liquid,"&_
'	""&Application("DBOwner")&".Grems_Sample.PUBNUM2,"&_
'	""&Application("DBOwner")&".Grems_Scale.TRITIUM"&_
'	" from "&Application("DBOwner")&".Grems_Release,"&Application("DBOwner")&".Grems_Sample,"&Application("DBOwner")&".Grems_Scale"&_
'	" where "&Application("DBOwner")&".Grems_Release.Release_DATE>to_date('"&min_date&"','YYYY-MM-DD')"&_
'	" and "&Application("DBOwner")&".Grems_Release.Release_DATE<to_date('"&max_date&"','YYYY-MM-DD')"&_
'	" and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Sample .ID"&_
'	" and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Scale .ID"
'Response.Write sql
'Response.End 
'sqlcount="select count("&Application("DBOwner")&".Grems_Release.ID)"&_
'		" from "&Application("DBOwner")&".Grems_Release,"&Application("DBOwner")&".Grems_Sample,"&Application("DBOwner")&".Grems_Scale"&_
'		" where "&Application("DBOwner")&".Grems_Release.Release_DATE>to_date('"&min_date&"','YYYY-MM-DD')"&_
'		" and "&Application("DBOwner")&".Grems_Release.Release_DATE<to_date('"&max_date&"','YYYY-MM-DD')"&_
'		" and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Sample .ID"&_
'		" and "&Application("DBOwner")&".Grems_Release.ID="&Application("DBOwner")&".Grems_Scale .ID"
call dbQuery(MonthSQL,MonthCountSQL,ssArray,ssRows)
call dbQuery(MonthSQL_Count,MonthCountSQL_Count,ssArray_Count,ssRows_Count)



call showMain()
	
ReDim ssArray(0)
ReDim ssArray_Count(0)

sub showMain()
	if ssRows=-1 then
		TER_num1=0
		TER_num2=0
		TER_num3=0
		SEL_num1=0
		SEL_num2=0
		SEL_num3=0
		ETY_num1=0
		ETY_num2=0
		ETY_num3=0
		TEG_num1=0
		TEG_num2=0
		TEG_num3=0
		TER_Times1=0
		TER_Times2=0
		TER_Times3=0
		SEL_Times1=0
		SEL_Times2=0
		SEL_Times3=0
		ETY_Times1=0
		ETY_Times2=0
		ETY_Times3=0
		TEG_Times1=0
		TEG_Times2=0
		TEG_Times3=0
		TER_V1=0
		TER_V2=0
		TER_V3=0
		SEL_V1=0
		SEL_V2=0
		SEL_V3=0
		Bq1=0
		Bq2=0
		Bq3=0
	else
		TER_num1=ID_num_Count("GNPS","TER")
		TER_num2=ID_num_Count("LNPS","TER")
		TER_num3=ID_num_Count("GNP","TER")
		SEL_num1=ID_num_Count("GNPS","SEL")
		SEL_num2=ID_num_Count("LNPS","SEL")
		SEL_num3=ID_num_Count("GNP","SEL")
		ETY_num1=ID_num_Count("GNPS","ETY")
		ETY_num2=ID_num_Count("LNPS","ETY")
		ETY_num3=ID_num_Count("GNP","ETY")
		TEG_num1=ID_num_Count("GNPS","TEG")
		TEG_num2=ID_num_Count("LNPS","TEG")
		TEG_num3=ID_num_Count("GNP","TEG")
		TER_Times1=Timers_num("GNPS","TER")
		TER_Times2=Timers_num("LNPS","TER")
		TER_Times3=Timers_num("GNP","TER")
		SEL_Times1=Timers_num("GNPS","SEL")
		SEL_Times2=Timers_num("LNPS","SEL")
		SEL_Times3=Timers_num("GNP","SEL")
		ETY_Times1=Timers_num("GNPS","ETY")
		ETY_Times2=Timers_num("LNPS","ETY")
		ETY_Times3=Timers_num("GNP","ETY")
		TEG_Times1=Timers_num("GNPS","TEG")
		TEG_Times2=Timers_num("LNPS","TEG")
		TEG_Times3=Timers_num("GNP","TEG")
		TER_V1=V_num_TER("GNPS","TER")
		TER_V2=V_num_TER("LNPS","TER")
		TER_V3=V_num_TER("GNP","TER")
		SEL_V1=V_num("GNPS","SEL")
		SEL_V2=V_num("LNPS","SEL")
		SEL_V3=V_num("GNP","SEL")
		Bq1=testnum(cdbl(Bq_num("GNPS","TER")))
		Bq2=testnum(cdbl(Bq_num("LNPS","TER")))
		Bq3=testnum(cdbl(Bq_num("GNP","TER")))
	end if
	
	LinkStr="TER_num1="&TER_num1&"&TER_num2="&TER_num2&"&TER_num3="&TER_num3&""
	LinkStr=LinkStr&"&SEL_num1="&SEL_num1&"&SEL_num2="&SEL_num2&"&SEL_num3="&SEL_num3&""
	LinkStr=LinkStr&"&ETY_num1="&ETY_num1&"&ETY_num2="&ETY_num2&"&ETY_num3="&ETY_num3&""
	LinkStr=LinkStr&"&TEG_num1="&TEG_num1&"&TEG_num2="&TEG_num2&"&TEG_num3="&TEG_num3&""
	LinkStr=LinkStr&"&content="&mdate&"&sdate=Y&Stimes=Y"
	
	
	LinkStrV="TER_V1="&TER_V1&"&TER_V2="&TER_V2&"&TER_V3="&TER_V3&""
	LinkStrV=LinkStrV&"&SEL_V1="&SEL_V1&"&SEL_V2="&SEL_V2&"&SEL_V3="&SEL_V3&""
	LinkStrV=LinkStrV&"&content="&mdate&"&sdate=Y&V=Y"
	
	p "<table border=0 height=100% width=100% ><tr><td align=center><table style='filter:glow(color=white,strength=2)'><tr><td align=center colspan=2><font style='font-size:11pt;color=white'>月度统计表</font></td></tr></table></td></tr><td >"
	p "<table border=0 height=100% width=100% >"
	p "<tr bgcolor=#339933>"
	p "<td align=center>"
	'p "<select name=mm_year onchange='return schange()'>"
	'p "</select>"
	p "&nbsp;&nbsp;"
	p "&nbsp;"&sInputYear&"&nbsp;年&nbsp;"&sInputMonth&"月"
	p "&nbsp;&nbsp;&nbsp;广东核电放射性流出物排放结果&nbsp;&nbsp;&nbsp;&nbsp;"
	p "</td><td></td></tr>"
	p "<tr><td align=right colspan=2 bgcolor=#ffffff>"
	
	
	
	p "<table border=1 height=100% width=100% cellspacing=0 cellpadding=0 >"
	p "<tr height=25 align=center bgcolor='#339933'>"
	p "<td width=10% >&nbsp;</td>"
	p "<td width=10% >系统号</td>"
	p "<td width=20% >排放次数</td>"
	p "<td width=20% >排放体积 m3*</td>"
	p "<td width=20% >累计排放时间(hr)</td>"
	p "<td width=20% >液态氚的排放量(Bq)</td>"
	p "</tr>"
	
	
	call ListMain("GNPS",TER_num1,SEL_num1,ETY_num1,TEG_num1,TER_Times1,SEL_Times1,ETY_Times1,TEG_Times1,TER_V1,SEL_V1,Bq1)
	call ListMain("LNPS",TER_num2,SEL_num2,ETY_num2,TEG_num2,TER_Times2,SEL_Times2,ETY_Times2,TEG_Times2,TER_V2,SEL_V2,Bq2)
	call ListMain("GNP",TER_num3,SEL_num3,ETY_num3,TEG_num3,TER_Times3,SEL_Times3,ETY_Times3,TEG_Times3,TER_V3,SEL_V3,Bq3)	
	
	p "</table>"
	p "</td></tr>"
	p "</table></form>"
	
	p"</td></tr><tr><td height=10></td></tr></table>"
	
	ReDim ssArray(0)
	
end sub

sub ListMain(Name,TER_num,SEL_num,ETY_num,TEG_num,TER_Times,SEL_Times,ETY_Times,TEG_Times,TER_V,SEL_V,Bq)
	p "<tr style='color:black'><td rowspan=4 valign=top style='FONT-SIZE: 14px'>&nbsp;<b>"&Name&"</b></td>"
	p "<td style='FONT-SIZE: 13px'>&nbsp;<b>TER</b></td><td align=center>&nbsp;"&TER_num&"&nbsp;</td><td align=center>&nbsp;"&TER_V&"&nbsp;</td><td align=center>&nbsp;"&TER_Times&"&nbsp;<td align=center>&nbsp;"
	'if Bq="0" then
	p ""&Bq&""
	'else
	'	p "<script language=javascript>document.write(FormatNum("&Bq&",2))</script>"
	'end if
	p "&nbsp;</td></tr>"
	p "<tr style='color:black'><td style='FONT-SIZE: 13px'>&nbsp;<b>SEL</b></td><td align=center>&nbsp;"&SEL_num&"&nbsp;</td><td align=center>&nbsp;"&SEL_V&"&nbsp;</td><td align=center>&nbsp;"&SEL_Times&"&nbsp;</td><td align=center>无</td></tr>"
	p "<tr style='color:black'><td style='FONT-SIZE: 13px'>&nbsp;<b>ETY</b></td><td align=center>&nbsp;"&ETY_num&"&nbsp;</td><td align=center>无</td><td align=center>&nbsp;"&ETY_Times&"&nbsp;</td><td align=center>无</td></tr>"
	p "<tr style='color:black'><td style='FONT-SIZE: 13px'>&nbsp;<b>TEG</b></td><td align=center>&nbsp;"&TEG_num&"&nbsp;</td><td align=center>无</td><td align=center>&nbsp;"&TEG_Times&"&nbsp;</td><td align=center>无</td></tr>"
end sub
%>