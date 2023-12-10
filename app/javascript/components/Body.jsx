import { React, useState } from "react";

const Body = (props) => {

  const [error, setError] = useState("");

  return (
    <div className="App-body">
      <div className="App-body-left">
        <div className="App-body-left-title">
          <h1>Chicago Bike Dashboard</h1>
        </div>
        <div className="App-body-left-content">
          <p>
            This dashboard provides a visual representation of the Chicago obstructions cyclists face on a daily basis.
          </p>
        </div>
      </div>
    </div>
  );
};

export default Body;
