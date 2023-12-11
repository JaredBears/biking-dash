import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Button } from 'react-bootstrap';

const NewReport = (props) => {
  const url = "/api/v1/reports/create";
  const navigate = useNavigate();
  const [report, setReport] = useState({
    category: "",
    lat: "",
    lon: "",
    address_street: "",
    address_zip: "",
    description: "",
    created_at: "",
    neighborhood: "",
    suburb: "",
    reporter_id: "",
  });

  const stripHtmlEntities = (str) => {
    return String(str)
      .replace(/\n/g, "<br> <br>")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  };

  const onChange = (event) => {
    const { name, value } = event.target;
    setReport({
      ...report,
      [name]: {
        ...report[name], value
      }
    });
  }

  const onSubmit = (event) => {
    event.preventDefault();
    const { category, lat, lon, address_street, address_zip, description, dateString, timeString } = report;
    const created_at = dateString + " " + timeString;

    const geo_success = (position) => {
      const { latitude, longitude } = position.coords;
      document.getElementById("lat").value = latitude;
      document.getElementById("lon").value = longitude;
    }

    const geo_error = () => {
      alert("Sorry, no position available.");
    }

    const geo_options = {
      enableHighAccuracy: true,
      maximumAge: 30000,
      timeout: 27000
    }

    const getLocation = () => {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(geo_success, geo_error, geo_options);
      } else {
        alert("Geolocation is not supported by this browser.");
      }
    }

    const body = {
      category,
      lat,
      lon,
      address_street,
      address_zip,
      description: stripHtmlEntities(description),
      created_at,
      neighborhood,
      suburb,
    }

    const token = document.querySelector('meta[name="csrf-token"]').content;

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    })
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error("Network response was not ok.");
      })
      .then(() => navigate("/reports"))
      .catch((error) => console.log(error.message));

    return (
      <div className="container mt-5">
        <div className="row">
          <div className="col-sm-12 col-lg-6 offset-lg-3">
            <h1 className="font-weight-normal mb-5">
              Add a new report
            </h1>
            <form onSubmit={onSubmit}>
              <div className="form-group">
                <select
                  className="form-control"
                  id="category"
                  name="category"
                  required
                  onChange={(event) => onChange(event, setReport)}
                >
                  <option value="">Select a category</option>
                  <option value="Company Vehicle">Company Vehicle</option>
                  <option value="Municipal (city) Vehicle - includes USPS">Municipal (city) Vehicle - includes USPS</option>
                  <option value="Private Owner Vehicle">Private Owner Vehicle</option>
                  <option value="Taxi / Uber / Livery / Lyft">Taxi / Uber / Livery / Lyft</option>
                  <option value="Construction">Construction</option>
                  <option value="Other  (damaged lane / snow / debris / pedestrian / etc.)">Other  (damaged lane / snow / debris / pedestrian / etc.)</option>
                </select>
              </div>
              <div className="form-group">
                <label htmlFor="lat">Latitude</label>
                <input
                  type="number"
                  name="lat"
                  id="lat"
                  className="form-control"
                  onChange={(event) => onChange(event, setReport)}
                />
              </div>
              <div className="form-group">
                <label htmlFor="lon">Longitude</label>
                <input
                  type="number"
                  name="lon"
                  id="lon"
                  className="form-control"
                  onChange={(event) => onChange(event, setReport)}
                />
              </div>
              <div className="form-group">
                <label htmlFor="address_street">Street Address</label>
                <input
                  type="text"
                  name="address_street"
                  id="address_street"
                  className="form-control"
                  onChange={(event) => onChange(event, setReport)}
                />
              </div>
              <div className="form-group">
                <label htmlFor="address_zip">Zip Code</label>
                <input
                  type="text"
                  name="address_zip"
                  id="address_zip"
                  className="form-control"
                  onChange={(event) => onChange(event, setReport)}
                />
              </div>
              <div className="form-group">
                <Button onClick={getLocation}>Get Location</Button>
              </div>
              <div className="form-group">
                <label htmlFor="description">Description</label>
                <input
                  type="text"
                  name="description"
                  id="description"
                  className="form-control"
                  required
                  onChange={(event) => onChange(event, setReport)}
                />
              </div>
              <div className="form-group">
                <input
                  type="datetime-local"
                  name="created_at"
                  id="created_at"
                  className="form-control"
                  onChange={(event) => onChange(event, setReport)}
                />
              </div>
              <Button onClick={onSubmit}>Create Report </Button>
            </form>
          </div>
        </div>
      </div>
    );
  };
}

export default NewReport;
