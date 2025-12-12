const sql = require('mssql');

const config = {
    user: 'DESKTOP-8K20357\\Dell G15', 
    password: '', 
    server: 'localhost\\SQLEXPRESS',
    database: 'AgriDB', 
    options: {
        encrypt: true, 
        trustServerCertificate: true 
    }
};

async function connectToDatabase() {
    try {
        await sql.connect(config);
        console.log('Connected to SQL Server');
    } catch (err) {
        console.error('Error connecting to SQL Server:', err);
    }
}

connectToDatabase();

