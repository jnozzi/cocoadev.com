I have a class method to get and set a string which returns the string called "Long". eg:

<code>
-([[NSString]] '')type
{
     return type:
}

-(void)setType:([[NSString]] '')aType
{
   [ aType retain];
   [type release];
   type =aType;
}
</code>

The above is straight forward. I want to know how you call the string value in another method

<code>
-(double) myValue
{
   if (type = [whatever the type is "Long" ]{
     
      return 0;
    }else{
      return 1;
    }
}
</code>

If type is set to a string called "Long". What is the  objective -C code to give back the string value "long" in the [[MyValue]] method. 

Thanks DSG

----

It is not clear what you're asking, or what you'd like the code to do.  My guess is that you want <code>myValue</code> to return 0 if <code>type</code> is <code>@"Long"</code>, and 1 otherwise?

If so, the <code>myValue</code> method should look like this:

<code>
-(double) myValue
{
   if ([type isEqualToString:@"Long"]) {     
      return 0;
    }else{
      return 1;
    }
}

</code>

Thanks! works like a charm!