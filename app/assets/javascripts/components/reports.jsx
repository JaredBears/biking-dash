import { React, ReactComponent, useState } from "react";
import { Card } from '@mui/material';

const Reports = (props) => {

  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [listView, setListView] = useState(true);
  const [reports, setReports] = useState([]);

  const toggleView = () => {
    setListView(!listView);
  }

  const getReports = () => {
    fetch("/api/reports")
      .then(res => res.json())
      .then(
        (result) => {
          setIsLoaded(true);
          setReports(result);
        },
        (error) => {
          setIsLoaded(true);
          setError(error);
        }
      )
  }

  const renderReport = (report) => {
    return (
      <Card>
        <h3>{report.id} : {report.category}</h3>
        
      </Card>
    )
}

export default Reports;
