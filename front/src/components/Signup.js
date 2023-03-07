import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

import "../styles/Signup.css";
import mainImg from "../static/images/signup_img.jpg";

const Signup = () => {
  const [userInput, setUserInput] = useState({
    id: "",
    pw: "",
    name: "",
    phone: "",
    email: "",
  });

  const navigate = useNavigate();

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setUserInput((prevState) => ({ ...prevState, [name]: value }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const { id, pw, name, phone, email } = event.target.elements;

    try {
      const response = await axios.post("http://111.67.218.43:8000/signup/", {
        id: id.value,
        pw: pw.value,
        name: name.value,
        phone: phone.value,
        email: email.value,
      });
      console.log(response);
      if (response.data.result == "success") {
        alert(`${userInput.name} 님 환영합니다`);
        navigate("/login");
      } else {
        alert(response.data.message);
      }
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <>
      <img src={mainImg} className="signup-img" />
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="id">ID</label>
          <input type="text" id="id" name="id" onChange={handleInputChange} />
        </div>
        <div>
          <label htmlFor="pw">Password</label>
          <input
            type="password"
            id="pw"
            name="pw"
            onChange={handleInputChange}
          />
        </div>
        <div>
          <label htmlFor="name">Name</label>
          <input
            type="text"
            id="name"
            name="name"
            onChange={handleInputChange}
          />
        </div>
        <div>
          <label htmlFor="phone">Phone</label>
          <input
            type="text"
            id="phone"
            name="phone"
            onChange={handleInputChange}
          />
        </div>
        <div>
          <label htmlFor="email">Email</label>
          <input
            type="email"
            id="email"
            name="email"
            onChange={handleInputChange}
          />
        </div>
        <button type="submit">Register</button>
      </form>
    </>
  );
};

export default Signup;
