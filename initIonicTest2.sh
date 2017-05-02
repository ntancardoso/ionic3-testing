#!/bin/bash
# ##################################################
#   Setup Ionic 3 Testing
# ##################################################

PACKAGES_GLOBAL="protractor"
PACKAGES_DEV="@ionic/app-scripts @ionic/cli-build-ionic-angular @ionic/cli-plugin-cordova @types/jasmine @types/node angular2-template-loader html-loader jasmine jasmine-spec-reporter karma karma-chrome-launcher karma-jasmine karma-jasmine-html-reporter karma-sourcemap-loader karma-webpack null-loader protractor ts-loader ts-node"
                
declare -a directories=("test-config" "e2e")
declare -a filenames=("test-config/karma.conf.js" 
                "test-config/karma-test-shim.js" "test-config/mocks-ionic.ts"
                "test-config/protractor.conf.js" "test-config/webpack.test.js"
                "e2e/tsconfig.json" "e2e/app.po.ts" "e2e/app.e2e-spec.ts" "src/app/app.component.spec.ts"
                )

function mainScript() {
    echo "===== Start ====="
    setupDirectories
    setupPackages
    setupFiles
    echo "===== Done ====="
    exit
}

function setupDirectories() {
    echo "***** Creating Directories ***** "
    for i in "${directories[@]}"
    do
        echo "$i"
        mkdir -p "$i"
    done
}

function setupPackages() {
    echo "***** Installing Packages *****"
    npm install -g $PACKAGES_GLOBAL
    npm install --save-dev $PACKAGES_DEV
}

function checkExistingFile() {
    if [ -w "$1"  ]; then                                                                                               
        echo " Overwrite existing file $1? y/N "
        read ANSWER
        if ! [[ $ANSWER = [yY] ]]; then
            return 1
        fi
    fi
    return 0
}

function setupFiles() {
    echo "***** Creating Files *****"
    for i in "${filenames[@]}"
    do
        createFile "$i"
    done
}

function createFile() {
    if checkExistingFile $1; then
        echo "$1"
        case "$1" in
            "test-config/karma.conf.js") 
                createKarmaConf
                ;;
            "test-config/karma-test-shim.js") 
                createKarmaShim
                ;;
            "test-config/mocks-ionic.ts")
                createMocks
                ;;
            "test-config/protractor.conf.js")
                createProtractorConf
                ;;
            "test-config/webpack.test.js")
                createWebpack
                ;;
            "e2e/tsconfig.json")
                createE2eTsConfig
                ;;
            "e2e/app.po.ts")
                createE2eAppPo
                ;;
            "e2e/app.e2e-spec.ts")
                createE2eAppSpec
                ;;
            "src/app/app.component.spec.ts")
                createAppSpec
                ;;
            *) echo "Cannot find file contents for $i"; ;;
        esac;
    fi
}

# FILES
# ------------------------------------------------------
function createKarmaConf() {
cat <<EOF >test-config/karma.conf.js
var webpackConfig = require('./webpack.test.js');

module.exports = function (config) {
  var _config = {
    basePath: '',

    frameworks: ['jasmine'],

    files: [
      {pattern: './karma-test-shim.js', watched: true}
    ],

    preprocessors: {
      './karma-test-shim.js': ['webpack', 'sourcemap']
    },

    webpack: webpackConfig,

    webpackMiddleware: {
      stats: 'errors-only'
    },

    webpackServer: {
      noInfo: true
    },

    browserConsoleLogOptions: {
      level: 'log',
      format: '%b %T: %m',
      terminal: true
    },

    reporters: ['kjhtml', 'dots'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome'],
    singleRun: false
  };

  config.set(_config);
};
EOF
}


function createKarmaShim() {
cat <<EOF >test-config/karma-test-shim.js
Error.stackTraceLimit = Infinity;

require('core-js/es6');
require('core-js/es7/reflect');

require('zone.js/dist/zone');
require('zone.js/dist/long-stack-trace-zone');
require('zone.js/dist/proxy');
require('zone.js/dist/sync-test');
require('zone.js/dist/jasmine-patch');
require('zone.js/dist/async-test');
require('zone.js/dist/fake-async-test');

var appContext = require.context('../src', true, /\.spec\.ts/);

appContext.keys().forEach(appContext);

var testing = require('@angular/core/testing');
var browser = require('@angular/platform-browser-dynamic/testing');

testing.TestBed.initTestEnvironment(browser.BrowserDynamicTestingModule, browser.platformBrowserDynamicTesting());
EOF
}


function createMocks {
cat <<EOF >test-config/mocks-ionic.ts
export class PlatformMock {
  public ready(): Promise<{String}> {
    return new Promise((resolve) => {
      resolve('READY');
    });
  }

  public getQueryParam() {
    return true;
  }

  public registerBackButtonAction(fn: Function, priority?: number): Function {
    return (() => true);
  }

  public hasFocus(ele: HTMLElement): boolean {
    return true;
  }

  public doc(): HTMLDocument {
    return document;
  }

  public is(): boolean {
    return true;
  }

  public getElementComputedStyle(container: any): any {
    return {
      paddingLeft: '10',
      paddingTop: '10',
      paddingRight: '10',
      paddingBottom: '10',
    };
  }

  public onResize(callback: any) {
    return callback;
  }

  public registerListener(ele: any, eventName: string, callback: any): Function {
    return (() => true);
  }

  public win(): Window {
    return window;
  }

  public raf(callback: any): number {
    return 1;
  }

  public timeout(callback: any, timer: number): any {
    return setTimeout(callback, timer);
  }

  public cancelTimeout(id: any) {
    // do nothing
  }

  public getActiveElement(): any {
    return document['activeElement'];
  }
}
EOF
}


function createProtractorConf {
cat <<EOF >test-config/protractor.conf.js
// Protractor configuration file, see link for more information
// https://github.com/angular/protractor/blob/master/lib/config.ts

/*global jasmine */
var SpecReporter = require('jasmine-spec-reporter').SpecReporter;

exports.config = {
  allScriptsTimeout: 11000,
  specs: [
    '../e2e/**/*.e2e-spec.ts'
  ],
  capabilities: {
    'browserName': 'chrome'
  },
  directConnect: true,
  baseUrl: 'http://localhost:8100/',
  framework: 'jasmine',
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000,
    print: function() {}
  },
  useAllAngular2AppRoots: true,
  beforeLaunch: function() {
    require('ts-node').register({
      project: 'e2e'
    });
  },
  onPrepare: function() {
    jasmine.getEnv().addReporter(new SpecReporter());
  }
};
EOF
}


function createWebpack {
cat <<EOF >test-config/webpack.test.js
var webpack = require('webpack');
var path = require('path');

module.exports = {
  devtool: 'inline-source-map',

  resolve: {
    extensions: ['.ts', '.js']
  },

  module: {
    rules: [
      {
        test: /\.ts$/,
        loaders: [
          {
            loader: 'ts-loader'
          } , 'angular2-template-loader'
        ]
      },
      {
        test: /\.html$/,
        loader: 'html-loader?attrs=false'
      },
      {
        test: /\.(png|jpe?g|gif|svg|woff|woff2|ttf|eot|ico)$/,
        loader: 'null-loader'
      }
    ]
  },

  plugins: [
    new webpack.ContextReplacementPlugin(
      // The (\\|\/) piece accounts for path separators in *nix and Windows
      /angular(\\|\/)core(\\|\/)(esm(\\|\/)src|src)(\\|\/)linker/,
      root('./src'), // location of your src
      {} // a map of your routes
    )
  ]
};

function root(localPath) {
  return path.resolve(__dirname, localPath);
}
EOF
}


function createE2eAppPo {
cat <<EOF >e2e/app.po.ts
import { browser } from 'protractor';

export class Page {

  navigateTo(destination) {
    return browser.get(destination);
  }

  getTitle() {
    return browser.getTitle();
  }
  
}
EOF
}


function createE2eAppSpec {
cat <<EOF >e2e/app.e2e-spec.ts
import { Page } from './app.po';

describe('App', function() {
  let page: Page;

  beforeEach(() => {
    page = new Page();
  });

  describe('default screen', () => {
    beforeEach(() => {
      page.navigateTo('/');
    });

    it('should have a title saying Page One', () => {
      page.getTitle().then(title => {
        expect(title).toEqual('Page One');
      });
    });
  })
});
EOF
}


function createE2eTsConfig {
cat <<EOF >e2e/tsconfig.json
{
  "compileOnSave": false,
  "compilerOptions": {
    "declaration": false,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "module": "commonjs",
    "moduleResolution": "node",
    "outDir": "../dist/out-tsc-e2e",
    "sourceMap": true,
    "target": "es5",
    "typeRoots": [
      "../node_modules/@types"
    ]
  }
}
EOF
}

function createAppSpec {
cat <<EOF >src/app/app.component.spec.ts
import { async, TestBed } from '@angular/core/testing';
import { IonicModule, Platform } from 'ionic-angular';

import { StatusBar } from '@ionic-native/status-bar';
import { SplashScreen } from '@ionic-native/splash-screen';

import { MyApp } from './app.component';
import { PlatformMock } from '../../test-config/mocks-ionic';

describe('MyApp Component', () => {
  let fixture;
  let component;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [MyApp],
      imports: [
        IonicModule.forRoot(MyApp)
      ],
      providers: [
        StatusBar,
        SplashScreen,
        { provide: Platform, useClass: PlatformMock }
      ]
    })
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MyApp);
    component = fixture.componentInstance;
  });

  it ('should be created', () => {
    expect(component instanceof MyApp).toBe(true);
  });

});
EOF
}

mainScript
