import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import getAccessToken from '@salesforce/apex/MakeCalloutOAuth.getAccessToken';
import createAccount from '@salesforce/apex/MakeCalloutOAuth.createAccount';

export default class OAuthFlowComponent extends NavigationMixin(LightningElement) {

    authURL = '';

    currentPageReference = null;
    urlStateParameters = null;
    showAuth = true;
    accessToken = false;
    showError = false;
    errorMessage;
    createdAccount = false;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            console.log(this.urlStateParameters);
            if (this.urlStateParameters.code) {
                this.showAuth = false;
            }
        }
    }

    get showAccessToken() {
        return (this.accessToken).substring(0, 18);
    }

    handleClick() {
        
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": "https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9pRzvMkjMb6kEpmq7wptlUtJvzS6joZBxfmYQR2.rUN0Bv_PddbO3y1SeHsv1NzbX4bxggvK1W5Ppmbqo&redirect_uri=https://girikon177-dev-ed.develop.my.site.com"
            }
        });

    }

    handleClickAccess() {
        getAccessToken({ authCode: this.urlStateParameters.code })
            .then(result => {
                console.log(result);
                const obj = JSON.parse(result);
                if (obj.hasOwnProperty('error')) {
                    this.showError = obj['error'];
                    this.errorMessage = obj['error_description'];
                    return;
                }
                this.accessToken = obj['access_token'];
                console.log(this.accessToken);
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleAccountCreation() {
        var inputCmp = this.template.querySelector('.inputCmp');
        var value = inputCmp.value;
        console.log('value', value);

        if (value == '' || value == undefined || value == null) {
            inputCmp.reportValidity();
            return;
        }

        createAccount({ accessToken: this.accessToken, accName: value }).then(result => {
            console.log(result);
            const obj = JSON.parse(result);
            this.createdAccount = obj['id'];
        })
            .catch(error => {
                console.log(error);
            });
    }
}