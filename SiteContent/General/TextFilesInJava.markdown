I am at a loss to figure out how to read a text file into a String in Java. I am new to Java, so maybe I am just really missing something in the documentation. Also, I was wondering if anybody has step by step instructions on how to get the Java Bridge working in Cocoa (using both Objective-C and Java classes in the same project).

-- [[JamesGlenlake]]

----

<code>

String readFile( String filePath ) {
	[[StringBuffer]] fileContents = new [[StringBuffer]]();

	try {
		[[BufferedReader]] reader = new [[BufferedReader]](
			new [[FileReader]](filePath)
		);

		String line;
	
		while ( (line = reader.readLine()) != null ) {
			fileContents.append(line);
		}
	} catch ( [[IOException]] ioe ) {
		// handle the exception properly in the real application
		return null;
	} finally {
		reader.close();
	}

	return fileContents.toString();
}
</code>

I suggest looking up the documentation for <code>[[FileReader]]</code>, <code>[[BufferedReader]]</code> and look at the Java Tutorial on http://java.sun.com

-- [[TheoHultberg]]/Iconara

----

The documentation for [[BufferedReader]] says that it does not include the line terminator in readLine(). Should I append a <code>"\n"</code> with each line as well?

-- [[JamesGlenlake]]

----

If you need it, yes.