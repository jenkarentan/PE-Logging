public class LogUtil {

    private static String ERROR = 'Error';
    private static String INFO = 'Info';

    public static void logMessage(String referenceId, String sourceFunction, String message) {
        publish(new List<Log_Message__e> { createLog(INFO, referenceId, sourceFunction, message, null) });            
    }

    public static void logError(String referenceId, String sourceFunction, String message, String stackTrace) {    
        publish(new List<Log_Message__e> { createLog(ERROR, referenceId, sourceFunction, message, stackTrace) });        
    }
    
    private static Log_Message__e createLog(String logType, String referenceId, String sourceFunction, String message, String stackTrace) {
        return new Log_Message__e(Type__c = logType, 
            Message__c = message, 
            Reference_Id__c = referenceId, 
            Source_Function__c = sourceFunction, 
            Stack_Trace__c = stackTrace);
    }

    private static void publish(List<Log_Message__e> logMessages) {
        
        List<Database.SaveResult> saveResults = EventBus.publish(logMessages);
        
        for (Database.SaveResult saveResult : saveResults) {
            if (saveResult.isSuccess()) {
                System.debug(LoggingLevel.Info, 'Successfully published log message. Id : ' + saveResult.getId());
            } else {
                for (Database.Error saveError : saveResult.getErrors()) {
                    System.debug(LoggingLevel.Error, 'Error publishing log message. ' +
                        saveError.getStatusCode() + ' - ' + saveError.getMessage());
                }
            }
        }
    }

}