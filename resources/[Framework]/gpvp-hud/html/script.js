const hud = document.getElementById("hud");
const weaponCluster = document.getElementById("weaponCluster");
const weaponImage = document.getElementById("weaponImage");
const ammoClipContainer = document.getElementById("ammoClip");
const ammoTotalContainer = document.getElementById("ammoTotal");
const killfeedContainer = document.getElementById("killfeed");
const leaderboardContainer = document.getElementById("leaderboard");
const leaderboardList = document.getElementById("leaderboardList");

let lastClip = 0;
let lastTotal = 0;
let movingHud = false, isDragging = false;
const offset = { x: 0, y: 0 };
let saveTimeout = null;
const killfeedLimit = 6;
const killfeedLifetime = 5000;

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function buildKillfeedPlayer(name, subtitle) {
  const wrapper = document.createElement("div");
  wrapper.className = "killfeed-player";

  const title = document.createElement("div");
  title.className = "killfeed-name";
  title.textContent = name || "Unknown";
  wrapper.appendChild(title);

  if (subtitle) {
    const sub = document.createElement("div");
    sub.className = "killfeed-sub";
    sub.textContent = subtitle;
    wrapper.appendChild(sub);
  }

  return wrapper;
}

function addKillfeedEntry({ killerName, killerSubtitle, victimName, victimSubtitle, weaponImage }) {
  if (!killfeedContainer) return;

  const entry = document.createElement("div");
  entry.className = "killfeed-entry";

  const killerBlock = buildKillfeedPlayer(killerName || "You", killerSubtitle || "Eliminated");
  const victimBlock = buildKillfeedPlayer(victimName || "Unknown", victimSubtitle || "Victim");

  const weaponBlock = document.createElement("div");
  weaponBlock.className = "killfeed-weapon";

  const img = document.createElement("img");
  img.src = weaponImage || "images/default.png";
  img.alt = "Weapon";
  weaponBlock.appendChild(img);

  entry.appendChild(killerBlock);
  entry.appendChild(weaponBlock);
  entry.appendChild(victimBlock);

  if (killfeedContainer.children.length >= killfeedLimit) {
    killfeedContainer.removeChild(killfeedContainer.firstElementChild);
  }

  killfeedContainer.appendChild(entry);

  requestAnimationFrame(() => {
    entry.classList.add("show");
  });

  setTimeout(() => {
    entry.classList.add("fade");
  }, Math.max(0, killfeedLifetime - 800));

  setTimeout(() => {
    if (entry.parentElement === killfeedContainer) {
      killfeedContainer.removeChild(entry);
    }
  }, killfeedLifetime);
}

function formatStatValue(value) {
  if (value == null) return "0";
  return Math.floor(value);
}

function updateLeaderboard(entries = []) {
  if (!leaderboardContainer || !leaderboardList) return;

  leaderboardList.innerHTML = "";

  if (!entries || entries.length === 0) {
    leaderboardContainer.classList.remove("visible");
    return;
  }

  leaderboardContainer.classList.add("visible");

  entries.forEach((entry, index) => {
    const row = document.createElement("div");
    row.className = "leaderboard-row" + (index === 0 ? " highlight" : "");

    const rank = document.createElement("div");
    rank.className = "leaderboard-rank";
    rank.textContent = index + 1;

    const name = document.createElement("div");
    name.className = "leaderboard-name";
    name.textContent = entry.name || `Player ${entry.id || ""}`;

    const kills = document.createElement("div");
    kills.className = "leaderboard-stat";
    kills.innerHTML = `<strong>${formatStatValue(entry.kills)}</strong><span>Kills</span>`;

    const deaths = document.createElement("div");
    deaths.className = "leaderboard-stat";
    deaths.innerHTML = `<strong>${formatStatValue(entry.deaths)}</strong><span>Deaths</span>`;

    const damage = document.createElement("div");
    damage.className = "leaderboard-stat";
    damage.innerHTML = `<strong>${formatStatValue(entry.damage)}</strong><span>Damage</span>`;

    row.appendChild(rank);
    row.appendChild(name);
    row.appendChild(kills);
    row.appendChild(deaths);
    row.appendChild(damage);

    leaderboardList.appendChild(row);
  });
}

// === HUD Move & Save ===
function enableDrag() {
  hud.classList.add("draggable");
  hud.addEventListener("mousedown", startDrag);
  window.addEventListener("mousemove", onDrag);
  window.addEventListener("mouseup", stopDrag);
  window.addEventListener("keydown", savePositionOnKey);
}
function disableDrag() {
  clearTimeout(saveTimeout);
  hud.classList.remove("draggable");
  hud.removeEventListener("mousedown", startDrag);
  window.removeEventListener("mousemove", onDrag);
  window.removeEventListener("mouseup", stopDrag);
  window.removeEventListener("keydown", savePositionOnKey);
  movingHud = false;
  // Save position when disabling drag
  saveHudPosition();
}
function startDrag(e) {
  isDragging = true;
  const r = hud.getBoundingClientRect();
  offset.x = e.clientX - r.left;
  offset.y = e.clientY - r.top;
}
function onDrag(e) {
  if (!isDragging) return;
  const newX = e.clientX - offset.x;
  const newY = e.clientY - offset.y;
  hud.style.left = newX + "px";
  hud.style.top = newY + "px";
  hud.style.bottom = "unset"; hud.style.right = "unset";

  // Auto-save after dragging stops (debounced)
  clearTimeout(saveTimeout);
  saveTimeout = setTimeout(() => {
    saveHudPosition();
  }, 500);
}
function stopDrag() { 
  isDragging = false;
  // Save immediately when drag stops
  saveHudPosition();
}
function saveHudPosition() {
  const rect = hud.getBoundingClientRect();
  fetch(`https://${GetParentResourceName()}/saveHudPosition`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ x: rect.left, y: rect.top })
  }).then(() => {
    console.log(`[HUD] Position saved: ${rect.left}, ${rect.top}`);
  }).catch((err) => {
    console.error('[HUD] Failed to save position:', err);
  });
}
function savePositionOnKey(e) {
  if (e.key === "Enter" || e.key === "Escape") {
    clearTimeout(saveTimeout);
    saveHudPosition();
    disableDrag();
    fetch(`https://${GetParentResourceName()}/disableMouse`, { method: 'POST' }).catch(()=>{});
  }
}

// === Ammo Animation ===
function animateAmmoChange(container, oldVal, newVal) {
  const currentSpan = container.querySelector(".ammo-number");
  if (!currentSpan) return;
  const clone = currentSpan.cloneNode(true);
  clone.textContent = oldVal;
  clone.classList.add("drop");
  container.appendChild(clone);
  currentSpan.textContent = newVal;
  setTimeout(() => clone.remove(), 250);
}

// === NUI Messages ===
window.addEventListener("message", (event) => {
  const data = event.data || {};

 if (data.type === "toggleHud") {
        const enabled = data.enabled !== false;
        document.body.classList.toggle("hud-hidden", !enabled);
        if (!enabled && speedometerElements.wrapper) {
          speedometerElements.wrapper.style.display = "none";
          speedometerElements.wrapper.classList.add("hidden");
        }
        return;
      }

  if (data.type === "movehud") {
    movingHud = !movingHud;
    if (movingHud) {
      enableDrag();
      fetch(`https://${GetParentResourceName()}/enableMouse`, { method: 'POST' });
    } else {
      disableDrag();
      fetch(`https://${GetParentResourceName()}/disableMouse`, { method: 'POST' });
    }
    return;
  }

  if (data.type === "killfeed") {
    addKillfeedEntry(data);
    return;
  }

  if (data.type === "leaderboard") {
    updateLeaderboard(data.entries);
    return;
  }

  if (data.type === "resetHud") {
    hud.style.left = "2vw";
    hud.style.bottom = "2vh";
    hud.style.top = "unset";
    hud.style.right = "unset";
    return;
  }

  if (data.type === "applyHudPosition" && data.x != null && data.y != null) {
    hud.style.left = data.x + "px";
    hud.style.top = data.y + "px";
    hud.style.bottom = "unset"; hud.style.right = "unset";
    return;
  }

  if (data.type === "hideWeapon") {
    weaponCluster.style.display = "none";
    return;
  }

  if (data.type === "updateWeapon") {
    weaponCluster.style.display = "flex";
    if (data.weaponImage) weaponImage.src = data.weaponImage;

    const newClip = clamp(data.ammoClip || 0, 0, 999);
    const newTotal = clamp(data.ammoTotal || 0, 0, 9999);

    if (newClip < lastClip) animateAmmoChange(ammoClipContainer, lastClip, newClip);
    if (newTotal < lastTotal) animateAmmoChange(ammoTotalContainer, lastTotal, newTotal);

    ammoClipContainer.querySelector(".ammo-number").textContent = newClip;
    ammoTotalContainer.querySelector(".ammo-number").textContent = newTotal;

    lastClip = newClip;
    lastTotal = newTotal;
    return;
  }

  if (data.health !== undefined) {
    const health = clamp(data.health, 0, 100);
    const healthInner = document.getElementById("healthInner");
    const healthPercent = document.getElementById("healthPercent");
    const healthIcon = document.getElementById("healthIcon");
    healthPercent.textContent = Math.round(health) + "%";
    const gradient = health > 60
      ? "linear-gradient(90deg, #00ff88, #00cc44)"
      : health > 30
      ? "linear-gradient(90deg, #ffaa00, #ff6600)"
      : "linear-gradient(90deg, #ff3300, #aa0000)";
    healthInner.style.background = gradient;
    healthInner.style.width = health + "%";
    healthIcon.style.color = health > 60 ? "#00ff88" : health > 30 ? "#ffaa00" : "#ff3300";
  }

  if (data.armor !== undefined) {
    const armor = clamp(data.armor, 0, 100);
    document.getElementById("armorPercent").textContent = Math.round(armor) + "%";
    document.getElementById("armorIcon").style.color = armor > 0 ? "#ff00a8" : "rgba(255,255,255,0.3)";
    const segs = ["armorSeg1","armorSeg2","armorSeg3","armorSeg4"].map(id => document.getElementById(id));
    const perSeg = 25;
    segs.forEach((seg, i) => {
      const start = i * perSeg;
      const fill = Math.min(Math.max((armor - start) / perSeg, 0), 1) * 100;
      seg.style.width = fill + "%";
    });
  }
});

// === On load, request saved HUD position ===
window.addEventListener("load", () => {
  fetch(`https://${GetParentResourceName()}/requestHudPosition`, { method: 'POST' }).catch(() => {});
});