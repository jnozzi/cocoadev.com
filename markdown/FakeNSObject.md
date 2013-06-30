

----

Hi all,
I was trying to emulate General/NSObject's retain count in C++ (off topic? I hope not)... I soon came up with:

    
#define N_ALLOC_INIT(class) (class *) class::alloc ()->init ()

#define N_BASE_CLASS(name) \
 public: \
  static id alloc () { return new name; }

class General/NObject;
typedef General/NObject * id;

class General/NObject
{
public:

 virtual id init ();
 virtual void dealloc ();

 id retain ();
 void release ();

 unsigned int getRetainCount ();

private:

 unsigned int retainCount;
};

static inline void General/NSafeRelease (id object)
{ if (object != NULL) object->release (); }

......

General/NObject::init ()
{
 return this;
}

.....
(the obvious)
.........


The problem is (now) about init methods in subclasses:

    
id General/NASubclass::init ()
{
 objectA = N_ALLOC_INIT (General/NObjectA);
 objectB = N_ALLOC_INIT (General/NObjectB);
......
 objectF = N_ALLOC_INIT (General/NObjectF);

 return General/NObject::init ();
}

void General/NASubclass::dealloc ()
{
 ..........
 General/NSafeRelease (objectB);
 General/NSafeRelease (objectA);
 General/NObject::dealloc ();
}


If I wanted the object to automatically release itself inside method init if one of its own objects failed to initialize (being NULL) I would come up with **ugly** code in init methods:

i.e.:
    
id General/NASubclass::init ()
{
 .....
 objectF = ......

 if (objectA != NULL && objectB != ...................................)
  return General/NObject::init ();
 else
 {
  release ();
  return NULL;
 }
}


Any elegant solution ? Cocoa ppl should be used to them :)
Anyone? Thx

-- peacha

----

I tried to make a neater solution, but it failed. -- General/KritTer

----

I was able to see, but not to reply to it in time (my provider SUXXX)
Thanks anyway, even though I still have that init "doubt".....
What about your implementation of delete calling C's stdlib free: would it --always-- work for stack allocated objects (even though I'm not going to support them, just curiosity)?

-- peacha

I was trying to stop stack allocation, leaving only heap alloc, but that's impossible. I also couldn't implement deletion properly because the destructor for the object is called before operator delete, so the object was going squiffy even if it was retained. All in all, I decided to throw in the towel.

-- General/KritTer