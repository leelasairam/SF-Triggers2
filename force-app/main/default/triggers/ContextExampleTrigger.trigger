trigger ContextExampleTrigger on Account (before insert, after insert, after delete) {
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            system.debug('Trigger : Inserted Before');
        } else if (Trigger.isAfter) {
            system.debug('Trigger : Inserted After');
        }        
    }
    else if (Trigger.isDelete) {
        system.debug('Trigger : Deleted');
    }
}