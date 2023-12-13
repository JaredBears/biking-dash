import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";

const NewReport = () => {
  const navigate = useNavigate();
  const [category, setCategory] = useState("");
  const [address_street, setAddressStreet] = useState("");
  const [address_zip, setAddressZip] = useState("");
  const [lat, setLat] = useState("");
  const [lon, setLon] = useState("");
  const [description, setDescription] = useState("");
  const [reporter_id, setReporterId] = useState(1);
  const [images, setImages] = useState();
  
  const handleChanges = (event, setFunction) => {
    setFunction(event.target.value);
  }

  const handleImages = () => {
    const files = document.getElementById("reportImages").files;
    const images = [];
    for (let i = 0; i < files.length; i++) {
      images.push(URL.createObjectURL(files[i]));
    }
    setImages(images);
  }

  const handleSubmit = (event) => {
    event.preventDefault();
    const url = "/api/v1/reports/create";
    const body = {
      category,
      address_street,
      address_zip,
      lat,
      lon,
      description,
      reporter_id,
      images
    };
    // if either lat or lon is filled in, then both must be filled in
    // if neither is filled in, then the address must be filled in
    if ((lat || lon) && !(lat && lon)) {
      alert("Please fill in both latitude and longitude.");
      return;
    } else if (!(lat || lon) && !(address_street && address_zip)) {
      alert("Please fill in either latitude and longitude or street address and zip code.");
      return;
    }
    const token = document.querySelector('meta[name="csrf-token"]').content;
    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json"
      },
      body: JSON.stringify(body)
    })
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network response not ok.");
      })
      .then((data) => navigate(`/report/${data.id}`))
      .catch((err) => console.log(err.message));
  };

  const getLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition);
    } else {
      alert("Geolocation is not supported by this browser.");
    }
  }

  const showPosition = (position) => {
    setLat(position.coords.latitude);
    setLon(position.coords.longitude);
    document.getElementById("reportLat").value = position.coords.latitude;
    document.getElementById("reportLon").value = position.coords.longitude;
  }

  return (
    <div className="container mt-5">
      <div className="row">
        <div className="col-sm-12 col-lg-6 offset-lg-3">
          <h1 className="font-weight-normal mb-5">
            Add a new report to help your community!
          </h1>
          <form onSubmit={handleSubmit}>
            <button type="button" className="btn custom-button" onClick={getLocation}>
              Use Current Location
            </button>
            <div className="form-group">
              <label htmlFor="reportCategory">Category</label>
              <select
                required
                className="form-control"
                id="reportCategory"
                name="category"
                onChange={(event) => handleChanges(event, setCategory)}
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
              <label htmlFor="reportAddressStreet">Street Address</label>
              <input
                type="text"
                name="address_street"
                id="reportAddressStreet"
                className="form-control"
                onChange={(event) => handleChanges(event, setAddressStreet)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="reportAddressZip">Zip Code</label>
              <input
                type="text"
                name="address_zip"
                id="reportAddressZip"
                className="form-control"
                onChange={(event) => handleChanges(event, setAddressZip)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="reportLat">Latitude</label>
              <input
                type="text"
                name="lat"
                id="reportLat"
                className="form-control"
                onChange={(event) => handleChanges(event, setLat)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="reportLon">Longitude</label>
              <input
                type="text"
                name="lon"
                id="reportLon"
                className="form-control"
                onChange={(event) => handleChanges(event, setLon)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="reportDescription">Description</label>
              <textarea
                className="form-control"
                id="reportDescription"
                name="description"
                rows="5"
                onChange={(event) => handleChanges(event, setDescription)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="reportImages">Images</label>
              <input
                type="file"
                name="images"
                id="reportImages"
                className="form-control"
                multiple
                onChange={(event) => handleImages()}
              />
            </div>
            <input
              type="hidden"
              name="reporter_id"
              id="reportReporterId"
              className="form-control"
              value="1"
            />
            <button type="submit" className="btn custom-button mt-3">
              Create Report
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};  

export default NewReport;
