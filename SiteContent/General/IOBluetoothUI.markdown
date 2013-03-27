

General/IOBluetoothUI constains subclasses of General/NSWindowController which provide access to the Built-in Apple User Interface for Paring, Device Selection, Service Browsing and Object Push.

Note that the General/IOBluetooth framework is not thread safe, if you make your first bluetooth call from a secondary thread these window controllers will not function.