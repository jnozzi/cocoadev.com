

I'm developing a Cocoa application in which the data model is heavily based on an XML format.  I'd like to use the General/XPath functionality of NSXML as it will make querying the underlying data much easier, but am not sure how to bind a particular namespace prefix to a URI.  For example, the query     ./body//p depends on the namespace of the element it is executed against.  I'd like to control how namespace prefixes are bound in the application code to handle cases where the document binds namespaces differently.

I know other libraries use a dictionary mapping prefixes to namespace General/URIs.  Something along the lines of:

    
  General/NSDictionary *bindings = General/[NSDictionary withObject:@"http://www.w3.org/1999/xhtml" forKey:@"xh"];
  General/NSArray *nodes = [xmlDoc nodesForXPath:@"./xh:body//xh:p" withNamespaces:bindings error:&err];


The only way I can see to achieve this with the NSXML API is building a formatted General/XQuery string, but it seems like there should be a better way.

----

Replying to myself, I've written a Category to add the functionality for General/XQuery queries, which may be slower than General/XPath but seems to get the job done.  I'm posting the code here in case anyone else finds it useful.

    

@interface General/NSXMLNode (General/QueryExtensions)
- (General/NSArray *) objectsForXQuery:(General/NSString *)query constants:(General/NSDictionary *)constants namespaces:(General/NSDictionary *)bindings error:(General/NSError **)error
@end

@implementation General/NSXMLNode (General/QueryExtensions)

- (General/NSArray *) objectsForXQuery:(General/NSString *)query constants:(General/NSDictionary *)constants namespaces:(General/NSDictionary *)bindings error:(General/NSError **)error
{
	if (bindings != nil) {
		General/NSString *key;
		General/NSMutableString *compiledQuery = General/[[NSMutableString alloc] init];
		General/NSEnumerator *keys = [bindings keyEnumerator];
		while (key = [keys nextObject]) {
			[compiledQuery appendFormat:@"declare namespace %@ = \"%@\";\n", key, [bindings objectForKey:key]];
		}
		[compiledQuery appendString:query];
		query = compiledQuery;
	}
	
	return [self objectsForXQuery:query constants:constants error:error];
}

@end

