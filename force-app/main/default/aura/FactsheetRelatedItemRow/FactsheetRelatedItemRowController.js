({
	doInit : function(component, event, helper) {
		var dr = component.get("v.datarow");
        var fs = component.get("v.fieldset");
        if (dr != null && fs != null) {
            for(var i = 0; i < dr.length; i++) {
                for(var j = 0; j < fs.length; j++) {
                    if (dr[i].name == fs[j].name) {
                        dr[i].label = fs[j].label;
                        break;
                    }
                }
            }
            
            component.set("v.datarow", dr);
            console.log('[FactsheetRelatedItemRow.controller.doInit] datarow', dr);
            console.log('[FactsheetRelatedItemRow.controller.doInit] fs', fs);
        }
        
	}
})