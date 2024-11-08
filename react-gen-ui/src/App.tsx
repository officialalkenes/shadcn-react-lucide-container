import React, { useState } from 'react';
import { Plus } from 'lucide-react';

function MemeGenerator() {
  const [image, setImage] = useState(null);
  const [text, setText] = useState('');
  const [textSize, setTextSize] = useState(24);
  const [textColor, setTextColor] = useState('#000000');
  const [textX, setTextX] = useState(10);
  const [textY, setTextY] = useState(20);
  const [dragging, setDragging] = useState(false);

  const handleImageChange = (event) => {
    setImage(URL.createObjectURL(event.target.files[0]));
  };

  const handleTextChange = (event) => {
    setText(event.target.value);
  };

  const handleSizeChange = (event) => {
    setTextSize(event.target.value);
  };

  const handleColorChange = (event) => {
    setTextColor(event.target.value);
  };

  const handleMouseDown = (event) => {
    setDragging(true);
    setTextX(event.nativeEvent.offsetX);
    setTextY(event.nativeEvent.offsetY);
  };

  const handleMouseMove = (event) => {
    if (dragging) {
      setTextX(event.nativeEvent.offsetX);
      setTextY(event.nativeEvent.offsetY);
    }
  };

  const handleMouseUp = () => {
    setDragging(false);
  };

  return (
    <div className="max-w-md mx-auto p-4">
      <h2 className="text-2xl font-bold mb-4">Meme Generator</h2>
      <input
        type="file"
        accept="image/*"
        onChange={handleImageChange}
        className="block mb-4"
      />
      <input
        type="text"
        value={text}
        onChange={handleTextChange}
        placeholder="Enter text"
        className="block mb-4 p-2 border border-gray-400 rounded"
      />
      <div className="flex mb-4">
        <label className="mr-2">Text Size:</label>
        <input
          type="range"
          min="12"
          max="48"
          value={textSize}
          onChange={handleSizeChange}
        />
      </div>
      <div className="flex mb-4">
        <label className="mr-2">Text Color:</label>
        <input
          type="color"
          value={textColor}
          onChange={handleColorChange}
        />
      </div>
      <div
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        className="relative"
      >
        {image && (
          <img src={image} alt="Meme" className="w-full h-full object-cover" />
        )}
        <canvas
          width={400}
          height={300}
          className="absolute top-0 left-0"
          ref={(canvas) => {
            if (canvas) {
              const ctx = canvas.getContext('2d');
              ctx.clearRect(0, 0, canvas.width, canvas.height);
              ctx.font = `${textSize}px Arial`;
              ctx.fillStyle = textColor;
              ctx.textAlign = 'left';
              ctx.textBaseline = 'top';
              ctx.fillText(text, textX, textY);
            }
          }}
        />
      </div>
    </div>
  );
}

const App = () => (
  <div>
    <MemeGenerator />
  </div>
);

export default App;
