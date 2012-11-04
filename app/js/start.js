require.config({
  baseUrl: "/app"
});
require({
  paths: {
    cs: 'lib/cs',
    'coffee-script': 'lib/coffee-script',
    'underscore': 'lib/underscore-min'
  },
  shim: {
    'underscore': {
      exports: '_'
    }
  }
}, ['cs!js/main']); 