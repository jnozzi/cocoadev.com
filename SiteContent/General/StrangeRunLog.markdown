I'm hoping someone can help me identify these lines in my run log.

<code>
[Session started at 2004-12-17 23:57:34 -0500.]
[[AbstractCMPluginFactory]]
[[AllocAbstractCMPluginType]]
[[AbstractCMPluginQueryInterface]]
[[AbstractCMPluginAddRef]]
[[AbstractCMPluginRelease]]
icWordCM->[[CMPluginExamineContext]]
icWordCM->[[CMPluginPostMenuCleanup]]
icWordCM->[[CMPluginExamineContext]]
icWordCM->[[CMPluginPostMenuCleanup]]
icWordCM->[[CMPluginExamineContext]]
icWordCM->[[CMPluginPostMenuCleanup]]
</code>

This has been appearing for the last several days, possibly a week, in my run log as my project is left open. I can't make sense of what google is trying to tell me so I'm not sure if this is good or bad. Can anybody identify the source of these messages? This is more an [[XCode]] question than a Cocoa question. I apologize for the off-topic page.

----
Is anything actually going wrong in your program? To me, these look like trace calls that are left over from when Apple was debugging the [[CMPlugin]] framework (most likely the "contextual menu" framework used by [[AppleScript]]). If there's no problem, it is probably OK to ignore these messages...unless someone smarter than me says otherwise. --[[JediKnil]]

''No, no bugs and this just happens during idle time - my project isn't even running when I notice these. I never actually see them appear, though - I just notice they're there and have never appeared during my own project's run time. Question is, why are they showing up in ''my'' debugger?''

----

The contextual menu underpinnings are linked into any GUI app, so I would expect this output to show up in any frontmost app at the time whatever this indicates is happening.