I'm writing a small program that depends on a few (pre-packaged) data files being present for it to work properly.  To that end, I've added them to my Xcode project and now they show up in [[MyApp]].app/Contents.  How do I access them? Do I use [[NSApplication]] to find out the location of my program, then append Contents/[[MyDataFileName]] to the end of it? Or is there some better way I should be doing this?

----

You should place data files (except for Info.plist, [[PkgInfo]] and other administrative thingies) in the Resources/ folder of the bundle, by adding them to the Copy Resources phase of your Xcode project, then use [[NSBundle]]'s pathForResource:ofType: method(s) to retrieve their path when needed.

Example, given the following folder structure:
<code>
 My.app/
  > Contents/
   > > [[MacOS]]/
    > > > My
   > > Resources/
    > > > [[YourDataFile]].datatype
 ...
</code>

You can access [[YourDataFile]].data's path by doing the following:
<code>
 - (void) myMethod {
    [[NSString]]'' pathToDataFile = [[[[NSBundle]] mainBundle] pathForResource:@"[[YourDataFile]]" ofType:@"datatype"];
    // work with the file...
}
</code>

 - [[EmanueleVulcano]] aka l0ne