<%
	'2003-2-20,ʹ��OLE DB����ԭ����ODBC����
	dim sDBOwner
	sDBOwner=Application("DBOwner")
	Function getConnString()
		getConnString=Application("GREMS_ConnectionString")
	END Function	
	Function Open_Connect()
		set Open_Connect=server.CreateObject("ADODB.CONNECTION")
		Open_Connect.CursorLocation=2
		Open_Connect.Open getConnString()
	End Function
	'����ֻ������ǰ��Recordset�������ж����ݿ�ĸ���Ӧ����
	'Connection��������ɡ�
	Function Open_Record(SqlStr)
		set Open_Record=server.CreateObject("ADODB.RECORDSET")
		Open_Record.CursorLocation=2
		Open_Record.LockType=1
		'Open_Record.CursorType=1
		Open_Record.CacheSize=10
		Open_Record.Open Sqlstr,getConnString()
	End Function	
	Function Get_rec()
		set Get_rec=server.CreateObject("ADODB.RECORDSET")
		Get_rec.CursorLocation=2
		Get_rec.LockType=1
		Get_rec.CursorType=1
		Get_rec.CacheSize=10
		set Get_rec.ActiveConnection=Open_Connect()
	End Function
	
%>
