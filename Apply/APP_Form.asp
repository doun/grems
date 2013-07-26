<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ConstParser.asp"-->
<%	
	var rParser=new requestParser()
	var sType=rParser.parse("[排放类型:x]")
	var sID=rParser.parse("[排放单号:s]")
	var rs=null,cn
	function getValue(sCol)
	{
		if(rs==null) return ""
		if(rs.EOF) return ""
		var sValue=""+rs(sCol)
		if(sValue==""||sValue=="null"||sValue=="N/A") return ""
		return sValue
	}
//	sID="'D0TER20030001'"
	if(sID!="'N/A'") {
		cn=new Connection()
		rs=cn.execRs("SELECT * FROM "+sDBOwner+".GREMS_APPLY WHERE ID="+sID)
		Erase(cn)
	}
	if(sType=="N/A") clear("错误的申请类型！")
	var oParser=new ConstParser()		
	var BUCKET_NO=oParser.getParam("BUCKET_NO",sType,2)
	var APPLY_ID=oParser.getParam("APPLY_USRID",sType,2)
	var APPLY_DATE=oParser.getParam("APPLY_DATE",sType,2)
	var APPLY_MEMO=oParser.getParam("APPLY_MEMO",sType,2)
	var LIQUT_ALTITUDE=oParser.getParam("LIQUT_ALTITUDE",sType,2)
	var CYCLE_TIME=oParser.getParam("CYCLE_TIME",sType,2)
	var userName=rParser.parse("[__USER_NAME:x]")
	var ID=oParser.getParam("ID",sType,2)
	var sOutput ="<table id='formposter' action='../apply/PostApply.asp' style=';height:1;font-size:12px'>"
				+"<col align=right width='25%' >"
				+"<col width='25%' >"
				+"<col align=right width='25%' ><tr>"
	var sValue1=getValue("BUCKET_NO")	
	var pre,suf,iLength,start
	start=0					
	if(sType=="ETY") {
		iLength=2;pre="";suf="号机"
	} else if(sType=="TEG") {
		start=1
		iLength=11
		pre="9TEG00"
		suf="BA"
	}
	else {
		iLength=3;
		pre=""+(sType=="TEG"||sType=="GAS"?9:0)+sType+"00";
		suf="BA"
	}	
	if(sType!="LIQ"&&sType!="GAS")
	{
		sOutput +="<FormItem:select text='"+BUCKET_NO+"' size=1 xstyle='margin-left:10' allownull='f' value='"+sValue1+"'>"
				+ "<FormItem:option value='' ></FormItem:option>"
		for(var i=start;i<iLength;i++)
		{
			var x1
			var x=""+(i+1)
			if(x.length==2) x1=pre.substring(0,pre.length-1)
			else x1=pre
			var sValue=x1+x+suf
			sOutput+="<FormItem:option value='"+sValue+"'>"+sValue+"</FormItem:option>"
		}
		sOutput+="</FormItem:select>"
	} else {
		sOutput+="<FormItem:text oncheck='resetBucket(oInput,bFlag)' datatype='s' min=5 max=10 text='"+BUCKET_NO+"' value='"+sValue1+"' />"
	}	
	Response.Write(sOutput)
	if(sType=="TER") {
%>		
		<FormItem:text min=3 onmousedown='selWin(this)' onfocus='this.blur()' text="<%=oParser.getParam("CRF_PUMPS","TER",2)%>" datatype='s' value='<%=getValue("CRF_PUMPS")%>' />
	</tr><tr>
		<FormItem:text min=3 onmousedown='selWin(this)' onfocus='this.blur()' text="<%=oParser.getParam("SEC_PUMPS","TER",2)%>" datatype='s' value='<%=getValue("SEC_PUMPS")%>' />
		<FormItem:text min=3 onmousedown='selWin(this)' onfocus='this.blur()' text="<%=oParser.getParam("SEC_STAGES","TER",2)%>" datatype='s' value='<%=getValue("SEC_STAGES")%>' />
		</tr>
		<tr>
<% 
	} 
	var def
	switch(sType)
	{
		case "TER":
		case "SEL":
			def="min=0.5 suf='2' max=10"
			break
		case "TEG":	
			def="min=0.5 suf='3' max=7"
			break
		case "ETY":
			def="min=950 suf='2' max=2000 alert='t' "
			break
		case "GAS":	
			def=" suf='3' max=7 min=0.5 "
			break
		default:
			def=" suf='2' max=10000 "
	}
	sOutput="<FormItem:text datatype='f' text='"+LIQUT_ALTITUDE+"' "+def+" value='"+getValue("LIQUT_ALTITUDE")+"' />"
	if(sType!="TER") sOutput+="</tr><tr>"
	if(sType=="TEG"||sType=="TER"||sType=="SEL")
	{
		if(sType!="TER") sOutput +="<td colSpan=2>&nbsp;</td>"
		sOutput +="<FormItem:date datatype='date' "
		if(sType=="TEG") sOutput+="disableHour='t' "
		sOutput +="text='"+CYCLE_TIME+"' value='"+getValue("CYCLE_TIME")+"' /></tr>"
	}	else if(sType=="ETY") {
		sOutput +="<td colSpan=2>&nbsp;</td>"
		sOutput +="<FormItem:text datatype='f' text='"+oParser.getParam("SEAWATER_FLOW",sType,2)+"' min=0 max=1050 value='"+getValue("SEAWATER_FLOW")+"' />"
		sOutput +="</TR>"
	}
	sOutput += "<tr style='border:1px solid red;height:40px'>"
			+ "<FormItem:textbox datatype='s' text='"+APPLY_MEMO+"' max=255 value='"+getValue("APPLY_MEMO")+"' "
	if(sType=="GAS"||sType=="LIQ")		
	sOutput +="min=10 "	
	sOutput +="/>"
			+ "</FormItem:textbox>"
			+ "</tr>"
			+"</table></div>"
	Response.Write(sOutput)		
	delete oParser
%>		
		