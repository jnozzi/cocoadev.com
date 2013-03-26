

Part of the iPhone [[UIKit]] framework. Subclass of [[UIView]]. (Unlike in [[AppKit]]..)

Abstract (?) superclass of whatever you'd ever want to display in a [[UITable]]. Useful subclasses include:


*[[UIImageAndTextTableCell]]


Those little right arrows? They're 'disclosures'. Use like:

%%BEGINCODESTYLE%%    [cell setDisclosureStyle: 2];%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%    [cell setShowDisclosure: YES];%%ENDCODESTYLE%%

Where style 1 (default) is the round blue arrow and 2 is the basic grey arrow.

Row Selected Style:setShowSelection

%%BEGINCODESTYLE%%    [cell setShowSelection: NO];%%ENDCODESTYLE%%

Setting setShowSelection: NO removes the text Highlite. YES is the default state.

Row Selected Style:setSelectionStyle

%%BEGINCODESTYLE%%    [cell setSelectionStyle: 1];%%ENDCODESTYLE%%

Setting setSelectionStyle: 1 changes the selection color of the row to red
(0 || 4+ == blue, 1 == red, 2 == grey, 3 == green)