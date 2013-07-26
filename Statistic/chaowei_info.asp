<%@ Language=VBScript %>
<html>
<head>
<title>潮位表</title>
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
</head>
<style>
body {
 SCROLLBAR-FACE-COLOR: #4a4;
    SCROLLBAR-HIGHLIGHT-COLOR: white;
    OVERFLOW: auto;
    BORDER-LEFT: 0px;
    WIDTH: 100%;
    SCROLLBAR-SHADOW-COLOR: white;
    SCROLLBAR-3DLIGHT-COLOR: #4a4;
    SCROLLBAR-ARROW-COLOR: white;
    SCROLLBAR-TRACK-COLOR: #eef;
    BORDER-BOTTOM: 0px;
    SCROLLBAR-DARKSHADOW-COLOR: #4a4;
}
</style>
<body align=center>
<table align=center>
<tr align=center>
<td align=center>
<%id=trim(Request("id"))
if id="" or not IsNumeric(id) then
Response.Write "对不起，潮位表参数传递错误"
end if
sql="select tide_id,tide_pic_path,tide_date from "&Application("DBOwner")&".GREMS_TIDE where tide_id="&id&""
set conn=server.createobject("adodb.connection")
conn.open Application("GREMS_ConnectionString")
set rs=server.CreateObject("adodb.recordset")
rs.Open sql,conn,1,1
if not rs.EOF then
%>
<img  src='../Statistic/Tide_Pic/<%=rs("tide_pic_path")%>' >
<%
else%>
对不起，数据库中无此图片
<%
end if
rs.Close 
set rs=nothing
conn.Close 
set conn=nothing
%>
</td></tr></table>
</body>
</html>
