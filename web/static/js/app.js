import {Socket} from "phoenix";
import "phoenix_html";
import {Tabs} from './tabs';

document.addEventListener( 'DOMContentLoaded', () => {
  if ( document.querySelector( '.nav-tabs' ) ) {
    new Tabs();
  }
});
