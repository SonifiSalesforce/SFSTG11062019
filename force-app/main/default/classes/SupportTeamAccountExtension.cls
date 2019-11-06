public class SupportTeamAccountExtension {
    
    public Account acc {get;set;}
    public Id acctid; 
     public List<User> lstuser {get;set;}
 
  
    public SupportTeamAccountExtension(ApexPages.StandardController controller) 
    {
        acc = (Account)controller.getRecord();
        acctid = acc.id;
        GetSupportTeamMembers();
    }

    public List<User> GetSupportTeamMembers()
    {
        List<User> lstu = New List<User>();
        List<User> lstnewusers = New List<User>();
        List<ResourcePreference> lstpr = New List<ResourcePreference>();
        lstpr = [ Select Id, relatedrecordid, serviceresource.userinfo__c, serviceresource.userinfo__r.profile.name, Account__c, preferencetype from ResourcePreference where
                  relatedrecordid = :acc.id and preferencetype = 'Preferred' ];

        if(lstpr.size() == 1){

            ResourcePreference rp = lstpr[0];

 
            lstu = [Select Id, name, manager.name, manager.firstname, manager.lastname, manager.manager.name, manager.mobilephone, manager.manager.mobilephone, 
                    manager.manager_title__c, manager.manager.manager_title__c, manager.manager.firstname,
                    manager.manager.lastname from User where id = :rp.serviceresource.userinfo__c ];

        }//end if lstpr size

        if(lstu.size() > 0)
        {
            for(User u :lstu)
            {
                
                //system.debug('manager name is ' +u.manager.name);
                //system.debug('upper manager name is ' +u.manager.manager.name);
                
                if(u.manager.manager.name != null)
                {
                    User newu2 = New User();
                    newu2.firstname = u.manager.manager.firstname;
                    newu2.lastname = u.manager.manager.lastname;
                    newu2.manager_title__c = u.manager.manager.manager_title__c;
                    newu2.mobilephone = u.manager.manager.mobilephone;
                    lstnewusers.add(newu2);
                }

                if(u.manager.name != null)
                {
                    User newu = New User();
                    newu.firstname = u.manager.firstname;
                    newu.lastname = u.manager.lastname;
                    newu.manager_title__c = u.manager.manager_title__c;
                    newu.mobilephone = u.manager.mobilephone;
                    lstnewusers.add(newu);

                }

                
            }// end for loop

        }

        lstuser = lstnewusers;
        return lstuser;
    }

  
}