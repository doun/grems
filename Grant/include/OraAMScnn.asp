<!--#include file="../include/mConstant.asp"-->

<%
'----------------------------------------------
'   �� �� �� �� ��
'   ����Ҫ�������ݿ����ʼ����
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
