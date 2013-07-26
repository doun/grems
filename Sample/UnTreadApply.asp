<!--#include file="../include/flowsv.asp"-->

<%
	var oCP=new ConstParser()
	var sUser=rp.parse("[__USER_NAME:s]")
	var sMark=oCP.getParam("SAMPLE_MEMO",sType,1)	
	sql2="UPDATE "+sDBOwner+".GREMS_SAMPLE SET SAMPLE_MEMO="+rp.parse("["+sMark+":s]")
		+",SAMPLE_UID="+sUser+",SAMPLE_DATE=sysdate,START_USER=NULL,START_DATE=NULL,PUBNUM1=NULL,PUBNUM2=NULL"
		+" WHERE ID="+sID
	cn.begin()	
	rStatus("AQT")
	setUser("SAM")	
	var rs=cn.execRs("SELECT * FROM "+owner+"SAMPLE WHERE ID="+sID)
	if(rs.EOF) cn.Execute("INSERT INTO "+owner+"SAMPLE(ID) VALUES("+sID+")")	
	cn.Execute(sql2)	
	cn.end()
	over()
%>