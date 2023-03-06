import React from "react";
import "../styles/Footer.css";

function Footer() {
  return (
    <>
      <footer className="footer-container">
        <div className="footer-left">
          <a href="/" className="footer-logo">
            My Logo
          </a>
        </div>
        <div className="footer-right">
          <p>Address: 서울시 금천구 새싹동 클라우드빌딩 꽃보러오삼</p>
          <p>Phone: 123-456-7890</p>
          <p>Email: flower53@3zo.com</p>
        </div>
      </footer>
    </>
  );
}

export default Footer;
