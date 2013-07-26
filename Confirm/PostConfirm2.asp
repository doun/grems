<!--#include file="../include/flowsv.asp"-->
<%
	var bFlag=(parseInt(rp.parse("[BFLAG:x]"))==1)?"RLS":"CAL"	
	cn.begin()					
		rStatus(bFlag)
		setUser("CM2")
		var str="UPDATE "+sDBOwner+".GREMS_CONFIRM SET CONFIRM2_DATE=SYSDATE,CONFIRM2_ID="
			+rp.parse("[__USER_NAME:s]")+",CONFIRM2_MEMO="+rp.parse("[±¸×¢:s]")
			+" WHERE ID="+sID
		cn.Execute(str)
	cn.end()
	over()	
%>	