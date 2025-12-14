// src/services/advicesService.js
const axios = require('axios');

// Crop database with growing parameters
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
  },
  onion: { 
    growingDays: 100, 
    waterNeed: 'medium', 
    tempRange: [13, 24],
    soilMoisture: { min: 45, max: 60 }
  },
  cabbage: { 
    growingDays: 90, 
    waterNeed: 'high', 
    tempRange: [15, 21],
    soilMoisture: { min: 55, max: 70 }
  }
};

// Rule-based recommendation system
function getRuleBasedRecommendation(data) {
  const { crop, sensorData = {}, weather } = data;
  const cropInfo = cropDatabase[crop.toLowerCase()];

  if (!cropInfo) {
    return {
      error: `Crop "${crop}" not found in database`,
      availableCrops: Object.keys(cropDatabase)
    };
  }

  const soilMoisture = sensorData.soilMoisture || 50;
  const currentTemp = weather.current.temp;
  
  // Calculate dates
  const today = new Date();
  const plantingDate = data.plantingDate ? new Date(data.plantingDate) : today;
  const harvestDate = new Date(plantingDate);
  harvestDate.setDate(harvestDate.getDate() + cropInfo.growingDays);
  
  // Watering decision
  const shouldWater = soilMoisture < cropInfo.soilMoisture.min;
  let wateringReason = shouldWater 
    ? `Soil moisture (${soilMoisture}%) is below optimal range (${cropInfo.soilMoisture.min}-${cropInfo.soilMoisture.max}%)`
    : `Soil moisture is adequate (${soilMoisture}%)`;
  
  // Check for upcoming rain
  const upcomingRain = weather.forecast.slice(0, 2).reduce((sum, day) => sum + day.rain, 0);
  if (upcomingRain > 5 && shouldWater) {
    wateringReason += `. However, ${upcomingRain}mm rain expected soon - consider waiting.`;
  }
  
  // Generate recommendations
  const recommendations = [];
  
  if (currentTemp < cropInfo.tempRange[0]) {
    recommendations.push(`🌡️ Temperature (${currentTemp}°C) is below optimal range (${cropInfo.tempRange[0]}-${cropInfo.tempRange[1]}°C). Consider frost protection.`);
  } else if (currentTemp > cropInfo.tempRange[1]) {
    recommendations.push(`🌡️ Temperature (${currentTemp}°C) is above optimal range. Increase watering frequency and provide shade if possible.`);
  } else {
    recommendations.push(`✅ Temperature (${currentTemp}°C) is optimal for ${crop}.`);
  }
  
  if (soilMoisture > cropInfo.soilMoisture.max) {
    recommendations.push('💧 Soil moisture is too high. Improve drainage to prevent root rot.');
  } else if (soilMoisture < cropInfo.soilMoisture.min) {
    recommendations.push(`💧 Soil moisture is low (${soilMoisture}%). Increase watering.`);
  } else {
    recommendations.push(`✅ Soil moisture (${soilMoisture}%) is optimal.`);
  }
  
  if (weather.current.humidity > 80) {
    recommendations.push('⚠️ High humidity detected. Monitor for fungal diseases and ensure good air circulation.');
  }

  if (upcomingRain > 20) {
    recommendations.push(`🌧️ Heavy rain expected (${upcomingRain}mm). Ensure proper drainage and delay watering.`);
  } else if (upcomingRain > 5) {
    recommendations.push(`🌧️ Rain expected (${upcomingRain}mm) in the next 2 days.`);
  }

  // Days until harvest
  const daysUntilHarvest = Math.ceil((harvestDate - today) / (1000 * 60 * 60 * 24));
  
  if (daysUntilHarvest > 0 && daysUntilHarvest <= 7) {
    recommendations.push(`🌾 Harvest time approaching! ${daysUntilHarvest} days remaining.`);
  } else if (daysUntilHarvest <= 0) {
    recommendations.push('🌾 Crop is ready for harvest!');
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
    }
  };
}

// AI-powered recommendations (optional)
async function getAIRecommendation(data) {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  
  if (!apiKey || apiKey === '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') {
    return null; // Fall back to rule-based
  }

  try {
    const { crop, sensorData = {}, weather, size, location } = data;

    const prompt = `You are an agricultural expert AI. Analyze this farm data and provide recommendations in mongolian.

Field Information:
- Location: ${location}
- Size: ${size} hectares
- Crop: ${crop}
- Planting Date: ${data.plantingDate || 'Not yet planted'}

Current Weather:
- Temperature: ${weather.current.temp}°C
- Humidity: ${weather.current.humidity}%
- Conditions: ${weather.current.description}

Sensor Data:
- Soil Moisture: ${sensorData.soilMoisture || 'N/A'}%
- Soil Temperature: ${sensorData.soilTemp || 'N/A'}°C

Weather Forecast (next 3 days):
${weather.forecast.slice(0, 3).map(d => `- ${d.date}: ${d.temp}°C, ${d.description}, Rain: ${d.rain}mm`).join('\n')}

Please provide concise recommendations in JSON format:
{
  "shouldWater": true/false,
  "wateringReason": "brief reason",
  "recommendations": ["recommendation 1", "recommendation 2", "recommendation 3"]
}`;

    const response = await axios.post(
      'https://api.anthropic.com/v1/messages',
      {
        model: 'claude-sonnet-4-20250514',
        max_tokens: 1024,
        messages: [{ role: 'user', content: prompt }]
      },
      {
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json'
        },
        timeout: 10000
      }
    );

    const text = response.data.content[0].text;
    const jsonMatch = text.match(/\{[\s\S]*\}/);
    
    if (jsonMatch) {
      const aiResult = JSON.parse(jsonMatch[0]);
      console.log('✅ AI recommendations generated');
      return aiResult;
    }
  } catch (error) {
    console.error('⚠️ AI API error:', error.message);
  }

  return null; // Fall back to rule-based
}

exports.getRecommendations = async (data) => {
  // Try AI first, fall back to rule-based
  const aiResult = await getAIRecommendation(data);
  const ruleResult = getRuleBasedRecommendation(data);

  if (aiResult) {
    // Merge AI insights with rule-based data
    return {
      ...ruleResult,
      shouldWater: aiResult.shouldWater,
      wateringReason: aiResult.wateringReason,
      recommendations: [...aiResult.recommendations, ...ruleResult.recommendations],
      source: 'AI-powered + Rule-based'
    };
  }

  return {
    ...ruleResult,
    source: 'Rule-based'
  };
};

exports.getWateringAdvice = async (data) => {
  const { crop, soilMoisture, weather } = data;
  const cropInfo = cropDatabase[crop.toLowerCase()];

  if (!cropInfo) {
    return { error: 'Crop not found' };
  }

  const shouldWater = soilMoisture < cropInfo.soilMoisture.min;
  const upcomingRain = weather.forecast.slice(0, 2).reduce((sum, day) => sum + day.rain, 0);

  return {
    shouldWater,
    reason: shouldWater 
      ? `Soil moisture (${soilMoisture}%) is below optimal (${cropInfo.soilMoisture.min}%)`
      : 'Soil moisture is adequate',
    upcomingRain: upcomingRain > 0 ? `${upcomingRain}mm expected` : 'No rain expected',
    recommendation: shouldWater && upcomingRain > 5 
      ? 'Wait for rain before watering' 
      : shouldWater 
        ? 'Water now' 
        : 'No watering needed'
  };
};

exports.getPlantingAdvice = async (data) => {
  const { crop, weather } = data;
  const cropInfo = cropDatabase[crop.toLowerCase()];

  if (!cropInfo) {
    return { error: 'Crop not found' };
  }

  const currentTemp = weather.current.temp;
  const isOptimalTemp = currentTemp >= cropInfo.tempRange[0] && currentTemp <= cropInfo.tempRange[1];

  const today = new Date();
  const harvestDate = new Date(today);
  harvestDate.setDate(harvestDate.getDate() + cropInfo.growingDays);

  return {
    isGoodTime: isOptimalTemp,
    reason: isOptimalTemp 
      ? `Current temperature (${currentTemp}°C) is optimal for planting ${crop}`
      : `Temperature (${currentTemp}°C) is outside optimal range (${cropInfo.tempRange[0]}-${cropInfo.tempRange[1]}°C)`,
    expectedHarvestDate: harvestDate.toISOString().split('T')[0],
    growingDays: cropInfo.growingDays
  };
};