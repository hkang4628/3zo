import { atom } from "recoil";

export const loginState = atom({
  key: "login", // unique ID (with respect to other atoms/selectors)
  default: false, // default value (aka initial value)
});

export const userInfoState = atom({
  key: "user",
  default: {
    id: "",
    name: "",
    phone: "",
    email: "",
  },
});
