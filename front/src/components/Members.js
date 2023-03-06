import React from "react";
import "../styles/Members.css";

const Member = () => {
  function importAll(r) {
    return r.keys().map(r);
  }
  const images = importAll(
    require.context("../static/images/members", false, /\.(png|jpe?g|svg)$/)
  );
  const leader = {
    id: 1,
    image: "member1.png",
    name: "강현희",
  };
  const memberList = [
    {
      id: 2,
      image: "member2.png",
      name: "손하린",
    },
    {
      id: 3,
      image: "member3.png",
      name: "정다운",
    },
    {
      id: 4,
      image: "member4.png",
      name: "국명근",
    },
    {
      id: 5,
      image: "member5.png",
      name: "황동혁",
    },
  ];

  return (
    <>
      <h1 className="member-h1">조직 위원회</h1>
      <div className="member-container">
        <div className="member-leader">
          <img
            className="member-image"
            src={images[leader.id - 1]}
            alt={leader.name}
          />
          <h3 className="member-name">{leader.name}</h3>
          <p className="member-position">조장</p>
        </div>
        <div className="member-member">
          {memberList.map((member) => (
            <div key={member.id} className="member-item">
              <img
                className="member-image"
                src={images[member.id - 1]}
                alt={member.name}
              />
              <h3 className="member-name">{member.name}</h3>
              <p className="member-position">조원</p>
            </div>
          ))}
        </div>
      </div>
    </>
  );
};

export default Member;
