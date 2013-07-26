<!--#include file="../Library/form.asp"-->
<%	
	var oCP=cp
	var sMemo=oCP.getParam("SAMPLE_MEMO",sType,2)	
%>
<script>	
	function oFun()
	{		
		oForm.InitForm("tblMain")
	}
	function oAdd(oX,oY)
	{
		var o=oY.selectSingleNode("//<%=sMemo%>")
		o.text="[R]"+o.text.replace("[R]","")
		return true
	}
	function submitForm()
	{
		var bReturn=oForm.PostForm(tblMain,checkForm,funResult)
	}		
</script>
<table style='height:100%' id=tblMain action="../Sample/UntreadApply.asp">
<col width=120 align=right><col><col width=120 align=right>
<tr>
<FormItem:textbox datatype='s' value='' text='<%=sMemo%>' max=252 min=4 /></tr>
</tr>
</table>
<script>button("Ã·Ωª||submitForm()")</script>
</body>