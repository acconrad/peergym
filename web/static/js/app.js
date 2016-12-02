import {Socket} from "phoenix";
import "phoenix_html";
import {Maps} from './map';
import {Tabs} from './tabs';

document.addEventListener( 'DOMContentLoaded', () => {
  if ( document.getElementById( 'map-canvas' ) ) {
    new Maps();
  }

  if ( document.querySelector( '.nav-tabs' ) ) {
    new Tabs();
  }
});
