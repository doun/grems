<!--#include file="../Library/form.asp"-->
<!--#include file="../include/checkConflict.asp"-->
<%
	var cn=new Connection()	
	var krt=cp.getParam("OKRT901MA",sType,2).replace("��","����")+"ʱת�����ŷ�"
	if(sID.substring(0,1)=="L"&&sGroup=="LIQ") krt=krt.replace("902","904")
	cp=null
	var rs=cn.execRs("select isspecial_app+isspecial_sam+isspecial_scl as isspecial,"
		+"isspecial_scl from "+sDBOwner+".grems_status where id='"+sID+"'")
	var iTotal=parseInt(""+rs(0)),iTotal1=parseInt(""+rs(1))	
	var sReturn,iReturn
	if(iTotal1!=2)
	{		
		sReturn=CheckConflict(cn,sID,sType)==null?"û":""
		iReturn=sReturn==""?1:0
		sReturn="<font style='color:"+(sReturn==""?"red":"")+"'>Ŀǰ"+sReturn+"���ŷų�ͻ��</font>"
	}	
	else
		sReturn="<font style='color:red'>תTER����</font>"	
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
			//if(!confirm("���Ĳ��������±������ŷŵ�����ֹ���Ƿ������")) return false
			if(!confirm("��ȷ��Ҫ��ֹ�˴��ŷ�������")) return false						
			CONFIRM_MEMO.value=CONFIRM_MEMO.value+"(�����ڴ˴�����ֹ)"
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
				alert1("���Ҫ�����뵥�˻ظ�����ˣ������ڱ�ע����д�˻ص����ɡ�",CONFIRM_MEMO)
				return false
			}	
			wLoader.push("BAGREE",0)
			return true
		}
		wLoader.push("BAGREE",1)
		if(iTotal1==2)
		{
			if(!bunt("��Ϊ�ܦû���밻�ȴ����趨ֵ������Ҫת��TER����",1)) return false
			if(CONFIRM_MEMO.value.Trim()=="")
			{
				alert1("���Ҫת��TER���������ڱ�ע������дһЩ��ע��",CONFIRM_MEMO)
				return false
			}					
			wLoader.push("TOTER",1)	
			return true
		}
		//if(AgreeConflict.checked)		
		//{
		//	alert("���ŷų�ͻ�����ܽ���������������ȴ��ŷ�����ٽ���������")
		//	return false
		//}
					
		if(bAgree1.checked)	
		{			
			wLoader.push("TOTER",0)
			if(bAgree1.checked) 
			{	
				
				if(AgreeConflict.checked)
				{
					if(!bunt("���ŷų�ͻ���������ŷ���תΪ�����ŷ�",1)) return false						
					iSpecial+=2
					//if(!bunt("���ŷų�ͻ�����ܽ�����������",1)) return true
					
					
				}	
				if(AgreeConflict1.checked)
				{
					if(!bunt("<%=krt%>")) return false						
					iSpecial+=4
				}	
				/*
				if(iTotal>0)
				{
					if(!bunt("ϵͳ�Զ��жϸ��ŷ�Ϊ�����ŷ�",1)) return false
				}	else if(!bunt("�õ����ֶ�תΪ�����ŷŵ�",1)) return false
				*/
				if(!bunt("���ŷ�Ϊ�����ŷ�",1)) return false
				if(CONFIRM_MEMO.value.Trim()=="")
				{
					alert1("���ҪתΪ�����ŷţ������ڱ�ע������дһЩ��ע��",CONFIRM_MEMO)
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
<TR><TD STYLE='WIDTH:1;height:1'>��<br>ע</TD>
<TD><TEXTAREA datatype="s" max=255 NAME='��ע' id='CONFIRM_MEMO' STYLE='BORDER:0;OVERFLOW:AUTO'></TEXTAREA>
</TR>
<tr><td style='height:2'></td></tr>
</TABLE>
<table style='height:1;border-collapse:collapse;border-top-width:0' border>
<tr>
<td style='width:50%;'><nobr><font style='font:13px'>��������</font>
<input type=radio name=bAgree id=bAgreeTrue checked onclick=checkInputBox(1)><label for=bAgreeTrue>��׼</label>
��<input type=radio name=bAgree id=bAgreeFalse value=1 onclick=checkInputBox(0)><label for=bAgreeFalse>�˻ظ������</label>
</nobr>����
</td>

<td>
<font style='font:13px'>�ŷŷ�ʽ��</font>
<input type=radio name=bAgree0 id=bAgree0 value=1 checked><label for=bAgree0>�����ŷ�</label>
<input type=radio name=bAgree0 id=bAgree1 value=1><label for=bAgree1>�����ŷ�</label>
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
if(sType=="LIQ"||sType=="GAS") sButtons=":��������||postForm(false)"

button("�ύ||postForm(true)"+sButtons)</script>
</body>