	var oPopB=window.createPopup()
	document.write('<DOWNLOAD ID=dwn STYLE="behavior:url(#default#download)" />')	
	dwn.startDownload('../Public/bong.asp',onDownLoadDone)
	function onDownLoadDone(src) {oPopB.document.write(src);}
	function MakeContent(bFlag)
	{
		var sText=""
		if(bFlag==null) 
		sText="filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=0, "+
				"	StartColorStr=\"#44aa44\", EndColorStr=\"#FFFFFF\");border:1px solid white;"
		var str="<table style='background-color:#4a4;"+sText+"height:100%'>"
		var sText1=""		
		if(bFlag==null) {
			sText1="<td></td>"
			str+="<tr><td style='width:1'>&nbsp;</td><td style='text-align:center;height:1;font:14px;progid:DXImageTransform.Microsoft.Gradient(GradientType=0, "+
				"	StartColorStr=\"#FFFFFF\", EndColorStr=\"#44aa44\")' id=tdTitle>&nbsp;</td><td style='width:1'>&nbsp;</td></tr>"
		}	
		str+="<tr>"+sText1+"<td style='background-color:#8e8;padding:5;border:1px solid white;border-top:1pt inset #afa;filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=0, "+
			"		StartColorStr=\"#FFFFFF\", EndColorStr=\"#44aa44\")'>"+
			"<div id=divInputField style='width:100%;height:1'>"	
		return str
	}
	function button(str,bFlag)
	{
		var ary=str.split(":")
		var str1=""
		var f=function (X,Y) {
			if(str1!="") str1+="&nbsp;&nbsp;"
			str1+="<button class='btnSubmit' onclick='this.blur();"+X+"'><nobr>"+Y+"</nobr></button>"
		}
		for(var i=0;i<ary.length;i++)
		{
			var ary1=ary[i].split("||")
			f(ary1[1],ary1[0])
		}
		var sText1=""
		if(bFlag==null) {f("parent.location.reload(true)","取消");sText1="<td></td>"}
		str1="</div></td>"+sText1+"</tr><tr><td style='height:5'></td></tr><tr>"+sText1+"<td style='height:1;text-align:center'>"+str1+"</td></tr><tr><Td style='height:5'></td>"+sText1+"</tr></table>"
		if(bFlag==null) document.write(str1)
		else return str1
	}
	function GetTime(_s1)
	{
		var _o=eval(_s1)
		if(_o==null) _o=document.all[_s1]
		if(_o==null) {alert("找不到“"+_s1+"”这个时间字段！");return}
		var	_oDate=new Date(DateHandler.CheckDate(_o).replace(/\-/g,"/")).getTime()
		var _sDate=new Date().getTime()-_sCurrentTime
		var _o2=new Date(_sDate)
		var _soDat=_o2.getYear()+"-"+(_o2.getMonth()+1)+"-"+_o2.getDate()+" "+_o2.getHours()+":"+_o2.getMinutes()
		var _sInfo="系统当前时间("+_soDat+")"
		var _iLeft=_oDate-_sDate
		if(_iLeft>0)
		{		
			alert1("“"+_s1+"”不能晚于"+_sInfo+"！",_o)
			return
		}
		return _oDate
	}	
	function testDate(_s1,_s2,bFlag)
	{	
		var _sInfo,_sDate
		var _o=GetTime(_s1)
		var _o1=GetTime(_s2)	
		if(_o==null||_o1==null) return		
		var _iLeft=_o-_o1
		if(_iLeft>0)
		{
			if(bFlag!=null&&_s2!=null) alert1("“"+_s2+"”不能早于“"+_s1+"”！",_o1)
			else alert1("“"+_s1+"”不能晚于“"+_s2+"”！",_o)
			return
		}
		return _iLeft
	}
	function cst()
	{
		return window.confirm("您的填写的信息将会被提交，是否继续？")
	}
	function selWin(o)
	{		
		if(o!=null) o.blur()
		var _x=screen.availWidth
		var _y=screen.availHeight
		_x=(_x-420)/2
		_y=(_y-350)/2
		oPopB.show(_x,_y,420,350)
		
	}
	function getParam1(_s)
	{
		return eval(oParamList[_s])
	}
	