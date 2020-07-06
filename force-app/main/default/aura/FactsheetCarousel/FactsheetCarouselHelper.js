({
	getAttachments : function(component) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getAttachmentsForRecord");
        action.setParams({
            "recordId" : recordId,
        });
        action.setCallback(this, function(response){
            var callState = response.getState();
            console.log('[FactsheetCarousel.helper.getAttachments] getAttachmentsForRecord action callback returned with state', callState);
            
            if (component.isValid()) {
                if (callState === "SUCCESS") {
                    try {                        
    	                var attachments = response.getReturnValue();
	                    console.log('[FactsheetCarousel.helper.getAttachments] returnmsg', attachments);
                        if (attachments == null) { attachments = []; }
                        /*
                        var images = [];
                        for(var i = 0; i < attachments.length; i++) {
                            if (attachments[i].attachment.ContentType.indexOf('image') < 0) {
                                images.push(attachments[i].attachment);
                            } else {
                                var img = {};
                                img.alt = attachments[i].name;
                                img.src = 'data:image/png;base64,'+attachments[i].src;
                                images.push(img);
                            }
                        }
                        console.log('[FactsheetCarousel.helper.getAttachments] images', images);
                        */
                        component.set("v.attachments", attachments);
                        component.set("v.attachmentCount", attachments.length);
                    } catch(ex1) {
                        console.log('[FactsheetCarousel.helper.getAttachments] exception', ex1);
                    }
                    
                } else if (callState === "INCOMPLETE") {
                    console.log('[FactsheetCarousel.helper.getAttachments] callback state is incomplete');    
                } else if (callState === "ERROR") {
                    var errors = response.getError();
                    console.log('[FactsheetCarousel.helper.getAttachments] callback returned errors. ', errors);                    
                    component.set("v.errors", errors);                    
                }
            }
            
        });
        $A.enqueueAction(action);
		
	}
})