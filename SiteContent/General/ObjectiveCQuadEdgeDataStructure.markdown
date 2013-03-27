

Hi all!

I am working to implement in Objective C a class General/QuadEdge based on Guibas and Stolfi's data structure for a GIS spatial data class. I have some design questions. I hope some people can help me in figuring these out.

I have found 3 implementations. Here are the abreiviated headers:

    -C : http://www.dcc.unicamp.br/~stolfi/EXPORT/software/c/libquad/

    
typedef int edge_ref;

typedef struct {
    edge_ref next[4]; //Stores General/ONext, General/SymDNext, General/RotRNext, General/TorLNext
    void *data[4];    //Stores origin, destination, General/LeftFace, General/RightFace
    unsigned mark;
  } edge_struct;

/* Edge orientation operators: */

#define ROT(e) (((e)&0xfffffffcu)+(((e)+1)&3u))
#define SYM(e) (((e)&0xfffffffcu)+(((e)+2)&3u))
#define TOR(e) (((e)&0xfffffffcu)+(((e)+3)&3u))


    -C++ : http://www-2.cs.cmu.edu/afs/andrew/scs/cs/15-463/pub/src/a2/quadedge.html

    
class General/QuadEdge;
class Edge {
   friend General/QuadEdge;
   private:
      int num;
      Edge *next;
      Point2d *data;
};

class General/QuadEdge {
   private:
      Edge e[4];
};

inline Edge* Edge::Rot()
   //Return the dual of the current edge
   {
      return (num < 3) ? this + 1 : this - 3;
   }

inline Edge* Edge::Sym()
   {
      return (num < 2) ? this + 2 : this -2;
   }

inline Edge* Edge::invRot()
   {
      return (num > 0) ? this - 1 : this + 3;
   }


    -Delphi : "The Quad-Arc Data Structure" by C Gold

    
General/TQuad = class
   N : General/TQuad;
   R : General/TQuad;
   V : General/TPoint;
   Index : Integer;
end;

function General/TQuad.Rot : General/TQuad;
begin
   Sym := Self.R;
end;

function General/TQuad.Sym : General/TQuad;
begin
   Sym := Self.R.R;
end;

function General/TQuad.Inv : General/TQuad;
begin
   Sym := Self.R.R.R;
end;



The 3 use different approaches and I am trying to decide which approach to use to make a General/ObjectiveC class. I would like my General/QuadEdge class to have the following variables:

General/NSString* edgeId;   Unique ID for each edge.
General/NSString* lineId;   Unique ID for each line composed of edges.
id vertex;   Refers to either a point or a face.

I have tried it using the following header based on the Delphi implementation:

    
@interface General/GISEdge : General/NSObject {
    General/NSString* lineId;
    General/NSString* edgeId;
    General/GISEdge* next;
    General/GISEdge* rotate;
    id vertex;
    BOOL internal;  // Edge is inside the hull of the TIN (1) or on the edge is part of the outer hull (0)
}


But this implementation seems to be way too bloated because each edge has 4 General/GISEdge structures. If a Voronoi diagram of any significant size uses this structure, it will be way too big, won't it?

So back to the drawing board. I looked at the C++ implementation and started:

    
typedef struct edge Edge;
struct edge {
    int num;
    Edge* next;
    id data;
};

@interface General/GISEdge : General/NSObject {
    General/NSString* lineId;
    General/NSString* edgeId;
    Edge e[4];
}


But if next points to edge[2] of General/QuadEdge "PR102", how can I get the edgeId for edge[2]? This seems too complicated. Yet I like the fact that the edgeId, lineId, and interior variables are only stored once and are associated where they should be, in the General/QuadEdge and not in the Edge. I could also add new items to the General/QuadEdge later without a 4x increase in size for every edge.

Another thought that has crossed my mind is to create a General/GISLayer class that hides individual edges. This would be more like the Symbol-Table Abstract Data Types I learned in Sedgewick's Algorithms books. 

This data structure is more advanced than anything I have done before. Any thoughts or suggestions are appreciated!

General/PhilipRiggs

----

If it is already available as a C library then why do you want to go and re-implement it in Objective-C? I would simply write a couple of helper classes to wrap the entire library. General/RbrtPntn.