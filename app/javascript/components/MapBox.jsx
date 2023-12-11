import React from 'react'
import { GoogleMap, Marker, InfoWindow } from '@react-google-maps/api';

const MapBox = (props) => {

  const containerStyle = {
    width: '100vw',
    height: '50vh'
  };

  const center = {
    lat: props.lat || 41.881,
    lng: props.lon || -87.623
  };

  return (
    <div>
      <GoogleMap
        mapContainerStyle={containerStyle}
        center={center}
        zoom={10}
      >
        { /* Child components, such as markers, info windows, etc. */}
        <Marker 
          position={center}
          animation={2}
          />
      </GoogleMap>
      Lat: {props.lat} Lng: {props.lon}
    </div>
  )
}

export default MapBox;
