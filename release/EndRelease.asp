<!--#include file="../include/flowsv.asp" -->
<%	
	var sRelease=rp.parse("[RELEASETYPE:x]")
	var suf=sType=="TER"?"时间":""	
	sql=rp.parse("UPDATE "+owner+"RELEASE set release_memo=[备注:s],END_TIME=[结束排放"+suf+":d],release_id=[__USER_NAME:s],end_release_date=sysdate,release_liquid=[Release_liquid:i],bucket_pressure2=[bucket_pressure2:i] where id="+sID)	
	cn.begin()	
	rStatus(sRelease)
	var rs=cn.execRs("select max(sub_id) from "+sDBOwner+".grems_release where id="+sID)
	var iTimes=parseInt(rs(0))		
	sql+=" AND sub_id="+iTimes
	rs=null	
	cn.Execute(sql)
	cn.end()
	message("OK!")
%>