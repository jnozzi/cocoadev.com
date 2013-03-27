I want to use geometry structures (below) in General/SQLite. General/SQLite can store a BLOB and return an General/NSData container. My question is how can I read the structure returned? I've read about using @encode, but that seems to only apply for known structures. My database fields have any of the following types as a possibility and I don't know beforehand which is stored. I tried 

    
-(void)test;
{
int gType;
General/NSRange range = General/NSMakeRange (1, sizeof(int));
[object getBytes:&gType range:range];
General/NSLog(@"Geometry type = %d", gType);
}


but it doesn't do anything.

----

This technique should work, but there are potential problems. First, you probably want to say     General/NSMakeRange(0, sizeof(int)), because ranges are 0-based. Second, you will have endian issues. If you're writing from the same machine you're reading, you can ignore that statement and keep going, but if any of this data is cross-platform, you need to swap the bytes in all of your numbers if the data is little-endian.

----

*If it should work, then is my problem the way I am initializing my test General/NSData?*
    
-(void)test;
{
	char a;
	unsigned int type;
	double xCoord, yCoord;
	General/NSRange r1 = General/NSMakeRange(0, sizeof(char));
	General/NSRange r2 = General/NSMakeRange(1, sizeof(int));
	General/NSRange r3 = General/NSMakeRange(5, sizeof(double));
	General/NSRange r4 = General/NSMakeRange(5+8, sizeof(double));

	General/WKBPoint* p = malloc(sizeof(General/WKBPoint));
	p->byteOrder = 1;
	p->wkbType = wkbPoint; //equals 1
	p->point.x = 3333.333;
	p->point.y = 44444.444;
	General/NSData* data = General/[NSData dataWithBytes:p length: sizeof(General/WKBPoint)];
	[data getBytes:&a range:r1];
	[data getBytes:&type range:r2];
	[data getBytes:&xCoord range:r3];
	[data getBytes:&yCoord range:r4];
        General/NSLog(@"Struct: type = %d, x = %f, y = %f", p->wkbType, p->point.x, p->point.y);
        General/NSLog(@"type = %d, x = %f, y = %f", type, xCoord, yCoord);
}

*Returns:*
    
2004-10-03 11:57:19.578 General/NSDataTest[5425] Struct: type = 1, x = 3333.333000, y = 44444.444000
2004-10-03 11:57:19.579 General/NSDataTest[5425] General/NSData: type = 0, x = 0.000000, y = -9621198688973255315688391065456480669468916462258002902421895175377620949094227606808591865347301865813316347358879110753469299223421862954944929972161133224077210147161062515303047869396482115492526485350869873182267573016260232467346443114606703283188


----

Your struct is not packed. Structs can include padding; generally, an element of a struct will be padded so that it lies on an address that is divisible by the size of that element. You're assuming that all of the elements are consecutive.

If you don't care about portability between platforms or compilers, then do this to get the data out:

    
General/WKBPoint p;
[data getBytes:&p range:General/NSMakeRange(0, sizeof(p))];


If you do care about portability, then you should both read and write the data element-by-element, instead of writing the entire struct in one go like you are now.

----
Some methods I would like to include:

    
@interface Geometry : General/NSObject {
General/NSData* object;
}

@implementation Geometry

-(unsigned int)geometryType;
{
return [object ... ]; //wkbType
}

-(double)x;
{
if ([self geometryType] == wkbPoint) {
return [object ...]; // x value for point
else ...
}

-(double)y;
{
if ([self geometryType] == wkbPoint) {
return [object ...]; // y value for point
else...
}

-(int)numPointsInLine;
{
if ([self geometryType] == wkbLineString) {
return [object ...]; // numPoints value for point
else...
}



The structs:

    
//Basic Type definitions  

//byte : 1 byte 
//uint32 : 32 bit unsigned integer (4 bytes) 
// double : double precision number (8 bytes) 

// Building Blocks : Point, General/LinearRing 

Point {
double x; 
double y; 
}; 

General/LinearRing  {
uint32 numPoints; 
Point points[numPoints]; 
};

enum wkbGeometryType { 
wkbPoint = 1, 
wkbLineString = 2, 
wkbPolygon = 3, 
wkbMultiPoint = 4, 
wkbMultiLineString = 5, 
wkbMultiPolygon = 6, 
wkbGeometryCollection = 7 
}; 

enum wkbByteOrder {
wkbXDR = 0, // Big Endian 
wkbNDR = 1 // Little Endian 
}; 

General/WKBPoint { 
byte byteOrder; 
uint32 wkbType; 
Point point; 
}; 

General/WKBLineString { 
byte byteOrder; 
uint32 wkbType; 
uint32 numPoints;   
Point points[numPoints]; 
}; 

General/WKBPolygon { 
byte byteOrder; 
uint32 wkbType; 
uint32 numRings; 
General/LinearRing rings[numRings]; 
}; 


Thanks for any help.

General/PhilipRiggs

----

The original discussion took place in a pre-Tiger environment. Nowadays, it might be very useful to try to solve this with General/CoreData (or something like it).