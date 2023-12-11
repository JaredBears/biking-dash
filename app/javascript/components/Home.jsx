import React from "react";
import { Link } from "react-router-dom";

const Home = () => {
  return (
    <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
    <div className="jumbotron jumbotron-fluid bg-transparent">
      <div className="container secondary-color">
        <h1 className="display-4">Chicago Bike Dashboard</h1>
        <hr className="my-4" />
        <Link
          to="/reports"
          className="btn btn-lg custom-button"
          role="button"
        >
          View Reports
        </Link>
        <Link
          to="/directions"
          className="btn btn-lg custom-button"
          role="button"
        >
          Get Directions
        </Link>
      </div>
    </div>
  </div>
  )
}

export default Home;
