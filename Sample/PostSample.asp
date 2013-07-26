<!--#include file="../Library/form.asp"-->
<%
	var oCP=cp
	var sPub1=oCP.getParam("PUBNUM1",sType,2)
	var sPub2=oCP.getParam("PUBNUM2",sType,2)
	var sMemo=oCP.getParam("SAMPLE_MEMO",sType,2)	
	var sUserName=Request.Form("__USER_NAME")	
%>

<script>
	function oFun()
	{
		oForm.InitForm("tblMain")
		s=(parent.ReleaseStation.innerText.Trim()=="大亚湾核电站")?"D":"L"
		if(sGroup=="LIQ"&&sType!="LIQ")
		{
			var o1=罐号.options
			var re=/\w?(\d\w+)/
			for(var i=1;i<o1.length;i++)
			{
				o1[i].text=o1[i].value=o1[i].text.replace(re,s+"$1")				
			}		
		}
	}
	function submitForm()
	{	
		var bReturn=oForm.PostForm(tblMain,checkForm,funResult)
	}
	function oAdd(oFormInst,dom,data)
	{
		var sSpecial=null
		reset()		
		var s=new Date(parent.LevelApply.all['签发时间'].children[0].innerHTML.replace(/\-/g,"/"))
		var _sampleDate=GetTime("取样时间")
		if(_sampleDate==null) return false
		var iLeft=_sampleDate-s.getTime()
		if(iLeft<0)
		{
			alert1("取样时间不能早于提交申请单的时间！",取样时间)
			return false
		}
		
		if(sType=="ETY")
		{
			var _sampleDate=GetTime("放样时间")
			if(_sampleDate==null) return false
			var iLeft=_sampleDate-s.getTime()
			if(iLeft<0)
			{
				alert1("放样时间不能早于提交申请单的时间！",放样时间)
				return false
			}
			var iLeft=testDate("放样时间","取样时间",1)
			if(iLeft==null) return false			
			iLeft=-iLeft/3.6E6  //获取的值是反的，为了不影响其他模块，在前面加负号。胡方能 2004－5－31
			var _x=getParam1("ETY_STOCK")
				 //var a=bunt("iLeft="+iLeft+"  _X="+_x+" 个小时")   测试用 胡方能
			if(iLeft<=_x)
			{
				 if(!bunt("取样时间少于 "+_x+" 个小时")) return false
			}			
		}		
		if(sGroup=="LIQ")
		{
			var s1,s2
			if(sType=="LIQ") {
				系统号.value=系统号.value.toUpperCase().Trim()
				s1="系统号";s2=系统号.value
			}
			else {s1="罐号";s2=罐号.options[罐号.selectedIndex].innerText.Trim()}
			var s=parent.LevelApply.all[s1].innerText.Trim()
			if(s!=s2)
			{
				alert1("取样时的"+s1+"与申请单的"+s1+"不一致！",document.all[s1])
				return false
			}
			if(sType!="LIQ")
			{
				var s=new Date(parent.LevelApply.all['循环开始时间'].children[0].innerHTML.replace(/\-/g,"/"))
				var iLeft=(_sampleDate-s.getTime())/(3.6E6)
				var iTest=getParam1(sType+"_STOCK")
				if(iLeft<iTest)
				{
					if(!bunt("循环时间小于"+iTest+"小时")) return false
				}
			}
		}
		
		return true		
	}
</script>
<table style='height:1' id=tblMain action="../Sample/DoSample.asp">
<col width=20% align=right><col width=30%><col width=20% align=right>
<%
	var cn=new Connection()
	var rs=cn.execRs("SELECT * FROM "+sDBOwner+".GREMS_SAMPLE WHERE ID='"+sID+"'")
	
	function getValue(col)
	{
		if(rs.EOF) return ""
		var sValue=""+rs(col)
		if(sValue=="N/A"||sValue=="null") return ""
		return sValue.replace("[R]","")
	}
	var str="<tr>",iMax1,iMin1
	var sValue=getValue("PUBNUM1")
	if(sGroup=="LIQ")
	{
		if(sType!="LIQ")
		{
			iMax1=10
			iMin1=0.5
			if(sValue.length!=0) sValue=sValue.substring(6,7)
			str+="<FormItem:select text='"+sPub1+"' size=1 xstyle='margin-left:10' allownull='f' value='"+sValue+"'>\n"
				+ "<FormItem:option value=''></FormItem:option>\n"
			for(var i=1;i<4;i++)
			{
				var sBucket="0"+sType+"00"+i+"BA"
				str+="<FormItem:option value='"+sBucket+"'>"+sBucket+"</FormItem:option>\n"
			}	
			str+="</FormItem:select>"
		} else {
			iMin1=""
			str+="<FormItem:text type='s' min=5 max=10 text='"+sPub1+"' value='"+sValue+"' />"
		}	
	} else {
		iMin1=0
		var iMin3="0"
		var iMax
		if(sType=="TEG") {iMax=5;iMax1=5}
		else if(sType=="ETY") {iMax=500;iMax1=100}
		else {iMax=1000;iMin3="";iMin1="";iMax1="100"}
		str+="<FormItem:text datatype='f' alert='请确认“"+sPub1.replace(/\(.*\)/,"")+"”的体积！' text='"+sPub1+"' value='"+sValue+"' min='"+iMin3+"' suf='3'  max='"+iMax+"' />\n"
	}
	str+="<FormItem:text datatype='f' alert='请确认“"+sPub2.replace(/\(.*\)/,"")+"”的值！' text='"
		+sPub2+"' value='"+getValue("PUBNUM2")+"' min='"
		+iMin1+"' suf='3' max='"+iMax1+"' /></tr>\n"
	var iMin2=""	
	if(sType=="ETY")
	{
		var rs1=cn.execRs("SELECT EP_NAME FROM "+sDBOwner+".GREMS_EMPLOYEE WHERE EP_WORKGROUP LIKE '%GP003%'")
		str +="<tr><FormItem:select allownull='f' text='"
			+oCP.getParam("START_USER",sType,2)
			+"' value='"+getValue("START_USER")+"' >\n"
			+"<FormItem:option value='' ></FormItem:option>"
		while(!rs1.eof) {
			var __sEPName=rs1(0)
			str+="<FormItem:option value='"+__sEPName+"' >"+__sEPName+"</FormItem:option>"
			rs1.MoveNext()
		}	
		str+="</FormItem:select>"
		delete rs1
		str	+="<FormItem:date datatype='date' text='"
			+oCP.getParam("START_DATE",sType,2)
			+"' value='"+getValue("START_DATE")+"' /></tr>\n"
	} else if(sType=="LIQ"||sType=="GAS") iMin2=""	
	// -----------by lb iMin2="min=4"
	
	str +="<tr><FormItem:text datatype='s' text='"
		+oCP.getParam("SAMPLE_UID",sType,2)
		+"' value='"+sUserName+"' min=2 max='10' readOnly />\n"
		+"<FormItem:date datatype='date' text='"
		+oCP.getParam("SAMPLE_DATE",sType,2)
		+"'  /></tr><tr>"
		+"<FormItem:textbox datatype='s' value='"+getValue("SAMPLE_MEMO")+"' text='"+sMemo+"' "+iMin2+" max=255  /></tr>"
		
	Response.Write(str)
	delete rs
	Erase(oCP)
	Erase(cn)
	delete cn
%>
</table>
<script>button("提交||submitForm()")</script>

</body>