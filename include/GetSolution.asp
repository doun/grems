<!--#include file="pm.asp"-->
<%
	var oDoc=getDom()
	oDoc.load(""+Application("GlobalPath")+"flowHandler.xml")
	CheckDom(oDoc)
%>