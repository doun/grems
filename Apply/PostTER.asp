<!--#include file="../Library/form.asp"-->
<%
	var sStation=sID.substring(0,1)
%>
<style>
	table {background-color:transparent}
</style>
<script>
	var sSpe='0',iGroup,Station='<%=sStation%>'	
	function oFun()
	{
		document.body.action="../Apply/PostApply.asp"
		wLoader.push("�ŷ�����","TER")		
		wLoader.load(res,"../apply/App_Form.asp","get")
	}
	function oAdd(oFormInst,dom,data)
	{		
		if(!checkSpecial(sType)) return false
		wLoader.push("��վ",Station)
		wLoader.push("����","0")
		wLoader.push("ROLL_ID",sID)
		var f=function(o) {
					return parseInt(o.value.replace(/[^\d]+/g,""))
				}

			
					var iA=f(SEC��̨Ͷ����)*3400
					var iB=f(SEC����Ͷ����)*4500
					var iC=f(CRF��Ͷ��̨��)*76000
					wLoader.push("SEAWATER_FLOW",iA+iB+iC)				
		
		dom.removeChild(dom.selectSingleNode("//�ŷŵ���"))
		dom.selectSingleNode("//�ŷ�����").text="TER"	
		return true
	}
	function res(text)
	{								
		resTab.innerHTML=text+"</table>"
		oForm.InitForm('formposter')
		parent.setForm()
		checkStation(Station)
		��ע.value="������["+sID+"]ת������TER���뵥��"
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