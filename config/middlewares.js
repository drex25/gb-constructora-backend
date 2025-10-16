module.exports = [
  'strapi::errors',
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
  'strapi::security',
  'strapi::cors',
  'strapi::poweredBy',
  'strapi::logger',
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
];module.exports = [
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  {
    name: 'strapi::cors',
    config: {
      origin: process.env.CLIENT_URL ? [process.env.CLIENT_URL, 'http://localhost:5173', 'http://localhost:8080'] : ['*'],
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
