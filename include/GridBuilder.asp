<!--#include file="connection.asp"-->
<%
'文件列表模板,原先的文件列表模板(DTC)的缺点是:
'1、DTC采用的是jscript,那么服务器在编译的时候不得不切换编译器,
'	这会大大消耗系统资源;
'2、DTC模块的初始化执行太多不必要的方法和属性
'3、DTC服务器不同脚本间的变量传递出现困难
'4、DTC的recordset对象采用客户端的static可更新光标,这会增加系统消耗
'5、DTC脚本难于维护，而且不够灵活
'recordset对象使用只读、向前的服务端光标
 on error resume next
 dim TimeCount
 function checkFormat(sTable,sData)
	checkFormat=sData
 end function
 class Grid	
	'data_fields的作用：
	'	数组中的每个元素都是recordset对象的对应fields的指针，在生成页面表的时候，
	'	使用的是指针而不是fields，那么这样可以提高效率
	'count_sql：基于意见，我们在统计recordset返回的行数的时候，用select count(1)
	'	而不是recordset.rowcount，count_sql是统计行数的sql语句
	'columns：三维数组,用以收集初始化资料
	'enable_split：boolean变量，用以判断是否采用分页
	'rsbookmark：如果采用分页，那么该变量作为书签以储存页面表最后一行的record_number
	private enable_split,pubstr,default_cn,columns,_
		col_list,rsbookmark,count_sql,recount,page_size,_
		OtherColumns,circle_list,record
	'public属性说明：
	'target_tables:要检索的数据库的表集,可以是一个或者多个表
	'filter:包含在where语句中的子句
	'sort:排序，相当于包含在order by语句中的字句
	'limit:在检索语句列表的列名集前,如distinct,unique
	'page,page_count:只读,只有采用分页才有效
	'thead:表格的<thead>部分的innerHTML
	'no_record_msg:当查询出的行数为0时，显示的信息，如果没有定义，就会使用默认字符串
	public col_name,col_value,col_format,col_attri,_
		target_tables,filter,sort,group,limit,row_attri,_
		page,page_count,thead,no_record_msg,col_data,preFormat,GNPS_count,LNPS_count
		
	'格式化属性
	
	private sub reset_fields
		'页面表的列名,相当于thead中的<td>col_name</td>
		col_name=""		
		'数据库表的列名,不能为空,相当于tbody中的<td>col_value</td>
		col_value=""
		'加在TD标志内的字符串,相当于tbody中的<td col_attri>....</td>
		col_attri=""
		'加在TD的innerHTML中,位于colvalue前的字符串,相当于<col col_format>
		col_format=""
		col_data=""
	end sub
	'类的初始化(生成对象)
	private sub class_initialize
		timecount=timer
		page=1
		page_count=1
		recount=-1
		enable_split=0
		page_size=-1
		redim data_fields(1)
		'数据库连接字符串
		no_record_msg="没有任何纪录。"
		reset_fields
		set record=get_rec()
	end sub
	'当释放这个类的对象时，执行的函数
	private sub class_terminate
		'先释放data_fields里的指针		
		'然后释放record
		set record=nothing
	end sub
	'当flag等于1时,将采用cisprg这个用户连接数据库
	public sub set_conn_flag(flag)
		if flag=1 then default_cn=pubstr
	end sub
	'当使用这个过程时,页面表可以分页显示,size是每个页面显示的纪录数
	public sub set_page_size(size)
		enable_split=1
		page_size=size
	end sub
	'增加页面表的列
	public sub insert_field
		dim max
		if isempty(columns) then 
			redim columns(4,0)
			max=0
		else
			max=ubound(columns,2)
			max=max+1
			redim preserve columns(4,max)
		end if
		col_value=trim(col_value)
		col_data=trim(col_data)
		if col_data="" then 
			Response.Write "请您指定列值！"
			Response.End
			exit sub
		end if
		if col_value="" then col_value=col_data		
		if col_name="" then col_name=col_data
		columns(0,max)=col_name
		columns(1,max)=col_data
		columns(2,max)=col_attri
		columns(3,max)=col_format
		columns(4,max)=col_value
		reset_fields
	end sub
	
	public sub Circle(list)
		circle_list=split(list,",")
	end sub
	public function Add_Columns(byval list)
		if isEmpty(OtherColumns) then 
			OtherColumns=list		
		else
			OtherColumns=OtherColumns&"~"&list
		end if
	end function
	'生成对数据库表的要查询的列集,如果list是多个列的集合,
	'那么必须在列与列之间用"~"分隔,而不是用","分隔,因为某个
	'列可能包含逗号,比如decode(x,1,"x",2,"y",x) as x
	'这个函数是public,如果用户要检索的列集不出现在col_value中，
	'而是出现在别的属性中(比如col_attri)，那么必须使用这个函数。
	'如要实现<td id="&record("num")&">,那么要start_list("num")
	private function start_list(byval list)	
		dim i,pre,max
		start_list=-1
		list=trim(list)
		if list="" then exit function
		list=split(list,"~")
		for i=0 to ubound(list)			
			list(i)=trim(list(i))
			if not isempty(list(i)) and list(i) <> "" then
				pre=mid(list(i),1,1)
				if pre<> "#" and pre <> "@" and pre <> "!" then
					if pre="$" then list(i)=mid(list(i),2)
					if isempty(col_list) then 
						redim col_list(0)
						col_list(0)=list(i)
						start_list=0
					else
						max=ubound(col_list)+1					
						redim preserve col_list(max)
						col_list(max)=list(i)
						start_list=max
					end if
				end if
			end if
		next
	end function
	'col_name、col_value、col_attri、row_attri四个属性的格式化：
	'１、当字符串前缀是$或者没有前缀或者是个数字，那么将返回record某个字段的值:
	'	比如：如果设置了col_attri=2,那么相当于"<td "&record(2)&">"
	'2、当字符串的前缀是#时，那么将执行前缀后的函数（不是过程，因为要返回值）;
	'   比如：col_value="#mycon"，而函数mycon的返回值是"xixi",那么相当于"<td>xixi</td>"
	'3、如果字符串的前缀是@，那么将该字符串做普通字符串处理;
	'   比如：col_attri="@id='this_row'",那么相当于<td id='this_row'>
	'4、如果字符串的前缀是!,那么将该字符串当做一个变量，
	'   比如：col_attri="!\id='\&record(\tsk_id\)&\'\",相当于先把字段中的\改做",然后再eval,
	'　 则为:"<td id='"&record("tsk_id")&"'>"
	'５、如果是\,那么与４类似，只不过不需要!而已
	'其他非上述的四个变量，一律当作普通字符串处理
	private function do_eval(value,data_fields,record)
		dim value1
		if typename(value)="Integer" then
			do_eval=data_fields(value)
			exit function
		end if
		value=trim(value)
		if isempty(value) or value="" then
			do_eval=""
			exit function
		end if		
		value1=mid(value,2)
		select case mid(value,1,1)
			'函数
			case "#"
				do_eval=eval(value1)
			'字符串	
			case "@"			
				do_eval=value1
			'函数、字符串、数据库列的总和，在设置时，必须把字符串中的所有"(双引号)改成!(感叹号)	
			case "\"
				value1=replace(value,"\","""")
				do_eval=eval(value1)
			case "!"
				value1=replace(value1,"\","""")				
				do_eval=eval(value1)	
			'数据库列值	
			case else
				if mid(value,1,1) <> "$" then value1=value
				value1=split(value1," ")
				do_eval=record(value1(ubound(value1)))
		end select
				
	end function
	'生成查询的SQL语句
	private function build_query				
		dim i,j,sql,request_sort,x,Sortcolumn
		target_tables=trim(target_tables)
		if isempty(columns) or _
			isempty(target_tables) or _
			target_tables="" then 
			Response.Write "请您指定数据库的表名！"
			Response.end
			exit function
		end if
		if typename(preFormat) <> "Object" then set preFormat=getRef("checkFormat")
		thead="<tr>"
		request_sort=trim(request.Form("record_sort"))
		If Request_sort <> "" Then 
            SortColumn = Split(Trim(Split(Request_sort, ",")(0)), " ")
        elseif not isEmpty(sort) then
			SortColumn = Split(Trim(Split(Trim(sort), ",")(0)), " ")
		else
			SortColumn= ""
        End If
		For i = 0 To UBound(Columns, 2)
            Datavalue = Columns(1, i)
            Index = Start_list(Datavalue)
            Combine_String Thead, "<th " & Columns(3, i) 
            if Index = -1 then
				Combine_String Thead, " DisableSort=true><nobr><span class=ttl>" + Columns(0, i) + "</nobr></th>"
            else
				dim tmpData
				tmpData=preFormat(lcase(target_tables),lcase(Columns(1,i))) 	
				if tmpData <> lcase(Columns(1, i)) then Columns(4,i)=tmpData _
				else if Columns(4,i)=Columns(1, i) then Columns(4, i) = CInt(Index)
                Combine_String Thead, "><nobr><span class=ttl col='" & (Index + 1) & "'>" & Columns(0, i)
                If isArray(SortColumn) then
					if SortColumn(0) = Col_list(Index) or SortColumn(0) = cstr(Index + 1) Then
						sort=""&(Index+1)
						If UCase(SortColumn(UBound(SortColumn))) <> "DESC" Then
						     sort=sort & " ASC"
						Else
						     sort=sort & " DESC"
						End If
					end if
                End If
                Combine_String Thead, "</nobr></th>"
            End If
        Next      
        if Trim(OtherColumns) <> "" then Start_List OtherColumns
		thead=thead&"</tr>"
		col_list=join(col_list,","&CHR(10))
		sql="SELECT"		
		if Trim(limit) <> "" then _
			sql=sql&" "&limit
		sql=sql&" "&col_list&chr(10)&" FROM "
		'if default_cn <> pubstr then sql=sql&"col."
		sql=sql&target_tables
		'设置数据过滤
		if Trim(filter) <> "" then _
			sql=sql&chr(10)&" WHERE "&trim(filter)
		count_sql="SELECT COUNT(1) FROM ("&chr(10)&UCASE(sql)&chr(10)&")"
		'设置数据分组	
		if Trim(group) <> "" then _
			sql=sql&chr(10)&" GROUP BY "&trim(group)	
		'设置数据排序			
		if Trim(sort) <> "" then sql=sql&chr(10)&" ORDER BY "&trim(sort)	
		build_query=sql
	end function
	private sub combine_string(byref msg,to_string)
		msg=msg&to_string
	end sub
	'生成页面表
	public sub build_grid
		dim target_sql		
		target_sql=build_query						
		record.Open count_sql
		'Response.Write count_sql
		'Response.End 
		recount=cint(record(0))		
		record.Close			
		record.Open target_sql
		'Response.Write target_sql
		'Response.End
		formatRecordset(record)		
	end sub
	public sub formatRecordset(rst)
		dim grid_msg,i,j,start_pos,end_pos,move_flag,col_length,_
			pos,pre,act,field_count,new_row_attri,bCount,tmpData
		bCount=false	
		if record.State=clng(0) then
			set record=rst
			target_tables="None"
			col_format="style='display:none'"
			col_value="None"
			insert_field
			build_query
			if sort <> "" then record.Sort=sort
			recount=cint(record.RecordCount)
			if recount=-1 then
				recount=0
				bCount=true
			end if
		end if		
		col_length=ubound(columns,2)
		field_count=record.Fields.Count			
		dim data_fields()
		redim data_fields(field_count-1)
		for i=0 to field_count-1
			set data_fields(i)=record(i)
		next	
		'table 的id统一采用Grid
		grid_msg=chr(10)&"<table id=Grid cellpadding=0 cellspacing=0><COLGROUP>"&chr(10)		
		for i=0 to col_length
			combine_string grid_msg,"<col "&columns(3,i)&">"&chr(10)
		next
		grid_msg=grid_msg&"</GOLGROUP>"
		grid_msg=chr(10)&"<table style='width:100%;height:100%;' cellspacing=0 cellpadding=0>"&chr(10)&"<tr style='height:1'><td>"&chr(10)&"<table id=GridTitle>"&thead&"</table>"&chr(10)& _
			"</tr><tr><td>"&chr(10)&"<div id=divGridMain style='width:100%;height:100%;overflow-y:scroll;overflow-x:auto;color:black'>"&chr(10)&grid_msg
		if recount <> 0 then	
			Dim IntLen,ChkStr,ChkValue
			j=-1
			do while not record.EOF
				j=j+1
				combine_string grid_msg,"<tr "&do_eval(row_attri,data_fields,record) 
				if not isEmpty(circle_list) then _
					combine_string grid_msg," class='"&Trim(circle_list(j mod (1+ubound(circle_list))))&"'"				
				combine_string grid_msg,">"				
				for i=0 to col_length
					pre=do_eval(columns(4,i),data_fields,record)		
					'if i>=1 then					pre=record.Fields(i-1).Name 
					if pre="" or isnull(pre) then pre="&nbsp;"
					combine_string grid_msg,"<td nowrap "&do_eval(columns(2,i),data_fields,record)&">"&pre&"</td>"
				next
				combine_string grid_msg,"</tr>"&chr(10)
				record.MoveNext
			loop
			Erase data_fields
			grid_msg=grid_msg&"</table>"
		else		
			grid_msg=grid_msg&"</table><style type=text/css>body "&_
				"{overflow:hidden}</style><table style='height:100%'>"&_
				"<tr><Td style='text-align:center'>"&no_record_msg&"</table>"
			page=1
			page_count=1
		end if
		grid_msg=grid_msg&chr(10)&"</div></td></tr><tr><td style='height:1;text-align:center'>"
		grid_msg=grid_msg&chr(10)&"<span id='grid_record_msg' style='width:100%;height:100%;text-align:center'>共有 "&recount&" 条记录，其中GNPS有"&&"条记录，LNPS有"&&"条记录，分为 "&page_count&" 页，这是第 "&page&" 页。</span>"
		grid_msg=grid_msg&chr(10)&"<form method=post style='display:none' id=data_list page_count="&page_count&">"&chr(10)
		grid_msg=grid_msg&_				
			"<input type=hidden name=start_position value="&start_pos&">"&chr(10)&_
			"<input type=hidden name=end_position value="&end_pos&">"&chr(10)&_
			"<input type=hidden id=record_sort name=record_sort value='"&sort&"'>"&chr(10)&_
			"<input type=submit id=move_first name=move_position value=-2>"&chr(10)&_
			"<input type=submit id=move_previous name=move_position value=-1>"&chr(10)&_
			"<input type=submit id=move_current name=move_position value=3>"&chr(10)&_
			"<input type=submit id=move_next name=move_position value=1>"&chr(10)&_
			"<input type=submit id=move_last name=move_position value=2>"&chr(10)
		grid_msg=grid_msg&"</form></td></tr></table>"&chr(10)
		Response.Write grid_msg		
		if move_flag=3 then act=typename(reload_action)
	end sub
	'返回总纪录数
	public property get record_count()
		record_count=recount
	end property
	public property get PageSize()
		PageSize=page_size
	end property	
 end class
 Response.CharSet="GB2312"
 on error goto 0
%>
<style type="text/css">
	body 
		{
			border:0;margin:0;
			overflow-y:hidden;overflow-x:auto
		}
	table
		{
			position:relative;width:100%;text-align:center;
			top:0;font-size:12px;border-collapse:collapse
		}		
	body,#divGridMain {
		scrollbar-face-color:#393;
		scrollbar-arrow-color:white;
		scrollbar-highlight-color:white;
		scrollbar-3dlight-color:#393;
		scrollbar-shadow-color:white;
		scrollbar-darkshadow-color:#393;
		scrollbar-track-color:#eef;
	}
	td,th {cursor:default}
	th {background-color:#393;color:white;border:1px solid white}
	.style2 {background-color:#f1f1f1}
	#grid_record_msg {background-color:#393;color:white;border:1px solid white}
</style>		
<script language="javascript">
	var opsitframe
	//当点击一个行时，显示的信息
	function showdetail(obj)
	{
		if(opsitframe!=null)
		try 
		{
			opsitframe.Grid.show("none")
		} catch(e) {}
	}
	//分页,参数说明：-2:首页；-1：前一页；0：更新当前页；1：下一页；2：末页
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
			x=x.replace(/[↓↑]{1}$/,"")
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
			if(flag=="ASC") tag="↓"
			else tag="↑"
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
	//排序
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
	    /*插入语句到已有事件句柄中，返回一个新的Function对象*/ 
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
</script>