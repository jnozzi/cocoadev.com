

I have a float pointer and want to return it from class, is this the right way?

<code>
- (float '')amb
{
	float ret[4] = {x, y, z, w};
	return ret;
}


//Another file

float test[4] = [[[AClass]] amb];

</code>

----

It's the right way to return a pointer, but your code is because your array will be deallocated when amb returns (it goes out of scope). Try this:

<code>
- (float '')amb
{
	float'' ret = calloc(sizeof(float),4);
        ret[0] = x;
        ret[1] = y;
        ret[2] = z;
        ret[3] = w;
	return ret;
}


//Another file

float'' test = [[[AClass]] amb];
</code>

Don't forget to call <code>free(test)</code> when you're done.

Alternatively, you could use an [[NSArray]] of [[NSNumber]]<nowiki/>s.

----

Another way would be to make the caller take care of memory allocation:
<code>
- (void)getAmb:(float '')array {
	array[0] = x;
	array[1] = y;
	array[2] = z;
	array[3] = w;
}

// call it like this:

float test[4];
[obj getAmb:test];
</code>

''this way would be more in keeping with Cocoa semantics''

----

Since this is obviously a 4-vector, I'd do it like this:
<code>
typedef struct
{
float x, y, z, w;
} V4;

-(V4)getAmb
{
V4 ret={x, y, z, w};
return ret;
}
</code>
Of course, that wouldn't be a pointer return.

----

You could even wrap that 4-vector up in an [[ObjC]] class if you wanted.

<code>
@interface fourVector : [[NSObject]] {
   float x, y, z, w;
}
- (id)initWithX:(float)_x y:(float)_y z:(float)_z w:(float)_w;
- (float)getX;
- (float)getY;
- (float)getZ;
- (float)getW;
@end
</code>

That way, you can take advantage not only of adding transformations, etc., to the interface, you can use [[ObjC]]'s [[MemoryManagement]] to solve the return problem:

<code>
-(fourVector'')getAmb {
   return [[[fourVector alloc] initWithX:x y:y z:z w:w] autorelease];
}
</code>

Indeed, you could simply store a <code>fourVector</code> in the class providing getAmb, instead of x,y,z and w. You could then give it a better name.