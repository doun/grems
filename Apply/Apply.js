	function resetBucket(o,flag)
	{
		if(flag==true) return true
		o.value=o.value.toUpperCase()
		return true
	}
	function setCounter(iA,iB,iC)
	{
		SEC��̨Ͷ����.value=iA+"̨"	
		SEC����Ͷ����.value=iB+"��"
		CRF��Ͷ��̨��.value=iC+"̨"
	}
	function checkStation(o)
	{
		var s=""
		if(typeof(o)!="string")
		{
			o.blur()			
			if(StationD.checked) s="D"
			else if(StationL.checked) s="L"
		} else s=o	
		if(s==""||sType=="LIQ"||sType=="GAS") return
		var o1=document.getElementsByTagName("SELECT")[0].options
		if(sType=="TEG") {
			var iStart,iEnd			
			�޺�.innerHTML=""
			if(s=="D") {iStart=2;iEnd=7}
			else {iStart=4;iEnd=11}
			var ops=�޺�.options
			ops.add(new Option())
			//var sOps="<option value=''></option>"
			var s2="000"
			for(var i=iStart;i<=iEnd;i++)
			{
				var s3=s2.replace(new RegExp("^(\\d*)\\d{"+(""+i).length+",}$"),"$1"+i)
				
				s3=s+"9TEG"+s3+"BA"
				ops.add(new Option(s3,s3))
			}
			
			//�޺�.innerHTML=sOps
		} else {		
			var re=/\w?(\d\w+)/
			for(var i=1;i<o1.length;i++)
			{
				o1[i].text=o1[i].text.replace(re,s+"$1")
				o1[i].value=o1[i].value.replace(re,s+"$1")
			}
		}
		return s		
	}
	function checkSpecial(formType)
	{
		sSpecialMemo=''
		switch(formType)
		{
			case "ETY":
				iGroup=��Ӧ�Ѻ�.value.substring(0,1)
				break
			case "SEL":
			case "TER":	
				var f=function(o) {
					return parseInt(o.value.replace(/[^\d]+/g,""))
				}

				if(formType=="TER") {
					var iA=f(SEC��̨Ͷ����)*3400
					var iB=f(SEC����Ͷ����)*4500
					var iC=f(CRF��Ͷ��̨��)*76000
					wLoader.push("SEAWATER_FLOW",iA+iB+iC)				
				}	
			
				if(GetTime("ѭ����ʼʱ��")==null)	return false
				
			case "LIQ":				
				iGroup=0
				break
			case "TEG":
				iGroup=9
				var s=parseInt(/00?(\d+)/.exec(�޺�.value)[1])
				var _x=getParam1("TEG_STOCK")
				if((Station=='D'&&s>7)||(Station=='L'&&s<4))
				{
					alert1("һ�˵Ĺ޺���002-007֮�䣬��������004-011֮��")
					return false
				}	
				var d1=GetTime("��������ʱ��")
				if(d1==null) return false
				var d2=new Date().getTime()-_sCurrentTime
				if(((d2-d1)/(3.6E6*24))<_x)
				{
					if(bunt("˥��ʱ��С��"+_x+"��")==false) return false
					else sSpe='1'
				}				
				break
			case "GAS":
				iGroup=9
				break
			default:return false
				
		}		
		return true
	}