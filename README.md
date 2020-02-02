AccountableISP ( WORK IN PROGRESS )
-----------------------

Monitoring the network performance of what you have paid your ISP for is challenging, and fustrating.
With sites like Speedtest.net, it can be difficult to make decisions about your ISP as collecting speedtest and network data is typically a manual piece of effort.

The aim of this project is to
  1. enable automated network testing and monitoring;
  2. and collection of that data that is accessible to you,
  3. and should you choose, share that data/collect from various people.

The main motivation, is to help give you the tools to make an informed decision, and to give you the data points you need to question your ISP. If they are unresponsive, hopefully help you have enough data to make your case to whatever external 3rd party resolution options you may choose.

# Usage Guide

### Prerequisites & Dependencies
This guide assumes you're using a modern Debian-based operating system, such as Debian, Ubuntu, or Raspbian. It also assumes you have `sudo` privilages and internet access to install any prerequisites. 

> Do note that this guide is meant to help get you started, not a "best practice", nor secure installation guide.

Update your packages and install the following packages:

 `sudo apt-get update && sudo apt-get upgrade -y`

 `aaa`


# About the Tool
## The Design

This suite is made of 3 main components:
 - the speedtest provider & network testing utilities
 - the automation script
 - the data collector

Some design considerations:
 - Must be able to be used like an appliance, once configured.
 - The initial setup, is performed by someone with basic Linux and Bash scripting knowledge.

### a) The Speedtest Provider & network testing utilities
This is mainly working with Speedtest.net; as it is one of the de-facto speedtest provider which also provides a permalink URL to the speedtes performed.

# Acknowledgements
A huge part of the Speedtest functionality is dependent on Speedtest-cli by Matt Martz
`https://github.com/sivel/speedtest-cli` and of course the Speedtest.net service. The `speedtest.py` included in this repository is a copy of commit [`c58ad33`](https://github.com/sivel/speedtest-cli/commit/c58ad3367bf27f4b4a4d5b1bca29ebd574731c5d) from his repository. A copy is included due to how intergral this is to the project. 

> speedtest-cli works with Python 2.4-3.7.

Some parts of the bandwidth test functionality are inspired and derived from these projects:

 - `s-st`'s [nech](https://github.com/n-st/nench) - https://github.com/n-st/nench
 - `teddysun`'s [bench.sh](https://github.com/teddysun/across/blob/master/bench.sh) - https://github.com/teddysun/across/blob/master/bench.sh
 - [Cloudharmony's CDN Speedtest](https://cloudharmony.com/speedtest-for-cloudflare:cdn)