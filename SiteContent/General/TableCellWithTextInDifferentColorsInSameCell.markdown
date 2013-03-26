

Is it possible to have text in table cells with different colors? I was hoping that [[NSTableView]] understood some kind of markup that would allow me to define e.g. colors in the text string.

----

[[NSCell]] has a <code>setAttributedStringValue:</code> method that takes an [[NSAttributedString]] object.