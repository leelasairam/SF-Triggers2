trigger Contacts_to_be_created_on_acc_created on Account (after insert) {
    list<Account>process_accs = new list<Account>();
    list<Contact>process_contacts = new list<Contact>();
    for(Account a : Trigger.New){
        process_accs.add(a);
    }
    
    if(process_accs.size()>0){
        for(Account acc : process_accs){
            if(acc.NumberofLocations__c!=null){
                for(Integer i=0;i<acc.NumberofLocations__c;i++){
                    Contact c = new Contact(LastName='contact ' + (i+1),AccountId=acc.Id);
                    process_contacts.add(c);
                }
            }
        }
    }
    
    if(process_contacts.size()>0){
        insert process_contacts;
    }
}