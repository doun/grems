function WebLoader(name,flag)
{	
	this._bCorrectPage=flag||false
	var oUsrInfo=this.correctPage()
	if(flag!=true&&oUsrInfo==null) return
	if(name!=null)
	{
		this.id=name
		eval("window."+name+"=this")
	}		
	this.xmlhttp=this.getActiveXObject("XMLHTTP")
	this.oStream=new ActiveXObject("ADODB.Stream")	
	this._domObject=this.getActiveXObject("DomDocument")
	this._domObject.async=false	
	var data=this._domObject.createElement("DATA")		
	var root=this._domObject.createElement("ROOT")		
	root.appendChild(data)
	if(typeof(oUsrInfo)!="boolean")	root.appendChild(oUsrInfo)		
	this._domObject.appendChild(root)
	/*
	var o=document.all['LoadingPage']
	if(o==null) 
	{	o=document.createElement("<IFRAME id='LoadingPage' src='../Public/Loader.htm' "+
			"style='border:0;visibility:hidden;position:absolute;z-index:99'></IFRAME>")		
		document.body.insertBefore(o)
	}
	this.LoadingObject=o
	*/
	this.setPosition()
	
	var o=document.getElementsByTagName("ERROR")
	if(o.length!=0)
	{
		o=o[0]
		var sHTML=o.innerHTML
		if(o.redirect=='t') window.location.href="../Public/message.asp?s="+escape(sHTML)
		else this.SendInfo(sHTML)
		return
	}
	var o=document.getElementsByTagName("ERROR")
	if(o.length!=0)
	{
		this.SendInfo(o[0].innerHTML)
	}	
}
WebLoader.prototype.getActiveXObject=function(sAOType)
{
	var servers=["MSXML2","Microsoft","MSXML","MSXML3"];
	var o;
	for(var i=0;i<servers.length;i++)
	{
		try {
			o=new ActiveXObject(servers[i]+"."+sAOType);
			return o;
		} catch(ex) {
			
		};		
	}	
	this.SendInfo("找不到XML解析器，请您确认是否已经安装了完整的IE6.0以上的浏览器！")
	throw new Error("找不到XML解析器，请您确认是否已经安装了完整的IE6.0以上的浏览器！");
}
WebLoader.prototype.correctPage=function(iFlag)
{	
	if(this._bCorrectPage==true) return true
	var oTop=window
	while(true)
	{
		if(oTop.opener==null||oTop.opener==window) break
		oTop=oTop.opener
	}
	oTop=oTop.parent
	while(oTop.globalUserInfo==null&&oTop!=window)	oTop=oTop.parent	
	var oUsrInfo=oTop.globalUserInfo
	if(oUsrInfo==null)
	{
		window.location.href="../Public/right.asp"
		return null
	}
	if(iFlag==null) return oUsrInfo.cloneNode(true)	
	else {
		var oFormNew=document.createElement("FORM")
		oFormNew.style.display='none'
		oFormNew.method="post"
		oFormNew.innerHTML=oTop.PostRight.innerHTML		
		if(iFlag==2)
		{
			oFormNew.id="frmDataPoster"
			document.body.insertAdjacentElement("beforeEnd",oFormNew)			
		}
		return oFormNew
	}
}
WebLoader.prototype.submitForm=function(oFrmSubmit)
{
	if(oFrmSubmit.nodeName!="FORM") return
	var oUsrInfo=this.correctPage(1)
	if(oUsrInfo==null) return
	if(typeof(oUsrInfo)!="boolean")
	{
		for(var i=0;i<oUsrInfo.children.length;i++)
		{
			oFrmSubmit.appendChild(oUsrInfo.children[i])
		}
	}
	oFrmSubmit.submit()
}
WebLoader.prototype.getDom=function()
{
	return this._domObject.firstChild.firstChild
}
WebLoader.prototype.getText=function(sName)
{
	var oNode=this._domObject.selectSingleNode(sName.toUpperCase())
	if(oNode==null) return null
	return oNode.text
}	
WebLoader.prototype.clearData=function()
{
	var data=this._domObject.createElement("DATA")
	var root=this._domObject.firstChild
	root.replaceChild(data,root.firstChild)
}
WebLoader.prototype.push=function(name,value)
{
	name=name.replace(/(^\s|\s$)*/g,"").match(/( |[^\0x00-0xff]|\w)*/)[0]
	var o=this._domObject.createElement(name.toUpperCase())
	o.text=value
	this._domObject.firstChild.firstChild.appendChild(o)
}
WebLoader.prototype.setPosition=function(e)
{
	return
	var iTop=0,iLeft=0
	if(e==null) e=document.body
	/*
	else {	
		while(true)
		{	
			if(e.tagName=="BODY") break;
			iTop=parseInt(e.offsetTop)
			if(iTop==0) e=e.parentNode
			else {
				iLeft=parseInt(e.offsetLeft);
				break;
			}
		}
		this.SendInfo(iTop)	
	}
	*/
	var w1=300
	var h1=90	
	var w=e.offsetWidth
	var h=e.offsetHeight		
	var l=(iLeft+w-w1)/2
	var t=(iTop+h-h1)/2
	with(this.LoadingObject.style)
	{
		left=l
		top=t
		width=w1
		height=h1
	}
} 
WebLoader.prototype.load=function(funCallback,src,mode,desc)
{
	if(typeof(funCallback)!="function") 
	{
		this.SendInfo("funCallback必须是一个函数！")
		return ""
	}
	/*
	this.LoadingObject.style.visibility="visible"
	if(this.LoadingObject.contentWindow.document.readyState=="complete") {
		if(desc==null||desc=="") desc="default"
		this.LoadingObject.contentWindow.setText(desc)
	}
	*/	
	this.Callback=funCallback	
	this.mode=(mode||"post").toLowerCase()
	this.xmlhttp.open("POST",src,true)
	this.xmlhttp.onreadystatechange=Function(this.id+".getResponse()")	
	this.xmlhttp.send(this._domObject)
	this.clearData()
	return ""
}
WebLoader.prototype.getResponse=function()
{
	if(this.xmlhttp.readyState==4)
	{
		//this.LoadingObject.style.visibility="hidden"
		if(this.xmlhttp.status!=200)
		{	
			var w=window.open("","_ERROR_WINDOW","scrollbars=1,toolbar=0,location=0,width=400,height=300")
			w.document.write(this.ConvertCharSet())	
			//var ErrMsg=this.ConvertCharSet().replace(/<[^>]*>/g,"").replace(/[\n\r]+/g,"\n")		
			//this.SendInfo(ErrMsg)
			return
		}
		var sText,sXML=this.xmlhttp.responseXML.xml
		var vReturn
		if(sXML!="") sText=sXML
		else sText=this.ConvertCharSet()
		var oDoc=new ActiveXObject("Microsoft.XMLDOM")
		oDoc.async=false
		if(/^<ERROR/.exec(sText)!=null)
		{
			oDoc.loadXML(sText)
			var oError=oDoc.firstChild
			if(oError.getAttribute('redirect')=='t')
			{
				window.location.href="../Public/message.asp?s="+escape(oError.text)
				return
			}
			this.SendInfo(oError.text)
			return
		}	
		if(/^<WARN/.exec(sText)!=null)
		{
			oDoc.loadXML(sText)
			this.SendInfo(oDoc.documentElement.firstChild.text)
		}			
		if(this.mode=="get")
			vReturn=sText
		else 
		{			
			oDoc.loadXML(sText)			
			if(oDoc.parseError.errorCode!=0)
			{
				this.SendInfo(oDoc.parseError.reason)
				return
			}	
			vReturn=oDoc					
		}
		this.Callback(vReturn)
		return true
	}	
}
WebLoader.prototype.ConvertCharSet=function()
{
	if(this.xmlhttp.responseText=="") return ""
	this.oStream.Type=1
	this.oStream.open()	
	this.oStream.Write(this.xmlhttp.responseBody)
	this.oStream.Position=0
	this.oStream.Type=2
	this.oStream.Charset="gb2312"
	text=this.oStream.ReadText()	
	this.oStream.close()
	return text
}
WebLoader.prototype.SendInfo=function(msg)
{
	//msg=msg.replace(/\n/g,"<br>").replace(" ","&nbsp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")
	alert(msg)
}