import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";

const Reports = () => {
  const navigate = useNavigate();
  const [reports, setReports] = useState([]);

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

  const allReports = reports.map((report, index) => (
    <div key={index} className="col-md-6 col-lg-4">
      <div className="card mb-4">
        <div className="card-body">
          <h5 className="card-title">{report.id}: {report.category}</h5>
          <Link to={`/report/${report.id}`} className="btn custom-button">
            View Report
          </Link>
        </div>
      </div>
    </div>
  ));

  const noReport = (
    <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
      <h4>
        No reports yet. Why not <Link to="/new_report">create one</Link>
      </h4>
    </div>
  );

  return (
    <div>
      <section className="jumbotron jumbotron-fluid text-center">
        <div className="container py-5">
          <h1 className="display-4">Reports</h1>
          <p className="lead text-muted">
            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Doloremque
          </p>
        </div>
      </section>
      <div className="py-5">
        <main className="container">
          <div className="text-right mb-3">
            <Link to="/report" className="btn custom-button">
              Create New Report
            </Link>
          </div>
          <div className="row">
            {reports.length > 0 ? allReports : noReport}
          </div>
          <Link to="/" className="btn btn-link">
            Home
          </Link>
        </main>
      </div>
    </div>
  )
};

export default Reports;
