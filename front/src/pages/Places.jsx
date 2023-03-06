import React from "react";
import { Link } from "react-router-dom";
import Header from "../components/Header";
import Footer from "../components/Footer";
import Main from "../components/Places";

function Places({ onLogin, isLoggedIn }) {
  return (
    <div>
      <Header onLogin={onLogin} isLoggedIn={isLoggedIn} />
      <Main />
      <Footer />
    </div>
  );
}

export default Places;
