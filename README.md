DHCoreData
==========

Simple class for creating a core data stack.  Uses concurrency model and is expecting to use performBlock: methods.

`mainContext` returns a managed object context with a `NSMainQueueConcurrencyType`.  This is the context expected to be used
for the user interface.  It has a parent context with `NSPrivateQueueConcurrencyType`.  When saving, call `dhSave:` to propagate
changes up to the parent context to perform an asynchronous save.

For asynchronous data processing, get a managed object context from the `context`, which will return a private queue type context
wtih the `mainContext` as its parent.  Calling `dhSave:` should then notify the main context of updates before performing the save
asynchronously.


Todo:
Get tests running properly.
Add data model for testing
