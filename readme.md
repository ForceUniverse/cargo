## Cargo ##

A small key value store for the server in analogy of html5 localstorage

### Simple usage ###

It has the same interface as of localstorage.

Just make an instance of Storage.

	Cargo storage = new Cargo();
	
Then you will have an asynchronous method to say that the storage is started

	Cargo storage = new Cargo(MODE: CargoMode.FILE, path: "../store/");
  
  	storage.start().then((_) {
  		// do storage operations
  	});
	
Add data to the storage.

	storage.setItem("data", {"data": "data"});
	storage["data"] = {"data": "data"};
	
Retrieve data from the storage on an asynchronous way.

	var data = storage.getItem("data");

Or on a synchronous way.

	var data = storage["data"];

Or like this	
	
	var data = storage.getItemSync("data");

### Todo's ###

- add a client implementation of storage

### Contributing ###
 
If you found a bug, just create a new issue or even better fork and issue a
pull request with you fix.