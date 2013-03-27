Does anybody know how to find out if Bluetooth is available on the machine? I can't seem to find an General/IOBluetooth or General/IOKit call to search for it. Anybody have some hints?

----

http://developer.apple.com/documentation/General/DeviceDrivers/Reference/General/IOBluetooth/General/IOBluetoothUserLib/Functions/Functions.html

As in

    
    if (General/IOBluetoothLocalDeviceAvailable()) {
        // do a bunch of bluetooth stuff ...
    }


-- General/MikeTrent
----
It also makes sense to check whether the device is turned on:

    
- (BOOL)localDeviceIsPowered {
    General/BluetoothHCIPowerState powerState;
    General/IOBluetoothLocalDeviceGetPowerState(&powerState);
    if(powerState == kBluetoothHCIPowerStateOFF) return FALSE;
    return TRUE;
}

Source: http://www.tims-weblog.com/sites/blog/content/view/50/44/