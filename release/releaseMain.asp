<!--#include file="../Library/form.asp"-->
<!--#include file="../include/checkConflict.asp"-->
<%
	//����ŷų�ͻ
	var cn=new Connection()
	var rs=cn.execRs("select isspecial_cfm from "+sDBOwner+".grems_status where id='"+sID+"'")
	var ipx=parseInt(rs(0))
	var sCurrentStatus=""+Request.Form("��ǰ״̬")
	var sMsg=null
	if(sCurrentStatus!="HLT") sMsg=CheckConflict(cn,sID,sType)	
	var sConflict=sMsg==null?"û":""
	var krt=cp.getParam("OKRT901MA",sType,2)
	
	if(sID.substring(0,1)=="L"&&sGroup=="LIQ") krt=krt.replace("904","902")
	//������ŷų�ͻ����ô���������ʱ�Ƿ��Ѿ�ָ������ǿ���ŷ�
	
	if(sConflict==""&&ipx!=3&&ipx!=7) showErr(sMsg)		
	var sReturn="<font style='color:"+(sConflict==""?"red":"")+"'>"+sConflict+"���ŷų�ͻ</font>"
	rs.close()
	rs=null
	Erase(cn)
	var oMin=function(g) {if(g==null) g=0;return (sType=="LIQ"||sType=="GAS")?"":"min="+g}
	var def	
	
	
	function flow_speed(iCRF){
		//�����ŷ����٣������� 2004��6��3
		//iCRF ΪCRF�õ�̨��
		/*���㹫ʽΪ:
				Q1=7.4*D*1000/B�ܦ� , Q2=740*D*1000/AH3  , Q=MIN��Q1��Q2��150��
				ʽ�У�Q��TER�ŷ����� m3/hr��
				D���������к�ˮ����m3/hr��
				B�ܦã����������ܦ�Ũ�� Bq/m3
				AH3����������H3��Ũ��Bq/m3
				D��76000��CRF��CRF��������CRF�õ�̨��
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
		//ת����ѧ������������Ϊ������
	
	}
%>
<STYLE>
	input {text-align:center}
</STYLE>
<script>
	var sConflict='<%=sConflict%>'
	var ipx=<%=ipx%>
	var krt="<%=krt%>".replace("��","����")
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
		
		//iRsp=parent.tblAnalyze.document.all['release_speed'][0].innerText �������޸�
		//alert(parent.tblAnalyze.document.all['release_speed'][1].innerText)
		
		iRsp=toFloat(iRsp)	
		iRsp2=iRsp
		
		if(sType=="TER")
		{
			if(parent.LevelApply.document.all['�ŷ�����ˮ����'].innerText != null) 
				var1=parseInt(parent.LevelApply.document.all['�ŷ�����ˮ����'].innerText)
			var2=parseInt(parent.LevelApply.document.all['CRF��Ͷ��̨��'].innerText.replace(/[^\d]+/g,""))*76000
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
		
		return parseFloat(_s.replace(/^[<��=]{1,2}/g,""))
	}
	function checkRsp(_o)
	{
		if(_o.checked==false) {
			selWin(_o)
		} else {iRsp2=iRsp;�ŷ�����.value=iRsp2}
		return true
	}
	function setCounter(iA,iB,iC)
	{
		iRsp2=(iRsp/var1)*(iA*3400+iB*4500+iC*76000)
		iRsp2=parseFloat((""+iRsp2).replace(/\.(\d){2,2}(\d+)/,".$1"))
		//alert(iRsp2)
		if(iRsp2>150) iRsp2=150
		//var _Value=parseFloat(toFloat(�ŷ�����.value))
		�ŷ�����.value=iRsp2
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
			var _o=�ŷ�����
			var _Value=toFloat(_o.value)
			var _r1="�ŷ����ٸ��ڽ�����ŷ�����("
			var _r2="m<sup>3</sup>/h)���������ύ�ŷŵ���"
			if(sType!="TER") {
				var _v1=toFloat(�̴�����.value)
				var lb_b= toFloat(parent.tblAnalyze.document.all['b'].innerText)
				iRsp2=oForm.convertInt((_v1*3600*7.056*40000)/lb_b,2)
				//iRsp2=oForm.convertInt((iRsp/var1)*_v1,2)
			}
			if(_Value>parseFloat(iRsp2)) {alert1(_r1+iRsp2+_r2,_o);return false}
		}
		var sux=""		
		if(document.all['��ʼ�ŷ�']==null) sux="ʱ��"		
		if(GetTime('��ʼ�ŷ�'+sux)==null) return false
		
				var d2=document.all['��ʼ�ŷ�ʱ��']	
				var s1=parent._spConfirmDate
				
				if(s1==null) s1=parent._ConfirmDate
				
				var s1=new Date(s1.innerText.replace(/\-/g,"/"))
				
				var s=GetTime('��ʼ�ŷ�'+sux)

				if(s==null) return false
				
				if(s-s1.getTime()<=0) {
					alert1("��ʼ�ŷ�ʱ��һ��Ҫ��������ʱ�䣡",d2)
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
				d2=document.all['��ʼ�ŷ�'+sux]	
				s1=new Date(d1.innerText.replace(/\-/g,"/"))
				 s=GetTime('��ʼ�ŷ�'+sux)
				if(s==null) return false
				if(s-s1.getTime()<=0) {
					alert1("��ʼ�ŷ�ʱ��һ��������һ���ŷŵĽ���ʱ�䣡",d2)
					return false
				}
				//var s1=parent._spConfirmDate
				//if(s1==null) s1=parent._ConfirmDate
				//var s1=new Date(s1.innerText.replace(/\-/g,"/"))
				//if(s-s1.getTime()<=0) {
				//	alert1("��ʼ�ŷ�ʱ��һ����������ʱ�䣡",d2)
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
						//&&!confirm("���ε�"+d2.name1+"��С��"+d2.name1.replace("��ʼ","��һ�εĽ���")+"��Ҫ����ô��")
						&&!confirm("���ε�"+d2.name1+"����"+d2.name1.replace("��ʼ","��һ�εĽ���")+"��Ҫ����ô��")
					)			
					return false
					
				}	
			}	
		}	
		if(sConflict==""&&!bunt("���ŷų�ͻ")) return false	
		wLoader.push("IPX",ipx)		
		wLoader.push("NO_CONFLECT",sConflict==""?"��":"��")
		if(!OKRT901MA.checked&&sType!="GAS"&&sType!="LIQ") 
		{
			if(ipx<5) {alert1(krt+"���������ύ�ŷŵ���",OKRT901MA);return false}
			else if(!bunt(krt)) return false					
		}
		wLoader.push("OKRT901MA",(OKRT901MA.checked==true)?"��":"��")		
					
		if(sGroup=="GAS")
		{
			if(CONFIRM80M.checked!=true)
			{
				alert1("80�׷��ٱ������0.5m/s���ܽ����ŷš�",CONFIRM80M)
				return false
			}
			wLoader.push("CONFIRM80M","��")	
			if(parseFloat(Speed80M.value)<0.5)
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
	
		if(!confirm("��ȷ�ϻ����״̬,��ȷ��ô?")) return
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
<%if(sType=="TER") {%>
<td>
<table style='width:400' align="right" style='height:1;border:0;background-color:transparent;filter:'><tr><td>
SEC��CRF���б����ޱ仯<input onclick='checkRsp(this)' type=checkbox id="WATERFLOW_NOCHANGE" value=1 checked style='width:15' >
</td>
<td>�ŷ����١�(m<sup>3</sup>/h)��
<td style='width:120'><input type=text name1=�ŷ����� id='�ŷ�����' name=Release_Speed2  alert='t' datatype='f' <%=oMin()%> max=9e15></td>
</tr>
</table>
</td>

<%} else if(sGroup=="GAS") {%>
<TD>����վ80m����>0.5m/s<input type=checkbox value='��' id='CONFIRM80M' style='width:15' >
</TABLE>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table style='border-collapse:collapse' border>
<tr><Td>�ŷ�����(m<sup>3</sup>/h)</td><td>�̴�����(m/s)</td><td>80m����</td><td>80m����(m/s)</td></tr>
<tr><Td><input type=text name=Release_Speed name1=�ŷ����� id='�ŷ�����' alert='t' max=9e15 suf=5 datatype='f' <%=oMin()%>></td>
<td><input type=text name=Chimney_Speed name1=�̴�����  id='�̴�����' datatype='f' min=7 max=30 alert='t' /></td>
<td><select type=text name=Direction80M name1=80m����  datatype='f' <%=oMin()%>>
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
<td><input type=text id=Speed80M name=Speed80M name1=80m����  alert='t' datatype='f' min=0 max=60 /></td>
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
<tr><FormItem:date datatype='date' text='��ʼ�ŷ�ʱ��' value='' /><td>ʵ���ŷ�����(m<sup>3</sup>/h)��
<td><input type=text name1=ʵ���ŷ����� id='ʵ���ŷ�����' name=Release_Speed  alert='t' datatype='f' <%=oMin()%> max=9e15></td>
<td>Һλ(m)��</td>
<td><input type=text name1=Һλ name=Release_liquid  alert='t' datatype='f' <%=oMin(-1)%> max=20 ></td>
</tr>
</tr>
</table>
<%} else {%>
<table border>
<col width=30%>
<col width=35%>

<tr><td>&nbsp;<td>ʱ��
</td><td><%=cp.getParam("Release_liquid",sType,2)%></td></tr>
<tr><FormItem:date datatype='date' text='��ʼ�ŷ�' value='' />
<td><input type=text alert='t' name=Bucket_Pressure name1=��ʼ�ŷ�<%=cp.getParam("Release_liquid",sType,1)%> datatype='f' <%=sType=="ETY"?oMin(900):oMin(0)%> 
	max=<%=sGroup=="LIQ"?(sType=="SEL"?10:1e4):(sType=="ETY"?2000:7)%>></td></tr>
</table>
<%}%>
</td></tr>
<tr><td style='height:5;border:0'></td></tr>
<tr><td style='height:1;border:0'>
<table><tr><td style='width:1'>��<br>ע</td>
<td><textarea name="��ע" datatype="s" max=255></textarea>
</td></tr></table>
</td></tr>
</table>
<script>button("�ύ||postForm()")
	if (this.document.all['�ŷ�����'] !=null)
	{
		�ŷ�����.value = iRsp2
	}
</script>