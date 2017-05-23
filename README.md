# Ionic 3 Testing Script

The script will install packages and create config files that are needed for Ionic 3 testing.
This setup and configurations are based on https://www.joshmorony.com/introduction-to-testing-ionic-2-applications-with-testbed/

A second script was created "initIonicTest2.sh" which is based on 
https://github.com/driftyco/ionic-unit-testing-example

##### WARNING! The scripts are not tested on all versions. Use it at your own risk >:)

### Installation
1. Create a new [Ionic 3](http://ionicframework.com/getting-started/) project
2. Copy the script *initIonicTest.sh* OR *initIonicTest2.sh* to your project's root directory
3. Add permission and run the script
```sh
$ chmod u+x initIonicTest.sh
$ ./initIonicTest.sh
```
4. Add *test* script to your package.json
* If you are using initIonicTest.sh add:
```
        "test": "ng test"
```
* If you are using initIonicTest2.sh add:
```
        "test": "karma start ./test-config/karma.conf.js",
        "test-ci": "karma start ./test-config/karma.conf.js --single-run",
        "e2e": "webdriver-manager update --standalone false --gecko false; protractor ./test-config/protractor.conf.js"
```
5. Run the test
```sh
$ npm test
```

### Known Issues

* initIonicTest.sh - [ERROR in Could not resolve module @angular/router](https://github.com/angular/angular-cli/issues/5967) - Current issue with @angular/cli. Just modify a file (eg. tsconfig.test.json) and it will resume.
