## Cargo ##

A small key value store for the server in analogy of html5 localstorage

### Simple usage ###

It has the same interface as of localstorage.

Just make an instance of Storage.

	Cargo storage = new Cargo();
	
Then you will have an asynchronous method to say that the storage is started

	Cargo storage = new Cargo(MODE: CargoMode.FILE, conf: { "path" : "../store/" });
  
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
	
You can also listen to all the data changes.

  cargo.onAll((DataEvent de) => print(de));
	
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
	
When you want to copy some data from one cargo implentation to another you can use.

	cargo.copyTo(anotherCargoImpl);
	
You can also export the data to a map with the functions export and exportSync.
	
### Note ###

IndexDB is not fully functional, we are waiting on the 'await' keyword of dart.

### Contributing ###
 
If you found a bug, just create a new issue or even better fork and issue a
pull request with you fix.

### Join our discussion group ###

[Google group](https://groups.google.com/forum/#!forum/dart-force)

### Social media ###

#### Twitter ####

Follow us on twitter https://twitter.com/usethedartforce

#### Google+ ####

Follow us on [google+](https://plus.google.com/111406188246677273707)

or join our [G+ Community](https://plus.google.com/u/0/communities/109050716913955926616) 
