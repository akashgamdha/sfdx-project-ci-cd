import { LightningElement } from 'lwc';

export default class DemoLWC extends LightningElement {
    connectedCallback() {
        console.log('Demo callback');
    }
}