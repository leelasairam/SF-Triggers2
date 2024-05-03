trigger UpdateAccountRatingBasedOnClosedCases on Case (before insert,after update) {
    if(Trigger.isBefore){
        if(Trigger.IsInsert){
            for(Case c : Trigger.New){
                if(c.Status == 'Closed'){
                    c.addError('Cannot create a case with status closed.');
                }
            }
        }
    }
    
    if(Trigger.IsAfter && Trigger.IsUpdate){
        set<Id>ProcessAccountIds = new set<Id>();
        for(Case i : Trigger.New){
            if(i.AccountId != null && i.Status != Trigger.oldMap.get(i.Id).Status){
                ProcessAccountIds.add(i.AccountId);
            }
        }
        if(!ProcessAccountIds.isEmpty()){
            //Method 1

            /*list<Account>accs = [SELECT Id,Rating,(SELECT Id FROM Cases WHERE Status = 'Closed') FROM Account WHERE Id IN :ProcessAccountIds];
            Integer CasesSize;
            for(Account a : accs){
                CasesSize = a.Cases.size();
                if(CasesSize>=5){
                    a.rating = 'Hot';
                }
                else if(CasesSize>=2 && CasesSize<5){
                    a.Rating = 'Warm';
                }
                else{
                    a.Rating = 'Cold';
                }
            }
            update accs;*/

            //Method 2
            
            list<Case>CaseList = [SELECT Id, AccountId FROM Case WHERE Status = 'Closed' AND AccountId IN :ProcessAccountIds];
            Map<Id,list<Id>> CaseMap = new Map<Id,list<Id>>();
            for(Case j : CaseList){
                if(!CaseMap.containsKey(j.AccountId)){
                    CaseMap.put(j.AccountId,new list<Id>());
                }
                CaseMap.get(j.AccountId).add(j.Id);
            }
            list<Account>UpdateAccount = new list<Account>();
            Integer CasesSize;
            for(Id k : CaseMap.keySet()){
                CasesSize = CaseMap.get(k).size();
                Account acc = new Account();
                acc.Id = k;
                if(CasesSize>=5){
                    acc.rating = 'Hot';
                }
                else if(CasesSize>=2 && CasesSize<5){
                    acc.Rating = 'Warm';
                }
                else{
                    acc.Rating = 'Cold';
                }
                UpdateAccount.add(acc);
            }
            update UpdateAccount;
        }
    }
}