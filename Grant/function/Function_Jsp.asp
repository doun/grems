<SCRIPT LANGUAGE=javascript>
<!--
function FocusWin(oOpener,openStr,sStyle){
//------------------------------------------------------------------
//---���ܣ����ڻ�ȡ�Ѿ��򿪴��ڵĽ���-------------------------------
//---������oOpener��ʾ�򿪴��ڵľ��,openStr:�򿪵��ַ���-----------
//---�÷���
//var oOpener1
//sStyle="left=120,top=150,height=230,width=400,center=1,scroll=0,status=0,directories=0,channelmode=0"
//oOpener1=FocusWin(oOpener1,URL,sStyle)
//---------------------------------------------------------------
	try{	
		if (oOpener != null){
			oOpener.focus();
	     }else{
		    oOpener=window.open(openStr,"s",sStyle);
	    	oOpener.focus();
	    }
	 }catch(exceptionl){
		oOpener=window.open(openStr,"s",sStyle);
	 }
	return oOpener
	 }
 
function Add_to_TxtBox(NCA_TOP,NCA_TOP_NAME,NCA_CLASS,NCA_CLASS_NAME,NCA_MID_CLASS,NCA_MID_CLASS_NAME,NCA_SMALL_CLASS,NCA_SMALL_CLASS_NAME,NCA_TINY_CLASS,NCA_TINY_CLASS_NAME){
//--ר�ú���
	parent.window.iFr_change.window.fm_class_change.CODE_TOP.value =NCA_TOP;
	parent.window.iFr_change.window.fm_class_change.CODE_TOP_NAME.value =NCA_TOP_NAME;
	parent.window.iFr_change.window.fm_class_change.CODE_CLASS.value =NCA_CLASS;
	parent.window.iFr_change.window.fm_class_change.CODE_CLASS_NAME.value =NCA_CLASS_NAME;
	parent.window.iFr_change.window.fm_class_change.CODE_MID_CLASS.value =NCA_MID_CLASS;
	parent.window.iFr_change.window.fm_class_change.CODE_MID_CLASS_NAME.value =NCA_MID_CLASS_NAME;	
	parent.window.iFr_change.window.fm_class_change.CODE_SMALL_CLASS.value =NCA_SMALL_CLASS;
	parent.window.iFr_change.window.fm_class_change.CODE_SMALL_CLASS_NAME.value =NCA_SMALL_CLASS_NAME;	
	parent.window.iFr_change.window.fm_class_change.CODE_TINY_CLASS.value =NCA_TINY_CLASS;
	parent.window.iFr_change.window.fm_class_change.CODE_TINY_CLASS_NAME.value =NCA_TINY_CLASS_NAME;	
}

function txt_onkeypress(isNum,isNum_Char) {
//------------------------------------------------------------------------
//--���ܣ�����������������Ч�ַ�������------------------------------------
//--������isNum(0,1):ֻ������������,isNum_Char(0,1):ֻ�����������ֺ���ĸ--
//------------------------------------------------------------------------
  if(isNum){
	if((window.event.keyCode<48)||(window.event.keyCode>57) ){
	   window.event.returnValue =false
	}
  }
 if(isNum_Char){
	if((window.event.keyCode<48)||((window.event.keyCode>57)&&(window.event.keyCode<65))||((window.event.keyCode>90)&&(window.event.keyCode<97))||(window.event.keyCode>122)){
	   window.event.returnValue =false
	}
  }
  
  //if(window.event.keyCode==13){ ȥ���س���
 //	window.event.returnValue =false
 // }
}
function checkTxt(theTxt,theTxtName,iMin,iMax,isNum,isChar_Num){
//------------------------------------------------------------------------
//----���������ڼ���ı����ַ�����Ч��------------------------------------
//----theTxt��ID����,theTxtName:����,iMin����С�ַ���,iMax������ַ���----
//----isNum���Ƿ��Ϊ����(1,0),isCharAndNum���Ƿ��Ϊ�ַ�������(1,0)------
//------------------------------------------------------------------------
  if(theTxtName==""){
		theTxtName="��"
  }
  if(iMin>0){
		 if (theTxt.value == "")
		{
		  alert("���ڡ�"+theTxtName+"����������ֵ��");
		  theTxt.focus();
		  return (false);
		}

		if (JStrLen(theTxt.value) < iMin) //���ǵ�����
		{
		  alert("�ڡ�"+theTxtName+"�� ���У�����������"+iMin+"���ַ���");
		  theTxt.focus();
		  return (false);
		}
  }
  if(iMax>0){
		if (JStrLen(theTxt.value) >iMax)  //���ǵ�����
		{
		  alert("�ڡ�"+theTxtName+"�� ���У����������"+iMax+"���ַ���");
		  theTxt.focus();
		  return (false);
		}
  }  
  if(isNum>0){ 
  //alert("��"+theTxtName+" ���У�ֻ���������֡�");
       	var checkOK = ".0123456789-,";
		var checkStr = theTxt.value;
		var allValid = true;
		var decPoints = 0;
		var allNum = "";
		if(checkStr==""){checkStr=" ";}
		for (i = 0;  i < checkStr.length;  i++)
		{
		  ch = checkStr.charAt(i);
		  for (j = 0;  j < checkOK.length;  j++)
		    if (ch == checkOK.charAt(j))
		      break;
		  if (j == checkOK.length)
		  {
		    allValid = false;
		    break;
		  }
		  if (ch != ",")
		    allNum += ch;
		}
		if (!allValid)
		{
		  alert("��"+theTxtName+" ���У�ֻ���������֡�");
		  theTxt.focus();
		  return (false);
		}
  }
  if(isChar_Num>0){
		var checkOK = ".0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		var checkStr = theTxt.value;
		var allValid = true;
		for (i = 0;  i < checkStr.length;  i++)
		{
		  ch = checkStr.charAt(i);
		  for (j = 0;  j < checkOK.length;  j++)
		    if (ch == checkOK.charAt(j))
		      break;
		  if (j == checkOK.length)
		  {
		    allValid = false;
		    break;
		  }
		}
		if (!allValid)
		{
		    alert("�ڡ�"+theTxtName+"�����У�ֻ�������ַ������ݡ�");
		  theTxt.focus();
		  return (false);
		}
  }
  return (true);
}

function JLTrim(sString)
{	
// -----------------------------------------------------------------------------------
//4.1 ���������ڶ�sString�ַ�������ǰ�ո�س�
// -----------------------------------------------------------------------------------
	if(sString==null){ return("");}
	if(sString==""){ return("");}
	var i,iStart;
	while (sString.charAt(i)==' ') 
	{
			i++;
			if(i==sString.length){ //��ʾsString�е������ַ����ǿո�,�򷵻ؿմ�
			   return("")
			}
	}
	iStart=i;
	return(sString.substring(iStart));
}

function JRTrim(sString)
{	
// -----------------------------------------------------------------------------------
//4.2 ���������ڶ�sString�ַ������к�ո�س�
// -----------------------------------------------------------------------------------
	var i,iStart;
	if(sString==null){ return("");}
	if(sString==""){ return("");}
	i=sString.length-1;
	while (sString.charAt(i)==' ') 
	{
			i--;
			if(i==-1){ //��ʾsString�е������ַ����ǿո�,�򷵻ؿմ�
			   return("")
			}
	}
	iStart=i+1;
	return(sString.substring(0,iStart));
}

function JStrLen(sString)
{
// -----------------------------------------------------------------------------
//4.3 ���������ڲ����ַ���sString�ĳ���;
// ע:�Ա�������˵,1�����ִ���2��λ����;
// -----------------------------------------------------------------------------
	var sStr,iCount,i,strTemp ;
	if (sString==null){
	return 0;
	}
	iCount = 0 ;
	sStr = sString.split("");
	for (i = 0 ; i < sStr.length ; i ++)
	{
		strTemp = escape(sStr[i]);	
		if (strTemp.indexOf("%u",0) == -1)		// ��ʾ�Ǻ���
		{ 
			iCount = iCount + 1 ;
		}	
		else 
		{
			iCount = iCount + 2 ;
		}
	}
	return iCount ;
}

//-->
</SCRIPT>
