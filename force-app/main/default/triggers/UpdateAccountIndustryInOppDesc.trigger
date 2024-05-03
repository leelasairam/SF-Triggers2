trigger UpdateAccountIndustryInOppDesc on Opportunity (after insert) {
    List<Opportunity> processOpps = new List<Opportunity>();

    for (Opportunity o : Trigger.New) {
        if (o.AccountId != null) {
            Opportunity opp = new Opportunity(Id = o.Id, Description = o.Account.Industry);
            processOpps.add(opp);
        }
    }

    if (!processOpps.isEmpty()) {
        update processOpps;
    }
}