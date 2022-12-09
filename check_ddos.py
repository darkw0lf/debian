#! /usr/bin/env python

__author__ = "\nAuthor: Raimundo Henrique da Silva Chipongue\nE-mail: fc48807@alunos.fc.ul.pt, chipongue1@gmail.com\nInstitution: Faculty of Science of the University of Lisbon\n"

__version__= "1.0.0"

'''

Script to check the server accesses, and warn if an abnormal number of requests, indicating probable attempt to DDOS 

Creation date: 14/01/2017
Date last updated: 19/03/2017

* 
* License: GPL
* Copyright (c) 2017 DI-FCUL
* 
* Description:
* 
* This file contains the check_ddos plugin
* 
* Use the nrpe program to check request on remote server.
* 
* 
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* 
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''

import os
import sys
from optparse import OptionParser

# define exit codes
ExitOK = 0
ExitWarning = 1
ExitCritical = 2
ExitUnknown = 3

connection=int(os.popen("netstat -antu | grep SYN_RECV | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | grep -v 127.0.0.1 | wc -l").read())
def check(opts):
    critical = opts.crit
    warning = opts.warn
    if critical and warning:
        if connection > critical:
            print('CRITICAL - The host has %s active connections' %connection)
            sys.exit(ExitCritical)
        elif connection > warning:
            print('WARNING - The host has %s active connections' %connection)
            sys.exit(ExitWarning)
        else:
            print("OK - The host has %s active connections" %connection)
            sys.exit(ExitOK)
    else:
        print("UNKNOWN - The number of active connections is unknown")
        sys.exit(ExitUnknown)    
def main():
    parser = OptionParser("usage: %prog [options] ARG1 ARG2 FOR EXAMPLE: -c 300 -w 200")
    parser.add_option("-c","--critical", type="int", dest="crit", help="the value if consider very heigth connection in web server")
    parser.add_option("-w","--warning", type= "int", dest="warn", help="the value if consider heigth connection in web server")
    parser.add_option("-V","--version", action="store_true", dest="version", help="This option show the current version number of the program and exit")
    parser.add_option("-A","--author", action="store_true", dest="author", help="This option show author information and exit")
    (opts, args) = parser.parse_args()
   
    if opts.author:
        print(__author__)
        sys.exit()
    if opts.version:
        print("check_ddos.py %s"%__version__)
        sys.exit()

    if opts.crit and opts.warn:
        if opts.crit < opts.warn:
            print("Critical value < Warning value, please check you config")
            sys.exit(ExitCritical)
    else:
        parser.error("Please, this program requires -c and -w arguments, for example: -c 300 -w 200")  
        sys.exit(ExitCritical)

    check(opts)

if __name__ == '__main__':
    main()

  
