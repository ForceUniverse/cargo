### Changelog ###

This file contains highlights of what changes on each version of the cargo package.

#### Pub version 0.7.0 ####

- Adding Options in the export methods, first usecase is limiting your export to a certain amount of results

#### Pub version 0.6.0 ####

- Change return type of the clear() method, return a Future.
- Fix encoding of special chars for the file implementation.

#### Pub version 0.5.1 ####

- Export with query parameters, extend method with optional query parameters.
  
  Map exportSync({Map params});
  Future<Map> export({Map params});

#### Pub version 0.5.0+2 ####

- Fix dispatch localstorage implementation

#### Pub version 0.5.0+1 ####

- Add possibility to define a collection in the constructor of cargo as optional.

#### Pub version 0.5.0 ####

- add collection switch
- improve testing suite
- add method instanceWithCollection

#### Pub version 0.4.5 ####

- add DataType into DataEvent, so you can see if a data element is been changed or removed

#### Pub version 0.4.4+1 ####

- small adjustments when we fire an onAll event.

#### Pub version 0.4.4 ####

- Add the key to the dataEvent object.
- Add onAll method to CargoDispatcher
- Add with CargoDispatcher to CargoBase and remove it from all Cargo classes

#### Pub version 0.4.3 ####

- length method returns now Future<int> instead of int, go to an asynchronous implementation.

#### Pub version 0.4.2 ####

- export & exportSync methods

#### Pub version 0.4.1+1 ####

- Change of directory for temporary data for testing
- Rename FileBackend to FileCargo
- Code reformat

#### Pub version 0.4.1 ####

- Adding a copyTo method and an export method.
- Adding the method exportToFileStorage to the memory impl serverside.
- Still some work todo in indexDB implementation.

#### Pub version 0.4.0 ####

- Adding a better way of adding configuration data to the right implementation.

So instead of path: ... you will find now conf: ...

	var cargo = new Cargo(MODE: CargoMode.FILE, conf: { "path" : "../store/" });

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

