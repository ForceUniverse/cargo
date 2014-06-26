## Cargo ##

A small key value store for the server in analogy of html5 localstorage

### Simple usage ###

It has the same interface as of localstorage.

Just make an instance of Storage.

	Storage storage = new Storage();
	
Then you will have an asynchronous method to say that the storage is started

	Storage storage = new Storage(path: "store/");
  
  	storage.start().then((_) {
  		// do storage operations
  	});
	
Add data to the storage.

	storage.setItem("data", {"data": "data"});
	
Retrieve data from the storage.

	var data = storage.getItem("data");

### Todo's ###

- store json on disk.

### Contributing ###
 
If you found a bug, just create a new issue or even better fork and issue a
pull request with you fix.