<!--#include file="../Library/form.asp"-->
<style>
	table {background-color:transparent}
</style>
<script>
	var sSpe='0',iGroup,Station
	function oFun()
	{
		document.body.action="../Apply/PostApply.asp"
		wLoader.push("�ŷŵ���",sID)
		wLoader.push("�ŷ�����",sType)		
		Station=(parent.ReleaseStation.innerText.Trim()=="������˵�վ")?"D":"L"
		wLoader.load(res,"../apply/App_Form.asp","get")
	}
	function oAdd(oFormInst,dom,data)
	{				
		if(!checkSpecial(sType)) return false
		return true
	}
	function res(text)
	{								
		resTab.innerHTML=text+"</table>"
		oForm.InitForm('formposter')
		checkStation(Station)
		parent.setForm()
	}
	
	function submitForm()
	{		
		oForm.PostForm(document.body,checkForm,funResult)
//		if(bReturn!=false) o.style.display="none"
	}
<!--#include file="Apply.js"-->	
	
</script>

<div style='width:100%;height:1' id=resTab>
</div>
<script>button("�ύ||submitForm()")</script>
</body>