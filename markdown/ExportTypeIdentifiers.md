Here is a script that parses an Info.plist file and outputs the XML code needed to export those General/UTIs that the system does not know about. It uses the General/ListAllDeclaredTypeIdentifiers program to find out which General/UTIs are already declared on your system. It is a bit hackish, but it can save you a lot of work if you declare a whole lot of new types. It relies on the Info.plist being indented with tabs in the same way that Xcode does! 

It takes the path to an Info.plist file as an argument, and optionally you can list any General/UTIs you want to conform to.

-- General/WAHa

    
#!/usr/bin/perl

use strict;

my $lstypes_command="./lstypes";
my @definedtypes=grep $_,split /\n/,`$lstypes_command`;

die "Usage: exporttypes.pl Info.plist [types-to-conform-to ...]" unless @ARGV>=1;

my $plist;
open PLIST,$ARGV[0] or die "Couldn't open file \"$ARGV[0]\"";
$plist.=$_ while(<PLIST>);

my $conform;
$conform="\t\t\t<array>\n".(join "",map "\t\t\t\t<string>$_</string>\n",@ARGV[1..$#ARGV])."\t\t\t</array>"
	if(@ARGV>1);

my $declaredtypes;
$plist=~m!<key>General/UTExportedTypeDeclarations</key>\s*^(\t*)<array>\s*^(.*?)^\1</array>!sm;
$declaredtypes.=$2;
$plist=~m!<key>General/UTImportedTypeDeclarations</key>\s*^(\t*)<array>\s*^(.*?)^\1</array>!sm;
$declaredtypes.=$2;

@definedtypes=grep $_ ne $1,@definedtypes
	while($declaredtypes=~m!<key>General/UTTypeIdentifier</key>\s*<string>(.*?)</string>!msg);

$plist=~m!<key>General/CFBundleDocumentTypes</key>\s*^(\t*)<array>\s*^(.*?)^\1</array>!sm;
my $types=$2;

my %types;
while($types=~m!^(\t*)<dict>\s*^(.*?)^\1</dict>!msg)
{
	my %type;
	my $typedef=$2;
	$type{$1}=$2 while($typedef=~m!<key>(.*?)</key>\s*^(\s*<(\w+)>.*?</\3>|\s*<\w+/>)!msg);

	my ($id)=$type{General/LSItemContentTypes}=~m!<string>(.*?)</string>!;

	$types{$id}=\%type if $id and !grep $id eq $_,@definedtypes;
}

print "\t<array>\n";

for(sort keys %types)
{
	my $type=$types{$_};
	print "\t\t<dict>\n";

	print "\t\t\t<key>General/UTTypeIdentifier</key>\n";
	print "\t\t\t<string>$_</string>\n";

	if($$type{General/CFBundleTypeName})
	{
		print "\t\t\t<key>General/UTTypeDescription</key>\n";
		print "$$type{General/CFBundleTypeName}\n";
	}

	if($conform)
	{
		print "\t\t\t<key>General/UTTypeConformsTo</key>\n";
		print "$conform\n";
	}

	if($$type{General/CFBundleTypeIconFile})
	{
		print "\t\t\t<key>General/UTTypeIconFile</key>\n";
		print "$$type{General/CFBundleTypeIconFile}\n";
	}

	print "\t\t\t<key>General/UTTypeTagSpecification</key>\n";
	print "\t\t\t<dict>\n";

	if($$type{General/CFBundleTypeExtensions})
	{
        	print "\t\t\t\t<key>public.filename-extension</key>\n";
		$$type{General/CFBundleTypeExtensions}=~s/^\t\t\t/\t\t\t\t/gm;
		print "$$type{General/CFBundleTypeExtensions}\n";
	}

	if($$type{General/CFBundleTypeMIMETypes})
	{
        	print "\t\t\t\t<key>public.mime-type</key>\n";
		$$type{General/CFBundleTypeMIMETypes}=~s/^\t\t\t/\t\t\t\t/gm;
		print "$$type{General/CFBundleTypeMIMETypes}\n";
	}

	if($$type{General/CFBundleTypeOSTypes})
	{
        	print "\t\t\t\t<key>com.apple.ostype</key>\n";
		$$type{General/CFBundleTypeOSTypes}=~s/^\t\t\t/\t\t\t\t/gm;
		print "$$type{General/CFBundleTypeOSTypes}\n";
	}

	print "\t\t\t</dict>\n";
	print "\t\t</dict>\n";
}
print "\t</array>\n";
