<!--#include file="pm.asp"-->
<%
	var oParser=new requestParser()
	var sUserID=oParser.parse("[USERID:s]").toUpperCase()
	var sPassword=oParser.parse("[PASSWORD:s]")
	var cn=new Connection()
	var rs=cn.execRs("select ep_id from "+sDBOwner+".grems_employee where ep_id="+sUserID+" and ep_passwd="+sPassword)
	var b=rs.eof
	Erase(cn)
	delete cn
	delete rs
	if(b) message("FAIL")
	else message("OK")
%>
