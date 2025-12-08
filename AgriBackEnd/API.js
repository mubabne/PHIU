const express = require('express');
const axios = require('axios'); 
const app = express();
const port = 5000; 
const apiKey = 'fe5084ecc5add1f8a9efc7c3d7072511';

const ai = require('axios');
const ai_port = 'Https://openai.com/api/';
const ai_apiKEY = 'sk-proj-ob0nheypc3xce3kccfxruueqb64nrvrqh_rewj6lxd-k_4vrepcl0xz9oaslmmjkz-zrjauaust3blbkfjqltnyvad_6ackj5drloxklvjdrjqh38unu7ttvbhzoahkxk4p3vapa_fysuea1rxu_t0k0dtqa/';

app.get('/weather', async (req, res) => 
{
    try {
        const city = req.query.city || 'London';

        const response = await axios.get(`http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}`);
        
        const weatherData = response.data;
        const temperature = weatherData.main.temp - 273.15;
        const weatherDescription = weatherData.weather[0].description;

        let advice = '';
        if (temperature < 10) {
            advice = 'It\'s cold. Wear warm clothes!';
        } else if (temperature > 30) {
            advice = 'It\'s hot. Drink lots of water!';
        } else {
            advice = 'The weather is nice. Enjoy your day!';
        }

        res.json({
            city: city,
            temperature: temperature,
            description: weatherDescription,
            advice: advice
        });
    } catch (error) {
    console.error('Error fetching weather data:', error.message); 
    res.status(500).send('Error fetching weather data');
}

});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});

ai.get('/advice', async (req, res) =>
{
    try {
        const question = req.query.city ;

        const response = await axios.get(`http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}`);
        
        const weatherData = response.data;
        const temperature = weatherData.main.temp - 273.15;
        const weatherDescription = weatherData.weather[0].description;

        let advice = '';
        if (temperature < 10) {
            advice = 'It\'s cold. Wear warm clothes!';
        } else if (temperature > 30) {
            advice = 'It\'s hot. Drink lots of water!';
        } else {
            advice = 'The weather is nice. Enjoy your day!';
        }

        res.json({
            city: city,
            temperature: temperature,
            description: weatherDescription,
            advice: advice
        });
    } catch (error) {
    console.error('Error fetching weather data:', error.message); 
    res.status(500).send('Error fetching weather data');
    }
});

ai.listen(port, () => 
{
    console.log('AI server is running on https://localhost: ${port}');
})