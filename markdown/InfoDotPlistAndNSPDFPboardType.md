

I have a program that exports PDF, TIFF, and PNG files so I followed Apple's Sketch example when declaring types in my     Info.plist file:

    
<dict>
     <key>General/CFBundleTypeExtensions</key>
     <array>
          <string>foo</string>
     </array>
     <key>General/CFBundleTypeName</key>
     <string>General/MyDocumentFileType</string>
     <key>General/CFBundleTypeRole</key>
     <string>Editor</string>
     <key>General/NSDocumentClass</key>
     <string>General/MyDocument</string>
     <key>General/NSExportableAs</key>
     <array>
          <string>General/NSPDFPboardType</string>
          <string>General/NSTIFFPboardType</string>
          <string>General/MyPNGFileType</string>
     </array>
</dict>
<dict>
     <key>General/CFBundleTypeExtensions</key>
     <array>
          <string>pdf</string>
     </array>
     <key>General/CFBundleTypeName</key>
     <string>General/NSPDFPboardType</string>
     <key>General/CFBundleTypeRole</key>
     <string>None</string>
</dict>
<dict>
     <key>General/CFBundleTypeExtensions</key>
     <array>
          <string>tiff</string>
          <string>tif</string>
     </array>
     <key>General/CFBundleTypeName</key>
     <string>General/NSTIFFPboardType</string>
     <key>General/CFBundleTypeRole</key>
     <string>None</string>
</dict>
<dict>
     <key>General/CFBundleTypeExtensions</key>
     <array>
          <string>png</string>
     </array>
     <key>General/CFBundleTypeName</key>
     <string>General/MyPNGFileType</string>
     <key>General/CFBundleTypeRole</key>
     <string>None</string>
</dict>


Unfortunately, this has an unexpected consequence.  Calls to     -General/[NSDocumentController fileExtensionsFromType:] with     @"General/NSPDFPboardType" or     @"General/NSTIFFPboardType" return     nil but calling the method with     @"General/MyPNGFileType" still works as expected.

So why is this happening?  Thanks!