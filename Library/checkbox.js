function setBox()
{
	var box=document.getElementsByTagName("box")
	for(var i=0;i<box.length;i++)
	{
		var attri=/<mpc:box([^>]*)>/ig.exec(box[i].outerHTML)[1]
		box[i].innerHTML="<font style='font-family:wingdings;display:none'>&#254</font>"
			+"<font style='font-family:wingdings'>&#111</font>"
			+"<input type='checkbox'"+attri+">"+box[i].innerHTML
		box[i].children(2).style.display="none"	
		if(box[i].id!=null) box[i].children(2).id="chk"+box[i].id
		resetBox(box[i])	
		var activecolor=box[i].getAttribute("onactive")	
		if(activecolor==null) {
			activecolor=box[i].style.onactive
			if(activecolor==null) activecolor=box[i].currentStyle.onactive
		}
		if(activecolor!=null) {
			activecolor=activecolor.replace(/["' ]*/ig,"").split(":")
			if(activecolor.length==1) activecolor[1]=""
			box[i].activecolor=activecolor
			var localcolor=new Array(box[i].style.color,box[i].style.backgroundColor)
			box[i].localcolor=localcolor
			box[i].onmouseover=function() 
			{
				this.style.color=this.activecolor[0];
				this.style.backgroundColor=this.activecolor[1];
			}
			box[i].onmouseout=function() 
			{
				this.style.color=this.localcolor[0]
				this.style.backgroundColor=this.localcolor[1]
			}
		}	
		box[i].style.cursor="default"
		box[i].tmponclick=box[i].onclick
		box[i].onclick=getCheck
		box[i].onselectstart=Function("return false")
		box[i].ondragstart=Function("return false")		
		box[i].check=checkBox
		var actionstyle
	}	
}
function checkBox(flag)
{
	if(flag!=true&&flag!=false) return
	this.children(2).checked=flag
	resetBox(this)
	if(this.tmponclick!=null) this.tmponclick(this)
}
function resetBox(obj)
{
	var flag
	with(obj)
	{
		var flag=children(2).checked
		if(flag==true)
		{
			children(0).style.display=""
			children(1).style.display="none"
		}	else	{
			children(1).style.display=""
			children(0).style.display="none"
		}		
	}
	obj.checked=flag
}
function getCheck()
{	
	with(this)
	{
		children(2).checked=(children(2).checked==true)?false:true		
	}	
	resetBox(this)
	if(this.tmponclick!=null) this.tmponclick(this)
	return true
}
LoadEvent("setBox()")