import React, { useState, useEffect } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";

const Report = () => {
  const params = useParams();
  const navigate = useNavigate();
  const [report, setReport] = useState({});

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
    <div className="hero position-relative d-flex align-items-center justify-content-center">
      {/* <img src={report.images[0]} alt={`${report.category} image`} className="img-fluid position-absolute" /> */}
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
  </div>
  )
};

export default Report;
