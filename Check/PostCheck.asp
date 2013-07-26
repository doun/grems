<!--#include file="../include/flowsv.asp"-->
<%
	var bFlag=rp.parse("[BFLAG:x]")
	var bFlag=(bFlag=="0")?"CHK":(bFlag==1?"CQT":"SQT")
	var sID=rp.parse("[ÅÅ·Åµ¥ºÅ]")	
	cn.begin()			
		rStatus(bFlag)
		setUser("CHK")
		var rs=cn.execRs("select id from "+sDBOwner+".grems_check where id="+sID)
		if(rs.EOF) cn.Execute("insert into "+sDBOwner+".grems_check(id) values("+sID+")")
		rs=null		
		var str="UPDATE "+sDBOwner+".GREMS_CHECK SET CHECK_DATE=SYSDATE,CHECK_ID="
			+rp.parse("[__USER_NAME:s]")+",CHECK_MEMO="+rp.parse("[±¸×¢:s]")
			+" WHERE ID="+sID
		cn.Execute(str)		
	cn.end()	
	over()
%>	