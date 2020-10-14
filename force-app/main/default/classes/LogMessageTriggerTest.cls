@IsTest
public class LogMessageTriggerTest {
    @IsTest
    static void logMessageTest(){

        List<Log_Message__e> logMessages = new List<Log_Message__e>{
            new Log_Message__e(Type__c = 'Info', 
                Message__c = 'message', 
                Reference_Id__c = 'info-refId', 
                Source_Function__c = 'sourceFunction'),
            new Log_Message__e(Type__c = 'Error', 
                Message__c = 'Error message', 
                Reference_Id__c = 'error-refId', 
                Source_Function__c = 'sourceFunction', 
                Stack_Trace__c = 'stackTrace')
        };
        
        Test.startTest();
        
        EventBus.publish(logMessages);

        Test.stopTest();

        Log__c infoLogCreated = [SELECT Id, RecordTypeId FROM Log__c WHERE Reference_Id__c = 'info-refId' LIMIT 1];
        Log__c errorLogCreated = [SELECT Id, RecordTypeId FROM Log__c WHERE Reference_Id__c = 'error-refId' LIMIT 1];        
        System.assert(infoLogCreated != null);
        System.assert(errorLogCreated != null);

        Id infoLogRTId = Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName().get('Info').getRecordTypeId();
        Id errorLogRTId = Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName().get('Error').getRecordTypeId();
        System.assertEquals(infoLogRTId, infoLogCreated.RecordTypeId);
        System.assertEquals(errorLogRTId, errorLogCreated.RecordTypeId);
        
    }
}
