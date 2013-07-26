//这个脚本建立了一个FormInputHandler类，用来格式化form中的用户输入元素
//并且检验输入数据的合法性
function FormInputHandler(name,oCallback,bgcolor,color)
{
	this.id=name
	eval("window."+name+"=this")	
	this._bgcolor=bgcolor==null?"#90ee90":bgcolor
	this._color=color==null?"black":color
	this._readonlycolor="black"
	this._readonlybackcolor="transparent"
	this.oCallback=oCallback
	this.arrayInputBox=[]
	this.iInputCount=0
}
FormInputHandler.prototype.setColor=function(e,flag)
{
	if(flag!=1)
	{
		e.bkbackgroundColor=e.style.backgroundColor
		e.bkcolor=e.style.color
		e.style.backgroundColor=this._bgcolor
		e.style.color=this._color
	} else {
		e.style.backgroundColor=e.bkbackgroundColor
		e.style.color=e.bkcolor
		e.title=""
		e.onfocus=null
	}
}
FormInputHandler.prototype.checkKey=function(o)
{	
	var k1=parseInt(o.iInputIndex)
	if(event.keyCode==13&&!isNaN(k1)&&k1<this.arrayInputBox.length-1)
	{
		o.blur()
		var o1=this.arrayInputBox[k1+1]
		o1.focus()
		o1.select()
	}
}
FormInputHandler.prototype.formatForm=function(o)
{		
	var oGroup=["INPUT","TEXTAREA"]
	var k=this.iInputCount
	for(var j=0;j<oGroup.length;j++)
	{
		var o1=o.all.tags(oGroup[j])
		for(var i=0;i<o1.length;i++)
		{
			if(o1[i].type!="text"&&j==0) continue			
			o1[i].enablecheck='t'	
			o1[i].onblur=Function(this.id+".TestInput(this)")
			if(o1[i].readOnly) {o1[i].style.backgroundColor=this._readonlybackcolor;continue}
			o1[i].iInputIndex=k
			if(j==0) o1[i].onkeyup=Function(this.id+".checkKey(this)")
			this.arrayInputBox[k]=o1[i]
			++k
		}	
	}	
	this.iInputCount=k
}

FormInputHandler.prototype.InitForm=function(oTarget)
{
	if(oTarget==null) oTarget=document
	if(typeof(oTarget)=="string") oTarget=document.all[oTarget]==null?document:document.all[oTarget].document	
	var ItemList=new Array("text","select","textbox","date")
	window.status=''
	var ik=this.iInputCount
	for(var j=0;j<ItemList.length;j++)
	{
		var tInput=oTarget.getElementsByTagName(ItemList[j])				
		var sItem=ItemList[j]
		for(var i=tInput.length-1;i>=0;i--)
		{						
			var item=tInput[i]
			if(item.scopeName!="FormItem") continue			
			var oParent=item.parentElement
			if(oParent.tagName!="TR") continue			
			var cell=document.createElement("TD")				
			var text=item.text
			var text1=text.replace(/(\([^\)]+\)|：)/g,"")
			item.removeAttribute("text")
			var readonly=item.readOnly			
			if(readonly!=null) {
				readonly=" style='background-color:"+this._readonlybackcolor+";color:"+this._readonlycolor+"'"
			}	
			else readonly=""
			var sInner=""
			var onbluraction=" onblur='"+this.id+".TestInput(this)' "
			switch(sItem)
			{
				case "text":					
					var o=document.createElement("<INPUT ID='"+text1+"' name='"+text1+"' enablecheck='t' class=FormText "+readonly+" style='width:100%' type=text value='"
						+(item.value==null?"":item.value)+"'"+onbluraction+"/>")
					o.mergeAttributes(item,true)
					if(!o.readOnly) {
						o.iInputIndex=ik
						o.onkeyup=this.id+".checkKey(this)"												
					}	
					cell.innerHTML=o.outerHTML
					if(!o.readOnly) {
						this.arrayInputBox[ik]=cell.all.tags("INPUT")[0]
						++ik
					}
					break
				case "textbox":
					cell.colSpan=4
					var o=document.createElement("<TEXTAREA ID='"+text1+"' name='"+text1+"' enablecheck='t' "
						+onbluraction.replace("previousSibling","parentElement.parentElement.parentElement.parentElement.previousSibling")
						+"style='overflow:auto;border:0;width:100%;height:98%'></TEXTAREA>")
					o.mergeAttributes(item,true)	
					o.value=item.value||item.innerHTML	
					if(!o.readOnly) {
						o.iInputIndex=ik
						
					}	
					cell.innerHTML="<TABLE style='width:100%;height:100%;border-collapse:collapse' cellpadding=0><TBODY>\n"
						+"<TR><TD style='width:1;tex-align:center' class='FormTextBoxTitle'>"+text+"</TD>\n"
						+"<TD class='FormTextBox'>"+o.outerHTML+"</TD>\n"
						+"</TR></TBODY></TABLE>"						
					if(!o.readOnly) {
						this.arrayInputBox[ik]=cell.all.tags('TEXTAREA')[0]
						++ik
					}
					break
				case "select":								
					var sInner=item.outerHTML.replace(/(<\?[^>]*>|FormItem\:)/ig,"")
					var sValue1=item.value
					if(sValue1!=null&&sValue1!="") {
						var res=eval("/(value\\s*=\\s*['\"]?"+sValue1+"['\"]?)/ig")
						sInner=sInner.replace(/selected/ig,"").replace(res,"$1 selected")
					}
					//item.outerHTML="<span style='border:1px solid #393;width:100%;height:18px;vertical-align:top;background-color:white'>"+sInner.replace("<select","<select id='"+text1+"' name='"+text1+"' style='margin:-2' IsSelectBox='t' "+readonly+" style='width:100%'")+"</span>"
					cell.innerHTML+=sInner.replace("<select","<select id='"+text1+"' name='"+text1+"' IsSelectBox='t' "+readonly+" style='width:100%'")
					break
				case "date":
					if(window.DateHandler==null) new oDateTime("DateHandler","DateObject")					
					var oDate=window.DateHandler
					cell.innerHTML+=oDate.make(text,item.disableHour==null?true:false,item.value,item.readOnly)
					if(readonly!="")
					{
						var group1=["SPAN","INPUT"]
						var v,j
						for(v=0;v<group1.length;v++)
						{
							var x=cell.getElementsByTagName(group1[v])
							for(j=0;j<x.length;j++)
							{
								x[j].style.color=this._readonlycolor
								x[j].style.backgroundColor=this._readonlybackcolor
								x[j].readonly=true
							}
						}
					}
					break					
			}
			oParent.replaceChild(cell,item)
			if(sItem!="textbox") {
				var cell=oParent.insertCell(cell.cellIndex)
				cell.innerHTML=text+"："
			}	
		}
	}
	this.iInputCount=ik
}

FormInputHandler.prototype.PostForm=function(e,oFun,oFunReturn,oLoader,bFlag)
{	
	if(oLoader==null)
	{
		if(window.wLoader==null) new WebLoader("wLoader")
		oLoader=window.wLoader
	}	
	oLoader.clearData()
	//检查下拉框
	var selectboxes=e.getElementsByTagName("SELECT")
	for(var i=0;i<selectboxes.length;i++)
	{		
		var box=selectboxes[i]
		var text=box.name		
		var value=box.options[box.selectedIndex].value
		if(value=="")
		{
			if(box.allownull=="f")
			{
				this.SendInfo("请您选择“"+(box.name1||text)+"”！",box)
				return false
			}
			continue
		}						
		oLoader.push(text,value.replace(/\s+selected/g,""))
	}
	//文本框
	var group=new Array("INPUT","TEXTAREA")
	for(var j=0;j<group.length;j++)
	{
		var ItemList=e.getElementsByTagName(group[j])
		for(var i=0;i<ItemList.length;i++)
		{
			var item=ItemList[i]
			if(item.enablecheck!='t') continue
			var sFun=item.onblur.toString().match(/\{[\w\W]*\}/)[0].replace(/[\s\{\}]+/g,"")
			sFun=sFun.replace(/this/g,"item").replace(")",",true)")
			if(eval(sFun)==false) return false
			var name=item.name			
			var value=item.value
			if(value.Trim()=="") continue			
			oLoader.push(name,value)		
		}
	}
	//日期
	var oDate=window.DateHandler
	var datebox=e.getElementsByTagName("TABLE")
	for(var i=0;i<datebox.length;i++)
	{
		var item=datebox[i]
		if(item.isDateBox!='t') continue
		var text=item.datemsg
		var s=oDate.CheckDate(item)
		if(typeof(s)!="string")
		{
			this.ErrorInput(item,"InputError","请填写正确完整的“"+text+"”的时间格式！",true)
			return false
		}
		oLoader.push(text,s)
	}
	if(typeof(oFun)=="function") if(oFun(this,oLoader.getDom())==false) return false
	var src=e.action
	if(src==null) {this.SendInfo("没有指定所要操作数据页面！");return false}
	if(bFlag==null&&!window.confirm("您填写的信息将会被提交，是否继续？")) return false	
	oLoader.load(oFunReturn,src,null,"提交数据")
}
FormInputHandler.prototype.DoInspect=function(text,sValue,sInputType,max,min,oInput,bFlag,suffix)
{
	var sMark=""
	var DoThrow=function(sInfo)
	{		
		sMark=sInfo
		throw("InputError")	
	}
	sInputType=sInputType.substring(0,1)
	if(sInputType=="f")
	{
		max=parseFloat(max)
		min=parseFloat(min)
	} else {
		max=parseInt(max)
		min=parseInt(min)
	}	
	switch(sInputType)
	{
		/*数字合法性检查*/
		case "i": /*Integer*/
		case "f": /*Float*/
			text1=text+"的值不能"
			var iLength=parseFloat(sValue)
			if(sInputType=="i") iLength=parseInt(iLength)
			try
			{
				if(sValue==""&&!isNaN(min)) DoThrow("请您填写"+text+"！")				
				if(!isNaN(min)&&(isNaN(iLength)||/^\-?\d+(\.\d*)?(e\-?\d+)?$/i.exec(sValue)==null)) 
				{
					if(sValue=="") DoThrow("请您填写"+text+"的值！")
					else DoThrow(text1+"是字符串，而是数字！")
				}	
				if(sValue==""&&isNaN(min)) return true				
				if(!isNaN(max)&&iLength>max) DoThrow(text1+"大于"+this.convertInt(max,2)+"！")
				if(!isNaN(min)&&(iLength<min||(iLength<=0&&m>=0))) DoThrow(text1+"小于"+min+"！")
			} 	
			catch(expt) {			
				var xs
				if(oInput.alert!=null) {
					if(oInput.alert=='t')
						xs="请确认"+text+"的值！"
					else
						xs=	oInput.alert
				}	
				else xs=sMark	
				return this.ErrorInput(oInput,expt,xs,bFlag)				
			}			
			if(iLength!=0)
			{
				var suf=parseInt(oInput.suf)				
				if(isNaN(suf)) suf=2							
				if(suffix!=false) {
					ox1=(""+iLength).split(".")
					if(ox1.length>1&&ox1[1].length>suf) ox1[1]=ox1[1].substring(0,suf)
					var sValue1=ox1.join(".")
					if(eval(sValue1)!=iLength) oInput.value=sValue1
				} else {
					var sValue1=this.convertInt(iLength,suf)	
					oInput.value=oInput.value.replace(sValue,sValue1)
				}	
			}	
			break
		/*字符串合法性检查*/	
		case "s":			
			var len=sValue.getLength()
			text1=text+"的长度["+len+"]不能"
			try
			{
				if(sValue==""&&!isNaN(min)) DoThrow("请您填写"+text+"！")
				if(!isNaN(max)&&len>max) DoThrow(text1+"大于"+max+"个字符！")
				if(!isNaN(min)&&len<min) DoThrow(text1+"小于"+min+"个字符！")					
			}	catch(expt) {
				return this.ErrorInput(oInput,expt,sMark,bFlag)				
			}
		default:break
	}
	return true
}
FormInputHandler.prototype.convertInt=function(iLength,suf,ox)
{
//将数字转换成科学计数法－胡方能
	var sLength=""+iLength
	if(iLength==0) return 0
	var sValue1,p
	if(iLength<1)
	{
		var a=/^0\.(0*[1-9])/.exec(sLength)
		if(a==null) return sLength
		p=a[1].length+1
		sLength=sLength.replace(".","")
		sValue1=sLength.substring(0,p).replace(/^0+/,"")
		if(sLength.length>p) sValue1+="."+sLength.substring(p)+"000"
		else sValue1+=".000"					
		p=-1*(p-1)
	} else {
		sLength=sLength.replace(/^0+/,"")
		a=/^(\d+)(\.\d+)?$/.exec(sLength)
		if(a==null) return sLength
		p=a[1].length
		if(p==1) 
		{
			sValue1=sLength
			if(a[2].length<2) sValue1+="."
			sValue1+="000";
			p=0
		} else {
			sLength=sLength.replace(".","")
			sValue1=sLength.substring(0,1)+"."+sLength.substring(1)+"000"
			--p
		}	
	}
	if(suf!=null) sValue1=sValue1.substring(0,suf+2)
	return (sValue1+"E"+p)
}
FormInputHandler.prototype.TestInput=function(oInput,bFlag)
{	
	var max=oInput.getAttribute("max")
	var min=oInput.getAttribute("min")
	var suffix=oInput.getAttribute("suffix")
	var text=oInput.name1
	if(text==null) text=oInput.name
	var sValue=oInput.value.Trim()
	oInput._bSuccess=false
	window.status=""
	if(bFlag!=true&&sValue=="") return
	var sInputType=(oInput.datatype||"string").toLowerCase()
	text="“"+text+"”"
	var bReturn=false	
	if(sInputType!="combine") 
	{
		bReturn=this.DoInspect(text,sValue,sInputType,max,min,oInput,bFlag,suffix)
		if(bReturn==false) return false
	}	else {
	/*组合类型*/
		//if(sValue==""&&isNaN(parseInt(oInput.min))) return true
		var sFormat=oInput.getAttribute("format1")
		if(typeof(sFormat)=="string"&&
			eval(sFormat).exec(sValue)==null
			&&sValue!=""
		) {this.SendInfo(text+'的格式错误！',oInput);return false}
		sFormat=oInput.getAttribute("format")
		if(typeof(sFormat)!="string") {
			this.SendInfo("combine类型必须指定format(string)属性！")
			return false
		}
		var ary1=sFormat.split("#")
		for(var i=0;i<ary1.length;i++)
		{
			if(ary1[i]=="") continue
			var ary2=ary1[i].split(":")
			var tValue=ary2[0].toLowerCase().Trim().substring(0,1)
			var max=null,min=null
			if(ary2.length>1) {
				max=ary2[1]
				if(ary2.length>2) min=ary2[2]
			}
			var s,s1
			if(tValue=="s")	
			{
				s=/^\D*[^\d\-]/.exec(sValue) /*如果是字符*/
				s1="字符"
			}	else {
				s=/^\-?\d+(\.\d*)?(e\-?\d+)?$/i.exec(sValue) /*如果是数字*/
				s1="数字"
			}	
			if(s!=null) s=s[0];
			else s=""			
			var __s2=text+"中的"+s1+"部分"
			if(sValue=="") __s2=text
			bReturn=this.DoInspect(__s2,s,tValue,max,min,oInput,bFlag,false)
			if(bReturn==false) return false
			sValue=sValue.replace(s,"")
		}
		if(sValue!="")
		{
			return this.ErrorInput(oInput,"InputError",text+"的输入值格式错误！",bFlag)
		}
	}
	var sChecker=oInput.oncheck
	if(typeof(sChecker)=="string")	
	{
		bReturn=this.ErrorInput(oInput,"InputError",eval(sChecker),bFlag)
		if(bReturn!=true) return false
	}	
	oInput._bSuccess=true
	return true
}
FormInputHandler.prototype.ErrorInput=function(oInput,expt,sMark,bFlag)
{
	if(typeof(sMark)=="boolean") return sMark
	else if(typeof(sMark)!="string"||sMark.Trim()=="") return true
	oInput._bSuccess=false
	if(expt.toString()!="InputError")
	{
		throw(expt)
		return false
	}	
	this.SendInfo(sMark,oInput)
	oInput.title=sMark		
	if(oInput.tagName!="TABLE") 
	{
		oInput.onfocus=Function(this.id+".setColor(this,1);")
		this.setColor(oInput)
	}	
	return false
}
FormInputHandler.prototype.SendInfo=function(sInfo,oInput)
{
	alert1(sInfo,oInput)
	
}
