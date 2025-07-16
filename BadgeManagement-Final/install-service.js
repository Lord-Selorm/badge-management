const Service = require('node-windows').Service;
const path = require('path');

// Create a new service object
const svc = new Service({
  name: 'BadgeManagement',
  description: 'Badge Management System Web Application',
  script: path.join(__dirname, 'server.js'),
  nodeOptions: [
    '--harmony',
    '--max_old_space_size=4096'
  ]
});

// Listen for the "install" event, which indicates the
// process is available as a service.
svc.on('install', function() {
  console.log('Service installed successfully');
  console.log('Starting the service...');
  svc.start();
});

// Install the service
console.log('Installing service...');
svc.install();
