

slerp has a whole mess of handy snippets: http://phonedev.tumblr.com

----

**Take a screen shot**

Thanks to Erica Sadun, I believe.

    
@implementation General/UIView (Snapshot)

- (void)saveSnapshot
{
	General/CGRect bounds;
	int err = 0, i;
	General/CGImageRef image = nil;
	char path[ 32 ];
	General/CGContextRef pdfContext = nil;
	struct stat sb;
	General/CFStringRef string = nil;
	General/CFURLRef url = nil;
	
	bounds = [self bounds];
	
	for ( i = 0; i < 100; ++i )
	{
		snprintf( path, sizeof(path), "/tmp/snapshot_%d.pdf", i );
		if ( stat( path, &sb ) == -1 ) break;
	}
	
	if ( ! ( string = General/CFStringCreateWithCString( nil, path, kCFStringEncodingASCII ) ) ) err = 1;
	if ( ! err && ! ( image = [self createSnapshotWithRect: bounds] ) ) err = 1;
	if ( ! err && ! ( url = General/CFURLCreateWithFileSystemPath( nil, string, kCFURLPOSIXPathStyle, 0 ) ) ) err = 1;
	if ( ! err && ! ( pdfContext = General/CGPDFContextCreateWithURL( url, &bounds, nil ) ) ) err = 1;

	if ( ! err ) {
		General/CGContextBeginPage( pdfContext, &bounds );
		General/CGContextDrawImage( pdfContext, bounds, image );
		General/CGContextEndPage( pdfContext );
		General/CGContextFlush( pdfContext );
	}
	
	if ( pdfContext ) General/CGContextRelease( pdfContext );
	if ( url ) General/CFRelease( url );
	if ( image ) General/CGImageRelease( image );
	if ( string ) General/CFRelease( string );
}

@end


----

**Subclassing General/UIKit**

To see what the rest of General/UIKit is expecting from your subclass, you can log calls to respondsToSelector: and the like.

    
- (BOOL)respondsToSelector:(SEL)selector
{
  General/NSLog(@"respondsToSelector: %s", selector);
  return [super respondsToSelector:aSelector];
}

- (General/NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
  General/NSLog(@"methodSignatureForSelector: %s", selector);
  return [super methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(General/NSInvocation*)invocation
{
  General/NSLog(@"forwardInvocation: %s", [invocation selector]);
  [super forwardInvocation:anInvocation];
}


----

If you use a function that returns a float or a double, you'll get a linker error on the function objc_msgSend_fpret. Here's a standin until the toolchain is fixed:

    

double objc_msgSend_fpret(id self, SEL op, ...) {
	Method method = class_getInstanceMethod(self->isa, op);
	int numArgs = method_getNumberOfArguments(method);
	
	if(numArgs == 2) {
		double (*imp)(id, SEL);
		imp = (double (*)(id, SEL))method->method_imp;
		return imp(self, op);
	} else if(numArgs == 3) {
		// FIXME: this code assumes the 3rd arg is 4 bytes
		va_list ap;
		va_start(ap, op);
		double (*imp)(id, SEL, void *);
		imp = (double (*)(id, SEL, void *))method->method_imp;
		return imp(self, op, va_arg(ap, void *));
	}
	
	// FIXME: need to work with multiple arguments/types
	fprintf(stderr, "ERROR: objc_msgSend_fpret, called on <%s %p> with selector %s, had to return 0.0\n", object_getClassName(self), self, sel_getName(op));
	return 0.0;	
}


**Update:** http://www.tuaw.com/2007/09/04/iphone-coding-using-the-slider/ says that this is no longer necessary as of the v.20 toolchain.