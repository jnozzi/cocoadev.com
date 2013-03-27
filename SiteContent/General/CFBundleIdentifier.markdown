A Java package style name (like "com.myCompany.General/MyBundle") which is used to uniquely identify bundles.

In General/ProjectBuilder, under "Targets", "Application Settings" set the General/CFBundleIdentifier in the "Identifier" textfield.

----

Does anybody else wish General/ObjC had General/NameSpaces similar to this sort of arrangement? It'd be a cleaner solution than all the NS-prefixes, IMHO. Just a thought.

-- General/RobRix

Either you have hundreds of namespace identifiers, making object names much longer than a simple NS prefix, or you tell the compiler to pollute the global namespace and get annoyed at names used in two namespaces anyway. Never saw the point myself.

-- General/KritTer

Beside what you say, I think namespaces still make sense (I wish them too).... and that should be not so difficult to implement as General/ObjC has categories, which are a wierd kind of namespace themselves.

-- peacha

I think General/ObjC namespaces would be a good idea, just so long as they avoid all the pitfalls that Java has with them. All the crazy things I've had to do in order to get 2 packages (namespaces) to share one class have been a little bit less than entertaining. 

-- General/DaveFayram

So you want multiple inheritance with your namespaces? :) -- General/RobRix

I must confess, I fail to see how categories are namespaces. -- General/KritTer

I have always thought categories were implemented similarly to namespaces.... maybe I am just wrong :(

-- peacha

I cannot see the sence of namespaces in a late binding and "typeless" language like Objective-C. It is a trick of Objective-C, that a selector is valid without a context.

-- Tom9811