import React from 'react';
import Header from './Header';
import Body from './Body';
import Footer from './Footer';

const Home = () => {

  return (
    <div className="App">
      <Header text="Chicago Bike Dashboard" />
      <Body />
      <Footer text = "© 2023 by Jared Bears" />
    </div>
  );
};

export default Home;
