import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { LineChart} from 'react-chartkick'
import 'chartkick/chart.js'

const ReportsGraph = () => {
  const navigate = useNavigate();
  const [reports, setReports] = useState([]);

  useEffect(() => {
    const url = "/api/v1/reports/index/0";
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

  return (
    <div className="container py-5">
      <h1 className="display-4">Reports</h1>
      <div className="row">
        <div className="col-sm-12 col-lg-6">
          <LineChart data={reports} />
        </div>
      </div>
    </div>
  );
}

export default ReportsGraph;
