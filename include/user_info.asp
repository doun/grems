<!--#include file="pm.asp"-->
<!--#include file="ModeRule.asp"-->
<%	
	
	var sTreeText="<TREE name=\"�б�\" action=\"void(0);\">"
		+"<NODE name=\"��ҳ\" action=\"LoadPage('Public/ActionMain.asp?Action=DEFAULT');\"/>"
		+"<NODE name=\"�����ŷ�\" ref='apply._default' action=\"LoadPage('Apply/DoApply.asp');\"/>"
		+"<NODE name=\"����\" ref='sample._default' action=\"LoadPage('Public/ActionMain.asp?Action=SAMPLE');\"/>"
		+"<NODE name=\"����\" ref='analyze._default' action=\"LoadPage('Public/ActionMain.asp?Action=ANALYZE');\"/>"
		+"<NODE name=\"���\" ref='check._default' action=\"LoadPage('Public/ActionMain.asp?Action=CHECK');\"/>"
		+"<NODE name=\"��ͨ�ŷ�����\" ref='confirm._default' action=\"LoadPage('Public/ActionMain.asp?Action=CONFIRM');\"/>"
		+"<NODE name=\"�����ŷ�����\" ref='confirm.confirmmain2' action=\"LoadPage('Public/ActionMain.asp?Action=SPCONFIRM');\"/>"
		+"<NODE name=\"�ŷ�\" ref='release._default' action=\"LoadPage('Public/ActionMain.asp?Action=RELEASE');\"/>"
		+"<NODE name=\"��ѯ��ͳ��\" ref='statistic._default' action=\"void(0);\">"
		+"<NODE name=\"��λ��\" action=\"LoadPage('Statistic/chaowei.asp');\"/>"
		+"<NODE name=\"�����ѯ\" ref='statistic.statisticsearch' action=\"LoadPage('Statistic/StatisticMain.asp?content=SEARCH');\"/>"
		+"<NODE name=\"���ͳ��\" action=\"LoadPage('Statistic/StatisticMain.asp?content=YEAR');\"/>"
		+"<NODE name=\"�¶�ͳ��\" action=\"LoadPage('Statistic/StatisticMain.asp?content=MONTH');\"/>"
		+"<NODE name=\"TERϵͳͳ��\" action=\"LoadPage('Statistic/StatisticMain.asp?content=TER');\"/>"
		+"<NODE name=\"SELϵͳͳ��\" action=\"LoadPage('Statistic/StatisticMain.asp?content=SEL');\"/>"
		+"<NODE name=\"ETYϵͳͳ��\" action=\"LoadPage('Statistic/StatisticMain.asp?content=ETY');\"/>"
		+"<NODE name=\"TEGϵͳͳ��\" action=\"LoadPage('Statistic/StatisticMain.asp?content=TEG');\"/></NODE>"
		+"<NODE name=\"��վά��\" ref='grantgroup._default' action=\"void(0);\">"
		+"<NODE name=\"ϵͳ��Աά��\" action=\"LoadPage('GrantGroup/AuthGroup.asp');\"/>"
		+"<NODE name=\"�û�ά��\" action=\"LoadPage('GrantGroup/users.asp');\"/>"
		+"<NODE name=\"��λ��ά��\" action=\"LoadPage('GrantGroup/chaowei_info.asp');\"/>"
		+"<NODE name=\"ϵͳ����ά��\" ref='public.setparam' action=\"LoadPage('Public/setParam.asp');\"/></NODE>"
		
		+"<NODE name=\"ֽ���ŷŵ�¼��\" ref='input._default' action=\"void(0);\">"
		+"<NODE name=\"TER�ŷŵ�¼��\" action=\"LoadPage('Input/TER_Input.asp');\"/>"
		+"<NODE name=\"SEL�ŷŵ�¼��\" action=\"LoadPage('Input/SEL_Input.asp');\"/>"
		+"<NODE name=\"ETY�ŷŵ�¼��\" action=\"LoadPage('Input/ETY_Input.asp');\"/>"
		+"<NODE name=\"TEG�ŷŵ�¼��\" action=\"LoadPage('Input/TEG_Input.asp');\"/>"
		+"<NODE name=\"����Һ�嵥¼��\" action=\"LoadPage('Input/Other_Liq_Input.asp');\"/>"
		+"<NODE name=\"�������嵥¼��\" action=\"LoadPage('Input/Other_Gas_Input.asp');\"/></NODE>"				
		
		+"<NODE name=\"�޸�����\" action=\"LoadPage('GrantGroup/Change_Pwd.asp');\"/>"
		+"<NODE name=\"�˳���½\" action=\"ExitLogon()\"/></TREE>"
	var cp=new requestParser()
	var sUserID=cp.parse("[CURRENT_USER:s]")			
	var cn=new Connection()
	//����ȡ���û��Ļ�����Ϣ(ID,NAME,Station,Development)
	var rs=cn.execRs("SELECT EP_ID,EP_NAME,EP_DEPNAME,EP_STATION,EP_WORKGROUP FROM "+sDBOwner+".GREMS_EMPLOYEE WHERE EP_ID="+sUserID)
	if(rs.EOF) clear("�����ڸ��û����������µ�½��")		
	var sRole=(""+rs(4)).replace(/(^,+|\s+$)/g,"")
	var sResult="<ROOT><__USER_INFO>"
		+"<__USER_ID>"+rs(0)+"</__USER_ID>"
		+"<__USER_NAME>"+rs(1)+"</__USER_NAME>"
		+"<__USER_DEPT>"+rs(2)+"</__USER_DEPT>"
		+"<__USER_STATION>"+rs(3)+"</__USER_STATION>"
		+"<__USER_ROLE>"+sRole+"</__USER_ROLE>"
		+"</__USER_INFO>"+sTreeText+"</ROOT>"
	var uDom=getDom()
	//��μ���û��Ĳ���Ȩ��
	uDom.loadXML(sResult)
	var nodes=uDom.selectNodes("//NODE")
	var oModeRule=new ModeRuleObject()	
	for(var i=nodes.length-1;i>=0;i--)
	{
		if(nodes[i].childNodes.length>0) continue
		var ref=nodes[i].getAttribute("ref")
		if(ref==null) {
			var oParent=nodes[i].parentNode
			if(oParent==null||oParent.nodeName=="TREE") continue
			ref=oParent.getAttribute("ref")
			if(ref==null) continue
		} else nodes[i].removeAttribute("ref")
		if(checkGrant(sRole,getMode(ref,oModeRule))) continue
		nodes[i].removeAttribute("action")
		nodes[i].setAttribute("close",1)
	}
	Response.Write(uDom.xml)	
	Erase(cp)
	delete cp
	delete uDom	
%>
