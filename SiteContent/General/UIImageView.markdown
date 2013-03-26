



%%BEGINCODESTYLE%%

//create background view
	
[[UIImageView]] ''background = [[[[[UIImageView]] alloc] initWithFrame:[[CGRectMake]](0.0f, 0.0f, 320.0f, 480.0f)] autorelease];

[background setImage:[[[UIImage]] imageAtPath:[[[[NSBundle]] mainBundle] 
             pathForResource:@"myGreatImage"
             ofType:@"png" 
             inDirectory:@"/"]]];

@property (nonatomic, retain) image <- image is already retained!

%%ENDCODESTYLE%%