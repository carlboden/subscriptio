// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "wrapper" ]

  connect() {
    // console.log("controller connected !");
  }
  fetchPlans(e) {
    let software_id = e.target.value;
    fetch(`/softwares/${software_id}/select_plans`).then( data => data.json() ).then( ( data ) => { 
        this.wrapperTarget.innerHTML = data.html_string
     } )
  }
}
