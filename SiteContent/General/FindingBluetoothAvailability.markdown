Does anybody know how to find out if Bluetooth is available on the machine? I can't seem to find an [[IOBluetooth]] or [[IOKit]] call to search for it. Anybody have some hints?

----

http://developer.apple.com/documentation/[[DeviceDrivers]]/Reference/[[IOBluetooth]]/[[IOBluetoothUserLib]]/Functions/Functions.html

As in

<code>
    if ([[IOBluetoothLocalDeviceAvailable]]()) {
        // do a bunch of bluetooth stuff ...
    }
</code>

-- [[MikeTrent]]
----
It also makes sense to check whether the device is turned on:

<code>
- (BOOL)localDeviceIsPowered {
    [[BluetoothHCIPowerState]] powerState;
    [[IOBluetoothLocalDeviceGetPowerState]](&powerState);
    if(powerState == kBluetoothHCIPowerStateOFF) return FALSE;
    return TRUE;
}
</code>
Source: http://www.tims-weblog.com/sites/blog/content/view/50/44/