trigger UpdateAnnualRevenueOnAccountWhenOppInserteOrDeleted on Opportunity (after insert, after delete) {
    list<Account>UpdateAccs = new list<Account>();
    
    for(Opportunity op : Trigger.New){
        Account A = new Account();
        A.Id = op.AccountId;
        A.AnnualRevenue += (Decimal)op.Amount; 
        UpdateAccs.add(A);
    }
    
    if(!UpdateAccs.isEmpty()){
        update UpdateAccs;
    }
}