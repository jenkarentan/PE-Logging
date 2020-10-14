trigger LogMessageTrigger on Log_Message__e (after insert) {
    LogMessageHandler.handleLogMessages(Trigger.new);
}