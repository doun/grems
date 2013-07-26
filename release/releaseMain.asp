<!--#include file="../Library/form.asp"-->
<!--#include file="../include/checkConflict.asp"-->
<%
	//检查排放冲突
	var cn=new Connection()
	var rs=cn.execRs("select isspecial_cfm from "+sDBOwner+".grems_status where id='"+sID+"'")
	var ipx=parseInt(rs(0))
	var sCurrentStatus=""+Request.Form("当前状态")
	var sMsg=null
	if(sCurrentStatus!="HLT") sMsg=CheckConflict(cn,sID,sType)	
	var sConflict=sMsg==null?"没":""
	var krt=cp.getParam("OKRT901MA",sType,2)
	
	if(sID.substring(0,1)=="L"&&sGroup=="LIQ") krt=krt.replace("904","902")
	//如果有排放冲突，那么检查在审批时是否已经指定可以强制排放
	
	if(sConflict==""&&ipx!=3&&ipx!=7) showErr(sMsg)		
	var sReturn="<font style='color:"+(sConflict==""?"red":"")+"'>"+sConflict+"有排放冲突</font>"
	rs.close()
	rs=null
	Erase(cn)
	var oMin=function(g) {if(g==null) g=0;return (sType=="LIQ"||sType=="GAS")?"":"min="+g}
	var def	
	
	
	function flow_speed(iCRF){
		//计算排放流速－胡方能 2004－6－3
		//iCRF 为CRF泵的台数
		/*计算公式为:
				Q1=7.4*D*1000/B总γ , Q2=740*D*1000/AH3  , Q=MIN（Q1，Q2，150）
				式中：Q：TER排放流量 m3/hr；
				D：申请栏中海水流量m3/hr；
				B总γ：分析栏中总γ浓度 Bq/m3
				AH3：分析栏中H3的浓度Bq/m3
				D＝76000×CRF，CRF是启动的CRF泵的台数
		*/
		var cn=new Connection()
		var rs=cn.execRs("select Tritium,Y from "+sDBOwner+".Grems_Scale where id='"+sID+"'")
		var D=76000*iCRF
	
		var re = /</g;                //Create regular expression pattern.
		var Tritium=(rs.fields("Tritium")+"").replace(re,"")
		var Y=(rs.fields("Y")+"").replace(re,"")
		var Q1=7.4*D*Y;
		var Q2=740*D*Tritium;
		var Q=150
		if(Q1<Q) Q=Q1;
		if(Q2<Q) Q=Q2;
		return iCRF*Q;
		rs.close()
		rs=null
		Erase(cn)
	}
	
	
	function convert_num(fNumber){
		//转化科学计数法的数据为浮点数
	
	}
%>
<STYLE>
	input {text-align:center}
</STYLE>
<script>
	var sConflict='<%=sConflict%>'
	var ipx=<%=ipx%>
	var krt="<%=krt%>".replace("可","不可")
	var iRsp,iRsp2,var1,var2,var3
	var lb_i=0
	
	if(sType=="TER"||sType=="TEG"||sType=="ETY")
	{
	

			if (parent.tblAnalyze.document.all['release_speed'][0]!=null) 
			{
				iRsp=parent.tblAnalyze.document.all['release_speed'][0].innerText
			}
		if (parent.tblAnalyze.document.all['release_speed'].innerText != null)
		{
			iRsp=parent.tblAnalyze.document.all['release_speed'].innerText   //  --------by lb
		}
		
		//iRsp=parent.tblAnalyze.document.all['release_speed'][0].innerText 胡方能修改
		//alert(parent.tblAnalyze.document.all['release_speed'][1].innerText)
		
		iRsp=toFloat(iRsp)	
		iRsp2=iRsp
		
		if(sType=="TER")
		{
			if(parent.LevelApply.document.all['排放渠海水流量'].innerText != null) 
				var1=parseInt(parent.LevelApply.document.all['排放渠海水流量'].innerText)
			var2=parseInt(parent.LevelApply.document.all['CRF泵投运台数'].innerText.replace(/[^\d]+/g,""))*76000
			//var1-=var2*76000
		} else {
		
			
			if (parent.tblAnalyze.document.all['chimney_speed'][0]!= null)
			{	
					
				var1=toFloat(parent.tblAnalyze.document.all['chimney_speed'][0].innerText)
			}
			else
			{
				
				var1=toFloat(parent.tblAnalyze.document.all['chimney_speed'].innerText)
			}
		}
	}	
	
	function toFloat(_s)
	{
		
		return parseFloat(_s.replace(/^[<≤=]{1,2}/g,""))
	}
	function checkRsp(_o)
	{
		if(_o.checked==false) {
			selWin(_o)
		} else {iRsp2=iRsp;排放流速.value=iRsp2}
		return true
	}
	function setCounter(iA,iB,iC)
	{
		iRsp2=(iRsp/var1)*(iA*3400+iB*4500+iC*76000)
		iRsp2=parseFloat((""+iRsp2).replace(/\.(\d){2,2}(\d+)/,".$1"))
		//alert(iRsp2)
		if(iRsp2>150) iRsp2=150
		//var _Value=parseFloat(toFloat(排放流速.value))
		排放流速.value=iRsp2
	}
	function oFun()
	{
		document.body.action="../release/releasePost.asp"
		oForm.formatForm(document.body)
		oForm.InitForm('document.body')		
	}
	
	
	
	
	function oAdd(oFormInst,dom,data)
	{
		reset()
		if(sType=="TER"||sType=="TEG"||sType=="ETY")
		{
			var _o=排放流速
			var _Value=toFloat(_o.value)
			var _r1="排放流速高于建议的排放流速("
			var _r2="m<sup>3</sup>/h)，您不能提交排放单！"
			if(sType!="TER") {
				var _v1=toFloat(烟囱流速.value)
				var lb_b= toFloat(parent.tblAnalyze.document.all['b'].innerText)
				iRsp2=oForm.convertInt((_v1*3600*7.056*40000)/lb_b,2)
				//iRsp2=oForm.convertInt((iRsp/var1)*_v1,2)
			}
			if(_Value>parseFloat(iRsp2)) {alert1(_r1+iRsp2+_r2,_o);return false}
		}
		var sux=""		
		if(document.all['开始排放']==null) sux="时间"		
		if(GetTime('开始排放'+sux)==null) return false
		
				var d2=document.all['开始排放时间']	
				var s1=parent._spConfirmDate
				
				if(s1==null) s1=parent._ConfirmDate
				
				var s1=new Date(s1.innerText.replace(/\-/g,"/"))
				
				var s=GetTime('开始排放'+sux)

				if(s==null) return false
				
				if(s-s1.getTime()<=0) {
					alert1("开始排放时间一定要晚于审批时间！",d2)
					return false
				}


		var d1=parent.document.all['tdReleaseInfo']
		if(d1!=null)
		{
			d1=d1.document.all['end_time']
			if(d1!=null)
			{
				var sFlag=0
				if(d1.outerHTML==null) {sFlag=d1.length-1;d1=d1[sFlag]}		
				d2=document.all['开始排放'+sux]	
				s1=new Date(d1.innerText.replace(/\-/g,"/"))
				 s=GetTime('开始排放'+sux)
				if(s==null) return false
				if(s-s1.getTime()<=0) {
					alert1("开始排放时间一定晚于上一次排放的结束时间！",d2)
					return false
				}
				//var s1=parent._spConfirmDate
				//if(s1==null) s1=parent._ConfirmDate
				//var s1=new Date(s1.innerText.replace(/\-/g,"/"))
				//if(s-s1.getTime()<=0) {
				//	alert1("开始排放时间一定晚于审批时间！",d2)
				//	return false
				//}
				if(sType!="TER")
				{
					var d1=parent.document.all['tdReleaseInfo'].document.all['bucket_pressure2']	
					if(sFlag!=0) d1=d1[sFlag]
					var d2=Bucket_Pressure
					//var s1=parseInt(d1.innerText)
					//var s2=parseInt(d2.value)
					var s1=parseFloat(d1.innerText)
					var s2=parseFloat(d2.value)
					
					//alert(s2)
					//alert(s1)
					
					if(!isNaN(s1)&&!isNaN(s2)&&s2>=s1
						//&&!confirm("本次的"+d2.name1+"不小于"+d2.name1.replace("开始","上一次的结束")+"，要继续么？")
						&&!confirm("本次的"+d2.name1+"大于"+d2.name1.replace("开始","上一次的结束")+"，要继续么？")
					)			
					return false
					
				}	
			}	
		}	
		if(sConflict==""&&!bunt("有排放冲突")) return false	
		wLoader.push("IPX",ipx)		
		wLoader.push("NO_CONFLECT",sConflict==""?"否":"是")
		if(!OKRT901MA.checked&&sType!="GAS"&&sType!="LIQ") 
		{
			if(ipx<5) {alert1(krt+"，您不能提交排放单。",OKRT901MA);return false}
			else if(!bunt(krt)) return false					
		}
		wLoader.push("OKRT901MA",(OKRT901MA.checked==true)?"是":"否")		
					
		if(sGroup=="GAS")
		{
			if(CONFIRM80M.checked!=true)
			{
				alert1("80米风速必须大于0.5m/s才能进行排放。",CONFIRM80M)
				return false
			}
			wLoader.push("CONFIRM80M","是")	
			if(parseFloat(Speed80M.value)<0.5)
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
	
		if(!confirm("请确认机组的状态,您确定么?")) return
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
<%if(sType=="TER") {%>
<td>
<table style='width:400' align="right" style='height:1;border:0;background-color:transparent;filter:'><tr><td>
SEC和CRF运行泵数无变化<input onclick='checkRsp(this)' type=checkbox id="WATERFLOW_NOCHANGE" value=1 checked style='width:15' >
</td>
<td>排放流速≤(m<sup>3</sup>/h)：
<td style='width:120'><input type=text name1=排放流速 id='排放流速' name=Release_Speed2  alert='t' datatype='f' <%=oMin()%> max=9e15></td>
</tr>
</table>
</td>

<%} else if(sGroup=="GAS") {%>
<TD>气象站80m风速>0.5m/s<input type=checkbox value='是' id='CONFIRM80M' style='width:15' >
</TABLE>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table style='border-collapse:collapse' border>
<tr><Td>排放流速(m<sup>3</sup>/h)</td><td>烟囱流速(m/s)</td><td>80m风向</td><td>80m风速(m/s)</td></tr>
<tr><Td><input type=text name=Release_Speed name1=排放流速 id='排放流速' alert='t' max=9e15 suf=5 datatype='f' <%=oMin()%>></td>
<td><input type=text name=Chimney_Speed name1=烟囱流速  id='烟囱流速' datatype='f' min=7 max=30 alert='t' /></td>
<td><select type=text name=Direction80M name1=80m风向  datatype='f' <%=oMin()%>>
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
<td><input type=text id=Speed80M name=Speed80M name1=80m风速  alert='t' datatype='f' min=0 max=60 /></td>
</tr>
<%}%>
</table>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<%if(sType=="TER") {%>
<table border>
<col width=16%>
<col width=24%>
<col width=18%>
<col width=12%>
<col width=15%>
<tr><FormItem:date datatype='date' text='开始排放时间' value='' /><td>实际排放流速(m<sup>3</sup>/h)：
<td><input type=text name1=实际排放流速 id='实际排放流速' name=Release_Speed  alert='t' datatype='f' <%=oMin()%> max=9e15></td>
<td>液位(m)：</td>
<td><input type=text name1=液位 name=Release_liquid  alert='t' datatype='f' <%=oMin(-1)%> max=20 ></td>
</tr>
</tr>
</table>
<%} else {%>
<table border>
<col width=30%>
<col width=35%>

<tr><td>&nbsp;<td>时间
</td><td><%=cp.getParam("Release_liquid",sType,2)%></td></tr>
<tr><FormItem:date datatype='date' text='开始排放' value='' />
<td><input type=text alert='t' name=Bucket_Pressure name1=开始排放<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' <%=sType=="ETY"?oMin(900):oMin(0)%> 
	max=<%=sGroup=="LIQ"?(sType=="SEL"?10:1e4):(sType=="ETY"?2000:7)%>></td></tr>
</table>
<%}%>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table><tr><td style='width:1'>备<br>注</td>
<td><textarea name="备注" datatype="s" max=255></textarea>
</td></tr></table>
</td></tr>
</table>
<script>button("提交||postForm()")
	if (this.document.all['排放流速'] !=null)
	{
		排放流速.value = iRsp2
	}
</script>