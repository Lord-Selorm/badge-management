// Electron Preload Script: Exposes badge file APIs to renderer (React) via contextBridge
const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  saveBadges: (badges) => ipcRenderer.invoke('save-badges', badges),
  loadBadges: () => ipcRenderer.invoke('load-badges')
});
