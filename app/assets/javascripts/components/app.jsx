import React from 'react';
import Header from './header';
import Body from './body';
import Footer from './footer';

const App = () => {

  return (
    <div className="App">
      <Header text="Chicago Bike Dashboard" />
      <Body />
      <Footer text = "© 2023 by Jared Bears" />
    </div>
  );
};

export default App;
