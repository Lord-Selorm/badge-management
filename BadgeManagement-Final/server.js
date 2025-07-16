const http = require('http');
const fs = require('fs');
const path = require('path');
const port = process.env.PORT || 3000;

// Get the absolute path to the build directory
const buildPath = path.join(__dirname, 'build');

// Log the current directory and build path for debugging
console.log('Current directory:', __dirname);
console.log('Build path:', buildPath);

// Check if build directory exists
if (!fs.existsSync(buildPath)) {
  console.error('ERROR: Build directory not found at:', buildPath);
  console.error('Please run `npm run build` first');
  process.exit(1);
}

// List files in build directory for debugging
try {
  console.log('\nBuild directory contents:');
  const files = fs.readdirSync(buildPath);
  files.forEach(file => {
    const filePath = path.join(buildPath, file);
    const stats = fs.statSync(filePath);
    console.log(`- ${file} (${stats.isDirectory() ? 'directory' : 'file'})`);
  });
} catch (err) {
  console.error('Error reading build directory:', err);
  process.exit(1);
}

const mimeTypes = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.wav': 'audio/wav',
  '.mp4': 'video/mp4',
  '.woff': 'application/font-woff',
  '.ttf': 'application/font-ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.otf': 'application/font-otf',
  '.wasm': 'application/wasm'
};

const server = http.createServer((req, res) => {
  console.log(`Request for ${req.url}`);
  
  // Handle root path
  let filePath = req.url === '/' ? '/index.html' : req.url;
  filePath = path.join(buildPath, filePath);
  
  // Prevent directory traversal
  if (!filePath.startsWith(buildPath)) {
    filePath = path.join(buildPath, 'index.html');
  }
  
  console.log('Requested URL:', req.url);
  console.log('Serving file:', filePath);

  const extname = String(path.extname(filePath)).toLowerCase();
  const contentType = mimeTypes[extname] || 'application/octet-stream';

  fs.readFile(filePath, (error, content) => {
    if (error) {
      if (error.code === 'ENOENT') {
        // File not found, serve index.html for client-side routing
        const indexPath = path.join(buildPath, 'index.html');
        console.log('File not found, trying to serve:', indexPath);
        
        fs.readFile(indexPath, (error, content) => {
          if (error) {
            console.error('Error loading index.html:', error);
            res.writeHead(500, { 'Content-Type': 'text/plain' });
            res.end('Error loading index.html: ' + error.message);
          } else {
            console.log('Serving index.html for client-side routing');
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(content, 'utf-8');
          }
        });
      } else {
        // Server error
        res.writeHead(500);
        res.end('Server Error: ' + error.code);
      }
    } else {
      // Success
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(content, 'utf-8');
    }
  });
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
  
  // Open the browser
  const { exec } = require('child_process');
  const start = process.platform === 'win32' ? 'start' : 'open';
  exec(`${start} http://localhost:${port}`);
});

console.log('Starting server...');
