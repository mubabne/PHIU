require('dotenv').config();
const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// In-memory storage
let fields = [];
let sensorReadings = [];
let users = [];

// Urgats database
const cropDatabase = {
  wheat: { 
    growingDays: 120, 
    waterNeed: 'medium', 
    tempRange: [15, 25],
    soilMoisture: { min: 40, max: 60 }
  },
  rice: { 
    growingDays: 150, 
    waterNeed: 'high', 
    tempRange: [20, 35],
    soilMoisture: { min: 70, max: 90 }
  },
  corn: { 
    growingDays: 90, 
    waterNeed: 'medium', 
    tempRange: [18, 27],
    soilMoisture: { min: 50, max: 70 }
  },
  maize: { 
    growingDays: 90, 
    waterNeed: 'medium', 
    tempRange: [18, 27],
    soilMoisture: { min: 50, max: 70 }
  },
  tomato: { 
    growingDays: 80, 
    waterNeed: 'medium', 
    tempRange: [18, 26],
    soilMoisture: { min: 50, max: 65 }
  },
  potato: { 
    growingDays: 100, 
    waterNeed: 'medium', 
    tempRange: [15, 20],
    soilMoisture: { min: 45, max: 60 }
  },
  carrot: { 
    growingDays: 70, 
    waterNeed: 'medium', 
    tempRange: [16, 21],
    soilMoisture: { min: 50, max: 65 }
  },
  lettuce: { 
    growingDays: 45, 
    waterNeed: 'high', 
    tempRange: [15, 20],
    soilMoisture: { min: 60, max: 75 }
  }
};

//Tsag agaariin service

const getMockWeather = (location) => ({
  location,
  current: {
    temp: 22,
    feelsLike: 20,
    humidity: 65,
    precipitation: 0,
    windSpeed: 5,
    description: 'Хэсэгчилсэн үүлтэй',
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
      description: 'Хэсэгчилсэн үүлтэй'
    },
    { 
      date: new Date(Date.now() + 86400000).toISOString().split('T')[0],
      temp: 24,
      tempMin: 19,
      tempMax: 27,
      humidity: 60, 
      rain: 5,
      description: 'Шиврээ бороотой'
    },
    { 
      date: new Date(Date.now() + 172800000).toISOString().split('T')[0],
      temp: 21,
      tempMin: 17,
      tempMax: 24,
      humidity: 70, 
      rain: 15,
      description: 'Бороотой'
    }
  ]
});

async function getWeather(location) {
  const apiKey = process.env.OPENWEATHER_API_KEY;

  if (!apiKey || apiKey === 'https://api.openweathermap.org/data/2.5/weather?q=Ulaanbaatar&appid=f0a2505cd5a5cb30ea1290e43b8a2e4a') {
    console.log(`Орон нутаг: ${location}`);
    return getMockWeather(location);
  }

  try {
    const geoUrl = `http://api.openweathermap.org/geo/1.0/direct?q=${encodeURIComponent(location)}&limit=1&appid=${apiKey}`;
    const geoRes = await axios.get(geoUrl, { timeout: 5000 });

    if (!geoRes.data || geoRes.data.length === 0) {
      console.log(`❌ Location олдсонгүй: ${location}, Дата ашиглаж байна`);
      return getMockWeather(location);
    }

    const { lat, lon } = geoRes.data[0];

    const weatherUrl = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&units=metric&appid=${apiKey}`;
    const weatherRes = await axios.get(weatherUrl, { timeout: 5000 });

    const forecastUrl = `https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&units=metric&appid=${apiKey}`;
    const forecastRes = await axios.get(forecastUrl, { timeout: 5000 });

    console.log(`Цаг агаарын хариалагдах газар: ${location}`);

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
        .filter((_, index) => index % 8 === 0)
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
    console.error(`Weather API алдаа гарлаа ${location}:`, error.message);
    console.log('Хуучин дата руу буцаж байна');
    return getMockWeather(location);
  }
}

// ============ Санал болгох систем ============

function getRuleBasedRecommendation(data) {
  const { crop, sensorData = {}, weather } = data;
  const cropInfo = cropDatabase[crop.toLowerCase()];

  if (!cropInfo) {
    return {
      error: `Ургац "${crop}" өгөгдлийн санд олдсонгүй`,
      availableCrops: Object.keys(cropDatabase)
    };
  }

  const soilMoisture = sensorData.soilMoisture || 50;
  const currentTemp = weather.current.temp;
  
  const today = new Date();
  const plantingDate = data.plantingDate ? new Date(data.plantingDate) : today;
  const harvestDate = new Date(plantingDate);
  harvestDate.setDate(harvestDate.getDate() + cropInfo.growingDays);
  
  const shouldWater = soilMoisture < cropInfo.soilMoisture.min;
  let wateringReason = shouldWater 
    ? `Хөрсний чийг: (${soilMoisture}%) дунджаас доогуур байна (${cropInfo.soilMoisture.min}-${cropInfo.soilMoisture.max}%)`
    : `Хөрсний чийг яг тохиромжтой байна (${soilMoisture}%)`;
  
  const upcomingRain = weather.forecast.slice(0, 2).reduce((sum, day) => sum + day.rain, 0);
  if (upcomingRain > 5 && shouldWater) {
    wateringReason += ` ${upcomingRain}mm бороо орох гэж байгаа тул усалгаа хүлээгдэв`;
  }
  
  const recommendations = [];
  
  if (currentTemp < cropInfo.tempRange[0]) {
    recommendations.push(`Температур (${currentTemp}°C) тул дунджаас доогуур байна.`);
  } else if (currentTemp > cropInfo.tempRange[1]) {
    recommendations.push(`Температур (${currentTemp}°C) хэт их байгаа тул сүүдэрлэнэ үү.`);
  } else {
    recommendations.push(`Температур (${currentTemp}°C) байгаа тул ${crop} ургамалд яг тохирч байна.`);
  }
  
  if (soilMoisture > cropInfo.soilMoisture.max) {
    recommendations.push('Хөрсний чийг хэт их байна');
  } else if (soilMoisture < cropInfo.soilMoisture.min) {
    recommendations.push(`хөрсний чийг бага байна:(${soilMoisture}%). Усалгаа хийнэ үү.`);
  } else {
    recommendations.push(`Хөрсний чийг тохиромжтой (${soilMoisture}%) байна.`);
  }
  
  if (weather.current.humidity > 80) {
    recommendations.push('Агаарын чийгшил их байна. мөөгөнцрөөс сэргийлэх арга хэмжээ авна уу.');
  }

  if (upcomingRain > 20) {
    recommendations.push(`Хүчтэй бороо. (${upcomingRain}mm). Хөрсний шүүлтийг сайжруулна уу.`);
  }

  const daysUntilHarvest = Math.ceil((harvestDate - today) / (1000 * 60 * 60 * 24));
  
  if (daysUntilHarvest > 0 && daysUntilHarvest <= 7) {
    recommendations.push(`Хадлах хийхэд ${daysUntilHarvest} өдөр үлдсэн байна.`);
  } else if (daysUntilHarvest <= 0) {
    recommendations.push('Хадлан хийгдэхэд бэлэн боллоо.');
  }

  return {
    shouldWater,
    wateringReason,
    plantingDate: plantingDate.toISOString().split('T')[0],
    harvestDate: harvestDate.toISOString().split('T')[0],
    daysUntilHarvest: Math.max(0, daysUntilHarvest),
    recommendations,
    cropInfo: {
      name: crop,
      growingPeriod: `${cropInfo.growingDays} days`,
      waterRequirement: cropInfo.waterNeed,
      optimalTemp: `${cropInfo.tempRange[0]}-${cropInfo.tempRange[1]}°C`,
      optimalMoisture: `${cropInfo.soilMoisture.min}-${cropInfo.soilMoisture.max}%`
    },
    source: 'Rule-based'
  };
}

// ============ API ROUTES ============

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'AgriBackEnd API is running',
    timestamp: new Date().toISOString() 
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'Welcome to AgriBackEnd API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      field: '/api/field/*',
      advice: '/api/advice/*',
      sensor: '/api/sensor/*',
      auth: '/api/auth/*'
    }
  });
});

// ============ FIELD ROUTES ============

app.post('/api/field/create', (req, res) => {
  try {
    const { size, location, crop, plantingDate } = req.body;
    
    if (!size || !location || !crop) {
      return res.status(400).json({ 
        error: 'Missing required fields: size, location, crop' 
      });
    }

    const field = {
      id: Date.now().toString(),
      size: parseFloat(size),
      location,
      crop: crop.toLowerCase(),
      plantingDate: plantingDate || null,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    fields.push(field);

    res.status(201).json({
      success: true,
      message: 'Талбай амжиллтай хадгалагдлаа.',
      field
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/field/all', (req, res) => {
  res.json({
    success: true,
    count: fields.length,
    fields
  });
});

app.get('/api/field/:id', (req, res) => {
  const field = fields.find(f => f.id === req.params.id);
  
  if (!field) {
    return res.status(404).json({ error: 'Талбай олдсонгүй.' });
  }

  res.json({ success: true, field });
});

app.put('/api/field/:id', (req, res) => {
  const index = fields.findIndex(f => f.id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({ error: 'Талбай олдсонгүй.' });
  }

  fields[index] = {
    ...fields[index],
    ...req.body,
    id: fields[index].id,
    updatedAt: new Date().toISOString()
  };

  res.json({
    success: true,
    message: 'Талбайн мэдээлэл амжилттай шинчлэгдлээ.',
    field: fields[index]
  });
});

app.delete('/api/field/:id', (req, res) => {
  const index = fields.findIndex(f => f.id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({ error: 'Талбай олдсонгүй.' });
  }

  fields.splice(index, 1);
  res.json({ success: true, message: 'Талбай амжилттай устлаа.' });
});

// ============ ADVICE ROUTES ============

app.post('/api/advice/recommendations', async (req, res) => {
  try {
    const { location, crop, size, sensorData } = req.body;

    if (!location || !crop) {
      return res.status(400).json({ 
        error: 'Missing required fields: location, crop' 
      });
    }

    const weather = await getWeather(location);
    const recommendations = getRuleBasedRecommendation({
      crop,
      sensorData,
      weather,
      size,
      location
    });

    res.json({
      success: true,
      weather,
      recommendations
    });
  } catch (error) {
    console.error('Recommendation error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/advice/watering', async (req, res) => {
  try {
    const { location, crop, soilMoisture } = req.body;

    const weather = await getWeather(location);
    const cropInfo = cropDatabase[crop.toLowerCase()];

    if (!cropInfo) {
      return res.status(400).json({ error: 'Ургац олдсонгүй.' });
    }

    const shouldWater = soilMoisture < cropInfo.soilMoisture.min;
    const upcomingRain = weather.forecast.slice(0, 2).reduce((sum, day) => sum + day.rain, 0);

    res.json({
      success: true,
      advice: {
        shouldWater,
        reason: shouldWater 
          ? `Хөрсний чийг (${soilMoisture}%) тохиромжтой хэмжээнээс бага байна (${cropInfo.soilMoisture.min}%)`
          : 'Хөрсний чийг хангалттай байна.',
        upcomingRain: upcomingRain > 0 ? `${upcomingRain}mm expected` : 'Бороо байхгүй байна',
        recommendation: shouldWater && upcomingRain > 5 
          ? 'Бороо орохыг хүлээх.' 
          : shouldWater 
            ? 'Одоо услах.' 
            : 'Услах хэрэггүй.'
      },
      weather: weather.current
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/advice/planting', async (req, res) => {
  try {
    const { location, crop } = req.body;

    const weather = await getWeather(location);
    const cropInfo = cropDatabase[crop.toLowerCase()];

    if (!cropInfo) {
      return res.status(400).json({ error: 'Ургац олдсонгүй.' });
    }

    const currentTemp = weather.current.temp;
    const isOptimalTemp = currentTemp >= cropInfo.tempRange[0] && currentTemp <= cropInfo.tempRange[1];

    const today = new Date();
    const harvestDate = new Date(today);
    harvestDate.setDate(harvestDate.getDate() + cropInfo.growingDays);

    res.json({
      success: true,
      advice: {
        isGoodTime: isOptimalTemp,
        reason: isOptimalTemp 
          ? `Температур (${currentTemp}°C) тохиромжтой хэмжээнд байна. ${crop}`
          : `Температур (${currentTemp}°C) тохиромжтой хэмжээнээс гадуур байна (${cropInfo.tempRange[0]}-${cropInfo.tempRange[1]}°C)`,
        expectedHarvestDate: harvestDate.toISOString().split('T')[0],
        growingDays: cropInfo.growingDays
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ============ SENSOR ROUTES ============

app.post('/api/sensor/reading', (req, res) => {
  try {
    const { fieldId, soilMoisture, soilTemp, airTemp, humidity } = req.body;

    if (!fieldId || soilMoisture === undefined) {
      return res.status(400).json({ 
        error: 'Missing required fields: fieldId, soilMoisture' 
      });
    }

    const reading = {
      id: Date.now().toString(),
      fieldId,
      soilMoisture: parseFloat(soilMoisture),
      soilTemp: soilTemp ? parseFloat(soilTemp) : null,
      airTemp: airTemp ? parseFloat(airTemp) : null,
      humidity: humidity ? parseFloat(humidity) : null,
      timestamp: new Date().toISOString()
    };

    sensorReadings.push(reading);

    if (sensorReadings.length > 1000) {
      sensorReadings = sensorReadings.slice(-1000);
    }

    res.status(201).json({
      success: true,
      message: 'Мэдрэгч мэдээллийг хүлээн авч байна.',
      reading
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/sensor/history/:fieldId', (req, res) => {
  const { fieldId } = req.params;
  const { limit = 50 } = req.query;

  const fieldReadings = sensorReadings
    .filter(r => r.fieldId === fieldId)
    .slice(-parseInt(limit));

  res.json({
    success: true,
    count: fieldReadings.length,
    readings: fieldReadings
  });
});

app.get('/api/sensor/latest/:fieldId', (req, res) => {
  const { fieldId } = req.params;

  const fieldReadings = sensorReadings.filter(r => r.fieldId === fieldId);
  
  if (fieldReadings.length === 0) {
    return res.status(404).json({ 
      error: 'Энэ талбайд мэдээлэл олдсонгүй.' 
    });
  }

  const latest = fieldReadings[fieldReadings.length - 1];

  res.json({
    success: true,
    reading: latest
  });
});

// ============ AUTH ROUTES ============

app.post('/api/auth/register', (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ 
        error: 'Missing required fields' 
      });
    }

    const existing = users.find(u => u.email === email);
    if (existing) {
      return res.status(400).json({ error: 'Хэрэглэгч бүртгэлтэй байна.' });
    }

    const user = {
      id: Date.now().toString(),
      username,
      email,
      createdAt: new Date().toISOString()
    };

    users.push(user);

    res.status(201).json({
      success: true,
      message: 'Амжилттай бүртгэгдлээ.',
      user: { id: user.id, username: user.username, email: user.email }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/auth/login', (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ 
        error: 'Missing required fields' 
      });
    }

    const user = users.find(u => u.email === email);
    
    if (!user) {
      return res.status(401).json({ error: 'Тодорхоогүй мэдээлэл' });
    }

    res.json({
      success: true,
      message: 'Амжиллттай нэвтэрлээ.',
      user: { id: user.id, username: user.username, email: user.email }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Error handling
app.use((err, req, res, next) => {
  console.error('Error:', err.stack);
  res.status(500).json({ 
    error: 'Алдаа гарлаа.',
    message: err.message 
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log('🌾================================🌾');
  console.log(`🚀 AgriBackEnd API Server Running`);
  console.log(`📡 Port: ${PORT}`);
  console.log(`🌐 Local: http://localhost:${PORT}`);
  console.log(`🔧 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log('🌾================================🌾');
  console.log('\n📋 Available Endpoints:');
  console.log(`   GET  /health`);
  console.log(`   POST /api/field/create`);
  console.log(`   GET  /api/field/all`);
  console.log(`   POST /api/advice/recommendations`);
  console.log(`   POST /api/sensor/reading`);
  console.log(`   POST /api/auth/register`);
  console.log('\n✅ Ready to accept requests!\n');
});