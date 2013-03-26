How do you create an [[NSOutlineView]] with multiple roots?

- [[JohnDevor]]

Huh? ... Doesn't that, like, defy the laws of nature or something?

----

Why not just pretend that root siblings are root nodes?

----

Create multiple outline views, or one outline view with a popup at top to switch between roots, or use a [[NSBrowserView]]

----

When your data source methods <code>-outlineView:numberOfChildrenOfItem:</code> and <code>-outlineView:child:ofItem:</code> are called with <code>nil</code> as the item, that's the outline view asking you for the root objects.  Simply return the number of root objects to the first method, and the respective root objects themselves to the second method, and you'll be in business.  -- Bo

----

Ah, thanks Bo. - [[JohnDevor]]

----

I'm having trouble trying to keep the root objects straight. I tried an array, but I don't really understand how the calling part would work. Could anyone help me with this?

I've got some sketchy code like this:

<code>
static int i = 0; // this is probably a horrible way to cycle through the items...
- (id)outlineView:([[NSOutlineView]] '')ov child:(int)index ofItem:(id)item
{
    // is the parent non-nil?
    if (item)
        // Return the child
        return [item childAtIndex:index];
    else 
        // Else return the root
        i++;
        return [rootNodeArray objectAtIndex:i]; // this should cycle through my array... I think... probably not (and I see it only works once)
        
}
</code>

- [[JohnDevor]]

----

You don't need to cycle through your root array.  It will do that for you, i.e. for each root item you have, it will call <code>-outlineView:child:ofItem:</code> with the appropriate index.  So ditch the static variable and just return <code>[rootNodeArray objectAtIndex:index]</code>.  -- Bo

----

Ah! The frustration... Thanks again Bo.