#!/bin/bash
# Network Speedtest Audit (v0.1.2)
#-------------------------
# This script runs the Speedtest-cli script, and puts it together
# into somewhat of a nice text report.
# Useful for providing proof of speed to your ISP.
# The goal here is to help track speed performance and peering
# bandwidth limitations. Expect this to use lots of bandwidth.
# Only run if you have Unlimited quota.
#----------------------------------------------------------------
#set -ex
set -m

source '/etc/profile'
source '~/.bashrc'
source '~/.profile'


# --- configuration ---
OUTPUT_FOLDER=`pwd`
OUTPUT_ST_CSV="$OUTPUT_FOLDER/st_results.csv"; #The Speedtest.net csv
OUTPUT_TRACE="$OUTPUT_FOLDER/st_trace.txt"; #The txt report with info to help diagnose.

TEST_REPEAT=2;
IP_ADDR="127.0.0.1";

# --- Pre-flight Check ---

if  [ ! -e $OUTPUT_ST_CSV ]; # Setup a new Speedtest CSV since it doesn't exist
then
    mkdir -p $OUTPUT_FOLDER;
    touch $OUTPUT_ST_CSV;

    #Create CSV Headers
    python speedtest.py --csv-header >> "$OUTPUT_ST_CSV";
fi
if [ ! -e $OUTPUT_TRACE ]; # Setup a new trace txt file since it doesn't exit.
then
    mkdir -p  $OUTPUT_FOLDER;
    touch $OUTPUT_TRACE ;
    echo ' Date +  Ping + traceroute ' >> $OUTPUT_TRACE ;
fi


# --- Perform Speedtest using Speedtest.net
    for i in {1..$TEST_REPEAT};
    do
        #python speedtest.py --server 2225 --csv >> "$OUTPUT_ST_CSV"; # Telstra, Melbourne, AU
        #python speedtest.py --server 6141 --csv >> "$OUTPUT_ST_CSV"; # AARNet, Melbourne, AU
        #python speedtest.py --server 2629 --csv >> "$OUTPUT_ST_CSV"; # Telstra, Sydney, AU
        #python speedtest.py --server 6355 --csv >> "$OUTPUT_ST_CSV"; # AARNet, Sydney, AU
        python3 speedtest.py --server 26511 --csv >> "$OUTPUT_ST_CSV"; # Maxis, Subang, MY
        python3 speedtest.py --server 6546 --csv >> "$OUTPUT_ST_CSV"; # Time dotcom, Shah Alam, MY
        python3 speedtest.py --server 10327 --csv >> "$OUTPUT_ST_CSV"; # TM, KL, MY

        python3 speedtest.py --server 3914 --csv >> "$OUTPUT_ST_CSV"; # SingTel, Singapore, SG
        python3 speedtest.py --server 7311 --csv >> "$OUTPUT_ST_CSV"; # M1, Singapore, SG
        python3 speedtest.py --server 5754 --csv >> "$OUTPUT_ST_CSV"; # Fastmetrics Inc., San Fancisco, USA
        python3 speedtest.py --server 603 --csv >> "$OUTPUT_ST_CSV";  # Unwired, San Fancisco, USA
    done;



# --- Perform Network Trace

    #Block Separator & Metadata
    echo -e "\n" >> $OUTPUT_TRACE;
    echo "#################################################"  >> $OUTPUT_TRACE;
    echo -n "Time : "  >> $OUTPUT_TRACE;
    date >> $OUTPUT_TRACE;
    echo "#################################################"  >> $OUTPUT_TRACE;

    IP_ADDR=`curl -Ls http://thisis.my/ip`;

    #Metadata
    echo -n "Test Host IP : " >> $OUTPUT_TRACE;
    curl -Ls http://thisis.my/ip 2>&1 >> $OUTPUT_TRACE;

    echo "### Host IP Info :"       >> $OUTPUT_TRACE;
    echo '$> host'                  >> $OUTPUT_TRACE;
    host $IP_ADDR 2>&1              >> $OUTPUT_TRACE;
    echo '$> nslookup'              >> $OUTPUT_TRACE;
    nslookup $IP_ADDR 2>&1          >> $OUTPUT_TRACE;
    echo '$> whois'                 >> $OUTPUT_TRACE;
    whois $IP_ADDR 2>&1             >> $OUTPUT_TRACE;
    echo ""                         >> $OUTPUT_TRACE;
    echo '$> iptoasn.com'           >> $OUTPUT_TRACE;
    curl -Ls "https://api.iptoasn.com/v1/as/ip/$IP_ADDR" >> $OUTPUT_TRACE;

    echo "### Host Network Info :"  >> $OUTPUT_TRACE;
    #host, whois, nslookup
    echo '$> host'           >> $OUTPUT_TRACE;
    host $IP_ADDR            >> $OUTPUT_TRACE;
    echo '$> whois'          >> $OUTPUT_TRACE;
    whois $IP_ADDR           >> $OUTPUT_TRACE;
    echo '$> nslookup'       >> $OUTPUT_TRACE;
    nslookup $IP_ADDR        >> $OUTPUT_TRACE;

    #Host information
    ip route show  >>  $OUTPUT_TRACE;
    lshw -class network >>  $OUTPUT_TRACE;
    ip a >>  $OUTPUT_TRACE;

    #Sanity Check -- ping google & amazon
    ping -c 2 google.com     >> $OUTPUT_TRACE;
    ping -c 2 amazon.com.au  >> $OUTPUT_TRACE;
    ping -c 2 172.217.25.174 >> $OUTPUT_TRACE;
    
    echo '$> mtr'                            >> $OUTPUT_TRACE;
    mtr -rwz google.com                      >> $OUTPUT_TRACE;
    mtr -rwz s3.ap-southeast-2.amazonaws.com >>  $OUTPUT_TRACE;
    mtr -rwz s3.ap-southeast-1.amazonaws.com >>  $OUTPUT_TRACE;
    mtr -rwz s3.ap-northeast-1.amazonaws.com >>  $OUTPUT_TRACE;
    mtr -rwz s3.eu-west-2.amazonaws.com      >>  $OUTPUT_TRACE;
    mtr -rwz s3.us-west-1.amazonaws.com      >>  $OUTPUT_TRACE;
    mtr -rwz s3.us-east-2.amazonaws.com      >>  $OUTPUT_TRACE;
    mtr -rwz speedtest.syd01.softlayer.com   >>  $OUTPUT_TRACE;
    mtr -rwz speedtest.sng01.softlayer.com   >>  $OUTPUT_TRACE;
    mtr -rwz speedtest.sjc01.softlayer.com   >>  $OUTPUT_TRACE;
    mtr -rwz titan.csit.rmit.edu.au          >>  $OUTPUT_TRACE;

    echo '$> traceroute'               >> $OUTPUT_TRACE;
    traceroute --mtu -A google.com     >> $OUTPUT_TRACE;
    traceroute --mtu -A s3.ap-southeast-2.amazonaws.com >>  $OUTPUT_TRACE;
    traceroute --mtu -A s3.ap-southeast-1.amazonaws.com >>  $OUTPUT_TRACE;
    traceroute --mtu -A s3.ap-southeast-1.amazonaws.com >>  $OUTPUT_TRACE;
    traceroute --mtu -A speedtest.syd01.softlayer.com   >>  $OUTPUT_TRACE;
    traceroute --mtu -A speedtest.sng01.softlayer.com   >>  $OUTPUT_TRACE;
    traceroute --mtu -A speedtest.sjc01.softlayer.com   >>  $OUTPUT_TRACE;
    traceroute --mtu -A titan.csit.rmit.edu.au          >>  $OUTPUT_TRACE;

    #Run Download Speedtest
    echo -n '[Softlayer-Syd]=' >> $OUTPUT_TRACE;
    wget -O /dev/null http://speedtest.syd01.softlayer.com/downloads/test10.zip 2>&1 | tail -2 | head -1 >> $OUTPUT_TRACE;
    echo -n '[Softlayer-Sng]=' >> $OUTPUT_TRACE;
    wget -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test10.zip 2>&1 | tail -2 | head -1 >> $OUTPUT_TRACE;
    echo -n '[Softlayer-Sjc]=' >> $OUTPUT_TRACE;
    wget -O /dev/null http://speedtest.sjc01.softlayer.com/downloads/test10.zip 2>&1 | tail -2 | head -1 >> $OUTPUT_TRACE;

    echo -n '[AWS-Syd]=' >> $OUTPUT_TRACE;
    wget -O /dev/null https://s3-ap-southeast-2.amazonaws.com/speedtest.c12.pw/random4000x4000.jpg 2>&1 | tail -2  | head -1 >> $OUTPUT_TRACE;
    
    echo -n '[RMIT-Melb]=' >> $OUTPUT_TRACE;
    wget -O /dev/null http://titan.csit.rmit.edu.au/~e09755/test10.zip    2>&1 | tail -2 | head -1 >> $OUTPUT_TRACE;
    wget -O /dev/null http://saturn.csit.rmit.edu.au/~e09755/test10.zip   2>&1 | tail -2 | head -1 >> $OUTPUT_TRACE;
    wget -O /dev/null http://jupiter.csit.rmit.edu.au/~e09755/test10.zip  2>&1 | tail -2 | head -1 >> $OUTPUT_TRACE;

# --- Perform Speedtest using Speedtest.net
    for i in {1..$TEST_REPEAT};
    do
        python speedtest.py --server 2225 --csv >> "$OUTPUT_ST_CSV"; # Telstra, Melbourne, AU
        python speedtest.py --server 6141 --csv >> "$OUTPUT_ST_CSV"; # AARNet, Melbourne, AU
        python speedtest.py --server 2629 --csv >> "$OUTPUT_ST_CSV"; # Telstra, Sydney, AU
        python speedtest.py --server 6355 --csv >> "$OUTPUT_ST_CSV"; # AARNet, Sydney, AU
        python speedtest.py --server 3914 --csv >> "$OUTPUT_ST_CSV"; # SingTel, Singapore, SG
        python speedtest.py --server 7311 --csv >> "$OUTPUT_ST_CSV"; # M1, Singapore, SG
        python speedtest.py --server 5754 --csv >> "$OUTPUT_ST_CSV"; # Fastmetrics Inc., San Fancisco, USA
        python speedtest.py --server 603 --csv >> "$OUTPUT_ST_CSV";  # Unwired, San Fancisco, USA
    done;


# Forensics Sanity : Hash the script that just ran.
echo '[RunScriptHash|SHA1]=' >> $ $OUTPUT_TRACE;
cat "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)/$0" | sha1sum >> $OUTPUT_TRACE;
