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
			if(!confirm("��ȷ��Ҫ��ֹ�˴��ŷ�������")) return false
			if(CONFIRM_MEMO2.value.Trim()=="")
			{
				alert1("�������ͬ������ŷ����룬�����ڱ�ע����д���Ե����ɡ�",CONFIRM_MEMO2)
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
<TR><TD STYLE='WIDTH:1;height:1'>��<br>ע</TD>
<TD><TEXTAREA datatype="s" max=500 NAME='��ע' id='CONFIRM_MEMO2' STYLE='BORDER:0;OVERFLOW:AUTO'></TEXTAREA>
</TR></TABLE>
<br>
<table style='height:1;border-collapse:collapse' border>
<tr>
<td style='width:1;'><nobr>���������</nobr></td>
<td style='width:40%'>
<input type=radio name=bAgree id=bAgreeTrue value=1 checked><label for=bAgreeTrue>��׼</label>
<td>
<input type=radio name=bAgree id=bAgreeFalse value=1><label for=bAgreeFalse>����׼</label>
</td></tr></table>
<script>button("�ύ||postForm()")</script>
</body>