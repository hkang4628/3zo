import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useRecoilState } from "recoil";
import { loginState, userInfoState } from "../state/atom";
import axios from "axios";

import "../styles/ContestList.css";

const ContestList = () => {
  const [login, setLogin] = useRecoilState(loginState);
  const [contests, setContests] = useState([]);

  const navigate = useNavigate();

  useEffect(() => {
    axios
      .get("http://localhost:8000/contest_list/")
      .then((response) => setContests(response.data))
      .catch((error) => console.error(error));
  }, []);

  function handleUpload() {
    if (login) {
      navigate("/upload");
    } else {
      alert("로그인이 필요한 서비스 입니다.");
      navigate("/login");
    }
  }

  return (
    <>
      <h1 className="contest-h1">미디어 공모전</h1>
      <div className="contest-div">
        <button className="contest-button" onClick={handleUpload}>
          사진 업로드
        </button>
      </div>
      <div className="contest-list">
        {contests.map((contest) => (
          <div className="contest" key={contest.id}>
            <Link to={`http://localhost:3000/contest-detail?id=${contest.id}`}>
              <img src={contest.thumbnail} alt={contest.title} />
              <div className="contest-content">
                <h2 className="contest-title">{contest.title}</h2>
                <p className="contest-member_name">{contest.member_name}</p>
                <p className="contest-location">{contest.location}</p>
              </div>
            </Link>
          </div>
        ))}
      </div>
    </>
  );
};

export default ContestList;
