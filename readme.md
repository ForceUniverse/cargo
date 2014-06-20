## Cargo ##

A small key value store for the server in analogy of html5 localstorage

### Simple usage ###

It has the same interface as of localstorage.

Just make an instance of Storage.

	Storage storage = new Storage();
	
Add data to the storage.

	storage.setItem("data", {"data": "data"});
	
Retrieve data from the storage.

	var data = storage.getItem("data");

### Todo's ###

- store json on disk.

### Contributing ###
 
If you found a bug, just create a new issue or even better fork and issue a
pull request with you fix.