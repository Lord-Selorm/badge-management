const http = require('http');

// Try to connect to the server
const checkServer = () => {
  console.log('Testing connection to http://localhost:3000...');
  
  http.get('http://localhost:3000', (res) => {
    console.log(`Server responded with status: ${res.statusCode}`);
    process.exit(0);
  }).on('error', (err) => {
    console.error('Error connecting to server:', err.message);
    console.log('\nTroubleshooting steps:');
    console.log('1. Make sure you ran Start.bat as administrator');
    console.log('2. Check if port 3000 is in use by another program');
    console.log('3. Try running these commands manually in order:');
    console.log('   a. npm install express serve-static');
    console.log('   b. node simple-server.js');
    process.exit(1);
  });
};

checkServer();
