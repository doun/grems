<!--#include file="../include/mConstant.asp"-->

<%
'----------------------------------------------
'   连 接 数 据 库
'   在需要连接数据库程序开始加上
'   
'----------------------------------------------
	
dim OraAmsCnn
dim OraAmsRs

set OraAmsCnn = Server.CreateObject("ADODB.Connection")
set OraAmsRs = Server.CreateObject("ADODB.recordset")  

'oraAmsRs.ActiveConnection = oraAmsCnn
OraAmsCnn.CommandTimeout = Application("OraAmscnn_CommandTimeout")
OraAmsCnn.ConnectionTimeout = Application("OraAmscnn_ConnectionTimeout")
OraAmsCnn.CursorLocation = Application("OraAmscnn_CursorLocation")
OraAmscnn.Open Application("OraAmscnn_ConnectString")

%>
