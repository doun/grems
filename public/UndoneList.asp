<%Response.Expires=-1%>
<!--#include file="../include/GridBuilder.asp"-->
<%	
	set table=new Grid
	table.col_name="�ŷŵ���"
	table.col_format="style='width:120px'"
	table.col_data="A.ID"
	table.insert_field
	
	table.col_name="Һλ/ѹ��"
	table.col_data="B.LIQUT_ALTITUDE"
	table.col_format="style='width:100px'"
	table.insert_field
	
	table.col_name="ǩ����"
	table.col_data="B.APPLY_USRID"
	table.col_format="style='width:60px'"
	table.insert_field
	
	table.col_name="ǩ��ʱ��"
	table.col_data="B.APPLY_DATE"
	table.col_format="style='width:140px'"
	table.insert_field
	
	table.col_name="��ǰ״̬"
	table.col_data="C.Status_Info"	
	table.insert_field
	
	table.target_tables="GREMS.GREMS_STATUS A,GREMS.GREMS_APPLY B,GREMS.GREMS_Status_Info C"
	table.filter="A.ID=B.ID AND A.CURRENT_STATUS=C.CURRENT_STATUS AND A.Current_Status IN ('APP','ALS','AQT','SMP')"	
	table.sort="ID"
	table.circle("style1,style2")	
	table.limit="distinct"
	table.Build_Grid
	set table=nothing
%>
