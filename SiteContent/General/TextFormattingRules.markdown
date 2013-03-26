Your text will appear exactly as you enter it.  HTML tags are not processed. To include double-percents, precede each one with double-backslash, like so: \\\\%\\\\%

Any fully-qualified [[URLs]] you enter into the text will automatically become links.  If the URL is that of a GIF or JPEG image file, that image will be inserted into the page, rather than a link. (''Note the URL parser doesn't understand fragment identifiers (#).'')

[[WordsJammedTogether]] will become links to new or existing pages on this site.

Some custom formatting keywords are available.  To use them, just enter them into your text:



* '''\\%\\%BEGINLIST\\%\\%''' will open a bulleted list
* '''\\%\\%ITEM\\%\\%''' adds an item to an opened bulleted list
* '''\\%\\%ENDLIST\\%\\%''' will end a bulleted list


* '''\\%\\%BEGINBOLD\\%\\%''' begins a bold section of text
* '''\\%\\%ENDBOLD\\%\\%''' ends a bold section of text
* Paired triple apostrophes ('''<code></code>'<code></code>'<code></code>'...'<code></code>'<code></code>'<code></code>''') can also bold a section of text on a single line


* '''\\%\\%BEGINITALIC\\%\\%''' begins an italicized section of text
* '''\\%\\%ENDITALIC\\%\\%''' ends a italicized section of text
* Paired double apostrophes ('''<code></code>'<code></code>'...'<code></code>'<code></code>''') can also italicize a section of text on a single line


* '''\\%\\%BEGINCODE\\%\\%''' begins a code block (displayed inside its own inline frame with scrollbars)
* '''\\%\\%ENDCODE\\%\\%''' ends a code block (displayed inside its own inline frame with scrollbars)


Note that undefined [[WordsJammedTogether]] are not marked with a ? in code blocks.


* '''\\%\\%BEGINCODESTYLE\\%\\%''' begins monospaced text
* '''\\%\\%ENDCODESTYLE\\%\\%''' ends monospaced text
* Paired triple-brackets ('''{<nowiki/>{{...}}<nowiki/>}''') can also create a monospace section of text on a single line





* '''\\%\\%LINE\\%\\%''' adds a horizontal line to the text.
* '''\\%\\%REPLY\\%\\%''' starts a new post in a conversation, ended by the next \\%\\%REPLY\\%\\% or \\%\\%LINE\\%\\% (Please discuss this new feature on [[SignArguments]])



You can prevent [[WordsJammedTogether]] from being made into Wiki links by using six single quotes after the first letter of a word: '''E'<code></code>'<code></code>'<code></code>'<code></code>'<code></code>'scapeWordsJammedTogether''' becomes E<nowiki/>scapeWordsJammedTogether

----(Actually, it needs to be after the initial capital letters; e.g., NST'<code></code>'<code></code>'<code></code>'<code></code>'<code></code>'ableView, instead of N'<code></code>'<code></code>'<code></code>'<code></code>'<code></code>'[[STableView]])----

However, the use of [[WordsJammedTogether]] is one of the fundamental principles of the [[WikiWikiWeb]], so unless you have a good reason (like you're illustrating how [[WordsJammedTogether]] work), you shouldn't try to escape them. The main use for this is so that plurals are properly [[WikiLink]]<nowiki/>ed. For example, we do not need separate entries for [[NSTableView]] and NST<nowiki/>ableViews, so stick the six apostrophes before the last letter and it's excluded from the word (e.g. NST<nowiki/>ableView'<code></code>'<code></code>'<code></code>'<code></code>'<code></code>'s becomes [[NSTableView]]<nowiki/>s). You can even use this trick to talk about [[NSTableView]]<nowiki/>'s [[SuperClass]] and it'll get the ''<code></code>'s'' right.

See also:

*[[HowToUseTopics]]
*[[HowToAddPicturesToThisWebsite]]