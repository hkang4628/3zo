import React from "react";
import { Link } from "react-router-dom";
import mainVideo from "../static/video/main_video.mp4";
import mainImg from "../static/images/main_img.png";
import "../styles/HomeMain.css";

function HomeMain() {
  return (
    <>
      <div className="home-main-container">
        <video className="home-main-video" autoPlay loop muted>
          <source src={mainVideo} type="video/mp4"></source>
        </video>
        <img className="home-main-img" src={mainImg} />
      </div>
    </>
  );
}

export default HomeMain;
