<!--#include file="../Library/form.asp"-->
<!--#include file="../include/checkConflict.asp"-->
<%
	//����ŷų�ͻ
	var cn=new Connection()
	var rs=cn.execRs("select isspecial_cfm from "+sDBOwner+".grems_status where id='"+sID+"'")
	var ipx=parseInt(rs(0))
	var sMsg=CheckConflict(cn,sID,sType)
	var sReturn=sMsg==null?"û":""
	var krt=cp.getParam("OKRT901MA",sType,2)
	if(sID.substring(0,1)=="D"&&sGroup=="LIQ") krt=krt.replace("902","904")
	//������ŷų�ͻ����ô���������ʱ�Ƿ��Ѿ�ָ������ǿ���ŷ�
	if(sReturn==""&&ipx!=3&&ipx!=7) showErr(sMsg)		
	sReturn="<font style='color:"+(sReturn==""?"red":"")+"'>"+sReturn+"���ŷų�ͻ</font>"
	rs.close()
	rs=null
	Erase(cn)
%>
<STYLE>
	input {text-align:center}
</STYLE>
<script>
	var ipx=<%=ipx%>
	var krt="<%=krt%>".replace("��","����")
	function oFun()
	{
		document.body.action="../release/releasePost.asp"
		oForm.formatForm(document.body)
		oForm.InitForm('document.body')		
	}
	function oAdd(oFormInst,dom,data)
	{
		reset()
		wLoader.push("IPX",ipx)
		var sux=""
		if(document.all['��ʼ�ŷ�']==null) sux="ʱ��"
		var d1=document.all['��ʼ�ŷ�'+sux]
		var d2=document.all['�����ŷ�'+sux]
		var s1=new Date(DateHandler.CheckDate(d1).replace(/\-/g,"/"))
		var s=new Date(DateHandler.CheckDate(d2).replace(/\-/g,"/"))
		if(s.getTime()-s1.getTime()<=0) {
			alert1("�����ŷ�ʱ��һ�����ڿ�ʼ�ŷ�ʱ�䣡",d2)
			return false
		}
		if(!OKRT901MA.checked) 
		{
			if(ipx<5) {alert1(krt+"���������ύ�ŷŵ���",OKRT901MA);return false}
			else if(!bunt(krt)) return false					
		}
		wLoader.push("OKRT901MA",(OKRT901MA.checked==true)?"��":"��")		
		wLoader.push("NO_CONFLECT","��")
		var bFlag=EnablereLeaseTrue.checked
		if(bFlag!=true) bFlag=EnablereLeaseFalse.checked
		if(bFlag!=true)
		{
			alert1("����ѡ���ǽ����ŷŻ����ж��ŷţ�",EnablereLeaseFalse)
			return false
		}
		wLoader.push("bRelease",(EnablereLeaseTrue.checked==true)?"1":"0")
		if(sGroup=="GAS")
		{
			if(CONFIRM80M.checked!=true)
			{
				alert1("80�׷��ٱ������0.5m/s���ܽ����ŷš�",CONFIRM80M)
				return false
			}
			wLoader.push("CONFIRM80M","��")	
			if(parseFloat(Speed80M.value)<=0.5)
			{
				alert1("80�׷��ٱ������0.5m/s���ܽ����ŷš�",Speed80M)
				return false
			}
		}
		return true
	}
	function postForm(bFlag)
	{
		sFlag=bFlag
		oForm.PostForm(document.body,checkForm,funResult)
	}	
</script>
<table cellspacing=0 cellpadding=0 style='height:1;border:0;background-color:transparent;filter:'>
<tr><td style='height:1;border:0'>

<table><tr><Td>
<%=krt%><input type=checkbox value='��' id='OKRT901MA' style='width:15'>
</td>
<td>
<%=sReturn%>
<input type=checkbox value='��' id='NO_CONFLECT' style='width:15' disabled checked>
</td>
<%if(sGroup=="GAS") {%>
<TD>����վ80m����>0.5m/s<input type=checkbox value='��' id='CONFIRM80M' style='width:15' >
</TABLE>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table style='border-collapse:collapse' border>
<tr><Td>�ŷ�����(m<sup>3</sup>/h)</td><td>�̴�����(m/s)</td><td>80m����</td><td>80m����(m/s)</td></tr>
<tr><Td><input type=text name=Release_Speed name1=�ŷ�����  datatype='f' min=0></td>
<td><input type=text name=Chimney_Speed name1=�̴�����  datatype='f' min=7 max=30 alert='t' /></td>
<td><select type=text name=Direction80M name1=80m����  datatype='f' min=0>
<option value="��(E)">��(E)</option>
<option value="����(ES)">����(ES)</option>
<option value="��ƫ��(SSE)">��ƫ��(SSE)</option>
<option value="����(NE)">����(NE)</option>
<option value="��ƫ��(NNE)">��ƫ��(NNE)</option>

<option value="��(W)">��(W)</option>
<option value="����(SW)">����(SW)</option>
<option value="��ƫ��(SSW)">��ƫ��(SSW)</option>
<option value="����(NW)">����(NW)</option>
<option value="��ƫ��(NNW)">��ƫ��(NNW)</option>

<option value="��(S)">��(S)</option>
<option value="��ƫ��(SWW)">��ƫ��(SWW)</option>
<option value="��ƫ��(SEE)">��ƫ��(SEE)</option>

<option value="��(N)">��(N)</option>
<option value="��ƫ��(NEE)">��ƫ��(NEE)</option>
<option value="��ƫ��(NWW)">��ƫ��(NWW)</option>
</select>
</td>
<td><input type=text id=Speed80M name=Speed80M name1=80m����  datatype='f' min=0 max=60 /></td>
</tr>
<%}%>
</table>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<%if(sType=="TER") {%>
<table border>
<col width=25%>
<col width=25%>
<col width=25%>
<tr><FormItem:date datatype='date' text='��ʼ�ŷ�ʱ��' value='' /><td>�ŷ�����(m<sup>3</sup>/h)��
<td><input type=text name1=�ŷ����� name=Release_Speed  datatype='f' min=0></td></tr>
</tr>
<tr><FormItem:date datatype='date' text='�����ŷ�ʱ��' value='' /><td>Һλ(m)��
<td><input type=text name1=Һλ name=Release_liquid  datatype='f' min=-1></td></tr>
</tr>
</table>
<%} else {%>
<table border>
<col width=30%>
<col width=35%>

<tr><td>&nbsp;<td>ʱ��
</td><td><%=cp.getParam("Release_liquid",sType,2)%></td></tr>
<tr><FormItem:date datatype='date' text='��ʼ�ŷ�' value='' />
<td><input type=text name=Bucket_Pressure name1=��ʼ�ŷ�<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' min=0></td></tr>
<tr><FormItem:date datatype='date' text='�����ŷ�' value='' />
<td><input type=text name=Bucket_Pressure2 name1=�����ŷ�<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' min=0></td></tr>
</table>
<%}%>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table><tr><td style='width:1'>��<br>ע</td>
<td><textarea name="��ע" datatype="s" max=255></textarea>
</td></tr></table>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table>
<col width=50%>
<tr><td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLeaseTrue />
<label for=EnablereLeaseTrue>�����ŷ�</label></nobr></td>
<td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLeaseFalse /><label for=EnablereLeaseFalse>�ж��ŷ�</label></nobr></td>
</tr></table>
</td></tr></table>
<script>button("�ύ||postForm()")</script>