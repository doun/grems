<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ConstParser.asp"-->
<style>
	body {
		overflow:hidden;
		overflow-y:auto;
		border:0;
		margin:0;	
		
		background-color:white
	}
	body,div {
		scrollbar-face-color:GREEN;
		scrollbar-arrow-color:white;
		scrollbar-highlight-color:white;
		scrollbar-3dlight-color:green;
		scrollbar-shadow-color:white;
		scrollbar-darkshadow-color:darkgreen;
		scrollbar-track-color:#eef;
	}
	table {font-size:14px;width:100%;height:1;border-collapse:collapse}
	td {border:2px solid black}
	fieldset td {text-align:center}
	.label {font-family:����}
	.thinborder td {border:1px solid black}
	.noborder td {border:0}
	#divContent {
		width:100%;height:100%;
	}
	.labelT {font-family:����_gb2312;font-weight:bold}
	#tdReleaseInfo td {text-align:center}
	
</style>
<!--
<object id="factory" style="display:none" viewastext 
		classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" 
		 codebase="../../../../print/scriptX.cab#Version=5,60,0,360"
>
</object>
!-->
<script language="javascript" src="..\Library\default.js"></script>
<form id=formInput target='frmInput' style='display:none' method='post'></form>
<script>
	
	var sNowStatus=null
	var sColorD="linen",sColorL="lightblue"
	function DoPrint() 
	{
		//alert("��ȷ�����Ѿ������˴�ӡ�������Ҵ�ӡ�����Ѿ�׼���˴�ӡֽ�����һ�о�����������ȷ������")
		
		//factory.printing.header=""
		//factory.printing.footer=""
		try {
			window.print();
			//if(factory.printing.Print(false) ) 
			//{
			//	SpoolStatus(true);
			//	factory.printing.WaitForSpoolingComplete();
			//	SpoolStatus(false);
			//}
		} catch(__e) {}	
	}
	
	function reload()
	{
		top.parent.UnDoneList.location.reload(true)
		window.location.reload(true)
	}
	var wLoader,oForm,TmpTitle=""
	function window.onload()
	{
		
		with(divContent.style)
		{
			width="100%"
			height="100%"
			overflowX="hidden"
			overflowY="auto"
		}
		
		wLoader=parent.wLoader		
		oForm=parent.xForm
		var sBgColor=(ReleaseStation.innerText.Trim()=="������˵�վ")?"D":"L"
		parent.setButtons(sNowStatus,sBgColor)
		divContent.style.backgroundColor=eval("sColor"+sBgColor)
		divContent.children[0].scrollIntoView(false)
	}
	function openWin(url,sText,oFun)
	{
		TmpTitle=sText
		var sID=�ŷŵ���.innerText.Trim()
		var sType=�ŷ�����.innerText.Trim()
		formInput.innerHTML=oForm.innerHTML
		formInput.innerHTML+="<input type=hidden name='�ŷŵ���' value='"+sID+"'/>" 
			+"<input type=hidden name='�ŷ�����' value='"+sType+"'/>" 
			+"<input type=hidden name='��ǰ״̬' value='"+sNowStatus+"'/>" 
		with(document.all['frmInputs'].style)
		{
			display=""	
			height="50"
		}	
		formInput.target="frmInput"
		formInput.action=url
		if(oFun!=null) eval(oFun)
		formInput.submit()
	}
	function setForm()
	{
		document.all['frmInputs'].style.height=frmInputs.document.body.scrollHeight
		frmInputs.setTitle(TmpTitle)
		divContent.children[0].scrollIntoView(false)
	}
	function setHeight(iHeight)
	{
		document.all['frmInputs'].style.height=iHeight
	}
</script>	

<table style='height:100%' id=tblContentMain>
<tr><td style='border:0'>
<div id=divContent>
<SCRIPT LANGUAGE=vbscript RUNAT=Server>
	dim getID
	getID=mid(Request.QueryString("id"),1,1)
	
	Response.Write(getID)

</SCRIPT>


<%

	eval(""+Application("PARAM_INFO"))
	var selID=Request.QueryString("id")
		var cn=new Connection()
	
	//��ȡ�ŷ��ˡ������˵ĳ�ν
	var rs1
	
	if(getID=="D"){
		rs1=cn.execRs("SELECT param_value FROM "+sDBOwner+".GREMS_param WHERE param_name='һ�������˺��ŷ��˳�ν'")
		var appName=rs1("param_value")
		rs1=cn.execRs("SELECT param_value FROM "+sDBOwner+".GREMS_param WHERE param_name='һ�������˳�ν'")
		var confirmName=rs1("param_value")
		rs1=cn.execRs("SELECT param_value FROM "+sDBOwner+".GREMS_param WHERE param_name='һ���������ų�ν'")
		var depName=rs1("param_value")
	}else{
		rs1=cn.execRs("SELECT param_value FROM "+sDBOwner+".GREMS_param WHERE param_name='���������˺��ŷ��˳�ν'")
		var appName=rs1("param_value")
		rs1=cn.execRs("SELECT param_value FROM "+sDBOwner+".GREMS_param WHERE param_name='���������˳�ν'")
		var confirmName=rs1("param_value")
		rs1=cn.execRs("SELECT param_value FROM "+sDBOwner+".GREMS_param WHERE param_name='�����������ų�ν'")

	}

	
	
	var oParser=new ConstParser()
	var rs=cn.execRs("SELECT * FROM "+sDBOwner+".VW_GREMS_ALL WHERE ID='"+selID+"'")
	var iFlowTabs=1
	if(""+rs("SAMPLE_SAMPLE_UID")!="null") {
		++iFlowTabs
		if(""+rs("SCALE_SCALE_ID")!="null") {
			++iFlowTabs
			if(""+rs("CHECK_CHECK_ID")!="null") {
				++iFlowTabs
				if(""+rs("CONFIRM_CONFIRM_ID")!="null") {
					++iFlowTabs					
					if(""+rs("RELEASE_START_USER")!="null") {
						++iFlowTabs					
					}
				}
			}
		}
	}	
	var tblID=""
	for(i=rs.Fields.Count-1;i>=0;i--)
	{
		var sName=""+rs(i).Name
		if(/^EXECUTER\_/.exec(sName)==null) break
		tblID="<td id='"+sName+"'>"+(""+rs(i)=="null"?"":rs(i))+"</td>"+tblID
	}
	Response.Write("<table id=tblExecuter style='display:none'><tr>"+tblID+"</tr></table>")
	var sTables=["STATUS","APPLY","SAMPLE","SCALE","CHECK","CONFIRM","RELEASE"]
	var iIndex=0
	function Rs(col)
	{
		return sReturn=""+rs(sTables[iIndex]+"_"+col)		
		
	}
	function GetCol(col)				
	{
		var sAry=col.split(";")
		var sReturn=""
		for(var i=0;i<sAry.length;i++)
		{
			var sReturn1=Rs(sAry[i])
			if(sReturn1=="null"||sReturn1=="N/A") sReturn1=""
			sReturn+= "<td id='"+sAry[i].toLowerCase()+"' align=center><nobr>"+sReturn1+"</nobr></td>"
		}	
		return sReturn
	}
	var sType=""+Rs("SYS_TYPE")
	var sGroup=oParser.getGroup(sType)	
	var sStatus=""+Rs("CURRENT_STATUS")	
	Response.Write("<script>sNowStatus='"+sStatus+"'</script>")	
	
	function gc(sColumn,sDataType)
	{
		if(sType=="ETY"&&sColumn=="CRF_PUMPS") return "<td colspan=3>&nbsp;</td>"
		var sReturn=""+Rs(sColumn)
		if(sReturn=="null"||sReturn=="N/A") return ""			
		return "<td class='label'><nobr>"+oParser.getParam(sColumn,sType,2)+"</nobr><td>��</td></td>\n<td id='"+oParser.getParam(sColumn,sType,2)+"'><nobr>"+sReturn+"</nobr></td>\n"
	}
	
	//���ڽ��ֶ��е��ı���ʽ�����Է���HTML����
	function getMessage(sColumn)
	{
		var sReturn=""+Rs(sColumn)
		if(sReturn=="null"||sReturn=="N/A") return ""
		return sReturn.replace(/\n/g,"<br>")
	}
	function getMemo(sColumn)
	{
		var sReturn=""+Rs(sColumn)
		if(sReturn=="null"||sReturn=="N/A"||sReturn=="") return ""
		sReturn=sReturn.replace(/\n/g,"<br>��")
		var iMemoFlag=0,sTitle="��ע"
		if(sColumn=="SPECIAL_REASON") {
			iMemoFlag=2;sTitle="תΪ���⴦��ı�ע"
		} else if(sReturn.indexOf("[R]")==0) {
			sTitle="�˻�ԭ��"
			sReturn=sReturn.replace("[R]","")
			iMemoFlag=1
		}		
		var sStyle=iMemoFlag>0?"color:red;border-color:red":""
		sReturn="<br><fieldset style='width:100%;border:1px solid black;border-left:0;border-right:0;"+sStyle+"'><legend class='label'"
			+">"+sTitle+"</legend><div style='font-size:13px;text-align:left'>��"+sReturn+"</div></fieldset>"
		return sReturn
	}
	function CheckExits()
	{
		Response.Write(sOutput)
		sOutput=""
		++iIndex
		if(iIndex>iFlowTabs) {
			Response.Write(
				"</table></td></tr></div><tr><td style='height:10;border:0;background-color:green'></td></tr>"+
				"<tr><td style='border:0;height:1'><iframe name='frmInput' id='frmInputs' style='display:none;width:100%;height:150;border:2px outset lightgreen'></iframe></td></tr></table>"				
			)	
			Response.End()		
		}	
	}
	var letID=""+rs("ID")	
	var station=letID.substring(0,1)
	var cStation=(station=="D"?"������":"���")+"�˵�վ"
	var sButtinId="�ŷŵ���"	
	var sOutput="<table><caption style='font:17px ����'>"+cStation+sType+"ȡ�������ŷŵ�</caption>"
		+"<col width=1><col width=1>"
		+"<tr><td colspan=3 class=thinborder>\n<table><tr style='display:none'><td nowrap align=center id=ReleaseStation>"+cStation+"</td></tr>"
		+"<tr><td nowrap class=label align=center>��̰汾��</td><td ALIGN=center>"
		+Rs("VERSION")+"</td><td nowrap class=label align=center>"+sButtinId+"</td><td align=center id='"+sButtinId+"' nowrap>"+letID+"</td>"
		+"<td align=center id='�ŷ�����' style='display:none'>"+sType+"</td>"
		+"<td nowrap class=label align=center>״̬</td><td id='״̬' nowrap align=center>"+rs("STATUS_INFO_STATUS_INFO")+"</td>"
		+"</tr></table>\n</td></tr>"		
		+"<tr><td class=labelT>���д�</td><td class=labelT>����</td>"
		
	CheckExits()	
	sOutput+="<td  class=thinborder><table class='noborder' id='LevelApply' >"
		+"<col width=25% style='text-indent:1em'><col width=1><col width=25% ><col width=25% style='text-indent:1em'><col width=1><tr>"
		+gc("BUCKET_NO")
		+gc("LIQUT_ALTITUDE")
		+"</tr><tr>"
		+gc("SEC_PUMPS")
		+gc("SEC_STAGES")
		+"</tr><tr>"
		+gc("CRF_PUMPS")
		+gc("SEAWATER_FLOW")
		+"</tr><tr>"
		+gc("CYCLE_TIME")
		+"</tr><tr>"
		+gc("APPLY_DATE")	
		+gc("APPLY_USRID")	
	sOutput	+="</tr></table>\n"
		+getMemo("SPECIAL_REASON")
		+getMemo("APPLY_MEMO")+"</td>"
		+"</td></tr>"
	//ȡ��	
	CheckExits()	
	sOutput +="<tr><td rowspan=3 class=labelT>�������ƿ�</td><td class=labelT>ȡ��</td><td  class=thinborder>"
			+"<table class='noborder' id='LevelSample'>"
			+"<col width=25% style='text-indent:1em'><col width=1><col width=25% ><col width=25% style='text-indent:1em'><col width=1><tr>"
			+"<tr>"
			+gc("PUBNUM1")
			+gc("PUBNUM2")
			+"</tr><tr>"
			+gc("START_USER")
			+gc("START_DATE")
			+"</tr><tr>"
			+gc("SAMPLE_UID")
			+gc("SAMPLE_DATE")
			+"</tr>"
			+"</table>"
			+getMemo("SPECIAL_REASON")
			+getMemo("SAMPLE_MEMO")
	sOutput +="</td></tr>"
	//����	
	CheckExits()	
	function getItem(sItem)
	{
		return "<td class=label align=center>"+oParser.getParam(sItem,sType,2)
	}
	var sWidth="<col width="
	var sCount=3
	var strx=getItem("B")+getItem("Y")+getItem("TRITIUM")
	if(sGroup=="GAS") {strx+=getItem("Chimney_Speed");sWidth+="20";sCount=4}
	else {sWidth+="25"}
	sWidth+="% />"
	var sWidth1=""
	for(var i=0;i<sCount;i++) sWidth1+=sWidth
	strx+=getItem("Release_Speed")
	var sOutput1="<tr>"+strx+"</tr><tr>"
	//writeElement
	//�����ݿ��е�Ԫ����ת��Ϊ���ӵİ����ϱ�ʹ�Сд��Ԫ�ط���
	function re(str)
	{
		var str1=eval(
			str.toLowerCase().replace(/^([a-z])([a-z]*)(\d+.*)$/,
			"'<td align=center class=label><sup>$3</sup>\'+"+
			"'$1'.toUpperCase()+'$2</td>'"
		))					
		sOutput1+=str1
	}
	//����ָ��id��value���ı���
	function re1(str)
	{		
		var sValue=Rs(str)
		if(sValue=="null") sValue="&nbsp;"
		var str1="<td align=center id='"+str.toLowerCase()+"'>"+sValue+"</td>"
		sOutput1+=str1
	}
	
	
%>	
	<tr><td class=labelT>��������</td><td  class=thinborder>
	<%if(sStatus!="ALS"&&sStatus!="AQT"&&sStatus!="SQT") {%>
	<table STYLE='HEIGHT:1;border:1px solid black' id="tblAnalyze">
	<%=sWidth1%>
	<%
		//sOutput1 ="<tr>"+str+"</tr><tr>"
		re1("b");re1("y");re1("tritium");
		if(sGroup=="GAS") re1("Chimney_Speed");
		re1("Release_Speed");
		sOutput1+="</tr></table><br>"
		Response.Write(sOutput1)
		sOutput1=""
		if(sGroup=="GAS") {
	%>
	<table STYLE='HEIGHT:1;border:1px solid black'>
	<tr><td rowspan=6 width=1><nobr>�����׷�����<wbr>(��λ:Bq/m<sup>3</sup>)</nobr></td>
	<td rowspan=2 class=label>����</td>
	<%
			re("kr85");re("kr88");re("xe133");re("xe135");
			sOutput1+="</tr><tr>"
			re1("kr85");re1("kr88");re1("xe133");re1("xe135");
			sOutput1+="</tr>"
			var sName;
			if(sType!="ETY") {
				sName="���";
				sOutput1+="<tr><td rowspan=2 class=label>��Ĥ</td>"
				re("co58");re("co60");re("cs134");re("cs137")
				sOutput1+="</tr><tr>"
				re1("co58");re1("co60");re1("cs134");re1("cs137")
				sOutput1+="</tr>"
			} else sName="̼��";
			sOutput1+="<tr><td rowspan=2 class=label>"+sName+"</td>"
			re("i131");re("i133")
			sOutput1+="<td>&nbsp;</td><td>&nbsp;</td></tr><tr>"
			re1("i131");re1("i133")
			sOutput1+="<td>&nbsp;</td><td>&nbsp;</td></tr></table>"
		} else {
			var iSpe=Rs("CURRENT_DIVIDE")
	%>
	
	<table STYLE='border:1px solid black'>
	<col width=12.5%>
	<col width=12.5%>
	<col width=12.5%>
	<col width=12.5%>
	<col width=12.5%>
	<col width=12.5%>
	<col width=12.5%>
	<tr style='height:1'><td colspan=8 style='font:14px ����'>���ܦá�<%=iSpe%> Bq/m<sup>3</sup>ʱ�������ײ������(��λ��Bq/m<sup>3</sup>)</th></tr>
	<%
			sOutput1+="<tr>"
			re("ag110m");re("co58");re("co60");re("cs137");re("i131");re("cs134");re("mn54");re("sb124");
			sOutput1+="</tr><tr>"
			re1("ag110");re1("co58");re1("co60");re1("cs137");re1("i131");re1("cs134");re1("mn54");re1("sb124");
			sOutput1+="</tr></table>"
		}
		Response.Write(sOutput1)
		}
		Response.Write(getMemo("SPECIAL_REASON")+getMemo("SCALE_MEMO"))
	%>

	<table class=noborder><col width=25% align=right><col width=25%><col width=25% align=right>
	<tr><td class=label>�����ˣ�<td><%=Rs("scale_id")%><td class=label>����ʱ�䣺<td><%=Rs("scale_date")%></tr></table>
	</td></tr>		
<%		
	//��鵥��Ϣ
	CheckExits()
	
%>	
<tr><td class=labelT>���</td><td>
	<%=getMemo("CHECK_MEMO")%>
	<table class=noborder><col width=25% align=right><col width=25%><col width=25% align=right>
	<tr><td class=label>����ˣ�<td><%=Rs("check_id")%><td class=label>���ʱ�䣺<td><%=Rs("check_date")%></tr></table>	
	</td></tr>
	
<%
	//������Ϣ
	CheckExits()
	var iConfirmFlag=1
	var id2=""+Rs("confirm2_id")
	if(id2!="null"&&id2!=""&&id2!="N/A") iConfirmFlag=2
%>
	<tr><td rowspan=<%=iConfirmFlag%> class=labelT><%=station=="D"?"���д�":"�˰�ȫ�뻷����"%></td>
	<td class=labelT>����</td><td>
	
	<%=getMemo("SPECIAL_REASON")+getMemo("CONFIRM_MEMO")%>
	<table class=noborder id=tblConfirm><col width=25% align=right><col width=25%><col width=25% align=right>
	<tr><td class=label>ֵ����<td><%=Rs("confirm_id")%><td class=label>����ʱ�䣺
	<td id='_ConfirmDate'><%=Rs("confirm_date")%></tr></table>
	</td></tr>
	<%if(iConfirmFlag==2) {%>	
	<tr><td class=labelT>��������</td><td>
	<%=getMemo("CONFIRM2_MEMO")%>
	<table class=noborder><col width=25% align=right><col width=25%><col width=25% align=right>
	<tr><td class=label>�����ˣ�<td><%=Rs("confirm2_id")%><td class=label>����ʱ�䣺
	<td id='_spConfirmDate'><%=Rs("confirm2_date")%></tr></table></td></tr>
<%
	} 	
	CheckExits() 
%>
	<tr><td class=labelT>���д�<td class=labelT>�ŷ�<td id="tdReleaseInfo" style='border:2px solid black'  class=thinborder>
<%
		var iTimes=0
		while(!rs.eof)
		{			
%>
		<br>
		
			<table style="border:0;page-break-inside:avoid">			
			<tr><td style='height:1;border:0' class=thinborder>
			<table><tr>			
			<td class=label style='width:1'><nobr>�ŷ����</nobr></td><td width=1><nobr>&nbsp;<%=Rs("sub_id")%>&nbsp;</nobr></td>
			<td class=label width=20%><nobr>
			<%
				var sKrt=oParser.getParam("OKRT901MA",sType,2)
				if(station=="L"&&sGroup=="LIQ") sKrt=sKrt.replace("904,802")
				Response.Write(sKrt)
			%></nobr>
			<%=GetCol("OKRT901MA")%>
			<td class=label  width=20%><nobr>
			<%=oParser.getParam("NO_CONFLECT",sType,2)%></nobr>
			<%=GetCol("NO_CONFLECT")%>
			<%if(sGroup=="GAS") {%>
			<TD  class=label  width=20%><nobr>����վ80m����>0.5m/s</nobr>
			<%=GetCol("CONFIRM80M")%>
			</tr></TABLE>
			</td></tr><tr><td style='height:5;border:0'></td></tr><tr><td style="border:0;height:1">
			<table style='border-collapse:collapse'>
			<tr><Td class=label>�ŷ�����(m<sup>3</sup>/h)</td>
			<td class=label>�̴�����(m/s)</td>
			<td class=label>80m����</td>
			<td class=label>80m����(m/s)</td></tr>
			<tr>
			<%Response.Write(GetCol("Release_Speed;Chimney_Speed;Direction80M;Speed80M"))}%>			
			</tr>
			</table>
			</td></tr><tr><td style='height:5;border:0'></td></tr><tr><td style='height:1;border:0'>
			
			<% if(sType=="TER") {%>
			<table>
			<col width=25%>
			<col width=25%>
			<col width=25%>
			<tr><td class=label>��ʼ�ŷ�ʱ��<%=GetCol("start_time")%>
			<td  class=label>�ŷ�����(m<sup>3</sup>/h)��<%=GetCol("Release_Speed")%></tr>
			</tr>
			<tr><td class=label>�����ŷ�ʱ��</td><%=GetCol("end_time")%>
			<td  class=label>Һλ(m)��
			<%=GetCol("Release_liquid")%></tr>
			</tr>
			</table>
			<%} else {%>
			<table>
			<col width=30%>
			<col width=35%>

			<tr><td>&nbsp;<td  class=label>ʱ��
			</td><td  class=label><%=oParser.getParam("Release_liquid",sType,2)%></td></tr>
			<tr><td  class=label>��ʼ�ŷ�<%=GetCol("start_time;Bucket_Pressure")%></tr>
			<tr><td  class=label>�����ŷ�<%=GetCol("end_time;Bucket_Pressure2")%></tr>
			</table>
			<%}%>
			</td></tr><tr><td style='height:5;border:0'></td></tr><tr><td style='height:1;border:0'>
			<table>
			<col width=14%><col width=43%>
			<tr><td>&nbsp;<td class=label>��ʼ�ŷ�<td class=label>�����ŷ�</tr>
			<tr><Td class=label>������</td><%=GetCol("start_user;release_id")%></tr>
			<tr><td class=label><nobr>����ʱ��</nobr><%=GetCol("release_date;end_release_date")%></tr>
			<tr><td class=label>��ע<%=GetCol("start_release_memo;release_memo")%></tr>
			</table>
			</td></tr><tr><td style='height:5;border:0'></td></tr><tr><td style='height:1;border:0'>
			<% Response.Write(getMemo("SPECIAL_REASON"))%>
			</table>
			
<%		
		rs.MoveNext()	
		if(!rs.eof) Response.Write("<hr style='border:2px solid black;page-break-after:auto'>")	
		}
%>		
	</td></tr>
<%if(sStatus=="END") {%>	
	<tr><td style='border:0;text-align:right' COLSPAN=3 >
		<br>
		��ֵ��ǩ�֣�__________________
	</td></tr>
<%}%>	
<%	
	CheckExits()
	delete rs
	Erase(cn)
%>
</div>
</td></tr>
</table>