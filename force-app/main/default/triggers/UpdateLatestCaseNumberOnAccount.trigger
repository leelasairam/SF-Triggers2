trigger UpdateLatestCaseNumberOnAccount on Case (after insert) {
    list<Account>UpdateAccs = new list<Account>();
    
    for(Case c : Trigger.New){
        Account A = new Account();
        A.Id = c.AccountId;
        A.Description = 'Latest case on this account : '+c.CaseNumber+' ('+c.Subject+')';
        UpdateAccs.add(A);
    }
    
    if(!UpdateAccs.isEmpty()){
        Update UpdateAccs;
    }
}