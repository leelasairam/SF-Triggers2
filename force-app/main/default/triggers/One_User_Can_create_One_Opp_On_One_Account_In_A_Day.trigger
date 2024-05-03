trigger One_User_Can_create_One_Opp_On_One_Account_In_A_Day on Opportunity (before insert) {
    Set<Id> accIds = new Set<Id>();

    for (Opportunity o : Trigger.New) {
        accIds.add(o.AccountId);
    }

    if (!accIds.isEmpty()) {
        Datetime dt = DateTime.now().addHours(-24);

        // Query existing Opportunities
        List<Opportunity> oppsByUsernDate = [SELECT Id, AccountId, CreatedDate FROM Opportunity WHERE AccountId IN :accIds AND CreatedById = :UserInfo.getUserId() AND CreatedDate >= :dt];

        // Set to store existing Opportunities per AccountId
        Set<Id> existingOppsId = new Set<Id>();
        for (Opportunity existingOpp : oppsByUsernDate) {
            existingOppsId.add(existingOpp.AccountId);
        }

        // Check each Opportunity in Trigger.New
        for (Opportunity newOpp : Trigger.New) {
            // If an existing Opportunity is found for the Account and criteria, add an error
            if (existingOppsId.contains(newOpp.AccountId)) {
                newOpp.addError('You can create one opportunity for one account in the span of 24 hours.');
            }
        }
    }
}