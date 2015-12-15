export class Maps {
  constructor(){
    var pageFolder = document.body.className;

    google.maps.event.addDomListener( window, 'load', this.initializeSearch );

    if ( pageFolder.match( /gym index|gym show/ ) ) {
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
          , zoom: doc.body.className === "gym show" ? 16 : 11
          , disableDefaultUI: true
          , draggable: true
          , zoomControl: true
          , scrollwheel: false
          , disableDoubleClickZoom: true
          });

          google.maps.event.addListenerOnce( map, 'bounds_changed', () => {
            Array.prototype.forEach.call( document.querySelectorAll( '.gym-item' ), gym => {
              var marker = new google.maps.Marker({
                    map: map
                  , position: { lat: +gym.dataset.latitude , lng: +gym.dataset.longitude } });

              google.maps.event.addListener(marker, 'click', () => {
                var slug = gym.dataset.slug
                  , name = slug.replace( /\b\w/g, word => {
                      return word.toUpperCase();
                    }).replace( /-/g, ' ' );
                infoWindow.setContent( '<a href="/gyms/' + slug + '">' + name + '</a>' );
                infoWindow.open( map, marker );
              });
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
            form.querySelector( '#search_city' ).value = result.address_components.filter( component => {
              return component.types[0].match( /locality/ );
            })[0].long_name;
            form.querySelector( '#search_state' ).value = result.address_components.filter( component => {
              return component.types[0] === 'administrative_area_level_1';
            })[0].short_name;
            form.submit();
          } else {
            alert( 'Geocode was not successful for the following reason: ' + status );
          }
        });
      });
    });
  }
}
