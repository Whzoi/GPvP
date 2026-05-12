import React, { useEffect, useReducer, useState } from "react";
import "./scss/App.scss";
import "react-toastify/dist/ReactToastify.css";

import { debugData } from "../utils/debugData";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { Slide, ToastContainer, toast } from "react-toastify";
import { playSound } from "./SoundManager";
import { appReducer, initialState } from "./appReducer";
import { LobbyData, PlayerData } from "./types";

import NavigationBar from "./NavigationBar";
import PasswordPopup from "./PasswordPopup";
import LobbyList from "./LobbyList";
import { fetchNui } from "../utils/fetchNui";
import CreateLobby from "./CreateLobby";
import { FaCirclePlus } from "react-icons/fa6";
// import Locker from "./Locker";
import useMockData from "./useMockNuiEvent";

debugData([{ action: "setVisible", data: true }]);

const App: React.FC = () => {
  const [state, dispatch] = useReducer(appReducer, initialState);
  const [lobbies, setLobbies] = useState<LobbyData[]>([]);
  const [players, setPlayers] = useState<PlayerData[]>([]);
  const [activeParentNavItem, setactiveParentNavItem] = useState<string>("Servers");

  const {
    selectedLobby,
    inputPassword,
    showPasswordPopup,
    isFocused,
    showLine,
    searchTerm,
  } = state;

  useEffect(() => {
    const idSet = new Set(lobbies.map((lobby) => lobby.ID));
    if (idSet.size !== lobbies.length) {
      console.error("Duplicate IDs found in lobbies data");
    }
  }, [lobbies]);

  useEffect(() => {
    if (isFocused) {
      dispatch({ type: "SET_SHOW_LINE", payload: true });
    } else {
      const timer = setTimeout(() => {
        dispatch({ type: "SET_SHOW_LINE", payload: false });
      }, 700);
      return () => clearTimeout(timer);
    }
  }, [isFocused]);

  useMockData<LobbyData>(setLobbies, 10, "lobby");
  // useMockData<PlayerData>(setPlayers, 0, 'player');

  useNuiEvent<PlayerData>("setPlayers", (userData) => {
    console.log(JSON.stringify(userData));
    const existingIndex = players.findIndex(
      (p) => p.user_id === userData.user_id
    );
    if (existingIndex !== -1) {
      const updatedPlayers = [...players];
      updatedPlayers[existingIndex] = userData;
      setPlayers(updatedPlayers);
    } else {
      setPlayers([...players, userData]);
    }
  });
  useNuiEvent<LobbyData[]>("setLobbies", setLobbies);

  useNuiEvent<string>("SetActiveNavItem", (newActiveNavItem) => {
    setactiveParentNavItem(newActiveNavItem);
  });  

  const handleSearchTermChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    dispatch({ type: "SET_SEARCH_TERM", payload: e.target.value });
  };

  const togglePasswordPopup = (show: boolean) => {
    dispatch({ type: "TOGGLE_PASSWORD_POPUP", payload: show });
  };

  const handlePasswordInput = (event: React.ChangeEvent<HTMLInputElement>) => {
    dispatch({ type: "SET_INPUT_PASSWORD", payload: event.target.value });
  };

  const handlePasswordSubmit = () => {
    const selectedLobbyInfo = lobbies.find(
      (lobby) => lobby.ID === selectedLobby
    );
    const isCorrectPassword =
      inputPassword === selectedLobbyInfo?.lobbyinfo.password;

    playSound("click");
    dispatch({ type: "SET_SHOW_LINE", payload: true });

    if (isCorrectPassword) {
      togglePasswordPopup(false);
      JoinLobby(selectedLobbyInfo.ID);
    } else {
      if (inputPassword) {
        toast.error("Incorrect password");
        playSound("error");
      }
      togglePasswordPopup(false);
    }
  };

  const handlePasswordCancel = () => {
    dispatch({ type: "TOGGLE_PASSWORD_POPUP", payload: false });
    playSound("click");
  };

  const handleParentNavItemClick = (itemName: string) => {
    dispatch({ type: "SET_ACTIVE_PARENT_NAV_ITEM", payload: itemName });

    playSound("click");
    setactiveParentNavItem(itemName);
  };

  const handleCloseMenu = () => {
    fetchNui("closeMenu").catch(() => {
      // Silent catch to avoid surfacing errors if the endpoint is not available during development.
    });
    playSound("click");
  };

  const handleCreateButton = () => {
    handleParentNavItemClick("Create");
    playSound("click");
  };

  // Handle Escape key to close UI
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "Escape") {
        handleCloseMenu();
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, []);

  const JoinLobby = (lobbyId: number) => {
    const lobby = lobbies.find((l) => l.ID === lobbyId);
    if (!lobby) {
      console.error("Lobby not found");
      return;
    }

    // Example: Assuming the first player is the current user (which might not be correct)
    // You should replace this logic with the actual way to identify the current user
    const currentUser = players[0];
    if (!currentUser) {
      console.error("Current user not found");
      return;
    }

    fetchNui("Lobby:Join", { lobbyId: lobbyId, user_id: currentUser.user_id })
      .then(() => {
        toast.success(`Joined lobby: ${lobby.lobbyinfo.name}`);
        playSound("success");
      })
      .catch((e) => {
        console.error("Error joining lobby", e);
      });
  };

  const handleLobbyItemClick = (lobbyId: number) => {
    const lobby = lobbies.find((l) => l.ID === lobbyId);
    if (!lobby) {
      console.error("Lobby not found");
      return;
    }

    playSound("click");
    dispatch({ type: "SET_INPUT_PASSWORD", payload: "" });

    // Check if the selected lobby matches and then perform checks
    if (selectedLobby === lobby.ID) {
      if (lobby.lobbyinfo.maxPlayers === lobby.playerCount) {
        toast.error("Lobby Is Full");
        playSound("error");
        return; // Exit the function early
      }

      // Check if the current user is banned from the lobby
      const isBanned = players.some((player) =>
        lobby.lobbyinfo.banned.includes(player.user_id)
      );
      if (isBanned) {
        toast.error("You are banned");
        playSound("error");
        return; // Exit the function early
      }

      if (!lobby.lobbyinfo.passwordProtected) {
        JoinLobby(lobby.ID);
      } else {
        togglePasswordPopup(true);
      }
    } else {
      dispatch({ type: "SET_SELECTED_LOBBY", payload: lobby.ID });
    }
  };

  const [showBackgroundImage, setShowBackgroundImage] = useState<boolean>(false);

  useNuiEvent<boolean>("toggleBackgroundImage", (showImage) => {
    setShowBackgroundImage(showImage);
  });

  // Handle "Page:Leave" event
  useNuiEvent<any>("Page:Leave", () => {
    // console.log(`Page left: ${activeNavItem}`);

    fetchNui("Page:Leave", { page: activeParentNavItem })
      .then((response) => {
        // console.log(`Page:Leave response:`, response);
      })
      .catch((error) => {
        // console.error(`Error sending Page:Leave:`, error);
      });
  });

  // Handle "Page:Join" event
  useNuiEvent<any>("Page:Join", () => {
    // console.log(`Page joined: ${activeNavItem}`);

    fetchNui("Page:Join", { page: activeParentNavItem })
      .then((response) => {
        // console.log(`Page:Join response:`, response);
      })
      .catch((error) => {
        // console.error(`Error sending Page:Join:`, error);
      });
  });

  // Use effect to handle the activeNavItem changes
  useEffect(() => {
    // Send page join event
    fetchNui("Page:Join", { page: activeParentNavItem })
      .then((response) => {
        // console.log(`Page:Join response:`, response);
      })
      .catch((error) => {
        console.error(`Error sending Page:Join:`, error);
      });

    // Log page join
    // console.log(`Joined page: ${activeNavItem}`);

    // Cleanup function to send page leave event
    return () => {
      fetchNui("Page:Leave", { page: activeParentNavItem })
        .then((response) => {
          // console.log(`Page:Leave response:`, response);
        })
        .catch((error) => {
          console.error(`Error sending Page:Leave:`, error);
        });
      // Log page leave
      // console.log(`Left page: ${activeNavItem}`);
    };
  }, [activeParentNavItem]);

  return (
    <div className="app-shell">
      <ToastContainer
        position="bottom-right"
        autoClose={2500}
        limit={3}
        hideProgressBar
        newestOnTop
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        theme="dark"
        transition={Slide}
      />
      <div className="app-shell__content">
        <div className="lobby-ui">
          <header className="lobby-toolbar">
            <div className="lobby-toolbar__copy">
              <h1>Lobbies</h1>
              <span>Choose a lobby or host your own match.</span>
            </div>
            <div className="toolbar-actions">

              <button
                className="header-action header-action__create"
                title="Create Lobby"
                onClick={handleCreateButton}
              >
                <span className="header-action__icon">+</span>
              </button>

            </div>
          </header>
          <NavigationBar
            activeParentNavItem={activeParentNavItem}
            onParentNavItemClick={handleParentNavItemClick}
          />
          <main className="lobby-surface">
            {activeParentNavItem === "Servers" && (
              <LobbyList
                lobbies={lobbies}
                searchTerm={searchTerm}
                selectedLobby={selectedLobby}
                handleLobbyItemClick={handleLobbyItemClick}
                onSearchTermChange={handleSearchTermChange}
              />
            )}
            {activeParentNavItem === "Create" && <CreateLobby />}
            {/* {activeParentNavItem === "Locker" && <Locker />} */}
          </main>
        </div>
      </div>
      {showPasswordPopup && (
        <PasswordPopup
          inputPassword={inputPassword}
          onPasswordChange={handlePasswordInput}
          onPasswordSubmit={handlePasswordSubmit}
          onPasswordCancel={handlePasswordCancel}
          onInputFocus={() =>
            dispatch({ type: "SET_IS_FOCUSED", payload: true })
          }
          onInputBlur={() =>
            dispatch({ type: "SET_IS_FOCUSED", payload: false })
          }
          isFocused={isFocused}
          showLine={showLine}
        />
      )}
    </div>
  );
};

export default App;
