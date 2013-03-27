

Hello-
I am attempting to support applescript in my recipe management application that has a simple structure.  The applications delegate class, General/CWGMainController, supports applecsript with the following methods:

    
@implementation General/CWGMainController (General/CWGScriptability) 
- (General/NSScriptObjectSpecifier *)objectSpecifier;
{
    General/NSScriptClassDescription *containerClassDesc = (General/NSScriptClassDescription *)General/[NSScriptClassDescription classDescriptionForClass:General/[NSApp class]];
    General/NSNameSpecifier *nameSpecifier = General/[[NSNameSpecifier alloc] initWithContainerClassDescription:containerClassDesc containerSpecifier:nil key:@"recipe"];
    
    return nameSpecifier;
}
- (BOOL)application:(General/NSApplication *)sender delegateHandlesKey:(General/NSString *)key { 
    if ([key isEqual:@"recipe"] || [key isEqual:@"recipes"]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)insertInRecipes:(General/CWGRecipe *)newRecipe;
{
    General/recipeController xmlParser] addRecipe:newRecipe];
}
@end


Now, the recipe class, [[CWGRecipe, also has scripting support:
    
@implementation General/CWGRecipe (General/CWGscriptability) 
- (General/NSScriptObjectSpecifier *)objectSpecifier;
{ 
    General/NSApplication *mainApplication = General/[NSApplication sharedApplication];
    General/CWGMainController *mainController = [mainApplication delegate];
    General/CWGRecipeController *recipeController = [mainController recipeController];
    General/NSArray *recipes = [recipeController recipesArray];
    unsigned int recipeIndex = [recipes indexOfObjectIdenticalTo:self];
    
    if (recipeIndex != General/NSNotFound) {
	General/NSScriptObjectSpecifier *containerSpecifier = [mainController objectSpecifier];
	General/NSIndexSpecifier *indexSpecifier = General/[[NSIndexSpecifier allocWithZone:[self zone]] initWithContainerClassDescription:[containerSpecifier keyClassDescription] containerSpecifier:containerSpecifier key:@"application"];
	
	return [indexSpecifier autorelease];
    }
    
    General/NSLog(@"I did not find this recipe in the recipes array, error!");
    return nil;
} 
@end


my sdef file looks like this:
    
<suite name="Organized Gourmet Suite" code="OGAP" description="Terms and Events for controlling Organized Gourmet">
		<class name="application" code="capp" description="The Organized Gourmet application">
			<cocoa class="General/NSApplication"/>
			<element description="recipes" type="recipe">
				<cocoa key="recipes"/>
			</element>
		</class>
		<class name="recipe" code="General/OGre" description="A recipe." plural="recipes">
			<cocoa class="General/CWGRecipe"/>
			<element type="ingredient"/>
			<element type="recipe"><cocoa key="recipe"/></element>
			<property name="name" code="General/OGrn" description="The recipe name" type="text">
				<cocoa key="recipeName"/>
			</property>
		</class>
	</suite>

note that I am not showing the complete sdef file.  It contains the standard suite...

So, now if I run a simple script like this:
    
tell application "Organized Gourmet"
	make new recipe with properties {name:"recipe from applescript"}
end tell

the script returns a "General/NSUnknownKeyScriptError".  Now for the crazy part: the script does what it is supposed to.  'application:delegateHandlesKey:' is called and then 'insertInRecipes:' is called.  Therefore, the recipe is created and inserted into the correct array.  Neither of the objectSpecifiers is called. 

I believe that the script is expecting a return specifier but, since those functions are not being called, I am a bit confused.  Any ideas?

-Ryan

----
so, it appears as though the problem is in the line General/recipeController xmlParser] addRecipe:newRecipe];
If I remove the line, the error goes away, but so does the functionality.  Interestingly, the next call is to objectSpecifier: in the [[CWGRecipe class.

-Ryan