import flatpickr from "flatpickr";
import monthSelectPlugin from 'flatpickr/dist/plugins/monthSelect';

import 'flatpickr/dist/plugins/monthSelect/style.css' ;
const initFlatPicker = () => { 
  if (document.querySelector(".datepicker") ){
    flatpickr(".datepicker", {
        static: true,
        altInput: true,
        plugins: [
            new monthSelectPlugin({
              shorthand: true, //defaults to false
              dateFormat: "m.y", //defaults to "F Y"
              altFormat: "F Y", //defaults to "F Y"
              theme: "dark" // defaults to "light"
            })
        ]
    });
  }
}

export default initFlatPicker;