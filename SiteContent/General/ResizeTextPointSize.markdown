I wanted my text to scale with my General/NSTextView, so I tried to pull it off with the following methods. I came fairly close, and I think the resulting issues may be with the General/NSScrollView. If anyone has any suggestions on how to improve or increase the accuracy, it would be very much apreciated. 

Updated Oct. 12, 10:51PM -- Major speed boost

The more I try, the more ways I approach this, the more miserable I become. I don't think it is possible. Ill have to find another way to get similiar results. Chsnging monitor resolution wouldnt work either.

    
-(void)scaleText:(General/NSTextView *)txtView width:(float)width height:(float)height
{

int count = General/txtView string] length];

int i;

[[NSMutableDictionary *at;

General/NSSize original;

General/NSSize desired;

General/NSRange range;

at = General/[[NSMutableDictionary alloc] init];

for (i=0; i < count; i++)
    {
        
   [at setDictionary: General/txtView textStorage] attributesAtIndex:i effectiveRange:&range;  
         
       original = General/[txtView textStorage] attributedSubstringFromRange:range] size];
       
        desired = [[NSMakeSize(original.width*width,original.height*height);

General/txtView textStorage] beginEditing];

[[txtView textStorage] addAttribute:@"[[NSFont" value:General/[[NSFontManager sharedFontManager] convertFont: [at objectForKey:@"General/NSFont"] toSize: [self pointSizeForString:General/txtView textStorage] attributedSubstringFromRange:range] convertToSize:desired] ] range:range];

[[txtView textStorage] endEditing];

i = range.location + range.length;
    }

}

-(float)pointSizeForString:([[NSMutableAttributedString *)string convertToSize:(General/NSSize)newSize
{
General/NSSize originalSize;

General/NSSize testSize;

General/NSMutableDictionary *at;

at = General/[[NSMutableDictionary alloc] init];

 [at setDictionary: [string attributesAtIndex:0 effectiveRange:nil]];        

float originalPoint =General/at objectForKey:@"[[NSFont"] pointSize];

float xFactor;

float yFactor;

originalSize = [string size];

[string addAttribute:@"General/NSFont" value:General/[[NSFontManager sharedFontManager] convertFont: [at objectForKey:@"General/NSFont"] toSize: originalPoint+1 ] range:General/NSMakeRange(0,[string length])];

testSize = General/string string] sizeWithAttributes:[string attributesAtIndex:0 effectiveRange:nil;
 
xFactor = testSize.width - originalSize.width;

yFactor = testSize.height - originalSize.height;

[at release];

return (newSize.height/yFactor)*yFactor;

}

-- General/GormanChristian