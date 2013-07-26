<%Response.Expires=-1%>
<html>
<title>打印--SEL系统全年统计总表</title>
<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<STYLE>
	select{BORDER:1px solid #3c3;color:white;background-color:#393}
</STYLE>
<script language=javascript>
function schange(){
	//var myear=document.sform.mm_year.value;
	//var tt=confirm("是否要查看 "+myear+"月 的排放结果");
	//if(tt==true){
		document.sform.action="StatisticTER.asp";
		document.sform.submit();
	//}
	//else
	//{
	//	return false;
	//}
}

//var tt=FormatNum(120000,2)
//document.write(tt)
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
dim sInputYear
sInputYear=year(mdate)






LastSQL= " from "&Application("DBOwner")&".vw_grems_all"&_
		 " where Status_Info_Status_Info like '%已经完成%'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time < '"&mm_date&"'"&_
		 " and "&Application("DBOwner")&".vw_grems_all.Release_End_time >= '"&ii_date&"'"

SELSQL="select "&Application("DBOwner")&".vw_grems_all.ID,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Scale_TRITIUM,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Start_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_End_time,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure,"&_
		 ""&Application("DBOwner")&".vw_grems_all.Release_Bucket_Pressure2"&_
		 LastSQL
SELCountSQL="select count("&Application("DBOwner")&".vw_grems_all.ID)"&LastSQL


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
call dbQuery(SELSQL,SELCountSQL,ssArray,ssRows)


	LinkStr="num1="&ID_num_E("GNPS","SEL",1)&"&num2="&ID_num_E("GNPS","SEL",2)&"&num3="&ID_num_E("GNPS","SEL",3)&""
	LinkStr=LinkStr&"&num4="&ID_num_E("GNPS","SEL",4)&"&num5="&ID_num_E("GNPS","SEL",5)&"&num6="&ID_num_E("GNPS","SEL",6)&""
	LinkStr=LinkStr&"&num7="&ID_num_E("GNPS","SEL",7)&"&num8="&ID_num_E("GNPS","SEL",8)&"&num9="&ID_num_E("GNPS","SEL",9)&""
	LinkStr=LinkStr&"&num10="&ID_num_E("GNPS","SEL",10)&"&num11="&ID_num_E("GNPS","SEL",11)&"&num12="&ID_num_E("GNPS","SEL",12)&""
	LinkStr=LinkStr&"&Lum1="&ID_num_E("LNPS","SEL",1)&"&Lum2="&ID_num_E("LNPS","SEL",2)&"&Lum3="&ID_num_E("LNPS","SEL",3)&""
	LinkStr=LinkStr&"&Lum4="&ID_num_E("LNPS","SEL",4)&"&Lum5="&ID_num_E("LNPS","SEL",5)&"&Lum6="&ID_num_E("LNPS","SEL",6)&""
	LinkStr=LinkStr&"&Lum7="&ID_num_E("LNPS","SEL",7)&"&Lum8="&ID_num_E("LNPS","SEL",8)&"&Lum9="&ID_num_E("LNPS","SEL",9)&""
	LinkStr=LinkStr&"&Lum10="&ID_num_E("LNPS","SEL",10)&"&Lum11="&ID_num_E("LNPS","SEL",11)&"&Lum12="&ID_num_E("LNPS","SEL",12)&""
	LinkStr=LinkStr&"&content="&mdate&"&name=SEL&Stimes=Y"

	
	
	LinkStrV="num1="&V_num_E("GNPS","SEL",1)&"&num2="&V_num_E("GNPS","SEL",2)&"&num3="&V_num_E("GNPS","SEL",3)&""
	LinkStrV=LinkStrV&"&num4="&V_num_E("GNPS","SEL",4)&"&num5="&V_num_E("GNPS","SEL",5)&"&num6="&V_num_E("GNPS","SEL",6)&""
	LinkStrV=LinkStrV&"&num7="&V_num_E("GNPS","SEL",7)&"&num8="&V_num_E("GNPS","SEL",8)&"&num9="&V_num_E("GNPS","SEL",9)&""
	LinkStrV=LinkStrV&"&num10="&V_num_E("GNPS","SEL",10)&"&num11="&V_num_E("GNPS","SEL",11)&"&num12="&V_num_E("GNPS","SEL",12)&""
	LinkStrV=LinkStrV&"&Lum1="&V_num_E("LNPS","SEL",1)&"&Lum2="&V_num_E("LNPS","SEL",2)&"&Lum3="&V_num_E("LNPS","SEL",3)&""
	LinkStrV=LinkStrV&"&Lum4="&V_num_E("LNPS","SEL",4)&"&Lum5="&V_num_E("LNPS","SEL",5)&"&Lum6="&V_num_E("LNPS","SEL",6)&""
	LinkStrV=LinkStrV&"&Lum7="&V_num_E("LNPS","SEL",7)&"&Lum8="&V_num_E("LNPS","SEL",8)&"&Lum9="&V_num_E("LNPS","SEL",9)&""
	LinkStrV=LinkStrV&"&Lum10="&V_num_E("LNPS","SEL",10)&"&Lum11="&V_num_E("LNPS","SEL",11)&"&Lum12="&V_num_E("LNPS","SEL",12)&""
	LinkStrV=LinkStrV&"&content="&mdate&"&name=SEL&V=Y"
	
	
	p "<table border=0 height=10% width=10% >"
	p "<tr><td align=left><table style='filter:glow(color=white,strength=2)'><tr><td align=center><font style='font-size:11pt;color=white'>SEL系统全年统计总表</font></td></tr></table></td></tr>"
	p "<table border=0 height=90% width=90% >"
	p "<tr bgcolor=#339933 >"
	p "<td height=30>&nbsp;<a href='javascript:window.print()'><font color=yellow><b>打印</b></font></a>&nbsp;&nbsp;<a href='javascript:window.close()'><font color=yellow><b>关闭</b></font></a></td>"
	p "<td  align=right>"
	p "&nbsp;"&sInputYear&"&nbsp;年&nbsp;"
	p "&nbsp;&nbsp;"
	p "1月&nbsp;至&nbsp;"&mmonht&"月"
	p "&nbsp;&nbsp;&nbsp;<font color=yellow><b>SEL</b></font> 系统放射性流出物排放结果&nbsp;&nbsp;&nbsp;&nbsp;"
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
	
	sub ListMain(Name)
		p "<tr style='color:black;text-align:center'><td rowspan=2 valign=top style='FONT-SIZE: 14px'><b>"&Name&"</b></td>"
		p "<td style='FONT-SIZE: 13px'>&nbsp;次数&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E(Name,"SEL",1)&"&nbsp;</td><td>&nbsp;"&ID_num_E(Name,"SEL",2)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E(Name,"SEL",3)&"&nbsp;</td><td>&nbsp;"&ID_num_E(Name,"SEL",4)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E(Name,"SEL",5)&"&nbsp;</td><td>&nbsp;"&ID_num_E(Name,"SEL",6)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E(Name,"SEL",7)&"&nbsp;</td><td>&nbsp;"&ID_num_E(Name,"SEL",8)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E(Name,"SEL",9)&"&nbsp;</td><td>&nbsp;"&ID_num_E(Name,"SEL",10)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E(Name,"SEL",11)&"&nbsp;</td><td>&nbsp;"&ID_num_E(Name,"SEL",12)&"&nbsp;</td>"
		p "<td>&nbsp;"&ID_num_E(Name,"SEL",0)&"&nbsp;</td></tr>"
		p "<tr style='color:black;text-align:center'><td style='FONT-SIZE: 13px'>&nbsp;体积(m3)&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E(Name,"SEL",1)&"&nbsp;</td><td>&nbsp;"&V_num_E(Name,"SEL",2)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E(Name,"SEL",3)&"&nbsp;</td><td>&nbsp;"&V_num_E(Name,"SEL",4)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E(Name,"SEL",5)&"&nbsp;</td><td>&nbsp;"&V_num_E(Name,"SEL",6)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E(Name,"SEL",7)&"&nbsp;</td><td>&nbsp;"&V_num_E(Name,"SEL",8)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E(Name,"SEL",9)&"&nbsp;</td><td>&nbsp;"&V_num_E(Name,"SEL",10)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E(Name,"SEL",11)&"&nbsp;</td><td>&nbsp;"&V_num_E(Name,"SEL",12)&"&nbsp;</td>"
		p "<td>&nbsp;"&V_num_E(Name,"SEL",0)&"&nbsp;</td></tr>"
		
	end sub
%>