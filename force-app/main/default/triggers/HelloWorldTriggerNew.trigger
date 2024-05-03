trigger HelloWorldTriggerNew on Account (before insert) {
    for(Account a : Trigger.New) {
        a.Description = 'New description';
        a.Phone = '9878675645';
    }   
}