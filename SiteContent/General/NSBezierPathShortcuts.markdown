

class methods:

    

+(void)fillRect:(General/NSRect)rect
+(void)strokeRect:(General/NSRect)rect
+(void)clipRect:(General/NSRect)rect
+(void)strokeLineFromPoint:(General/NSPoint)point1 toPoint:(General/NSPoint)point2



if speed is critical there here are some C functions you can call directly:

    

void General/NSRectFill(General/NSRect rect);
void General/NSRectFillList(const General/NSRect *rects, int count);
void General/NSRectFillListWithGrays(const General/NSRect *rects, const float *grays, int num);
void General/NSRectFillListWithColors(const General/NSRect *rects, General/NSColor **colors, int num);

//drawing outlines

void General/NSFrameRect(General/NSRect rect);
void General/NSFrameRectWithWidth(General/NSRect rect, float frameWidth);
void General/NSFrameRectWithWidthUsingOperation(General/NSRect rect, float frameWidth, General/NSCompositingOperation op);

