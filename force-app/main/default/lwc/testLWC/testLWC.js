import { LightningElement } from 'lwc';

export default class TestLWC extends LightningElement {
  connectedCallback() {
    console.log('Hi from connectedCallback');
  }

  renderedCallback() {
    console.log('Hi from render');
  }
}
