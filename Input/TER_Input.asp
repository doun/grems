<!--#include file="InputLib.asp"-->

<%
	set GremsConn=server.createobject("adodb.connection")
    GremsConn.open Application("GREMS_ConnectionString")
    if err.number<>0 then 
        err.clear
        GremsConn.close
        set GremsConn=nothing
	    response.write "�������ݿ����!"
        Response.End 
    end if
    
    Dim rs,strSQL,guicheng
	

	strSQL = "SELECT param_value FROM Grems.GREMS_param where param_id = 'VERSION'"
	Set rs = Server.CreateObject("ADODB.Recordset")
	
	
	rs.Open strSQL,GremsConn

		IF Not (rs.EOF And rs.BOF) Then
			guicheng = rs("param_value")
		End if
	rs.Close:Set rs=nothing
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script language=javascript src="../library/date.js"></script>
<script language="javascript" src="..\Library\default.js"></script>
<script language="javascript" src="..\Library\http.js"></script>

<script language="JavaScript" src="../Include/JspFunction.js"></script>


<title>TER�ŷŵ�¼��</title>
<style>
<!--
	td {border:2px solid black}
	.label {font-family:����}
	.thinborder td {border:1px solid black}
	.labelT {font-family:����_gb2312;font-weight:bold}
	table {font-size:14px;width:100%;height:1;border-collapse:collapse}
	.noborder td {border:0}
	#tdReleaseInfo td {text-align:center}
	
-->
</style>
</head>

<SCRIPT>
	
	
	var sNowStatus=null
	var sColorD="linen",sColorL="lightblue"
	new oDateTime("dateTime")
	
	
 	function createButton(sName,sFun,sFlag)
	{
		var o=sFlag==null?tblButton:tblOtherButton		
		var oCell=o.rows[0].insertCell(0)
		oCell.innerHTML="<nobr><button value='"+sName+"' style='border:0;background:url(../images/button.gif) no-repeat;width:100;height:22'"+
			"onclick='this.blur();"+sFun+"' "+
			" id=button1 name=button1>"+sName+"</button></nobr>"
	}
	
	//
//�����������ж�txtName�������Ƿ�����+ʱ���ʽ
//
	function JCheckTxtISDateTime(txtName,sLabel)
	{
	var sValue;
	var sDate, sTime
	
	sDate = JHshStrCopy(txtName.value,0,10);
	sTime = JHshStrCopy(txtName.value,11,5);
	if ((JHshStrIsTime(sTime)) & (JHshStrIsDate(sDate)))
	{
		return true;
	}
	else
	{
		strTemp = "��" + sLabel + "����ֵ<" + txtName.value + ">���ǺϷ�������+ʱ�������ݡ�" + unescape("\n\n") ;
		strTemp = strTemp + "�Ϸ���ʱ�������ݸ�ʽ�ǣ�<YYYY-MM-DD HH:MM>��" + unescape("\n\n") ;
		strTemp = strTemp + "�磺<20ʱ8��>��д��<20:08>��<20:8>��"
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return false ;
	}
	}

	function Button_Onclick()
	{
		//��֤���ݵ�������
		if (JHshTextEmpty(formInput.Version,"��̰汾��")) return ;
		if (JHshTextEmpty(formInput.ID,"�ŷŵ�����")) return ;
		if (JHshTextEmpty(formInput.Current_Status,"״̬")) return ;
		if (JHshSelectEmpty(formInput.Bucket_No,"�޺�")) return ;
		if (JHshTextEmpty(formInput.liqut_altitude,"Һλ")) return ;
		if (!JHshIsNumber(formInput.liqut_altitude,"Һλ")) return ;
		if (JHshTextEmpty(formInput.sec_pumps,"SEC��̨Ͷ����")) return ;
		if (JHshTextEmpty(formInput.sec_stages,"SEC����Ͷ����")) return ;
		//if (!JHshCheckTxtIsDate(formInput.cycle_time,"ѭ����ʼʱ��")) return;
		if (!JCheckTxtISDateTime(formInput.cycle_time,"ѭ����ʼʱ��")) return;
		if (!JCheckTxtISDateTime(formInput.apply_date,"ǩ��ʱ��")) return;
		if (JHshSelectEmpty(formInput.apply_userid,"ǩ����")) return ;
				
		if (JHshSelectEmpty(formInput.sample_uid,"ȡ����")) return ;
		if (JHshTextEmpty(formInput.pubnum2,"Һλ")) return ;
		if (!JHshIsNumber(formInput.pubnum2,"Һλ")) return ;
		
		if (!JCheckTxtISDateTime(formInput.sample_date,"ȡ��ʱ��")) return;
		if (JHshTextEmpty(formInput.scale_b,"PHֵ")) return ;
		if (JHshTextEmpty(formInput.scale_y,"Һ���ܦ�")) return ;
		if (JHshTextEmpty(formInput.scale_tritium,"�")) return ;
		if (!JHshIsNumber(formInput.scale_tritium,"�")) return ;
		if (JHshTextEmpty(formInput.scale_release_speed,"�ŷ�����")) return ;
		if (!JHshIsNumber(formInput.scale_release_speed,"�ŷ�����")) return ;
		if (JHshSelectEmpty(formInput.scale_scale_ID,"������")) return ;
		if (!JCheckTxtISDateTime(formInput.scale_scale_date,"����ʱ��")) return ;
		if (JHshSelectEmpty(formInput.Check_Id,"�����")) return ;
		if (!JCheckTxtISDateTime(formInput.Check_date,"���ʱ��")) return ;
		if (JHshSelectEmpty(formInput.confirm_id,"ֵ��")) return ;
		if (!JCheckTxtISDateTime(formInput.Confirm_date,"����ʱ��")) return ;
		
		if (!JCheckTxtISDateTime(formInput.release_start_time,"��ʼ�ŷ�ʱ��")) return;
		if (!JCheckTxtISDateTime(formInput.release_end_time,"�����ŷ�ʱ��")) return;
		
		if (JHshTextEmpty(formInput.release_speed,"�ŷ�����")) return ;
		if (!JHshIsNumber(formInput.release_speed,"�ŷ�����")) return ;
		
		if (JHshTextEmpty(formInput.release_liquid,"�ŷź�Һλ")) return ;
		if (!JHshIsNumber(formInput.release_liquid,"�ŷź�Һλ")) return ;
		if (JHshSelectEmpty(formInput.release_start_user,"��ʼ�ŷŸ�ֵ��")) return ;
		if (JHshSelectEmpty(formInput.release_release_id,"�����ŷŸ�ֵ��")) return ;
		if (!JCheckTxtISDateTime(formInput.release_release_date,"��ʼ����ʱ��")) return;
		if (!JCheckTxtISDateTime(formInput.release_end_release_date,"��������ʱ��")) return;		
		
		//�Ƿ������ŷ�
		
		if(formInput.lb_special_release.checked)
		{
			if (JHshTextEmpty(formInput.apply_special_reason,"����ʱ�������ŷ�ԭ��")) return ;
			if (JHshTextEmpty(formInput.sample_special_reason,"ȡ��ʱ�������ŷ�ԭ��")) return ;
			if (JHshTextEmpty(formInput.scale_special_reason,"����ʱ�������ŷ�ԭ��")) return ;
			if (JHshTextEmpty(formInput.Confirm_special_reason,"����ʱ�������ŷ�ԭ��")) return ;
			if (JHshSelectEmpty(formInput.confirm_id2,"�����ŷ�������")) return ;
			if (!JCheckTxtISDateTime(formInput.Confirm_date2,"�����ŷ�����ʱ��")) return ;
			if (JHshTextEmpty(formInput.release_special_reason,"�ŷ�ʱ�������ŷ�ԭ��")) return ;
			
			formInput.target="ifrSave";
			formInput.action = "InputSave.asp?Op=Add&Sys=TER&Special=True";
			formInput.submit() ;
		}
		else
		{
			formInput.target="ifrSave";
			formInput.action = "InputSave.asp?Op=Add&Sys=TER";
			formInput.submit() ;
		}
	}
	function Reset_Onclick()
	{
			//formInput.action=""
						//formInput.submit()
			
		window.location.reload(false)
		
	}
	
	function Station_onchange()
	{
		
		var ops=formInput.Bucket_No.options

		if( formInput.station.value == "D")
		{
		
			formInput.style.backgroundColor ="linen";
			formInput.Bucket_No.innerHTML = "";
			ops.add(new Option("",""));
			ops.add(new Option("D0TER001BA","D0TER001BA"));
			ops.add(new Option("D0TER002BA","D0TER002BA"));
			ops.add(new Option("D0TER003BA","D0TER003BA"));
			document.all.lb_shenpi.innerText = "���д�";				
		}
		else
		{
			formInput.style.backgroundColor ="lightblue";
			formInput.Bucket_No.innerHTML = "";
			ops.add(new Option("",""));
			ops.add(new Option("L0TER001BA","L0TER001BA"));
			ops.add(new Option("L0TER002BA","L0TER002BA"));
			ops.add(new Option("L0TER003BA","L0TER003BA"));
			document.all.lb_shenpi.innerText = "�˰�ȫ��";
		}
		
		formInput.pubnum1.value=formInput.Bucket_No.value;
		
	}
	
	function Bucket_Change()
	{
		formInput.pubnum1.value=formInput.Bucket_No.value;
	}
	
	

	
	
</SCRIPT>

<body>

<form id="formInput" name="formInput" style="DISPLAY: non1; background-color: linen" method="post" target="ifrSave">

<table id="table1" name="table1" style="height: 100%; font-size: 14px; width: 100%; border-collapse: collapse">
	<tr>
		<td style="border: 0px none">
		<div id="divContent" name="divContent" style="overflow-y: auto; overflow-x: hidden; width: 100%; height: 100%; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef;">
			<table id="table2" style="display: none; font-size: 14px; width: 100%; height: 1; border-collapse: collapse">
				
			</table>
<SCRIPT>sNowStatus='END'</SCRIPT>

			<table style="font-size: 14px; width: 100%; height: 1; border-collapse: collapse" id="table3">
				<caption style="FONT: 17px ����">
				<Select ID=station name=station onchange='return Station_onchange()'>
					<option value='D'>������˵�վ</option>
					<option value='L'>��ĺ˵�վ</option>
				</select>
				TERȡ�������ŷŵ�</caption>
				<colgroup>
					<col width="1"><col width="1">
				</colgroup>
				
				<tr>
				
					<td class="thinborder" colSpan="3">
					<input type=checkbox id="lb_special_release" name="lb_special_release"><font color=red>�����ŷ�</font>
					
						<table style='font-size: 14px; width: 100%; height: 1; border-collapse: collapse' id='table4'> 
						<tr style='DISPLAY: none'>
						<td id='ReleaseStation' noWrap align='middle' style='border: 1px solid black'>������˵�վ</td>
						</tr><tr>
					    <td class='label' noWrap align='middle'>��̰汾��</td>
						<td align='middle' style='border: 1px solid black'>
						<input ID=Version name=Version value='<%=guicheng%>'></td>
						<td class='label' noWrap align='middle'>�ŷŵ���</td>
						<td id='�ŷŵ���' noWrap align='middle' style='border: 1px solid black'>
						<Input ID='ID' name='ID' readonly value = "�Զ������ŷŵ���"> </td>
						<td id='�ŷ�����' style='display: none; border: 1px solid black' align='middle'>
						<Input ID=Sys_Type name=Sys_Type Value=TER></td>
						<td class='label' noWrap align='middle'>״̬</td>
						<td id='״̬' noWrap align='middle' style='border: 1px solid black'>
						<Select ID=Current_Status name=Current_Status>
							<option value='END'>�Ѿ����</option>
							<option value='SMP'>�Ѿ�ȡ��</option>
							<option value='APP'>�Ѿ�����</option>
						</select></td></tr>
						
						</table>
					</td>
				</tr>
				<tr>
		<td class="labelT">���д�</td>
		<td class="labelT">����</td>
		<td class="thinborder">
		<table class="noborder" id="table3">
			<colgroup>
				<col style="TEXT-INDENT: 1em" width="25%"><col width="1">
				<col width="25%"><col style="TEXT-INDENT: 1em" width="25%">
				<col width="1">
			</colgroup>
			<tr>
				<td class="label"><nobr>�޺�</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="�޺�" name="guahao" style="border: 0 none"><nobr><Select ID='Bucket_No' name='Bucket_No' onchange='return Bucket_Change()'>
				<Option value=''></Option>
				<Option value='D0TER001BA'>D0TER001BA</Option>
				<Option value='D0TER002BA'>D0TER002BA</Option>
				<Option value='D0TER003BA'>D0TER003BA</Option>
				</select></nobr></td>
				
				<td class="label"><nobr>Һλ(m)</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="Һλ(m)" style="border: 0 none"><nobr><Input ID='liqut_altitude' name='liqut_altitude'></nobr></td>
			</tr>
			<tr>
				<td class="label"><nobr>SEC��̨Ͷ����</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="SEC��̨Ͷ����" style="border: 0 none"><nobr><Input ID='sec_pumps' name='sec_pumps'></nobr></td>
				<td class="label"><nobr>SEC����Ͷ����</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="SEC����Ͷ����" style="border: 0 none"><nobr><Input ID='sec_stages' name='sec_stages'></nobr></td>
			</tr>
			<tr>
				<td class="label"><nobr>CRF��Ͷ��̨��</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="CRF��Ͷ��̨��" style="border: 0 none"><nobr><Input name='crf_pumps'></nobr></td>
				<td class="label"><nobr>�ŷ�����ˮ����</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="�ŷ�����ˮ����" style="border: 0 none"><nobr><Input name='seawater_flow'></nobr></td>
			</tr>
			<tr>
				<td class="label"><nobr>ѭ����ʼʱ��</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="ѭ����ʼʱ��" style="border: 0 none"><nobr><Input name='cycle_time' onmousedown="dateTime.calendar(this)"></nobr></td>
			</tr>
			<tr>
				<td class="label"><nobr>ǩ��ʱ��</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="ǩ��ʱ��" style="border: 0 none"><nobr><Input name='apply_date' onmousedown="dateTime.calendar(this)" ></nobr></td>
				<td class="label"><nobr>ǩ����</nobr>
				</td>
				<td style="border: 0 none">��</td>
				<td id="ǩ����" style="border: 0 none"><nobr>
				<Select ID=apply_userid name=apply_userid>
				<%
					call LoadHuman("GP002","")
				%>
				</Select>
				</nobr>
				</td>
			</tr>
		</table>
		<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">��ע</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='apply_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>�����ŷ�ԭ��</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='apply_special_reason' size=80></div>
		</fieldset>
		
		</td>
	</tr>

				<tr>
					<td class="labelT" rowSpan="3">�������ƿ�</td>
					<td class="labelT">ȡ��</td>
					<td class="thinborder">
					<table class="noborder" id="table6">
						<colgroup>
							<col style="TEXT-INDENT: 1em" width="25%">
							<col width="1"><col width="25%">
							<col style="TEXT-INDENT: 1em" width="25%">
							<col width="1">
						</colgroup>
						<tr>
							<td class="label"><nobr>�޺�</nobr>
							</td>
							<td style="border: 0 none">��</td>
							<td id="�޺�1" style="border: 0 none"><nobr><Input name='pubnum1'></nobr></td>
							<td class="label"><nobr>Һλ(m)</nobr>
							</td>
							<td style="border: 0 none">��</td>
							<td id="Һλ(m)" style="border: 0 none"><nobr><Input name='pubnum2'></nobr></td>
						</tr>
						<tr>
							<td class="label"><nobr>ȡ����</nobr>
							</td>
							<td style="border: 0 none">��</td>
							<td id="ȡ����" style="border: 0 none"><nobr>
							<Select ID=sample_uid name=sample_uid>
							<%
								call LoadHuman("GP003","")
							%>
							</Select>
							</nobr></td>
							<td class="label"><nobr>ȡ��ʱ��</nobr>
							</td>
							<td>��</td>
							<td id="ȡ��ʱ��"><nobr><Input name='sample_date' onmousedown="dateTime.calendar(this)"></nobr></td>
						</tr>

					</table>
							<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">��ע</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='sample_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>�����ŷ�ԭ��</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='sample_special_reason' size=80></div>
		</fieldset>

					</td>
				</tr>
				<tr>
					<td class="labelT">��������</td>
					<td class="thinborder">
					<table id="table7" style="height: 1px; font-size: 14px; width: 100%; border-collapse: collapse; border: 1px solid black">
						<colgroup>
							<col width="25%"><col width="25%"><col width="25%">
						</colgroup>
						<tr>
							<td class="label" align="middle">PHֵ
							</td>
							<td class="label" align="middle">Һ���ܦ�(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">�(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">�ŷ�����(m<sup>3</sup>/h)</td>
						</tr>
						<tr>
							<td id="b" align="middle" style="border: 1px solid black">
							<Select ID=scale_b name=scale_b>
							<Option value= '�ϸ�'>�ϸ�</option>
							<Option value= '���ϸ�'>���ϸ�</option>
							</select>
							</td>
							
							<td id="y" align="middle" style="border: 1px solid black">
							<Input name='scale_y'></td>
							<td id="tritium" align="middle" style="border: 1px solid black">
							<Input name='scale_tritium'></td>
							<td id="release_speed" align="middle" style="border: 1px solid black">
							<Input name='scale_release_speed'></td>
						</tr>
					</table>
					<br>
��<table style="font-size: 14px; width: 100%; height: 1; border-collapse: collapse; border: 1px solid black" id="table8">
						<colgroup>
							<col width="12.5%"><col width="12.5%">
							<col width="12.5%"><col width="12.5%">
							<col width="12.5%"><col width="12.5%">
							<col width="12.5%">
						</colgroup>
						<tr style="HEIGHT: 1px">
							<td style="font-style: normal; font-variant: normal; font-weight: normal; font-size: 14px; font-family: ����; border: 1px solid black" colSpan="8">
							���ܦá�500000 Bq/m<sup>3</sup>ʱ�������ײ������(��λ��Bq/m<sup>3</sup>)</td>
						</tr>
						<tr>
							<td class="label" align="middle"><sup>110m</sup>Ag</td>
							<td class="label" align="middle"><sup>58</sup>Co</td>
							<td class="label" align="middle"><sup>60</sup>Co</td>
							<td class="label" align="middle"><sup>137</sup>Cs</td>
							<td class="label" align="middle"><sup>131</sup>I</td>
							<td class="label" align="middle"><sup>134</sup>Cs</td>
							<td class="label" align="middle"><sup>54</sup>Mn</td>
							<td class="label" align="middle"><sup>124</sup>Sb</td>
						</tr>
						<tr>
							<td id="ag110" align="middle" style="border: 1px solid black;width=10">
							<Input name='scale_ag110' size=8></td>
							<td id="co58" align="middle" style="border: 1px solid black;width=5%">
							<Input name='scale_co58' size=8></td>
							<td id="co60" align="middle" style="border: 1px solid black;width=5%">
							<Input name='scale_co60' size=8></td>
							<td id="cs137" align="middle" style="border: 1px solid black;width=5%">
							<Input name='scale_cs137' size=8></td>
							<td id="i131" align="middle" style="border: 1px solid black;width=5%">
							<Input name='scale_i131' size=8></td>
							<td id="cs134" align="middle" style="border: 1px solid black;width=5%">
							<Input name='scale_cs134' size=8></td>
							<td id="mn54" align="middle" style="border: 1px solid black;width=5%">
							<Input name='scale_mn54' size=8></td>
							<td id="sb124" align="middle" style="border: 1px solid black;width=5%">
							<Input name='scale_sb124' size=8></td>
						</tr>
					</table>
					<table class="noborder" id="table9">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">�����ˣ�
							</td>
							<td style="border: 0 none">
							<Select ID=scale_scale_ID name=scale_scale_ID>
							<%
								call LoadHuman("GP003","")
							%>
							</Select>							
							</td>
							<td class="label">����ʱ�䣺
							</td>
							<td style="border: 0 none"><Input name='scale_scale_date' onmousedown="dateTime.calendar(this)" ></td>
						</tr>
					</table>
		<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">��ע</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='scale_scale_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>�����ŷ�ԭ��</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='scale_special_reason' size=80></div>
		</fieldset>

					
					</td>
				</tr>
				<tr>
					<td class="labelT">���</td>
					<td style="border: 2px solid black">
					<table class="noborder" id="table10">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">����ˣ�
							</td>
							<td style="border: 0 none">
							<Select ID=Check_Id name=Check_Id>
							<%
								call LoadHuman("GP008","")
							%>
							</Select>							
							
							</td>
							<td class="label">���ʱ�䣺
							</td>
							<td style="border: 0 none"><Input name='Check_date' onmousedown="dateTime.calendar(this)" ></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="labelT" id='lb_shenpi' name='lb_shenpi'>���д�</td>
					<td class="labelT">����</td>
					<td style="border: 2px solid black">
					<table class="noborder" id="table11">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">ֵ����
							</td>
							<td style="border: 0 none">
							<Select ID=confirm_id name=confirm_id>
							<%
								call LoadHuman("GP004","GP005")
							%>
							
							</td>
							<td class="label">����ʱ�䣺 
							</td>
							<td id="_ConfirmDate" style="border: 0 none">
							<Input name='Confirm_date' onmousedown="dateTime.calendar(this)" ></td>
						</tr>
					</table>
		<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">��ע</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='Confirm_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>�����ŷ�ԭ��</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='Confirm_special_reason' size=80></div>
		</fieldset>

					<table class="noborder" id="table11">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">�����ŷ�������
							</td>
							<td>
							<Select ID=confirm_id2 name=confirm_id2>
							<%
								call LoadHuman("GP005","")
							%>
							</select>							
							</td>
							<td class="label">�����ŷ�����ʱ�䣺 
							</td>
							<td id="_ConfirmDate"><Input name='Confirm_date2' onmousedown="dateTime.calendar(this)" ></td>
						</tr>
						
					</table>
										
					</td>
				</tr>
				<tr>
					<td class="labelT">���д�
					</td>
					<td class="labelT">�ŷ�
					</td>
					<td class="thinborder" id="tdReleaseInfo" style="BORDER-RIGHT: black 2px solid; BORDER-TOP: black 2px solid; BORDER-LEFT: black 2px solid; BORDER-BOTTOM: black 2px solid">
					<br>
��<table style="page-break-inside: avoid; font-size: 14px; width: 100%; height: 1; border-collapse: collapse; border: 0px none" id="table12">
						<tr>
							<td class="thinborder" style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
							<table style="font-size: 14px; width: 100%; height: 1; border-collapse: collapse" id="table13">
								<tr>
									<td class="label" style="WIDTH: 1px"><nobr>
									�ŷ����</nobr></td>
									<td width="1" style="text-align: center; border: 1px solid black">
									<nobr><Input name='release_sub_id' value='1' readonly size=1></nobr></td>
									<td class="label" width="20%"><nobr>
									OKRT901MA����</nobr> 
									</td>
									<td id="okrt901ma" align="middle" style="text-align: center; border: 1px solid black">
									<nobr>
									<Select ID=release_okrt901ma name=release_okrt901ma>
									<Option value= '��'>��</option>
									<Option value= '��'>��</option>
									</select>
									</nobr></td>
									<td class="label" width="20%"><nobr>���ŷų�ͻ</nobr> 
									</td>
									<td id="no_conflect" align="middle" style="text-align: center; border: 1px solid black">
									<nobr>
									<Select ID=release_no_conflect name=release_no_conflect>
									<Option value= '��'>��</option>
									<Option value= '��'>��</option>
									</select>
									</nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="height: 5px; text-align: center; border: 0px none">��</td>
						</tr>
						<tr>
							<td style="height: 1px; text-align: center; border: 0px none">
							<table style="font-size: 14px; width: 100%; height: 1; border-collapse: collapse" id="table14">
								<colgroup>
									<col width="25%"><col width="25%">
									<col width="25%">
								</colgroup>
								<tr>
									<td class="label">��ʼ�ŷ�ʱ��
									</td>
									<td id="start_time" align="middle" style="text-align: center; border: 1px solid black">
									<nobr><Input name='release_start_time' onmousedown="dateTime.calendar(this)" ></nobr></td>
									<td class="label">�ŷ�����(m<sup>3</sup>/h)��
									</td>
									<td id="release_speed" align="middle" style="text-align: center; border: 1px solid black">
									<nobr><Input name='release_speed'></nobr></td>
								</tr>
								<tr>
									<td class="label">�����ŷ�ʱ��</td>
									<td id="end_time" align="middle" style="text-align: center; border: 1px solid black">
									<nobr><Input name='release_end_time' onmousedown="dateTime.calendar(this)"></nobr></td>
									<td class="label">Һλ(m)�� 
									</td>
									<td id="release_liquid" align="middle" style="text-align: center; border: 1px solid black">
									<nobr><Input name='release_liquid'></nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="height: 5px; text-align: center; border: 0px none">��</td>
						</tr>
						<tr>
							<td style="height: 1px; text-align: center; border: 0px none">
							<table style="font-size: 14px; width: 100%; height: 1; border-collapse: collapse" id="table15">
								<colgroup>
									<col width="14%"><col width="43%">
								</colgroup>
								<tr>
									<td style="text-align: center; border: 1px solid black">
									&nbsp;
									</td>
									<td class="label">��ʼ�ŷ�
									</td>
									<td class="label">�����ŷ�</td>
								</tr>
								<tr>
									<td class="label">��ֵ��</td>
									<td id="start_user" align="middle" style="text-align: center; border: 1px solid black">
									<nobr>
									<Select ID=release_start_user name=release_start_user>
									<%
											call LoadHuman("GP002","")
									%>
									</Select>										
									</nobr></td>
									<td id="release_id" align="middle" style="text-align: center; border: 1px solid black">
									<nobr>
									<Select ID=release_release_id name=release_release_id>
									<%
											call LoadHuman("GP002","")
									%>
									</Select>										
									</nobr></td>
								</tr>
								<tr>
									<td class="label"><nobr>����ʱ��</nobr>
									</td>
									<td id="release_date" align="middle" style="text-align: center; border: 1px solid black">
									<nobr><Input name='release_release_date' onmousedown="dateTime.calendar(this)"></nobr></td>
									<td id="end_release_date" align="middle" style="text-align: center; border: 1px solid black">
									<nobr><Input name='release_end_release_date' onmousedown="dateTime.calendar(this)"></nobr></td>
								</tr>
								
							</table>
		<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">��ע</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='release_release_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>�����ŷ�ԭ��</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			��<Input name='release_special_reason' size=80></div>
		</fieldset>

							
							</td>
						</tr>
						
					</table>
					
��
					</td>
				</tr>
				<tr>
					<td style="text-align: right; border: 0px none" colSpan="3">
					<br>
					��ֵ��ǩ�֣�__________________ 
					</td>
				</tr>
			</table>
		</div>
		</td>
	</tr>
	<tr>
		<td style="height: 10px; border: 0px none; background-color: green">

	
		<!--��ӡ�ؼ�-->
	
	<table style='width:100%;height:100%' cellspacing=0>
	<tr><Td style="height:1;padding:0 0 0 10">
	<table style='width:1;height:1;' id=tblButton><tr>	</tr></table></td>
	<td style='height:1;width:1;padding:0 10 0 0'>
		<table style='width:1;height:1;' id=tblOtherButton><tr> </tr></table>
	</td>
	</tr>
	</table>
	
	<script language=javascript>
		createButton('����','Reset_Onclick()')
		createButton('����','Button_Onclick()')
		
	</script>
	
		</td>
	</tr>
	<tr>
		<td style="height: 1px; border: 0px none">
		<iframe id="frmInputs" style="BORDER-RIGHT: lightgreen 2px outset; BORDER-TOP: lightgreen 2px outset; DISPLAY: none; BORDER-LEFT: lightgreen 2px outset; WIDTH: 100%; BORDER-BOTTOM: lightgreen 2px outset; HEIGHT: 150px" name="I1">
		</iframe></td>
	</tr>
	
</table>


 <iframe frameborder="1" name="ifrSave" id="ifrSave" width="500" height="200" SCROLLING="yes" style="DISPLAY: none">
  </iframe> 
  
  </form>
</body>


</html>

<%
	sub LoadHuman(right,special_right)
	Dim rs,strSQL,w_id,C_Name
	
	if special_right <> "" then
		strSQL = "SELECT EP_NAME FROM Grems.GREMS_EMPLOYEE where EP_WORKGROUP like '%"+right+"%' or Ep_WORKGROUP like '%"+Special_right+"%' "
	else
		strSQL = "SELECT EP_NAME FROM Grems.GREMS_EMPLOYEE where EP_WORKGROUP like '%"+right+"%' "
	end if
	Set rs = Server.CreateObject("ADODB.Recordset")
	
	
	
	rs.Open strSQL,GremsConn
	
	response.write "<option value=''>��ѡ��</option>" & vbcrlf
		IF Not (rs.EOF And rs.BOF) Then
		Do While Not rs.EOF
		  C_Name = rs("EP_Name")
		  response.write "<option value='" & C_Name & "'>"& C_Name &"</option>" & vbcrlf
		  rs.movenext
		Loop
		End if
	rs.Close:Set rs=nothing
  End sub
  

	GremsConn.close
%>