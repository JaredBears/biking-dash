import React, { useState, useEffect } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { GoogleMap, Marker, InfoWindow } from '@react-google-maps/api';

import ImageList from '@mui/material/ImageList';
import ImageListItem from '@mui/material/ImageListItem';

const Report = () => {
  const params = useParams();
  const navigate = useNavigate();
  const [report, setReport] = useState([]);

  const containerStyle = {
    width: '100vw',
    height: '50vh'
  };

  useEffect(() => {
    const url = `/api/v1/show/${params.id}`;
    fetch(url)
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network response was not ok.");
      })
      .then((data) => setReport(data))
      .catch(() => navigate("/reports"));
  }, [params.id]);

  return (
    <div className="">
      <Link to="/reports" className="btn btn-link">
        Back to Reports
      </Link>
      <Link to="/directions" className="btn btn-link">
        Get Directions
      </Link>
      <Link to="/" className="btn btn-link">
        Home
      </Link>
      <div className="hero position-relative d-flex align-items-center justify-content-center">
        <div className="overlay bg-dark position-absolute" />
        <h1 className="display-4 position-relative text-white">
          {report.category}
        </h1>
      </div>
      <div className="container py-5">
        <ul>
          <li>Category: {report.category}</li>
          <li>Reported on: {report.created_at}</li>
          {report.address_street && <li>Street Address: {report.address_street}</li>}
          <li>Location: {report.lat}, {report.lon}</li>
          <li>Description: {report.description}</li>
        </ul>
      </div>
      <ImageList 
        sx={{ width: 500, height: 150 }} 
        cols={3} 
        rowHeight={121}
        variant="quilted"
      >
        {report.images && report.images.split('|').map((image_url) => (
          <ImageListItem key={image_url}>
            <img
              src={image_url}
              srcSet={`${image_url}?w=164&h=164&fit=crop&auto=format 1x,
                ${image_url}?w=164&h=164&fit=crop&auto=format&dpr=2 2x`}
              alt={report.category}
              loading="lazy"
            />
          </ImageListItem>
        ))}
      </ImageList>
      <div className="container py-5">
        <h3 className="mb-3">Map</h3>
        <GoogleMap
          mapContainerStyle={containerStyle}
          center={{ lat: report.lat, lng: report.lon }}
          zoom={10}
        >
          { /* Child components, such as markers, info windows, etc. */}
          <Marker
            position={{ lat: report.lat, lng: report.lon }}
            animation={2}
          />
        </GoogleMap>
      </div>
    </div>
  );
};

export default Report;
