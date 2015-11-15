export class Maps {
  constructor(){
    var pageFolder = document.body.className;

    google.maps.event.addDomListener( window, 'load', this.initializeSearch );

    if ( pageFolder.match( /gym index/ ) ) {
      google.maps.event.addDomListener( window, 'load', this.initializeMap );
    }
  }

  initializeMap(){
    var doc = document
      , canvas = doc.getElementById( 'map-canvas' )
      , infoWindow = new google.maps.InfoWindow()
      , map;

    new google.maps.Geocoder().geocode( { 'placeId': canvas.dataset.placeId }, (results, status) => {
      if ( status === google.maps.GeocoderStatus.OK ) {
        if ( results[0] ) {
          map = new google.maps.Map( canvas, {
            center: results[0].geometry.location
          , zoom: 11
          , disableDefaultUI: true
          , draggable: false
          , zoomControl: false
          , scrollwheel: false
          , disableDoubleClickZoom: true
          , styles: [
              {
                stylers: [
                  { visibility: 'simplified' }
                ]
              }
            , {
                elementType: 'labels'
              , stylers: [
                  { visibility: 'off' }
                ]
              }
            ]
          });

          google.maps.event.addListenerOnce( map, 'bounds_changed', () => {
            Array.prototype.forEach.call( document.querySelectorAll( '.gym-item' ), gym => {
              new google.maps.Marker({
                map: map
              , position: { lat: +gym.dataset.latitude , lng: +gym.dataset.longitude } });
            });
          });
        } else {
          return false;
        }
      } else {
        return false;
      }
    });
  }

  initializeSearch(){
    var doc = document
      , locations = doc.querySelectorAll( '.form-gym-location' )
      , forms = doc.querySelectorAll( '.form-gym-search' );

    Array.prototype.forEach.call( locations, location => {
      new google.maps.places.Autocomplete( location );
    });

    Array.prototype.forEach.call( forms, form => {
      form.addEventListener( 'submit', event => {
        event.preventDefault();
        new google.maps.Geocoder().geocode( { 'address': form.querySelector('.form-gym-location').value }, (results, status) => {
          var result, latlng;
          if ( status === google.maps.GeocoderStatus.OK ) {
            result = results[0];
            latlng = result.geometry.location.toString().slice(1,-1).split(', ');
            form.querySelector( '#search_lat' ).value = latlng[0];
            form.querySelector( '#search_lng' ).value = latlng[1];
            form.querySelector( '#search_place' ).value = result.place_id;
            form.submit();
          } else {
            alert( 'Geocode was not successful for the following reason: ' + status );
          }
        });
      });
    });
  }
}
