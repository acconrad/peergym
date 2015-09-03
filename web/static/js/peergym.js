export class Maps {
  constructor(){
    var initialize = document.body.className.match( /page/ ) ? this.initializeSearch : this.initializeMap;
    google.maps.event.addDomListener( window, 'load', initialize );
  }

  initializeMap(){
    var doc = document
      , canvas = doc.getElementById( 'map-canvas' )
      , infoWindow = new google.maps.InfoWindow()
      , service, map;

    new google.maps.Geocoder().geocode( { 'placeId': canvas.dataset.placeId }, (results, status) => {
      if ( status === google.maps.GeocoderStatus.OK ) {
        if ( results[0] ) {
          map = new google.maps.Map( canvas, {
            center: results[0].geometry.location
          , zoom: 13
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

          service = new google.maps.places.PlacesService( map );

          google.maps.event.addListenerOnce( map, 'bounds_changed', () => {
            service.radarSearch(
              { bounds: map.getBounds(), keyword: 'gyms' }
            , (places, status) => {
                if ( status != google.maps.places.PlacesServiceStatus.OK ) {
                  alert( status );
                  return;
                }

                places.forEach( place => {
                  var marker = new google.maps.Marker({ map: map, position: place.geometry.location })
                    , placeDetails, addr;

                  service.getDetails( place, (result, status) => {
                    if ( status != google.maps.places.PlacesServiceStatus.OK ) {
                      alert( status );
                      return;
                    }

                    placeDetails = result;
                    addr = place.address_components.map( component => {
                      if ( component.types[0].match( /country|suffix/i ) ) {
                        return false;
                      }

                      return component.short_name;
                    }).filter( component => { return component; }).join( ', ' );

                    document.getElementById( 'gyms-list' ).innerHTML = `
                      <li>
                        <h2>${place.name}</h2>
                        <p>${addr}</p>
                        <p>${place.formatted_phone_number}</p>
                      </li>`;
                  });

                  google.maps.event.addListener( marker, 'click', () => {
                    infoWindow.setContent( `<a href="/gyms/${placeDetails.place_id}?name=${placeDetails.name}">${placeDetails.name}</a>` );
                    infoWindow.open( map, marker );
                  });
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
      , location = doc.getElementById( 'search_location' )
      , form = doc.getElementById( 'gym-search-form' );

    new google.maps.places.Autocomplete( location );

    form.addEventListener( 'submit', event => {
      event.preventDefault();

      new google.maps.Geocoder().geocode( { 'address': location.value }, (results, status) => {
        if ( status === google.maps.GeocoderStatus.OK ) {
          document.getElementById( 'search_place' ).value = results[0].place_id;
          form.submit();
        } else {
          alert( 'Geocode was not successful for the following reason: ' + status );
        }
      });
    });
  }
}
