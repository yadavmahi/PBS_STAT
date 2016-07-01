# PBS_STAT
Protable Batch Scheduler Run time Statistics

Installation of PBS_STAT is simple and easy.

Requirement for PBS_STAT are :
Linux Web server
PBS command : qstat (To display jobs information)
Perl : Parsing qstat information.
Jquery 

Copy all file to respective folder of web server 
/var/www/html/pbs_stat/

Edit pbs_stat.sh, Provide 
BASEHOME=/var/www/html/pbs_stat   # Location of copied files
QSTAT=/opt/pbs/default/bin/qstat  # Location qstat command

Edit pbs_stat.cron, Provide  Location of pbs_stat.sh
PATH=/opt/pbs/default/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root@localhost
00-59/3 * * * * root /var/www/html/pbs_stat/pbs_stat.sh > /tmp/cron_pbs_stat.log 2>&1

Edit data.json, Provide Queue's Information and Running states
{
"queue":{"1":"bnormal"},
"state":{"1":"R","2":"Q","3":"E"}
}

Now check command pbs_stat.sh for generating index.html file 
./pbs_stat.sh

Now open in browser : http://localhsot/pbs_stat

