

I have a program that exports PDF, TIFF, and PNG files so I followed Apple's Sketch example when declaring types in my <code>Info.plist</code> file:

<code>
<dict>
     <key>[[CFBundleTypeExtensions]]</key>
     <array>
          <string>foo</string>
     </array>
     <key>[[CFBundleTypeName]]</key>
     <string>[[MyDocumentFileType]]</string>
     <key>[[CFBundleTypeRole]]</key>
     <string>Editor</string>
     <key>[[NSDocumentClass]]</key>
     <string>[[MyDocument]]</string>
     <key>[[NSExportableAs]]</key>
     <array>
          <string>[[NSPDFPboardType]]</string>
          <string>[[NSTIFFPboardType]]</string>
          <string>[[MyPNGFileType]]</string>
     </array>
</dict>
<dict>
     <key>[[CFBundleTypeExtensions]]</key>
     <array>
          <string>pdf</string>
     </array>
     <key>[[CFBundleTypeName]]</key>
     <string>[[NSPDFPboardType]]</string>
     <key>[[CFBundleTypeRole]]</key>
     <string>None</string>
</dict>
<dict>
     <key>[[CFBundleTypeExtensions]]</key>
     <array>
          <string>tiff</string>
          <string>tif</string>
     </array>
     <key>[[CFBundleTypeName]]</key>
     <string>[[NSTIFFPboardType]]</string>
     <key>[[CFBundleTypeRole]]</key>
     <string>None</string>
</dict>
<dict>
     <key>[[CFBundleTypeExtensions]]</key>
     <array>
          <string>png</string>
     </array>
     <key>[[CFBundleTypeName]]</key>
     <string>[[MyPNGFileType]]</string>
     <key>[[CFBundleTypeRole]]</key>
     <string>None</string>
</dict>
</code>

Unfortunately, this has an unexpected consequence.  Calls to <code>-[[[NSDocumentController]] fileExtensionsFromType:]</code> with <code>@"[[NSPDFPboardType]]"</code> or <code>@"[[NSTIFFPboardType]]"</code> return <code>nil</code> but calling the method with <code>@"[[MyPNGFileType]]"</code> still works as expected.

So why is this happening?  Thanks!