
function ShowPage(str)
{
	var o=parent.wLoader.correctPage(2)	
	var sRan="SHOWDETAIL"+parseInt(10000*Math.random())
	if(parent.windowMSGDetail==null) parent.windowMSGDetail=[]
	parent.windowMSGDetail[parent.windowMSGDetail.length]=parent.open("",sRan,"resizable=1,scrollbars=0,toolbar=0,location=0,left=50,top=50,width=700,height=400")
	o.innerHTML+="<input type=hidden name='selectedRow' value='"+str+"'>"
			    +"<input type=hidden name='sID' value='"+parent.parent.document.all['__USER_ID'].value+"' />"	
	o.action="../Public/HandlePage.asp"
	o.target=sRan
	parent.document.body.onbeforeunload=function() 
	{		
		var oToClose=parent.windowMSGDetail
		for(var i=0;i<oToClose.length;i++)
		{
			try { oToClose[i].close() } catch(exp) {continue}
		}					
	}
	o.submit()
}

function window.onload()
{
	var oStyle=document.createStyleSheet()
	oStyle.addRule("#divMsg0","background-color:#EEC")
	oStyle.addRule("#divMsg1","background-color:lightblue")
	oStyle.addRule("#divMsg0 td","border-bottom:1px solid white")
	oStyle.addRule("#divMsg1 td","border-top:1px solid white")
	if(/list\.asp\?s\=app/i.exec(window.location.href)!=null)
	oStyle.addRule("#grid_record_msg","display:none")
	if(Grid.rows.length==0) return	
	var g=Grid.cloneNode(true),g0=g.cloneNode(true),g1=g.cloneNode(true)
	g0.id="GridD";g1.id="GridL"
	for(var i=g.rows.length-1;i>=0;i--)
	{
		var sStation=g.rows[i].cells[0].innerText.substring(0,1)
		if(sStation=='L') {
			g0.deleteRow(i)
			g1.rows[i].onmouseover='with(this.style) {backgroundColor="blue";color="white"}'
			g1.rows[i].onmouseout='with(this.style) {backgroundColor="";color=""}'			
		} else {
			g1.deleteRow(i)
			g0.rows[i].onmouseover='with(this.style) {backgroundColor="darkorange";color="white"}'
			g0.rows[i].onmouseout='with(this.style) {backgroundColor="";color=""}'	
		}
	}
	var f=function(iName)
	{
		var o=eval("g"+iName)
		if(o.rows.length==0)
		{
			o.style.height="100%"
			var td=o.insertRow().insertCell()
			td.style.textAlign="center"
			td.innerHTML="没有匹配的纪录。"
		}
	}
	f(0);f(1)
	var ot=document.createElement(
		"<TABLE style='width:100%;height:100%;border-collapse:collapse' cellpadding=0 id=tblConent></TABLE>"
	)
	otr=GridTitle.parentNode.parentNode
	var otr1=otr.cloneNode(true)
	otr.parentNode.removeChild(otr)
	var otd=document.createElement("TD")
	var sPub="color:white;font-size:13px;border:1px solid white;background-color:"
	otd.style.cssText="width:20;"+sPub+"#393;border-width:1 0 1 1;"
	otd.innerHTML="&nbsp;"
	otr1.insertAdjacentElement("afterBegin",otd)
	ot.appendChild(otr1)
	for(var i=0;i<=1;i++)
	{
		var ox=eval("g"+i)
		var otr=document.createElement("TR")		
		var otd=document.createElement("TD")
		otd.style.cssText=(i==0?"height:expression((tblConent.clientHeight-20)/2);":"")
			+sPub+(i==0?"darkorange":"blue")+";border-width:"+(i==0?"0 1 1 1":"0 1")
	
		otd.innerText=i==0?"一\n核":"二\n核"		
		
		otr.appendChild(otd)
		var otd=document.createElement("TD")
		
		otd.innerHTML="<DIV id='divMsg"+i+"' STYLE='width:100%;height:100%;overflow-x:hidden;overflow-y:auto'></DIV>"
		otd.children[0].appendChild(ox)
		otr.appendChild(otd)
		ot.appendChild(otr)
	}
	divGridMain.outerHTML=ot.outerHTML
}	
function setColor(o,flag)
{
	o.style.color=(flag==1)?"red":"black"
}