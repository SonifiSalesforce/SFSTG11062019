trigger StandardServiceAppointmentTrigger on ServiceAppointment (before insert, before update, after insert, after update) {

    //jjackson--check to see if trigger is turned off via the custom setting
    try{ 
    	if(AppConfig__c.getValues('Global').BlockTriggerProcessing__c) {
    		return;
    	} else if(ServiceAppointmentTriggerConfig__c.getValues('Global').BlockTriggerProcessing__c) {
			return; 
		}
    }
    catch (Exception e) {}

if(trigger.isBefore)
{
    if(trigger.isInsert)
    {  StandardServiceAppointmentTriggerLogic.PopulateAccountandSiteSurveyInfo(trigger.new); 
       StandardServiceAppointmentTriggerLogic.TechnicianAssignedUpdatesOwnership(trigger.new, 'Insert', trigger.oldmap);
    }

    if(trigger.isUpdate)
    {
        StandardServiceAppointmentTriggerLogic.PopulateGanttLabel(trigger.new);
        StandardServiceAppointmentTriggerLogic.TechnicianAssignedUpdatesOwnership(trigger.new, 'Update', trigger.oldmap);
        StandardServiceAppointmentTriggerLogic.UpdateScheduledEndfromDuration(trigger.new, trigger.oldmap);
        StandardServiceAppointmentTriggerLogic.ChangeScheduledEndDatetoActual(trigger.new, trigger.oldMap);
    }
}

if(trigger.isAfter)
{
    if(trigger.isInsert)
    {
        StandardServiceAppointmentTriggerLogic.ChangeFWOOwnershiptoQueue(trigger.new);
    }

    if(trigger.isUpdate)
    {   
        List<ServiceAppointment> lstsa = New List<ServiceAppointment>();
        for(ServiceAppointment s :trigger.new)
        {
            if(s.create_follow_up__c == true && trigger.oldMap.get(s.id).create_follow_up__c == false)
            {
                lstsa.add(s);
            }
        }
        StandardServiceAppointmentTriggerLogic.PopulateFWODatefromSA(trigger.new, trigger.oldMap);
        StandardServiceAppointmentTriggerLogic.PopulateSiteSurveyScheduleDate(trigger.new, trigger.oldMap);
        StandardServiceAppointmentTriggerLogic.SurveyAppointmentCompleted(trigger.new, trigger.oldMap);
        StandardServiceAppointmentTriggerLogic.CreateFollowUpAppointment(lstsa);
    }
}

}