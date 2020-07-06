({
	doInit : function(component, event, helper) {
		helper.getAttachments(component);
	},
    
    toggleSection : function(component, event, helper) {
        var view = component.find("section_panel");
        $A.util.toggleClass(view, "slds-is-open");

        view = component.find("section_content");
        $A.util.toggleClass(view, "slds-hide");
    }
})