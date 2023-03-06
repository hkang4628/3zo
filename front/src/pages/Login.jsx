import React from "react";
import { Link } from "react-router-dom";
import Header from "../components/Header";
import Footer from "../components/Footer";
import Main from "../components/Login";

export default function Login() {
  return (
    <div>
      <Header />
      <Main />
      <Footer />
    </div>
  );
}
