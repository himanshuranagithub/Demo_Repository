import { LightningElement } from 'lwc';
export default class ProgressIndicator extends LightningElement {

    steps = [
        { label: 'Dev', value: 'step-1' },
        { label: 'QA', value: 'step-2' },
        { label: 'UAT', value: 'step-3' },
        { label: 'Production', value: 'step-4' },
        { label: 'Integration', value: 'step-5' },
    ];

}