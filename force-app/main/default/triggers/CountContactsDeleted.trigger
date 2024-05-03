trigger CountContactsDeleted on Contact (after delete) {
    //create variables
    map<Id,list<Id>>process_contacts = new map<Id,list<Id>>();
    list<Account>process_accounts = new list<Account>();
    
    //add Contact.AccountId as key and Contact.Id as value to the map
    for(Contact c : Trigger.Old){
        if(c.AccountId!=null){
            //check AccountId is already available in map or not
            if(!process_contacts.containsKey(c.AccountId)){
                process_contacts.put(c.AccountId,new list<Id>{c.Id});
            }
            //if available get the value (list) by passing key (c.AccountId) and add the contact id to the list
            else{
                process_contacts.get(c.AccountId).add(c.Id);
            }
        }
    }
    
    if(process_contacts.size()>0){
        //query the accounts using process_contacts.keySet()
        process_accounts = [SELECT Id,Contacts_Deleted__c FROM Account WHERE Id IN : process_contacts.keySet()];
        for(Account a : process_accounts){
            //get the list size by passing a.Id and add value to current value
            a.Contacts_Deleted__c += process_contacts.get(a.Id).size();
        }
        update process_accounts;
    }
}