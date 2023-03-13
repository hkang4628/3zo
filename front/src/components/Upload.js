import React, { useState } from "react";
import { useRecoilState } from "recoil";
import { userInfoState } from "../state/atom";
import axios from "axios";
import "../styles/Upload.css";

import { SERVER_URL } from "../constants";

const Upload = ({ onCancel, onSubmit }) => {
  const [userInfo, setUserInfo] = useRecoilState(userInfoState);
  const [userInput, setUserInput] = useState({
    title: "",
    location: "",
  });
  const [image, setImage] = useState("");

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setUserInput((prevState) => ({ ...prevState, [name]: value }));
  };

  const handleImageChange = (event) => {
    const file = event.target.files[0];
    setImage(file);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    try {
      const formData = new FormData();

      formData.append("title", userInput.title);
      formData.append("location", userInput.location);
      formData.append("member_id", userInfo.id);
      formData.append("member_name", userInfo.name);
      formData.append("phone", userInfo.phone);
      formData.append("email", userInfo.email);
      formData.append("image", image);
      console.log(userInput);
      console.log(userInfo);
      const res = await axios.post(`${SERVER_URL}/upload/`, formData);
      //   const res = await axios.post("http://localhost:8000/upload/", {
      //     id: "id",
      //   });
      const contestId = res.data.id;
      //   console.log(res);
      //     if (image) {
      //       const imageData = new FormData();
      //       imageData.append("image", image);
      //       const config = { headers: { "content-type": "multipart/form-data" } };
      //       const response = await axios.post(
      //         `http://localhost:8000/upload/${contestId}/image/`,
      //         imageData,
      //         config
      //       );
      //       const { imageUrl } = response.data;
      //     }
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <form className="form-container" onSubmit={handleSubmit}>
      <label className="form-label">
        Title
        <input type="text" name="title" onChange={handleInputChange} required />
      </label>
      <label className="form-label">
        Location
        <input
          type="text"
          name="location"
          onChange={handleInputChange}
          required
        />
      </label>
      <label className="form-label">
        Image
        <input
          type="file"
          accept="image/*"
          onChange={handleImageChange}
          required
        />
      </label>
      <div className="form-buttons">
        <button type="button" className="form-button" onClick={onCancel}>
          Cancel
        </button>
        <button type="submit" className="form-button">
          Submit
        </button>
      </div>
    </form>
  );
};

export default Upload;
