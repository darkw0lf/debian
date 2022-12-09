#! /usr/bin/perl -w

############################## check_snmp_memory_linux ##############
# Version : 1.1
# Date : Dec 04 2013
#####################################################################
#
# Help : ./check_snmp_memory_linux.pl -h
#

use strict;
use Net::SNMP;
use Getopt::Long;
use POSIX;

# SNMP Datas

my $memory_Total        = ".1.3.6.1.4.1.2021.4.5.0";
my $memory_Free         = ".1.3.6.1.4.1.2021.4.6.0";
my $memory_Buffered     = ".1.3.6.1.4.1.2021.4.14.0";
my $memory_Cached       = ".1.3.6.1.4.1.2021.4.15.0";

# Globals

my $version='1.0';

my $o_host      = undef;        # hostname
my $o_community = undef;        # community
my $o_port      = 161;          # port
my $o_help      = undef;        # wan't some help ?
my $o_version   = undef;        # print version
my $o_version2  = undef;        # use snmp v2c

my %ERRORS=('OK'=>0,'WARNING'=>1,'CRITICAL'=>2,'UNKNOWN'=>3,'DEPENDENT'=>4);

# Variable pour les valeurs de Mem

my $memUsed     = undef;
my $memFree     = undef;
my $memBuffered = undef;
my $memCached   = undef;
my $memTotal    = undef;
my $percentMem  = undef;

my $memUsedOctets = undef;
my $memUsedGOctets = undef;
my $memFreeOctets = undef;
my $memCachedOctets = undef;
my $memBufferedOctets = undef;
my $memTotalOctets = undef;
my $memTotalGOctets = undef;

my $resultat    = undef;
my $c_output    = undef;
my $c_status    = undef;

my $warn_value  = 95;
my $crit_value  = 98;

# Functions

sub p_version {
        print "check_snmp_memory_linux version : $version\n";
}

sub print_usage {
        print "Usage: $0 -H <host> -C <snmp_community> [-2] [-p <port>]\n\n";
}

sub help {
   print "\nSNMP Memory Linux Monitor for Nagios version ",$version,"\n";
   print_usage();
   print <<EOT;
-h, --help
        print this help message
-H, --hostname=HOST
        name or IP address of host to check
-C, --community=COMMUNITY NAME
        community name for the host's SNMP agent (implies SNMP v1 or v2c with option)
-2, --v2c
        Use snmp v2c
-P, --port=PORT
        SNMP port (Default 161)
-V, --version
        prints version number
EOT
}

sub check_options {
        Getopt::Long::Configure ("bundling");

        GetOptions(
                'h'     => \$o_help,            'help'          => \$o_help,
                'H:s'   => \$o_host,            'hostname:s'    => \$o_host,
                'p:i'   => \$o_port,            'port:i'        => \$o_port,
                'C:s'   => \$o_community,       'community:s'   => \$o_community,
                'V'     => \$o_version,         'version'       => \$o_version,
                '2'     => \$o_version2,        'v2c'           => \$o_version2
        );
        if ( defined ($o_help) ) {
                help();
                exit $ERRORS{"UNKNOWN"};
        };

        if ( defined($o_version) ) {
                p_version();
                exit $ERRORS{"UNKNOWN"};
        };

        if ( ! defined($o_host) ) { # check host and filter
                print "No host defined!\n";
                print_usage();
                exit $ERRORS{"UNKNOWN"};
        };

        # Check Snmp Information
        if ( ! defined($o_community) ) {
                print "No community defined!\n";
                print_usage();
                exit $ERRORS{"UNKNOWN"};
        }
}

########## MAIN #######

check_options();

# Connection to host
my ($session,$error);
if ( defined ($o_version2) ) {
        # SNMPv2 Login
        ($session, $error) = Net::SNMP->session(
                -hostname  => $o_host,
                -version   => 2,
                -community => $o_community,
                -port      => $o_port
        );
} else {
        # SNMPV1 login
        ($session, $error) = Net::SNMP->session(
                -hostname  => $o_host,
                -community => $o_community,
                -port      => $o_port
        );
}
if ( !defined($session) ) {
        printf("ERROR opening session: %s.\n", $error);
        exit $ERRORS{"UNKNOWN"};
}


$resultat       = $session->get_request($memory_Total);
$memTotal       = $resultat->{$memory_Total};

$resultat       = $session->get_request($memory_Free);
$memFree        = $resultat->{$memory_Free};

$resultat       = $session->get_request($memory_Buffered);
$memBuffered    = $resultat->{$memory_Buffered};

$resultat       = $session->get_request($memory_Cached);
$memCached      = $resultat->{$memory_Cached};

$memUsed = $memTotal - ( $memFree + $memBuffered + $memCached );

$memUsedOctets = $memUsed * 1024;
$memUsedGOctets = $memUsed / 1048576;
$memUsedGOctets = sprintf("%.2f", $memUsedGOctets);
$memTotalOctets = $memTotal * 1024;
$memTotalGOctets = $memTotal / 1048576;
$memTotalGOctets = sprintf("%.2f", $memTotalGOctets);
$memCachedOctets = $memCached * 1024;
$memBufferedOctets = $memBuffered * 1024;
$memFreeOctets = $memFree * 1024;
$percentMem = floor(( $memUsed / $memTotal ) * 100);

if ( $percentMem < $warn_value ) {
        $c_output       = "OK - La memoire est utilisee a ".$percentMem."%. Il y a ".$memUsedGOctets." Go d'utilisee sur ".$memTotalGOctets." Go. | Mem_Totale=".$
memTotalOctets."o; Mem_Used=".$memUsedOctets."o; Mem_Buffered=".$memBufferedOctets."o; Mem_Cached=".$memCachedOctets."o; Mem_Free=".$memFreeOctets."o";        $c_status       = "OK";
}
elsif ( ($percentMem >= $warn_value) && ($percentMem < $crit_value) ) {
        $c_output       = "WARNING - La memoire est utilisee a ".$percentMem."%. Il y a ".$memUsedGOctets." Go d'utilisee sur ".$memTotalGOctets." Go. | Mem_Total
e=".$memTotalOctets."o; Mem_Used=".$memUsedOctets."o; Mem_Buffered=".$memBufferedOctets."o; Mem_Cached=".$memCachedOctets."o; Mem_Free=".$memFreeOctets."o";        $c_status       = "WARNING";
}
elsif ( $percentMem >= $crit_value ) {
        $c_output       = "CRITICAL - La memoire est utilisee a ".$percentMem."%. Il y a ".$memUsedGOctets." Go d'utilisee sur ".$memTotalGOctets." Go. | Mem_Tota
le=".$memTotalOctets."o; Mem_Used=".$memUsedOctets."o; Mem_Buffered=".$memBufferedOctets."o; Mem_Cached=".$memCachedOctets."o; Mem_Free=".$memFreeOctets."o";
        $c_status       = "CRITICAL";
}

$session->close;
print "$c_output \n";
exit $ERRORS{$c_status};
