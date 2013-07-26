<!--#include file="InputLib.asp"-->

<%
	set GremsConn=server.createobject("adodb.connection")
    GremsConn.open Application("GREMS_ConnectionString")
    if err.number<>0 then 
        err.clear
        GremsConn.close
        set GremsConn=nothing
	    response.write "连接数据库错误!"
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


<title>ETY排放单录入</title>
<style>
<!--
	td {border:2px solid black}
	.label {font-family:黑体}
	.thinborder td {border:1px solid black}
	.labelT {font-family:楷体_gb2312;font-weight:bold}
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
//本函数用于判断txtName内数据是否日期+时间格式
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
		strTemp = "“" + sLabel + "”的值<" + txtName.value + ">不是合法的日期+时间型数据。" + unescape("\n\n") ;
		strTemp = strTemp + "合法的时间型数据格式是：<YYYY-MM-DD HH:MM>。" + unescape("\n\n") ;
		strTemp = strTemp + "如：<20时8分>可写成<20:08>或<20:8>。"
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return false ;
	}
	}

	function Button_Onclick()
	{
		//验证数据的完整性
		if (JHshTextEmpty(formInput.Version,"规程版本号")) return ;
		if (JHshTextEmpty(formInput.ID,"排放单编码")) return ;
		if (JHshTextEmpty(formInput.Current_Status,"状态")) return ;
		if (JHshSelectEmpty(formInput.Bucket_No,"反应堆号")) return ;
		if (JHshTextEmpty(formInput.liqut_altitude,"安全壳绝对压力(mbar)")) return ;
		if (!JHshIsNumber(formInput.liqut_altitude,"安全壳绝对压力(mbar)")) return ;
		if (JHshTextEmpty(formInput.seawater_flow,"大气压力(mbar)")) return ;
		if (!JHshIsNumber(formInput.seawater_flow,"大气压力(mbar)")) return ;		
		if (!JCheckTxtISDateTime(formInput.apply_date,"签发时间")) return;
		if (JHshSelectEmpty(formInput.apply_userid,"签发人")) return ;
		
		
		if (JHshTextEmpty(formInput.pubnum1,"碘盒")) return ;
		if (!JHshIsNumber(formInput.pubnum1,"碘盒")) return ;
		if (JHshTextEmpty(formInput.pubnum2,"氚")) return ;
		if (!JHshIsNumber(formInput.pubnum2,"氚")) return ;
		if (JHshSelectEmpty(formInput.sample_start_user,"放样人")) return ;		
		if (JHshSelectEmpty(formInput.sample_uid,"取样人")) return ;
				
		if (!JCheckTxtISDateTime(formInput.sample_start_date,"放样时间")) return;
		if (!JCheckTxtISDateTime(formInput.sample_date,"取样时间")) return;
		
		
		
		if (JHshTextEmpty(formInput.scale_b,"KRT009MA")) return ;
		if (JHshTextEmpty(formInput.scale_y,"碘盒总γ")) return ;
		if (JHshTextEmpty(formInput.scale_tritium,"氚")) return ;
		if (JHshTextEmpty(formInput.scale_chimney_speed,"烟囱流速")) return ;
		if (!JHshIsNumber(formInput.scale_chimney_speed,"烟囱流速")) return ;
		if (JHshTextEmpty(formInput.scale_release_speed,"排放流量")) return ;
		if (!JHshIsNumber(formInput.scale_release_speed,"排放流量")) return ;
		
		if (JHshTextEmpty(formInput.scale_kr85,"KR85")) return ;
		if (JHshTextEmpty(formInput.scale_kr88,"KR88")) return ;
		if (JHshTextEmpty(formInput.scale_xe133,"XE133")) return ;
		if (JHshTextEmpty(formInput.scale_xe135,"XE135")) return ;
		if (JHshTextEmpty(formInput.scale_i131,"I131")) return ;
		if (JHshTextEmpty(formInput.scale_i133,"I133")) return ;
		if (JHshSelectEmpty(formInput.scale_scale_ID,"分析人")) return ;
		if (!JCheckTxtISDateTime(formInput.scale_scale_date,"分析时间")) return ;
		
		
		if (JHshSelectEmpty(formInput.Check_Id,"检查人")) return ;
		if (!JCheckTxtISDateTime(formInput.Check_date,"检查时间")) return ;
		if (JHshSelectEmpty(formInput.confirm_id,"值长")) return ;
		if (!JCheckTxtISDateTime(formInput.Confirm_date,"审批时间")) return ;
		
		
		if (JHshTextEmpty(formInput.release_speed,"排放流速")) return ;
		if (!JHshIsNumber(formInput.release_speed,"排放流速")) return ;
		if (JHshTextEmpty(formInput.release_chimney_speed,"烟囱流速")) return ;
		if (!JHshIsNumber(formInput.release_chimney_speed,"烟囱流速")) return ;
		if (JHshTextEmpty(formInput.Release_Speed80M,"80m风速")) return ;
		if (!JHshIsNumber(formInput.Release_Speed80M,"80m风速")) return ;
		if (!JCheckTxtISDateTime(formInput.release_start_time,"开始排放时间")) return;
		if (!JCheckTxtISDateTime(formInput.release_end_time,"结束排放时间")) return;

		if (JHshTextEmpty(formInput.Release_Bucket_Pressure,"开始排放时安全壳压力")) return ;
		if (!JHshIsNumber(formInput.Release_Bucket_Pressure,"开始排放时安全壳压力")) return ;
		if (JHshTextEmpty(formInput.Release_bucket_pressure2,"结束排放时安全壳压力")) return ;
		if (!JHshIsNumber(formInput.Release_bucket_pressure2,"结束排放时安全壳压力")) return ;

		
		if (JHshSelectEmpty(formInput.release_start_user,"开始排放副值长")) return ;
		if (JHshSelectEmpty(formInput.release_release_id,"结束排放副值长")) return ;
		if (!JCheckTxtISDateTime(formInput.release_release_date,"开始操作时间")) return;
		if (!JCheckTxtISDateTime(formInput.release_end_release_date,"结束操作时间")) return;		
		
		if(formInput.lb_special_release.checked)
		{
			if (JHshTextEmpty(formInput.apply_special_reason,"申请时的特殊排放原因")) return ;
			if (JHshTextEmpty(formInput.sample_special_reason,"取样时的特殊排放原因")) return ;
			if (JHshTextEmpty(formInput.scale_special_reason,"分析时的特殊排放原因")) return ;
			if (JHshTextEmpty(formInput.Confirm_special_reason,"审批时的特殊排放原因")) return ;
			if (JHshSelectEmpty(formInput.confirm_id2,"特殊排放审批人")) return ;
			if (!JCheckTxtISDateTime(formInput.Confirm_date2,"特殊排放审批时间")) return ;
			if (JHshTextEmpty(formInput.release_special_reason,"排放时的特殊排放原因")) return ;
			
			formInput.target="ifrSave";
			formInput.action = "InputSave.asp?Op=Add&Sys=ETY&Special=True";
			formInput.submit() ;
		}
		else
		{
			formInput.target="ifrSave";
			formInput.action = "InputSave.asp?Op=Add&Sys=ETY";
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
			document.all.lb_shenpi.innerText = "运行处";	
		}
		else
		{
			formInput.style.backgroundColor ="lightblue";
			document.all.lb_shenpi.innerText = "核安全处";
		}
		
		
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
				<caption style="FONT: 17px 黑体">
				<Select ID=station name=station onchange='return Station_onchange()'>
					<option value='D'>大亚湾核电站</option>
					<option value='L'>岭澳核电站</option>
				</select>
				ETY取样分析排放单</caption>
				<colgroup>
					<col width="1"><col width="1">
				</colgroup>
				<tr>
					<td class="thinborder" colSpan="3">
					<input type=checkbox id="lb_special_release" name="lb_special_release"><font color=red>特殊排放</font>
						<table style='font-size: 14px; width: 100%; height: 1; border-collapse: collapse' id='table4'> 
						<tr style='DISPLAY: none'>
						<td id='ReleaseStation' noWrap align='middle' style='border: 1px solid black'>大亚湾核电站</td>
						</tr><tr>
					    <td class='label' noWrap align='middle'>规程版本号</td>
						<td align='middle' style='border: 1px solid black'>
						<input ID=Version name=Version value='<%=guicheng%>'></td>
						<td class='label' noWrap align='middle'>排放单号</td>
						<td id='排放单号' noWrap align='middle' style='border: 1px solid black'>
						<Input ID='ID' name='ID' readonly value = "自动生成排放单号"> </td>
						<td id='排放类型' style='display: none; border: 1px solid black' align='middle'>
						<Input ID=Sys_Type name=Sys_Type Value=ETY></td>
						<td class='label' noWrap align='middle'>状态</td>
						<td id='状态' noWrap align='middle' style='border: 1px solid black'>
						<Select ID=Current_Status name=Current_Status>
							<option value='END'>已经完成</option>
							<option value='SMP'>已经取样</option>
							<option value='APP'>已经申请</option>
						</select></td></tr>
						
						</table>
					</td>
				</tr>
				
<tr>
		<td class="labelT">运行处</td>
		<td class="labelT">申请</td>
		<td class="thinborder">
		<table class="noborder" id="table2">
			<colgroup>
				<col style="TEXT-INDENT: 1em" width="25%"><col width="1">
				<col width="25%"><col style="TEXT-INDENT: 1em" width="25%">
				<col width="1">
			</colgroup>
			<tr>
				<td class="label"><nobr>反应堆号</nobr>
				</td>
				<td style="border: 0 none">：</td>
				<td id="反应堆号" style="border: 0 none"><nobr>
				<Select ID='Bucket_No' name='Bucket_No'>
				<Option value=''>请选择</Option>
				<option value='1号机'>1号机</option>
				<option value='2号机'>2号机</option>
				</select>
				</nobr></td>
				<td class="label"><nobr>安全壳绝对压力(mbar)</nobr>
				</td>
				<td style="border: 0 none">：</td>
				<td id="安全壳绝对压力(mbar)" style="border: 0 none"><nobr><Input ID='liqut_altitude' name='liqut_altitude'></nobr></td>
			</tr>
			<tr>
				<td colSpan="3" style="border: 0 none">&nbsp;</td>
				<td class="label"><nobr>大气压力(mbar)</nobr>
				</td>
				<td style="border: 0 none">：</td>
				<td id="大气压力(mbar)" style="border: 0 none"><nobr><Input ID='seawater_flow' name='seawater_flow'></nobr></td>
			</tr>
			<tr>
				<td class="label"><nobr>签发时间</nobr>
				</td>
				<td style="border: 0 none">：</td>
				<td id="签发时间" style="border: 0 none"><nobr><Input name='apply_date' onmousedown="dateTime.calendar(this)" ></nobr></td>
				<td class="label"><nobr>签发人</nobr>
				</td>
				<td style="border: 0 none">：</td>
				<td id="签发人" style="border: 0 none"><nobr>
				<Select ID=apply_userid name=apply_userid>
				<%
					call LoadHuman("GP002","")
				%>
				</Select>
				</nobr></td>
			</tr>
		</table>
		<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">备注</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='apply_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>特殊排放原因</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='apply_special_reason' size=80></div>
		</fieldset>
		
		</td>
	</tr>


				<tr>
					<td class="labelT" rowSpan="3">环境控制科</td>
					<td class="labelT">取样</td>
					<td class="thinborder">
					<table class="noborder" id="table6">
						<colgroup>
							<col style="TEXT-INDENT: 1em" width="25%">
							<col width="1"><col width="25%">
							<col style="TEXT-INDENT: 1em" width="25%">
							<col width="1">
						</colgroup>
						<tr>
							<td class="label"><nobr>碘盒(m<sup>3</sup>)</nobr>
							</td>
							<td>：</td>
							<td id="碘盒(m&lt;sup&gt;3&lt;/sup&gt;)"><nobr><Input name='pubnum1'></nobr></td>
							<td class="label"><nobr>氚(m<sup>3</sup>)</nobr>
							</td>
							<td>：</td>
							<td id="氚(m&lt;sup&gt;3&lt;/sup&gt;)"><nobr><Input name='pubnum2'></nobr></td>
						</tr>
						<tr>
							<td class="label"><nobr>放样人</nobr>
							</td>
							<td>：</td>
							<td id="放样人"><nobr>
							<Select ID=sample_start_user name=sample_start_user>
							<%
								call LoadHuman("GP003","")
							%>
							</nobr></td>
							<td class="label"><nobr>放样时间</nobr>
							</td>
							<td>：</td>
							<td id="放样时间"><nobr><Input name='sample_start_date' onmousedown="dateTime.calendar(this)"></nobr></td>
						</tr>
						<tr>
							<td class="label"><nobr>取样人</nobr>
							</td>
							<td>：</td>
							<td id="取样人"><nobr>
							<Select ID=sample_uid name=sample_uid>
							<%
								call LoadHuman("GP003","")
							%>
							</nobr></td>
							<td class="label"><nobr>取样时间</nobr>
							</td>
							<td>：</td>
							<td id="取样时间"><nobr><Input name='sample_date' onmousedown="dateTime.calendar(this)"></nobr></td>
						</tr>
					</table>
<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">备注</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='sample_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>特殊排放原因</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='sample_special_reason' size=80></div>
		</fieldset>
							
					</td>
				</tr>
				
				<tr>
					<td class="labelT">测量分析</td>
					<td class="thinborder">
					<table id="table7" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid; HEIGHT: 1px">
						<colgroup>
							<col width="20%"><col width="20%"><col width="20%">
							<col width="20%">
						</colgroup>
						<tr>
							<td class="label" align="middle">KRT009MA(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">碘盒总γ(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">氚(Bq/m<sup>3</sup>)
							</td>
							<td class="label" align="middle">烟囱流速(m/s)
							</td>
							<td class="label" align="middle">排放流量(m<sup>3</sup>/h)</td>
						</tr>
						<tr>
							<td id="b" align="middle"><Input name='scale_b'></td>
							<td id="y" align="middle"><Input name='scale_y'></td>
							<td id="tritium" align="middle"><Input name='scale_tritium'></td>
							<td id="chimney_speed" align="middle"><Input name='scale_chimney_speed'></td>
							<td id="release_speed" align="middle"><Input name='scale_release_speed'></td>
						</tr>
					</table>
					<br>
					
	
					
　<table style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid; HEIGHT: 1px" id="table8">
						<tr>
							<td width="1" rowSpan="6"><nobr>γ能谱分析表<WBR>(单位:Bq/m<sup>3</sup>)</nobr></td>
							<td class="label" rowSpan="2">气体</td>
							<td class="label" align="middle"><sup>85</sup>Kr</td>
							<td class="label" align="middle"><sup>88</sup>Kr</td>
							<td class="label" align="middle"><sup>133</sup>Xe</td>
							<td class="label" align="middle"><sup>135</sup>Xe</td>
						</tr>
						<tr>
							<td id="kr85" align="middle"><input name='scale_kr85'></td>
							<td id="kr88" align="middle"><input name='scale_kr88'></td>
							<td id="xe133" align="middle"><input name='scale_xe133'></td>
							<td id="xe135" align="middle"><input name='scale_xe135'></td>
						</tr>
						<tr>
							<td class="label" rowSpan="2">碳盒</td>
							<td class="label" align="middle"><sup>131</sup>I</td>
							<td class="label" align="middle"><sup>133</sup>I</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td id="i131" align="middle"><input name='scale_i131'></td>
							<td id="i133" align="middle"><input name='scale_i133'></td>
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
							<td class="label">分析人：
							</td>
							<td>
							<Select ID=scale_scale_ID name=scale_scale_ID>
							<%
								call LoadHuman("GP003","")
							%>
							</Select>		
							</td>
							<td class="label">分析时间：
							</td>
							<td>
							<Input name='scale_scale_date' onmousedown="dateTime.calendar(this)" >
							</td>
						</tr>
					</table>

		<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">备注</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='scale_scale_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>特殊排放原因</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='scale_special_reason' size=80></div>
		</fieldset>
							
					</td>
				</tr>
				<tr>
					<td class="labelT">检查</td>
					<td>
					<table class="noborder" id="table10">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">检查人：
							</td>
							<td>
							<Select ID=Check_Id name=Check_Id>
							<%
								call LoadHuman("GP008","")
							%>
							</Select>	
							</td>
							<td class="label">检查时间：
							</td>
							<td><Input name='Check_date' onmousedown="dateTime.calendar(this)" ></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="labelT" id='lb_shenpi' name='lb_shenpi'>运行处</td>
					<td class="labelT">审批</td>
					<td>
					<table class="noborder" id="table11">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">值长：
							</td>
							<td>
							<Select ID=confirm_id name=confirm_id>
							<%
								call LoadHuman("GP004","GP005")
							%>
							</select>							
							</td>
							<td class="label">审批时间： 
							</td>
							<td id="_ConfirmDate"><Input name='Confirm_date' onmousedown="dateTime.calendar(this)" ></td>
						</tr>
						
					</table>
			<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">备注</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='Confirm_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>特殊排放原因</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			<Input name='Confirm_special_reason' size=80></div>
		</fieldset>		
					<table class="noborder" id="table11">
						<colgroup>
							<col align="right" width="25%"><col width="25%">
							<col align="right" width="25%">
						</colgroup>
						<tr>
							<td class="label">特殊排放审批：
							</td>
							<td>
							<Select ID=confirm_id2 name=confirm_id2>
							<%
								call LoadHuman("GP005","")
							%>
							</select>							
							</td>
							<td class="label">特殊排放审批时间： 
							</td>
							<td id="_ConfirmDate"><Input name='Confirm_date2' onmousedown="dateTime.calendar(this)" ></td>
						</tr>
						
					</table>
										
					</td>
				</tr>
				
				<tr>
					<td class="labelT">运行处
					</td>
					<td class="labelT">排放
					</td>
					<td class="thinborder" id="tdReleaseInfo" style="BORDER-RIGHT: black 2px solid; BORDER-TOP: black 2px solid; BORDER-LEFT: black 2px solid; BORDER-BOTTOM: black 2px solid">
					<br>
　<table style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; page-break-inside: avoid" id="table12">
						<tr>
							<td class="thinborder" style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
							<table id="table13">
								<tr>
									<td class="label" style="WIDTH: 1px"><nobr>
									排放序号</nobr></td>
									<td width="1"><nobr><Input name='release_sub_id' value='1' readonly size=1></nobr></td>
									<td class="label" width="20%"><nobr>
									KRT016/017MA可用</nobr> 
									</td>
									<td id="okrt901ma" align="middle"><nobr>
									<Select ID=release_okrt901ma name=release_okrt901ma >
									<Option value= '是'>是</option>
									<Option value= '否'>否</option>
									</select>									
									</nobr></td>
									<td class="label" width="20%"><nobr>无排放冲突</nobr> 
									</td>
									<td id="no_conflect" align="middle"><nobr>
									<Select ID=release_no_conflect name=release_no_conflect>
									<Option value= '是'>是</option>
									<Option value= '否'>否</option>
									</select>									
									</nobr></td>
									<td class="label" width="20%"><nobr>
									气象站80m风速&gt;0.5m/s</nobr> 
									</td>
									<td id="confirm80m" align="middle"><nobr>
									<Select ID=release_confirm80m name=release_confirm80m>
									<Option value= '是'>是</option>
									<Option value= '否'>否</option>
									</select>									
									</nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 5px">　</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 1px">
							<table style="BORDER-COLLAPSE: collapse" id="table14">
								<tr>
									<td class="label">排放流速(m<sup>3</sup>/h)</td>
									<td class="label">烟囱流速(m/s)</td>
									<td class="label">80m风向</td>
									<td class="label">80m风速(m/s)</td>
								</tr>
								<tr>
									<td id="release_speed" align="middle"><nobr>
									<input name='release_speed'></nobr></td>
									<td id="chimney_speed" align="middle"><nobr>
									<input name='release_chimney_speed'></nobr></td>
									<td id="direction80m" align="middle"><nobr>
									
<select type=text name='Release_Direction80M'>
<option value="">请选择</option>
<option value="东(E)">东(E)</option>
<option value="东南(ES)">东南(ES)</option>
<option value="东偏南(SSE)">东偏南(SSE)</option>
<option value="东北(NE)">东北(NE)</option>
<option value="东偏北(NNE)">东偏北(NNE)</option>

<option value="西(W)">西(W)</option>
<option value="西南(SW)">西南(SW)</option>
<option value="西偏南(SSW)">西偏南(SSW)</option>
<option value="西北(NW)">西北(NW)</option>
<option value="西偏北(NNW)">西偏北(NNW)</option>

<option value="南(S)">南(S)</option>
<option value="南偏西(SWW)">南偏西(SWW)</option>
<option value="南偏东(SEE)">南偏东(SEE)</option>

<option value="北(N)">北(N)</option>
<option value="北偏东(NEE)">北偏东(NEE)</option>
<option value="北偏西(NWW)">北偏西(NWW)</option>
</select>

									</nobr></td>
									<td id="speed80m" align="middle"><nobr>
									<input name='Release_Speed80M'></nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 5px">　</td>
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
									<td class="label">时间 </td>
									<td class="label">安全壳压力(mbar)</td>
								</tr>
								<tr>
									<td class="label">开始排放
									</td>
									<td id="start_time" align="middle"><nobr>
									<Input name='release_start_time' onmousedown="dateTime.calendar(this)" ></nobr></td>
									<td id="bucket_pressure" align="middle">
									<nobr><input name='Release_Bucket_Pressure'></nobr></td>
								</tr>
								<tr>
									<td class="label">结束排放
									</td>
									<td id="end_time" align="middle"><nobr>
									<Input name='release_end_time' onmousedown="dateTime.calendar(this)" ></nobr></td>
									<td id="bucket_pressure2" align="middle">
									<nobr><input name='Release_bucket_pressure2'></nobr></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px; HEIGHT: 5px">　</td>
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
									<td class="label">开始排放
									</td>
									<td class="label">结束排放</td>
								</tr>
								<tr>
									<td class="label">副值长</td>
									<td id="start_user" align="middle"><nobr>
									<Select ID=release_start_user name=release_start_user>
									<%
											call LoadHuman("GP002","")
									%>
									</Select>														
									</nobr></td>
									<td id="release_id" align="middle"><nobr>
									<Select ID=release_release_id name=release_release_id>
									<%
											call LoadHuman("GP002","")
									%>
									</Select>															
									</nobr></td>
								</tr>
								<tr>
									<td class="label"><nobr>操作时间</nobr>
									</td>
									<td id="release_date" align="middle"><nobr>
									<Input name='release_release_date' onmousedown="dateTime.calendar(this)"></nobr></td>
									<td id="end_release_date" align="middle">
									<nobr><Input name='release_end_release_date' onmousedown="dateTime.calendar(this)"></nobr></td>
								</tr>
							
							</table>
	<br>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label">备注</legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='release_release_memo' size=80></div>
		</fieldset>
		<fieldset style="BORDER-RIGHT: 0px; BORDER-TOP: black 1px solid; BORDER-LEFT: 0px; WIDTH: 100%; BORDER-BOTTOM: black 1px solid">
		<legend class="label"><font color=red>特殊排放原因</font></legend>
		<div style="font-size: 13px; text-align: left; scrollbar-face-color: GREEN; scrollbar-arrow-color: white; scrollbar-highlight-color: white; scrollbar-3dlight-color: green; scrollbar-shadow-color: white; scrollbar-darkshadow-color: darkgreen; scrollbar-track-color: #eef">
			　<Input name='release_special_reason' size=80></div>
		</fieldset>

							
							</td>
						</tr>
						
					</table>
					
　
					</td>
				</tr>
				<tr>
					<td style="text-align: right; border: 0px none" colSpan="3">
					<br>
					副值长签字：__________________ 
					</td>
				</tr>
			</table>
		</div>
		</td>
	</tr>
	<tr>
		<td style="height: 10px; border: 0px none; background-color: green">

	
		<!--打印控件-->
	
	<table style='width:100%;height:100%' cellspacing=0>
	<tr><Td style="height:1;padding:0 0 0 10">
	<table style='width:1;height:1;' id=tblButton><tr>	</tr></table></td>
	<td style='height:1;width:1;padding:0 10 0 0'>
		<table style='width:1;height:1;' id=tblOtherButton><tr> </tr></table>
	</td>
	</tr>
	</table>
	
	<script language=javascript>
		createButton('重置','Reset_Onclick()')
		createButton('保存','Button_Onclick()')
		
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
	
	response.write "<option value=''>请选择</option>" & vbcrlf
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
