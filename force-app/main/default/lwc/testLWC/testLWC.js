import { LightningElement } from 'lwc';

export default class TestLWC extends LightningElement {
  connectedCallback() {
    console.log("connectedCallback called");
  }
}
