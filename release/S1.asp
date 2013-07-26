<!--#include file="../include/flowsv.asp" -->
<!--#include file="../include/checkConflict.asp"-->
<%	
	var sRelease=(rp.parse("[bRelease:x]")=="1")?"END":"PUS"
	var suf=sType=="TER"?"时间":""
	sql="insert into "+sDBOwner+".grems_release(id,sub_id,no_conflect,start_time,end_time,okrt901ma,release_speed,release_liquid,chimney_speed,direction80m,speed80m,confirm80m,bucket_pressure,bucket_pressure2,release_id,release_date,release_memo,special_reason) values("
		   +sID+",%Times%,[NO_CONFLECT:s],[开始排放"+suf+":d],[结束排放"+suf+":d],[okrt901ma:s],[release_speed:i],[release_liquid:i],[chimney_speed:i],[direction80m:s],[speed80m:i],[confirm80m:s],[Bucket_Pressure:i],[Bucket_Pressure2:i],[__user_name],sysdate,[备注:s],[SPECIAL_REASON:s])"		
	cn.begin()
	var sReturn=CheckConflict(cn,sID,sType)
	if(sReturn!=null)
	{
		if(iSpecial!="3"&&iSpecial!="7") clear(sReturn)
		else rp.oDoc.selectSingleNode("//SPECIAL_REASON").text+="\n"+sReturn
	}
	rStatus(sRelease)
	var rs=cn.execRs("select max(sub_id) from "+sDBOwner+".grems_release where id="+sID)
	var iTimes=parseInt(rs(0))	
	rs=null
	if(isNaN(iTimes)) iTimes=1
	else iTimes=parseInt(iTimes)+1
	setUser("RS"+iTimes)
	sql=rp.parse(sql.replace("%Times%",""+iTimes))
	cn.Execute(sql)
	cn.end()
	message("OK!")
%>