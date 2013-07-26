<!--#include file="../include/flowsv.asp"-->
<%
	var oCP=new ConstParser()
	var sUser=rp.parse("[__USER_NAME:s]")
	var flag=""+Request.QueryString("ActionFlag")	
	cn.begin()
	rStatus(flag=="true"?"APP":"SMP")
	if(flag!="true")
	{
		var rs=cn.execRs("SELECT COUNT(1) FROM "+sDBOwner+".GREMS_SAMPLE WHERE ID="+sID)
		var iCount=parseInt(rs(0))
		var sql2
		delete rs
		if(iCount==0)	
			sql2="INSERT INTO "+sDBOwner+".GREMS_SAMPLE(ID,SAMPLE_UID,SAMPLE_DATE) VALUES("+sID+","+sUser+",SYSDATE)"
		else 
			sql2="UPDATE "+sDBOwner+".GREMS_SAMPLE SET SAMPLE_DATE=SYSDATE,SAMPLE_UID="+sUser+" WHERE ID="+sID
	}	else sql2="UPDATE "+sDBOwner+".GREMS_SAMPLE SET SAMPLE_UID=NULL,SAMPLE_DATE=NULL WHERE ID="+sID
	cn.Execute(sql2)
	setUser("SAM")
	cn.end()	
	over()
%>