<%
FormSize=Request.TotalBytes
FormData=Request.BinaryRead(FormSize)

function ImageUp(formsize,formdata)
	bncrlf=chrb(13)&chrb(10)
	divider=leftb(formdata,instrb(formdata,bncrlf)-1)
	datastart=instrb(formdata,bncrlf&bncrlf)+4
	dataend=instrb(datastart+1,formdata,divider)-datastart
	imageup=midb(formdata,datastart,dataend)
end function
Image=ImageUp(FormSize,Formdata)


'Response.Write Image
'response.contenttype="image/gif"
'response.binarywrite Image
'Response.End 
'set conn1=server.createobject("adodb.connection")
'conn1.open Application("GREMS_ConnectionString")

sql="select * from "&Application("DBOwner")&".GREMS_TIDE "
SET OraSEESION=CreateObject("OracleInProcServer.XOraSession")
Set OraDatabase = OraSEESION.OpenDatabase("ORAT62", "GREMS/GREMS", Cint(0))
Set OraDynaset = OraDatabase.DbCreateDynaset(sql, cint(0)) 
OraDynaset.edit
OraDynaset("tide_pic").AppendChunk Image
OraDynaset.update
OraDynaset.close
set OraSEESION=nothing

'set conn=server.createobject("adodb.connection")
'conn.open Application("GREMS_ConnectionString")
sql="select * from "&Application("DBOwner")&".GREMS_TIDE "
SET OraSEESION=CreateObject("OracleInProcServer.XOraSession")
Set OraDatabase = OraSEESION.OpenDatabase("ORAT62", "GREMS/GREMS", Cint(0))
Set OraDynaset = OraDatabase.DbCreateDynaset(sql, cint(0))
'set rs=server.CreateObject("adodb.recordset")
'rs.Open sql,conn,1,1   
if OraDynaset("tide_pic")=Image then

Response.Write "11" 
end if
response.contenttype="image/gif"
Response.BinaryWrite Image

'set rs=server.CreateObject("adodb.recordset")
'rs.Open sql,conn1,3,3    
'if not rs.EOF then
'rs(1).AppendChunk 
'rs.AddNew 
'rs.Edit 
'rs("wg_name")="xyh"
'rs("WG_NAME")="ฤใบร"
'rs.Update 
'end if
'sql="update "&Application("DBOwner")&".GREMS_TIDE set tide_id="&Image
'sql=sql&"'"
'Response.Write sql
Response.End 
'conn1.Execute(sql) 
'conn1.close
'set conn1=nothing
%>