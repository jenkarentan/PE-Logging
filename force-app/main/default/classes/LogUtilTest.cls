@IsTest
public class LogUtilTest {
    @IsTest
    static void logMessageTest(){
        
        Test.startTest();
        
        LogUtil.logMessage('info-refId', 'sourceFunction', 'message');

        Test.stopTest();

        Log__c infoLogCreated = [SELECT Id, RecordTypeId FROM Log__c WHERE Reference_Id__c = 'info-refId' LIMIT 1];
        System.assert(infoLogCreated != null);

        Id infoLogRTId = Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName().get('Info').getRecordTypeId();
        System.assertEquals(infoLogRTId, infoLogCreated.RecordTypeId);        
    }

    @IsTest
    static void logErrorTest(){
        
        Test.startTest();
        
        LogUtil.logError('error-refId', 'sourceFunction', 'message', 'stackTrace');

        Test.stopTest();

        Log__c errorLogCreated = [SELECT Id, RecordTypeId FROM Log__c WHERE Reference_Id__c = 'error-refId' LIMIT 1];
        System.assert(errorLogCreated != null);

        Id errorLogRTId = Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName().get('Error').getRecordTypeId();
        System.assertEquals(errorLogRTId, errorLogCreated.RecordTypeId);                
    }
}
