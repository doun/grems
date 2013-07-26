<%
//���ļ����ڱ��������е����ֳ�������������

	function ConstParser() {}
	//����
	ConstParser.prototype.ConstPublic=""+
		"BUCKET_NO:ϵͳ��,"+
		"ID:�ŷŵ���,"+
		"SYS_TYPE:�ŷ�����,"+
		"APPLY_USRID:ǩ����,"+
		"APPLY_DATE:ǩ��ʱ��,"+
		"APPLY_MEMO:��ע,"+
		"SAMPLE_UID:ȡ����,"+
		"SAMPLE_DATE:ȡ��ʱ��,"+
		"SAMPLE_MEMO:������ע,"+
		"NO_CONFLECT:���ŷų�ͻ,"+
		"START_TIME:�ŷſ�ʼʱ��,"+
		"END_TIME:�ŷŽ���ʱ��"
	//Һ��	
	ConstParser.prototype.ConstLIQ=""+
		"LIQUT_ALTITUDE:Һλ(m),"+
		"CYCLE_TIME:ѭ����ʼʱ��,"+
		"PUBNUM1:ϵͳ��,"+
		"PUBNUM2:Һλ(m),"+
		"B:PHֵ,"+
		"Y:Һ���ܦ�(Bq/m<sup>3</sup>),"+
		"TRITIUM:�(Bq/m<sup>3</sup>),"+
		"OKRT901MA:OKRT904MA����,"+
		"Release_Speed:�ŷ�����(m<sup>3</sup>/h),"+
		"Release_liquid:Һλ(m)"
	//TER	
	ConstParser.prototype.ConstTER=""+	
		"BUCKET_NO:�޺�,"+
		"SEC_PUMPS:SEC��̨Ͷ����,"+
		"SEC_STAGES:SEC����Ͷ����,"+
		"CRF_PUMPS:CRF��Ͷ��̨��,"+
		"SEAWATER_FLOW:�ŷ�����ˮ����,"+
		"OKRT901MA:OKRT901MA����,"+
		"PUBNUM1:�޺�"
	//SEL	
	ConstParser.prototype.ConstSEL=""+	
		"BUCKET_NO:�޺�,"+
		"PUBNUM1:�޺�"
	//����	
	ConstParser.prototype.ConstGAS=""+
		"LIQUT_ALTITUDE:��ѹ(Bar),"+
		"PUBNUM1:��Ĥ(m<sup>3</sup>),"+
		"PUBNUM2:�(m<sup>3</sup>),"+
		"B:�����ܦ�(Bq/m<sup>3</sup>),"+
		"Y:�ܦ�(Bq/m<sup>3</sup>),"+
		"TRITIUM:�(Bq/m<sup>3</sup>),"+
		"OKRT901MA:KRT016/017MA����,"+
		"Release_Speed:�ŷ�����(m<sup>3</sup>/h),"+
		"Chimney_Speed:�̴�����(m/s),"+
		"Release_liquid:��ѹ(bar)"

	//TEG	
	ConstParser.prototype.ConstTEG=""+	
		"BUCKET_NO:�޺�,"+
		"LIQUT_ALTITUDE:��ѹ(Bar),"+
		"CYCLE_TIME:��������ʱ��,"+
		"Y:����ܦ�(Bq/m<sup>3</sup>),"+
		"TRITIUM:�(Bq/m<sup>3</sup>)"
	//ETY	
	ConstParser.prototype.ConstETY=""+	
		"BUCKET_NO:��Ӧ�Ѻ�,"+
		"LIQUT_ALTITUDE:��ȫ�Ǿ���ѹ��(mbar),"+	
		"SEAWATER_FLOW:����ѹ��(mbar),"+
		"PUBNUM1:���(m<sup>3</sup>),"+
		"START_USER:������,"+
		"START_DATE:����ʱ��,"+	
		"B:KRT009MA(Bq/m<sup>3</sup>),"+
		"Y:����ܦ�(Bq/m<sup>3</sup>),"+
		"TRITIUM:�(Bq/m<sup>3</sup>),"+
		"Release_liquid:��ȫ��ѹ��(mbar)"
		
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
			default:this.showError("�������������["+sType+"]��");return sType
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