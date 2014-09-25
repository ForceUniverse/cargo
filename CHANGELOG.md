### Changelog ###

This file contains highlights of what changes on each version of the cargo package.

#### Pub version 0.3.5+7 - 0.3.5+8 ####

- Improvement fixes for indexeddb implementation

#### Pub version 0.3.5+2 - 0.3.5+6 ####

- Improvement of the localstorage implementation, fix a bug with retrieving a value of an item.

#### Pub version 0.3.5+1 ####

- Move package to ForceUniverse on github.

#### Pub version 0.3.5 ####

- Add an optional parameter defaultValue when you want to get an item out of the storage implementation.

#### Pub version 0.3.4+1 ####

- Solve issue with add, when the key don't exist!

#### Pub version 0.3.4 ####

- Add the method, 'add' to cargo, so you can add data to a key in a list. This can be handy if you want to collect data.
- Improve the working of localstorage, encode and decode objects.

#### Pub version 0.3.3 ####

- Add the implementation of IndexDb as an option

#### Pub version 0.3.2+1 ####

- Small improvement in reading out a directory.

#### Pub version 0.3.2 ####

- Introducing off(key, datachangelistener) and offAll(key) method, to remove the listeners

#### Pub version 0.3.1 ####

- Adding events responds immediately to data changes as they occur. 
  By using the method cargo.on("userData", (DataEvent de) {
  });

#### Pub version 0.3.0 ####

- Changed Storage into Cargo class
- Client / Server abstraction

#### Pub version 0.2.0 ####

- Add async for getting a value
- Add operator functions [] and []=
- Fix some issues on the length parameter

#### Pub version 0.1.0 ####

- Add start method to the storage implementation
- Length of json storage

#### Pub version 0.0.1 ####

- Add a memory storage implementation
- Add a json storage implementation
- Setup of the project

