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
	/*--�ļ��б�ģ��֮�������Ե���ʹ�á�--*/
	/*--��ĳ��TABLE��Behaviorָ������ʱ,����ע�⣺
		1������THEAD��TFOOT��CELLS�⣬���CELLS���ܷǳ��棬��������ָ�ķǳ����ǣ�
			ĳһ�еĵ�X����ROWSPAN�����߲����еĵ�X����COLSPAN�����������еĵ�X����û��COLSPAN
			����Ȼ����������ǿ��ܵ�������ʧЧ
		2��TABLEҪһ����д�롣�������ASP�ű���д��TABLEʱ����ͣ����response.write��
			��ôҲ��ֻдһ���ֵ�ʱ��ҳ���ϸ�TABLE���Ѿ�������oncontentready�¼�������Ҳ�д�������
			a�����ǰ�Public InitGrid()��ȥ��oncontentready�¼��Ĵ�������������������ֶ�ִ��
				InitGrid()����
			b��һ����д�롣����֪������asp����vbs����ѭ��ʱ����ò�����������ĸ�ʽ��
				do while not rs.eof
					x=x&"a"&rs(0)&.....	
					......
					rs.movenext
				loop
				������ֵ������ԭ��̫�����Ҳ�˵�ˡ�
				js�������������x+="a"+rs(0)...��vbs�أ���������
				sub combine_string(byref msg,to_string)
					msg=msg&to_string
				end sub
				combine_string x,"a"&rs(0)...��
				����ֱ��ʹ��rs.getString��rs.getRows����
		�ļ��б�ķ�ҳ�������ģ����У���Ϊ�ͻ��˵�ҳ��һ�������ֻ��һҳ�����Ҫ������ҳ�ļ�¼��
			��ô��Ҫ�������������󡣶��������������ҳ������ҳ��ֻ��1����ôֻ��Ҫ����Sort������
			�ڿͻ������򣻷������������������������������TABLE
	*/
	/*
	��������������ǲ���alert���ѳ���ֻ�����Ի��߲���ʧЧ����
	
	�������Լ�����˵����
		��ҳ��������/�������Ե�ʱ�������Ժ��Դ�Сд
		Sort���ַ�����ֻд��������������Ե�ʱ�򣬽����������������ֵ�ĸ�ʽ��DoSort����
		element.Offset�����֣���/д��ƫ���������磬��element.Offset=1,Sort='1 DESC'ʱ��ԭ���ǽ���һ���������У����ڱ�ɵڶ������򣬿���Ϊ��ֵ
		element.FocusStyle���ַ�������ʹĳ�л�ý���(onclick)��ʱ�򣬸��е���ʾ��ʽ�����û�����ø����ԣ���ô�ͻ�ʹ��Ĭ�ϵĸ�ʽ
			�ٸ����ӣ�"backgroundColor:#333;color:red"����ô���л�ý����ʱ���䱳��ɫΪ#333,������ɫΪred
			��ע�⣺�����ر���Ҫ����Ҫ��ҳ�������ø�Table��cells(TD��TH)����ɫ�ͱ���ɫ
			��������������֣���ôֻ�Ǵ���ش���ָ���ĺ����������ı���ɫ����
		element.ActiveStyle���ַ�������/д����������Բ�Ϊ��ʱ�����ڷ���onmouseover��onmouseout�����ϴ�������
			���ʽ��element.FocusStyleһ��
		element.GridStyle���ַ�������FocusStyle��ֻд������TABLE��runtimeStyle������/����Ĭ������
		show(index)���൱�ڴ�������ڼ��У������THEAD����ôTBODY�ĵ�һ�е�IndexֵΪ1������Ϊ0
		InitGrid()�����³�ʼ��TABLE
		Heading:���ñ��TITLE��(TR����)����Ŀ����Ϊ��ʹ��������������������
	*/
	/*	
	currentStyle,style��runtimeStyle��˵����
		currentStyle��������ҳ���<STYLE>��<REL..>��ǩ��
		style��������ָ��Ԫ�ص�style������
		runtimeStyle���û��ڽű��ж��壬Ҳ������<REL..>�ж���
		һ������£����Ǻ��߸���ǰ�ߣ�����runtimeStyle->style->currentStyle
		����Ҳ�����⡣����ָ������ʾ���ǣ�������ֵ����
	��ΰ�һ��Ԫ�ص�ĳ��Style������Ϊ�̳�(Inherit)��
		�ı�style��ʱ�򣬲�Ҫ�޸ĺϲ����ԡ��ٸ����ӣ�
			���ĳ��Ԫ�ص�[element].currentStyle.border="1px solid red"��borderΪ�ϲ�����
			��ô���������[element].style.border="1px inset green"��������[element].style.border=""��
			��ô���޷��̳�currentStyle.border(��"1px solid red")���ԣ����ǲ���CSS��Ĭ�����ã���border=0����
			����İ취��
			with([element].style)
			{
				borderStyle="inset"
				borderColor="green"
			}
			Ҫ�̳л���currentStyle.border���ԣ��ͣ�
			with([element].style)
			{
				borderStyle=""
				borderColor=""
			}			
	*/
	//element.SelectedRow���ڴ����н�����е�ָ��
	var SelectedRow="",StartRow,EndRow,Len,SortCell=null,GridHead=null
	//ȥ���ַ������ߵĿո�
	String.prototype.Trim=new Function("return this.replace(/^([ ��\t]+)|([ ��\t]+)$/g,'')")
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
			alert("��Ч�� GridStyle["+the_style+"] ���ԣ�")
			return
		}
	}
	//��tHead����tFoot���ֲ���onmouseover��onmouseout�¼�ʱ�����ú���
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
				alert("��ı�����(TagName=TR)���ڵ�ǰ�����У�������û�и�������BelongTo���ԣ�")	
				return
			}		
		}	
		else isInner=1
		if(e==null) return
		var e1=e
		e=GetParentByTag(e,"TD",1)
		if(e==0||!element.GridHead.contains(e)) e=GetParentByTag(e1,"TH",1)
		if(e==0||!element.GridHead.contains(e)) return
		//��e��cellIndex����sortIndexʱ���������κβ���
		if((e==element.SortCell||e==element.tmpCol)&&isInner==0) return
		//��flag==0ʱ��onmouseout����1ʱ��onmouseover
		//����title_activate_action(flag)����
		if(typeof(title_activate_action)=="function")
		title_activate_action(e,flag)
	}
	//��ʼ��
	function ResetGrid(Heading)
	{
		var trs=element.rows
		element.Len=trs.length
		element.StartRow=0
		element.EndRow=element.Len-1
		//�˵�THEAD����
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
		//�˵�TFOOT����
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
			alert("�����Heading["+Heads+"]���Ի�������onend(element)��������")
			return
		}
		
	}
	//������ѡ��(SELECT)
	function release()
	{
		event.returnValue=false	
	}
	//������͡�����ǰ��Ϊ��¼���ƣ�����Ϊ��¼����
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
				//GridHeadΪ��ʱ��SortCellΪ���֣����Ա�����һ��SortCell��cellIndex
				show_sort_action(null,col,flag)
				element.SortCell=col
			}	
		} catch(Exceptions) {}	
	}
	//��������������XSL���򣬲��ɹ�����Ϊʹ��XML�ܵ�IE����汾������,������Ҳû�п���Nescape
	function DoSort(col)
	{
		//COL���ַ�����ʽΪ��NUMBER+" "+"ASC/DESC"��NUMBERָ���ǵڼ��У���һ�е�NUMBERΪ1,������0�����磺1 ASC
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
		//����������Ҫ��ʱ��
		T=new Date().getTime()
		col=col.split(" ")
		//ASCΪ�������У�DESCΪ����
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
			//alert("��Ч��Sort���ԣ���ȷ��ʽΪ'[Number] [ASC/DESC]'��")
			return
		}
		col-=1
		if(!isNaN(parseInt(element.Offset))) col+=parseInt(element.Offset)
		//���²���Ҫ��Alert��ֻ������ʧЧ����
		//����<1
		if(element.Len<1) return 
		//����Ƿǳ�������(����ĳЩCELL�ǿ���[COLSPAN>1]���߿���[ROWSPAN>1]����ô�������ʧЧ)
		try
		{
			var start=new Date
			sort_table(element,col,(flag==1)?true:false)		
			window.status = " (Time spent: " + (new Date - start) + "ms)";		
			/*
				������֮�󣬴���show_sort_action������
				flag������ASC����DESC����ʾ�������ǽ�������
				SortIndex��ԭ��������е�cellIndex
				col����������е�cellIndex
				���У�һ����ĵ�һ�е�cellIndexֵΪ0
			*/			
			if(!isNaN(parseInt(element.Offset))) col-=element.Offset
			if(typeof(show_sort_action)=="function")
			{
				//ע�⣺����������뷵��һ��cell[TD/TH]����ΪTHEAD��������һ��TABLE�����ǵ���һ��
				//���������ֵ����ôĬ���ж�
				if(element.GridHead==null)
				{
					//GridHeadΪ��ʱ��SortCellΪ���֣����Ա�����һ��SortCell��cellIndex
					//show_sort_action(element.SortCell,col,(flag==1)?"ASC":"DESC")
					element.SortCell=col
				}	else	{				
					//����SortCellΪһ��TDԪ�ػ���THԪ��
					if(element.SortCell!=null)
					{
						element.SortCell.IsSorting=false
						//��ʱ��ԭ�����е������inActivate
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
		//�������
		TimeCost=new Date().getTime()-T
	//	alert(TimeCost)
	}
	//�����һ����ʱ����ʾ����Ϣ
	function show(obj)
	{
		//���OBJ��null,��ô�ж�event.srcElement�Ƿ����ڸ�TABLE���������,return
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
					alert("��ı�����(TagName=TR)���ڵ�ǰ�����У�������û�и�������BelongTo���ԣ�")	
					return
				}	
			}		
			e=ev.srcElement
			if(ev.button!=1||e==null) return			
			var e1=e
			obj=GetParentByTag(e,null,1)
			//�˵�TFOOT��
			if(obj==0||(element.contains(obj)&&obj.rowIndex>element.EndRow)) return
			//����������THEAD���֣���ô����������
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
		//���obj�����֣���ô��ȡrowIndex=obj����
		else if(typeof(obj)=="number")
		{						
			if(element.rows.length-1<obj||obj<0) return
			obj=element.rows[obj]
			if(obj==null||obj.rowIndex>element.EndRow||obj.rowIndex<element.StartRow) return
		//	obj.scrollIntoView()
		}
		//���obj�����Ѿ��н��㣬��ô��ִֹ��
		//if(obj==element.SelectedRow) return
		try
		{
			//��ԭ���н������ʧȥ����(backgroundColor��color���inherit�����ı�TRԭ�е�Style)
			with(element.SelectedRow.runtimeStyle)
			{
				backgroundColor=""
				color=""
			}
			//���ҳ���д���show_blur_action��������ô�������������Ϊobjʧȥ����Ĵ����¼�
			if(typeof(show_blur_action)=="function")
			show_blur_action(element.SelectedRow)
			element.SelectedRow=""
		} catch(e) {}
		if(obj=="none")
		{
			//���obj="none"����ôִֻ�е��ˣ������ʱҳ���д���show_none_action������
			//��ô�����ú���
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
				alert("��Ч�� element.FocusStyle["+element.FocusStyle+"] ���ԣ�")
				return
			}
		}				
		//��ָ�����л�ý���󴥷�ָ���ĺ�����������������������ȥ�����ظ������Ҷ�������
		//���Ը�����Ҫ�����Ƿ�ɾ��showdetail()�������
		if(typeof(showdetail)=="function") showdetail()		
		if(typeof(show_detail_action)=="function") show_detail_action(element.SelectedRow)		
	}
	//��FocusStyle��ActiveStyle���н���
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
	//ȡ��tagNameΪtag�ĸ�Ԫ�أ����û��ָ��tag,��ôtagΪ"TR"
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
	//��Row������(onmouseover)���߱�����(onmouseout)��������element.ActiveStyle��Ϊ��ʱ�������¼�
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
				alert("��Ч�� element.ActiveStyle["+element.ActiveStyle+"] ���ԣ�")
				return
			}
		} else {
			with(e.runtimeStyle)
			{
				backgroundColor=""
				color=""
			}
		}				
		//������show_activate_action([object],[number])ʱ�������ú���
		//flag=1��ʾonmouseover,flag=0��ʾonmouseout
		if(typeof(show_activate_action)=="function")
			show_activate_action(e,type)
	}
</script>
<script language=vbscript>
	'[<-���ı���ʽ�Ƚ������ַ����������ANSI��ʽ����ô���ֱȽϲ�����������Ȼ��������Ƚ�����������Ч->]
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
		'����ǽ������У����߽�������Ϊ0����ô�Ӻ���ǰ��
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
	'StrComp���ı���ʽ�Ƚ�
	'java�Ŀ�������˼·
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
		'����ı���ͬ����ô������λ��
		if tArray(iFrom)(0)=tArray(iTo)(0) then exit sub
		SwapTimes=Swaptimes+1
		tmp=tArray(iFrom)
		tArray(iFrom)=tArray(iTo)
		tArray(iTo)=tmp
	end sub
</script>
</PUBLIC:COMPONENT>
