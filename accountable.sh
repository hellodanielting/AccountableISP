#!/bin/bash
# -------------------------------------------------------------------
# Keeping ISPs Accountable for their promises, and good quid pro quo 
# 
#
# -------------------------------------------------------------------
# This is the main execution script.
# Ensure that `config.sh` is configured.

# So, you're reading code here... this is pretty much a wrapper around
# speedtest-cli, with abstracted persistance, to enable future work to
# be able to upload the results to a shared "Google Sheets" or other.
# Here, we use a simple 3 layer architcture, with some abstractions.

source config.sh;


echo $DO_SPEEDTESTNET


# Test code blck.
if [ $DO_SPEEDTESTNET -eq 0 ]; # Check if it is "true", "0"
then
    echo "Speedtest";
fi

# Simple existence check for dependencies.
# This does not check for "correctness".
#
function dependencies_check(){
    # Software dependencies
    local cmd = "python3 --version"
    status = $?;
    if [ $status -eq 0 ]
    then
        echo "[SUCCESS] Python3 installed." ;
    else
        echo "[FAILED] Python3 cannot be located via env. vars."
    fi
    
    # Config dependencies
    # TODO.
}

function setup_storage() {
    #TODO Intialise storage
    #Currently to flatfile
}

# This interface takes a "string" and stores it in the persistance layer.

function store(){

}















# MAIN EXECUTE.
dependencies_check