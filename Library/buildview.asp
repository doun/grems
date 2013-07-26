<!--#INCLUDE FILE="../INCLUDE/PM.ASP"-->
<%
	var cn=new Connection()
	var a=["STATUS","STATUS_INFO","APPLY","SAMPLE","SCALE","CHECK","CONFIRM","RELEASE","EXECUTER"]
	var a1=["A","B","C","D","E","F","G","H","I"]
	var rs
	sql="SELECT A.ID,"
	sql1=" FROM "
	
	var sFolder=/([^\/]*\/)[^\/]*$/.exec(Request.ServerVariables("SCRIPT_NAME"))[1]
	sFolder=sFolder.substring(0,sFolder.length-1).toUpperCase()
	for(var i=0;i<a.length;i++)
	{
		rs=cn.execRs("SELECT * FROM GREMS_"+a[i]+" where 1=2")
		var x=rs.Fields				
		if(i!=0) sql+="<br>"
		for(var j=0;j<x.count;j++)
		{
			var x1=a1[i]+"."+x.item(j).Name
			if(""+x.item(j).Type=="135") 
			x1="TO_CHAR("+x1+",'YYYY-MM-DD HH24:MI')"
			if(x1!="ID")
			sql+=x1+" AS "+a[i]+"_"+x.item(j).Name+","
		}
		sql1+="GREMS_"+a[i]+" "+a1[i]+","
		
	}
	y=sql.substring(0,sql.length-1)+"<br>"+sql1.substring(0,sql1.length-1)
	y+="<BR> WHERE A.CURRENT_STATUS=B.CURRENT_STATUS AND A.ID=I.ID(+) AND A.ID=H.ID(+) AND A.ID=G.ID(+) AND A.ID=C.ID(+) AND A.ID=D.ID(+) AND A.ID=E.ID(+) AND A.ID=F.ID(+)"
	Response.Write(y)
	//cn.Execute("delete grems_status")
%>