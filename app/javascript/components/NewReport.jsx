import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Button } from '@mui/material';

const NewReport = (props) => {
  const navigate = useNavigate();
  const url = "/api/v1/reports/create";

  const [report, setReport] = useState({
    address_street: "",
    address_zip: "",
    category: "",
    description: "",
    lat: "",
    lon: "",
    reporter_id: ""
  });

  const stripHtmlEntities = (str) => {
    return String(str)
      .replace(/\n/g, "<br> <br>")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  };

  const getLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(updatePosition);
    } else {
      alert("Geolocation is not supported by this browser.");
    }
  };

  const updatePosition = (position) => {
    //update form fields with current position:
    document.getElementById("lat").value = position.coords.latitude;
    document.getElementById("lon").value = position.coords.longitude;
  }

  const handleChange = (event) => {
    setReport({
      ...report,
      [event.currentTarget.name]: event.currentTarget.value,
    });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    const body = {
      address_street,
      address_zip,
      category,
      description: stripHtmlEntities(description),
      lat,
      lon,
      reporter_id
    };

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
        throw new Error("Network response not ok.");
      })
      .then(() => navigate("/report/${response.id}"))
      .catch((error) => console.log(error.message));
  }

  return (
    <div>test</div>
  );
}

export default NewReport;
