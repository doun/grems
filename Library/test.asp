<!--#include file="../include/GridJS.asp"-->
<%	
	set table=GetGrid()
	table.tables="grems.grems_status"
	table.append "���뵥��","ID","width='120'"
	table.append "��ǰ״̬","CURRENT_STATUS",null,"@id=^1^"
	table.sort="1 desc"
	table.Build
	set table=nothing
	set t2=GetGrid()
%>