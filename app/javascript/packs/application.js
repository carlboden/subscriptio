// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("chartkick")
require("chart.js")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";
import initFlatPicker from "../plugins/flatpickr"


// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import { autocompleteSearch } from "../components/autocomplete"
import { initUpdateNavbarOnScroll } from '../components/navbar';
import { initActivateNavItem } from '../components/navbar';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  initFlatPicker();
  initUpdateNavbarOnScroll();
  initActivateNavItem();

});

import "controllers"
