import React from "react";
import { Link } from "react-router-dom";
import Header from "../components/Header";
import Footer from "../components/Footer";
import Main from "../components/ContestDetail";

export default function ContestList() {
  return (
    <div>
      <Header />
      <Main />
      <Footer />
    </div>
  );
}
