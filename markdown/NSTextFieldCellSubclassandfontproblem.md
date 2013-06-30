Describe General/NSTextFieldCellSubclassandfontproblem here.



Im developing a font managment software in cocoa, and im having problems with the preview of the fonts.

For the preview Im using a General/NSTableView, with a subclass of General/NSTextFieldCell. In this subclass I draw the name of the font and a text example with the font.

The problem is after I preview the font in a cell, i can�t deactivate it. It seems like the General/NSFont object used in the cell is not released and dont allow to deactivate the font.

The General/NSTextFieldCell Subclass code:

    

@implementation General/TextPreviewCell

- (void)dealloc {
	General/NSLog(@"deallocing CELL");
	[datosColumna release];
	datosColumna = nil;
        [super dealloc];
}//end method

- (void)drawWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView {
        
		General/NSRect	rectanguloCabecera;
		General/NSDivideRect(cellFrame, &rectanguloCabecera, &cellFrame, 14, General/NSMinYEdge);
		
		if (sStripeColor == nil) sStripeColor = General/[[NSColor colorWithCalibratedRed:STRIPE_RED green:STRIPE_GREEN blue:STRIPE_BLUE alpha:1.0] retain];
		[sStripeColor set];
		rectanguloCabecera.size.width = (rectanguloCabecera.size.width + 8);
		rectanguloCabecera.origin.x = (rectanguloCabecera.origin.x - 1);
		rectanguloCabecera.origin.y = (rectanguloCabecera.origin.y - 2);
   		General/NSRectFill(rectanguloCabecera);
		
		General/NSPoint p;
		p.x = rectanguloCabecera.origin.x + 3;
		p.y = rectanguloCabecera.origin.y + 1;
		
		int columna = [controlView rowAtPoint:p];
		General/NSString *nombreFuente = General/controlView dataSource] getDataRow:columna];
		
		[[NSFont *fuenteCabecera = General/[[NSFont fontWithName:@"General/LucidaGrande" size:10] autorelease];
		General/NSMutableDictionary *estilo = General/[NSMutableDictionary dictionary]; [estilo setObject:fuenteCabecera forKey:General/NSFontAttributeName];
		[nombreFuente drawAtPoint:p withAttributes:estilo];
		
		if (tamanoFuente == 0) [self setTamanoFuente:8];
		if (textoCelda == nil) [self setTexto:@"sin asignar"];
		
		General/NSFont *fuente = General/[[NSFont fontWithName:nombreFuente size:tamanoFuente] autorelease];
		
		[self setFuente:fuente];
		[self setFont:font];
		[self setStringValue:textoCelda];
		[self setLineBreakMode:General/NSLineBreakByTruncatingTail];
		[self setWraps:NO];
	
		[super drawWithFrame:cellFrame inView:controlView];

}



For activating the font Im using: 

    
err = General/ATSFontActivateFromFileSpecification(&fspec, kATSFontContextGlobal, kATSFontFormatUnspecified, NULL, kATSOptionFlagsDefault, &id_fuente);


And for deactivating: 

    
General/ATSFontDeactivate(id_fuente, NULL, kATSOptionFlagsDefault);


If I activate the font without preview in the table, works fine, activating and deactivating the font.

I note that if I put a General/NSLog in the dealloc method of my General/NSTextFieldCell subclass, it sends the log when i click in the row or when i move the scrolls, but it not log when I 
reload data in the data source of the General/NSTableView, but the rows are deleted and the new data is displayed. �are those cells deallocated?.

Sorry for my English and thanks.

C�sar Escolar