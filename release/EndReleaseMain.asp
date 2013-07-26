<!--#include file="../Library/form.asp"-->
<%
	var oMin=function(g) {if(g==null) g=0;return (sType=="LIQ"||sType=="GAS")?"":"min="+g}
%>
<STYLE>
	input {text-align:center}
</STYLE>
<script>
	
	function oFun()
	{
		document.body.action="../release/EndRelease.asp"
		oForm.formatForm(document.body)
		oForm.InitForm('document.body')		
	}
	function oAdd(oFormInst,dom,data)
	{
		reset()
		
		var sux=""		
		if(document.all['结束排放']==null) sux="时间"		
		var sFlag=0
		var d1=parent.document.all['tdReleaseInfo'].document.all['start_time']
		if(d1.outerHTML==null) {sFlag=d1.length-1;d1=d1[sFlag]}
		
		var d2=document.all['结束排放'+sux]	
		var s1=new Date(d1.innerText.replace(/\-/g,"/"))
		var s=GetTime('结束排放'+sux)
		if(s==null) return false
		if(s-s1.getTime()<=0) {
			alert1("结束排放时间一定晚于开始排放时间！",d2)
			return false
		}
		
		if(sType!="TER")
		{
			var d1=parent.document.all['bucket_pressure']	
			if(sFlag!=0) d1=d1[sFlag]
			var d2=Bucket_Pressure2
			var s1=parseFloat(d1.outerText)
			var s2=parseFloat(d2.value)
		
			if((!isNaN(s1))&&(!isNaN(s2))&&(s2>=s1))
			{			
				alert1(d2.name1+"必须小于"+d2.name1.replace("结束","开始")+"！"+s2+">="+s1,d2)	
				return false
			}			
		}	
		var iFlag=null
		var bFlag=EnablereLease2.checked
		if(bFlag) {
			iFlag='PUS'
			if(!confirm("您的操作将导致排放被中断，要继续么？")) return false
		} else {
			bFlag=EnablereLease1.checked
			if(bFlag) iFlag='HLT'
			else {
						
				if(sType=="TER" || sType=="SEL")
				{
					var lb_liq =parseFloat(Release_liquid.value)
					if (lb_liq > 1)
					{
						alert1("请确认结束排放时液位！",Release_liquid)
						return false
					}
				}
				bFlag=EnablereLease0.checked
				if(bFlag) iFlag='END'
			}
		}
		if(iFlag==null) 
		{
			alert1("请您选择是结束排放、等潮位还是中断排放！",EnablereLease0)
			return false
		}		
		wLoader.push("RELEASETYPE",iFlag)
		return true
	}
	function postForm(bFlag)
	{
		sFlag=bFlag
		oForm.PostForm(document.body,checkForm,funResult)
	}	
</script>
<table cellspacing=0 cellpadding=0 style='height:1;border:0;background-color:transparent;filter:'>
<tr><td style='height:1;border:0'>
<%if(sType=="TER") {%>
<table border>

<tr>
<td>操作人：</td><td><input type=text readOnly name="ENDEXECUTOR" value="<%=Request.Form("__USER_NAME")%>"></td>
<FormItem:date datatype='date' text='结束排放时间' value='' />
<td>结束时液位(m)：</td>
<td  width=120><input type=text name1=液位  name=Release_liquid  alert='t' datatype='f'  max=20></td>
</tr>
</table>
<%} else {%>
<table border>


<tr><td>&nbsp;<td>时间
</td><td><%=cp.getParam("Release_liquid",sType,2)%></td></tr>
<tr><FormItem:date datatype='date' text='结束排放' value='' />
<td><input type=text id=Bucket_Pressure2 
	name=Bucket_Pressure2 
	alert='t'
	name1=结束排放<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' <%=sType=="ETY"?oMin(900):oMin(0)%> 
	max=<%=sGroup=="LIQ"?(sType=="SEL"?10:1e4):(sType=="ETY"?2000:7)%>>
</td></tr>
</table>
<%}%>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table><tr><td style='width:1'>备<br>注</td>
<td><textarea name="备注" datatype="s" max=255></textarea>
</td></tr></table>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table>
<col width=33.3%>
<col width=33.3%>
<tr><td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLease0 />
<label for=EnablereLease0>结束排放</label></nobr></td>
<td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLease1 /><label for=EnablereLease1>等待潮位/气象</label></nobr></td>
<td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLease2 /><label for=EnablereLease2>中断排放</label></nobr></td>
</tr></table>
</td></tr></table>
<script>button("提交||postForm()")</script>