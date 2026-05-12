import React, { useState } from "react";
import FadeIn from "react-fade-in";

interface PasswordPopupProps {
  inputPassword: string;
  showLine: boolean;
  isFocused: boolean;
  onPasswordChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
  onPasswordSubmit: () => void;
  onPasswordCancel: () => void;
  onInputFocus: () => void;
  onInputBlur: () => void;
}

const PasswordPopup: React.FC<PasswordPopupProps> = React.memo(({
  inputPassword,
  showLine,
  isFocused,
  onPasswordChange,
  onPasswordSubmit,
  onPasswordCancel,
  onInputFocus,
  onInputBlur,
}) => {
  const [lineStrokeWidth, setLineStrokeWidth] = useState(1);

  return (
    <div className="password-popup">
      <FadeIn>
        <div className="password-popup-content">
          <input
            type="password"
            placeholder="Enter password"
            value={inputPassword}
            onChange={onPasswordChange}
            onFocus={onInputFocus}
            onBlur={onInputBlur}
            onMouseEnter={() => setLineStrokeWidth(3)}
            onMouseLeave={() => setLineStrokeWidth(1)}
          />
          <svg
            className="line"
            style={{ position: "relative" }}
            width="250"
            height="10"
            xmlns="http://www.w3.org/2000/svg"
          >
            <line
              x1="0"
              y1="5"
              x2="250"
              y2="5"
              style={{
                stroke: "black",
                strokeWidth: lineStrokeWidth,
                transition: "all 0.2s ease-in-out",
              }}
            />
            {showLine && (
              <line
                className={`line-container ${isFocused ? "expand" : "collapse"}`}
                x1="0"
                y1="5"
                x2="250"
                y2="5"
                stroke="#1289da"
                strokeWidth="3"
              />
            )}
          </svg>
          <div className="password-buttons">
            <button className="cancel" onClick={onPasswordCancel}>
              Cancel
            </button>
            <button className="submit" onClick={onPasswordSubmit}>
              Submit
            </button>
          </div>
        </div>
      </FadeIn>
    </div>
  );
});

export default PasswordPopup;
