

[Topic]

Why does drawing strings seem so complicated?  All I want to do is to have a string variable I can change and draw in a view with whichever color, size, and font I would like.

I would like to do something like this...

    
General/NSMutableString *s;

s = General/[[NSMutableString alloc] init];
switch(condition)
{
     case 1:
         [s setString:@"@"];
         break;
     case 2:
         [s setString:@"#"];
         break;
...
}
set color of font to white;
set size of font 50;
[s drawInRect:r]; //where r is defined previously


Do I really have to create an General/NSDictionary to hold attibutes, or create an General/NSMutableAttributedString?  I tried creating an General/NSMutableAttributedString, but got bogged down in simply setting the string value.  There does not seem to be a method like setString that will allow you to set its value to a string like @"thisString".  The only thing I could think of was replaceCharactersInRange, but this doesn't work because the string starts empty and it gives me an error.  Is there no easier way?  This should be so easy,  --General/AlexanderD

----

General/NSAttributedString. -initWithString:. Then make a -setAttributedString: method on your class, whatever it is, and just replace the object with an altogether new one.

I don't like it either, but hey. -- General/RobRix

So, if I understand you correctly, if I have ten different strings that could potentially go into my final string, I create one General/NSMutableAttributedString and ten General/NSAttributedStrings that I initiallize using the initWithString: method.  Is this what you meant?  Is there no way to directly assign an General/NSString value to an General/NSMutableAttributedString without creating and initializing so many new variables? --General/AlexanderD

Why not use the General/NSString -drawAtPoint:withAttributes: method?  From what I am reading, it would be perfect. You can even pass nil for the attributes and have it draw the string in its default font, size, and color.  For custom fonts and sizes, use the General/NSAttributedString attribute constants in an General/NSDictionary. There's even a -sizeWithAttributes: method to get the size of the resulting string.  -- General/BrianMoore

See, there *are* smarter people than me on here :D -- General/RobRix

Thank you both to Rob and Brian.  I finally did create the additional General/NSDictionary object to hold the attributes that are then assigned to an General/NSMutableString.  What a convoluted way to do things!  It works, but I can't say it is elegant.  My criticism is not to those who have helped me, but to the API that seems to turn an otherwise simple operation into a many line solution.  Thanks again for the help. --General/AlexanderD