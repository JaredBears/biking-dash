import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { GoogleMap, Marker, DirectionsService, DirectionsRenderer } from '@react-google-maps/api';

const Directions = () => {
  // use the Google Maps Api to allow the user to get biking directions from their current location to their target location
  // Will also display all recent reports on the map

  const navigate = useNavigate();
  const directionsService = new google.maps.DirectionsService();
  const [reports, setReports] = useState([]);
  const [directions, setDirections] = useState([]);
  const [origin, setOrigin] = useState([]);
  const [destination, setDestination] = useState([]);
  const [center, setCenter] = useState([]);

  const containerStyle = {
    width: '75vw',
    height: '75vh'
  };

  useEffect(() => {
    const url = "/api/v1/reports/index";
    fetch(url)
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network response was not ok");
      })
      .then((data) => setReports(data))
      .catch(() => navigate("/"));
  }, []);

  const getDirections = () => {
    directionsService.route({
      origin: origin,
      destination: destination + ", Chicago, IL",
      travelMode: google.maps.TravelMode.BICYCLING,
      provideRouteAlternatives: true
    }, (result, status) => {
      if (status === google.maps.DirectionsStatus.OK) {
        setDirections(result)
      } else {
        console.error(`error fetching directions ${result}`);
      }
    });
  }

  const allMarkers = reports.map((report, index) => (
    <Marker
      position={{ lat: report.lat, lng: report.lon }}
      animation={2}
    />
  ));

  const getLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition);
    } else {
      alert("Geolocation is not supported by this browser.");
    }
  }

  const showPosition = (position) => {
    setOrigin(`${position.coords.latitude}, ${position.coords.longitude}`);
    setCenter({ lat: position.coords.latitude, lng: position.coords.longitude });
    document.getElementById("origin").value = `${position.coords.latitude}, ${position.coords.longitude}`;
  }

  return (
    <div className="container py-5">
      <Link to="/" className="btn btn-link">
        Home
      </Link>
      <Link to="/reports" className="btn btn-link">
        View Reports
      </Link>
      <h3 className="mb-3">Map</h3>
      <div className="row">
        <div className="col-md-6">
          <form>
            <div className="form-group">
              <label htmlFor="origin">Origin</label>
              <input
                type="text"
                name="origin"
                id="origin"
                className="form-control"
                required
                onChange={(event) => setOrigin(event.target.value)}
              />
              <button type="button" className="btn custom-button mt-3" onClick={getLocation}>
                Use Current Location
              </button>
            </div>
            <div className="form-group">
              <label htmlFor="destination">Destination</label>
              <input
                type="text"
                name="destination"
                id="destination"
                className="form-control"
                required
                onChange={(event) => setDestination(event.target.value)}
              />
            </div>
            <button onClick={getDirections} type="button" className="btn custom-button mt-3">
              Get Directions
            </button>
          </form>
        </div>
        <div className="col-md-6">
          <GoogleMap
            mapContainerStyle={containerStyle}
            center={center}
            zoom={10}
          >
            { /* Child components, such as markers, info windows, etc. */}
            {allMarkers}
            {directions && <DirectionsRenderer directions={directions} />}
          </GoogleMap>
        </div>

      </div>
    </div>
  );
}

export default Directions;
