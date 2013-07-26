<!--#include file="../Library/form.asp"-->
<!--#include file="../include/checkConflict.asp"-->
<%
	//检查排放冲突
	var cn=new Connection()
	var rs=cn.execRs("select isspecial_cfm from "+sDBOwner+".grems_status where id='"+sID+"'")
	var ipx=parseInt(rs(0))
	var sMsg=CheckConflict(cn,sID,sType)
	var sReturn=sMsg==null?"没":""
	var krt=cp.getParam("OKRT901MA",sType,2)
	if(sID.substring(0,1)=="D"&&sGroup=="LIQ") krt=krt.replace("902","904")
	//如果有排放冲突，那么检查在审批时是否已经指定可以强制排放
	if(sReturn==""&&ipx!=3&&ipx!=7) showErr(sMsg)		
	sReturn="<font style='color:"+(sReturn==""?"red":"")+"'>"+sReturn+"有排放冲突</font>"
	rs.close()
	rs=null
	Erase(cn)
%>
<STYLE>
	input {text-align:center}
</STYLE>
<script>
	var ipx=<%=ipx%>
	var krt="<%=krt%>".replace("可","不可")
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
		if(document.all['开始排放']==null) sux="时间"
		var d1=document.all['开始排放'+sux]
		var d2=document.all['结束排放'+sux]
		var s1=new Date(DateHandler.CheckDate(d1).replace(/\-/g,"/"))
		var s=new Date(DateHandler.CheckDate(d2).replace(/\-/g,"/"))
		if(s.getTime()-s1.getTime()<=0) {
			alert1("结束排放时间一定晚于开始排放时间！",d2)
			return false
		}
		if(!OKRT901MA.checked) 
		{
			if(ipx<5) {alert1(krt+"，您不能提交排放单。",OKRT901MA);return false}
			else if(!bunt(krt)) return false					
		}
		wLoader.push("OKRT901MA",(OKRT901MA.checked==true)?"是":"否")		
		wLoader.push("NO_CONFLECT","是")
		var bFlag=EnablereLeaseTrue.checked
		if(bFlag!=true) bFlag=EnablereLeaseFalse.checked
		if(bFlag!=true)
		{
			alert1("请您选择是结束排放还是中断排放！",EnablereLeaseFalse)
			return false
		}
		wLoader.push("bRelease",(EnablereLeaseTrue.checked==true)?"1":"0")
		if(sGroup=="GAS")
		{
			if(CONFIRM80M.checked!=true)
			{
				alert1("80米风速必须大于0.5m/s才能进行排放。",CONFIRM80M)
				return false
			}
			wLoader.push("CONFIRM80M","是")	
			if(parseFloat(Speed80M.value)<=0.5)
			{
				alert1("80米风速必须大于0.5m/s才能进行排放。",Speed80M)
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
<%=krt%><input type=checkbox value='是' id='OKRT901MA' style='width:15'>
</td>
<td>
<%=sReturn%>
<input type=checkbox value='是' id='NO_CONFLECT' style='width:15' disabled checked>
</td>
<%if(sGroup=="GAS") {%>
<TD>气象站80m风速>0.5m/s<input type=checkbox value='是' id='CONFIRM80M' style='width:15' >
</TABLE>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table style='border-collapse:collapse' border>
<tr><Td>排放流速(m<sup>3</sup>/h)</td><td>烟囱流速(m/s)</td><td>80m风向</td><td>80m风速(m/s)</td></tr>
<tr><Td><input type=text name=Release_Speed name1=排放流速  datatype='f' min=0></td>
<td><input type=text name=Chimney_Speed name1=烟囱流速  datatype='f' min=7 max=30 alert='t' /></td>
<td><select type=text name=Direction80M name1=80m风向  datatype='f' min=0>
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
</td>
<td><input type=text id=Speed80M name=Speed80M name1=80m风速  datatype='f' min=0 max=60 /></td>
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
<tr><FormItem:date datatype='date' text='开始排放时间' value='' /><td>排放流速(m<sup>3</sup>/h)：
<td><input type=text name1=排放流速 name=Release_Speed  datatype='f' min=0></td></tr>
</tr>
<tr><FormItem:date datatype='date' text='结束排放时间' value='' /><td>液位(m)：
<td><input type=text name1=液位 name=Release_liquid  datatype='f' min=-1></td></tr>
</tr>
</table>
<%} else {%>
<table border>
<col width=30%>
<col width=35%>

<tr><td>&nbsp;<td>时间
</td><td><%=cp.getParam("Release_liquid",sType,2)%></td></tr>
<tr><FormItem:date datatype='date' text='开始排放' value='' />
<td><input type=text name=Bucket_Pressure name1=开始排放<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' min=0></td></tr>
<tr><FormItem:date datatype='date' text='结束排放' value='' />
<td><input type=text name=Bucket_Pressure2 name1=结束排放<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' min=0></td></tr>
</table>
<%}%>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table><tr><td style='width:1'>备<br>注</td>
<td><textarea name="备注" datatype="s" max=255></textarea>
</td></tr></table>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table>
<col width=50%>
<tr><td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLeaseTrue />
<label for=EnablereLeaseTrue>结束排放</label></nobr></td>
<td><nobr>
<input style='width:17' type=radio name=bEnableRelease id=EnablereLeaseFalse /><label for=EnablereLeaseFalse>中断排放</label></nobr></td>
</tr></table>
</td></tr></table>
<script>button("提交||postForm()")</script>