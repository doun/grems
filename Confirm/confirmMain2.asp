<!--#include file="../Library/form.asp"-->
<script>
	function oFun()
	{
		document.body.action="../Confirm/PostConfirm2.asp"
		oForm.formatForm(document.body)
	}
	function postForm()
	{		
		oForm.PostForm(document.body,checkForm,funResult)
	}
	function oAdd(oFormInst,dom,data)
	{
		if(bAgreeFalse.checked)
		{
			if(!confirm("您确认要终止此次排放申请吗？")) return false
			if(CONFIRM_MEMO2.value.Trim()=="")
			{
				alert1("如果您不同意这个排放申请，请您在备注中填写反对的理由。",CONFIRM_MEMO2)
				return false
			}	
		}		
		wLoader.push("bFlag",(bAgreeTrue.checked==true)?'1':'0')
		return true
	}
	
</script>
<style>

	input {width:15}
</style>
<TABLE CELLSPACING=0>
<TR><TD STYLE='WIDTH:1;height:1'>备<br>注</TD>
<TD><TEXTAREA datatype="s" max=500 NAME='备注' id='CONFIRM_MEMO2' STYLE='BORDER:0;OVERFLOW:AUTO'></TEXTAREA>
</TR></TABLE>
<br>
<table style='height:1;border-collapse:collapse' border>
<tr>
<td style='width:1;'><nobr>审批意见：</nobr></td>
<td style='width:40%'>
<input type=radio name=bAgree id=bAgreeTrue value=1 checked><label for=bAgreeTrue>批准</label>
<td>
<input type=radio name=bAgree id=bAgreeFalse value=1><label for=bAgreeFalse>不批准</label>
</td></tr></table>
<script>button("提交||postForm()")</script>
</body>