var opsitframe
	//�����һ����ʱ����ʾ����Ϣ
	function showdetail(obj)
	{
		if(opsitframe!=null)
		try 
		{
			opsitframe.Grid.show("none")
		} catch(e) {}
	}
	//��ҳ,����˵����-2:��ҳ��-1��ǰһҳ��0�����µ�ǰҳ��1����һҳ��2��ĩҳ
	function change_page(flag)
	{
		if(typeof(data_list)=="undefined") return
		with(data_list.all)
		{
			switch(flag)
			{
				case -2:
					move_first.click()
					break
				case -1:
					move_previous.click()
					break
				case 0:
					move_current.click()
					break
				case 1:
					move_next.click()
					break
				case 2:
					move_last.click()					
			}
		}	
	}
	function show_sort_action(oldcell,index,flag)
	{
		if(oldcell!=null)
		{
			x=oldcell.all[0].innerText
			x=x.replace(/[����]{1}$/,"")
			oldcell.all[0].innerText=x
			with(oldcell.style)
			{
				backgroundColor=""
				color=""
			}
		}
		if(index!=null)
		{	
			var tag
			if(flag=="ASC") tag="��"
			else tag="��"
			index.all[0].innerText+=tag
			with(index.style)
			{
				backgroundColor="#66aa66"
				color="white"
			}
		}	
	}
	function SetSortStyle()
	{
		try {
			Grid.SetStyleWithoutSort(data_list.record_sort.value)
		} catch(Exception)
		{
			setTimeout('SetSortStyle()',10)
		}
	}
	//����
	function onbeforesort(x,val)
	{			
		var ColumnNo=val.split(" ")[0]		
		var resort=document.all["record_sort"]
		if(resort!=null) resort.value=val
		if(typeof(data_list)=="undefined"||parseInt(data_list.page_count)<2) 
		{
			return 1
		}	
		else 
		{
			data_list.all["move_first"].click()
			return 0
		}	
	}
	function addSenToEventHandle(EHObj,insSen)
	{ 
	    /*������䵽�����¼�����У�����һ���µ�Function����*/ 
		var preSen; 
		if (EHObj!=null)
		{ 
			preSen=EHObj.toString(); 
		}else { 
			preSen=""; 
		} 
		var reg=/^(function +[\w|\$|\.]+ *\([\w|\$|\,|\.]*\) *\{)([\W|\w]*)(\})$/; 
		var preBody=preSen.replace(reg,"$2"); 
		var newFunObj=new Function(preBody+insSen); 
		return newFunObj; 
	} 
	function SetEvent(Event,Fun)
	{
	    window.onload=addSenToEventHandle(Event,Fun)
	}
	function LoadEvent(Fun)
	{
		window.onload=addSenToEventHandle(window.onload,Fun)
	}
	LoadEvent("SetSortStyle()")