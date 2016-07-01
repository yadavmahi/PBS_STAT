#!/bin/bash

BASEHOME=/var/www/html/pbs_stat
QSTAT=/opt/pbs/default/bin/qstat

perl $BASEHOME/pbs_stat.pl >  $BASEHOME/index.html

date
