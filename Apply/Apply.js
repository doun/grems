	function resetBucket(o,flag)
	{
		if(flag==true) return true
		o.value=o.value.toUpperCase()
		return true
	}
	function setCounter(iA,iB,iC)
	{
		SEC单台投运数.value=iA+"台"	
		SEC整列投运数.value=iB+"列"
		CRF泵投运台数.value=iC+"台"
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
			罐号.innerHTML=""
			if(s=="D") {iStart=2;iEnd=7}
			else {iStart=4;iEnd=11}
			var ops=罐号.options
			ops.add(new Option())
			//var sOps="<option value=''></option>"
			var s2="000"
			for(var i=iStart;i<=iEnd;i++)
			{
				var s3=s2.replace(new RegExp("^(\\d*)\\d{"+(""+i).length+",}$"),"$1"+i)
				
				s3=s+"9TEG"+s3+"BA"
				ops.add(new Option(s3,s3))
			}
			
			//罐号.innerHTML=sOps
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
				iGroup=反应堆号.value.substring(0,1)
				break
			case "SEL":
			case "TER":	
				var f=function(o) {
					return parseInt(o.value.replace(/[^\d]+/g,""))
				}

				if(formType=="TER") {
					var iA=f(SEC单台投运数)*3400
					var iB=f(SEC整列投运数)*4500
					var iC=f(CRF泵投运台数)*76000
					wLoader.push("SEAWATER_FLOW",iA+iB+iC)				
				}	
			
				if(GetTime("循环开始时间")==null)	return false
				
			case "LIQ":				
				iGroup=0
				break
			case "TEG":
				iGroup=9
				var s=parseInt(/00?(\d+)/.exec(罐号.value)[1])
				var _x=getParam1("TEG_STOCK")
				if((Station=='D'&&s>7)||(Station=='L'&&s<4))
				{
					alert1("一核的罐号在002-007之间，二核则在004-011之间")
					return false
				}	
				var d1=GetTime("充气结束时间")
				if(d1==null) return false
				var d2=new Date().getTime()-_sCurrentTime
				if(((d2-d1)/(3.6E6*24))<_x)
				{
					if(bunt("衰变时间小于"+_x+"天")==false) return false
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