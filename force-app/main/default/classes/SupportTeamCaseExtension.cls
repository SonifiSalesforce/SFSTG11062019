//jjackson 11/2019:  code coverage for this extension class is supplied by unit test SupportTeamAccountExtTest.cls

public class SupportTeamCaseExtension {
    
    public Case suppcase {get;set;}
    public Id caseid; 
    public Id acctid;
    public List<User> lstuser {get;set;}
    public ResourcePreference rp = New ResourcePreference();
 
  
    public SupportTeamCaseExtension(ApexPages.StandardController controller) 
    {
        suppcase = (Case)controller.getRecord();
        caseid = suppcase.id;
        Case thiscase = [Select Id, Accountid from Case where id = :caseid LIMIT 1 ];
        acctid = thiscase.accountid;
        
        
        GetSupportTeamMembers();
    }

    public List<User> GetSupportTeamMembers()
    {
        List<User> lstu = New List<User>();
        List<User> lstnewusers = New List<User>();
        List<ResourcePreference> lstpr = New List<ResourcePreference>();
        lstpr = [ Select Id, relatedrecordid, serviceresource.userinfo__c, serviceresource.userinfo__r.profile.name, Account__c, preferencetype from ResourcePreference where
                  relatedrecordid = :acctid and preferencetype = 'Preferred' ];

        if(lstpr.size() == 1){

            rp = lstpr[0];

 
            lstu = [Select Id, name, firstname, lastname, mobilephone, manager.name, manager.firstname, manager.lastname, manager.manager.name, manager.mobilephone, manager.manager.mobilephone, 
                    manager.manager_title__c, manager.manager.manager_title__c, manager.manager.firstname,
                    manager.manager.lastname from User where id = :rp.serviceresource.userinfo__c ];

        }//end if lstpr size

        if(lstu.size() > 0)
        {
            for(User u :lstu)
            {
                
                //system.debug('manager name is ' +u.manager.name);
                //system.debug('upper manager name is ' +u.manager.manager.name);
                system.debug('preferred resource name is ' +u.name);
                
                if(u.manager.manager.name != null)
                {
                    User newu2 = New User();
                    newu2.firstname = u.manager.manager.firstname;
                    newu2.lastname = u.manager.manager.lastname;
                    newu2.manager_title__c = u.manager.manager.manager_title__c;
                    newu2.mobilephone = u.manager.manager.mobilephone;

                    if(newu2.manager_title__c != 'Field Operations VP')
                    { lstnewusers.add(newu2); }
                }

                if(u.manager.name != null)
                {
                    User newu = New User();
                    newu.firstname = u.manager.firstname;
                    newu.lastname = u.manager.lastname;
                    newu.manager_title__c = u.manager.manager_title__c;
                    newu.mobilephone = u.manager.mobilephone;
                    if(newu.manager_title__c != 'Field Operations VP')
                    { lstnewusers.add(newu); }

                }

                if(u.id == rp.serviceresource.userinfo__c)
                {
                    User newu1 = New User();
                    newu1.firstname = u.firstname;
                    newu1.lastname = u.lastname;
                    newu1.manager_title__c = 'Preferred Resource';
                    newu1.mobilephone = u.mobilephone;
                    lstnewusers.add(newu1);
                }

                
            }// end for loop

        }

        lstuser = lstnewusers;
        return lstuser;
    }

  
}