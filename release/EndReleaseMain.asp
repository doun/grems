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
		if(document.all['�����ŷ�']==null) sux="ʱ��"		
		var sFlag=0
		var d1=parent.document.all['tdReleaseInfo'].document.all['start_time']
		if(d1.outerHTML==null) {sFlag=d1.length-1;d1=d1[sFlag]}
		
		var d2=document.all['�����ŷ�'+sux]	
		var s1=new Date(d1.innerText.replace(/\-/g,"/"))
		var s=GetTime('�����ŷ�'+sux)
		if(s==null) return false
		if(s-s1.getTime()<=0) {
			alert1("�����ŷ�ʱ��һ�����ڿ�ʼ�ŷ�ʱ�䣡",d2)
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
				alert1(d2.name1+"����С��"+d2.name1.replace("����","��ʼ")+"��"+s2+">="+s1,d2)	
				return false
			}			
		}	
		var iFlag=null
		var bFlag=EnablereLease2.checked
		if(bFlag) {
			iFlag='PUS'
			if(!confirm("���Ĳ����������ŷű��жϣ�Ҫ����ô��")) return false
		} else {
			bFlag=EnablereLease1.checked
			if(bFlag) iFlag='HLT'
			else {
						
				if(sType=="TER" || sType=="SEL")
				{
					var lb_liq =parseFloat(Release_liquid.value)
					if (lb_liq > 1)
					{
						alert1("��ȷ�Ͻ����ŷ�ʱҺλ��",Release_liquid)
						return false
					}
				}
				bFlag=EnablereLease0.checked
				if(bFlag) iFlag='END'
			}
		}
		if(iFlag==null) 
		{
			alert1("����ѡ���ǽ����ŷš��ȳ�λ�����ж��ŷţ�",EnablereLease0)
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
<td>�����ˣ�</td><td><input type=text readOnly name="ENDEXECUTOR" value="<%=Request.Form("__USER_NAME")%>"></td>
<FormItem:date datatype='date' text='�����ŷ�ʱ��' value='' />
<td>����ʱҺλ(m)��</td>
<td  width=120><input type=text name1=Һλ  name=Release_liquid  alert='t' datatype='f'  max=20></td>
</tr>
</table>
<%} else {%>
<table border>


<tr><td>&nbsp;<td>ʱ��
</td><td><%=cp.getParam("Release_liquid",sType,2)%></td></tr>
<tr><FormItem:date datatype='date' text='�����ŷ�' value='' />
<td><input type=text id=Bucket_Pressure2 
	name=Bucket_Pressure2 
	alert='t'
	name1=�����ŷ�<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' <%=sType=="ETY"?oMin(900):oMin(0)%> 
	max=<%=sGroup=="LIQ"?(sType=="SEL"?10:1e4):(sType=="ETY"?2000:7)%>>
</td></tr>
</table>
<%}%>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table><tr><td style='width:1'>��<br>ע</td>
<td><textarea name="��ע" datatype="s" max=255></textarea>
</td></tr></table>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table>
<col width=33.3%>
<col width=33.3%>
<tr><td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLease0 />
<label for=EnablereLease0>�����ŷ�</label></nobr></td>
<td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLease1 /><label for=EnablereLease1>�ȴ���λ/����</label></nobr></td>
<td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLease2 /><label for=EnablereLease2>�ж��ŷ�</label></nobr></td>
</tr></table>
</td></tr></table>
<script>button("�ύ||postForm()")</script>