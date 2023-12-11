import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Reports from "../components/Reports";
import Report from "../components/Report";
import NewReport from "../components/NewReport";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/reports" element={<Reports />} />
      <Route path="/report/:id" element={<Report />} />
      <Route path="/report/create" element={<NewReport />} />
    </Routes>
  </Router>
);
