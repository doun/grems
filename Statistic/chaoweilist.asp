<%
'Response.Write Request.Form("userid")
'Response.End 
%>
<%Response.Expires=0%>
<html>
<style>
TABLE
{
    FONT-SIZE: 12px;
    WIDTH: 100%;
    BORDER-COLLAPSE: collapse
}
</style>
<head>


	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">


<title>用户</title>
<script language=javascript>
var oOpener
function openWin(link){
	//alert(link);
	openStr=link;
	var sStyle="left=150,top=50,height=440,width=300,center=1,scroll=0,status=0,directories=0,channelmode=0"
	oOpener=FocusWin(oOpener,openStr,sStyle);
	return false;
}
</script>
</script>
<%
mdate=trim(Request.Form("date_y"))
if mdate<>"" then
	mdate=mdate&"-01-01"
else
	mdate=date()
end if
mindate=year(mdate)&"-01-01"
mindate=dateadd("d",-1,mindate)
maxdate=year(mdate)&"-12-31"
ymdate=year(mdate)
'Response.Write mindate
sql="select tide_id,tide_pic_path,tide_date from "&Application("DBOwner")&".GREMS_TIDE  where tide_date > to_date('"&mindate&"','yyyy-mm-dd') and tide_date < to_date('"&maxdate&"','yyyy-mm-dd') order by tide_date asc"
set conn=server.createobject("adodb.connection")
conn.open Application("GREMS_ConnectionString")
set rs=server.CreateObject("adodb.recordset")
rs.Open sql,conn,1,1
if not rs.EOF then
	chaoweiArray=rs.GetRows
	chaoweiRows=ubound(chaoweiArray,2)
else
	chaoweiRows=-1
end if
'Response.Write chaoweiRows
%>

</head>
<script language=javascript>




function openWin(sUrl)
	{
		var sHeight=window.screen.availHeight-100
		var sWidth=window.screen.availWidth-100
		window.open(sUrl,"chaowei","height="+sHeight+",width="+sWidth+",left=50,top=50,location=0,scrollbars=1")
	}
	
function submitpage(){
	if(document.userForm.date_y.value!="0"){
		document.userForm.submit();   
	}
}



  

</script>

<body>
<form name=userForm method=post>
<input type=hidden name=selectMod>
<table border="0" width="100%" >
  
   <tr >
          <td bgcolor="#339933" 　colspan=6>
          <table border=0>
          <tr><td height=20 width=150>
          &nbsp;
          <font color=yellow><%=ymdate%>年度&nbsp;潮位表</font>
          </td>
          <td>
          <select name=date_y onchange="return submitpage()">
          <option value=0>请选择年度</option>
          <%for i=2003 to year(date())+1%>
          <option value=<%=i%>><%=i%>年</option>
          <%next%>
          </select>
          </td></tr>
          </table>
          </td>
        </tr>
  <tr>
    <td width="33%" colspan="2">
    <fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><img SRC="../images/collection.gif" WIDTH="16"> 潮位表</legend>
      <table name="TB_for_Write" ID="TB_for_Write" border="0" width="100%" bordercolorlight="#444444" bordercolordark="#339933">
     
      <tr><td height=10></td></tr>
      <%if chaoweiRows<>-1 then
         for i=0 to chaoweiRows
           if i mod 3 =0 then%>
          </tr><tr>
           <%end if%>
      <td align=center>
      <table border=0><tr><td align=center>
      <a href="javascript:openWin('../Statistic/chaowei_info.asp?id=<%=chaoweiArray(0,i)%>');"><img src='../Statistic/Tide_Pic/<%=chaoweiArray(1,i)%>' width=80  height=80   style="BORDER:1px solid #3c3;color:black;"></a>
      </td></tr>
      <tr><td align=center>
      <%=year(chaoweiArray(2,i))%>年<%=month(chaoweiArray(2,i))%>月
      </td></tr>
      <tr><td height=10></td></tr>
      </table>
      </td>
      <% next
      else%>
      <tr><td height=10></td></tr>
      <tr><td height=30 align=center>没有任何&nbsp;<font color=red><%=ymdate%></font>年度&nbsp;潮位表信息,如要查询&nbsp;<%=ymdate%>年度&nbsp;潮位表，请与管理员联系．</td></tr>
      <tr><td height=30></td></tr>
      <%
        end if%>
      </table>
     
      
    </td>
  </tr>
  
</table>
</form>

</body>

</html>
