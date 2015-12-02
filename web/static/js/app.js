import {Socket} from "deps/phoenix/web/static/js/phoenix";
import "deps/phoenix_html/web/static/js/phoenix_html";
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
