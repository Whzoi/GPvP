var ctx = document.getElementsByTagName("canvas")[0].getContext("2d");
ctx.scale(1.0, 1.0);

function drawNeedle(rotation) {
  ctx.lineWidth = 7;

  ctx.save();
  ctx.beginPath();
  ctx.translate(100, 100);
  ctx.rotate(rotation);
  ctx.shadowColor = "rgba(255, 255, 255, 0.4)";
  ctx.shadowOffsetX = 0;
  ctx.shadowOffsetY = 0;
  ctx.shadowBlur = 10;
  ctx.strokeStyle = "rgba(0, 174, 239)";
  ctx.strokeRect(-29 / 2 + 80, -1 / 2, 15, 1);
  ctx.restore();
  ctx.closePath();
}

function calcAngle(x, a, b) {
  let degree = (a - b) * x + b;
  let radian = (degree * Math.PI) / 180;
  return radian <= 2.45 ? radian : 1.45;
}

function loadProgress(percentage) {
  let linesCount = percentage / 1.25 - 20;
  ctx.clearRect(0, 0, 200, 200);
  $("#loadProgress").html(percentage + "%");
  for (var i = -20; i < linesCount; i += 3) {
    drawNeedle(calcAngle(i / 85, 120.0, 0.0) * Math.PI);
  }
}

window.addEventListener("message", function (e) {
  if (e.data.eventName === "loadProgress") {
    loadProgress(parseInt(e.data.loadFraction * 100));
  }
});


onNet('getDiscordID', () => {
    const src = global.source;
    const identifiers = getPlayerIdentifiers(src);
    let discordID = 'Unknown';

    for (const id of identifiers) {
        if (id.startsWith('discord:')) {
            discordID = id.replace('discord:', '');
            break;
        }
    }

    emitNet('sendDiscordID', src, discordID);
});

onNet('sendDiscordID', (discordID) => {
    SendNuiMessage(JSON.stringify({
        action: 'setDiscordID',
        id: discordID
    }));
});

// Trigger request on player spawn or UI open
setTimeout(() => {
    emit('getDiscordID');
}, 1000);



loadProgress(0);