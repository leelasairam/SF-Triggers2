trigger Update_Account_Owner_upon_inactive on User (after update) {
    set<Id>ProcessUsers = new set<Id>();
    
    for(User u : Trigger.New){
        if(u.IsActive != Trigger.oldMap.get(u.Id).IsActive && u.IsActive == false){
            if(u.ManagerId == null){
                u.addError('User cannot be de-activate if manager is not tagged');
            }
            else{
                ProcessUsers.add(u.Id);
            }
        } 
    }
    
    if(!ProcessUsers.isEmpty()){
        Update_Account_Owner_helper batch = new Update_Account_Owner_helper(ProcessUsers);
        database.executeBatch(batch);
    }
}