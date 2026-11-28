/* Tirelire — service worker (v3.2)
   Stratégie : cache d'abord + mise à jour en arrière-plan, pour un lancement
   instantané et fonctionnel sans réseau. Les nouveautés s'appliquent au lancement suivant. */
const VERSION = 'tirelire-v4.2';
const SHELL = [
  './',
  './index.html',
  './manifest.webmanifest',
  './config.js',
  './icon.svg',
  './icon-180.png',
  './icon-192.png',
  './icon-512.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(VERSION)
      .then((cache) => Promise.all(
        SHELL.map((url) => cache.add(new Request(url, { cache: 'reload' })).catch(() => {}))
      ))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(
        keys.filter((k) => k.startsWith('tirelire-') && k !== VERSION).map((k) => caches.delete(k))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;

  // Pages publiques des projets partagés : toujours le réseau (jamais la copie de l'app).
  if (url.pathname.startsWith('/p/') || url.pathname.endsWith('/projet.html')) return;

  // Page principale : on sert la copie en cache, on la rafraîchit en arrière-plan.
  if (req.mode === 'navigate') {
    event.respondWith(
      caches.match('./index.html').then((cached) => {
        const network = fetch(req)
          .then((res) => {
            if (res && res.ok) {
              const copy = res.clone();
              caches.open(VERSION).then((c) => c.put('./index.html', copy));
            }
            return res;
          })
          .catch(() => cached);
        return cached || network;
      })
    );
    return;
  }

  // Autres fichiers de l'app (icônes, manifest…)
  event.respondWith(
    caches.match(req).then((cached) => {
      const network = fetch(req)
        .then((res) => {
          if (res && res.ok) {
            const copy = res.clone();
            caches.open(VERSION).then((c) => c.put(req, copy));
          }
          return res;
        })
        .catch(() => cached);
      return cached || network;
    })
  );
});
