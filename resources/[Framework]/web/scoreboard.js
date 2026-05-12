window.addEventListener('load', () => {
    fetch(`https://lobby/nui_ready`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).catch(err => console.log(err));
});

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'scoreboard:show') {
        document.getElementById('scoreboard').style.display = 'flex';
    } else if (data.type === 'scoreboard:hide') {
        document.getElementById('scoreboard').style.display = 'none';
    } else if (data.type === 'scoreboard:update') {
        const team1Score = document.getElementById('team1-score');
        const team2Score = document.getElementById('team2-score');
        const team1Alive = document.getElementById('team1-alive');
        const team2Alive = document.getElementById('team2-alive');
        const roundNumber = document.getElementById('round-number');

        team1Score.textContent = data.team1Wins;
        team2Score.textContent = data.team2Wins;
        team1Alive.textContent = `${data.team1Alive}/${data.team1Total}`;
        team2Alive.textContent = `${data.team2Alive}/${data.team2Total}`;
        roundNumber.textContent = `${data.currentRound}/${data.maxRounds}`;
    }
});