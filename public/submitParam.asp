<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ModeRule.asp"-->
<!--#include file="../include/ApplicationAdd.asp"-->
<%
	setReferer("Public/setParam.asp")
	var rp=new requestParser()
	var oNode=rp.oDoc.selectSingleNode("//DATA").firstChild
	var cn=new Connection()
	cn.Execute("UPDATE "+sDBOwner+".GREMS_PARAM SET PARAM_VALUE='"+oNode.text+"' WHERE PARAM_ID='"+oNode.nodeName+"'")
	ReBuildParam()
	message("OK!")
%>