export class Maps {
  constructor(){
    var initialize = document.body.className.match( /page/ ) ? this.initializeSearch : this.initializeMap;
    google.maps.event.addDomListener( window, 'load', initialize );
  }

  changeBounds(){
    service.radarSearch( { bounds: map.getBounds(), keyword: 'gyms' }, this.searchCallback );
  }

  changePlace(){
    var place = autocomplete.getPlace()
      , address = '';

    infowindow.close();
    marker.setVisible( false );

    if ( !place.geometry ) {
      window.alert( 'Autocomplete returned place contains no geometry ' );
      return;
    }

    if ( place.geometry.viewport ) {
      map.fitBounds( place.geometry.viewport );
    } else {
      map.setCenter( place.geometry.location );
      map.setZoom( 17 );
    }

    marker.setIcon(({
      url: place.icon
    , size: new google.maps.Size( 71, 71 )
    , origin: new google.maps.Point( 0, 0 )
    , anchor: new google.maps.Point( 17, 34 )
    , scaledSize: new google.maps.Size( 35, 35 )
    }));
    marker.setPosition( place.geometry.location );
    marker.setVisible( true );

    if ( place.address_components ) {
      address = [
        (place.address_components[0] && place.address_components[0].short_name || '')
      , (place.address_components[1] && place.address_components[1].short_name || '')
      , (place.address_components[2] && place.address_components[2].short_name || '')
      ].join(' ');
    }

    infowindow.setContent( `<div><strong>${place.name}</strong><br>${ address }` );
    infowindow.open( map, marker );
  }

  createMarker( place ) {
    var marker = new google.maps.Marker({ map: map, position: place.geometry.location });

    google.maps.event.addListener( marker, 'click', () => {
      service.getDetails( place, (result, status) => {
        if ( status != google.maps.places.PlacesServiceStatus.OK ) {
          alert(status);
          return;
        }

        infoWindow.setContent( `<a href="/gyms/1">${result.name}</a>` );
        infoWindow.open(map, marker);
      });
    });
  }

  searchCallback( results, status ){
    if ( status != google.maps.places.PlacesServiceStatus.OK ) {
      alert( status );
      return;
    }

    results.forEach( result => {
      this.createMarker( result );
    });
  }

  initializeMap(){
    var map = new google.maps.Map( document.getElementById('map-canvas'), {
          center: new google.maps.LatLng( 42.3601, -71.0589)
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
        })
      , infoWindow = new google.maps.InfoWindow()
      , service = new google.maps.places.PlacesService( map );

    google.maps.event.addListenerOnce( map, 'bounds_changed', this.changeBounds );
  }

  initializeSearch(){
    var mapOptions = {
        center: new google.maps.LatLng( 42.3601, -71.0589)
      , zoom: 13
      }
    , map = new google.maps.Map( document.getElementById( 'map-canvas' ), mapOptions )
    , input = document.getElementById( 'pac-input' )
    , types = document.getElementById( 'type-selector' )
    , autocomplete = new google.maps.places.Autocomplete( input )
    , infowindow = new google.maps.InfoWindow()
    , marker = new google.maps.Marker({ map: map, anchorPoint: new google.maps.Point( 0, -29 ) });

    map.controls[ google.maps.ControlPosition.TOP_LEFT ].push( input );
    map.controls[ google.maps.ControlPosition.TOP_LEFT ].push( types );

    autocomplete.bindTo( 'bounds', map );

    google.maps.event.addListener( autocomplete, 'place_changed', this.changePlace );

    autocomplete.setTypes([]);
  }
}
