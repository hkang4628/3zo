import React, { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import axios from "axios";

import { SERVER_URL } from "../constants";

import "../styles/ContestDetail.css";

export default function ContestDetail() {
  const [contest, setContest] = useState([]);

  const { search } = useLocation();
  const params = new URLSearchParams(search);
  const id = params.get("id");

  // id와 name을 사용하여 서버에서 데이터를 가져오는 코드
  useEffect(() => {
    axios
      .get(`${SERVER_URL}/contest_detail/?id=${id}`)
      .then((response) => {
        setContest(response.data);
      })
      .catch((error) => console.error(error));
  }, []);

  return (
    <div className="frame-container">
      <div className="frame-image">
        <img src={contest.img_url} alt={contest.title} />
      </div>
      <div className="frame-info">
        <p className="frame-location">{contest.location}</p>
        <h3 className="frame-title">{contest.title}</h3>
        <p className="frame-author">{contest.member_name}</p>
      </div>
    </div>
  );
}
