import { useEffect } from "react";
import { LobbyData, PlayerData, LobbySettings } from "./types";

const generateTagsFromSettings = (settings: LobbySettings): string => {
  const tags: string[] = [];

  if (settings.hsMulti) tags.push("Headshots");
  if (settings.disableLadders) tags.push("Blocked Ladders");
  if (settings.firstPersonVehicle) tags.push("First Person Vehicles");
  if (settings.disableFP) tags.push("Disable FP");
  if (settings.vdm) tags.push("Disable FP");
  if (settings.disableQPeeking) tags.push("Disable Q Peeking");
  if (settings.disableHighRoofs) tags.push("Disable High Roofs");
  if (settings.skeletons) tags.push("Skeletons");
  if (settings.noRagdoll) tags.push("No Ragdoll");
  if (settings.barrelStuffing) tags.push("Barrel Stuffing");
  if (settings.noAutoReload) tags.push("No Auto Reload");
  if (settings.onlyInSafezone) tags.push("Only In Safezone");

  return tags.join(", ");
};

const generateRandomLobby = (id: number): LobbyData => {
  const settings: LobbySettings = {
    recoilMode: "normal",
    firstPersonVehicle: Math.random() < 0.5,
    hsMulti: Math.random() < 0.5,
    disableFP: Math.random() < 0.5,
    vdm: Math.random() < 0.5,
    disableLadders: Math.random() < 0.5,
    disableQPeeking: Math.random() < 0.5,
    disableHighRoofs: Math.random() < 0.5,
    skeletons: Math.random() < 0.5,
    noRagdoll: Math.random() < 0.5,
    barrelStuffing: Math.random() < 0.5,
    noAutoReload: Math.random() < 0.5,
    onlyInSafezone: Math.random() < 0.5,
  };

  return {
    ID: id,
    playerCount: Math.floor(Math.random() * 10),
    gamemode: "custom",
    lobbyinfo: {
      name: `Random Lobby ${id}`,
      map: ["Southside", "Downtown", "Suburbs"][Math.floor(Math.random() * 3)],
      tags: generateTagsFromSettings(settings),
      maxPlayers: 10,
      passwordProtected: Math.random() < 0.5,
      password: Math.random() < 0.5 ? "123" : "",
      banned: Math.random() < 0.5 ? "Ninja420" : "",
    },
    settings,
  };
};

const generateRandomPlayer = (id: number): PlayerData => ({
  user_id: `User${id}`,
  user_level: Math.floor(Math.random() * 100),
  user_lobby: 0,
  stats: {
    name: `Player ${id}`,
    kills: Math.floor(Math.random() * 100),
    damage: Math.floor(Math.random() * 10000),
  },
});

const initialMockLobbies: LobbyData[] = [
  // {
  //   ID: 1,
  //   playerCount: 1,
  //   gamemode: "custom",
  //   lobbyinfo: {
  //     name: "Banned Lobby",
  //     map: "Southside",
  //     tags: "Headshots, first person",
  //     maxPlayers: 10,
  //     passwordProtected: true,
  //     password: "123",
  //     banned: "29123",
  //   },
  //   settings: {
  //     recoilMode: "normal",
  //     firstPersonVehicle: false,
  //     hsMulti: true,
  //     disableFP: false,
  //     disableLadders: false,
  //     disableQPeeking: true,
  //     disableHighRoofs: true,
  //     skeletons: false,
  //     noRagdoll: true,
  //     barrelStuffing: false,
  //     noAutoReload: true,
  //     onlyInSafezone: false,
  //   },
  // },
  // {
  //   ID: 2,
  //   playerCount: 3,
  //   gamemode: "custom",
  //   lobbyinfo: {
  //     name: "Ninja420's Lobby",
  //     map: "Southside",
  //     tags: "Headshots, casual",
  //     maxPlayers: 10,
  //     passwordProtected: false,
  //     password: "",
  //     banned: "",
  //   },
  //   settings: {
  //     recoilMode: "normal",
  //     firstPersonVehicle: true,
  //     hsMulti: false,
  //     disableFP: true,
  //     disableLadders: true,
  //     disableQPeeking: false,
  //     disableHighRoofs: false,
  //     skeletons: true,
  //     noRagdoll: false,
  //     barrelStuffing: true,
  //     noAutoReload: false,
  //     onlyInSafezone: true,
  //   },
  // },
  // {
  //   ID: 3,
  //   playerCount: 10,
  //   gamemode: "custom",
  //   lobbyinfo: {
  //     name: "Full Lobby",
  //     map: "Southside",
  //     tags: "Headshots",
  //     maxPlayers: 10,
  //     passwordProtected: true,
  //     password: "123",
  //     banned: "",
  //   },
  //   settings: {
  //     recoilMode: "normal",
  //     firstPersonVehicle: true,
  //     hsMulti: true,
  //     disableFP: true,
  //     disableLadders: true,
  //     disableQPeeking: true,
  //     disableHighRoofs: true,
  //     skeletons: true,
  //     noRagdoll: true,
  //     barrelStuffing: true,
  //     noAutoReload: true,
  //     onlyInSafezone: true,
  //   },
  // },
  // {
  //   ID: 4,
  //   playerCount: 1,
  //   gamemode: "custom",
  //   lobbyinfo: {
  //     name: "Locked Lobby",
  //     map: "Southside",
  //     tags: "Headshots, First Person",
  //     maxPlayers: 10,
  //     passwordProtected: true,
  //     password: "123",
  //     banned: "",
  //   },
  //   settings: {
  //     recoilMode: "normal",
  //     firstPersonVehicle: false,
  //     hsMulti: true,
  //     disableFP: true,
  //     disableLadders: true,
  //     disableQPeeking: false,
  //     disableHighRoofs: false,
  //     skeletons: true,
  //     noRagdoll: false,
  //     barrelStuffing: true,
  //     noAutoReload: false,
  //     onlyInSafezone: true,
  //   },
  // },
];

const initialMockPlayers: PlayerData[] = [
  {
    user_id: "29123",
    user_level: 5,
    user_lobby: 0,
    stats: {
      name: "Ninja420",
      kills: 223231,
      damage: 123333,
    },
  },
];

function setMockData<T>(
  handler: React.Dispatch<React.SetStateAction<T[]>>,
  NumberOfItems: number,
  dataType: 'lobby' | 'player'
) {
  useEffect(() => {
    let data: T[] = [];

    if (dataType === 'lobby') {
      data = [
        ...initialMockLobbies,
        ...Array.from({ length: NumberOfItems }, (_, index) => generateRandomLobby(index + initialMockLobbies.length + 1)),
      ] as unknown as T[];
    } else if (dataType === 'player') {
      data = [
        ...initialMockPlayers,
        ...Array.from({ length: NumberOfItems }, (_, index) => generateRandomPlayer(index + initialMockPlayers.length + 1)),
      ] as unknown as T[];
    }

    handler(data);

  }, [handler, NumberOfItems, dataType]);
}

export default setMockData;