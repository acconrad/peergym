export class Tabs {
  constructor(){
    var doc = document
      , tabs = doc.querySelectorAll( '.nav-tabs a' );

    Array.prototype.forEach.call( tabs, tab => {
      tab.addEventListener( 'click', event => {
        Array.prototype.forEach.call( tab.parentNode.parentNode.children, listItem => {
          listItem.classList.remove( 'active' );
          doc.getElementById( listItem.children[0].dataset.tab ).classList.add( 'hidden' );
        });

        tab.parentNode.classList.add( 'active' );
        doc.getElementById( tab.dataset.tab ).classList.remove( 'hidden' );
      });
    });
  }
}
