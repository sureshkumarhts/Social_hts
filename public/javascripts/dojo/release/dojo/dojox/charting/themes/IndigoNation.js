/*
	Copyright (c) 2004-2008, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["dojox.charting.themes.IndigoNation"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["dojox.charting.themes.IndigoNation"] = true;
dojo.provide("dojox.charting.themes.IndigoNation");
dojo.require("dojox.charting.Theme");

(function(){
	//	notes: colors generated by moving in 30 degree increments around the hue circle,
	//		at 90% saturation, using a B value of 75 (HSB model).
	var dxc=dojox.charting;
	dxc.themes.IndigoNation=new dxc.Theme({
		colors: [
			"#93a4d0",
			"#3b4152",
			"#687291",
			"#9faed9",
			"#8290b8"
		]
	});
})();

}
