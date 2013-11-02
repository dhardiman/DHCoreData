DHCoreData
================

Common repository of useful Core Data code

Includes [DHFoundation](https://github.com/dhardiman/DHFoundation) when built as a framework.

## Classes
### DHCoreDataStack
Convenient class for configuring Core Data. Using the `sharedStack` will give you a configured main thread managed object context as well as a method for getting private queue managed object contexts which are configured for merging their changes to the main context on save. The name of the model should be supplied, as well as optional configurations for the directory and the store name. If you have multiple models in your app, simply create and retain as many `DHCoreDataStack` objects as you have models.
