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
		wLoader.push("排放类型","TER")		
		wLoader.load(res,"../apply/App_Form.asp","get")
	}
	function oAdd(oFormInst,dom,data)
	{		
		if(!checkSpecial(sType)) return false
		wLoader.push("电站",Station)
		wLoader.push("机组","0")
		wLoader.push("ROLL_ID",sID)
		var f=function(o) {
					return parseInt(o.value.replace(/[^\d]+/g,""))
				}

			
					var iA=f(SEC单台投运数)*3400
					var iB=f(SEC整列投运数)*4500
					var iC=f(CRF泵投运台数)*76000
					wLoader.push("SEAWATER_FLOW",iA+iB+iC)				
		
		dom.removeChild(dom.selectSingleNode("//排放单号"))
		dom.selectSingleNode("//排放类型").text="TER"	
		return true
	}
	function res(text)
	{								
		resTab.innerHTML=text+"</table>"
		oForm.InitForm('formposter')
		parent.setForm()
		checkStation(Station)
		备注.value="这是由["+sID+"]转过来的TER申请单。"
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
<script>button("提交||submitForm()")</script>
</body>