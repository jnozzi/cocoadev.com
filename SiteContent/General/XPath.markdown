[[XPath]] is a sort of query language for XML. You can access any node within a document with a simple expression. The shorthand form looks much like a UNIX file path.


Consider this simple XML-document
<code>
<persons>
    <person id="811201">
        <name>Theo</name>
        <surname>Hultberg</surname>
     </person>
</persons>
</code>

%%BEGINCODESTYLE%%/persons/person[1]%%ENDCODESTYLE%%
retrieves the first person-element that is a child of the root node ("/" is the root node).

%%BEGINCODESTYLE%%/persons/person[@id="811201"]%%ENDCODESTYLE%%
retrieves all person-elements that are children of the root element and has an attribute ("@<name>") with the name "id" that has the value "811201".

%%BEGINCODESTYLE%%//name%%ENDCODESTYLE%%
retrieves all name-elements in the document

%%BEGINCODESTYLE%%//person/@id%%ENDCODESTYLE%%
retrieves all id attributes of person-elements in the document.

%%BEGINCODESTYLE%%/persons//name%%ENDCODESTYLE%%
retrieves all name-elements in the document that are descendants of person-elements (that are children of the root node)

Double-quotes and single-quotes are equivalent.

See http://www.w3.org/TR/xpath for more info.

-- [[TheoHultberg]]/Iconara

----

[[IconaraDOM]] has basic [[XPath]]-support for working with XML-documents in Cocoa. [[XMLTree]] has some [[XPath]]-support, too.

Tiger introduces the [[NSXml]] classes, which include [[XPath]] support.