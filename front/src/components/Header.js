import React, { useState } from "react";
import { Link } from "react-router-dom";
import { useRecoilState } from "recoil";

import { loginState } from "../state/atom";
import logoImg from "../static/images/logo_img.png";
import "../styles/Header.css";

function Header() {
  const [login, setLogin] = useRecoilState(loginState);

  function handleLogin() {
    setLogin(!login);
  }
  return (
    <>
      <div className="header-container">
        <div className="logo-container">
          <a href="/home">
            <img src={logoImg} className="logo"></img>
          </a>
        </div>
        <div className="navigation-container">
          <nav>
            <ul>
              <li>
                <Link to="/">홈</Link>
              </li>
              <li>
                <Link to="/places">장소 소개</Link>
              </li>
              <li>
                <Link to="/contest-list">미디어 공모전</Link>
              </li>
              <li>
                <Link to="/members">조직 위원회</Link>
              </li>
            </ul>
          </nav>
        </div>

        <div className="auth-container">
          {login ? (
            <button className="auth-link" onClick={handleLogin}>
              로그아웃
            </button>
          ) : (
            <Link to="/login" className="auth-link">
              로그인
            </Link>
          )}
          <Link to="/signup" className="auth-link">
            회원가입
          </Link>
        </div>
      </div>
    </>
  );
}

export default Header;
