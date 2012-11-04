({
    appDir: '../app',
    baseUrl: '.',

    //Uncomment to turn off uglify minification.
    //optimize: 'none',
    dir: '../build',

    //Stub out the cs module after a build since
    //it will not be needed.
    stubModules: ['cs'],

    paths: {
        'cs' :'lib/cs',
        'coffee-script': 'lib/coffee-script',
        'underscore': 'lib/underscore-min'
    },
    shim: {
      'underscore': {
        exports: '_'
      }
    },
    modules: [
        {
            name: 'js/start',
            //The optimization will load CoffeeScript to convert
            //the CoffeeScript files to plain JS. Use the exclude
            //directive so that the coffee-script module is not included
            //in the built file.
            exclude: ['coffee-script']
        }
    ]
})