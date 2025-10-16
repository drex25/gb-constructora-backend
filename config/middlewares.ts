export default [
  'strapi::errors',
  {
    name: 'global::swc-fallback',
    configure: () => {
      try {
        process.env.SWC_BINARY_PATH = process.env.SWC_BINARY_PATH || '';
        process.env.SWC_WASM = process.env.SWC_WASM || '1';
      } catch (e) {}
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
];
