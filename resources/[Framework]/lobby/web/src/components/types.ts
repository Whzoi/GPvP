// export interface LobbyData {
//   ID: number;
//   gamemode: string;
//   playerCount: number;
//   lobbyinfo: {
//     name: string;
//     tags?: string;
//     map: string;
//     maxPlayers: number;
//     passwordProtected: boolean;
//     password?: string;
//     banned: string;
//   };
// }


// new lobby data for tags and settings @TODO
export interface LobbySettings {
  recoilMode: string;
  firstPersonVehicle: boolean;
  hsMulti: boolean;
  disableFP: boolean;
  vdm: boolean;
  disableLadders: boolean;
  disableQPeeking: boolean;
  disableHighRoofs: boolean;
  skeletons: boolean;
  noRagdoll: boolean;
  barrelStuffing: boolean;
  noAutoReload: boolean;
  onlyInSafezone: boolean;
}

export interface LobbyInfo {
  name: string;
  tags?: string;
  map: string;
  maxPlayers: number;
  passwordProtected: boolean;
  password?: string;
  banned: string;
}

export interface LobbyData {
  ID: number;
  owner?: string | null;
  gamemode: string;
  playerCount: number;
  lobbyinfo: LobbyInfo;
  settings: LobbySettings;
}

export interface PlayerData {
  user_id: string;
  user_level: number;
  user_lobby: number;
  stats: {
    name: string;
    kills: number;
    damage: number;
  };
}

interface NavItem {
  name: string;
  icon: any;
}

import { GiLockers } from "react-icons/gi"; // locker

import { IoListCircle } from "react-icons/io5"; // Server List

// Removed Create Game icon from nav; using header action instead

export const navigationConfig: NavItem[] = [
  {
    name: "Servers",
    icon: IoListCircle,
  },
  // {
  //   name: "Locker",
  //   icon: GiLockers,
  // },
];