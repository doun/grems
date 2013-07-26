<!--#include file="pm.asp"-->
<!--#include file="ModeRule.asp"-->
<%	
	
	var sTreeText="<TREE name=\"列表\" action=\"void(0);\">"
		+"<NODE name=\"首页\" action=\"LoadPage('Public/ActionMain.asp?Action=DEFAULT');\"/>"
		+"<NODE name=\"申请排放\" ref='apply._default' action=\"LoadPage('Apply/DoApply.asp');\"/>"
		+"<NODE name=\"采样\" ref='sample._default' action=\"LoadPage('Public/ActionMain.asp?Action=SAMPLE');\"/>"
		+"<NODE name=\"分析\" ref='analyze._default' action=\"LoadPage('Public/ActionMain.asp?Action=ANALYZE');\"/>"
		+"<NODE name=\"检查\" ref='check._default' action=\"LoadPage('Public/ActionMain.asp?Action=CHECK');\"/>"
		+"<NODE name=\"普通排放审批\" ref='confirm._default' action=\"LoadPage('Public/ActionMain.asp?Action=CONFIRM');\"/>"
		+"<NODE name=\"特殊排放审批\" ref='confirm.confirmmain2' action=\"LoadPage('Public/ActionMain.asp?Action=SPCONFIRM');\"/>"
		+"<NODE name=\"排放\" ref='release._default' action=\"LoadPage('Public/ActionMain.asp?Action=RELEASE');\"/>"
		+"<NODE name=\"查询与统计\" ref='statistic._default' action=\"void(0);\">"
		+"<NODE name=\"潮位表\" action=\"LoadPage('Statistic/chaowei.asp');\"/>"
		+"<NODE name=\"任务查询\" ref='statistic.statisticsearch' action=\"LoadPage('Statistic/StatisticMain.asp?content=SEARCH');\"/>"
		+"<NODE name=\"年度统计\" action=\"LoadPage('Statistic/StatisticMain.asp?content=YEAR');\"/>"
		+"<NODE name=\"月度统计\" action=\"LoadPage('Statistic/StatisticMain.asp?content=MONTH');\"/>"
		+"<NODE name=\"TER系统统计\" action=\"LoadPage('Statistic/StatisticMain.asp?content=TER');\"/>"
		+"<NODE name=\"SEL系统统计\" action=\"LoadPage('Statistic/StatisticMain.asp?content=SEL');\"/>"
		+"<NODE name=\"ETY系统统计\" action=\"LoadPage('Statistic/StatisticMain.asp?content=ETY');\"/>"
		+"<NODE name=\"TEG系统统计\" action=\"LoadPage('Statistic/StatisticMain.asp?content=TEG');\"/></NODE>"
		+"<NODE name=\"网站维护\" ref='grantgroup._default' action=\"void(0);\">"
		+"<NODE name=\"系统成员维护\" action=\"LoadPage('GrantGroup/AuthGroup.asp');\"/>"
		+"<NODE name=\"用户维护\" action=\"LoadPage('GrantGroup/users.asp');\"/>"
		+"<NODE name=\"潮位表维护\" action=\"LoadPage('GrantGroup/chaowei_info.asp');\"/>"
		+"<NODE name=\"系统参数维护\" ref='public.setparam' action=\"LoadPage('Public/setParam.asp');\"/></NODE>"
		
		+"<NODE name=\"纸质排放单录入\" ref='input._default' action=\"void(0);\">"
		+"<NODE name=\"TER排放单录入\" action=\"LoadPage('Input/TER_Input.asp');\"/>"
		+"<NODE name=\"SEL排放单录入\" action=\"LoadPage('Input/SEL_Input.asp');\"/>"
		+"<NODE name=\"ETY排放单录入\" action=\"LoadPage('Input/ETY_Input.asp');\"/>"
		+"<NODE name=\"TEG排放单录入\" action=\"LoadPage('Input/TEG_Input.asp');\"/>"
		+"<NODE name=\"其他液体单录入\" action=\"LoadPage('Input/Other_Liq_Input.asp');\"/>"
		+"<NODE name=\"其他气体单录入\" action=\"LoadPage('Input/Other_Gas_Input.asp');\"/></NODE>"				
		
		+"<NODE name=\"修改密码\" action=\"LoadPage('GrantGroup/Change_Pwd.asp');\"/>"
		+"<NODE name=\"退出登陆\" action=\"ExitLogon()\"/></TREE>"
	var cp=new requestParser()
	var sUserID=cp.parse("[CURRENT_USER:s]")			
	var cn=new Connection()
	//首先取出用户的基本信息(ID,NAME,Station,Development)
	var rs=cn.execRs("SELECT EP_ID,EP_NAME,EP_DEPNAME,EP_STATION,EP_WORKGROUP FROM "+sDBOwner+".GREMS_EMPLOYEE WHERE EP_ID="+sUserID)
	if(rs.EOF) clear("不存在该用户，请您重新登陆！")		
	var sRole=(""+rs(4)).replace(/(^,+|\s+$)/g,"")
	var sResult="<ROOT><__USER_INFO>"
		+"<__USER_ID>"+rs(0)+"</__USER_ID>"
		+"<__USER_NAME>"+rs(1)+"</__USER_NAME>"
		+"<__USER_DEPT>"+rs(2)+"</__USER_DEPT>"
		+"<__USER_STATION>"+rs(3)+"</__USER_STATION>"
		+"<__USER_ROLE>"+sRole+"</__USER_ROLE>"
		+"</__USER_INFO>"+sTreeText+"</ROOT>"
	var uDom=getDom()
	//其次检查用户的操作权限
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
