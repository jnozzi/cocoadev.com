

I have a General/NSTextField and I set its attributedStringValue.  When the view is first displayed, the text of the General/NSTextField looks as it should.  But as soon as I tab into the General/NSTextField, the text attributes are lost and they stay lost even after ending the edit.  What am I doing wrong?

----

General/PostYourCode is one way we advise you on General/HowToAskQuestions.

----

Look up <code>-General/[NSCell setAllowsEditingTextAttributes:]</code>.