import React from 'react'
import { GoogleMap } from '@react-google-maps/api';

const containerStyle = {
  width: '100vw',
  height: '50vh'
};

const center = {
  lat: 41.878,
  lng: -87.629
};

const MapBox = () => {
  return (
    <GoogleMap
      mapContainerStyle={containerStyle}
      center={center}
      zoom={10}
    >
      { /* Child components, such as markers, info windows, etc. */ }
      <></>
    </GoogleMap>
  )
}

export default MapBox;
