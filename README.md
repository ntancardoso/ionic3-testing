# Ionic2-Testing Script

The script will install packages and create config files that are needed for Ionic 2 testing.
This setup and configurations are based on https://www.joshmorony.com/introduction-to-testing-ionic-2-applications-with-testbed/

A second script was created "initIonicTest2.sh" which is based on 
https://github.com/driftyco/ionic-unit-testing-example

##### WARNING! This script is not tested on all versions. Use it at your own risk >:)

### Installation
1. Create a new [Ionic 3](http://ionicframework.com/getting-started/) project
2. Copy the script initIonicTest.sh to your project's root directory
3. Add permission and run the script
```sh
$ chmod u+x initIonicTest.sh
$ ./initIonicTest.sh
```
4. Run the test
```sh
$ ng test
```
5. (Optional) Add *"test": "ng test"* to your package.json scripts
```sh
$ npm test
```

### Known Issues

* [ERROR in Could not resolve module @angular/router](https://github.com/angular/angular-cli/issues/5967) - Current issue with @angular/cli. Just modify a file (eg. tsconfig.test.json) and it will resume.
