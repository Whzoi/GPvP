import React from 'react';
import { PlayerData } from './types';

interface LeaderboardProps {
  players: PlayerData[];
}

const Leaderboard: React.FC<LeaderboardProps> = React.memo(({ players }) => {
  return (
    <div className="wrapper">
      <div className="leaderboard-list">
        <div className="leaderboard-header">
          <div className="leaderboard-name">Name</div>
          <div className="leaderboard-kills">Kills</div>
          <div className="leaderboard-damage">Damage</div>
        </div>
        {players.map((player, index) => (
          <div key={player.user_id} className="leaderboard-row">
            <div className="leaderboard-name">{player.stats.name}</div>
            <div className="leaderboard-kills">{player.stats.kills}</div>
            <div className="leaderboard-damage">{player.stats.damage}</div>
          </div>
        ))}
      </div>
    </div>
  );
});

export default Leaderboard;
