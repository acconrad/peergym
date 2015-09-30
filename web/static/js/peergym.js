export class Maps {
  constructor(){
    var initialize = document.body.className.match( /page/ ) ? this.initializeSearch : this.initializeMap;
    google.maps.event.addDomListener( window, 'load', initialize );
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
      , location = doc.getElementById( 'search_location' )
      , form = doc.getElementById( 'gym-search-form' );

    new google.maps.places.Autocomplete( location );

    form.addEventListener( 'submit', event => {
      event.preventDefault();

      new google.maps.Geocoder().geocode( { 'address': location.value }, (results, status) => {
        var result, latlng;
        if ( status === google.maps.GeocoderStatus.OK ) {
          result = results[0];
          latlng = result.geometry.location.toString().slice(1,-1).split(', ');
          document.getElementById( 'search_lat' ).value = latlng[0];
          document.getElementById( 'search_lng' ).value = latlng[1];
          document.getElementById( 'search_place' ).value = result.place_id;
          form.submit();
        } else {
          alert( 'Geocode was not successful for the following reason: ' + status );
        }
      });
    });
  }
}
