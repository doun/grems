<%Response.Expires=-1%>
<!--#include file="../include/ModeRule.asp"-->
<!--#include file="../include/ModeCheckVB.asp"-->
<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<STYLE>
	select{BORDER:1px solid #3c3;color:white;background-color:#393}
</STYLE>
<script language=javascript>
function schange(){
		document.sform.action="StatisticTER.asp";
		document.sform.submit();
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

TERSQL="select "&Application("DBOwner")&".vw_grems_all.ID,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Scale_TRITIUM,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Start_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_End_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Release_liquid,"&_
		 ""&Application("DBOwner")&".vw_grems_all.sample_pubnum2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.release_sub_id"&_
		 LastSQL
TERCountSQL="select count("&Application("DBOwner")&".vw_grems_all.ID)"&LastSQL


LastSQL_Count= " from "&Application("DBOwner")&".vw_grems_all"&_
		 " where Status_Info_Status_Info like '%已经完成%'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time < '"&mm_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time >= '"&ii_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.release_sub_ID = '1'"
		 
TERSQL_Count="select "&Application("DBOwner")&".vw_grems_all.ID,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Scale_TRITIUM,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Start_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_End_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Release_liquid,"&_
		 ""&Application("DBOwner")&".vw_grems_all.sample_pubnum2,"&_
		 ""&Application("DBOwner")&".vw_grems_all.release_sub_id"&_
		 LastSQL_Count
		

		 
TERCountSQL_Count="select count("&Application("DBOwner")&".vw_grems_all.ID)"&LastSQL_Count
'Response.Write TERCountSQL_Count


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
call dbQuery(TERSQL,TERCountSQL,ssArray,ssRows)
call dbQuery(TERSQL_Count,TERCountSQL_Count,ssArray_Count,ssRows_Count)


	LinkStr="num1="&ID_num_E_TER("GNPS","TER",1)&"&num2="&ID_num_E_TER("GNPS","TER",2)&"&num3="&ID_num_E_TER("GNPS","TER",3)&""
	LinkStr=LinkStr&"&num4="&ID_num_E_TER("GNPS","TER",4)&"&num5="&ID_num_E_TER("GNPS","TER",5)&"&num6="&ID_num_E_TER("GNPS","TER",6)&""
	LinkStr=LinkStr&"&num7="&ID_num_E_TER("GNPS","TER",7)&"&num8="&ID_num_E_TER("GNPS","TER",8)&"&num9="&ID_num_E_TER("GNPS","TER",9)&""
	LinkStr=LinkStr&"&num10="&ID_num_E_TER("GNPS","TER",10)&"&num11="&ID_num_E_TER("GNPS","TER",11)&"&num12="&ID_num_E_TER("GNPS","TER",12)&""
	LinkStr=LinkStr&"&Lum1="&ID_num_E_TER("LNPS","TER",1)&"&Lum2="&ID_num_E_TER("LNPS","TER",2)&"&Lum3="&ID_num_E_TER("LNPS","TER",3)&""
	LinkStr=LinkStr&"&Lum4="&ID_num_E_TER("LNPS","TER",4)&"&Lum5="&ID_num_E_TER("LNPS","TER",5)&"&Lum6="&ID_num_E_TER("LNPS","TER",6)&""
	LinkStr=LinkStr&"&Lum7="&ID_num_E_TER("LNPS","TER",7)&"&Lum8="&ID_num_E_TER("LNPS","TER",8)&"&Lum9="&ID_num_E_TER("LNPS","TER",9)&""
	LinkStr=LinkStr&"&Lum10="&ID_num_E_TER("LNPS","TER",10)&"&Lum11="&ID_num_E_TER("LNPS","TER",11)&"&Lum12="&ID_num_E_TER("LNPS","TER",12)&""
	LinkStr=LinkStr&"&content="&mdate&"&name=TER&Stimes=Y"
	
	LinkStrV="num1="&V_num_E_TER("GNPS","TER",1)&"&num2="&V_num_E_TER("GNPS","TER",2)&"&num3="&V_num_E_TER("GNPS","TER",3)&""
	LinkStrV=LinkStrV&"&num4="&V_num_E_TER("GNPS","TER",4)&"&num5="&V_num_E_TER("GNPS","TER",5)&"&num6="&V_num_E_TER("GNPS","TER",6)&""
	LinkStrV=LinkStrV&"&num7="&V_num_E_TER("GNPS","TER",7)&"&num8="&V_num_E_TER("GNPS","TER",8)&"&num9="&V_num_E_TER("GNPS","TER",9)&""
	LinkStrV=LinkStrV&"&num10="&V_num_E_TER("GNPS","TER",10)&"&num11="&V_num_E_TER("GNPS","TER",11)&"&num12="&V_num_E_TER("GNPS","TER",12)&""
	LinkStrV=LinkStrV&"&Lum1="&V_num_E_TER("LNPS","TER",1)&"&Lum2="&V_num_E_TER("LNPS","TER",2)&"&Lum3="&V_num_E_TER("LNPS","TER",3)&""
	LinkStrV=LinkStrV&"&Lum4="&V_num_E_TER("LNPS","TER",4)&"&Lum5="&V_num_E_TER("LNPS","TER",5)&"&Lum6="&V_num_E_TER("LNPS","TER",6)&""
	LinkStrV=LinkStrV&"&Lum7="&V_num_E_TER("LNPS","TER",7)&"&Lum8="&V_num_E_TER("LNPS","TER",8)&"&Lum9="&V_num_E_TER("LNPS","TER",9)&""
	LinkStrV=LinkStrV&"&Lum10="&V_num_E_TER("LNPS","TER",10)&"&Lum11="&V_num_E_TER("LNPS","TER",11)&"&Lum12="&V_num_E_TER("LNPS","TER",12)&""
	LinkStrV=LinkStrV&"&content="&mdate&"&name=TER&V=Y"
		
	LinkStrB="num1="&Bq_num_E_TER("GNPS","TER",1)&"&num2="&Bq_num_E_TER("GNPS","TER",2)&"&num3="&Bq_num_E_TER("GNPS","TER",3)&""
	LinkStrB=LinkStrB&"&num4="&Bq_num_E_TER("GNPS","TER",4)&"&num5="&Bq_num_E_TER("GNPS","TER",5)&"&num6="&Bq_num_E_TER("GNPS","TER",6)&""
	LinkStrB=LinkStrB&"&num7="&Bq_num_E_TER("GNPS","TER",7)&"&num8="&Bq_num_E_TER("GNPS","TER",8)&"&num9="&Bq_num_E_TER("GNPS","TER",9)&""
	LinkStrB=LinkStrB&"&num10="&Bq_num_E_TER("GNPS","TER",10)&"&num11="&Bq_num_E_TER("GNPS","TER",11)&"&num12="&Bq_num_E_TER("GNPS","TER",12)&""
	LinkStrB=LinkStrB&"&Lum1="&Bq_num_E_TER("LNPS","TER",1)&"&Lum2="&Bq_num_E_TER("LNPS","TER",2)&"&Lum3="&Bq_num_E_TER("LNPS","TER",3)&""
	LinkStrB=LinkStrB&"&Lum4="&Bq_num_E_TER("LNPS","TER",4)&"&Lum5="&Bq_num_E_TER("LNPS","TER",5)&"&Lum6="&Bq_num_E_TER("LNPS","TER",6)&""
	LinkStrB=LinkStrB&"&Lum7="&Bq_num_E_TER("LNPS","TER",7)&"&Lum8="&Bq_num_E_TER("LNPS","TER",8)&"&Lum9="&Bq_num_E_TER("LNPS","TER",9)&""
	LinkStrB=LinkStrB&"&Lum10="&Bq_num_E_TER("LNPS","TER",10)&"&Lum11="&Bq_num_E_TER("LNPS","TER",11)&"&Lum12="&Bq_num_E_TER("LNPS","TER",12)&""
	LinkStrB=LinkStrB&"&content="&mdate&"&name=TER&Bq=Y"
	
	
	p "<table border=0 height=100% width=100% >"
	p "<tr bgcolor=#339933 >"
	p "<td height=30>&nbsp;<font color=yellow>矩形图表</font>&nbsp;<a href='StatisticShapeEach.asp?"&LinkStr&"'><font color=yellow>次数</font></a>&nbsp;<a href='StatisticShapeEach.asp?"&LinkStrV&"'><font color=yellow>体积</font></a>&nbsp;<a href='StatisticShapeEach.asp?"&LinkStrB&"'><font color=yellow>氚排放量</font></a>&nbsp;&nbsp;<a href='StatisticTER_E.asp?content="&mdate&"' onclick='return openWin(this.href)'><font color=yellow>输出Excel</font></a>&nbsp;&nbsp;<a href='StatisticTERp.asp?content="&mdate&"' onclick='return openWin(this.href)'><font color=yellow>我要打印</font></a></td>"
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
	p "&nbsp;&nbsp;&nbsp;<font color=yellow><b>TER</b></font> 系统放射性流出物排放结果&nbsp;&nbsp;&nbsp;&nbsp;"
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
	
	ReDim ssArray_Count(0)
	
	sub ListMain(Name)
		p "<tr style='color:black;text-align:center'><td rowspan=3 valign=top style='FONT-SIZE: 14px'><b>"&Name&"</b></td>"
		p "<td style='FONT-SIZE: 13px'>&nbsp;次数&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TER",1)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TER",2)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TER",3)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TER",4)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TER",5)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TER",6)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TER",7)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TER",8)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TER",9)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TER",10)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TER",11)&"&nbsp;</td><td>&nbsp;"&ID_num_E_TER(Name,"TER",12)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E_TER(Name,"TER",0)&"&nbsp;</td></tr>"
		p "<tr style='color:black;text-align:center'><td style='FONT-SIZE: 13px'>体积(m3)</td>"
		p "<td>&nbsp;"&V_num_E_TER(Name,"TER",1)&"&nbsp;</td><td>&nbsp;"&V_num_E_TER(Name,"TER",2)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E_TER(Name,"TER",3)&"&nbsp;</td><td>&nbsp;"&V_num_E_TER(Name,"TER",4)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E_TER(Name,"TER",5)&"&nbsp;</td><td>&nbsp;"&V_num_E_TER(Name,"TER",6)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E_TER(Name,"TER",7)&"&nbsp;</td><td>&nbsp;"&V_num_E_TER(Name,"TER",8)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E_TER(Name,"TER",9)&"&nbsp;</td><td>&nbsp;"&V_num_E_TER(Name,"TER",10)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E_TER(Name,"TER",11)&"&nbsp;</td><td>&nbsp;"&V_num_E_TER(Name,"TER",12)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E_TER(Name,"TER",0)&"&nbsp;</td></tr>"
		p "<tr style='color:black;text-align:center'><td style='FONT-SIZE: 13px'>&nbsp;氚排放量(Bq)</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",1)))
			'call testnum(Bq_num_E_TER(Name,"TER",1))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",2)))
			'call testnum(Bq_num_E_TER(Name,"TER",2))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",3)))
			'call testnum(Bq_num_E_TER(Name,"TER",3))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",4)))
			'call testnum(Bq_num_E_TER(Name,"TER",4))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",5)))
			'call testnum(Bq_num_E_TER(Name,"TER",5))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",6)))
			'call testnum(Bq_num_E_TER(Name,"TER",6))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",7)))
			'call testnum(Bq_num_E_TER(Name,"TER",7))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",8)))
			'call testnum(Bq_num_E_TER(Name,"TER",8))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",9)))
			'call testnum(Bq_num_E_TER(Name,"TER",9))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",10)))
			'call testnum(Bq_num_E_TER(Name,"TER",10))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",11)))
			'call testnum(Bq_num_E_TER(Name,"TER",11))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",12)))
			'call testnum(Bq_num_E_TER(Name,"TER",12))
		p "&nbsp;</td>"
		p "<td>&nbsp;"
			Response.write testnum(cdbl(Bq_num_E_TER(Name,"TER",0)))
			'call testnum(Bq_num_E_TER(Name,"TER",0))
		p "&nbsp;</td>"
		'p "<td>&nbsp;"&Bq_num_E(Name,"TER",2)&"&nbsp;</td>"
		'p "<td>&nbsp;"&Bq_num_E(Name,"TER",3)&"&nbsp;</td><td>&nbsp;"&Bq_num_E(Name,"TER",4)&"&nbsp;</td>"
		'p "<td>&nbsp;"&Bq_num_E(Name,"TER",5)&"&nbsp;</td><td>&nbsp;"&Bq_num_E(Name,"TER",6)&"&nbsp;</td>"
		'p "<td>&nbsp;"&Bq_num_E(Name,"TER",7)&"&nbsp;</td><td>&nbsp;"&Bq_num_E(Name,"TER",8)&"&nbsp;</td>"
		'p "<td>&nbsp;"&Bq_num_E(Name,"TER",9)&"&nbsp;</td><td>&nbsp;"&Bq_num_E(Name,"TER",10)&"&nbsp;</td>"
		'p "<td>&nbsp;"&Bq_num_E(Name,"TER",11)&"&nbsp;</td><td>&nbsp;"&Bq_num_E(Name,"TER",12)&"&nbsp;</td>"
		'p "<td>&nbsp;"&Bq_num_E(Name,"TER",0)&"&nbsp;</td>"
		p "</tr>"
	end sub
	
	

%>