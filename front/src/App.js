import { BrowserRouter as Router } from "react-router-dom";
import { Route, Routes, Navigate } from "react-router-dom";
import {
  RecoilRoot,
  atom,
  selector,
  useRecoilState,
  useRecoilValue,
} from "recoil";

import Home from "./pages/Home";
import Places from "./pages/Places";
import Members from "./pages/Members";
import Signup from "./pages/Signup";
import Login from "./pages/Login";
import ContestList from "./pages/ContestList";
import ContestDetail from "./pages/ContestDetail";
import Upload from "./pages/Upload";

function App() {
  return (
    <RecoilRoot>
      <Router>
        <Routes>
          <Route path="/" element={<Navigate replace to="/home" />} />
          <Route path="/home" element={<Home />} />
          <Route path="/places" element={<Places />} />
          <Route path="/members" element={<Members />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/login" element={<Login />} />
          <Route path="/contest-list" element={<ContestList />} />
          <Route path="/contest-detail" element={<ContestDetail />} />
          <Route path="/upload" element={<Upload />} />
        </Routes>
      </Router>
    </RecoilRoot>
  );
}

export default App;
