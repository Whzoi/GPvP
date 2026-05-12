import React from "react";
import { navigationConfig } from "./types";

interface NavItem {
  name: string;
  icon: React.ComponentType<any>;
}

interface NavigationBarProps {
  activeParentNavItem: string;
  onParentNavItemClick: (itemName: string) => void;
}

const NavigationBar: React.FC<NavigationBarProps> = ({
  activeParentNavItem,
  onParentNavItemClick,
}) => {
  return (
    <div className="navigation-pill-group">
      {navigationConfig.map((item) => (
        <button
          key={item.name}
          type="button"
          className={`navigation-pill ${
            activeParentNavItem === item.name ? "active" : ""
          }`}
          onClick={() => onParentNavItemClick(item.name)}
        >
          {item.name}
        </button>
      ))}
    </div>
  );
};

export default React.memo(NavigationBar);
