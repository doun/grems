<!--#include file="../include/flowsv.asp"-->
<%	
	cn.begin()	
		rStatus("ISA",iSpecial)
		setUser("SAL")		
		var oDom=rp.oDoc.firstChild.firstChild.childNodes //ȡ��DATA�ڵ�������ӽڵ�ļ���			
		var str=""
		for(var i=0;i<oDom.length;i++)
		{
			var sName=oDom[i].nodeName
			if(sName=="�ŷŵ���") break	
			if(i!=0) str+=","
			var sText="'"+oDom[i].text+"'"
			if(sName=="SCALE_MEMO") sText=rp.parse("["+sName+":s]")
			str+=sName+"="+sText
		}
		str+=",SCALE_ID="+rp.parse("[__USER_NAME:s]")+",SCALE_DATE=SYSDATE"+rSpecial
		if(sType=="TER"||sType=="SEL"||sType=="LIQ")
			str+=",CURRENT_DIVIDE='"+oParamList[sType+"_Y"]+"'"
		str="UPDATE "+sDBOwner+".GREMS_SCALE SET "+str+" WHERE ID="+sID	
		cn.Execute(str)	
	cn.end()	
	over()
%>