trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> task=new List<Task>();
    for (Opportunity opp : Trigger.New){
        if (opp.StageName =='Closed Won'){
            task.add(new Task(Subject='Follow Up Test Task',WhatId=opp.Id));
        }
    }
    if(task.size()>0){
        insert task;
    }
        

}