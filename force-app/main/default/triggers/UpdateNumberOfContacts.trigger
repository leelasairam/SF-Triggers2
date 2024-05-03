trigger UpdateNumberOfContacts on Contact (after insert) {
    map<Id,list<Contact>>ProcessContacts = new map<Id,list<Contact>>();
    
    for(Contact c : Trigger.New){
        if(c.AccountId != null){
            if(!ProcessContacts.containsKey(c.AccountId)){
                ProcessContacts.put(c.AccountId,new list<Contact>());
            }
            ProcessContacts.get(c.AccountId).add(c);
        }
    }
    
    if(!ProcessContacts.isEmpty()){
        list<Account>accs = [SELECT Id,NumberOfContacts__c FROM Account WHERE Id IN :ProcessContacts.keySet()];
        for(Account a : accs){
            a.NumberOfContacts__c += ProcessContacts.get(a.Id).size();
        }
 
        if(!accs.isEmpty()){
            update accs;
        }
    }
}