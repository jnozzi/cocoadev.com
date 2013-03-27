I'm trying to use General/NSStream's SOCKS Proxy support, and I cannot seem to get it to work.  I've written a class to wrap around the General/NSStream (for purposes of General/UnitTesting) and these are the two relevant methods:

    
- (BOOL) setProperty:(id)value forKey:(General/NSString *)key
{
  BOOL success;
  General/NSLog(@"Value before set: %@ forKey: %@", value, key);
  success = [stream setProperty:value forKey:key];
  General/NSLog(@"Value after set: %@ forKey: %@",
        [stream propertyForKey:key], key);
  return success;
}

- (id) propertyForKey:(General/NSString *)key
{
  return [stream propertyForKey:key];
}


Elsewhere I call this code:

    
- (BOOL) enableProxyWithHostname:(General/NSString *)hostname
                          onPort:(int)port
                         version:(int)version
                        username:(General/NSString *)username
                        password:(General/NSString *)password
{
  BOOL success;
  General/NSArray *objects = General/[NSArray arrayWithObjects:
    hostname,
    General/[NSNumber numberWithInt:port],
    (version == 4 ? NSStreamSOCKSProxyVersion4 : NSStreamSOCKSProxyVersion5),
    username,
    password, nil];
  
  General/NSArray *keys = General/[NSArray arrayWithObjects:
    General/NSStreamSOCKSProxyHostKey,
    General/NSStreamSOCKSProxyPortKey,
    General/NSStreamSOCKSProxyVersionKey,
    General/NSStreamSOCKSProxyUserKey,
    General/NSStreamSOCKSProxyPasswordKey, nil];
  
  General/NSDictionary *proxyDictionary = General/[NSDictionary dictionaryWithObjects:objects
                                                              forKeys:keys];
  
  General/NSLog(@"Dictionary %@", proxyDictionary);
  
  success = [inputStream setProperty:proxyDictionary
                              forKey:General/NSStreamSOCKSProxyConfigurationKey];  
  if (success)
  {
    success = [outputStream setProperty:proxyDictionary
                                 forKey:General/NSStreamSOCKSProxyConfigurationKey];
  }
  
  return success;
}


When I call that third method it returns success!  But, if I then check the stream, the property is nil.  Any ideas?