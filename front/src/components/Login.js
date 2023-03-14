import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useRecoilState } from "recoil";
import { loginState, userInfoState } from "../state/atom";
import mainImg from "../static/images/login_img.jpg";

import { SERVER_URL } from "../constants";

import "../styles/Login.css";
import axios from "axios";

const Login = () => {
  const [login, setLogin] = useRecoilState(loginState);
  const [userInfo, setUserInfo] = useRecoilState(userInfoState);

  const [userInput, setUserInput] = useState({
    id: "",
    pw: "",
  });
  const navigate = useNavigate();

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setUserInput((prevState) => ({ ...prevState, [name]: value }));
  };
  const handleUserInfo = ({
    member_id,
    member_name,
    member_phone,
    member_email,
  }) => {
    setUserInfo({
      ...userInfo,
      id: member_id,
      name: member_name,
      phone: member_phone,
      email: member_email,
    });
  };
  const handleSubmit = async (event) => {
    event.preventDefault();
    const { id, pw } = event.target.elements;

    try {
      const response = await axios.post(`${SERVER_URL}/login/`, {
        id: id.value,
        pw: pw.value,
      });
      if (response.data.result == "success") {
        // console.log(response.data);
        handleUserInfo(response.data);
        setLogin(!login);
        // console.log(userInfo);
        navigate("/home");
      } else {
        alert(response.data.message);
      }
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div className="frame-container">
      <img src={mainImg} className="login-img" />
      <form onSubmit={handleSubmit} className="frame-form">
        <div className="form-group">
          <label htmlFor="id">ID</label>
          <input type="text" id="id" name="id" onChange={handleInputChange} />
        </div>
        <div className="form-group">
          <label htmlFor="password">PW</label>
          <input
            type="password"
            id="pw"
            name="pw"
            onChange={handleInputChange}
          />
        </div>
        <button type="submit" className="form-button">
          로그인
        </button>
      </form>
    </div>
  );
};

export default Login;
