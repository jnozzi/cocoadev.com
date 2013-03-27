
Hi. I have one question about Cocoa and Core Data. 

How can I sum numbers in General/NSTableView and show them in General/NSTextFiled? Like in this pic:

http://shrani.si/files/picture2qc7m.png
----

Assuming you want a bindings answer, the key path should look like `dataSource.arrayName.@sum`.

More information at http://developer.apple.com/documentation/Cocoa/Conceptual/General/KeyValueCoding/Concepts/General/ArrayOperators.html

-G

----

This post begs for a General/HowToAskQuestions link, but I guess somebody already answered.