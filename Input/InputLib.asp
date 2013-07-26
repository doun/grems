<%@ Language=VBScript %>


<%
	sub InputTitle()
		Response.Write "<table style='font-size: 14px; width: 100%; height: 1; border-collapse: collapse' id='table4'> "
		Response.Write "<tr style='DISPLAY: none'>"
		Response.Write "<td id='ReleaseStation' noWrap align='middle' style='border: 1px solid black'>"
		Response.Write "大亚湾核电站</td>"
		Response.Write "</tr><tr>"
		Response.Write " <td class='label' noWrap align='middle'>规程版本号</td>"
		Response.Write "<td align='middle' style='border: 1px solid black'>"
		Response.Write "<input ID=Version name=Version value=GREMSV1.0></td>"
		Response.Write "<td class='label' noWrap align='middle'>排放单号</td>"
		Response.Write "<td id='排放单号' noWrap align='middle' style='border: 1px solid black'>"
		Response.Write "<Input ID='ID' name='ID'> </td>"
		Response.Write "<td id='排放类型' style='display: none; border: 1px solid black' align='middle'>"
		Response.Write "<Input ID=Sys_Type name=Sys_Type Value=TER></td>"
		Response.Write "<td class='label' noWrap align='middle'>状态</td>"
		Response.Write "<td id='状态' noWrap align='middle' style='border: 1px solid black'>"
		Response.Write "<Select ID=Current_Status name=Current_Status>"
		Response.Write "<option value='APP'>已经申请</option>"
		Response.Write "<option value='SMP'>已经取样</option>"
		Response.Write "<option value='END'><font color='#0000e0'>已经完成</font></option>"
		Response.Write "</select></td></tr></table>"
	End sub
%>