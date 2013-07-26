	
	function NestResize()
	{	
		var iWidth=parseInt(2160/parseInt(this.style.width))
		var iHeight=parseInt(2160/parseInt(this.style.height))
		for(var i=this.children.length-1;i>=0;i--)
		{
			var oChild=this.children[i]
			try {
				if(oChild.scopeName.toLowerCase()!='v') continue
			} catch(e) {alert(i)}
			var action=oChild.onresizeaction
			if(action==null) continue
			if(typeof(action)=='string'&&action.Trim()!='')
			{
				action=new Function('iWidth','iHeight',action)
				oChild.onresizeaction=action
			}
			if(typeof(action)=='function') oChild.onresizeaction(iWidth,iHeight)
		}
	}	
	
	var ShapeTitleModel=document.createElement('<v:shape style="width:100%;height:12pt" \n'+
			'		coordsize="2160,2160" path="m@2,0qx0,@1,0,@5,2160,@5,2160,@1qy@3,0xe"\n'+
			'		adj="200"\n'+
			'		strokecolor="#ffd700"\n'+
			'	>\n'+
			'</v:shape>'
	)
	
	ShapeTitleModel.innerHTML='<v:path textboxrect="@2,0,@3,@0"/>\n'+
			'		<v:formulas>\n'+
			'			<v:f eqn="val 2160"/>\n'+
			'			<v:f eqn="val #0"/>\n'+
			'			<v:f eqn="prod 2160 5 pixelwidth"/>\n'+
			'			<v:f eqn="sum width 0 @2"/>	\n'+
			'			<v:f eqn="prod pixelheight 20 height"/>\n'+
			'			<v:f eqn="prod 2160 20 pixelheight"/>\n'+
			'		</v:formulas>\n'+
			'		<v:textbox inset="0,1.5pt,0,0" style="color:white;font:14px;\n'+
			'			text-align:center"><span id="region_shape_title" style="width:100%;height:100%;filter:dropshadow(color=darkgreen,OffX=-1,OffY=-1) shadow(color=#339933,direction=135)">@TitleinnerHTML</span></v:textbox>\n'+
			'		<v:fill type="gradient" color="#393" color2="white" />\n'			
			
	var RegionGroupModel=document.createElement('<v:group \n'+
			'	coordsize="2160,2160" \n'+
			'	style="position:relative;width:100%;height:100%">\n'+
			'</v:group>'	
	)
	
	RegionGroupModel.innerHTML='<v:roundrect arcsize="2000f"   style="width:2160;height:2160"\n'+
			'		strokecolor="#ffd700" fillcolor="#393" AllowInCell="True"\n'+
			'	>\n'+
			'		<v:textbox inset="0,13pt,0,0," id="ContentInnerHTML"></v:textbox>\n'+
			'	</v:roundrect>'	
			
	RegionGroupModel.appendChild(ShapeTitleModel)
	
	var sNest=CopyFunction(NestResize)
	/*建立一个包含标题的自定义区域*/
	function formatRegion()
	{			
		var Shapes=document.getElementsByTagName("region")		
		var iWidth=null,iHeight=null		
		for(var i=Shapes.length-1;i>=0;i--)
		{			
			var Shape=Shapes[i]	
		//	Shape.appendChild(RegionGroupModel.cloneNode(true))
		//	continue
			var bgcolor=getAttribute(Shape,"backgroundColor",null)
			var title=getAttribute(Shape,"title","Title")
			var o1=RegionGroupModel.cloneNode(true)			
			o1.all['region_shape_title'].innerHTML=title			
			o1.all['ContentInnerHTML'].innerHTML=Shape.innerHTML			
			//o1.style.cssText+=Shape.style.cssText			
			if(bgcolor!=null&&bgcolor!="transparent") o1.fillcolor=bgcolor
			if(Shape.sizeformat!=null) o1.sizeformat=shape.sizeformat				
			var onaction=Shape.onaction	
			Shape.innerHTML=""			
			Shape.appendChild(o1)
			if(onaction!=null)
			{
				if(typeof(onaction)=="function") sInner=onaction()
				else eval(onaction)
			}		
		}
	}
	/*
		重新初始化VML Shape，使之包含在一个Width以及Height
		精确固定(即非百分比)的DIV容器中,以减少不必要的CPU消耗
	*/	
	function InitShape()
	{		
		var aShapes=new Array("shape","roundrect","group","rect","container")
		for(var j=0;j<aShapes.length;j++)
		{
			var oVMLs=document.getElementsByTagName(aShapes[j])
			for(var i=0;i<oVMLs.length;i++)
			{
				if(oVMLs[i].sizeformat==null) continue				
				Sizer.push(oVMLs[i])
			}
		}
	}