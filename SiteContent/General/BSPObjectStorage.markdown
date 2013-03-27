Recently I ran into the need to optimise the performance of drawing many tens of thousands of objects. I started to notice that the time to traverse a linear array discovering which objects needed to be drawn (according to General/NSView's -needsToDrawRect: method) was becoming significant. What I describe here is one possible solution to the problem of discovering objects needing to be drawn from an arbitrarily large set. Other solutions are also well-known, such as General/RTrees, but I'll leave that for another day.

This solution makes use of a common search algorithm - that of the General/BinarySearch - in fact given a sorted list of objects, the binary search is the fastest known method to find a given object.

Here, a binary search is extended into 2 dimensions, and the criterion for determining the location of any given object is its bounding rectangle. This is called Binary Search Partitioning, and is a well-known divide-and-conquer method for graphics.

The overall area of a given view is alternately divided and subdivided horizontally and vertically into two partitions, forming a binary tree. The whole view is the root, and the leaves represent some small area of the view. The tree depth determines how small this area is. If the tree depth is 1, there is only one leaf, and the system is equivalent to the linear array case. The number of objects stored at each leaf will usually depend on the depth also - the more finely divided the view, the fewer objects tend to be stored at any given leaf, assuming that on average they are distributed evenly within the view.

The advantage of this approach is that we can quickly return a small set of objects that intersect the view's drawing update area without having to test every one - the input to the tree is a rectangle, and the result is a list of objects that intersect it. General/NSView has the method -getRectsBeingDrawn:count: which will return a list of rectangles needing update. We can use this as input to our tree.

We might also need to consider the front-to-back ordering (Z-order) of the objects. The tree code here doesn't handle this part, but it's easy enough to do if each object maintains a Z-value - the returned list can simply be sorted according to Z. Naturally the Z-value must be maintained as objects are inserted and deleted into the storage.

The tree code is presented below. To add or remove an object from the tree, a bounds parameter must be supplied which locates the object in 2-dimensional space. Typically an object would supply its own bounds, but in this code that is handled externally. In addition, should an object move, it needs to be repositioned in the tree. This is most easily accomplished by removing it using its old bounds value then adding it back with the new bounds. The tree itself uses recursion to accomplish the tree traversal, and the code here optimises the object-C method call to make that as fast as possible. It also makes use of toll-free bridging to General/CFArray and friends to speed up other operations. When a complex drawing is being repeatedly redrawn (as when scrolling for example) these optimisations are worth having. An object needs to respond to -setMarked: which is just a flag that the tree uses to avoid including the same object more than once. The objects should have this flag reset before the next search, on eopportunity to do this is when you iterate the returned list to draw the objects.

Hope this is useful to someone - a more complete implementation is found in General/DrawKit. --General/GrahamCox.

    

typedef enum
{
	kOperationInsert,
	kOperationDelete,
	kOperationAccumulate
}
General/BSPOperation;


typedef enum
{
	kNodeHorizontal,
	kNodeVertical,
	kNodeLeaf
}
General/LeafType;



@interface General/BSPTree : General/NSObject
{
@protected
	General/NSMutableArray*		mLeaves;
	General/NSMutableArray*		mNodes;
	General/NSSize				mCanvasSize;
	General/BSPOperation		        mOp;
@public
	id	                                mObj;
	General/NSMutableArray*		mFoundObjects;
	unsigned				mObjectCount;
}

- (id)				initWithCanvasSize:(General/NSSize) size depth:(unsigned) depth;
- (General/NSSize)			canvasSize;

- (void)			setDepth:(unsigned) depth;
- (unsigned)		countOfLeaves;

- (void)			insertItem:(id) obj withRect:(General/NSRect) rect;
- (void)			removeItem:(id) obj withRect:(General/NSRect) rect;
- (void)			removeAllObjects;
- (unsigned)		count;

// tree returns mutable results so that they can be sorted in place without needing to be copied

- (General/NSMutableArray*)	objectsIntersectingRects:(const General/NSRect*) rects count:(unsigned) count;
- (General/NSMutableArray*)	objectsIntersectingRect:(General/NSRect) rect;
- (General/NSMutableArray*)	objectsIntersectingPoint:(General/NSPoint) point;

@end

#pragma mark -

/// node object - only used internally with General/BSPTree

@interface General/BSPNode : General/NSObject
{
@public
	General/LeafType		mType;
	union
	{
		float		mOffset;
		unsigned	mIndex;
	}u;
}

- (void)			setType:(General/LeafType) aType;
- (General/LeafType)		type;
- (void)			setLeafIndex:(unsigned) indx;
- (unsigned)		leafIndex;
- (void)			setOffset:(float) offset;
- (float)			offset;


@end



//=============================================================================================

static inline unsigned childNodeAtIndex( unsigned nodeIndex )
{
	return (nodeIndex << 1) + 1;
}


@implementation General/BSPTree


- (id)				initWithCanvasSize:(General/NSSize) size depth:(unsigned) depth
{
	self = [super init];
	if( self )
	{
		mCanvasSize = size;
		mNodes = General/[[NSMutableArray alloc] init];
		mLeaves = General/[[NSMutableArray alloc] init];
                mFoundObjects = General/[[NSMutableArray alloc] init];		

		[self setDepth:depth];
	}
	
	return self;
}


- (General/NSSize)			canvasSize
{
	return mCanvasSize;
}



- (void)			setDepth:(unsigned) depth
{
	[self removeNodesAndLeaves];

	unsigned i, nodeCount = (( 1 << ( depth + 1)) - 1);
	
	// prefill the nodes array
	
	for( i = 0; i < nodeCount; ++i )
	{
		General/BSPNode* node = General/[[BSPNode alloc] init];
		[mNodes addObject:node];
		[node release];
	}
	
	[self allocateLeaves:( 1 << depth )];
	
	General/NSRect canvasRect = General/NSZeroRect;
	canvasRect.size = [self canvasSize];
	
	[self partition:canvasRect depth:depth index:0];
}

- (void)			removeNodesAndLeaves
{
	[mNodes removeAllObjects];
	[mLeaves removeAllObjects];
}


- (void)			allocateLeaves:(unsigned) howMany
{
	// prefill the leaves array, which is an array of mutable arrays
	
	unsigned i;
	
	for( i = 0; i < howMany; ++i )
	{
		id leaf = General/[[NSMutableArray alloc] init];
		[mLeaves addObject:leaf];
		[leaf release];
	}
}


static unsigned sLeafCount = 0;

- (void)			partition:(General/NSRect) rect depth:(unsigned) depth index:(unsigned) indx
{
	// recursively subdivide the total canvas size into equal halves in alternating horizontal and vertical directions.
	// This is done once when the tree is built or rebuilt.
	
	General/BSPNode* node = [mNodes objectAtIndex:indx];
	
	if( indx == 0 )
	{
		[node setType:kNodeHorizontal];
		[node setOffset:General/NSMidX( rect )];
		sLeafCount = 0;
	}
	
	if ( depth > 0 )
	{
		General/LeafType	type;
		General/NSRect	ra, rb;
		float		oa, ob;
		
		if([node type] == kNodeHorizontal)
		{
			type = kNodeVertical;
			ra = General/NSMakeRect( General/NSMinX( rect ), General/NSMinY( rect ), General/NSWidth( rect ), General/NSHeight( rect) * 0.5f);
			rb = General/NSMakeRect( General/NSMinX( rect ), General/NSMaxY( ra ), General/NSWidth( rect ), General/NSHeight( rect ) - General/NSHeight( ra ));
			oa = General/NSMidX( ra );
			ob = General/NSMidX( rb );
		}
		else
		{
			type = kNodeHorizontal;
			ra = General/NSMakeRect( General/NSMinX( rect ), General/NSMinY( rect ), General/NSWidth( rect ) * 0.5f, General/NSHeight( rect ));
			rb = General/NSMakeRect( General/NSMaxX( ra), General/NSMinY( rect ), General/NSWidth( rect ) - General/NSWidth( ra ), General/NSHeight( rect ));
			oa = General/NSMidY( ra );
			ob = General/NSMidY( rb );
		}
		
                unsigned chIdx = childNodeAtIndex( indx );
		
                General/BSPNode* child = [mNodes objectAtIndex:chIdx];
		[child setType:type];
		[child setOffset:oa];
		
                child = [mNodes objectAtIndex:chIdx + 1];
                [child setType:type];
		[child setOffset:ob];
		
                [self partition:ra depth:depth - 1 index:chIdx];
                [self partition:rb depth:depth - 1 index:chIdx + 1];
    }
    else
    {
        [node setType:kNodeLeaf];
        [node setLeafIndex:sLeafCount++];
    }
}


// if set to 1, recursive function avoids obj-C message dispatch for slightly more performance

#define qUseImpCaching		1


- (void)			recursivelySearchWithRect:(General/NSRect) rect index:(unsigned) indx
{
#if qUseImpCaching	
	static void(*sfunc)( id, SEL, General/NSRect, unsigned ) = nil;
	
	if ( sfunc == nil )
		sfunc = (void(*)( id, SEL, General/NSRect, unsigned ))General/self class] instanceMethodForSelector:_cmd];
#endif

    [[BSPNode* node = [mNodes objectAtIndex:indx];
    unsigned subnode = childNodeAtIndex( indx );
	
    switch ( node->mType )
	{
		case kNodeHorizontal:
			if ( General/NSMinY( rect ) < node->u.mOffset )
			{
				#if qUseImpCaching	
				sfunc( self, _cmd, rect, subnode );
				#else
				[self recursivelySearchWithRect:rect index:subnode];
				#endif
				if( General/NSMaxY( rect ) >= node->u.mOffset )
					#if qUseImpCaching	
					sfunc( self, _cmd, rect, subnode + 1 );
					#else
					[self recursivelySearchWithRect:rect index:subnode + 1];
					#endif
			}
			else
				#if qUseImpCaching	
				sfunc( self, _cmd, rect, subnode + 1 );
				#else
				[self recursivelySearchWithRect:rect index:subnode + 1];
				#endif
			break;
			
		case kNodeVertical:
			if ( General/NSMinX( rect ) < node->u.mOffset )
			{
				#if qUseImpCaching	
				sfunc( self, _cmd, rect, subnode );
				#else
				[self recursivelySearchWithRect:rect index:subnode];
				#endif
				if( General/NSMaxX( rect ) >= node->u.mOffset )
					#if qUseImpCaching	
					sfunc( self, _cmd, rect, subnode + 1 );
					#else
					[self recursivelySearchWithRect:rect index:subnode + 1];
					#endif
			}
			else
				#if qUseImpCaching	
				sfunc( self, _cmd, rect, subnode + 1 );
				#else
				[self recursivelySearchWithRect:rect index:subnode + 1];
				#endif
			break;
			
		case kNodeLeaf:
			[self operateOnLeaf:[mLeaves objectAtIndex:node->u.mIndex]];
			break;
			
		default:
			break;
    }
}



- (void)			recursivelySearchWithPoint:(General/NSPoint) pt index:(unsigned) indx
{
    General/BSPNode* node = [mNodes objectAtIndex:indx];
    unsigned subnode = childNodeAtIndex( indx );
	
    switch ([node type])
	{
		case kNodeLeaf:
			[self operateOnLeaf:[mLeaves objectAtIndex:[node leafIndex]]];
			break;
			
		case kNodeVertical:
			if ( pt.x < [node offset])
				[self recursivelySearchWithPoint:pt index:subnode];
			else
				[self recursivelySearchWithPoint:pt index:subnode + 1];
			break;
			
		case kNodeHorizontal:
			if ( pt.y < [node offset])
				[self recursivelySearchWithPoint:pt index:subnode];
			else
				[self recursivelySearchWithPoint:pt index:subnode + 1];
			break;
			
		default:
			break;
    }
}


#define USE_CF_APPLIER         1

static void			addValueToFoundObjects( const void* value, void* context )
{
	id obj = (id)value;
	
	if(![obj isMarked] && [obj visible])
	{
		General/BSPTree* tree = (General/BSPTree*)context;
		[obj setMarked:YES];
		General/CFArrayAppendValue((General/CFMutableArrayRef)tree->mFoundObjects, value );
	}
}



- (void)			operateOnLeaf:(id) leaf
{
	// <leaf> is a pointer to the General/NSMutableArray at the leaf
	
	switch( mOp )
	{
		case kOperationInsert:
			[leaf addObject:mObj];
			break;
			
		case kOperationDelete:
			[leaf removeObject:mObj];
			break;
			
		case kOperationAccumulate:
		{
#if USE_CF_APPLIER
			General/CFArrayApplyFunction((General/CFArrayRef) leaf, General/CFRangeMake( 0, [leaf count]), addValueToFoundObjects, self );
#else			
			General/NSEnumerator* iter = [leaf objectEnumerator];
			id anObject;
			
			while(( anObject = [iter nextObject]))
			{
				if(![anObject isMarked] && [anObject visible])
				{
					[anObject setMarked:YES];
					[mFoundObjects addObject:anObject];
				}
			}
#endif
		}
		break;
			
		default:
			break;
	}
}


- (void)			insertItem:(id<General/DKStorableObject>) obj withRect:(General/NSRect) rect
{
    if ([mNodes count] == 0)
        return;
	
	if( obj && !General/NSIsEmptyRect( rect ))
	{
		mOp = kDKOperationInsert;
		mObj = obj;
		[self recursivelySearchWithRect:rect index:0];
		
		++mObjectCount;
	}
	
	//General/NSLog(@"inserted obj = %@, bounds = %@", obj, General/NSStringFromRect( rect ));
}


- (void)			removeItem:(id<General/DKStorableObject>) obj withRect:(General/NSRect) rect
{
    if ([mNodes count] == 0)
        return;
	
	if( obj && !General/NSIsEmptyRect( rect ))
	{
		[obj setMarked:NO];
		mOp = kOperationDelete;
		mObj = obj;
		[self recursivelySearchWithRect:rect index:0];
		
		if( mObjectCount > 0 )
			--mObjectCount;
	}
}


- (void)			removeAllObjects
{
	General/NSEnumerator* iter = [mLeaves objectEnumerator];
	General/NSMutableArray*	leaf;
	
	while(( leaf = [iter nextObject]))
		[leaf removeAllObjects];
	
	mObjectCount = 0;
}


- (General/NSMutableArray*)	objectsIntersectingRects:(const General/NSRect*) rects count:(unsigned) count
{
	// this may be used in conjunction with General/NSView's -getRectsBeingDrawn:count: to find those objects that intersect the non-rectangular update region.
	
    if ([mNodes count] == 0)
        return nil;
	
	mOp = kOperationAccumulate;
	[mFoundObjects removeAllObjects];
	
	unsigned i;
	
	for( i = 0; i < count; ++i )
		[self recursivelySearchWithRect:rects[i] index:0];
	
	return mFoundObjects;
}


- (General/NSMutableArray*)	objectsIntersectingRect:(General/NSRect) rect
{
    if ([mNodes count] == 0)
        return nil;
	
	mOp = kOperationAccumulate;
	[mFoundObjects removeAllObjects];
	
	[self recursivelySearchWithRect:rect index:0];
	return mFoundObjects;
}


- (General/NSMutableArray*)	objectsIntersectingPoint:(General/NSPoint) point
{
    if ([mNodes count] == 0)
        return nil;
	
	mOp = kOperationAccumulate;
	[mFoundObjects removeAllObjects];
	
	[self recursivelySearchWithPoint:point index:0];
	return mFoundObjects;
}


- (unsigned)		count
{
	// returns the number of unique objects in the tree. Note that this value can be unreliable if the client didn't take care (i.e. calling removeItem with a bad object).
	
	return mObjectCount;
}

- (void)			dealloc
{
	[mNodes release];
	[mLeaves release];
        [mFoundObjects release];
	[super dealloc];
}


- (General/NSString*)		description
{
	// warning: description string can be very large, as it enumerates the leaves
	
	return General/[NSString stringWithFormat:@"<%@ %p>, %d leaves = %@", General/NSStringFromClass([self class]), self, [self countOfLeaves], mLeaves];
}


#pragma mark -


@implementation General/BSPNode

- (void)			setType:(General/LeafType) aType
{
	mType = aType;
}



- (General/LeafType)		type
{
	return mType;
}




- (void)			setLeafIndex:(unsigned) indx
{
	u.mIndex = indx;
}



- (unsigned)		leafIndex
{
	return u.mIndex;
}




- (void)			setOffset:(float) offset
{
	u.mOffset = offset;
}



- (float)			offset
{
	return u.mOffset;
}

@end

