import React from "react";

const Header = (props) => {
    return (
        <header className="App-header">
            <h1>{props.text}</h1><br />
            <div>
                Welcome!
            </div>
        </header>
    );
};

export default Header;
