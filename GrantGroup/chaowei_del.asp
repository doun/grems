<%
checkbox=trim(Request.Form("checkbox"))
if checkbox="" then
%>
<script language=javascript>
	alert("��ѡ��Ҫɾ����Ŀ��");
	window.history.go(-1); 
</script>
<%
Response.End 
end if
'Response.Write checkbox
sql="delete from "&Application("DBOwner")&".GREMS_TIDE where tide_id in ("&checkbox&")"
set conn=server.createobject("adodb.connection")
conn.open Application("GREMS_ConnectionString")
'Response.Write sql
'Response.End 
conn.Execute(sql)
conn.Close 
set conn=nothing
if err.number<>0 then
%>
<script language=javascript>
	alert("ɾ�����ݿ��¼����");
	window.history.go(-1); 
</script>
<%Response.End 	
end if  
%>
<script language=javascript>
	alert("ɾ���ɹ�");
	window.location.href="chaowei_list.asp"  
</script>