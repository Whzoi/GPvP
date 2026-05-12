import React, { useState, useEffect } from 'react';
import { IoShirtSharp } from "react-icons/io5";
import { PiSunglassesBold } from "react-icons/pi";
import { PiPantsFill } from "react-icons/pi";
import { GiSonicShoes } from "react-icons/gi";
import { FaHatCowboySide } from "react-icons/fa";
import { GiJasonMask } from "react-icons/gi";
import { fetchNui } from '../utils/fetchNui';

interface ClothingItems {
  Jackets: { name: string }[];
  Pants: { name: string }[];
  Shoes: { name: string }[];
  Masks: { name: string }[];
  Glasses: { name: string }[];
  Hats: { name: string }[];
}

// const Locker: React.FC = () => {
//   const [clothingItems, setClothingItems] = useState<ClothingItems>({
//     Jackets: [],
//     Pants: [],
//     Shoes: [],
//     Masks: [],
//     Glasses: [],
//     Hats: [],
//   });

//   const [selectedCategory, setSelectedCategory] = useState<keyof ClothingItems | null>(null);
//   const [selectedItem, setSelectedItem] = useState<string | null>(null);

//   useEffect(() => {
//     const handleMessage = (event: MessageEvent) => {
//       const { type, data } = event.data;
//       if (type === "clothingData") {
//         setClothingItems(data);
//       }
//     };

//     window.addEventListener("message", handleMessage);
//     return () => window.removeEventListener("message", handleMessage);
//   }, []);

//   const handleCategorySelect = (category: keyof ClothingItems) => {
//     setSelectedCategory(category);
//     setSelectedItem(null);
  
//     fetchNui('UpdateClothingNUI', {
//       category: category,
//       itemName: null 
//     });
//   };  

//   const handleItemSelect = (item: string) => {
//     setSelectedItem(item);
//     console.log(`Selected ${selectedCategory}: ${item}`);
    
//     if (selectedCategory) {
//       fetchNui('setClothing', {
//         category: selectedCategory,
//         itemName: item
//       });
//     }
//   };

//   return (
//     <div className="locker-container">
//       <div className="left-column-clothing">
//       <div className="categories">
//           <h2>Clothing</h2>
//           {Object.keys(clothingItems).map(category => (
//             <button
//               key={category}
//               className={selectedCategory === category ? 'selected' : ''}
//               onClick={() => handleCategorySelect(category as keyof ClothingItems)}
//             >
//               {getIcon(category as keyof ClothingItems)}
//             </button>
//           ))}
//         </div>
//         <div className="items">
//           <h3>{selectedCategory}</h3>
//           {selectedCategory && (
//             <ul>
//               {clothingItems[selectedCategory].map(item => (
//                 <li key={item.name}>
//                   <button
//                     className={selectedItem === item.name ? 'selected' : ''}
//                     onClick={() => handleItemSelect(item.name)}
//                   >
//                     <img src={`./clothing/${item.name}.png`} alt={item.name} className="item-icon" />
//                     {/* <label className="item-label">{item.name}</label> */}
//                   </button>
//                 </li>
//               ))}
//             </ul>
//           )}
//         </div>
//       </div>
//       <div className="middle-column-clothing">
//       </div>
//       <div className="right-column-clothing">
//         {/* <div className="items">
//           <h3>{selectedCategory ? `Select ${selectedCategory}` : 'Select a category'}</h3>
//           {selectedCategory && (
//             <ul>
//               {clothingItems[selectedCategory].map(item => (
//                 <li key={item.name}>
//                   <button
//                     className={selectedItem === item.name ? 'selected' : ''}
//                     onClick={() => handleItemSelect(item.name)}
//                   >
//                     <img src={`./clothing/${item.name}.png`} alt={item.name} className="item-icon" />
//                     <label className="item-label">{item.name}</label>
//                   </button>
//                 </li>
//               ))}
//             </ul>
//           )}
//         </div> */}
//       </div>
//     </div>
//   );
// };

// const getIcon = (category: keyof ClothingItems) => {
//   switch (category) {
//     case 'Jackets':
//       return <IoShirtSharp />;
//     case 'Glasses':
//       return <PiSunglassesBold />;
//     case 'Pants':
//       return <PiPantsFill />;
//     case 'Shoes':
//       return <GiSonicShoes />;
//     case 'Hats':
//       return <FaHatCowboySide />;
//     case 'Masks':
//       return <GiJasonMask />;
//     default:
//       return null;
//   }
// };

// export default Locker;
