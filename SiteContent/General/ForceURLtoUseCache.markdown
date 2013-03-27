I use General/WebView to load page, and some pages have cache-control dirrectives (pragma no-cache, etc.)
General/WebView follows this dirrectives, so when I load them, there are no access to data via

    
- (id)webView:(General/WebView *)sender identifierForInitialRequest:(General/NSURLRequest *)request fromDataSource:(General/WebDataSource *)dataSource
{
        return (request);
}
-(void)webView:(General/WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(General/WebDataSource *)dataSource
{
        General/NSCachedURLResponse *cResponse = [ General/[NSURLCache sharedURLCache] cachedResponseForRequest:identifier];
}


cResponse is nil��

what can I do to access data of resource for loaded page in case of no-cache pragma?
Is there any way to force storing cache for such pages?