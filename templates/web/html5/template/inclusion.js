gAPI.loader.advance(!conf.replay ? {
    preset: 'slot',
    resources: [
        'mobile-detect.js',
        'Main.js',
        'init.js'
    ]
} : {
    preset: 'replay',
        resources: [
        'mobile-detect.js',
        'Main.js',
        'init.js'
    ]
})