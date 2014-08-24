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
	
Realtime data events are possible as follow.
Adding events responds immediately to data changes as they occur. 
  
	cargo.on("userData", (DataEvent de) {
	  	// add code that needs to happen when userData value is been changed
	});

You can also turn the event off!

	cargo.off("userData", dataChangeListener);

Or remove all the listeners

	cargo.offAll("userData");
	
These are the modes that you can use:

Serverside:

	CargoMode.MEMORY
  	CargoMode.FILE

Clientside:

	CargoMode.MEMORY
  	CargoMode.INDEXDB
  	CargoMode.LOCAL
  	CargoMode.SESSION
  	
You can also provide a defaultValue when you want to retrieve a value, but the value is not yet present.

	cargo.getItem("key", defaultValue: new List());

### Contributing ###
 
If you found a bug, just create a new issue or even better fork and issue a
pull request with you fix.

### Join our discussion group ###

[Google group](https://groups.google.com/forum/#!forum/dart-force)