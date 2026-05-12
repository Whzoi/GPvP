import React, { useState, useEffect } from 'react';
import { useNuiEvent } from './hooks/useNuiEvent';
import './Scoreboard.css';

interface ScoreboardData {
  team1Wins: number;
  team2Wins: number;
  team1Alive: number;
  team1Total: number;
  team2Alive: number;
  team2Total: number;
  currentRound: number;
  maxRounds: number;
}

const Scoreboard: React.FC = () => {
  const [visible, setVisible] = useState(false);
  const [scores, setScores] = useState<ScoreboardData>({
    team1Wins: 0,
    team2Wins: 0,
    team1Alive: 0,
    team1Total: 0,
    team2Alive: 0,
    team2Total: 0,
    currentRound: 0,
    maxRounds: 5,
  });

  useNuiEvent<boolean>('scoreboard:show', setVisible);
  useNuiEvent<boolean>('scoreboard:hide', () => setVisible(false));
  useNuiEvent<ScoreboardData>('scoreboard:update', (data) => {
    setScores(data);
  });

  if (!visible) {
    return null;
  }

  return (
    <div id="scoreboard" className="scoreboard-container">
      <div className="team" id="team1">
        <div className="team-name">TEAM 1</div>
        <div className="team-score" id="team1-score">{scores.team1Wins}</div>
        <div className="alive-count" id="team1-alive">{`${scores.team1Alive}/${scores.team1Total}`}</div>
      </div>
      <div className="round-info">
        <div className="round-title">ROUND</div>
        <div className="round-number" id="round-number">{`${scores.currentRound}/${scores.maxRounds}`}</div>
      </div>
      <div className="team" id="team2">
        <div className="team-name">TEAM 2</div>
        <div className="team-score" id="team2-score">{scores.team2Wins}</div>
        <div className="alive-count" id="team2-alive">{`${scores.team2Alive}/${scores.team2Total}`}</div>
      </div>
    </div>
  );
};

export default Scoreboard;