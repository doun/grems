<!--#include file="../include/flowsv.asp"-->
<%

	var oCP=new ConstParser()
	var sPub1=oCP.getParam("PUBNUM1",sType,1)
	var sPub2=oCP.getParam("PUBNUM2",sType,1)
	var sSID=oCP.getParam("SAMPLE_UID",sType,1)
	var sSDT=oCP.getParam("SAMPLE_DATE",sType,1)
	var sSID1=oCP.getParam("START_USER",sType,1)
	var sSDT1=oCP.getParam("START_DATE",sType,1)
	var sMark=oCP.getParam("SAMPLE_MEMO",sType,1)
	var ssPub1=rp.parse("["+sPub1+":s]")
	cn.begin()
	var rs=cn.execRs("SELECT ID FROM "+sDBOwner+".GREMS_SAMPLE WHERE ID="+sID)
	if(rs.EOF)
	{
		cn.Execute("INSERT INTO "+sDBOwner+".GREMS_SAMPLE(ID) VALUES("+sID+")")
	}
	delete rs
	var sql="UPDATE "+sDBOwner+".GREMS_SAMPLE SET PUBNUM1="+ssPub1+",PUBNUM2=["+sPub2+":i],"
		+"SAMPLE_UID=[__USER_NAME:s],SAMPLE_DATE=["+sSDT+":d],START_USER=["+sSID1
		+":s],START_DATE=["+sSDT1+":d],SAMPLE_MEMO=["+sMark
		+":s]"+rSpecial+" WHERE ID="+sID	
	rStatus("ALS",iSpecial)
	setUser("SAM")
	cn.Execute(rp.parse(sql))
	cn.end()	
	over()
%>