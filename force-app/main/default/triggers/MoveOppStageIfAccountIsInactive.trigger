trigger MoveOppStageIfAccountIsInactive on Account (after update) {
    set<Id>ProcessAccounts = new set<Id>();
    
    for(Account a : Trigger.New){
        if(Trigger.OldMap.get(a.Id).Active__c != a.Active__c && a.Active__c == 'No'){
            ProcessAccounts.add(a.Id);
        }
    }
    
    if(!ProcessAccounts.IsEmpty()){
        list<Opportunity>Opps = [SELECT Id,StageName FROM Opportunity WHERE AccountId IN :ProcessAccounts AND StageName != 'Closed Won'];
        if(!Opps.IsEmpty()){
            for(Opportunity o : Opps){
                o.StageName = 'Closed Lost';
            }
            update Opps;
        }
    }
}