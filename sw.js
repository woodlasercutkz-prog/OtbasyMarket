const V='otbasy-v2',SHELL=['./','index.html','manifest.webmanifest','qrcode.min.js','icons/icon-192.png','icons/icon-512.png','icons/icon.svg'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(V).then(c=>Promise.all(SHELL.map(u=>c.add(u).catch(()=>{})))).then(()=>self.skipWaiting()))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!=V).map(x=>caches.delete(x)))).then(()=>self.clients.claim()))});
self.addEventListener('fetch',e=>{const r=e.request;if(r.method!='GET'||r.url.includes('.supabase.co'))return;
e.respondWith(caches.match(r).then(c=>{const n=fetch(r).then(x=>{if(x&&(x.ok||x.type=='opaque')){const k=x.clone();caches.open(V).then(h=>h.put(r,k))}return x}).catch(()=>c||(r.mode=='navigate'?caches.match('index.html'):Response.error()));return c||n}))});
