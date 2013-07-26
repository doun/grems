<!--#include file="../include/flowsv.asp"-->
<%	
	var iSpecial=rp.parse("[IS_SPECIAL:S]")
	var cParser=new ConstParser()
	cn.begin()	
	//提交新的申请单
	if(sID=="'N/A'")
	{
		var sql="select c.status_info,a.id from "+sDBOwner+".grems_status a,"+sDBOwner
			+".grems_apply b,"+sDBOwner+".grems_status_info c where c.current_status=a.current_status and a.current_status not in('END','CAL') "
			+"and substr(a.id,1,1)="+rp.parse("[电站:s]")+" "
			+"and b.bucket_no="+rp.parse(cParser.parse1("[BUCKET_NO:s]",sType,1))+" and a.id=b.id"
		var rs=cn.execRs(sql)
		if(!rs.eof) message("该罐废气（废液）正处于"+rs(0)+"状态，提交申请失败！")
		var sqlstr="select max(substr(id,6)) from "+sDBOwner+".grems_status where SYS_TYPE='"+sType+"'"
		rs=cn.execRs(sqlstr)
		var sSeq=""+rs(0).value
		delete rs
		//确定年份和序号
		var iYear=(new Date()).getFullYear()
		var iSeq		
		if(sSeq=="null") iSeq=1
		else {
			var aSeq=/(\d{4})(\d+)/.exec(sSeq)
			if(iYear!=parseInt(aSeq[1])) iSeq=1
			else iSeq=parseInt(parseFloat(aSeq[2]))+1		
		}
		sSeq=""+iSeq
		sSeq=""+iYear+""+"0000".replace(eval("/\\d{"+sSeq.length+"}$/"),sSeq)
		//生成排放单号	
		sID="'"+rp.parse("[电站:x][机组:x]")+sType+""+sSeq+"'"
		var lb_sID = rp.parse("[电站:x][机组:x]")+sType+""+sSeq
		var sql1=rp.parse("insert into "+sDBOwner+".grems_status(id,sys_type,current_status,ISSPECIAL_APP,VERSION) values("+sID+",[排放类型],'APP',"
			+iSpecial+",'"+oParamList['VERSION']+"')")
		//在GREMS_STATUS表中添加新纪录
		cn.Execute(sql1)
		//在GREMS_APPLY表中添加新纪录
		cn.Execute("insert into"+owner+"apply(id) values("+sID+")")
		//在GREMS_EXECUTER表中添加新纪录
		cn.Execute("insert into"+owner+"executer(id,app) values("+sID+","+rp.parse("[__USER_ID:s]")+")")
		var sRollID=rp.parse("[ROLL_ID:s]")		
		if(sRollID!="'N/A'") {
			cn.Execute("UPDATE "+owner+"STATUS SET CURRENT_STATUS='END' WHERE ID="+sRollID)
			
			cn.Execute("UPDATE "+owner+"CONFIRM SET CONFIRM_MEMO='由于氚活度或者总γ超过了设定值，该单已经转到单号为"+lb_sID+"的TER分析排放单上继续执行。' WHERE ID="+sRollID)
		}
	} else {	//修改申请单
		rStatus("APP",iSpecial)	
		setUser("APP")		
	}	
	//公共信息
	var sql2="UPDATE "+sDBOwner+".GREMS_APPLY SET BUCKET_NO=[BUCKET_NO:s],LIQUT_ALTITUDE=[LIQUT_ALTITUDE:i],"
		+"APPLY_MEMO=[APPLY_MEMO:s],CYCLE_TIME=[CYCLE_TIME:d],APPLY_DATE=SYSDATE,"
		+"APPLY_USRID=[__USER_NAME]"+rSpecial
	if(sType=="TER")
	{
		var iValue=rp.parse("[SEAWATER_FLOW:i]")
		sql2+=",SEAWATER_FLOW="+iValue+",SEC_PUMPS=[SEC_PUMPS:s],SEC_STAGES=[SEC_STAGES:s],CRF_PUMPS=[CRF_PUMPS:s]"
	} else if(sType=="ETY") {		
		sql2+=",SEAWATER_FLOW=[SEAWATER_FLOW:s]"		
	}
	
	sql2=rp.parse(cParser.parse1(sql2+" WHERE ID="+sID,sType))
	cn.Execute(sql2)	
	cn.end()	
	over("您已经成功提交了排放单号为["+sID+"]的签发单！")	
%>
