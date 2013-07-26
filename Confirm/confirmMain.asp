<!--#include file="../Library/form.asp"-->
<!--#include file="../include/checkConflict.asp"-->
<%
	var cn=new Connection()	
	var krt=cp.getParam("OKRT901MA",sType,2).replace("可","不可")+"时转特殊排放"
	if(sID.substring(0,1)=="L"&&sGroup=="LIQ") krt=krt.replace("902","904")
	cp=null
	var rs=cn.execRs("select isspecial_app+isspecial_sam+isspecial_scl as isspecial,"
		+"isspecial_scl from "+sDBOwner+".grems_status where id='"+sID+"'")
	var iTotal=parseInt(""+rs(0)),iTotal1=parseInt(""+rs(1))	
	var sReturn,iReturn
	if(iTotal1!=2)
	{		
		sReturn=CheckConflict(cn,sID,sType)==null?"没":""
		iReturn=sReturn==""?1:0
		sReturn="<font style='color:"+(sReturn==""?"red":"")+"'>目前"+sReturn+"有排放冲突。</font>"
	}	
	else
		sReturn="<font style='color:red'>转TER处理</font>"	
	delete rs
	Erase(cn)
%>
<script>
	var sFlag
	var iTotal=<%=iTotal%>
	var iTotal1=<%=iTotal1%>
	var iReturn=<%=iReturn%>
	function oFun()
	{		
		document.body.action="../Confirm/PostConfirm.asp"
		oForm.formatForm(document.body)
		checkInputBox(1)
		if(iReturn==1)
		{
			AgreeConflict.checked=true
			checkSpecial(AgreeConflict)
		}	
	}
	function checkInputBox(flag)
	{
		var oInput=document.getElementsByTagName("INPUT")
		if(flag==1) 
		{
			if(iTotal1==2)
			{
				for(var i=oInput.length-1;i>=2;i--)
				{
					var o=oInput[i]
					o.disabled=true;
					o.checked=false					
				}
				AgreeConflict.checked=true
			} else if(iTotal>0) {		
				bAgree0.checked=false
				bAgree1.checked=true
				for(var i=oInput.length-1;i>=2;i--)
				{
					var o=oInput[i]
					if(i>oInput.length-3) o.disabled=false;
					else o.disabled=true
				}	
			}	else {
				bAgree0.checked=true
				bAgree1.checked=false
				AgreeConflict.checked=false;
				for(var i=oInput.length-1;i>=2;i--)
				{
					var o=oInput[i]
					o.disabled=false;
				}	
			}
		}	else {
			for(var i=oInput.length-1;i>=2;i--)
			{
				var o=oInput[i]
				o.disabled=true;
				o.checked=false
			}	
		}
		for(var i=oInput.length-1;i>=0;i--) oInput[i].blur()
	}
	function checkSpecial(o)
	{
		if(iTotal1==2) return
		var tmpTotal=iTotal
		if(o.checked==true) iTotal=1
		checkInputBox(1)
		iTotal=tmpTotal
	}
	function postForm(bFlag)
	{
		sFlag=bFlag==true?1:0
		if(sFlag==0)
		{
			//if(!confirm("您的操作将导致本分析排放单被终止，是否继续？")) return false
			if(!confirm("您确认要终止此次排放申请吗？")) return false						
			CONFIRM_MEMO.value=CONFIRM_MEMO.value+"(本单在此处被终止)"
		}	
		oForm.PostForm(document.body,checkForm,funResult)
	}
	function oAdd(oFormInst,dom,data)
	{
		reset()
		wLoader.push("ACTIONFLAG",sFlag)		
		if(bAgreeFalse.checked)
		{
			if(CONFIRM_MEMO.value.Trim()=="")
			{
				alert1("如果要把申请单退回给检查人，请您在备注中填写退回的理由。",CONFIRM_MEMO)
				return false
			}	
			wLoader.push("BAGREE",0)
			return true
		}
		wLoader.push("BAGREE",1)
		if(iTotal1==2)
		{
			if(!bunt("因为总γ或者氚活度大于设定值，所以要转到TER处理",1)) return false
			if(CONFIRM_MEMO.value.Trim()=="")
			{
				alert1("如果要转到TER处理，请您在备注栏中填写一些备注。",CONFIRM_MEMO)
				return false
			}					
			wLoader.push("TOTER",1)	
			return true
		}
		//if(AgreeConflict.checked)		
		//{
		//	alert("有排放冲突，不能进行审批操作！请等待排放完毕再进行审批。")
		//	return false
		//}
					
		if(bAgree1.checked)	
		{			
			wLoader.push("TOTER",0)
			if(bAgree1.checked) 
			{	
				
				if(AgreeConflict.checked)
				{
					if(!bunt("有排放冲突，如允许排放则转为特殊排放",1)) return false						
					iSpecial+=2
					//if(!bunt("有排放冲突，不能进行审批操作",1)) return true
					
					
				}	
				if(AgreeConflict1.checked)
				{
					if(!bunt("<%=krt%>")) return false						
					iSpecial+=4
				}	
				/*
				if(iTotal>0)
				{
					if(!bunt("系统自动判断该排放为特殊排放",1)) return false
				}	else if(!bunt("该单被手动转为特殊排放单",1)) return false
				*/
				if(!bunt("该排放为特殊排放",1)) return false
				if(CONFIRM_MEMO.value.Trim()=="")
				{
					alert1("如果要转为特殊排放，请您在备注栏中填写一些备注。",CONFIRM_MEMO)
					return false
				}	
			}					
		}		
		return true
	}
	
</script>
<style>
	input {width:15}
</style>
<TABLE CELLSPACING=0>
<TR><TD STYLE='WIDTH:1;height:1'>备<br>注</TD>
<TD><TEXTAREA datatype="s" max=255 NAME='备注' id='CONFIRM_MEMO' STYLE='BORDER:0;OVERFLOW:AUTO'></TEXTAREA>
</TR>
<tr><td style='height:2'></td></tr>
</TABLE>
<table style='height:1;border-collapse:collapse;border-top-width:0' border>
<tr>
<td style='width:50%;'><nobr><font style='font:13px'>审批意向：</font>
<input type=radio name=bAgree id=bAgreeTrue checked onclick=checkInputBox(1)><label for=bAgreeTrue>批准</label>
　<input type=radio name=bAgree id=bAgreeFalse value=1 onclick=checkInputBox(0)><label for=bAgreeFalse>退回给检查人</label>
</nobr>　　
</td>

<td>
<font style='font:13px'>排放方式：</font>
<input type=radio name=bAgree0 id=bAgree0 value=1 checked><label for=bAgree0>正常排放</label>
<input type=radio name=bAgree0 id=bAgree1 value=1><label for=bAgree1>特殊排放</label>
</tr>
<tr><td colspan=2>&nbsp;
<%=sReturn%>&nbsp;
<span id=xbf style='<%if(sType=="SEL") {%>display:none<%}%>'>
<input type=checkbox id=AgreeConflict onclick=checkSpecial(this) style='display:none'>
</span>
<span id=xbf1 style='<%if(sType!="ETY"&&sType!="TEG") {%>display:none<%}%>'>
<input type=checkbox id=AgreeConflict1 onclick=checkSpecial(this)>
<label for=AgreeConflict1><%=krt%></label>
</span>
</td>
</tr>
</table>
<script>
var sButtons=""
if(sType=="LIQ"||sType=="GAS") sButtons=":结束本单||postForm(false)"

button("提交||postForm(true)"+sButtons)</script>
</body>