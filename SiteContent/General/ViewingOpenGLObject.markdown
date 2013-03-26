I read this article about [[GlobalVariablesInCocoa]]. I try to make a global variable to share the [[NSMutableArray]] in the new nib i created at runtime. I create 3 classes to achieve this:

<code>
// globalValues.h

#import <Cocoa/Cocoa.h>

extern [[NSMutableArray]] ''vertexOri, ''vertexTemp;

@interface globalValues : [[NSObject]] {}
@end
// end of globalValues.h

// globalValues.m
#import "globalValues.h"

[[NSMutableArray]] ''vertexOri;
[[NSMutableArray]] ''vertexTemp;

@implementation globalValues
@end
// end of globalValues.m
</code>

i use this globalValues class in two different class 

<code>
// [[QuiXplorer]].h
#import <Cocoa/Cocoa.h>
#import "vertex.h"
#import "glViewerController.h"

@interface [[QuiXplorerController]] : [[NSObject]]
{
	[[IBOutlet]] [[NSPanel]] ''mainMenu;
	[[IBOutlet]] [[NSButton]] ''loadButton;
	[[IBOutlet]] [[NSButton]] ''saveButton;
	[[IBOutlet]] [[NSButton]] ''closeButton;
	
	glViewerController ''doc;
}

- ([[IBAction]])[[LoadFile]]:(id)sender;
@end
// end of [[QuiXplorer]].h

// [[QuiXplorer]].m
#import "[[QuiXplorerController]].h"
#import "globalValues.h"

@implementation [[QuiXplorerController]]
- ([[IBAction]])[[LoadFile]]:(id)sender
{
	[[NSLog]](@"Load File");
	
	[[NSString]] ''objFile;
	if (objFile = [[[NSString]] stringWithContentsOfFile:[self getUserFileName:0]])
	{
		// Setting the buttons
		[loadButton setEnabled:NO];
		[saveButton setEnabled:YES];
		[closeButton setEnabled:YES];
		
		// Extracting vertex from file;
		[[NSScanner]] ''scanner;
		[[NSCharacterSet]] ''newLineCharacterSet = [[[NSCharacterSet]] characterSetWithCharactersInString:@"\r\n"];
		
		float x,y,z;
		int jmhTitik = 0;
		int jmhVn = 0;
		int jmhF = 0;
		vertex ''ttk = [[vertex alloc] init];
		vertexOri = [[[[NSMutableArray]] alloc] init];		

		scanner = [[[NSScanner]] scannerWithString:objFile];	
		while ([scanner isAtEnd] == NO)
		{
			// Scanning Vektor
			if ([scanner scanString:@"v " intoString:nil])
			{
				[scanner scanFloat:&x];
				[scanner scanFloat:&y];
				[scanner scanFloat:&z];
				
				[ttk setVertexX:x setVertexY:y setVertexZ:z];

				[vertexOri addObject:ttk];
				jmhTitik++;
			} 
			// Scanning vektor normal
			else if ([scanner scanString:@"vn " intoString:nil])
			{
				[scanner scanFloat:&x];
				[scanner scanFloat:&y];
				[scanner scanFloat:&z];
				jmhVn++;
			}
			// Scanning f
			else if ([scanner scanString:@"f " intoString:nil])
			{
				[scanner scanInt:nil];
				[scanner scanInt:nil];
				[scanner scanInt:nil];
				jmhF++;
			} 
			// Scanning for newline
			else
			{
				[scanner scanUpToCharactersFromSet:newLineCharacterSet intoString:nil];
			}
		}
					
		[[NSLog]](@"ttk terakhir : \n x=%f \n y=%f \n z=%f",[[vertexOri objectAtIndex:jmhTitik-1] getX],[[vertexOri objectAtIndex:jmhTitik-1] getY],[[vertexOri objectAtIndex:jmhTitik-1] getZ]);
		
		// releasing variables from memory
		[ttk dealloc];		

		[[[NSBundle]] loadNibNamed:@"glViewer" owner:self];
	}
}
@end
// end of [[QuiXplorer]].m
</code>

and the last class is where i call the new nib
<code>
// glViewerController.h
#import <Cocoa/Cocoa.h>
#import "glViewerView.h"
#import "vertex.h"

@interface glViewerController : [[NSResponder]]
{
	[[IBOutlet]] id glWindow;
	glViewerView ''glView;
}

- (void)awakeFromNib;
// end of glViewerController.h

// glViewerController.m
- (void)awakeFromNib
{
	[ [[NSApp]] setDelegate:self ];   // We want delegate notifications
	[ glWindow makeFirstResponder:self ];
	glView = [ [ glViewerView alloc ] init];
	if ( glView != nil )
	{
		[ glWindow setContentView:glView ];
		[ glWindow makeKeyAndOrderFront:self ];
		
		vertex ''titik = [[vertex alloc] init];

		int jmhTtk = [vertexOri count];
		[[NSLog]](@"jmh titik glviewer controller = %d",jmhTtk);
		int ul = 0;

		for (ul = 0 ; ul < jmhTtk ; ul++)
		{
			titik = [vertexOri objectAtIndex:1];
			[[NSLog]](@"x = %f , y = %f , z = %f",[titik getX],[titik getY],[titik getZ]);
		}
	}
	else
	{
		[[NSLog]](@"Failed to create Window");
	}
}
// end of glViewerController.m
</code>

then when i run the code and do the action here is what i get in the [[NSLog]] :

<code>
2005-11-14 18:06:58.089 3D [[QuiXplorer]][3527] jmh titik glviewer controller = 10
2005-11-14 18:06:58.108 3D [[QuiXplorer]][3527] ''''' -[[[NSCheapMutableString]] getX]: selector not recognized [self = 0x3dbe60]
2005-11-14 18:06:58.124 3D [[QuiXplorer]][3527] ''''' -[[[NSCheapMutableString]] getX]: selector not recognized [self = 0x3dbe60]
</code>

where do i do wrong? thanks - [[JuliusJuarsa]]

----

The error message looks pretty self-explanatory: you're calling getX on a string. Not sure why.

You should NOT allocate only one vertex and repeatedly call <code>-setVertexX:setVertexY:setVertexZ:</code> on it. Try using:

<code>
// Scanning Vektor
if ([scanner scanString:@"v " intoString:nil])
{
   vertex ''ttk = [[vertex alloc] init];

   [scanner scanFloat:&x];
   [scanner scanFloat:&y];
   [scanner scanFloat:&z];
   [ttk setVertexX:x setVertexY:y setVertexZ:z];

   [vertexOri addObject:ttk];
   [ttk release];
   jmhTitik++;
} 
</code>

You probably want to capitalize the class <code>vertex</code>, too: use <code>Vertex</code> to be clearer. Ditto for <code>globalValues</code>.

I also recommend you move <code>vertexOri</code> ''out'' of your global variables. Make it a class member of [[QuiXplorerController]]. Don't use globals unless you're sure.

The problem is the line <code>[ttk dealloc]</code>. Go read [[MemoryManagement]]. Don't ever call <code>dealloc</code> directly: use <code>release</code>. -- [[KritTer]]

One more thing, style-wise. Instead of providing separate <code>-init</code> and <code>-setVertexX:setVertexY:setVertexZ:</code> methods - the former of which can do nothing sensible - try providing one combined method, <code>-initWithVertexX:setVertexY:setVertexZ:</code>. If you want a mutable vertex class, <code>[[MutableVertex]]</code>, you can then make it a [[SubClass]] of <code>Vertex</code>. -- [[KritTer]]

----

The reason i use global variable on [[VertexOri]] is that i want to use the [[NSMutableArray]] value on 2 different class. is there any other way of doing this than using the extern keyword??
to [[KritTer]] : i replace the <code>[ttk dealloc]</code> with <code>[ttk release]</code> like your suggestion and it's working. but my question is what is the different? i am confused with the memory management stuff ^^

in cocoa, can i do 2 different initialization but with different parameter?? 
ex : <code>-initWithVertexX:setVertexY:setVertexZ:</code>
      <code>-initWithVertexX:getVertexY:getVertexZ:</code>

correct me if i'm wrong. so in [[NSMutableArray]], if I addObject: in the array (example Vertex) at index 1, when i retreive the object at index 1 i would get the same Vertex? - [[JuliusJuarsa]]

----
The syntax is slightly off; it would be <code>-initWithVertexX:vertexY:vertexZ:</code>. Then you have accessors <code>-vertexX</code>, <code>-vertexY</code>, <code>-vertexZ</code>, and <code>-getVertexX:vertexY:vertexZ:</code>. The mutators would be <code>-setVertexX:</code>, <code>-setVertexY:</code>, <code>-setVertexZ:</code>, and <code>-setVertexX:vertexY:vertexZ:</code>. This is pretty much the standard format for a multiple-variable access: individual accessors and mutators, with a single init method. Also, you should only have one verb per method. <code>initWith...</code> means you are using the nouns following "with" to initialize the object. <code>set...</code> is similar. <code>get...</code> means you are returning by passed-in references (pointers). No verb means you are returning by value. For more information, check out the great naming stuff on http://www.cocoadevcentral.com/articles/000082.php --[[JediKnil]]

----
Thanks, Jedi, that was a copy-n-paste error on my part
----

If you want to access the array of vectors from another object, you need to find a way to give that object access to the [[QuiXplorerController]]. If you're setting this up from [[InterfaceBuilder]], you can add an outlet to the second class and link it to the controller. Alternatively, if the second object's method is called from the controller, the controller can pass the array of vectors as a parameter.

Retain/release are balanced pairs. When you pass an object to an array, the array retains it. When you remove an object from an array (or the array is deallocated after its final release), it releases it. When you create the object, you are also implicitly retaining it once, so when you've added it to the array, you should call <code>release</code> on it if you no longer need to access it. When the object has been released as many times as it was retained, it will <code>dealloc</code> itself, because (unless you've coded things incorrectly) it knows nobody wants it anymore.

Arrays store the object passed to them, '''not copies'''. If you call <code>dealloc</code> directly, you bypass this [[MemoryManagement]] system, and delete the object held in the array. When you access the array again later, the memory the object used to take up will quite likely have been reused. In your code, it had been taken up by a string, hence the strange error. As you said, when you call <code>addObject:</code> then later retrieve the object at that location, you get '''the same Vertex''' that you put in. -- [[KritTer]]