#!/usr/bin/perl -w
#

use strict;

sub  trim {my $s = shift; if (defined $s){ $s =~ s/^\s+|\s+$//g;}else{$s="";} return $s };


#my @output=`/opt/pbs/default/bin/qstat -f 304628 304627 304592 304591`;
my $cmd;
if (defined $ENV{'QSTAT'} ){
$cmd=$ENV{'QSTAT'}+" -f";
}else{
$cmd="/opt/pbs/default/bin/qstat -f";
}

#my @output=`/opt/pbs/default/bin/qstat -f`;
#print $cmd;
my @output=`$cmd`;

chomp(@output);  # remove new lines

my $sitetitle="PBS Stat";
my $linestart = 0;
my $jobid="";
my $jobname="";
my $jobowner="";
my $jobstate="";
my $queue="";
my $cores="";
my $mem="";
my $date = localtime();

printf("<html><head><title>%s</title><script src=\"jquery-3.0.0.min.js\"></script><script src=\"script.js\"></script> <link href=\"styles.css\" rel=\"stylesheet\"/></head>\n",$sitetitle);
printf("<body><div class=\"content\">\n");
printf("<div class=\"header\"><h1> %s </h1><span class=\"time\">%s IST</span></div><div class=\"center\">",$sitetitle,$date);
printf("<div class=\"left\"><h2> Details </h2><div class=\"res\"></div></div>");
printf("<div class=\"right\"><h2> Jobs </h2><div id=\"buttons\"><span class=\"run\">Running</span><span class=\"que\">Waiting</span><span class=\"err\">Error</span></div>");

printf("<table id=\"main\"><thead><tr><th>Job ID</th><th>Job Name</th><th>Job Owner</th><th>Job State</th><th>Queue</th><th>Cores</th><th>Memory</th></tr></thead>\n");

foreach my $line(@output){
#	print $line."\n";
	if ($line =~ /^$/){
#		print "hellop\n";
	}else{
	if ( $line =~ /^Job/ ){
#	  print "hai\n";
#printf("%10s%10s%10s%20s%10s%25s%20s\t%30s\n",$sys,$stat,$cores,$mem,$ucores,$umem,$acores,$jobs);
if($linestart > 0) {
printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",$jobid,$jobname,$jobowner,$jobstate,$queue,$cores,$mem) ; 
}
$linestart=1;
$jobid="";
$jobname="";
$jobowner="";
$jobstate="";
$queue="";
$cores="";
$mem="";
	my ($attribute1,$value1)=split /:/,trim($line);
        $jobid=trim($value1);
# 	print ".....ID>..".$jobid;
	}else{
#print $line."\n";
	  my ($attribute1,$value1)=split /=/,trim($line);
	  my $attribute=trim($attribute1);
	  my $value=trim($value1);
	  #print $attribute."...".$value."\n";
	  if($attribute eq "Job_Name"){ $jobname=$value;}
	  if($attribute eq "Job_Owner"){ $jobowner=$value;}
	  if($attribute eq "job_state"){ $jobstate=$value;}
	  if($attribute eq "queue"){ $queue=$value;}
	  if($attribute eq "Resource_List.ncpus"){ $cores=$value;}
	  if($attribute eq "Resource_List.mem"){ $mem=$value;}
	}
	}
}
printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",$jobid,$jobname,$jobowner,$jobstate,$queue,$cores,$mem) ; 
printf("</table></div></div>\n");
printf("<div class=\"footer\"><h3>Copy right \@ Mahesh Yadav</h3></div>\n");
printf("</div></body>\n");

