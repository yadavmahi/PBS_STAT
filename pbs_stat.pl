#!/usr/bin/perl -w
#

use strict;

sub  trim {my $s = shift; if (defined $s){ $s =~ s/^\s+|\s+$//g;}else{$s="";} return $s };


my $cmd;
my $cmd1;
my $cmd2;
my $option=" -f";
my $option1=" -Bf";
my $option2=' -q  | sed \'1,5d\' | awk \'{print $1," ",$6," ",$7," ",$8}\'';
#my $option=" -x -f";
if (defined $ENV{'QSTAT'} ){
$cmd=$ENV{'QSTAT'}.$option;
$cmd1=$ENV{'QSTAT'}.$option1;
$cmd2=$ENV{'QSTAT'}.$option2;
}else{
$cmd="/opt/pbs/default/bin/qstat ".$option;
$cmd1="/opt/pbs/default/bin/qstat ".$option1;
$cmd2="/opt/pbs/default/bin/qstat ".$option2;
}

#my @output=`/opt/pbs/default/bin/qstat -f`;
#print $cmd;
my @output=`$cmd`;
my @output1=`$cmd1`;
my @output2=`$cmd2`;
#my @output=`/opt/pbs/default/bin/qstat -f 304628 304627 304592 304591`;

chomp(@output);  # remove new lines
chomp(@output1); # remove new lines
chomp(@output2);  # remove new lines

my $sitetitle="PBS Stat";
my $linestart = 0;
my $jobid="";
my $jobname="";
my $jobowner="";
my $jobstate="";
my $queue="";
my $cores="";
my $mem="";
my $node="";
my $date = localtime();

my $server_name="";
my $server_state="";
my $server_amem="";
my $server_acores="";

my $queue_name="";
my $queue_mem="";
my $queue_cpu="";
my $queue_wall="";
my $queue_node="";
my $queue_run="";
my $queue_que="";
my $queue_lim="";
my $queue_state="";

printf("<html><head><title>%s</title><script src=\"jquery-3.0.0.min.js\"></script><script src=\"script.js\"></script> <link href=\"styles.css\" rel=\"stylesheet\"/></head>\n",$sitetitle);
printf("<body><div class=\"content\">\n");
printf("<div class=\"header\"><h1> %s </h1><span class=\"time\">%s IST</span></div>",$sitetitle,$date);
printf("<div class=\"center\">");
printf("<div class=\"tabs\"><span class=\"system\"> Server Details </span> <span class=\"details\"> Job Details </span></div>");

printf("<div class=\"left\">");
printf("<div class=\"dmain1\">");
printf("<table id=\"smain\"><thead><tr><th>Servername</th><th>Status</th><th>Assigned Cores</th><th>Assigned Memory</th></tr></thead>\n");

foreach my $line(@output1){
#   print $line."\n";
	if ($line =~ /^$/){
#		print "hellop\n";
	}else{
	if ( $line =~ /^Server/ ){
if($linestart > 0) {
printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",$server_name,$server_state,$server_acores,$server_amem) ; 
}
$linestart=1;
$server_name="";
$server_state="";
$server_amem="";
$server_acores="";

	my ($attribute1,$value1)=split /:/,trim($line);
        $server_name=trim($value1);
# 	print ".....ID>..".$jobid;
	}else{
#print $line."\n";
	  my ($attribute1,$value1)=split /=/,trim($line);
	  my $attribute=trim($attribute1);
	  my $value=trim($value1);
	  #print $attribute."...".$value."\n";
	  if($attribute eq "server_state"){ $server_state=$value;}
	  if($attribute eq "resources_assigned.mem"){ $server_amem=$value;}
	  if($attribute eq "resources_assigned.ncpus"){ $server_acores=$value;}
	}
	}
}
printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",$server_name,$server_state,$server_acores,$server_amem) ; 
printf("</table>\n");

printf("<table id=\"qmain\"><thead><tr><th>Queue</th><th>Running jobs</th><th>Queue jobs</th><th>Limit cores</th></tr></thead>\n");

foreach my $line(@output2){
#   print $line."\n";
	if ($line =~ /^$/){
#		print "hellop\n";
	}else{
	if ( $line =~ /^[a-z,A-Z]/ ){
#		print "$line\n";
		my @queue_fields=split / /,trim($line);
		printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",$queue_fields[0],$queue_fields[3],$queue_fields[6],$queue_fields[9]) ;
	}
}
}
printf("</table></div>\n");

printf("<div class=\"dmain2\">");
printf("<div class=\"res\"></div><div class=\"search\"></div>");
printf("</div></div>");
printf("<div class=\"right\"><h2> Jobs </h2><div class=\"res\"><span></span></div>");
printf("<table id=\"main\"><thead><tr><th>Job ID</th><th>Job Name</th><th>Job Owner</th><th>Job State</th><th>Queue</th><th>Cores</th><th>Memory</th><th>Node</th></tr></thead>\n");

foreach my $line(@output){
#	print $line."\n";
	if ($line =~ /^$/){
#		print "hellop\n";
	}else{
	if ( $line =~ /^Job/ ){
#	  print "hai\n";
#printf("%10s%10s%10s%20s%10s%25s%20s\t%30s\n",$sys,$stat,$cores,$mem,$ucores,$umem,$acores,$jobs);
if($linestart > 0) {
printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",$jobid,$jobname,$jobowner,$jobstate,$queue,$cores,$mem,$node) ; 
}
$linestart=1;
$jobid="";
$jobname="";
$jobowner="";
$jobstate="";
$queue="";
$cores="";
$mem="";
$node="";
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
	  if($attribute eq "exec_host"){ $node=$value;}
	}
	}
}
printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",$jobid,$jobname,$jobowner,$jobstate,$queue,$cores,$mem,$node) ; 
printf("</table></div></div>\n");
printf("<div class=\"footer\"><h3>Copy right \@ Mahesh Yadav</h3></div>\n");
printf("</div></body>\n");

