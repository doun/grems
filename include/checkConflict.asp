<%
	//检查是否存在排放冲突
	function CheckConflict(cn,sID,sType)
	{
		
		if(sType=="SEL"||sType=="LIQ"||sType=="GAS")  return null
		//if(sType=="LIQ"||sType=="GAS")  return null				
		//1、单号；2、电站；3、类型；4、气体/液体；5、罐号/机组
		var rs
		if(sType=="TER") 
		{
			rs=cn.execRs(
				"select a.id,decode(substr(a.id,1,1),'D','一核','二核'),sys_type,"
				+"decode(sys_type,'TER','液体','SEL','液体','LIQ','液体','气体'),"
				+"b.bucket_no,decode(a.current_status,'HLT','等待潮位/气象','RLS','等待排放','正在排放') from "+sDBOwner+".grems_status a,"+sDBOwner
				+".grems_apply b where sys_type='TER' and a.current_status in ('RLG','HLT','RLS') and a.id=b.id order by sys_type"
			)
		}
		else
		{
			rs=cn.execRs(
				"select a.id,decode(substr(a.id,1,1),'D','一核','二核'),sys_type,"
				+"decode(sys_type,'TER','液体','SEL','液体','LIQ','液体','气体'),"
				+"b.bucket_no,decode(a.current_status,'HLT','等待潮位/气象','RLS','等待排放','正在排放') from "+sDBOwner+".grems_status a,"+sDBOwner
				+".grems_apply b where sys_type in ('ETY','TEG') and a.current_status in ('RLG','HLT','RLS') and a.id=b.id order by sys_type"
			)

		}
		
		
		if(rs.EOF) return null
		//(rs(0)==sID) return null
		
		var rcs=new VBArray(rs.GetRows())
		rs.close()
		sID=sID.replace(/'/g,"")
		rs.open("select bucket_no from "+sDBOwner+".grems_apply where id='"+sID+"'")
		sBucket=""+rs(0)
		rs=null
		var a=rcs.ubound(2)
		var b=rcs.ubound(1)		
		var r=[]
		var sReturn=""
		for(var i=0;i<=a;i++)
		{
			var r1=[]
			for(var j=0;j<=b;j++) r1[j]=rcs.getItem(j,i)
			r[i]=r1
		}
				
		delete rcs
		var f=function(x) 
		{
			var str="/"
			for(var i=0;i<arguments.length-1;i++)
				str+=(str=="/"?"":",.*")+arguments[i]			
			var res=eval(str+"/i")	
			for(var i=r.length-1;i>=0;i--)
			{
				if(res.exec(""+r[i])!=null && r[i][0]!=sID) {
					sReturn="排放冲突：单号为["+r[i][0]+"]的排放单处于"+r[i][5]+"状态，请与相应电站主控室联系。本次排放失败"
					return r[i]
				}	
			}
			return null
		}
		//判断当前排放是液态排放还是气态排放
		var sGroup=(sType=="LIQ"||sType=="TER"||sType=="SEL")?"液体":"气体"
		var sStation=((sID.substring(0,1)=="D")?"一核":"二核")
		//1、检查另一个电站是否存在相同类型(气体/液体)的排放
		var sMsg="至少有一项"+sGroup+"排放处于正在排放状态，请与相应电站主控室联系"
		if((sType=="TER"&&f(sStation,sGroup,sMsg)!=null) 
			||(sType!="TER"&&f(sGroup,sMsg)!=null)) 
			return sReturn
			
		//2、检查如果同一电站是否存在同一类型(TER,SEL,etc)但是罐号/机组号不相同的排放
		var x1=f(sType,"")
		//3、检查		
		if(x1!=null&&sBucket!=x1[4])
			return sReturn
		return null
	}
%>