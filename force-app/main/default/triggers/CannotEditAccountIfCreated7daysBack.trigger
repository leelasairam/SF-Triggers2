trigger CannotEditAccountIfCreated7daysBack on Account (before update) {
    set<Id> ProcessAccounts = new set<Id>();
    
    for(Account a : Trigger.New){
        Long Diff = (DateTime.now().getTime() - a.CreatedDate.getTime())/1000/60/60/24;
        if(Diff < 7){
            a.addError('You can edit only accounts created 7+ days back. The current account created '+Diff+' days back only.');
        }
    }
}