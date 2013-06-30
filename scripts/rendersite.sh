# Cleaning up
echo "Cleaning up working files"
rm replacements.sed
rm pages.index
rm pages.paths
rm pages.categorieswithextension

# Pull markdown from Github
echo "Pulling content from Github"
cd content
git pull origin

# Render HTML
echo "Rendering HTML from Markdown"
cd ..
markdoc build 

# Build index
echo "Indexing pages"
cd rendered
find -name \*.html > "../pages.paths"
sed 's|[./]*||' "../pages.paths" > "../pages.categorieswithextension"
sed 's|\.html$||' "../pages.categorieswithextension" > "../pages.index"

# Create sed script for auto-linking
echo "Building Replacement Script"
for linkedTitle in $(< "../pages.index");do
	
	# Build hyperlink for linkedTitle
	hyperlink="<a href=\"/$linkedTitle\">$linkedTitle</a>"
	
	# Append replacment string to file
	echo "s|$linkedTitle|$hyperlink|g" >> "../replacements.sed"

done

# Auto-link each HTML page
echo "Auto-linking pages"
for title in $(< "../pages.index");do

	# Determine page path
	htmlPagePath="$title.html"

	# Replace all occurrences of linkedTitle with hyperlink
	echo "Auto-linking $title"
	sed -i.bak -f "../replacements.sed" $htmlPagePath

done

# All done
echo "Done!"

