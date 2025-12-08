// src/services/weatherService.js
const axios = require('axios');

// Mock weather data for testing
const getMockWeather = (location) => ({
  location,
  current: {
    temp: 22,
    feelsLike: 20,
    humidity: 65,
    precipitation: 0,
    windSpeed: 5,
    description: 'Partly cloudy',
    icon: '02d'
  },
  forecast: [
    { 
      date: new Date().toISOString().split('T')[0],
      temp: 22, 
      tempMin: 18,
      tempMax: 25,
      humidity: 65, 
      rain: 0,
      description: 'Partly cloudy'
    },
    { 
      date: new Date(Date.now() + 86400000).toISOString().split('T')[0],
      temp: 24,
      tempMin: 19,
      tempMax: 27,
      humidity: 60, 
      rain: 5,
      description: 'Light rain'
    },
    { 
      date: new Date(Date.now() + 172800000).toISOString().split('T')[0],
      temp: 21,
      tempMin: 17,
      tempMax: 24,
      humidity: 70, 
      rain: 15,
      description: 'Rain'
    },
    { 
      date: new Date(Date.now() + 259200000).toISOString().split('T')[0],
      temp: 23,
      tempMin: 19,
      tempMax: 26,
      humidity: 58, 
      rain: 0,
      description: 'Clear'
    },
    { 
      date: new Date(Date.now() + 345600000).toISOString().split('T')[0],
      temp: 25,
      tempMin: 20,
      tempMax: 28,
      humidity: 55, 
      rain: 0,
      description: 'Sunny'
    }
  ]
});

exports.getWeather = async (location) => {
  const apiKey = process.env.OPENWEATHER_API_KEY;

  // If no API key or using mock mode
  if (!apiKey || apiKey === 'your_api_key_here') {
    console.log(`📍 Using mock weather data for: ${location}`);
    return getMockWeather(location);
  }

  try {
    // Get coordinates from location name
    const geoUrl = `http://api.openweathermap.org/geo/1.0/direct?q=${encodeURIComponent(location)}&limit=1&appid=${apiKey}`;
    const geoRes = await axios.get(geoUrl, { timeout: 5000 });

    if (!geoRes.data || geoRes.data.length === 0) {
      console.log(`❌ Location not found: ${location}, using mock data`);
      return getMockWeather(location);
    }

    const { lat, lon } = geoRes.data[0];

    // Get current weather
    const weatherUrl = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&units=metric&appid=${apiKey}`;
    const weatherRes = await axios.get(weatherUrl, { timeout: 5000 });

    // Get 5-day forecast
    const forecastUrl = `https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&units=metric&appid=${apiKey}`;
    const forecastRes = await axios.get(forecastUrl, { timeout: 5000 });

    console.log(`✅ Real weather data fetched for: ${location}`);

    return {
      location,
      current: {
        temp: Math.round(weatherRes.data.main.temp),
        feelsLike: Math.round(weatherRes.data.main.feels_like),
        humidity: weatherRes.data.main.humidity,
        precipitation: weatherRes.data.rain?.['1h'] || 0,
        windSpeed: weatherRes.data.wind.speed,
        description: weatherRes.data.weather[0].description,
        icon: weatherRes.data.weather[0].icon
      },
      forecast: forecastRes.data.list
        .filter((_, index) => index % 8 === 0) // Get one forecast per day
        .slice(0, 5)
        .map(item => ({
          date: item.dt_txt.split(' ')[0],
          temp: Math.round(item.main.temp),
          tempMin: Math.round(item.main.temp_min),
          tempMax: Math.round(item.main.temp_max),
          humidity: item.main.humidity,
          rain: item.rain?.['3h'] || 0,
          description: item.weather[0].description
        }))
    };
  } catch (error) {
    console.error(`⚠️ Weather API error for ${location}:`, error.message);
    console.log('📍 Falling back to mock weather data');
    return getMockWeather(location);
  }
};