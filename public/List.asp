<%@Language=JScript%>
<!--#include file="../include/GridJS.asp"-->
<%	
	var sDBOwner=Application("DBOwner")
	var table=new Grid()	
	table.limit="distinct"
	table.append("�ŷŵ���","A.ID",100)	
	table.append("�޺�/ϵͳ��","B.BUCKET_NO",80)
	table.append("Һλ/ѹ��","B.LIQUT_ALTITUDE",100)
	table.append("ǩ����","B.APPLY_USRID",60)
	table.append("ǩ��ʱ��","TO_CHAR(B.APPLY_DATE,'YYYY-MM-DD HH24:MI')",140)
	table.append("��ǰ״̬","C.Status_Info")			
	table.tables=sDBOwner + ".GREMS_STATUS A," + sDBOwner + ".GREMS_APPLY B," + sDBOwner+".GREMS_Status_Info C"
	table.filter="A.ID=B.ID AND A.CURRENT_STATUS=C.CURRENT_STATUS"	
	table.rAttri="@onclick=ShowPage(^1^)"
	table.sort="A.ID"
	s=(""+Request.QueryString("s")).toUpperCase()
	var sf
	switch(s)
	{
		case "DEFAULT":
		case "APP":sf=" < 16";break
		case "SAM":sf="IN ('APP','ALS','AQT','SMP')";break	
		case "ANA":sf="IN ('ALS','CQT','ISA')";break
		case "CHK":sf="IN ('ISA','WQT')";break
		case "COM":sf="IN ('CHK','CQT','RLS')";break
		case "CM2":sf="IN ( 'CFM','RLS')";break
		case "RLS":sf="IN ('RLS','PUS','HLT','RLG')";break
		default:
			Response.Clear()
			Response.End()
	}			
	var sFlag
	if(s == "APP"||s =="DEFAULT") sFlag="C.Status_NO" 
	else sFlag="A.CURRENT_STATUS"
	table.filter += " AND "+sFlag+" "+sf
	table.Build()
	table=null
%>
<script>parent.document.all['UnDoneList'].style.display="";</script>
<script src="../Public/List.js" language=javascript></script>