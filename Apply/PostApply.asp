<!--#include file="../include/flowsv.asp"-->
<%	
	var iSpecial=rp.parse("[IS_SPECIAL:S]")
	var cParser=new ConstParser()
	cn.begin()	
	//�ύ�µ����뵥
	if(sID=="'N/A'")
	{
		var sql="select c.status_info,a.id from "+sDBOwner+".grems_status a,"+sDBOwner
			+".grems_apply b,"+sDBOwner+".grems_status_info c where c.current_status=a.current_status and a.current_status not in('END','CAL') "
			+"and substr(a.id,1,1)="+rp.parse("[��վ:s]")+" "
			+"and b.bucket_no="+rp.parse(cParser.parse1("[BUCKET_NO:s]",sType,1))+" and a.id=b.id"
		var rs=cn.execRs(sql)
		if(!rs.eof) message("�ù޷�������Һ��������"+rs(0)+"״̬���ύ����ʧ�ܣ�")
		var sqlstr="select max(substr(id,6)) from "+sDBOwner+".grems_status where SYS_TYPE='"+sType+"'"
		rs=cn.execRs(sqlstr)
		var sSeq=""+rs(0).value
		delete rs
		//ȷ����ݺ����
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
		//�����ŷŵ���	
		sID="'"+rp.parse("[��վ:x][����:x]")+sType+""+sSeq+"'"
		var lb_sID = rp.parse("[��վ:x][����:x]")+sType+""+sSeq
		var sql1=rp.parse("insert into "+sDBOwner+".grems_status(id,sys_type,current_status,ISSPECIAL_APP,VERSION) values("+sID+",[�ŷ�����],'APP',"
			+iSpecial+",'"+oParamList['VERSION']+"')")
		//��GREMS_STATUS��������¼�¼
		cn.Execute(sql1)
		//��GREMS_APPLY��������¼�¼
		cn.Execute("insert into"+owner+"apply(id) values("+sID+")")
		//��GREMS_EXECUTER��������¼�¼
		cn.Execute("insert into"+owner+"executer(id,app) values("+sID+","+rp.parse("[__USER_ID:s]")+")")
		var sRollID=rp.parse("[ROLL_ID:s]")		
		if(sRollID!="'N/A'") {
			cn.Execute("UPDATE "+owner+"STATUS SET CURRENT_STATUS='END' WHERE ID="+sRollID)
			
			cn.Execute("UPDATE "+owner+"CONFIRM SET CONFIRM_MEMO='����밻�Ȼ����ܦó������趨ֵ���õ��Ѿ�ת������Ϊ"+lb_sID+"��TER�����ŷŵ��ϼ���ִ�С�' WHERE ID="+sRollID)
		}
	} else {	//�޸����뵥
		rStatus("APP",iSpecial)	
		setUser("APP")		
	}	
	//������Ϣ
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
	over("���Ѿ��ɹ��ύ���ŷŵ���Ϊ["+sID+"]��ǩ������")	
%>
