import React, { useState, useEffect } from "react";
import "./App.css";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";

// This will set the NUI to visible if we are developing in the browser
debugData([
  {
    action: "setVisible",
    data: true,
  },
]);

interface Setting {
  name?: string;
  value: string | number;
}

enum Category {
  Effects,
  Time,
  Timecycles,
  Weather,
  KillEffect,
}

const App: React.FC = () => {
  const [effects, setEffects] = useState<Setting[]>([]);
  const [selectedEffectIndex, setSelectedEffectIndex] = useState<number>(0);

  const [times, setTimes] = useState<number[]>([]);
  const [selectedTimeIndex, setSelectedTimeIndex] = useState<number>(0);

  const [timecycles, setTimecycles] = useState<Setting[]>([]);
  const [selectedTimecycleIndex, setSelectedTimecycleIndex] = useState<number>(0);

  const [weathers, setWeathers] = useState<Setting[]>([]);
  const [selectedWeatherIndex, setSelectedWeatherIndex] = useState<number>(0);

  const [killEffects, setKillEffects] = useState<Setting[]>([]);
  const [selectedKillEffectIndex, setSelectedKillEffectIndex] = useState<number>(0);

  const [selectedCategory, setSelectedCategory] = useState<Category>(Category.Effects);

  const [isLeftArrowPressed, setIsLeftArrowPressed] = useState(false);
  const [isRightArrowPressed, setIsRightArrowPressed] = useState(false);

  const fetchDataFromLua = async () => {
    try {
      // Fetch data for effects, times, timecycles, weathers, and kill effects from Lua
      const effectResponse = await fetchNui<{ [key: string]: string }>("getBloodFx");
      const timeSettingsResponse = await fetchNui<number[]>("getTimeSettings");
      const timecycleResponse = await fetchNui<{ [key: string]: string }>("getTimecycleSettings");
      const weatherResponse = await fetchNui<{ [key: string]: string }>("getWeatherSettings");
      const killEffectResponse = await fetchNui<{ name: string, value: number }[]>("getKillEffectSettings");
  
      // Fetch current user data
      const currentTimeResponse = await fetchNui<number>("getCurrentTimeSettings");
      // const currentEffectResponse = await fetchNui<string>("getCurrentEffectSettings");
      // const currentTimecycleResponse = await fetchNui<string>("getCurrentTimecycleSettings");
      // const currentWeatherResponse = await fetchNui<string>("getCurrentWeatherIndex");
      // const currentKillEffectResponse = await fetchNui<string>("getCurrentKillEffectSettings");
  
      setSelectedTimeIndex(currentTimeResponse);
      // setSelectedEffectIndex(effects.findIndex(effect => effect.name === currentEffectResponse));
      // setSelectedTimecycleIndex(timecycles.findIndex(timecycle => timecycle.name === currentTimecycleResponse));
      // setSelectedWeatherIndex(weathers.findIndex(weather => weather.name === currentWeatherResponse));
      // setSelectedKillEffectIndex(killEffects.findIndex(killEffect => killEffect.name === currentKillEffectResponse));
  
      // Update state with fetched data
      const effectArray = Object.entries(effectResponse).map(([name, value]) => ({ name, value }));
      setEffects(effectArray);
  
      setTimes(timeSettingsResponse);
  
      const timecycleArray = Object.entries(timecycleResponse).map(([name, value]) => ({ name, value }));
      setTimecycles(timecycleArray);
  
      const weatherArray = Object.entries(weatherResponse).map(([name, value]) => ({ name, value }));
      setWeathers(weatherArray);
  
      setKillEffects(killEffectResponse);
  
    } catch (error) {
      console.error("Failed to fetch data from Lua: ", error);
    }
  };
  
  useEffect(() => {
    fetchDataFromLua();
  }, []);

  const handleBloodFXChange = (name: string) => {
    const label = document.querySelector('.settings-item-label');
    label?.classList.add('updated');

    fetchNui("blood:changeEffect", { effectName: name });

    setTimeout(() => {
      label?.classList.remove('updated');
    }, 250);
  };

  const handleTimeChange = (hour: number) => {
    const label = document.querySelector('.settings-item-label');
    label?.classList.add('updated');

    fetchNui("effects:setTime", { hour });

    setTimeout(() => {
      label?.classList.remove('updated');
    }, 250);
  };

  const handleTimecycleChange = (type: string) => {
    const label = document.querySelector('.settings-item-label');
    label?.classList.add('updated');

    fetchNui("timecycle:changeEffect", { type });

    setTimeout(() => {
      label?.classList.remove('updated');
    }, 250);
  };

  const handleWeatherChange = (type: string) => {
    const label = document.querySelector('.settings-item-label');
    label?.classList.add('updated');

    fetchNui("weather:changeEffect", { type });

    setTimeout(() => {
      label?.classList.remove('updated');
    }, 250);
  };

  const handleKillEffectChange = (index: number) => {
    const label = document.querySelector('.settings-item-label');
    label?.classList.add('updated');
  
    fetchNui("killEffect:changeEffect", { effectIndex: index.toString() }); // Convert index to string if necessary
  
    setTimeout(() => {
      label?.classList.remove('updated');
    }, 250);
  };  

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "ArrowLeft") {
        setIsLeftArrowPressed(true);
        setTimeout(() => {
          setIsLeftArrowPressed(false);
        }, 200);
      } else if (event.key === "ArrowRight") {
        setIsRightArrowPressed(true);
        setTimeout(() => {
          setIsRightArrowPressed(false);
        }, 200);
      }
  
      switch (event.key) {
        case "ArrowUp":
          setSelectedCategory((prevCategory) => {
            switch (prevCategory) {
              case Category.Effects:
                return Category.KillEffect;
              case Category.Time:
                return Category.Effects;
              case Category.Timecycles:
                return Category.Time;
              case Category.Weather:
                return Category.Timecycles;
              case Category.KillEffect:
                return Category.Weather;
              default:
                return prevCategory;
            }
          });
          break;
        case "ArrowDown":
          setSelectedCategory((prevCategory) => {
            switch (prevCategory) {
              case Category.Effects:
                return Category.Time;
              case Category.Time:
                return Category.Timecycles;
              case Category.Timecycles:
                return Category.Weather;
              case Category.Weather:
                return Category.KillEffect;
              case Category.KillEffect:
                return Category.Effects;
              default:
                return prevCategory;
            }
          });
          break;
        case "ArrowLeft":
          if (selectedCategory === Category.Effects) {
            setSelectedEffectIndex((prevIndex) => {
              const newIndex = prevIndex === 0 ? effects.length - 1 : prevIndex - 1;
              handleBloodFXChange(effects[newIndex]?.name ?? '');
              return newIndex;
            });
          } else if (selectedCategory === Category.Time) {
            setSelectedTimeIndex((prevIndex) => {
              const newIndex = prevIndex === 0 ? times.length - 1 : prevIndex - 1;
              handleTimeChange(times[newIndex]);
              return newIndex;
            });
          } else if (selectedCategory === Category.Timecycles) {
            setSelectedTimecycleIndex((prevIndex) => {
              const newIndex = prevIndex === 0 ? timecycles.length - 1 : prevIndex - 1;
              handleTimecycleChange(timecycles[newIndex]?.name ?? '');
              return newIndex;
            });
          } else if (selectedCategory === Category.Weather) {
            setSelectedWeatherIndex((prevIndex) => {
              const newIndex = prevIndex === 0 ? weathers.length - 1 : prevIndex - 1;
              handleWeatherChange(weathers[newIndex]?.name ?? '');
              return newIndex;
            });
          } else if (selectedCategory === Category.KillEffect) {
            setSelectedKillEffectIndex((prevIndex) => {
              const newIndex = prevIndex === 0 ? killEffects.length - 1 : prevIndex - 1;
              handleKillEffectChange(newIndex);
              return newIndex;
            });
          }
          break;
        case "ArrowRight":
          if (selectedCategory === Category.Effects) {
            setSelectedEffectIndex((prevIndex) => {
              const newIndex = prevIndex === effects.length - 1 ? 0 : prevIndex + 1;
              handleBloodFXChange(effects[newIndex]?.name ?? '');
              return newIndex;
            });
          } else if (selectedCategory === Category.Time) {
            setSelectedTimeIndex((prevIndex) => {
              const newIndex = prevIndex === times.length - 1 ? 0 : prevIndex + 1;
              handleTimeChange(times[newIndex]);
              return newIndex;
            });
          } else if (selectedCategory === Category.Timecycles) {
            setSelectedTimecycleIndex((prevIndex) => {
              const newIndex = prevIndex === timecycles.length - 1 ? 0 : prevIndex + 1;
              handleTimecycleChange(timecycles[newIndex]?.name ?? '');
              return newIndex;
            });
          } else if (selectedCategory === Category.Weather) {
            setSelectedWeatherIndex((prevIndex) => {
              const newIndex = prevIndex === weathers.length - 1 ? 0 : prevIndex + 1;
              handleWeatherChange(weathers[newIndex]?.name ?? '');
              return newIndex;
            });
          } else if (selectedCategory === Category.KillEffect) {
            setSelectedKillEffectIndex((prevIndex) => {
              const newIndex = prevIndex === killEffects.length - 1 ? 0 : prevIndex + 1;
              handleKillEffectChange(newIndex);
              return newIndex;
            });
          }
          break;
        default:
          break;
      }
    };
  
    window.addEventListener("keydown", handleKeyDown);
  
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [selectedCategory, effects, times, timecycles, weathers, killEffects]);
  

  const handleKeyUp = (event: KeyboardEvent) => {
    const { key } = event;
    if (key === "ArrowLeft") {
      setIsLeftArrowPressed(false);
    } else if (key === "ArrowRight") {
      setIsRightArrowPressed(false);
    }
  };

  useEffect(() => {
    document.addEventListener("keyup", handleKeyUp);

    return () => {
      document.removeEventListener("keyup", handleKeyUp);
    };
  }, []);

  return (
    <div className="settings-menu">
      {/* <h1 className="settings-header">Graphics Settings</h1> */}
      <div className={`settings-item ${selectedCategory === Category.Effects ? 'active-item' : ''}`}>
        {selectedCategory === Category.Effects && (
          <div
            className={`settings-item-arrow-left ${isLeftArrowPressed ? "active" : ""} ${isLeftArrowPressed ? "fade-out" : ""}`}
          >
            &#9664;
          </div>
        )}
        <div className={`settings-category ${selectedCategory === Category.Effects ? "active" : ""}`}>
          <div className="settings-item-title">BloodFX</div>
          <div className={`settings-item-label ${selectedCategory === Category.Effects ? "active" : ""}`}>
            <div className={`settings-item-selected ${selectedCategory === Category.Effects ? "active" : ""}`}>
              {effects[selectedEffectIndex]?.name}
            </div>
          </div>
        </div>
        {selectedCategory === Category.Effects && (
          <div
            className={`settings-item-arrow-right ${isRightArrowPressed ? "active" : ""} ${isRightArrowPressed ? "fade-out" : ""}`}
          >
            &#9654;
          </div>
        )}
      </div>
      <div className={`settings-item ${selectedCategory === Category.Time ? 'active-item' : ''}`}>
        {selectedCategory === Category.Time && (
          <div className={`settings-item-arrow-left ${isLeftArrowPressed ? "active" : ""}`}>
            &#9664;
          </div>
        )}
        <div className={`settings-category ${selectedCategory === Category.Time ? 'active' : ''}`}>
          <div className="settings-item-title">Time</div>
          <div className="settings-item-label">
            <div className={`settings-item-selected ${selectedCategory === Category.Time ? 'active' : ''}`}>
              {times[selectedTimeIndex]}:00
            </div>
          </div>
        </div>
        {selectedCategory === Category.Time && (
          <div className={`settings-item-arrow-right ${isRightArrowPressed ? "active" : ""}`}>
            &#9654;
          </div>
        )}
      </div>
      <div className={`settings-item ${selectedCategory === Category.Timecycles ? 'active-item' : ''}`}>
        {selectedCategory === Category.Timecycles && (
          <div className={`settings-item-arrow-left ${isLeftArrowPressed ? "active" : ""}`}>
            &#9664;
          </div>
        )}
        <div className={`settings-category ${selectedCategory === Category.Timecycles ? 'active' : ''}`}>
          <div className="settings-item-title">Timecycles</div>
          <div className="settings-item-label">
            <div className={`settings-item-selected ${selectedCategory === Category.Timecycles ? 'active' : ''}`}>
              {timecycles[selectedTimecycleIndex]?.name}
            </div>
          </div>
        </div>
        {selectedCategory === Category.Timecycles && (
          <div className={`settings-item-arrow-right ${isRightArrowPressed ? "active" : ""}`}>
            &#9654;
          </div>
        )}
      </div>
      <div className={`settings-item ${selectedCategory === Category.Weather ? 'active-item' : ''}`}>
        {selectedCategory === Category.Weather && (
          <div className={`settings-item-arrow-left ${isLeftArrowPressed ? "active" : ""}`}>
            &#9664;
          </div>
        )}
        <div className={`settings-category ${selectedCategory === Category.Weather ? 'active' : ''}`}>
          <div className="settings-item-title">Weather</div>
          <div className="settings-item-label">
            <div className={`settings-item-selected ${selectedCategory === Category.Weather ? 'active' : ''}`}>
              {weathers[selectedWeatherIndex]?.name}
            </div>
          </div>
        </div>
        {selectedCategory === Category.Weather && (
          <div className={`settings-item-arrow-right ${isRightArrowPressed ? "active" : ""}`}>
            &#9654;
          </div>
        )}
      </div>
      <div className={`settings-item ${selectedCategory === Category.KillEffect ? 'active-item' : ''}`}>
        {selectedCategory === Category.KillEffect && (
          <div className={`settings-item-arrow-left ${isLeftArrowPressed ? "active" : ""}`}>
            &#9664;
          </div>
        )}
        <div className={`settings-category ${selectedCategory === Category.KillEffect ? 'active' : ''}`}>
          <div className="settings-item-title">Kill Effect</div>
          <div className="settings-item-label">
            <div className={`settings-item-selected ${selectedCategory === Category.KillEffect ? 'active' : ''}`}>
              {killEffects[selectedKillEffectIndex]?.name}
            </div>
          </div>
        </div>
        {selectedCategory === Category.KillEffect && (
          <div className={`settings-item-arrow-right ${isRightArrowPressed ? "active" : ""}`}>
            &#9654;
          </div>
        )}
      </div>
    </div>
  );
};

export default App;
