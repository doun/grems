<!--#include file="../Library/form.asp"-->
<script>
	function oFun()
	{
		document.body.action="../Check/PostCheck.asp"
		oForm.formatForm(document.body)
	}
	function submitForm()
	{
		var bReturn=oForm.PostForm(document.body,checkForm,funResult)
	}
	function oAdd(oFormInst,dom,data)
	{
		var iFlag=0
		if(bAgree1.checked==true||bAgree2.checked==true)
		{
			if(SMEMO.value.Trim().length<4)			
			{
				alert1("���Ҫ�˻ظ÷����ŷŵ��������ڱ�ע����д�˻ص�����(����2��)��",SMEMO)
				return false
			} else 	{
				var o=dom.selectSingleNode("//��ע")
				o.text="[R]"+o.text.replace("[R]","")
			}
		}		
		iFlag=bAgree0.checked?0:(bAgree1.checked?1:2)
		wLoader.push("bFlag",iFlag)
		return true
	}	
</script>
<style>
	input {width:15}
</style>
<table cellspacing=0 cellpadding=0 style='height:1;border:0;background-color:transParent'>
<tr><td style='height:1;border:0'>
<TABLE CELLSPACING=0>
<TR><TD STYLE='WIDTH:1;height:1'>��<br>ע</TD>
<TD><TEXTAREA datatype="s" max=252 NAME='��ע' ID=SMEMO STYLE='BORDER:0;OVERFLOW:AUTO'></TEXTAREA>
</TR>
</TABLE>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table style='height:1' border>
<tr style='height:1'><td style='width:33.3%;height:1'>
<nobr><input type=radio name=bAgree id=bAgree0 value=1 checked><label for=bAgree0>�������</label></nobr>
<td style='width:33.3%'>
<nobr><input type=radio name=bAgree id=bAgree1 value=0><label for=bAgree1>�˻ظ�������</label></nobr>
</td>
<td>
<nobr><input type=radio name=bAgree id=bAgree2 value=0><label for=bAgree2>�˻ظ�ȡ����</label></nobr>
</td>
</tr></table>
</td></tr></table>
<script>button("�ύ||submitForm()")</script>
</body>