<%
	//����Ƿ�����ŷų�ͻ
	function CheckConflict(cn,sID,sType)
	{
		
		if(sType=="SEL"||sType=="LIQ"||sType=="GAS")  return null
		//if(sType=="LIQ"||sType=="GAS")  return null				
		//1�����ţ�2����վ��3�����ͣ�4������/Һ�壻5���޺�/����
		var rs
		if(sType=="TER") 
		{
			rs=cn.execRs(
				"select a.id,decode(substr(a.id,1,1),'D','һ��','����'),sys_type,"
				+"decode(sys_type,'TER','Һ��','SEL','Һ��','LIQ','Һ��','����'),"
				+"b.bucket_no,decode(a.current_status,'HLT','�ȴ���λ/����','RLS','�ȴ��ŷ�','�����ŷ�') from "+sDBOwner+".grems_status a,"+sDBOwner
				+".grems_apply b where sys_type='TER' and a.current_status in ('RLG','HLT','RLS') and a.id=b.id order by sys_type"
			)
		}
		else
		{
			rs=cn.execRs(
				"select a.id,decode(substr(a.id,1,1),'D','һ��','����'),sys_type,"
				+"decode(sys_type,'TER','Һ��','SEL','Һ��','LIQ','Һ��','����'),"
				+"b.bucket_no,decode(a.current_status,'HLT','�ȴ���λ/����','RLS','�ȴ��ŷ�','�����ŷ�') from "+sDBOwner+".grems_status a,"+sDBOwner
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
					sReturn="�ŷų�ͻ������Ϊ["+r[i][0]+"]���ŷŵ�����"+r[i][5]+"״̬��������Ӧ��վ��������ϵ�������ŷ�ʧ��"
					return r[i]
				}	
			}
			return null
		}
		//�жϵ�ǰ�ŷ���Һ̬�ŷŻ�����̬�ŷ�
		var sGroup=(sType=="LIQ"||sType=="TER"||sType=="SEL")?"Һ��":"����"
		var sStation=((sID.substring(0,1)=="D")?"һ��":"����")
		//1�������һ����վ�Ƿ������ͬ����(����/Һ��)���ŷ�
		var sMsg="������һ��"+sGroup+"�ŷŴ��������ŷ�״̬��������Ӧ��վ��������ϵ"
		if((sType=="TER"&&f(sStation,sGroup,sMsg)!=null) 
			||(sType!="TER"&&f(sGroup,sMsg)!=null)) 
			return sReturn
			
		//2��������ͬһ��վ�Ƿ����ͬһ����(TER,SEL,etc)���ǹ޺�/����Ų���ͬ���ŷ�
		var x1=f(sType,"")
		//3�����		
		if(x1!=null&&sBucket!=x1[4])
			return sReturn
		return null
	}
%>