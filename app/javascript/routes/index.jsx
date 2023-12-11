import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Reports from "../components/Reports";
import Report from "../components/Report";
import NewReport from "../components/NewReport";
import Directions from "../components/Directions";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/report/:id" element={<Report />} />
      <Route path="/reports" element={<Reports />} />
      <Route path="/report/new" element={<NewReport />} />
      <Route path="/directions" element={<Directions />} />
    </Routes>
  </Router>
);
