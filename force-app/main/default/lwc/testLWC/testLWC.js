import { LightningElement } from 'lwc';

export default class TestLWC extends LightningElement {
  connectedCallback() {
    console.log('Hi from connectedCallback');
    console.log('Another Hi');
  }
}
