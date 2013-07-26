<!--#include file="../include/flowsv.asp"-->
<%	
	var oCP=new ConstParser()
	var sUser=rp.parse("[__USER_NAME:s]")
	var sMark=rp.parse("[±¸×¢:s]")
	cn.begin()	
	rStatus("SQT")
	setUser("SAL")
	var rs=cn.execRs("SELECT * FROM"+owner+"SCALE WHERE ID="+sID)
	if(!rs.EOF)
	{
		var str=""
		for(var i=rs.Fields.count-1;i>=0;i--)
		{
			var sName=rs(i).Name
			if(sName=="ID") continue
			str+=sName+"="
			if(sName=="SCALE_MEMO") str+=sMark
			else if(sName=="SCALE_ID") str+=sUser
			else if(sName=="SCALE_DATE") str+="SYSDATE"
			else str+="null"
			str+=","
		}
		cn.Execute("UPDATE"+owner+"SCALE SET "+str.substring(0,str.length-1)+" WHERE ID="+sID)
	} else cn.Execute("INSERT INTO"+owner+"SCALE(ID,SCALE_ID,SCALE_MEMO,SCALE_DATE) VALUES("+sID+","+sUser+","+sMark+",SYSDATE)")
	cn.end()
	over()
%>