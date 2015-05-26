DHCoreData
================

[![Circle CI](https://circleci.com/gh/dhardiman/DHCoreData.svg?style=svg&circle-token=749cfe467657ec38861f166f80a6c7081a02a2c1)](https://circleci.com/gh/dhardiman/DHCoreData)

Common repository of useful Core Data code

Includes [DHFoundation](https://github.com/dhardiman/DHFoundation) when built as a framework.

## Classes
### DHCoreDataStack
Convenient class for configuring Core Data. Using the `sharedStack` will give you a configured main thread managed object context as well as a method for getting private queue managed object contexts which are configured for merging their changes to the main context on save. The name of the model should be supplied, as well as optional configurations for the directory and the store name. If you have multiple models in your app, simply create and retain as many `DHCoreDataStack` objects as you have models.
