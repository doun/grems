
	String.prototype.getLength=function()
	{
		return this.replace(/[^\x00-\xff]/g,"**").length
	}
	String.prototype.Trim=function()
	{
		return this.replace(/(^\s|\s$)*/g,"")
	}
	String.prototype.toInt=function()
	{
		var iValue=parseInt(this.replace(/[^\d]*/g,""))
		return isNaN(iValue)?0:iValue	
	}
	