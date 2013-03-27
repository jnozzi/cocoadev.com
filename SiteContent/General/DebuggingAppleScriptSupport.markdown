

You can turn on General/CocoaScripting debugging with the     General/NSScriptingDebugLogLevel preference. This preference can be set for a single app or for the entire system:
    
defaults write General/NSGlobalDomain General/NSScriptingDebugLogLevel 1
defaults write com.myApp General/NSScriptingDebugLogLevel 1

defaults delete General/NSGlobalDomain General/NSScriptingDebugLogLevel
defaults delete com.myApp General/NSScriptingDebugLogLevel


You can turn on the General/AppleScript engine's event tracking by setting environment variables. You can do this on a per-executable basis by double-clicking the icon for the executable.
    
set General/AEDebug=1
set General/AEDebugSends=1
set General/AEDebugReceives=1

unset General/AEDebug
unset General/AEDebugSends
unset General/AEDebugReceives


You can examine **General/NSScriptSuiteRegistry**, **General/NSScriptClassDescription**, and **General/NSScriptCommandDescription** to make sure your classes and commands were read properly from the the *.script**' files.