function SelectBox(name,path,scopeName)
{
	this.id=name
	eval("window."+name+"=this")
	if(path==null) path="lib"
	this.path=path
	this.scope=scopeName==null?"FormItem":scopeName
	this.overOptionCss = "background: highlight; color: highlighttext";
	this.sizedBorderCss = "1 inset buttonhighlight";
	
	this.globalSelect;	//This is used when calling an unnamed selectbox with onclick="this.PROPERTY"

	this.ie4 = (document.all != null);
	this.q = 0;
	this.fadeSteps = 4;				// Number of steps to loop
	this.fademsec = 25;				// The time between each step (note that most computer have problem
									// handling to small values due to hardware limitations)
	this.fadeArray = new Array();
}
SelectBox.prototype.getAttribute=function(e,sStyle,sDefault,bCustom)
{
	var flag="tStyle==null"
	var tStyle=e.getAttribute(sStyle)
	if(bCustom!=false) flag="tStyle==null||tStyle==''"
	if(eval(flag)) tStyle=e.style[sStyle]
	if(eval(flag)) tStyle=e.currentStyle[sStyle]
	if(eval(flag)) tStyle=sDefault
	if(!eval(flag)) tStyle=tStyle.replace(/(^['"]|['"]$)/ig,"")
	return tStyle
}
SelectBox.prototype.LoadScript=function(ScriptName,path,lang)	
{
	var scripts=document.getElementsByTagName("SCRIPT")
	if(ScriptName.indexOf(".")==-1) ScriptName+=".js"
	if(path==null) path="lib"
	if(lang==null) lang="javascript"
	path=path.toLowerCase()+"/"+ScriptName.toLowerCase()
	for(var i=0;i<scripts.length;i++)
	{
		var src=scripts[i].src
		if(typeof(src)!="string"||src=="") continue
		if(src.replace(/\\/g,"\/").toLowerCase().indexOf(path)!=-1) return
	}
	var src=document.createElement("<SCRIPT language='"+lang+"' src='"+path+"'><\/SCRIPT>")
	document.all[1].insertBefore(src)
}
SelectBox.prototype.initSelectBox=function(el) {
	this.copySelected(el);
	
	var size = el.getAttribute("size");

// These two lines combined with execution in this.optionClick() allow you to write:
	el.options = el.children[1].children;	
	el.selectedIndex = this.findSelected(el);	//Set the index now!
// Some methods that are supported on the real SELECT box
	el.remove = new Function("i", "this.int_remove(this,i)");
	el.item   = new Function("i", "return this.options[i]");
	el.add    = new Function("e", "i", "this.int_add(this, e, i)");
// The real select box let you have lot of options with the same NAME. In that case the item
// needs two arguments. When using DIVs you can't have two with the same NAME (or ID) and
// then there is no need for the second argument	
	el.options[el.selectedIndex].selected = true;
	dropdown = el.children[1];

	if (size != null) {
		if (size > 1) {
			el.size = size;
			dropdown.style.zIndex = 0;
			this.initSized(el);
		}
		else {
			el.size = 1;
			dropdown.style.zIndex = 99;
			if (dropdown.offsetHeight > 200) {
				dropdown.style.height = "200";
				dropdown.style.overflow = "auto";
			}
		}
	}
	
	this.highlightSelected(el,true);
}

SelectBox.prototype.int_remove=function(el,i) {
	if (el.options[i] != null)
		el.options[i].outerHTML = "";
}

SelectBox.prototype.int_add=function(el, e, i) {
	var html = "<div class='option' noWrap";
	if (e.value != null)
		html += " value='" + e.value + "'";
	if (e.style.cssText != null)
		html += " style='" + e.style.cssText + "'";
	html += ">";
	if (e.text != null)
		html += e.text;
	html += "</div>"

	if ((i == null) || (i >= el.options.length))
		i = el.options.length-1;

	el.options[i].insertAdjacentHTML("AfterEnd", html);
}
	
SelectBox.prototype.initSized=function(el) {
	var h = 0;
	el.children[0].style.display = "none";

	dropdown = el.children[1];
	dropdown.style.visibility = "visible";

	if (dropdown.children.length > el.size) {
		dropdown.style.overflow = "auto";
		for (var i=0; i<el.size; i++) {
			h += dropdown.children[i].offsetHeight;
		}

		if (dropdown.style.borderWidth != null) {
			dropdown.style.pixelHeight = h + 4; //2 * parseInt(dropdown.style.borderWidth);
		}

		else
			dropdown.style.height = h;

	}

	dropdown.style.border = this.sizedBorderCss;


	el.style.height = dropdown.style.pixelHeight;
}

SelectBox.prototype.copySelected=function(el) {
	var selectedIndex = this.findSelected(el);
	selectedCell = el.children[0].rows[0].cells[0];
	selectedDiv  = 	el.children[1].children[selectedIndex];
	
	selectedCell.innerHTML = selectedDiv.outerHTML;
}

// This function returns the first selected option and resets the rest
// in case some idiot has set more than one to selcted :-)
SelectBox.prototype.findSelected=function(el) {
	var selected = null;

	if(el.tagName!="SPAN"||el.className!="select") return
	ec = el.children[1].children;	//the table is the first child
	
	var ecl = ec.length;
	
	for (var i=0; i<ecl; i++) {
		if (ec[i].getAttribute("selected") != null) {
			if (selected == null) {	// Found first selected
				selected = i;
			}
			else
				ec[i].removeAttribute("selected");	//Like I said. Only one selected!
		}
	}
	if (selected == null)
		selected = 0;	//When starting this is the most logic start value if none is present

	return selected;
}

SelectBox.prototype.toggleDropDown=function(el) {
	if (el.size == 1) {
		dropDown = el.children[1];
		
		if (dropDown.style.visibility == "")
			dropDown.style.visibility = "hidden";
			
		if (dropDown.style.visibility == "hidden")
			this.showDropDown(dropDown);
		else
			this.hideDropDown(dropDown);
	}
}

SelectBox.prototype.optionClick=function() {
	el = this.getReal(window.event.srcElement, "className", "option");

	if (el.className == "option") {
		dropdown  = el.parentElement;
		box = dropdown.parentElement;
		//el.children[1].children;	
		oldSelected = dropdown.children[this.findSelected(box)]

		if(oldSelected != el) {
			oldSelected.removeAttribute("selected");
			el.setAttribute("selected", 1);
			box.selectedIndex = this.findSelected(box);
		}		
		if(box.options==null) box.options=box.children[1].children;	
		box.value=box.options[box.selectedIndex].value
		if (box.onchange != null) {	// This executes the onchange when you change the option
			var action=box.onchange
			if(typeof(action)=="string")
			{
				box.onchange=Function(action)
				action=box.onchange			
			}
			if(typeof(action)=="function")
			box.onchange()
		}
		
		if (el.backupCss != null)
			el.style.cssText = el.backupCss;
		this.copySelected(box);
		this.toggleDropDown(box);
		this.highlightSelected(box, true);
	}
}

SelectBox.prototype.optionOver=function(overoption) {
	var toEl = this.getReal(window.event.toElement, "className", "option");
	var fromEl = this.getReal(window.event.fromElement, "className", "option");
	if (toEl == fromEl) return;
	var el = toEl;
	
	if (el.className == "option") {
		if (el.backupCss == null)
			el.backupCss = el.style.cssText;
		this.highlightSelected(el.parentElement.parentElement, false);
		el.style.cssText = el.backupCss + "; " + overoption;
		this.highlighted = true;
	}
}

SelectBox.prototype.optionOut=function() {
	var toEl = this.getReal(window.event.toElement, "className", "option");
	var fromEl = this.getReal(window.event.fromElement, "className", "option");

	if (fromEl == fromEl.parentElement.children[this.findSelected(fromEl.parentElement.parentElement)]) {
		if (toEl == null)
			return;
		if (toEl.className != "option")
			return;
	}
	
	if (toEl != null) {
		if (toEl.className != "option") {
			if (fromEl.className == "option")
				this.highlightSelected(fromEl.parentElement.parentElement, true);
		}
	}
	
	if (toEl == fromEl) return;
	var el = fromEl;

	if (el.className == "option") {
		if (el.backupCss != null)
			el.style.cssText = el.backupCss;
	}

}

SelectBox.prototype.highlightSelected=function(el,add) {
	var selectedIndex = this.findSelected(el);
	
	selected = el.children[1].children[selectedIndex];
	
	if (add) {
		if (selected.backupCss == null)
			selected.backupCss = selected.style.cssText;
		selected.style.cssText = selected.backupCss + "; " + this.overOptionCss;
	}
	else if (!add) {
		if (selected.backupCss != null)
			selected.style.cssText = selected.backupCss;
	}
}

SelectBox.prototype.hideShownDropDowns=function() {
	var el = this.getReal(window.event.srcElement, "className", "select");
	
	var spans = document.all.tags("SPAN");
	var selects = new Array();
	var index = 0;
	
	for (var i=0; i<spans.length; i++) {
		if ((spans[i].className == "select") && (spans[i] != el)) {
			dropdown = spans[i].children[1];
			if ((spans[i].size == 1) && (dropdown.style.visibility == "visible"))
				selects[index++] = dropdown;
		}
	}
	
	for (var j=0; j<selects.length; j++) {
		this.hideDropDown(selects[j]);
	}	

}

SelectBox.prototype.hideDropDown=function(el) {
	if (typeof(fade) == "function")
		this.fade(el, false);
	else
		el.style.visibility = "hidden";
}

SelectBox.prototype.showDropDown=function(el) {
	if (typeof(fade) == "function")
		this.fade(el, true);
	else if (typeof(swipe) == "function")
		swipe(el, 2);
	else
		el.style.visibility = "visible";
}

SelectBox.prototype.initSelectBoxes=function(bFlag) 
{
	if(bFlag==true)
	{
		var tags=document.getElementsByTagName("select")
		for(var i=tags.length-1;i>=0;i--)
		{		
			var e=tags[i]	
			var sResult=this.CreateBox(e)
			if(sResult!=null)
			{		
				var index=e.sourceIndex
				e.outerHTML=sResult
				this.initSelectBox(document.all[index])
			}	
		}
		return
	}	
	var spans = document.all.tags("SPAN");
	var selects = new Array();
	var index = 0;
	
	for (var i=0; i<spans.length; i++) {
		if (spans[i].IsSelectBox == "t")
			selects[index++] = spans[i];
	}
	
	for (var j=0; j<selects.length; j++) {
		this.initSelectBox(selects[j]);
	}	
}

SelectBox.prototype.CreateBox=function(e)
{
	if(e.scopeName!=this.scope) return null
	var Option=this.Option
	var id=(e.id==null?"selectboxes":e.id)
	var style=e.xstyle
	var action=e.onchange
	var size=parseInt(e.size)
	if(isNaN(size)) size=1
	var child=e.children
	var optionArray = new Array();
	var bAllowNull=e.AllowNull
	for(var j=0;j<child.length;j++)
	{
		var e1=child[j]
		if(e1.scopeName!=this.scope||e1.tagName.toLowerCase()!="option") continue
		var selected=e1.selected!=null?"selected":null				
		var value=e1.value==null?"":e1.value
		var text=e1.innerHTML
		style=e1.xstyle
		optionArray[optionArray.length]=new Option(text,value,style,selected)
	}
	return this.writeSelectBox(optionArray,id,size,action,style,e,bAllowNull)	
	
}	

SelectBox.prototype.getReal=function(el, type, value) {
	temp = el;
	while ((temp != null) && (temp.tagName != "BODY")) {
		if (eval("temp." + type) == value) {
			el = temp;
			return el;
		}
		temp = temp.parentElement;
	}
	return el;
}

SelectBox.prototype.writeSelectBox=function(matrix, id, size, onchange, css,e) {
	var d = window.document;
	if (this.ie4) {
		var s = this.createIEString(matrix, id, size, onchange, css,e);
		return s;
	}

	else {
		return this.createXString(matrix, id, size, onchange, css,e);
	}
}

SelectBox.prototype.createIEString=function(matrix, id, size, onchange, css,e,bAllowNull) 
{
		var str = "";
//		Span startTag	
		var select=""
		var selected=""
		var selectTable=""
		var DropDown=""
		var button=""
		var font="icon"
		var option=""
		var sAllowNull=""
		if(bAllowNull=='f') sAllowNull=" bAllowNull='f'"
		var overoption=this.overOptionCss
		if(e!=null)
		{
			font=this.getAttribute(e,"font",font)
			select=this.getAttribute(e,"select",select)
			selected=this.getAttribute(e,"selected",selected)
			button=this.getAttribute(e,"button",button)
			selectTable=this.getAttribute(e,"selectTable",selectTable)
			DropDown=this.getAttribute(e,"DropDown",DropDown)
			option=this.getAttribute(e,"option",option)		
			overoption=this.getAttribute(e,"overoption",overoption)		
		}
		str += '<span class="select" IsSelectBox="t"'+sAllowNull+' style="color:black;width: 100%; font: '+font+'; cursor: default;'+select+'"';
		if (size == null)
			size = 1;			
		str += ' size="' + size + '"';	
		if (id != null)
			str += ' id="' + id + '"';
		if (onchange != null)
			str += ' onchange="' + onchange + '"';
		if (css != null)
			str += ' style="' + css + '"';
		str += '>\n';
	
//		Table Tag
		str += '<table class="selectTable" cellspacing="0" cellpadding="0"\n';
		str += ' onclick="'+this.id+'.toggleDropDown(this.parentElement)"\n';
		str += ' style="color:black;border: 1 inset buttonhighlight; background: buttonface;height: 100%; width: 100%;'+selectTable+'">\n'
		str += '<tr>\n';
		str += '<td class="selected" style="background: window;padding:0;font:'+font+';'+selected+'">&nbsp;</td>\n';
		str += '<td align="CENTER" valign="MIDDLE" class="Button" style="color:black;border:1 outset buttonhighlight;width: 16px; height: 5; font-family: webdings; padding: 0;font-size: 11px;'+button+'"\n';
		str += ' onselectstart="return false" ondragstart="return false"\n'
		str += ' onmousedown="this.style.borderStyle=\'inset\'"\n';
		str += ' onmouseup="this.style.borderStyle=\'outset\'"\n';
		str += ' onmouseout="this.style.borderStyle=\'outset\'">\n';
		str += '<span style="position: relative; left: 0; top: -2; width: 100%;font-family:Webdings">6</span></td>\n';
		str += '</tr>\n';
		str += '</table>\n';
//		DropDown startTag
		str += '<div class="dropDown" style="color:black;border: 1 solid windowtext; background: window;position: absolute; z-index:99;visibility: hidden; width: 100%;padding:0;'+DropDown+'"'
			+' onclick="'+this.id+'.optionClick()" onmouseover="'+this.id+'.optionOver(\''+overoption+'\')" onmouseout="'+this.id+'.optionOut()">\n';
		
		for (var i=0; i<matrix.length; i++) {
			html     = matrix[i].html;
			value    = matrix[i].value;
			css      = matrix[i].css;
			selected = matrix[i].selected;
			
//			Write option starttag
			str += '<div class="option" style="font: '+font+'; padding: 1; padding-left: 3; padding-right: 3; width: 100%;'+option+'"';
			if (value != null)
				str += ' value="' + value + '"';
			if (css != null)
				str += ' style="' + css + '"';
			if (selected != null)
				str += ' selected';
			str += '>\n';
			
//			Write HTML contents
			str += html;
//			Write end tag
			str += '</div>\n';
		}
	
	//DropDown endtag
		str += '</div>\n';
		
	// Span endTag
		str += '</span>\n';
		
	return str;
}

SelectBox.prototype.createXString=function(matrix, id, size, onchange, css) {
//	var str = "\n";
//	form startTag
	var str = '<form>\n';
//	Select startTag
	str += '<select';
	if (size == null)
		size = 1;
	str += ' size="' + size + '"';	
	if (id != null)
		str += ' id="' + id + '"';
	if (onchange != null)
		str += ' onchange="' + onchange + '"';
//	if (css != null)
//		str += ' style="' + css + '"';
	str += '>\n';
//	write options
	for (var i=0; i<matrix.length; i++) {
		html     = matrix[i].html;
		value    = matrix[i].value;
		css      = matrix[i].css;
		selected = matrix[i].selected;
		
//		Write option starttag
		str += '\n<option';
		if (value != null)
			str += ' value="' + value + '"';
//		if (css != null)
//			str += ' style="' + css + '"';
		if (selected != null)
			str += ' selected';
		str += '>';
		
//	Write HTML contents
		str += this.stripTags(html);
//	Write end tag
		str += '</option>\n';
	}
	str += '\n</select>\n';
	str += '</form>\n';

	return str;
}

SelectBox.prototype.stripTags=function(str) {
	var s = 0;
	var e = -1;
	var r = "";

	s = str.indexOf("<",e);	

	do {
		r += str.substring(e + 1,s);
		e = str.indexOf(">",s);
		s = str.indexOf("<",e);
	}
	while ((s != -1) && (e != -1))

	r += str.substring(e + 1,str.length);

	return r;
}

SelectBox.prototype.Option=function(html, value, css, selected) {
	this.html = html;
	this.value = value;
	this.css = css;
	this.selected = selected;
}
SelectBox.prototype.fade=function(el, fadeIn, steps, msec) {

	if (steps == null) steps = this.fadeSteps;
	if (msec == null) msec = this.fademsec;
	
	if (el.fadeIndex == null)
		el.fadeIndex = this.fadeArray.length;
	this.fadeArray[el.fadeIndex] = el;
	
	if (el.fadeStepNumber == null) {
		if (el.style.visibility == "hidden")
			el.fadeStepNumber = 0;
		else
			el.fadeStepNumber = steps;
		if (fadeIn)
			el.style.filter = "Alpha(Opacity=0)";
		else
			el.style.filter = "Alpha(Opacity=100)";
	}
			
	window.setTimeout("this.repeatFade(" + fadeIn + "," + el.fadeIndex + "," + steps + "," + msec + ")", msec);
}

//////////////////////////////////////////////////////////////////////////////////////
//  Used to iterate the fading

SelectBox.prototype.repeatFade=function(fadeIn, index, steps, msec) {	
	el = this.fadeArray[index];
	
	c = el.fadeStepNumber;
	if (el.fadeTimer != null)
		window.clearTimeout(el.fadeTimer);
	if ((c == 0) && (!fadeIn)) {			//Done fading out!
		el.style.visibility = "hidden";		// If the platform doesn't support filter it will hide anyway
//		el.style.filter = "";
		return;
	}
	else if ((c==steps) && (fadeIn)) {	//Done fading in!
		el.style.filter = "";
		el.style.visibility = "visible";
		return;
	}
	else {
		(fadeIn) ? 	c++ : c--;
		el.style.visibility = "visible";
		el.style.filter = "Alpha(Opacity=" + 100*c/steps + ")";

		el.fadeStepNumber = c;
		el.fadeTimer = window.setTimeout("this.repeatFade(" + fadeIn + "," + index + "," + steps + "," + msec + ")", msec);
	}
}