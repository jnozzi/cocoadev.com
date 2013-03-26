[[NSMaxRange]] is a foundation function which returns the end of the range passed to it. <code>[[NSMaxRange]](range)</code> is equivalent to <code>range.location + range.length</code>. For example, <code>[[NSMaxRange]]([[NSMakeRange]](7, 2))</code> will return <code>9</code>. It is located in [[NSRange]].h.

See [[NSRange]].