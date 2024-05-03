trigger One_Primary_Contact_For_Account on Contact (before insert, before update) {
    
    // Declare Variables
    List<Contact> contacts = Trigger.new;
    list<Contact> processRecords = new list<Contact>();
    list<Contact> errorRecords = new list<Contact>();
    Set<Id> accountIds = new Set<Id>();
    
    // Process lists
    for (Contact contact : contacts) {
        if (contact.Primary_Contact__c && contact.AccountId == null) {
            errorRecords.add(contact);
        } 
        else if (contact.Primary_Contact__c && contact.AccountId != null) {
            
            // Check if there are any multiple primary contacts for single account in bulk data
            if(!accountIds.contains(contact.AccountId)){
                processRecords.add(contact);
                accountIds.add(contact.AccountId);
            }
            else{
                contact.addError('There is already a primary contact in the csv file');
            }
        }
    }

    // Error handling
    if (!errorRecords.isEmpty()) {
        for (Contact errorContact : errorRecords) {
            errorContact.addError('Contact doesn\'t have an Account Id but is marked as Primary Contact');
        }
    }

    // Processing logic
    if (!processRecords.isEmpty()) {
        // Query existing primary contacts for the specified accounts
        List<Contact> existingPrimaryContacts = [SELECT Id, AccountId FROM Contact WHERE Primary_Contact__c = true AND AccountId IN :accountIds];

        // Set to store existing primary contacts by account Id
        set<Id>PrimaryContactAccId = new set<Id>();
        for(Contact ec : existingPrimaryContacts){
            PrimaryContactAccId.add(ec.AccountId);
        }

        // Check for duplicate primary contacts
        for (Contact processContact : processRecords) {
            if (PrimaryContactAccId.contains(processContact.AccountId)) {
                processContact.addError('This contact cannot be the primary contact because there is already a primary contact for the respective account');
            }
        }
    }
}