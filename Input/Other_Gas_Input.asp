
<head>
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

<form id="formInput" style="DISPLAY: none" method="post" target="frmInput">
</form>
<SCRIPT>
	
	var sNowStatus=null
	var sColorD="linen",sColorL="lightblue"
	//function DoPrint() 
	//{
		//alert("��ȷ�����Ѿ������˴�ӡ�������Ҵ�ӡ�����Ѿ�׼���˴�ӡֽ�����һ�о�����������ȷ������")
		
		//factory.printing.header=""
		//factory.printing.footer=""
	//	try {
	//		window.print();
			//if(factory.printing.Print(false) ) 
			//{
			//	SpoolStatus(true);
			//	factory.printing.WaitForSpoolingComplete();
			//	SpoolStatus(false);
			//}
	//	} catch(__e) {}	
	//}
	
	
	function DoPrint() { 
����	var odoc=window.document
	
����	//var odoc=window.divContent.document
����	
������	var r=odoc.body.createTextRange(); 
����	var stxt=r.htmlText; 
����	alert(stxt) 
����	var pwin=window.open("","print"); 
����	
����	pwin.document.write(stxt);
����	
����	//pwin.document.write(window.divContent.innerHTML); 
����	//pwin.document.write("<" + "script>print();</"+"script>");
����	//pwin.location.reload();
����	//pwin.close();
����	
����	
����	//alert(window.divContent.innerHTML)
����	
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
</SCRIPT>
<table id="table1" style="HEIGHT: 100%">
	<tr>
		<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px">
		<div id="divContent" style="overflow-y: auto; overflow-x: hidden; width: 100%; height: 100%; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef; background-color: linen">
			<table id="table2" style="DISPLAY: none">
				<tr>
					<td id="EXECUTER_ID">D9GAS20040014</td>
					<td id="EXECUTER_APP">P950115</td>
					<td id="EXECUTER_SAM">P890146</td>
					<td id="EXECUTER_SAL">P890146</td>
					<td id="EXECUTER_CHK">P910359</td>
					<td id="EXECUTER_COM">P890183</td>
					<td id="EXECUTER_CM2">��</td>
					<td id="EXECUTER_RS1">P950115</td>
					<td id="EXECUTER_RS2">��</td>
					<td id="EXECUTER_RS3">��</td>
					<td id="EXECUTER_RS4">��</td>
					<td id="EXECUTER_RS5">��</td>
					<td id="EXECUTER_RS6">��</td>
					<td id="EXECUTER_RS7">��</td>
					<td id="EXECUTER_RS8">��</td>
					<td id="EXECUTER_RS9">��</td>
				</tr>
			</table>
<SCRIPT>sNowStatus='END'</SCRIPT>

			<table id="table3">
				<caption style="FONT: 17px ����">������˵�վGASȡ�������ŷŵ�</caption>
				<colgroup>
					<col width="1"><col width="1">
				</colgroup>
				<tr>
					<td class="thinborder" colSpan="3">
					<table id="table4">
						<tr style="DISPLAY: none">
							<td id="ReleaseStation" noWrap align="middle">������˵�վ</td>
						</tr>
						<tr>
							<td class="label" noWrap align="middle">��̰汾��</td>
							<td align="middle">C-IP/EMS040 v11</td>
							<td class="label" noWrap align="middle">�ŷŵ���</td>
							<td id="�ŷŵ���" noWrap align="middle">D9GAS20040014</td>
							<td id="�ŷ�����" style="DISPLAY: none" align="middle">
							GAS</td>
							<td class="label" noWrap align="middle">״̬</td>
							<td id="״̬" noWrap align="middle">
							<font color="#0000e0">�Ѿ����</font></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="labelT">���д�</td>
					<td class="labelT">����</td>
					<td class="thinborder">
					<table class="noborder" id="table5">
						<colgroup>
							<col style="TEXT-INDENT: 1em" width="25%">
							<col width="1"><col width="25%">
							<col style="TEXT-INDENT: 1em" width="25%">
							<col width="1">
						</colgroup>
						<tr>
							<td class="label"><nobr>ϵͳ��</nobr>
							</td>
							<td>��</td>
							<td id="ϵͳ��"><nobr>9TEG002BA</nobr></td>
							<td class="label"><nobr>��ѹ(Bar)</nobr>
							</td>
							<td>��</td>
							<td id="��ѹ(Bar)"><nobr>1.5</nobr></td>
						</tr>
						<tr>
							<td class="label"><nobr>ǩ��ʱ��</nobr>
							</td>
							<td>��</td>
							<td id="ǩ��ʱ��"><nobr>2004-07-01 09:48</nobr></td>
							<td class="label"><nobr>ǩ����</nobr>
							</td>
							<td>��</td>
							<td id="ǩ����"><nobr>�￪��</nobr></td>
						</tr>
					</table>
					<br>
					<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
					<legend class="label">��ע</legend>
					<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
						��N2��ɨ�����</div>
					</fieldset></td>
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
							<td class="label"><nobr>��Ĥ(m<sup>3</sup>)</nobr>
							</td>
							<td>��</td>
							<td id="��Ĥ(m&lt;sup&gt;3&lt;/sup&gt;)"><nobr>0</nobr></td>
							<td class="label"><nobr>�(m<sup>3</sup>)</nobr>
							</td>
							<td>��</td>
							<td id="�(m&lt;sup&gt;3&lt;/sup&gt;)"><nobr>0</nobr></td>
						</tr>
						<tr>
							<td class="label"><nobr>ȡ����</nobr>
							</td>
							<td>��</td>
							<td id="ȡ����"><nobr>÷���</nobr></td>
							<td class="label"><nobr>ȡ��ʱ��</nobr>
							</td>
							<td>��</td>
							<td id="ȡ��ʱ��"><nobr>2004-07-01 10:00</nobr></td>
						</tr>
					</table>
					<br>
					<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
					<legend class="label">��ע</legend>
					<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
						��������ɨ</div>
					</fieldset></td>
				</tr>
				<tr>
					<td class="labelT">��������</td>
					<td class="thinborder">
					<table id="table7" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid; HEIGHT: 1px">
						<colgroup>
							<col width="20%"><col width="20%"><col width="20%">
							<col width="20%">
						</colgroup>
						<tr>
							<td class="label" align="middle">�����ܦ�(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">�ܦ�(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">�(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">�̴�����(m/s)
							</td>
							<td class="label" align="middle">�ŷ�����(m<sup>3</sup>/h)</td>
						</tr>
						<tr>
							<td id="b" align="middle">9.06E4</td>
							<td id="y" align="middle">0</td>
							<td id="tritium" align="middle">0</td>
							<td id="chimney_speed" align="middle">1.40E1</td>
							<td id="release_speed" align="middle">��1.57E5</td>
						</tr>
					</table>
					<br>
��<table style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid; HEIGHT: 1px" id="table8">
						<tr>
							<td width="1" rowSpan="6"><nobr>�����׷�����<WBR>(��λ:Bq/m<sup>3</sup>)</nobr></td>
							<td class="label" rowSpan="2">����</td>
							<td class="label" align="middle"><sup>85</sup>Kr</td>
							<td class="label" align="middle"><sup>88</sup>Kr</td>
							<td class="label" align="middle"><sup>133</sup>Xe</td>
							<td class="label" align="middle"><sup>135</sup>Xe</td>
						</tr>
						<tr>
							<td id="kr85" align="middle">&lt;3.02E4</td>
							<td id="kr88" align="middle">&lt;4.99E2</td>
							<td id="xe133" align="middle">9.35E3</td>
							<td id="xe135" align="middle">&lt;1.79E2</td>
						</tr>
						<tr>
							<td class="label" rowSpan="2">��Ĥ</td>
							<td class="label" align="middle"><sup>58</sup>Co</td>
							<td class="label" align="middle"><sup>60</sup>Co</td>
							<td class="label" align="middle"><sup>134</sup>Cs</td>
							<td class="label" align="middle"><sup>137</sup>Cs</td>
						</tr>
						<tr>
							<td id="co58" align="middle">0</td>
							<td id="co60" align="middle">0</td>
							<td id="cs134" align="middle">&nbsp;</td>
							<td id="cs137" align="middle">&nbsp;</td>
						</tr>
						<tr>
							<td class="label" rowSpan="2">���</td>
							<td class="label" align="middle"><sup>131</sup>I</td>
							<td class="label" align="middle"><sup>133</sup>I</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td id="i131" align="middle">0</td>
							<td id="i133" align="middle">0</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
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
							<td>÷���
							</td>
							<td class="label">����ʱ�䣺
							</td>
							<td>2004-07-01 11:19</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="labelT">���</td>
					<td>
					<table class="noborder" id="table10">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">����ˣ�
							</td>
							<td>�� Ծ
							</td>
							<td class="label">���ʱ�䣺
							</td>
							<td>2004-07-01 11:26</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="labelT">���д�</td>
					<td class="labelT">����</td>
					<td>
					<table class="noborder" id="table11">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">ֵ����
							</td>
							<td>���嶫
							</td>
							<td class="label">����ʱ�䣺 
							</td>
							<td id="_ConfirmDate">2004-07-02 12:56</td>
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
��<table style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; page-break-inside: avoid" id="table12">
						<tr>
							<td class="thinborder" style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
							<table id="table13">
								<tr>
									<td class="label" style="WIDTH: 1px"><nobr>
									�ŷ����</nobr></td>
									<td width="1"><nobr>&nbsp;1&nbsp;</nobr></td>
									<td class="label" width="20%"><nobr>
									KRT016/017MA����</nobr> 
									</td>
									<td id="okrt901ma" align="middle"><nobr>��</nobr></td>
									<td class="label" width="20%"><nobr>���ŷų�ͻ</nobr> 
									</td>
									<td id="no_conflect" align="middle"><nobr>��</nobr></td>
									<td class="label" width="20%"><nobr>
									����վ80m����&gt;0.5m/s</nobr> 
									</td>
									<td id="confirm80m" align="middle"><nobr>��</nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 5px">��</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
							<table style="BORDER-COLLAPSE: collapse" id="table14">
								<tr>
									<td class="label">�ŷ�����(m<sup>3</sup>/h)</td>
									<td class="label">�̴�����(m/s)</td>
									<td class="label">80m����</td>
									<td class="label">80m����(m/s)</td>
								</tr>
								<tr>
									<td id="release_speed" align="middle"><nobr>
									25</nobr></td>
									<td id="chimney_speed" align="middle"><nobr>
									14</nobr></td>
									<td id="direction80m" align="middle"><nobr>
									��ƫ��(SSE)</nobr></td>
									<td id="speed80m" align="middle"><nobr>2.46</nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 5px">��</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
							<table id="table15">
								<colgroup>
									<col width="30%"><col width="35%">
								</colgroup>
								<tr>
									<td>&nbsp;
									</td>
									<td class="label">ʱ�� </td>
									<td class="label">��ѹ(bar)</td>
								</tr>
								<tr>
									<td class="label">��ʼ�ŷ�
									</td>
									<td id="start_time" align="middle"><nobr>
									2004-07-02 10:20</nobr></td>
									<td id="bucket_pressure" align="middle">
									<nobr>1.5</nobr></td>
								</tr>
								<tr>
									<td class="label">�����ŷ�
									</td>
									<td id="end_time" align="middle"><nobr>
									2004-07-02 11:30</nobr></td>
									<td id="bucket_pressure2" align="middle">
									<nobr>0.2</nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 5px">��</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
							<table id="table16">
								<colgroup>
									<col width="14%"><col width="43%">
								</colgroup>
								<tr>
									<td>&nbsp;
									</td>
									<td class="label">��ʼ�ŷ�
									</td>
									<td class="label">�����ŷ�</td>
								</tr>
								<tr>
									<td class="label">������</td>
									<td id="start_user" align="middle"><nobr>�￪��</nobr></td>
									<td id="release_id" align="middle"><nobr>�￪��</nobr></td>
								</tr>
								<tr>
									<td class="label"><nobr>����ʱ��</nobr>
									</td>
									<td id="release_date" align="middle"><nobr>
									2004-07-02 12:58</nobr></td>
									<td id="end_release_date" align="middle">
									<nobr>2004-07-02 12:58</nobr></td>
								</tr>
								<tr>
									<td class="label">��ע
									</td>
									<td id="start_release_memo" align="middle">��</td>
									<td id="release_memo" align="middle">��</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 5px">��</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">��</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; TEXT-ALIGN: right" colSpan="3">
					<br>
					��ֵ��ǩ�֣�__________________ 
					</td>
				</tr>
			</table>
		</div>
		</td>
	</tr>
	<tr>
		<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 10px; BACKGROUND-COLOR: green">��</td>
	</tr>
	<tr>
		<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
		<iframe id="frmInputs" style="BORDER-RIGHT: lightgreen 2px outset; BORDER-TOP: lightgreen 2px outset; DISPLAY: none; BORDER-LEFT: lightgreen 2px outset; WIDTH: 100%; BORDER-BOTTOM: lightgreen 2px outset; HEIGHT: 150px" name="I1">
		</iframe></td>
	</tr>
</table>
