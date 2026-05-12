import React, { useRef, useState } from 'react';
import { fetchNui } from '../utils/fetchNui';
import { playSound } from './SoundManager';
import './scss/_createCustom.scss'

interface Settings {
  helmets: boolean;
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

const CreateLobby: React.FC = () => {
  const [lobbyMap, setLobbyMap] = useState('southside');
  const [recoilMode, setRecoilMode] = useState('roleplay');
  const [password, setPassword] = useState('');
  const [settings, setSettings] = useState({
    helmets: false,
    firstPersonVehicle: false,
    hsMulti: false,
    disableFP: false,
    vdm: false,
    disableLadders: false,
    disableQPeeking: false,
    disableHighRoofs: false,
    skeletons: false,
    noRagdoll: false,
    barrelStuffing: false,
    noAutoReload: false,
    onlyInSafezone: false,
  });

  const maps = [
    { value: 'southside', label: 'Southside', imageUrl: 'images/southside.png' },
    { value: 'mirrorpark', label: 'Mirror Park', imageUrl: 'images/mirrorpark.png' },
    { value: 'sandy', label: 'Sandy Shores', imageUrl: 'https://cdn.global-rp.com/i/af53b5350db503c3253b29671d2fbd90.webp' },
    { value: 'vinewood', label: 'Vinewood', imageUrl: 'https://cdn.global-rp.com/i/8418c8c3901967ede89ce6d71a688f32.webp' },
    { value: 'morningwood', label: 'Morningwood', imageUrl: 'https://cdn.global-rp.com/i/b15ea039df67ee84ada2af336b5369ab.webp' },
    { value: 'littleseoul', label: 'Little Seoul', imageUrl: 'images/littleseoul.png' },
  ];

  const recoilModes = [
    { value: 'roleplay', label: 'Roleplay' },
    { value: 'roleplay2', label: 'Roleplay 2' },
    { value: 'roleplay3', label: 'Car Fights' },
    { value: 'gpvp', label: 'GPVP' },
    { value: 'pma', label: 'PMA' },
    { value: 'cmplx', label: 'Complex' },
    { value: 'qb', label: 'QBCore' },
    // { value: 'hardcore', label: 'Hardcore' },
  ];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    const passwordProtected = password !== '';

    fetchNui('Lobby:Create', {
      map: lobbyMap,
      passwordProtected,
      password,
      recoilMode,
      ...settings,
    }).then((response: any) => {
      if (response.success) {
        console.log('Lobby created successfully');
      } else {
        console.error('Failed to create lobby');
      }
    }).catch(err => console.error('Error in NUI Callback:', err));
  };

  const toggleSetting = (settingName: keyof Settings) => {
    setSettings(prevSettings => ({
      ...prevSettings,
      [settingName]: !prevSettings[settingName],
    }));
    playSound("checkbox");
  };

  const settingItems = [
    { name: 'helmets', label: 'Helmets' },
    { name: 'firstPersonVehicle', label: 'First Person Vehicle' },
    { name: 'hsMulti', label: 'HS Multi' },
    { name: 'disableFP', label: 'Disable First Person' },
    { name: 'disableLadders', label: 'Disable Ladders' },
    { name: 'disableQPeeking', label: 'Disable Q Peeking' },
    { name: 'disableHighRoofs', label: 'Disable High Roofs' },
    { name: 'carRagdoll', label: 'Car Ragdolling' },
    { name: 'vdm', label: 'VDM' },
    { name: 'skeletons', label: 'Esp' },
    { name: 'noRagdoll', label: 'No Ragdoll' },
    { name: 'barrelStuffing', label: 'Barrel Stuffing' },
    { name: 'noAutoReload', label: 'No Auto Reload' },
    { name: 'onlyInSafezone', label: 'Only Spawn Cars Safezone' },
  ];

  // Map drag scroll handlers
  const mapStripRef = useRef<HTMLDivElement | null>(null);
  const [isDragging, setIsDragging] = useState(false);
  const [dragStartX, setDragStartX] = useState(0);
  const [scrollStartX, setScrollStartX] = useState(0);
  const [dragMoved, setDragMoved] = useState(false);

  const handleMapMouseDown = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!mapStripRef.current) return;
    setIsDragging(true);
    setDragMoved(false);
    setDragStartX(e.clientX);
    setScrollStartX(mapStripRef.current.scrollLeft);
  };
  const handleMapMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!isDragging || !mapStripRef.current) return;
    const dx = e.clientX - dragStartX;
    if (Math.abs(dx) > 5) setDragMoved(true);
    mapStripRef.current.scrollLeft = scrollStartX - dx;
  };
  const handleMapMouseUp = () => {
    setIsDragging(false);
  };
  const handleMapMouseLeave = () => {
    setIsDragging(false);
  };
  const handleMapItemClick = (e: React.MouseEvent<HTMLDivElement>, value: string) => {
    if (dragMoved) {
      e.preventDefault();
      e.stopPropagation();
      return;
    }
    setLobbyMap(value);
    playSound('checkbox');
  };
  // Touch support
  const handleMapTouchStart = (e: React.TouchEvent<HTMLDivElement>) => {
    if (!mapStripRef.current) return;
    setIsDragging(true);
    setDragMoved(false);
    setDragStartX(e.touches[0].clientX);
    setScrollStartX(mapStripRef.current.scrollLeft);
  };
  const handleMapTouchMove = (e: React.TouchEvent<HTMLDivElement>) => {
    if (!isDragging || !mapStripRef.current) return;
    const dx = e.touches[0].clientX - dragStartX;
    if (Math.abs(dx) > 5) setDragMoved(true);
    mapStripRef.current.scrollLeft = scrollStartX - dx;
  };
  const handleMapTouchEnd = () => {
    setIsDragging(false);
  };

  return (
    <div className="create-lobby-container">
      <form onSubmit={handleSubmit} className="create-lobby-form">
        <div className="left-column"></div>
        <div className="middle-column">
        <div>
        <h2>MAP SELECT</h2>
        <div
            className="dropdown-wrapper-map"
            ref={mapStripRef}
            onMouseDown={handleMapMouseDown}
            onMouseMove={handleMapMouseMove}
            onMouseUp={handleMapMouseUp}
            onMouseLeave={handleMapMouseLeave}
            onTouchStart={handleMapTouchStart}
            onTouchMove={handleMapTouchMove}
            onTouchEnd={handleMapTouchEnd}
          >
              {maps.map((map) => (
                <div
                  key={map.value}
                  className={`dropdown-item-img ${lobbyMap === map.value ? 'selected' : ''}`}
                  onClick={(e) => handleMapItemClick(e, map.value)}
                >
                  <img src={map.imageUrl} alt={map.label} />
                  <h2 className='map=label'>{map.label}</h2>
                  <span className="map-label">{map.label}</span>
                </div>
              ))}
            </div>
          </div>
          <div>
          <h2>RECOIL SELECT</h2>
          <div className="recoil-select">
            <select
              className="recoil-select__control"
              value={recoilMode}
              onChange={(e) => { setRecoilMode(e.target.value); playSound("checkbox"); }}
            >
              {recoilModes.map((mode) => (
                <option key={mode.value} value={mode.value}>{mode.label}</option>
              ))}
            </select>
          </div>
          <h2>Password</h2>
          <div className="password-settings-row">
            <div className="create-lobby-password">         
              <input
                className="create-lobby-password-input"
                id="password"
                type="password"
                value={password}
                placeholder="(optional)"
                onChange={(e) => setPassword(e.target.value)}
              />
              <button
                type="submit"
                className="create-button"
                onClick={() => playSound("click")}
              >
                create lobby
              </button>
            </div>
          <div className="settings-column">
            {settingItems.map((item) => (
              <div 
                key={item.name} 
                className={`checkbox-wrapper-8 ${settings[item.name as keyof Settings] ? 'checked' : ''}`}
                >
                  <label>{item.label}</label>
                  <input
                    className="tgl tgl-skewed"
                    id={`cb3-${item.name}`}
                    type="checkbox"
                    checked={settings[item.name as keyof Settings]}
                    onChange={() => {
                      toggleSetting(item.name as keyof Settings);
                    }}
                    onClick={(e) => {
                      e.stopPropagation();
                    }}
                    onFocus={(e) => {
                      e.target.blur();
                    }}
                  />
                  <label 
                    className="tgl-btn" 
                    data-tg-off="OFF" 
                    data-tg-on="ON" 
                    htmlFor={`cb3-${item.name}`}
                    onClick={(e) => {
                      e.stopPropagation();
                    }}
                  ></label>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
  );
};

export default CreateLobby;
