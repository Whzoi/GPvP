// Assuming Lobby type is defined elsewhere and imported here
export interface AppState {
  activeParentNavItem: string;
  selectedLobby: number | null;
  inputPassword: string;
  showPasswordPopup: boolean;
  isFocused: boolean;
  showLine: boolean;
  searchTerm: string;
}

export type AppAction =
  | { type: "SET_USER_DATA", payload: string }
  | { type: "SET_ACTIVE_PARENT_NAV_ITEM", payload: string }
  | { type: "SET_SELECTED_LOBBY", payload: number | null }
  | { type: "SET_INPUT_PASSWORD", payload: string }
  | { type: "TOGGLE_PASSWORD_POPUP", payload: boolean }
  | { type: "SET_IS_FOCUSED", payload: boolean }
  | { type: "SET_SHOW_LINE", payload: boolean }
  | { type: "SET_SEARCH_TERM", payload: string };

export const initialState: AppState = {
  activeParentNavItem: "Servers",
  selectedLobby: null,
  inputPassword: "",
  showPasswordPopup: false,
  isFocused: false,
  showLine: false,
  searchTerm: "",
};

export const appReducer = (state: AppState, action: AppAction): AppState => {
  switch (action.type) {
    case "SET_ACTIVE_PARENT_NAV_ITEM":
      return { ...state, activeParentNavItem: action.payload };
    case "SET_SELECTED_LOBBY":
      return { ...state, selectedLobby: action.payload };
    case "SET_INPUT_PASSWORD":
      return { ...state, inputPassword: action.payload };
    case "TOGGLE_PASSWORD_POPUP":
      return { ...state, showPasswordPopup: action.payload };
    case "SET_IS_FOCUSED":
      return { ...state, isFocused: action.payload };
    case "SET_SHOW_LINE":
      return { ...state, showLine: action.payload };
    case "SET_SEARCH_TERM":
      return { ...state, searchTerm: action.payload };
    default:
      return state;
  }
};
