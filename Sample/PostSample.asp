<!--#include file="../Library/form.asp"-->
<%
	var oCP=cp
	var sPub1=oCP.getParam("PUBNUM1",sType,2)
	var sPub2=oCP.getParam("PUBNUM2",sType,2)
	var sMemo=oCP.getParam("SAMPLE_MEMO",sType,2)	
	var sUserName=Request.Form("__USER_NAME")	
%>

<script>
	function oFun()
	{
		oForm.InitForm("tblMain")
		s=(parent.ReleaseStation.innerText.Trim()=="������˵�վ")?"D":"L"
		if(sGroup=="LIQ"&&sType!="LIQ")
		{
			var o1=�޺�.options
			var re=/\w?(\d\w+)/
			for(var i=1;i<o1.length;i++)
			{
				o1[i].text=o1[i].value=o1[i].text.replace(re,s+"$1")				
			}		
		}
	}
	function submitForm()
	{	
		var bReturn=oForm.PostForm(tblMain,checkForm,funResult)
	}
	function oAdd(oFormInst,dom,data)
	{
		var sSpecial=null
		reset()		
		var s=new Date(parent.LevelApply.all['ǩ��ʱ��'].children[0].innerHTML.replace(/\-/g,"/"))
		var _sampleDate=GetTime("ȡ��ʱ��")
		if(_sampleDate==null) return false
		var iLeft=_sampleDate-s.getTime()
		if(iLeft<0)
		{
			alert1("ȡ��ʱ�䲻�������ύ���뵥��ʱ�䣡",ȡ��ʱ��)
			return false
		}
		
		if(sType=="ETY")
		{
			var _sampleDate=GetTime("����ʱ��")
			if(_sampleDate==null) return false
			var iLeft=_sampleDate-s.getTime()
			if(iLeft<0)
			{
				alert1("����ʱ�䲻�������ύ���뵥��ʱ�䣡",����ʱ��)
				return false
			}
			var iLeft=testDate("����ʱ��","ȡ��ʱ��",1)
			if(iLeft==null) return false			
			iLeft=-iLeft/3.6E6  //��ȡ��ֵ�Ƿ��ģ�Ϊ�˲�Ӱ������ģ�飬��ǰ��Ӹ��š������� 2004��5��31
			var _x=getParam1("ETY_STOCK")
				 //var a=bunt("iLeft="+iLeft+"  _X="+_x+" ��Сʱ")   ������ ������
			if(iLeft<=_x)
			{
				 if(!bunt("ȡ��ʱ������ "+_x+" ��Сʱ")) return false
			}			
		}		
		if(sGroup=="LIQ")
		{
			var s1,s2
			if(sType=="LIQ") {
				ϵͳ��.value=ϵͳ��.value.toUpperCase().Trim()
				s1="ϵͳ��";s2=ϵͳ��.value
			}
			else {s1="�޺�";s2=�޺�.options[�޺�.selectedIndex].innerText.Trim()}
			var s=parent.LevelApply.all[s1].innerText.Trim()
			if(s!=s2)
			{
				alert1("ȡ��ʱ��"+s1+"�����뵥��"+s1+"��һ�£�",document.all[s1])
				return false
			}
			if(sType!="LIQ")
			{
				var s=new Date(parent.LevelApply.all['ѭ����ʼʱ��'].children[0].innerHTML.replace(/\-/g,"/"))
				var iLeft=(_sampleDate-s.getTime())/(3.6E6)
				var iTest=getParam1(sType+"_STOCK")
				if(iLeft<iTest)
				{
					if(!bunt("ѭ��ʱ��С��"+iTest+"Сʱ")) return false
				}
			}
		}
		
		return true		
	}
</script>
<table style='height:1' id=tblMain action="../Sample/DoSample.asp">
<col width=20% align=right><col width=30%><col width=20% align=right>
<%
	var cn=new Connection()
	var rs=cn.execRs("SELECT * FROM "+sDBOwner+".GREMS_SAMPLE WHERE ID='"+sID+"'")
	
	function getValue(col)
	{
		if(rs.EOF) return ""
		var sValue=""+rs(col)
		if(sValue=="N/A"||sValue=="null") return ""
		return sValue.replace("[R]","")
	}
	var str="<tr>",iMax1,iMin1
	var sValue=getValue("PUBNUM1")
	if(sGroup=="LIQ")
	{
		if(sType!="LIQ")
		{
			iMax1=10
			iMin1=0.5
			if(sValue.length!=0) sValue=sValue.substring(6,7)
			str+="<FormItem:select text='"+sPub1+"' size=1 xstyle='margin-left:10' allownull='f' value='"+sValue+"'>\n"
				+ "<FormItem:option value=''></FormItem:option>\n"
			for(var i=1;i<4;i++)
			{
				var sBucket="0"+sType+"00"+i+"BA"
				str+="<FormItem:option value='"+sBucket+"'>"+sBucket+"</FormItem:option>\n"
			}	
			str+="</FormItem:select>"
		} else {
			iMin1=""
			str+="<FormItem:text type='s' min=5 max=10 text='"+sPub1+"' value='"+sValue+"' />"
		}	
	} else {
		iMin1=0
		var iMin3="0"
		var iMax
		if(sType=="TEG") {iMax=5;iMax1=5}
		else if(sType=="ETY") {iMax=500;iMax1=100}
		else {iMax=1000;iMin3="";iMin1="";iMax1="100"}
		str+="<FormItem:text datatype='f' alert='��ȷ�ϡ�"+sPub1.replace(/\(.*\)/,"")+"���������' text='"+sPub1+"' value='"+sValue+"' min='"+iMin3+"' suf='3'  max='"+iMax+"' />\n"
	}
	str+="<FormItem:text datatype='f' alert='��ȷ�ϡ�"+sPub2.replace(/\(.*\)/,"")+"����ֵ��' text='"
		+sPub2+"' value='"+getValue("PUBNUM2")+"' min='"
		+iMin1+"' suf='3' max='"+iMax1+"' /></tr>\n"
	var iMin2=""	
	if(sType=="ETY")
	{
		var rs1=cn.execRs("SELECT EP_NAME FROM "+sDBOwner+".GREMS_EMPLOYEE WHERE EP_WORKGROUP LIKE '%GP003%'")
		str +="<tr><FormItem:select allownull='f' text='"
			+oCP.getParam("START_USER",sType,2)
			+"' value='"+getValue("START_USER")+"' >\n"
			+"<FormItem:option value='' ></FormItem:option>"
		while(!rs1.eof) {
			var __sEPName=rs1(0)
			str+="<FormItem:option value='"+__sEPName+"' >"+__sEPName+"</FormItem:option>"
			rs1.MoveNext()
		}	
		str+="</FormItem:select>"
		delete rs1
		str	+="<FormItem:date datatype='date' text='"
			+oCP.getParam("START_DATE",sType,2)
			+"' value='"+getValue("START_DATE")+"' /></tr>\n"
	} else if(sType=="LIQ"||sType=="GAS") iMin2=""	
	// -----------by lb iMin2="min=4"
	
	str +="<tr><FormItem:text datatype='s' text='"
		+oCP.getParam("SAMPLE_UID",sType,2)
		+"' value='"+sUserName+"' min=2 max='10' readOnly />\n"
		+"<FormItem:date datatype='date' text='"
		+oCP.getParam("SAMPLE_DATE",sType,2)
		+"'  /></tr><tr>"
		+"<FormItem:textbox datatype='s' value='"+getValue("SAMPLE_MEMO")+"' text='"+sMemo+"' "+iMin2+" max=255  /></tr>"
		
	Response.Write(str)
	delete rs
	Erase(oCP)
	Erase(cn)
	delete cn
%>
</table>
<script>button("�ύ||submitForm()")</script>

</body>