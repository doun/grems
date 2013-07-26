<%
	Response.ContentType="text/x-component"
	Response.Expires=3600
%>
<PUBLIC:COMPONENT tagName="TBL"> 
<PUBLIC:ATTACH onevent="DoActivate(1)" event="onmouseover"/> 
<PUBLIC:ATTACH onevent="DoActivate(0)" event="onmouseout"/> 
<PUBLIC:ATTACH onevent="show()" event="onmousedown"/> 
<PUBLIC:ATTACH onevent="release()" event="onselectstart"/>
<PUBLIC:ATTACH onevent="InitGrid()" event="oncontentready"/>
<PUBLIC:PROPERTY NAME="Sort" PUT="DoSort"/>
<PUBLIC:PROPERTY NAME="Offset"/>
<PUBLIC:PROPERTY NAME="Heading" PUT="ResetGrid"/>
<PUBLIC:PROPERTY NAME="FocusStyle"/>
<PUBLIC:PROPERTY NAME="ActiveStyle"/>	
<PUBLIC:PROPERTY NAME="GridStyle" PUT="SetGridStyle"/>
<PUBLIC:METHOD NAME="show" />
<PUBLIC:METHOD NAME="InitGrid" />
<PUBLIC:METHOD Name="SetStyleWithoutSort" />
<PUBLIC:METHOD Name="ResetProperty" />
<script language="JScript">		
	/*2002.11.10--2002.11.20,At GNPJVC*/
	/*--文件列表模板之三，可以单独使用。--*/
	/*--当某个TABLE的Behavior指向这里时,必须注意：
		1、除了THEAD和TFOOT的CELLS外，别的CELLS不能非常规，我在这里指的非常规是：
			某一行的第X列有ROWSPAN，或者部分行的第X列有COLSPAN，但是其它行的第X列又没有COLSPAN
			这虽然不会出错，但是可能导致排序失效
		2、TABLE要一次性写入。如果你在ASP脚本中写入TABLE时，不停的用response.write，
			那么也许只写一部分的时候，页面上该TABLE就已经触发了oncontentready事件。但是也有处理方法。
			a、就是把Public InitGrid()，去掉oncontentready事件的触发，但是这样你必须手动执行
				InitGrid()函数
			b、一次性写入。我们知道，在asp中用vbs进行循环时，最好不用类如下面的格式：
				do while not rs.eof
					x=x&"a"&rs(0)&.....	
					......
					rs.movenext
				loop
				即连后赋值，具体原因太长，我不说了。
				js可以这样解决：x+="a"+rs(0)...；vbs呢，就这样：
				sub combine_string(byref msg,to_string)
					msg=msg&to_string
				end sub
				combine_string x,"a"&rs(0)...，
				或者直接使用rs.getString和rs.getRows方法
		文件列表的分页不在这个模板进行，因为客户端的页面一般情况下只有一页，如果要看其他页的纪录，
			那么需要向服务器提出请求。对于排序，如果不分页或者总页数只有1，那么只需要设置Sort属性来
			在客户端排序；否则必须向服务器提出请求以重新生成TABLE
	*/
	/*
	如果操作出错，我们不用alert提醒出错，只作忽略或者操作失效处理
	
	公共属性及方法说明：
		在页面中设置/调用属性的时候，其属性忽略大小写
		Sort：字符串，只写，当设置这个属性的时候，将进行排序操作。其值的格式见DoSort函数
		element.Offset：数字，读/写。偏移量，例如，当element.Offset=1,Sort='1 DESC'时，原来是将第一列逆序排列，现在变成第二列逆序，可以为负值
		element.FocusStyle：字符串，当使某列获得焦点(onclick)的时候，该列的显示格式，如果没有设置该属性，那么就会使用默认的格式
			举个例子："backgroundColor:#333;color:red"，那么该列获得焦点的时候，其背景色为#333,字体颜色为red
			请注意：如无特别需要，不要在页面中设置该Table的cells(TD、TH)的颜色和背景色
			如果该属性是数字，那么只是纯粹地触发指定的函数，而不改变颜色设置
		element.ActiveStyle：字符串，读/写。当这个属性不为空时，将在发生onmouseover和onmouseout的行上触发函数
			其格式跟element.FocusStyle一样
		element.GridStyle：字符串，如FocusStyle，只写。设置TABLE的runtimeStyle以求增/改其默认设置
		show(index)：相当于触发点击第几列，如果有THEAD，那么TBODY的第一列的Index值为1，否则为0
		InitGrid()：重新初始化TABLE
		Heading:设置表的TITLE行(TR对象)，其目的是为了使标题区不随内容区滚动
	*/
	/*	
	currentStyle,style和runtimeStyle的说明：
		currentStyle：定义在页面的<STYLE>和<REL..>标签中
		style：定义在指定元素的style属性中
		runtimeStyle：用户在脚本中定义，也可以在<REL..>中定义
		一般情况下，都是后者覆盖前者，即：runtimeStyle->style->currentStyle
		但是也有例外。覆盖指的是显示覆盖，而不是值覆盖
	如何把一个元素的某个Style属性设为继承(Inherit)：
		改变style的时候，不要修改合并属性。举个例子：
			如果某个元素的[element].currentStyle.border="1px solid red"，border为合并属性
			那么如果我设置[element].style.border="1px inset green"，再设置[element].style.border=""，
			那么就无法继承currentStyle.border(即"1px solid red")属性，而是采用CSS的默认设置（即border=0）。
			解决的办法是
			with([element].style)
			{
				borderStyle="inset"
				borderColor="green"
			}
			要继承回其currentStyle.border属性，就：
			with([element].style)
			{
				borderStyle=""
				borderColor=""
			}			
	*/
	//element.SelectedRow用于储存有焦点的列的指针
	var SelectedRow="",StartRow,EndRow,Len,SortCell=null,GridHead=null
	//去掉字符串两边的空格
	String.prototype.Trim=new Function("return this.replace(/^([ 　\t]+)|([ 　\t]+)$/g,'')")
	with(runtimeStyle)
	{
		borderCollapse="collapse"
		tableLayout="auto"
		wordBreak="keep-all"
		fontSize="12px"
		width="100%"
		cursor="default"
		height=1
	}
	function InitGrid()
	{
		element.setAttribute("cellPadding","0")
		attachEvent("onkeydown",PasteRow)
		with(element.runtimeStyle)
		{
			borderCollapse="collapse"
			tableLayout="auto"
			wordBreak="keep-all"
			fontSize="12px"
			width="100%"
			cursor="default"
			height=1
		}
		ResetGrid()
		ResetProperty()
	}	
	function GetProperty(txt)
	{
		var TargetStyle=eval("element."+txt)
		if(TargetStyle==null)
		TargetStyle=element.runtimeStyle[txt]
		if(TargetStyle==null)
		TargetStyle=element.style[txt]
		if(TargetStyle==null)
		TargetStyle=element.currentStyle[txt]
		if(TargetStyle==null) return
		TargetStyle=TargetStyle.replace(/(')*/gi,"")
		eval("element."+txt+"=TargetStyle")
	}
	function ResetProperty()
	{
		GetProperty("FocusStyle")
		GetProperty("GridStyle")
		GetProperty("ActiveStyle")
		GetProperty("Heading")
	}
	function SetGridStyle(the_style)
	{
		if(the_style!=null)
		try
		{
			SetStyle(element,the_style)
		}
		catch(Exception)
		{
			alert("无效的 GridStyle["+the_style+"] 属性！")
			return
		}
	}
	//在tHead或者tFoot部分产生onmouseover和onmouseout事件时触发该函数
	function Title_Activate(flag,e)
	{
		if(element.GridHead==null) return
		var isInner=0		
		if(e==null) 
		{
			try
			{
				if(element.GridHead.BelongTo!=null)
					e=eval(element.GridHead.BelongTo+".event.srcElement")
				else
					e=event.srcElement
			} 
			catch(exp)
			{
				alert("表的标题行(TagName=TR)不在当前窗口中，并且您没有给它设置BelongTo属性！")	
				return
			}		
		}	
		else isInner=1
		if(e==null) return
		var e1=e
		e=GetParentByTag(e,"TD",1)
		if(e==0||!element.GridHead.contains(e)) e=GetParentByTag(e1,"TH",1)
		if(e==0||!element.GridHead.contains(e)) return
		//当e的cellIndex等于sortIndex时，不进行任何操作
		if((e==element.SortCell||e==element.tmpCol)&&isInner==0) return
		//当flag==0时是onmouseout，是1时是onmouseover
		//触发title_activate_action(flag)函数
		if(typeof(title_activate_action)=="function")
		title_activate_action(e,flag)
	}
	//初始化
	function ResetGrid(Heading)
	{
		var trs=element.rows
		element.Len=trs.length
		element.StartRow=0
		element.EndRow=element.Len-1
		//滤掉THEAD部分
		if(element.tHead)
		{
			for(element.StartRow=0;element.StartRow<element.Len;element.StartRow++)
			{
				if(GetParentByTag(trs[element.StartRow],"THEAD")==0) break
			}
		}
		if(Heading!=null) 
		{			
			SetHeading(Heading)	
		}
		else if(element.StartRow==1) element.GridHead=element.rows[0]
		if(element.GridHead!=null)
		{
			element.GridHead.onmouseover=Function("Title_Activate(1)")
			element.GridHead.onmouseout=Function("Title_Activate(0)")
			element.GridHead.onselectstart=new Function("return false")
		}
		//滤掉TFOOT部分
		if(element.tFoot)
		{
			element.tFoot.onmouseover=Function("Title_Activate(1)")
			element.tFoot.onmouseout=Function("Title_Activate(0)")
			element.tFoot.onselectstart=new Function("return false")
			for(element.EndRow=element.Len-1;element.EndRow>element.StartRow;element.EndRow--)
			{
				if(GetParentByTag(trs[element.EndRow],"TFOOT")==0) break
			}
		}	
		element.Len-=element.StartRow+(element.Len-1-element.EndRow)
	}
	function SetHeading(Heads)
	{
		var HeadOffset
		if(element.rows.length<1||element.EndRow<0) return
		var trs=element.rows[element.StartRow]
		try
		{
			var Heading=eval(Heads)
			if(Heading.tagName!="TR") return
			Heading.runtimeStyle.height=1
			element.GridHead=Heading
			HeadOffset=element.GridHead.offset
			if(HeadOffset==null) HeadOffset=0			
			else HeadOffset=parseInt(HeadOffset)
			element.GridHead.onmousedown=Function("show()")			
			var lenx=element.GridHead.cells.length
			var k=0
			for(var i=0;i<lenx;i++)
			{
				if(i>trs.length-1) break
				if(i<lenx-1)
				{
					var rowspan=parseInt(element.GridHead.cells(i).cellspan)
					if(isNaN(rowspan)) rowspan=1
					var celllength=0
					for(var j=1;j<=rowspan;j++)
					{
						celllength+=trs.cells(k).clientWidth+HeadOffset
						k++						
					}
					if(celllength>HeadOffset)
					{
						element.GridHead.cells(i).width=celllength
					}	
					element.GridHead.cells(i).nowrap=true
				}	
				if(element.GridHead.cells(i).IsSorting==true)
				{
					Title_Activate(0,element.GridHead.cells(i))
					if(typeof(show_sort_action)=="function") show_sort_action(element.GridHead.cells(i))
				}
			}
			if(typeof(onend)=="function") onend(element)
		}
		catch(Exp)
		{
			alert("错误的Heading["+Heads+"]属性或者载入onend(element)函数出错！")
			return
		}
		
	}
	//不允许选择(SELECT)
	function release()
	{
		event.returnValue=false	
	}
	//捕获↑和↓键，前者为纪录上移，后者为记录下移
	function PasteRow()
	{
		var code=event.keyCode
		if(code!=38&&code!=40) return true
		var index
		try 
		{
			index=(code==38)?(element.SelectedRow.rowIndex-1):(element.SelectedRow.rowIndex+1)
		} catch(e) {index=1}
		element.show(index)
	}
	function SetStyleWithoutSort(SortString)
	{
		if(SortString==null) return
		try {
			var cbs=SortString.split(" ")			
			if(isNaN(parseInt(cbs[0]))) return				
			targetcol=parseInt(cbs[0])-1
			if(element.GridHead!=null)
			{
				var len=element.GridHead.cells.length
				var col
				for(var i=0;i<len;i++)
				{
					col=element.GridHead.cells[i]
					if(col.DisableSort=="true") {++targetcol;continue}
					if(i==targetcol) break
					if(i==len-1) return
				}				
				var flag
				if(cbs.length==1||cbs[1]=="ASC") flag="ASC"
				else flag="DESC"
				col.setAttribute("CellSort",flag)
				//GridHead为空时，SortCell为数字，用以保存上一个SortCell的cellIndex
				show_sort_action(null,col,flag)
				element.SortCell=col
			}	
		} catch(Exceptions) {}	
	}
	//排序，曾经尝试用XSL排序，不成功，因为使用XML受到IE浏览版本的限制,这里我也没有考虑Nescape
	function DoSort(col)
	{
		//COL的字符串格式为：NUMBER+" "+"ASC/DESC"，NUMBER指的是第几列，第一列的NUMBER为1,而不是0，例如：1 ASC
		var flag,T,TimeCost
		var tmpcol=col.split(" ")
		if(element.IsSorting==true) return
		element.IsSorting=true
		var tmprow=element.GridHead
		if(element.SortCell!=null) 	Title_Activate(0,element.SortCell)
		if(tmprow!=null&&typeof(show_sort_action)=="function") 
		{
			var tmpCol=tmprow.cells(parseInt(tmpcol[0])-1)
			Title_Activate(0,tmpCol)
			show_sort_action(element.SortCell,tmpCol,tmpcol[1].toUpperCase())
			element.tmpCol=tmpCol
		}
		if(tmprow!=null&&tmprow.cells(parseInt(tmpcol[0])-1).DisableSort!='true')
		{			
			var j=0
			for(var i=0;i<parseInt(tmpcol[0]);i++)
			{
				if(tmprow.cells(i).DisableSort=='true') {continue}
				++j
			}
			tmpcol[0]=""+j
			if(typeof(onbeforesort)=="function"&&onbeforesort(element.SortCell,tmpcol.join(" "))==0) return
		}
		element.IsSorting=false	
		//测试排序需要的时间
		T=new Date().getTime()
		col=col.split(" ")
		//ASC为降序排列，DESC为逆序
		if(col.length!=2)
		{
			flag=-1
		} else {
			if(col[1].toUpperCase()=="ASC") flag=1
			else flag=-1
		}
		col=parseInt(col[0])
		if(isNaN(col)) 
		{
			//alert("无效的Sort属性，正确格式为'[Number] [ASC/DESC]'！")
			return
		}
		col-=1
		if(!isNaN(parseInt(element.Offset))) col+=parseInt(element.Offset)
		//以下不需要加Alert，只作操作失效处理
		//行数<1
		if(element.Len<1) return 
		//如果是非常规排序(比如某些CELL是跨列[COLSPAN>1]或者跨行[ROWSPAN>1]，那么排序可能失效)
		try
		{
			var start=new Date
			sort_table(element,col,(flag==1)?true:false)		
			window.status = " (Time spent: " + (new Date - start) + "ms)";		
			/*
				排序完之后，触发show_sort_action函数。
				flag：返回ASC或者DESC，表示是升序还是降序排列
				SortIndex：原来排序的列的cellIndex
				col：新排序的列的cellIndex
				其中，一个表的第一列的cellIndex值为0
			*/			
			if(!isNaN(parseInt(element.Offset))) col-=element.Offset
			if(typeof(show_sort_action)=="function")
			{
				//注意：这个函数必须返回一个cell[TD/TH]，因为THEAD区可能是一个TABLE而不是单单一行
				//如果不返回值，那么默认判断
				if(element.GridHead==null)
				{
					//GridHead为空时，SortCell为数字，用以保存上一个SortCell的cellIndex
					//show_sort_action(element.SortCell,col,(flag==1)?"ASC":"DESC")
					element.SortCell=col
				}	else	{				
					//否则SortCell为一个TD元素或者TH元素
					if(element.SortCell!=null)
					{
						element.SortCell.IsSorting=false
						//这时把原来排列的列设成inActivate
						//Title_Activate(0,element.SortCell)
					}		
					for(var i=0;i<element.GridHead.cells.length;i++)
					{
						if(parseInt(element.GridHead.cells(i).col)==col+1)
						{
							col=element.GridHead.cells(i)
							break
						}						
					}
					if(typeof(col)=="number") col=element.GridHead.cells(col)
					//show_sort_action(element.SortCell,col,(flag==1)?"ASC":"DESC")
					element.SortCell=col
				}	
				//Title_Activate(1,element.SortCell)	
				element.SortCell.IsSorting=true
			}
		} catch(Exception) {}
		//测试完毕
		TimeCost=new Date().getTime()-T
	//	alert(TimeCost)
	}
	//当点击一个行时，显示的信息
	function show(obj)
	{
		//如果OBJ是null,那么判断event.srcElement是否属于该TABLE，如果不是,return
		if(obj==null)
		{
			var e,ev
			ev=event
			if(ev==null)
			{
				try
				{	
					ev=eval(element.GridHead.BelongTo+".event")
				} 
				catch(exp)
				{
					alert("表的标题行(TagName=TR)不在当前窗口中，并且您没有给它设置BelongTo属性！")	
					return
				}	
			}		
			e=ev.srcElement
			if(ev.button!=1||e==null) return			
			var e1=e
			obj=GetParentByTag(e,null,1)
			//滤掉TFOOT区
			if(obj==0||(element.contains(obj)&&obj.rowIndex>element.EndRow)) return
			//如果点击的是THEAD部分，那么将进行排序
			if(element.GridHead!=null&&element.GridHead.contains(obj))
			{
				e=GetParentByTag(e1,"TD",1)
				if(e==0||!element.GridHead.contains(e)) 
				{
					e=GetParentByTag(e1,"TH",1)
					if(e==0||!element.GridHead.contains(e)) return
				}
				var col=e.cellIndex+1
				if(e.col) col=parseInt(e.col)
				if(e.CellSort!="ASC") e.setAttribute("CellSort","ASC")
				else e.setAttribute("CellSort","DESC")
				DoSort(""+col+" "+e.CellSort)
				return
			}
		}
		//如果obj是数字，那么提取rowIndex=obj的列
		else if(typeof(obj)=="number")
		{						
			if(element.rows.length-1<obj||obj<0) return
			obj=element.rows[obj]
			if(obj==null||obj.rowIndex>element.EndRow||obj.rowIndex<element.StartRow) return
		//	obj.scrollIntoView()
		}
		//如果obj本身已经有焦点，那么中止执行
		//if(obj==element.SelectedRow) return
		try
		{
			//让原来有焦点的列失去焦点(backgroundColor和color变成inherit，不改变TR原有的Style)
			with(element.SelectedRow.runtimeStyle)
			{
				backgroundColor=""
				color=""
			}
			//如果页面中存在show_blur_action函数，那么将把这个函数作为obj失去焦点的触发事件
			if(typeof(show_blur_action)=="function")
			show_blur_action(element.SelectedRow)
			element.SelectedRow=""
		} catch(e) {}
		if(obj=="none")
		{
			//如果obj="none"，那么只执行到此；如果这时页面中存在show_none_action函数，
			//那么触发该函数
			if(typeof(show_none_action)=="function")
			show_none_action()
			return
		}	
		element.SelectedRow=obj			
		if(element.FocusStyle==null)
		{
			with(element.SelectedRow.runtimeStyle)
			{
				backgroundColor="gray"
				color="white"
			}
		}	else  {		
			try
			{
				SetStyle(element.SelectedRow,element.FocusStyle)
			}
			catch(Exception)
			{
				alert("无效的 element.FocusStyle["+element.FocusStyle+"] 属性！")
				return
			}
		}				
		//当指定的列获得焦点后触发指定的函数，下面这两个函数看上去好像重复，但我都有在用
		//可以根据需要决定是否删除showdetail()这个函数
		if(typeof(showdetail)=="function") showdetail()		
		if(typeof(show_detail_action)=="function") show_detail_action(element.SelectedRow)		
	}
	//对FocusStyle和ActiveStyle进行解释
	function SetStyle(Src,TheStyle)
	{
		var target,value	
		if(typeof(TheStyle)=="number") return
		var lst=TheStyle.split(";")
		for(var i=0;i<lst.length;i++)
		{
			target=(lst[i].split(":")[0]).Trim()
			value=(lst[i].split(":")[1]).Trim()
			eval("Src.runtimeStyle."+target+"='"+value+"'")
		}	
	}
	//取得tagName为tag的父元素，如果没有指定tag,那么tag为"TR"
	function GetParentByTag(x,tag,flag)
	{
		if(tag==null) tag="TR"
		if(x.tagName==tag) return x
		var y=x.parentElement
		if(y==null||(!element.contains(y)&&flag!=1)) return 0
		if(y.tagName!=tag)
		return GetParentByTag(y,tag,flag)
		return y
	}	
	//当Row被激活(onmouseover)或者被放弃(onmouseout)并且属性element.ActiveStyle不为空时触发的事件
	function DoActivate(type)
	{
		if(element.ActiveStyle==null) return
		var e=event.srcElement
		if(e==null) return
		e=GetParentByTag(e)
		if(e==0||e.rowIndex>element.EndRow||e.rowIndex<element.StartRow||e==element.SelectedRow) return
		if(type==1)
		{			
			try
			{
				SetStyle(e,element.ActiveStyle)
			}
			catch(Exception)
			{
				alert("无效的 element.ActiveStyle["+element.ActiveStyle+"] 属性！")
				return
			}
		} else {
			with(e.runtimeStyle)
			{
				backgroundColor=""
				color=""
			}
		}				
		//当存在show_activate_action([object],[number])时，触发该函数
		//flag=1表示onmouseover,flag=0表示onmouseout
		if(typeof(show_activate_action)=="function")
			show_activate_action(e,type)
	}
</script>
<script language=vbscript>
	'[<-用文本方式比较两个字符串，如果用ANSI方式，那么汉字比较不出来，这虽然导致排序比较慢，但是有效->]
	dim SwapTimes
	function sort_table(the_tab,col,mode)
		dim Rows,iStart,iEnd,tArray(),i,j,tStep,eBody
		dim tmpStart,tmpEnd
		set Rows=the_tab.rows
		iStart=the_tab.StartRow
		SwapTimes=0
		iEnd=the_tab.EndRow
		redim tArray(iEnd-iStart)
		for i=iStart to iEnd
			tArray(i-iStart)=Array(Rows(i).cells(col).innerText,Rows(i))			
		next
		QuickSort tArray,0,iEnd-iStart	
		set eBody=Rows(iStart).parentElement
		'如果是降序排列，或者交换次数为0，那么从后往前排
		if mode=true and SwapTimes>0 then 
			tStep=1
			tmpStart=0
			tmpEnd=iEnd-iStart
		else
			tStep=-1
			tmpEnd=0
			tmpStart=iEnd-iStart
		end if
		for i=tmpStart to tmpEnd step tStep
			eBody.appendChild(tArray(i)(1))
		next
		'erase tArray
		set Rows=nothing
		set the_tab=nothing
		set tBody=nothing
	end function
	'StrComp，文本方式比较
	'java的快速排序思路
	function QuickSort(byref tArray,iStart,iEnd)
		dim o1,o2,i,j
		'Swaptimes=Swaptimes+1
		if iEnd>iStart then
			i=iStart-1
			j=iEnd
			o1=tArray(iEnd)(0)
			do while true
				dim t
				t=0
				i=i+1
				do while strcomp(tArray(i)(0),o1,1) < 0
					i=i+1
				loop								
				do while j>0
					j=j-1
					if strcomp(tArray(j)(0),o1,1) <= 0 then exit do
				loop
				if i >= j then exit do
				Swap tArray,i,j
			loop
			if i <> iEnd then Swap tArray,i,iEnd
			QuickSort tArray,iStart,i-1
			QuickSort tArray,i+1,iEnd
		end if
	end function
	
	sub Swap(byref tArray,iFrom,iTo)
		dim tmp
		'如果文本相同，那么不交换位置
		if tArray(iFrom)(0)=tArray(iTo)(0) then exit sub
		SwapTimes=Swaptimes+1
		tmp=tArray(iFrom)
		tArray(iFrom)=tArray(iTo)
		tArray(iTo)=tmp
	end sub
</script>
</PUBLIC:COMPONENT>
