I wan't to implement something like Activity Window in Safari, so I do:

<code>
[web setResourceLoadDelegate:self];

-(void)webView:([[WebView]] '')sender resource:(id)identifier didFinishLoadingFromDataSource:([[WebDataSource]] '')dataSource

{
  [[NSLog]](@"did finish load, %s", [[[[dataSource request] URL] relativeString] cString]);
}
</code>

But it always write only top-level url (domain name) i.e.:

did finish load, http://www.site.com/

for the page with text and three images on it. <code>absoluteString</code> will not help.

----

here is the solution:
<code>
- (id)webView:([[WebView]] '')sender identifierForInitialRequest:([[NSURLRequest]] '')request fromDataSource:([[WebDataSource]] '')dataSource
{
	return (request); // see this? this is the solution
}
</code>

----

This doesn't help, identifier changes, but dataSource is still EXACTLY the same in every call of didFinishLoading delegate :(
It contains just the data from URL in it :(

----
The [[WebDataSource]] in this case is the object that triggered the load. If you follow the example above you need to change your method accordingly:
<code>
-(void)webView:([[WebView]] '')sender resource:(id)identifier didFinishLoadingFromDataSource:([[WebDataSource]] '')dataSource
{
  [[NSLog]](@"did finish load, %@", identifier);
}
</code>
-- [[MikeSolomon]]

----

If you read the documentation, like Mike may have, you think it should work. But it doesn't, like the OP says. I'm testing this out now and I can't seem to figure out how to work it to track each resource. The request's URL always points to the main URL.