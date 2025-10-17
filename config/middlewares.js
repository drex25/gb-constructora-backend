module.exports = [
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  {
    name: 'global::swc-fallback',
    configure: () => {
      try {
        // If native binding fails, allow @swc/core to use wasm fallback
        process.env.SWC_BINARY_PATH = process.env.SWC_BINARY_PATH || '';
        process.env.SWC_WASM = process.env.SWC_WASM || '1';
      } catch (e) {
        // noop
      }
    },
  },
  {
    name: 'strapi::cors',
    config: {
      origin: [
        'http://149.50.132.34:3000',  // Frontend en servidor 149
        'http://localhost:5173',       // Desarrollo local
        'http://localhost:8080',       // Desarrollo local alternativo
        'http://localhost:3000'        // Desarrollo local frontend
      ],
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS'],
      headers: ['Content-Type', 'Authorization', 'Origin', 'Accept'],
      keepHeaderOnError: true,
    },
  },
  'strapi::poweredBy',
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
];
