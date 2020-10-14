import { LightningElement, track } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';

const columns = [
    {label: 'Type', fieldName: 'type', type: 'text'},
    {label: 'Reference Id', fieldName: 'referenceId', type: 'text'},
    {label: 'Source Function', fieldName: 'sourceFunction', type: 'text'},
    {label: 'Message', fieldName: 'message', type: 'text'},
    {label: 'Stack Trace', fieldName: 'stackTrace', type: 'text'}
];

export default class LogTable extends LightningElement {
    @track
    data = [];
    columns = columns;

    channelName = '/event/Log_Message__e';
    subscription = {};

    connectedCallback() {
        this.handleSubscribe();       
        this.registerErrorListener();      
    }

    handleSubscribe() {
        var self = this;
        const messageCallback = function(response) {
            console.log('New message received: ', JSON.stringify(response));
            var msg = response.data.payload;
            self.data = [...self.data, 
                {
                    type: msg.Type__c,
                    referenceId: msg.Reference_Id__c,
                    sourceFunction: msg.Source_Function__c,
                    message: msg.Message__c,
                    stackTrace: msg.Stack_Trace__c
                }
            ];
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}