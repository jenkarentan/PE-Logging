public class LogMessageHandler {

    public static void handleLogMessages(List<Log_Message__e> logMessages) {
        List<Log__c> logs = new List<Log__c>();
        
        for (Log_Message__e logMessage : logMessages) {

            Id logRecordTypeId = String.isNotBlank(logMessage.Type__c) ? 
                Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName().get(logMessage.Type__c).getRecordTypeId() : null;

            logs.add(new Log__c(
                Message__c = logMessage.Message__c,
                Reference_Id__c = logMessage.Reference_Id__c,
                Source_Function__c = logMessage.Source_Function__c,
                Stack_Trace__c = logMessage.Stack_Trace__c,
                RecordTypeId = logRecordTypeId));
        }
        
        if (!logs.isEmpty()) insert logs;
    }

}