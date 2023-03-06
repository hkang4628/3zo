import React from "react";
import "../styles/PlacesMain.css";

export default function PlacesMain() {
  function importAll(r) {
    const names = r.keys().map(r);
    const images = names.map(function (name) {
      return <img className="places-main-img" src={name} />;
    });
    return images;
  }

  const images = importAll(
    require.context("../static/images/places", false, /\.(jpe?g|svg)$/)
  );
  return (
    <>
      <div className="places-main-div">
        <h1 className="places-main-h1">장소 소개</h1>
        <div className="places-main-container">{images}</div>
      </div>
    </>
  );
}
