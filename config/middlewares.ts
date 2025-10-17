export default [
  {
    name: 'strapi::cors',
    config: {
      origin: ['http://149.50.132.34:3000'],
      credentials: true,
    },
  },
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  // 'strapi::poweredBy', // Assuming you want to keep this commented for production
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
];
