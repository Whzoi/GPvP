interface UIState {
    isFocused: boolean;
    showLine: boolean;
    activeParentNavItem: string;
    showBackgroundImage: boolean;
  }
  
  type UIAction =
    | { type: "SET_IS_FOCUSED", payload: boolean }
    | { type: "SET_SHOW_LINE", payload: boolean }
    | { type: "SET_ACTIVE_PARENT_NAV_ITEM", payload: string }
    | { type: "TOGGLE_BACKGROUND_IMAGE", payload: boolean };
  
  export const initialUIState: UIState = {
    isFocused: false,
    showLine: false,
    activeParentNavItem: "Servers",
    showBackgroundImage: true,
  };
  
  export const uiReducer = (state: UIState, action: UIAction): UIState => {
    switch (action.type) {
      case "SET_IS_FOCUSED":
        return { ...state, isFocused: action.payload };
      case "SET_SHOW_LINE":
        return { ...state, showLine: action.payload };
      case "SET_ACTIVE_PARENT_NAV_ITEM":
        return { ...state, activeParentNavItem: action.payload };
      case "TOGGLE_BACKGROUND_IMAGE":
        return { ...state, showBackgroundImage: action.payload };
      default:
        return state;
    }
  };
  