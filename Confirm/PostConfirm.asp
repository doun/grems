<!--#include file="../include/flowsv.asp"-->
<%
	var iFlag1=parseInt(rp.parse("[BAGREE:x]"))
	var iFlag2=parseInt(rp.parse("[TOTER:x]"))
	var iFlag3=parseInt(rp.parse("[ACTIONFLAG:x]"))
	cn.begin()			
		setUser("COM")
		var rs=cn.execRs("select id from "+sDBOwner+".grems_confirm where id="+sID)
		if(rs.EOF) cn.Execute("insert into "+sDBOwner+".grems_confirm(id) values("+sID+")")
		rs=null		
		var sql="UPDATE "+sDBOwner+".GREMS_CONFIRM SET CONFIRM_DATE=SYSDATE,CONFIRM_ID="
			+rp.parse("[__USER_NAME:s]")+",CONFIRM_MEMO="+rp.parse("[±¸×¢:s]")
		var sql1=" WHERE ID="+sID	
		if(iFlag3==0)
		{
			sql+=sql1	
			rStatus("CAL")
		}
		else {if(iFlag1=="0")
			{
				rStatus("MQT")
				sql+=sql1
			} else {
				sql+=rSpecial+sql1
				if(iFlag2=="1") rStatus("CTA",iSpecial)
				else if(parseInt(iSpecial)>0) rStatus("CFM",iSpecial)
				else rStatus("RLS")
			}
		}	
		cn.Execute(sql)	
	cn.end()	
	over()
%>	