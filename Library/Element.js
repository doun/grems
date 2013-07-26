function getAttribute(e,sStyle,sDefault,bCustom)
{
	var flag="tStyle==null"
	var tStyle=e.getAttribute(sStyle)
	if(bCustom!=false) flag="tStyle==null||tStyle==''"
	if(eval(flag)) tStyle=e.style[sStyle]
	if(eval(flag)) tStyle=e.currentStyle[sStyle]
	if(eval(flag)) tStyle=sDefault
	return tStyle
}