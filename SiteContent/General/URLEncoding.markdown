How can I encode an [[NSString]] in the correct form to send it as an argument in an HTTP POST operation?

The following Core Foundation function works just fine:

http://developer.apple.com/documentation/[[CoreFoundation]]/Reference/[[CFURLRef]]/Reference/function_group_3.html#//apple_ref/c/func/[[CFURLCreateStringByAddingPercentEscapes]]

for example:
<code>
[[NSString]] ''myMessage = @"Some Text With+Some&Characters+that would get lost";
[[NSString]] ''legalCharactersThatIWantEncodedAnyway = @"+&";
[[NSString]] ''encodedMessage = [[CFURLCreateStringByAddingPercentEscapes]] (0, myMessage, 0, legalCharactersThatIWantEncodedAnyway, kCFStringEncodingUTF8);
</code>

----

Or use [[NSString]]'s <code>stringByAddingPercentEscapesUsingEncoding:</code> method (10.3 or later).