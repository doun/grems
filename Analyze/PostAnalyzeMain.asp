<!--#include file="../Library/form.asp"-->
<%	
	function getItem(sItem)
	{
		return "<td>"+cp.getParam(sItem,sType,2)
	}
	var sWidth="<col width="
	var str=getItem("B")+getItem("Y")+getItem("TRITIUM")
	var sCount=3
	if(sGroup=="GAS") {str+=getItem("Chimney_Speed");sWidth+="20";sCount=4}
	else {sWidth+="25"}
	sWidth+="% />"
	var sWidth1=""
	for(var i=0;i<sCount;i++) sWidth1+=sWidth
	str+=getItem("Release_Speed")
	var sFormat="s:2#f:9E15:0"
	var sFormat1="/^(<|≤|<=)?\\d+[\\w\\W]*$/i"
	var cn=new Connection()
	var rs=cn.execRs("select * from "+sDBOwner+".grems_scale where id='"+sID+"'")
	
	//取TER_Y2的系统参数值  -----lb
	var TER_Y2
	var rs_sys=cn.execRs("select param_id,param_value from "+sDBOwner+".grems_param  where param_id='TER_Y2'")
	if(!rs_sys.EOF){
		 TER_Y2= rs_sys("param_value")
	}
	
	//取TER_Y1的系统参数值  -----lb
	var TER_Y1
	var rs_sys1=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='TER_Y1'")
	if(!rs_sys1.EOF){
		 TER_Y1= rs_sys1("param_value")
	}

	//取TEG_Y1的系统参数值  -----lb
	var TEG_Y1
	var rs_sys2=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='TEG_Y1'")
	if(!rs_sys2.EOF){
		 TEG_Y1= rs_sys2("param_value")
	}

	//取TEG_B的系统参数值  -----lb
	var TEG_B
	var rs_sys3=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='TEG_B'")
	if(!rs_sys3.EOF){
		 TEG_B= rs_sys3("param_value")
	}
	
	//取TEG_T的系统参数值  -----lb
	var TEG_T
	var rs_sys4=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='" + sType + "_T'")
	if(!rs_sys4.EOF){
		 TEG_T= rs_sys4("param_value")
	}

	//取SEL_Y3的系统参数值  -----lb
	var SEL_Y3
	var rs_sys5=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='SEL_Y3'")
	if(!rs_sys5.EOF){
		 SEL_Y3= rs_sys5("param_value")
	}

	//取SEL_Y1的系统参数值  -----lb
	var SEL_Y1
	var rs_sys6=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='SEL_Y1'")
	if(!rs_sys6.EOF){
		 SEL_Y1= rs_sys6("param_value")
	}

	
	//取TEG_I131的系统参数值  -----lb
	var TEG_I131
	var rs_sys7=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='TEG_I131'")
	if(!rs_sys7.EOF){
		 TEG_I131= rs_sys7("param_value")
	}

	//取TEG_I133的系统参数值  -----lb
	var TEG_I133
	var rs_sys8=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='TEG_I133'")
	if(!rs_sys8.EOF){
		 TEG_I133= rs_sys8("param_value")
	}

	
	//取ETY_B的系统参数值  -----lb
	var ETY_B
	var rs_sys9=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='ETY_B'")
	if(!rs_sys9.EOF){
		 ETY_B= rs_sys9("param_value")
	}

	//取ETY_Y1的系统参数值  -----lb
	var ETY_Y1
	var rs_sys10=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='ETY_Y1'")
	if(!rs_sys10.EOF){
		 ETY_Y1= rs_sys10("param_value")
	}

	
	//取ETY_I131的系统参数值  -----lb
	var ETY_I131
	var rs_sys11=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='ETY_I131'")
	if(!rs_sys11.EOF){
		 ETY_I131= rs_sys11("param_value")
	}

	//取ETY_I133的系统参数值  -----lb
	var ETY_I133
	var rs_sys12=cn.execRs("select param_value from "+sDBOwner+".grems_param  where param_id='ETY_I133'")
	if(!rs_sys12.EOF){
		 ETY_I133= rs_sys12("param_value")
	}


	if(rs.EOF) cn.Execute("insert into "+sDBOwner+".grems_scale(id) values('"+sID+"')")
	//writeElement
	//把数据库中的元素列转换为可视的包含上标和大小写的元素符号
	function re(str)
	{
		var str1=eval(
			str.toLowerCase().replace(/^([a-z])([a-z]*)(\d+\w*)$/,
			"'<td><sup>$3</sup>\'+"+
			"'$1'.toUpperCase()+'$2</td>'"
		))					
		Response.Write("\n"+str1)
	}
	
	//生成指定id和value的文本框
	var bXflag=false
	function re1(str,sName,sFlag)
	{		
		str=str.toLowerCase()
		var str1
		if(sName!=null) str1=sName
		else if(str.length>1) {
			str1=eval(
				str.toLowerCase().replace(/^([a-z])([a-z]*)(\d+\w*)$/,
				"'$1'.toUpperCase()+'$2'+'-$3'.toLowerCase()"
			))	
		}	
		else str1=str
		var sValue=""+(rs.EOF?"":rs(str))
		if(sValue=="null") sValue=""
		var sMin=" min=1 "	
		var sFormatx=sFormat
	
		if((sType=="LIQ"&&str!="y"&&str!="tritium")||(sType=="GAS"&&sFlag!=1)||sFlag==0) 
			sFormatx=sFormatx.replace(/0$/,"")			
		var str1="<td><input type=text style='width:100%;border:0;text-align:center' name1='"
			+str1+"' id='"+str+"' name='"+str+"' max=17 "+sMin+" datatype='combine' format='"
			+sFormatx+"' format1='"+sFormat1+"' value='"+sValue+"' oncheck='doCheckValue(oInput,bFlag)'"
		if(str=="release_speed") {
			if(sType!="LIQ") str1+=" readonly style='background-color:transparent;' suf=2 "	
		}	
		str1+=" /></td>"
		Response.write("\n"+str1)
	}
	eval(""+Application("PARAM_INFO"))
	iSpe=oParamList[sType+'_Y']
%>

<SCRIPT>		
function FormatNum(iLength,suf){
	var sValue1,p
	var sLength=""+iLength
	if(iLength<1)
	{
		var a=/^0\.(0*[1-9])/.exec(sLength)
		p=a[1].length+1
		sLength=sLength.replace(".","")
		sValue1=sLength.substring(0,p).replace(/^0+/,"")
		if(sLength.length>p) sValue1+="."+sLength.substring(p)+"000"
		else sValue1+=".000"					
		p=-1*(p-1)
	} else {
		sLength=sLength.replace(/^0+/,"")
		a=/^(\d+)(\.\d+)?$/.exec(sLength)
		p=a[1].length
		if(p==1) {sValue1=sLength+".000";p=0}
		else {
			sLength=sLength.replace(".","")
			sValue1=sLength.substring(0,1)+"."+sLength.substring(1)+"000"
			--p
			}	
	}
	if(suf!=null) sValue1=sValue1.substring(0,suf+2)
	return (sValue1+"E"+p)
}	
	
	
	var oRes=/^[<≤=]{1,2}/
	var iSpe=getParam1(sType+"_Y")
	function getCnv(targetID)
	{
		if(typeof(targetID)=="string") targetID=document.all[targetID]
		return parseFloat(targetID.value.replace(oRes,""))
	}
	function oFun()
	{
		document.body.action="../Analyze/PostAnalyze.asp"
		oForm.formatForm(document.body)
	}
	
	function doCheckValue(o,bFlag)
	{
		var sName=o.name
		o.value=o.value.replace("<=","≤")	
		
				
		if(sName=="chimney_speed")
		{
			var iCValue=getCnv(o)
			if(iCValue<7||iCValue>30)
			{
				alert1("请确认烟囱流速！",o)
				return false
			}
		}
		
		if(sName=="tritium")
		{
			var iCValue=getCnv(o)
			if(iCValue><%=TEG_T%>)
			{
				alert1("请确认H3浓度！",o)
				//return false
			}
		}
	
	if (sType=="TER")
	{
		if(sName=="y")
		{
			var iCValue=getCnv(o)
			if(iCValue<<%=TER_Y2%> || iCValue=="")
			{
				alert1("请确认TER总γ数值！",o)
				//return false
			}
			if(iCValue><%=TER_Y1%> || iCValue=="")
			{
				alert1("请确认TER总γ数值！",o)
				//return false
			}
			
		}
	}
	
	if (sType=="TEG")
	{
		if(sName=="y")
		{
			var iCValue=getCnv(o)
			if(iCValue>=<%=TEG_Y1%> || iCValue=="")
			{
				alert1("请确认TEG总γ数值！",o)
				//return false
			}
			//if(iCValue><%=TER_Y1%> || iCValue=="")
			//{
			//	alert1("请确认TER总γ数值！",o)
				//return false
			//}
			
		}
		if(sName=="b")
		{
			var iCValue=getCnv(o)
			if(iCValue>=<%=TEG_B%> || iCValue=="")
			{
				alert1("请确认TEG总β数值！",o)
				//return false
			}
		}
	}

	if (sType=="SEL")
	{
		if(sName=="y")
		{
			var iCValue=getCnv(o)
			if(iCValue<<%=SEL_Y3%> || iCValue=="")
			{
				alert1("请确认SEL总γ值！",o)
				//return false
			}
			if(iCValue>=<%=SEL_Y1%> || iCValue=="")
			{
				alert1("请确认SEL总γ值！",o)
				//return false
			}
		}
	}
		
	if (sType=="ETY")
	{
		if(sName=="i131")
		{
			var iCValue=getCnv(o)
			if(iCValue><%=ETY_I131%> || iCValue=="")
			{
				alert1("请确认I131浓度！",o)
				//return false
			}
		}
		if(sName=="i133")
		{
			var iCValue=getCnv(o)
			if(iCValue><%=ETY_I131%> || iCValue=="")
			{
				alert1("请确认I133浓度！",o)
				//return false
			}
		}
		if(sName=="b")
		{
			var iCValue=getCnv(o)
			if(iCValue>=<%=ETY_B%> || iCValue=="")
			{
				alert1("请确认KRT009MA数值！",o)
				//return false
			}
		}
		if(sName=="y")
		{
			var iCValue=getCnv(o)
			if(iCValue>=<%=ETY_Y1%> || iCValue=="")
			{
				alert1("请确认ETY总γ值！",o)
				//return false
			}
		}

	}
	else
	{
		if(sName=="i131")
		{
			var iCValue=getCnv(o)
			if(iCValue><%=TEG_I131%> || iCValue=="")
			{
				alert1("请确认I131浓度！",o)
				//return false
			}
		}
		if(sName=="i133")
		{
			var iCValue=getCnv(o)
			if(iCValue><%=TEG_I133%> || iCValue=="")
			{
				alert1("请确认I133浓度！",o)
				//return false
			}
		}
	
	}
		
		
		if(bFlag!=true) {
			if(sName=="y"||sName=="b"||sName=="tritium"||sName=="chimney_speed"
				||sName=="kr85"||sName=="kr88"||sName=="xe135"||sName=="xe133")
			setFlowSpeed()
			return true
		}	
		var bAlert
		var iValue=getCnv(o)
		o.value=o.value.replace("<=","≤")					
		var f1=function(s) {
			if(iValue>parseFloat(s)) 
			{
				if (sName != "tritium" && sName !="b" && sName!="y")
					return confirm("请确认"+o.name1+"的值，要继续么？")
				return true
			}
		}
		switch(sName.toLowerCase())
		{		
			case "release_speed":
			case "i131":
				return true
			case "y":		
				if(sType=="LIQ") return true
				var _x1=oParamList[sType+"_Y1"]				
				bAlert=f1(_x1)				
				break						
			case "tritium":
				var _x1=oParamList[sType+"_T"]
				bAlert=f1(_x1)				
				break
			case "b":
				if(sGroup!="GAS") return true
				var _x1=oParamList[sType+"_B"]
				bAlert=f1(_x1)				
				break
			case "xe133":
			case "kr85":
				var _x1=oParamList["NUCLIDE"]
				bAlert=f1(_x1)
				break	
			default:
				var _x1=oParamList["NUCLIDE1"]
				bAlert=f1(_x1)
				break
		}		
		return bAlert
	}
	function setFlowSpeed()
	{
		var Q=null
		switch(sType)
		{
			case "TER":
				var iFlow=parseInt(parent.排放渠海水流量.innerText)
				var Q1=7.4*1000*iFlow/getCnv('y')
				var Q2=740*1000*iFlow/getCnv('tritium')
				if(isNaN(Q1)||isNaN(Q2)) return	
				Q=Q1>Q2?Q2:Q1
				Q=Q>150?150:Q
				break					
			case "ETY":
			case "TEG":
			case "GAS":
				var iB=getCnv('b')
				var iC=getCnv('chimney_speed')
				if(isNaN(iB)||isNaN(iC)) return
				Q=iC*3600*7.056*4E4/iB	
				break
			/*	
			case "TEG":
			case "GAS":
				var iMinA=getCnv("kr85")
				if(isNaN(iMinA)) return
				var iMinB=getCnv("kr88")
				if(isNaN(iMinB)) return
				if(iMinA<iMinB) iMinA=iMinB
				var iMinB=getCnv("xe133")
				if(isNaN(iMinB)) return
				if(iMinA<iMinB) iMinA=iMinB
				var iMinB=getCnv("xe135")
				if(isNaN(iMinB)) return
				if(iMinA<iMinB) iMinA=iMinB
				var iB=iMinA*3
				var iC=getCnv('chimney_speed')				
				if(isNaN(iC)) return
				Q=iC*3600*7.056*4E4/iB
				break	
			*/	
			default:return
		}
		if(Q!=null) {
			Q=oForm.convertInt(Q,2).replace(/0+E/,"E")
			Q="≤"+Q
			release_speed.value=Q
		}	
	}
	function submitForm()
	{		
		reset()		
		
		yValue=getCnv('y')
		tritiumValue=getCnv('tritium')
		
		//if (tritiumValue><%=TEG_T%>) 
		//		if(!confirm("TEG排放的氚测量值大于系统参数指定的值： "+ FormatNum(<%=TEG_T%>,1) +"，继续进行吗？")) return false
		
		//if(sType=="TER")
		//{
			//if(yValue<=10000){
			//alert("TER排放总γ值<＝1E4，请重新输入！")
			// return false
			 //}
			
			//if(tritiumValue<=1000000)
			//if(!confirm("TER排放总H3值<＝1E6，继续进行吗？")) return false
			//if(!confirm("请确认氚浓度，继续进行吗？")) return false
		//}
		
		if(sType=="SEL")
		{
			if(yValue<=1000){
			alert("SEL排放总γ值<＝1E3，请重新输入！")
			 return false
			 }
			
			if(tritiumValue<=1000){
			alert("SEL排放总H3值<＝1E3，请重新输入！")
			//alert("请确认H3浓度！")
			 return false
			 }
		}
		
		if(sType=="ETY")
		{
			var etyI131 = this.i131.value
			//if (etyI131><%=ETY_I131%>) 
			//	if(!confirm("ETY I131的值大于系统参数指定的值： "+ FormatNum(<%=ETY_I131%>,1) +"，继续进行吗？")) return false
			if(etyI131.substring(0,1)!="<" && etyI131.substring(0,1)!="≤")
				//if(!confirm("ETY I131 没有'<'符号，继续进行吗？")) return false
				if(!confirm("ETY I131值大于探测限，继续进行吗？")) return false
			var etyI133 = this.i133.value
			//if (etyI133><%=ETY_I133%>) 
			//	if(!confirm("ETY I133的值大于系统参数指定的值： "+ FormatNum(<%=ETY_I133%>,1) +"，继续进行吗？")) return false
			if(etyI133.substring(0,1)!="<" && etyI133.substring(0,1)!="≤")
				//if(!confirm("ETY I133 没有'<'符号，继续进行吗？")) return false
				if(!confirm("ETY I133值大于探测限，继续进行吗？")) return false
			
		}
		if(sType=="TEG")
		{
			
			var tegI131 = this.i131.value
			//if (tegI131><%=TEG_I131%>) 
			//	if(!confirm("TEG I131的值大于系统参数指定的值： "+ FormatNum(<%=TEG_I131%>,1) +"，继续进行吗？")) return false
			if(tegI131.substring(0,1)!="<" && tegI131.substring(0,1)!="≤")
				//if(!confirm("TEG I131 没有'<'符号，继续进行吗？")) return false
				if(!confirm("TEG I131值大于探测限，继续进行吗？")) return false
			var tegI133 = this.i133.value
			//if (tegI133><%=TEG_I133%>) 
			//	if(!confirm("TEG I133的值大于系统参数指定的值： "+ FormatNum(<%=TEG_I133%>,1) +"，继续进行吗？")) return false
			if(tegI133.substring(0,1)!="<" && tegI133.substring(0,1)!="≤")
				//if(!confirm("TEG I133 没有'<'符号，继续进行吗？")) return false
				if(!confirm("TEG I133值大于探测限，继续进行吗？")) return false
				
				
		}	
		
		
		
		//alert(tritiumValue+"_"+yValue) //test
		if(sGroup=="LIQ")
		{
			var oInputs=LIQCheck.all.tags("INPUT")		
			var iValue=getCnv('y')	
			if(!isNaN(iValue))
			{				
				if(iValue>=iSpe)				
				{
					for(var i=0;i<oInputs.length;i++)
					{					
						oInputs[i].format="s:2#f:9E15:0"					
					}		
					if(!bunt("总γ≥"+FormatNum(iSpe,1)+"Bq/立方米")) return false
				} else {
					for(var i=0;i<oInputs.length;i++)
					{
						oInputs[i].format="s:2#f:9E15:"							
					}					
				}				
			}
		}		
		oForm.PostForm(document.body,checkForm,funResult)		
	}	
	function oAdd()
	{
		var _x1=getParam1(sType+"_I")
		if(sGroup=="LIQ") {
			if(document.all['b'].value!="合格")	{				
				if(!bunt("PH值不合格")) return false			
			}	
			if(sType=="SEL"||sType=="LIQ") {
				var iValue1=getCnv('y')
				var iValue2=getCnv('tritium')
				var sConfirm=""
				var _x=getParam1("SEL_Y2")
				var _x2=getParam1(sType+"_TRITUMN")
				if(sType=="SEL"&&iValue1>=_x) sConfirm="总γ值≥"+FormatNum(_x,1)+"Bq/立方米"
				if(iValue2>=_x2) {
					var sr="氚活度≥"+FormatNum(_x2,1)+"Bq/立方米"
					if(sConfirm=="") sConfirm=sr
					else sConfirm+="，并且"+sr					
				}
				if(sConfirm!="")
				{
					if(sType=="SEL"&&iValue1>=_x)
					{
						if(!bunt(sConfirm+"，这将会转向TER排放",1)) return false
						else iSpecial=2
					}	else {
						if(!bunt(sConfirm,1)) return false
					}
				}	
			}	
		}	else if(getCnv('i131')>_x1) {
			if(!bunt("碘-131的值大于"+FormatNum(_x1,1)+"Bq/立方米")) return false
		}		
		return true
	}
</script>
<table cellspacing=0 cellpadding=0 style='height:1;border:0;background-color:transparent;filter:'>
<tr><td style='height:1;border:0'>
<table cellspacing=0 STYLE='HEIGHT:1' border>
<%=sWidth1%>
<tr><%=str%></TR>
<TR>
<%if(sGroup=="LIQ") {%>
<td><select name="b" name1='PH值' allownull="f">
<option value="合格">合格</option>
<option value="不合格">不合格</option>
</select>
</td>
<%} else re1("b",cp.getParam("B",sType,1));
	re1("y",cp.getParam("Y",sType,1));re1("tritium","氚");
	if(sGroup=="GAS") re1("Chimney_Speed","烟囱流速",1);
	re1("Release_Speed","排放流速",0);
%></TR>
</table>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<%if(sGroup=="GAS") {%>
<table cellspacing=0 STYLE='HEIGHT:1' BORDER>
<tr><td rowspan=6 width=1><nobr>γ能谱分析表<wbr>(单位:Bq/m<sup>3</sup>)</nobr></td>
<td rowspan=2>气体</td>
<%re("kr85");re("kr88");re("xe133");re("xe135");%></tr>
<tr><%re1("kr85",null,1);re1("kr88",null,1);re1("xe133",null,1);re1("xe135",null,1);%></tr>
<%var sName;if(sType!="ETY") {sName="碘盒";%>
<tr><td rowspan=2>滤膜</td>
<%re("co58");re("co60");re("cs134");re("cs137")%></tr>
<tr><%re1("co58");re1("co60");re1("cs134");re1("cs137")%></tr>
<%} else sName="碳盒";%>
<tr><td rowspan=2><%=sName%></td>
<%re("i131");re("i133")%><td>&nbsp;</td><td>&nbsp;</td></tr>
<tr><%re1("i131");re1("i133")%><td>&nbsp;</td><td>&nbsp;</td></tr>
</table>
<%} else {%>

<table cellspacing=0 border>
<col width=12.5%>
<col width=12.5%>
<col width=12.5%>
<col width=12.5%>
<col width=12.5%>
<col width=12.5%>
<col width=12.5%>
<tr style='height:1'><td colspan=8 style='font:14px 黑体'>当γ≥<%=iSpe%> Bq/m<sup>3</sup>时，γ能谱测量结果(单位：Bq/m<sup>3</sup>)</th></tr>
<tr><%re("ag110m");re("co58");re("co60");re("cs137");re("i131");re("cs134");re("mn54");re("sb124");%></tr>
<tr id=LIQCheck><%re1("ag110");re1("co58");re1("co60");re1("cs137");re1("i131");re1("cs134");re1("mn54");re1("sb124");%></tr>
</table>
<%}%>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table cellspacing=0 style='height:1;border-collapse:collapse' border>
<tr><td style='width:1'>备<br>注</td>
<td>
<TEXTAREA datatype="s" max=255 name1='备注' NAME='SCALE_MEMO' id='SCALE_MEMO' STYLE='BORDER:0;OVERFLOW:AUTO'>
<%
	if(!rs.EOF) {
		var sMemo=""+rs("SCALE_MEMO")
		if(sMemo!=""&&sMemo!="null"&&sMemo!="N/A") {
			sMemo=sMemo.replace("[R]","")
			Response.Write(sMemo)
		}
	}
%></TEXTAREA>
</td>
</tr>
</table>
</td></tr></table>
<%
rs=null;
rs_sys=null;
rs_sys1=null;
rs_sys2=null;
rs_sys3=null;
rs_sys4=null;
rs_sys5=null;
rs_sys6=null;
rs_sys7=null;
rs_sys8=null;
rs_sys9=null;
rs_sys10=null;
rs_sys11=null;
rs_sys12=null;
delete cn;
%>
<script>button("提交||submitForm()")</script>
