const express = require('express');
const path = require('path');
const { exec } = require('child_process');
const app = express();
const port = 3000; // Fixed port for simplicity

// Get the build directory path
const buildPath = path.join(__dirname, 'build');

// Serve static files from the build directory
app.use(express.static(buildPath));

// Handle all other routes by serving index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(buildPath, 'index.html'));
});

// Start the server
const server = app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
  
  // Open the browser automatically
  const start = process.platform === 'win32' ? 'start' : 'open';
  exec(`${start} http://localhost:${port}`);
});

// Handle server errors
server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`Port ${port} is in use. Please close any other instances of the application.`);
    process.exit(1);
  }
});

// Handle process termination
process.on('SIGINT', () => {
  console.log('\nShutting down server...');
  process.exit(0);
});
