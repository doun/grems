	//自定义下拉框,该下拉框必须在<TD>内。
	//width:宽度;select_attri:下拉框的属性;bg_color:背景色;boder_style:边框样式
	var select_box_timer,have_past_box_style=0
	function create_box(width,select_attri,border_style,td_attri,box_length)
	{
		var str
		if(td_attri==null) td_attri=""
		if(box_length==null)
		{
			if(typeof(width)=="number") box_length=width-22
			else box_length="70%"
		}	
		if(width==null) width=""
		else width="width:"+width
		if(border_style==null) border_style="border:2px groove #09c;background-color:#08b;color:white;"
		str="<td class=tdselectdiv style='height:19px;border:0;padding:0;margin:0;vertical-align:top;text-align:left;"+width
			+ "' "+td_attri+"><div class=divbg style='height:1;"
		str	+="text-align:right;font-size:13px;cursor:default;"+border_style+"' onclick='var e=this.parentElement.all[3].scrollIntoView()'></div>"
			+ "</div><div style='border:0;clip:rect(3 99% 16 3)'>"
			+ "<select class=custom_select_box style='width:100%;left:0;top:0;'onmousedown='blur_select_box(this)' onclick='blur_select_box(this,1)' oncontextmenu='this.parentElement.focus()' "+select_attri+">"
		if(have_past_box_style!=1)
		{
			have_past_box_style=1	
			document.write("<style type=text/css>.tdselectdiv div {position:absolute;width:100%;height:1;padding:0}</style>")
			document.write("<style type=text/css>.tdselectdiv select {font:12px}</style>")
		}
		document.write(str)
		var the_len=document.all.length-1	
	}
	function end_box()
	{
		
	}	
	function blur_select_box(e,flag)
	{	
		if(flag==null)
		{
			e.parentElement.theIndex=e.selectedIndex
		} else {
			var i=e.sourceIndex
			if(event.button==2||e.parentElement.theIndex!=e.selectedIndex) e.parentElement.focus()
		}
	}
	
	function set_box_length(e)
	{
		e.parentElement.style.clip="rect(3 "+(e.clientWidth-3)+" 16 3)"
	}
	function set_boxes_length()
	{
		var ss=document.all.tags('SELECT')
		for(var i=0;i<ss.length;i++)
		{
			if(ss[i].className=="custom_select_box") set_box_length(ss[i])
		}
	}
	document.onreadystatechange=set_boxes_length
