The Java appkit does not implement NSURL, although General/NSWorkspace does implement the General/OpenURL method. General/OpenURL takes a java.net.URL instead of an NSURL. Therefore you can cause the system to open an URL using code like this:

    
try
{
  General/NSWorkspace ws = General/NSWorkspace.sharedWorkspace();
  java.net.URL url = new java.net.URL( "http://www.wrq.com" );
  ws.openURL( url );
}
catch( java.net.General/MalformedURLException e )
{
  e.printStackTrace();
}


General/StevePoole