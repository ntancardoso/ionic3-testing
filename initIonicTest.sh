#!/bin/bash
# ##################################################
#   Setup Ionic 3 Testing
# ##################################################

PACKAGES_GLOBAL="karma-cli"
PACKAGES_DEV="@angular/cli codecov jasmine-core jasmine-spec-reporter karma karma-chrome-launcher karma-jasmine karma-mocha-reporter karma-remap-istanbul ts-node tslint tslint-eslint-rules @types/jasmine @types/node"
                
declare -a directories=("src/environments")
declare -a filenames=("karma.conf.js" 
                "angular-cli.json" "src/environments/environment.prod.ts"
                "src/environments/environment.ts" "src/mocks.ts" "src/polyfills.ts" "src/test.ts"
                "tsconfig.test.json" "src/app/app.spec.ts"
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
            "karma.conf.js") 
                createKarmaConf
                ;;
            "angular-cli.json") 
                createAngularCli
                ;;
            "src/environments/environment.prod.ts")
                createEnvProd
                ;;
            "src/environments/environment.ts")
                createEnvDev
                ;;
            "src/mocks.ts")
                createMocks
                ;;
            "src/polyfills.ts")
                createPolyfills
                ;;
            "src/test.ts")
                createTest
                ;;
            "tsconfig.test.json")
                createTsconfigTest
                ;;
            "src/app/app.spec.ts")
                createAppSpec
                ;;
            *) echo "Cannot find file contents for $i"; ;;
        esac;
    fi
}

# FILES
# ------------------------------------------------------
function createKarmaConf() {
cat <<EOF >karma.conf.js
// Karma configuration file, see link for more information
// https://karma-runner.github.io/0.13/config/configuration-file.html
 
module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine', '@angular/cli'],
    plugins: [
      require('karma-jasmine'),
      require('karma-chrome-launcher'),
      require('karma-remap-istanbul'),
      require('karma-mocha-reporter'),
      require('@angular/cli/plugins/karma')
    ],
    files: [
      { pattern: './src/test.ts', watched: false }
    ],
    preprocessors: {
      './src/test.ts': ['@angular/cli']
    },
    mime: {
      'text/x-typescript': ['ts','tsx']
    },
    remapIstanbulReporter: {
      reports: {
        html: 'coverage',
        lcovonly: './coverage/coverage.lcov'
      }
    },
    angularCli: {
      config: './angular-cli.json',
      environment: 'dev'
    },
    reporters: config.angularCli && config.angularCli.codeCoverage
              ? ['mocha', 'karma-remap-istanbul']
              : ['mocha'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome'],
    singleRun: false
  });
};
EOF
}


function createAngularCli() {
cat <<EOF >angular-cli.json
{
  "project": {
    "version": "1.0.0-beta.22-1",
    "name": "ionic2-tdd"
  },
  "apps": [
    {
      "root": "src",
      "outDir": "dist",
      "assets": [
        "assets"
      ],
      "index": "index.html",
      "main": "app/main.ts",
      "test": "test.ts",
      "tsconfig": "tsconfig.test.json",
      "prefix": "app",
      "mobile": false,
      "styles": [
        "styles.css"
      ],
      "scripts": [],
      "environmentSource": "environments/environment.ts",
      "environments": {
        "dev": "environments/environment.ts",
        "prod": "environments/environment.prod.ts"
      }
    }
  ],
  "addons": [],
  "packages": [],
  "test": {
    "karma": {
      "config": "./karma.conf.js"
    }
  },
  "defaults": {
    "styleExt": "css",
    "prefixInterfaces": false,
    "inline": {
      "style": false,
      "template": false
    },
    "spec": {
      "class": false,
      "component": true,
      "directive": true,
      "module": false,
      "pipe": true,
      "service": true
    }
  }
}
EOF
}


function createEnvProd {
cat <<EOF >src/environments/environment.prod.ts
export const environment: any = {
  production: true,
};
EOF
}


function createEnvDev {
cat <<EOF >src/environments/environment.ts
// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses 'environment.ts', but if you do
// 'ng build --env=prod' then 'environment.prod.ts' will be used instead.
// The list of which env maps to which file can be found in 'angular-cli.json'.
 
export const environment: any = {
  production: false,
};
EOF
}


function createMocks {
cat <<EOF >src/mocks.ts
export class ConfigMock {
 
  public get(): any {
    return '';
  }
 
  public getBoolean(): boolean {
    return true;
  }
 
  public getNumber(): number {
    return 1;
  }
}
 
export class FormMock {
  public register(): any {
    return true;
  }
}
 
export class NavMock {
 
  public pop(): any {
    return new Promise(function(resolve: Function): void {
      resolve();
    });
  }
 
  public push(): any {
    return new Promise(function(resolve: Function): void {
      resolve();
    });
  }
 
  public getActive(): any {
    return {
      'instance': {
        'model': 'something',
      },
    };
  }
 
  public setRoot(): any {
    return true;
  }
}
 
export class PlatformMock {
  public ready(): any {
    return new Promise((resolve: Function) => {
      resolve();
    });
  }
}
 
export class MenuMock {
  public close(): any {
    return new Promise((resolve: Function) => {
      resolve();
    });
  }
}
EOF
}


function createPolyfills {
cat <<EOF >src/polyfills.ts
// This file includes polyfills needed by Angular 2 and is loaded before
// the app. You can add your own extra polyfills to this file.
import 'core-js/es6/symbol';
import 'core-js/es6/object';
import 'core-js/es6/function';
import 'core-js/es6/parse-int';
import 'core-js/es6/parse-float';
import 'core-js/es6/number';
import 'core-js/es6/math';
import 'core-js/es6/string';
import 'core-js/es6/date';
import 'core-js/es6/array';
import 'core-js/es6/regexp';
import 'core-js/es6/map';
import 'core-js/es6/set';
import 'core-js/es6/reflect';
 
import 'core-js/es7/reflect';
import 'zone.js/dist/zone';
EOF
}


function createTest {
cat <<EOF >src/test.ts
import './polyfills.ts';
 
import 'zone.js/dist/long-stack-trace-zone';
import 'zone.js/dist/proxy.js';
import 'zone.js/dist/sync-test';
import 'zone.js/dist/jasmine-patch';
import 'zone.js/dist/async-test';
import 'zone.js/dist/fake-async-test';
 
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { getTestBed, TestBed } from '@angular/core/testing';
import { BrowserDynamicTestingModule, platformBrowserDynamicTesting } from '@angular/platform-browser-dynamic/testing';
import { App, Config, Form, IonicModule, Keyboard, DomController, MenuController, NavController, Platform } from 'ionic-angular';
import { ConfigMock } from './mocks';
 
// Unfortunately there's no typing for the '__karma__' variable. Just declare it as any.
declare var __karma__: any;
declare var require: any;
 
// Prevent Karma from running prematurely.
__karma__.loaded = function (): void {
  // noop
};
 
// First, initialize the Angular testing environment.
getTestBed().initTestEnvironment(
  BrowserDynamicTestingModule,
  platformBrowserDynamicTesting(),
);
 
// Then we find all the tests.
let context: any = require.context('./', true, /\.spec\.ts/);
 
// And load the modules.
context.keys().map(context);
 
// Finally, start Karma to run the tests.
__karma__.start();
EOF
}


function createTsconfigTest {
cat <<EOF >src/tsconfig.test.json
{
  "compilerOptions": {
    "baseUrl": "",
    "declaration": false,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "lib": ["es6", "dom"],
    "mapRoot": "./",
    "module": "es6",
    "moduleResolution": "node",
    "outDir": "../dist/out-tsc",
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
cat <<EOF >src/app/app.spec.ts
import { TestBed, ComponentFixture, async } from '@angular/core/testing';
import { IonicModule } from 'ionic-angular';
import { MyApp } from './app.component';
import { SplashScreen } from '@ionic-native/splash-screen';
import { StatusBar } from '@ionic-native/status-bar';
//import { HomePage } from '../pages/home/home';
 
let comp: MyApp;
let fixture: ComponentFixture<MyApp>;
 
describe('Component: Root Component', () => {
 
    beforeEach(async(() => {
 
        TestBed.configureTestingModule({
 
            declarations: [MyApp],
 
            providers: [
                StatusBar,
                SplashScreen,
            ],
 
            imports: [
                IonicModule.forRoot(MyApp)
            ]
 
        }).compileComponents();
 
    }));
 
    beforeEach(() => {
 
        fixture = TestBed.createComponent(MyApp);
        comp    = fixture.componentInstance;
 
    });
 
    afterEach(() => {
        fixture.destroy();
        comp = null;
    });
 
    it('is created', () => {
 
        expect(fixture).toBeTruthy();
        expect(comp).toBeTruthy();
 
    });
 
    //it('initialises with a root page of HomePage', () => {
    //    expect(comp['rootPage']).toBe(HomePage);
    //});
 
});
EOF
}

mainScript
