<%
//此文件用于保存流程中的文字常量－－胡方能

	function ConstParser() {}
	//公共
	ConstParser.prototype.ConstPublic=""+
		"BUCKET_NO:系统号,"+
		"ID:排放单号,"+
		"SYS_TYPE:排放类型,"+
		"APPLY_USRID:签发人,"+
		"APPLY_DATE:签发时间,"+
		"APPLY_MEMO:备注,"+
		"SAMPLE_UID:取样人,"+
		"SAMPLE_DATE:取样时间,"+
		"SAMPLE_MEMO:采样备注,"+
		"NO_CONFLECT:无排放冲突,"+
		"START_TIME:排放开始时间,"+
		"END_TIME:排放结束时间"
	//液体	
	ConstParser.prototype.ConstLIQ=""+
		"LIQUT_ALTITUDE:液位(m),"+
		"CYCLE_TIME:循环开始时间,"+
		"PUBNUM1:系统号,"+
		"PUBNUM2:液位(m),"+
		"B:PH值,"+
		"Y:液体总γ(Bq/m<sup>3</sup>),"+
		"TRITIUM:氚(Bq/m<sup>3</sup>),"+
		"OKRT901MA:OKRT904MA可用,"+
		"Release_Speed:排放流速(m<sup>3</sup>/h),"+
		"Release_liquid:液位(m)"
	//TER	
	ConstParser.prototype.ConstTER=""+	
		"BUCKET_NO:罐号,"+
		"SEC_PUMPS:SEC单台投运数,"+
		"SEC_STAGES:SEC整列投运数,"+
		"CRF_PUMPS:CRF泵投运台数,"+
		"SEAWATER_FLOW:排放渠海水流量,"+
		"OKRT901MA:OKRT901MA可用,"+
		"PUBNUM1:罐号"
	//SEL	
	ConstParser.prototype.ConstSEL=""+	
		"BUCKET_NO:罐号,"+
		"PUBNUM1:罐号"
	//气体	
	ConstParser.prototype.ConstGAS=""+
		"LIQUT_ALTITUDE:表压(Bar),"+
		"PUBNUM1:滤膜(m<sup>3</sup>),"+
		"PUBNUM2:氚(m<sup>3</sup>),"+
		"B:气体总β(Bq/m<sup>3</sup>),"+
		"Y:总γ(Bq/m<sup>3</sup>),"+
		"TRITIUM:氚(Bq/m<sup>3</sup>),"+
		"OKRT901MA:KRT016/017MA可用,"+
		"Release_Speed:排放流量(m<sup>3</sup>/h),"+
		"Chimney_Speed:烟囱流速(m/s),"+
		"Release_liquid:表压(bar)"

	//TEG	
	ConstParser.prototype.ConstTEG=""+	
		"BUCKET_NO:罐号,"+
		"LIQUT_ALTITUDE:表压(Bar),"+
		"CYCLE_TIME:充气结束时间,"+
		"Y:碘盒总γ(Bq/m<sup>3</sup>),"+
		"TRITIUM:氚(Bq/m<sup>3</sup>)"
	//ETY	
	ConstParser.prototype.ConstETY=""+	
		"BUCKET_NO:反应堆号,"+
		"LIQUT_ALTITUDE:安全壳绝对压力(mbar),"+	
		"SEAWATER_FLOW:大气压力(mbar),"+
		"PUBNUM1:碘盒(m<sup>3</sup>),"+
		"START_USER:放样人,"+
		"START_DATE:放样时间,"+	
		"B:KRT009MA(Bq/m<sup>3</sup>),"+
		"Y:碘盒总γ(Bq/m<sup>3</sup>),"+
		"TRITIUM:氚(Bq/m<sup>3</sup>),"+
		"Release_liquid:安全壳压力(mbar)"
		
	ConstParser.prototype.getParam=function(sItem1,sType,iFlag)
	{
		sType=sType.toUpperCase()
		var sGroup=this.getGroup(sType)				
		var sTotal=eval("this.Const"+sType)+","+eval("this.Const"+sGroup)+","+this.ConstPublic
		var oRes
		sItem=sItem1.replace(/([\?\\\-\(\:\*\+\.\{\}\/])/g,"\\$1")
		
		switch(iFlag)
		{
			case 1: oRes=sItem+"\\:([^,\\(]*)";break
			case 2: oRes=sItem+"\\:([^,]*)";break
			default:oRes="([\\W,]*)\\:"+sItem
		}		
		oRes=eval("/"+oRes+"/")
		var oReturn=oRes.exec(sTotal)
		oRes=null
		if(oReturn==null) return sItem1
		return oReturn[1]
	}
	ConstParser.prototype.getGroup=function(sType)
	{
		var sGroup
		switch(sType=sType.toUpperCase())
		{
			case "TER":
			case "SEL":
			case "LIQ":
				sGroup="LIQ"
				break;
			case "TEG":
			case "ETY":
			case "GAS":
				sGroup="GAS"
				break
			default:this.showError("错误的申请类型["+sType+"]！");return sType
		}
		return sGroup
	}
	ConstParser.prototype.parse=function(str1,sType,bFlag)
	{
		str=(","+str1).replace(/,[\w]+\?/g,",")
		var ary=str.match(/\[[^\]]*\]/g)
		if(ary==null) return [str1,str1]
		for(var i=0;i<ary.length;i++)
		{
			sNode=ary[i].replace(/[\[\]]/g,"").split(":")[0]
			try {
				str=str.replace(sNode,this.getParam(sNode,sType,1))
			} catch(e) {this.showError(ary[i])}
		}
		return [str1.replace(/(\?[^,]+|\:[^\],]+|[\[\]])/g,""),str.substring(1)]
	}
	ConstParser.prototype.parse1=function(str,sType,bFlag)
	{
		var ary=str.match(/\[[^\]]*\]/g)
		if(ary==null) return str		
		for(var i=0;i<ary.length;i++)
		{
			sNode=ary[i].replace(/[\[\]]/g,"").split(":")[0]
			try {
				str=str.replace("["+sNode,"["+this.getParam(sNode,sType,1))
			} catch(e) {this.showError(ary[i])}
		}
		return str
	}
	ConstParser.prototype.showError=function(e)
	{
		if(typeof(clear)=="function") clear(e)
		else alert(e)
	}
%>