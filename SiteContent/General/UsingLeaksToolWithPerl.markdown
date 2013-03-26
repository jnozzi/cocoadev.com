You can use the leaks tools with perl to create terminal output that is easier to read (at least for me).

I am not a Cocoa or Perl expert, so I imagine there is a simpler and/or more elegant implementation of the following.  However, I thought I would share it as it is has been very useful for me.

I use a debug build with following environment variables set:

<code>
[[MallocStackLogging]] 1
[[MallocScribble]] 1
[[MallocGuardEdges]] 1
[[MallocCheckHeapStart]] 1
[[MallocCheckHeapEach]] 10000
[[NSDebugEnabled]] YES
[[NSZombieEnabled]] YES
[[NSHangOnUncaughtException]] YES
</code>

- Eric

<code>
#!/usr/bin/perl -w

open LEAKS, "leaks -nocontext [[YourApplication]]|" or die "leaks: non-zero exit of $?";

%leaks = ();
	
while (<LEAKS>)
{
	$line = $_;
	chomp $line;
	if (($line =~ /Leak/) and !($line =~ /[[NSZombie]]/))
	{
		$leak = $line;
		print $leak . "\n";
		
		$call_stack = <LEAKS>;
		chomp $call_stack;
		$call_stack =~ s/^\s+//;
		$call_stack =~ s/\[thread.''\]://;
		
		if (exists $leaks{$call_stack})
		{
			my ($leak, $count) = @{$leaks{$call_stack}};
			$count = $count + 1;
			$leaks{$call_stack} = [$leak, $count];
		}
		else
		{
			$leaks{$call_stack} = [$leak, 1];
		}
	}
}

print "\n";

while (($call_stack, $leak_values) = each %leaks)
{
	my ($leak, $count) = @{$leak_values};
	
	print $leak . "count=" . $count . "\n";

	@fields = split(/ \| /, $call_stack);
	foreach $field (@fields)
	{
		print "\t" . $field . "\n";
	}
	print "\n";
}
</code>