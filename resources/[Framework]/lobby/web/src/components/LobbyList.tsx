import React, { useMemo, useState } from "react";
import { LobbyData } from "./types";

interface LobbyListProps {
  lobbies: LobbyData[];
  searchTerm: string;
  selectedLobby: number | null;
  onSearchTermChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  handleLobbyItemClick: (lobbyId: number) => void;
}

const LobbyList: React.FC<LobbyListProps> = ({
  lobbies,
  searchTerm,
  selectedLobby,
  handleLobbyItemClick,
  onSearchTermChange,
}) => {
  const [activeTab, setActiveTab] = useState<"public" | "private">("public");

  const filteredLobbies = useMemo(() => {
    const baseFilter = lobbies.filter((lobby) =>
      lobby.lobbyinfo.name.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return baseFilter.filter((lobby) =>
      activeTab === "public"
        ? !lobby.lobbyinfo.passwordProtected
        : lobby.lobbyinfo.passwordProtected
    );
  }, [lobbies, searchTerm, activeTab]);

  return (
    <div className="lobby-browser-view">
      <div className="lobby-tabs">
        <button
          type="button"
          className={`lobby-tab ${activeTab === "public" ? "active" : ""}`}
          onClick={() => setActiveTab("public")}
        >
          Public Lobbies
        </button>
        <button
          type="button"
          className={`lobby-tab ${activeTab === "private" ? "active" : ""}`}
          onClick={() => setActiveTab("private")}
        >
          Private Lobbies
        </button>
        <div className="lobby-search">
          <input
            type="text"
            value={searchTerm}
            onChange={onSearchTermChange}
            placeholder="Search lobbies"
          />
        </div>
      </div>

      <div className="lobby-grid">
        {filteredLobbies.length === 0 ? (
          <div className="lobby-empty">No {activeTab} lobbies found.</div>
        ) : (
          filteredLobbies.map((lobby) => {
            const isSelected = selectedLobby === lobby.ID;
            const isPrivate = lobby.lobbyinfo.passwordProtected;
            const playerText = `${lobby.playerCount}/${lobby.lobbyinfo.maxPlayers}`;

            const recoilSubtitle =
              lobby.settings?.recoilMode &&
              lobby.settings.recoilMode !== ""
                ? `Recoil: ${lobby.settings.recoilMode}`
                : lobby.gamemode === "static"
                  ? "Static Game Mode"
                  : "Player Hosted";

            return (
              <article
                key={lobby.ID}
                className={`lobby-card ${isSelected ? "selected" : ""}`}
                onClick={() => handleLobbyItemClick(lobby.ID)}
              >
                <div className="lobby-card__banner">
                  <img
                    src={`./images/${lobby.lobbyinfo.map.toLowerCase()}.png`}
                    alt={lobby.lobbyinfo.map}
                    onError={(event) => {
                      (event.currentTarget as HTMLImageElement).src =
                        "https://picsum.photos/seed/lobby/400/200";
                    }}
                  />
                </div>
                <div className="lobby-card__body">
                  <div>
                    <div className="lobby-card__title">
                      <span>{lobby.lobbyinfo.name}</span>
                      {isPrivate && <i className="fas fa-lock"></i>}
                    </div>
                    <div className="lobby-subtitle">{recoilSubtitle}</div>
                  </div>
                </div>
                <footer className="lobby-card__footer">
                  <span className="lobby-card__players">{playerText}</span>
                  <button
                    type="button"
                    className="lobby-card__button"
                    onClick={(event) => {
                      event.stopPropagation();
                      handleLobbyItemClick(lobby.ID);
                    }}
                  >
                    Join
                  </button>
                </footer>
              </article>
            );
          })
        )}
      </div>
    </div>
  );
};

export default React.memo(LobbyList);
