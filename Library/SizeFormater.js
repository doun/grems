//name����������������һ��ȫ�ֱ�����ʹָ֮�������Ķ���
//��new SizeAranger("Sizer")�൱��var Sizer=new SizeAranger()
//oFrame,frame,oDocumentָ�������window������������document����
//�������������������
function SizeAranger(name)
{
	this.id=name
	eval("window."+name+"=this")
	this.ArangerArray=[]
	SetEvent("window.onresize",name+".DoArange()",1000)
}

//��Ҫ��λ�Ķ������͸������
SizeAranger.prototype.push=function(e)
{
	this.ArangerArray[this.ArangerArray.length]=e
	this.DoArange(e)
}
//��λ
SizeAranger.prototype.DoArange=function(e)
{
	var ary
	if(e!=null) ary=new Array(e)
	else {ary=this.ArangerArray}
	try {
		var iWidth=document.body.offsetWidth
		var iHeight=document.body.offsetHeight
	} catch(e) {alert("�ĵ���δ��ȫ���룬�޷���λ��");return}
	for(var i=0;i<ary.length;i++)
	{
		var e1=ary[i]
		//����ö���û��sizeformat���ԣ���ô��continue
		//sizeformat�ĸ�ʽ��:"width:100%-20;height:30%"		
		var format=getAttribute(e1,"sizeformat",null)
		if(typeof(format)!="string") continue
		e1.style.position="absolute"
		format=format.replace(/\s+/ig,"").toLowerCase()
		var f1=format.split(";")
		for(var i=0;i<f1.length;i++)
		{
			var f2=f1[i].split(":")
			if(f2.length!=2) continue
			var name=f2[0]			
			var value=this.getLength(name,f2[1],iWidth,iHeight)+"px"
			try {
				e1.style[name]=value		
			} catch(ex) {continue}
		}
		//����ö���û��onresizeaction���ԣ���ô��continue
		//����ִ�иú���
		var action=getAttribute(e1,"onresizeaction",null)
		if(action!=null) 
		{
			var sType=typeof(action)
			if(sType=="function") e1.onresizeaction()
			else if(sType=="string") {
				e1.onresizeaction=Function(action)
				e1.onresizeaction()
			}
		}
	}
}
SizeAranger.prototype.getLength=function(name,value,iWidth,iHeight)
{
	var iFlag
	try {
		if(isNaN(iWidth=parseFloat(iWidth))) iWidth=document.body.offsetWidth
		if(isNaN(iHeight=parseFloat(iHeight))) iHeight=document.body.offsetHeight
	} catch(e) {alert("�ĵ���δ��ȫ���룬�޷�ȡֵ��");return -1}
	switch(name)
	{
		case "width":
		case "left":
		case "right":
			iFlag=iWidth
			break
		case "height":
		case "top":
		case "bottom":
			iFlag=iHeight
			break
		default:return -1
	}
	return eval(value.replace(/(\d+(\.\d*)?)\%/g,"(iFlag*$1/100)"))
}