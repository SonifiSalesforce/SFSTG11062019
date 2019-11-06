({
	showInfoToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Info Toast Message',
            message: 'This is Info Toast...!!!',
            duration: '4000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
		toastEvent.fire();
	},
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Success Toast Message',
            message: 'This is Success Toast...!!!',
            duration: '4000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
		toastEvent.fire();
	},
    showErrorToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Error Toast Message',
            message: 'This is Error Toast...!!!',
            messageTemplate: 'Mode is pester, duration is 4sec and Message is overriden',
            duration: '4000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
		toastEvent.fire();
	},
        showWarningToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Warning Toast Message',
            message: 'This is Warning Toast...!!!',
            messageTemplate: 'Mode is sticky, duration is 4sec and Message is overriden because messageTemplateData is {1}',
            duration: '4000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
		toastEvent.fire();
	},
})