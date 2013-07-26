<SCRIPT LANGUAGE=javascript>
<!--
function FocusWin(oOpener,openStr,sStyle){
//------------------------------------------------------------------
//---功能：用于获取已经打开窗口的焦点-------------------------------
//---参数：oOpener表示打开窗口的句柄,openStr:打开的字符串-----------
//---用法：
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
//--专用函数
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
//--功能：本函数用于屏蔽无效字符的输入------------------------------------
//--参数：isNum(0,1):只允许输入数字,isNum_Char(0,1):只允许输入数字和字母--
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
  
  //if(window.event.keyCode==13){ 去掉回车！
 //	window.event.returnValue =false
 // }
}
function checkTxt(theTxt,theTxtName,iMin,iMax,isNum,isChar_Num){
//------------------------------------------------------------------------
//----本函数用于检查文本框字符的有效性------------------------------------
//----theTxt：ID名称,theTxtName:名称,iMin：最小字符数,iMax：最大字符数----
//----isNum：是否仅为数字(1,0),isCharAndNum：是否仅为字符或数字(1,0)------
//------------------------------------------------------------------------
  if(theTxtName==""){
		theTxtName="此"
  }
  if(iMin>0){
		 if (theTxt.value == "")
		{
		  alert("请在“"+theTxtName+"”域中输入值。");
		  theTxt.focus();
		  return (false);
		}

		if (JStrLen(theTxt.value) < iMin) //考虑到汉字
		{
		  alert("在“"+theTxtName+"” 域中，请至少输入"+iMin+"个字符。");
		  theTxt.focus();
		  return (false);
		}
  }
  if(iMax>0){
		if (JStrLen(theTxt.value) >iMax)  //考虑到汉字
		{
		  alert("在“"+theTxtName+"” 域中，请最多输入"+iMax+"个字符。");
		  theTxt.focus();
		  return (false);
		}
  }  
  if(isNum>0){ 
  //alert("在"+theTxtName+" 域中，只能输入数字。");
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
		  alert("在"+theTxtName+" 域中，只能输入数字。");
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
		    alert("在“"+theTxtName+"”域中，只能输入字符或数据。");
		  theTxt.focus();
		  return (false);
		}
  }
  return (true);
}

function JLTrim(sString)
{	
// -----------------------------------------------------------------------------------
//4.1 本函数用于对sString字符串进行前空格截除
// -----------------------------------------------------------------------------------
	if(sString==null){ return("");}
	if(sString==""){ return("");}
	var i,iStart;
	while (sString.charAt(i)==' ') 
	{
			i++;
			if(i==sString.length){ //表示sString中的所有字符均是空格,则返回空串
			   return("")
			}
	}
	iStart=i;
	return(sString.substring(iStart));
}

function JRTrim(sString)
{	
// -----------------------------------------------------------------------------------
//4.2 本函数用于对sString字符串进行后空格截除
// -----------------------------------------------------------------------------------
	var i,iStart;
	if(sString==null){ return("");}
	if(sString==""){ return("");}
	i=sString.length-1;
	while (sString.charAt(i)==' ') 
	{
			i--;
			if(i==-1){ //表示sString中的所有字符均是空格,则返回空串
			   return("")
			}
	}
	iStart=i+1;
	return(sString.substring(0,iStart));
}

function JStrLen(sString)
{
// -----------------------------------------------------------------------------
//4.3 本函数用于测试字符串sString的长度;
// 注:对本函数来说,1个汉字代表2单位长度;
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
		if (strTemp.indexOf("%u",0) == -1)		// 表示是汉字
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
