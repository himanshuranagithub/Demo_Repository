// deploymentPipelineLWC.js
import { LightningElement,api } from 'lwc';

export default class DeploymentPipelineLWC extends LightningElement {
    value = 'inProgress';
    @api orgs

    get options() {
        return [
            { id: 1, label: 'New', value: 'new' },
            { id: 2, label: 'In Progress', value: 'inProgress' },
        ];
    }

    get orgs() {
        return [
            { id: 1, name: 'Dev'},
            { id: 2, name: 'QA'},
            { id: 3, name: 'UAT'},
            { id: null, name: 'Production'},
        ];
    }


        isLastItem(index) {
            return index === this.orgs.length - 1;
        }

    handleChange(event) {
        this.value = event.detail.value;
    }

}