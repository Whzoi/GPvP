import React, { useState, useEffect } from "react";
import "./App.css";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";

// Debug in browser
debugData([
    {
        action: "setVisible",
        data: true,
    },
]);

interface CarData {
    model: string;
    image: string;
}

const App: React.FC = () => {
    const [carData, setCarData] = useState<CarData[]>([]);
    const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);
    const [visible, setVisible] = useState<boolean>(false);

    // Receive visibility updates from Lua
    useEffect(() => {
        window.addEventListener("message", (event) => {
            const data = event.data;

            if (data.action === "setVisible") {
                setVisible(data.data);
            }
        });
    }, []);

    // Fetch car data only once
    useEffect(() => {
        fetchCarDataFromLua();
    }, []);

    const fetchCarDataFromLua = async () => {
        try {
            const response = await fetchNui<CarData[]>("getCarData");
            setCarData(response);
        } catch (error) {
            console.error("Error fetching car data:", error);
        }
    };

    const handleCarSelection = (carModel: string) => {
        fetchNui("carspawner:spawnVehicle", { model: carModel });
    };

    const playClickSound = () => {
        const clickSound = document.getElementById("clickSound") as HTMLAudioElement;
        if (clickSound) {
            clickSound.currentTime = 0;
            clickSound.play();
        }
    };

    return (
        <div className="VehicleNUIRoot" style={{ display: visible ? "block" : "none" }}>
            {/* GPVP Gradient Overlay */}
            <div
                id="gpvpGradientOverlay"
                style={{
                    opacity: visible ? 1 : 0, // fade in/out
                    transition: "opacity 0.3s ease-in-out",
                }}
            />

            <audio id="clickSound" src="click_sound.mp3"></audio>

            <div className="VehicleMenu-wrapper">
                <div className="VehicleMenu-container">
                    {carData.map((car, index) => (
                        <button
                            key={index}
                            className="VehicleMenu-card"
                            onClick={() => {
                                playClickSound();
                                handleCarSelection(car.model);
                            }}
                        >
                            <img
                                src={car.image}
                                alt={car.model}
                                className="VehicleMenu-card-img"
                                onMouseEnter={() => setHoveredIndex(index)}
                                onMouseLeave={() => setHoveredIndex(null)}
                                style={{
                                    filter:
                                        hoveredIndex === index
                                            ? "brightness(0.8)"
                                            : "brightness(0.5)",
                                }}
                            />
                            <p
                                className="VehicleMenu-card-label"
                                onMouseEnter={() => setHoveredIndex(index)}
                                onMouseLeave={() => setHoveredIndex(null)}
                            >
                                {car.model}
                            </p>
                        </button>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default App;
