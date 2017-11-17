#!/usr/bin/perl
use POSIX;
use Net::SSH2;
use Control::CLI;
use Data::Dumper;
use Term::ReadKey;

use FindBin qw($Bin);
use lib "$Bin/../lib";

#$Bin from FindBin will give path to directory from where alarm script was invoked

$Bin =~ s/\//\\/g;



($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =localtime(time);

my $day = strftime "%a", localtime;
my $month = strftime "%m", localtime;
my $month_full = strftime "%B", localtime;
my $date = strftime "%e", localtime;
my $year = strftime "%Y", localtime;

my $hour = strftime "%H", localtime;
my $minute = strftime "%M", localtime;
my $second = strftime "%S", localtime;

if ($mday < 10) {
$mday = "0$mday";
                }

my ($lsm_user, $lsm_pass, $lsm_ip_address, $lsm_selected, $enode_num, $cascade);

my (%hash_ALM_4G, $hash_ALM_4G);
%hash_ALM_4G = ();

my ($ALARM_NO_DATA);

my (%hash_TEST_TXPWR, $hash_TEST_TXPWR);
%hash_TEST_TXPWR = ();

my (%hash_TEST_VSWR, $hash_TEST_VSWR);
%hash_TEST_VSWR = ();

my (%hash_OCNS, $hash_OCNS);
%hash_OCNS = ();

my $equip_count = 0;
my $disable_count = 0;

my $colon = ";\n";

if ($ARGV[0]) {		#start if information is provided on the command line
my (@input, $input);
@input = split(/,/,$ARGV[0]);
$lsm_user = "$input[0]";
$lsm_pass = "$input[1]";
$lsm_ip_address = "$input[2]";
$lsm_selected = "$input[3]";
$enode_num = "$input[4]";
$cascade = "$input[5]";
              }		#end if information is provided on the command line



my (%hash_term, $hash_term);
%hash_term = ();
$hash_term{0} = 0;
$hash_term{1} = 1;
$hash_term{2} = 2;

print ("##################################################################\n");
print ("#            4G 1900 ATP EXECUTION AND VERIFY TOOL               #\n");
print ("# TOOL WILL CREATE AND EXECUTE ATP BATCH AND VERIFY RESULTS      #\n");
print ("##################################################################\n\n");

my $validate = "true";#`C:\\3G_4G_TOOL_Scripts\\bin\\validate.exe`;
chomp ($validate);


if ($validate eq "expired"){
print ("ERROR: YOUR TOOLS HAS EXPIRED\n\n");
sleep 15;
exit;
                           }



if ($validate ne "true"){
print ("ERROR: YOU ARE NOT A VALID USER\n");
sleep 15;
exit;
                        }


if (!$ARGV[0]) {		#start if information is not provided on the command line
################################
# START GET LSM DATA FOR LOGIN #
################################
my (%hash_lsm, $hash_lsm);
my (%hash_lsm_ip, $hash_lsm_ip);
my (%hash_lsm_num, $hash_lsm_num);
%hash_lsm = ();
%hash_lsm_ip = ();
%hash_lsm_num = ();
my ($lsm_num_input);


my $lsm_database = `type lsm_database.txt`;

my (@array_each_line_lsm, $array_each_line_lsm);
@array_each_line_lsm = split(/\n/, $lsm_database);

print ("LSM to Select:\n");
foreach $array_each_line_lsm (@array_each_line_lsm) {
@_ = split(/,/, $array_each_line_lsm);
$hash_lsm{$_[0]} = $_[0];
$hash_lsm_ip{$_[0]} = $_[1];
                                                    }


my $lsm_num = 1;
foreach $hash_lsm (sort keys %hash_lsm) {
print ("$lsm_num - $hash_lsm\n");
$hash_lsm_num{$lsm_num} = $hash_lsm;
$lsm_num++;
                                        }

print ("CHOOSE A NUMBER: ");
$lsm_num_input = <STDIN>;
chomp ($lsm_num_input);
$lsm_num_input =~ s/\s+//g;

$lsm_selected = $hash_lsm_num{$lsm_num_input};
$lsm_ip_address = $hash_lsm_ip{$lsm_selected};
#print ("$lsm_selected $lsm_ip_address\n");

################################
#  END GET LSM DATA FOR LOGIN  #
################################


print ("\n##################################################\n");
print ("#     ENTER LSM UNIX USERNAME AND PASSWORD       #\n");
print ("# NOTE: USERNAME AND PASSWORD ARE CASE SENSITIVE #\n");
print ("##################################################\n");



print "\nEnter $lsm_selected LSM Username: ";
$lsm_user=<STDIN>;
chomp ($lsm_user);

print "\nEnter $lsm_selected LSM Password: ";
ReadMode 2;
$lsm_pass=<STDIN>;
chomp ($lsm_pass);
ReadMode 0;
print ("\n");

#print ("$lsm_selected LSM USERNAME:$lsm_user\n$lsm_selected LSM PASSWORD:$lsm_pass\n");




#############################
# START ENTER ENODEB NUMBER #
#############################
print ("\n#################################################\n");
print ("#               ENTER ENODEB NUMBER             #\n");
print ("#                  EXAMPLE:517134               #\n");
print ("#################################################\n");
print ("TYPE ENODEB NUMBER: ");
$enode_num = <STDIN>;
chomp ($enode_num);
$enode_num =~ s/\s+//g;

#############################
#  END ENTER ENODEB NUMBER  #
#############################


               }		#end if information is not provided on the command line

#################
# START SSH LSM #
#################

my $ssh = new Control::CLI(Use => 'SSH',
                        Prompt => ']',
			Errmode=> 'return',
                        Timeout=> '60');


$ssh->connect(Host => $lsm_ip_address,
          Username => $lsm_user,
          Password => $lsm_pass,
        PrivateKey => '.ssh/id_dsa');


#$ssh->dump_log("$Bin\\dump.txt");           # Debuging
#$ssh->output_log("$Bin\\output.txt");       # Debuging

$ssh->read(Blocking => 1);






my (%hash_level_id, $hash_level_id);
%hash_level_id = ();						#hash for level id equal grow etc


my ($ip);


my (%hash_enode_name, $hash_enode_name);
my (%hash_bucket, $hash_bucket);
my (%hash_ip, $hash_ip);
my (%hash_current_pkg, $hash_current_pkg);
%hash_enode_name = ();
%hash_bucket = ();
%hash_ip = ();
%hash_current_pkg = ();

$ssh->print("source /home/lsm/.profile");
$ssh->waitfor(']');
my $profile = $ssh->waitfor(']');
#print ("$profile\n");

sleep 1;

$ssh->print("INFO.sh;");
$ssh->waitfor(';');
my $info = $ssh->waitfor(']');
$info =~ s/\[.*//g;
print ("$info\n\n");


my ($database_name);

if (($info =~ m/4.0/)  || ($info =~ m/5.0/)) {
$database_name = "mc_db";
                                 }
else {
$database_name = "lsm_db";
     }


print ("$database_name\n");


print ("\n\nPLEASE WAIT......\n\n");


$ssh->print("/db/mysql/app/bin/mysql -ulsm -plsm $database_name\;");
my $sql_start = $ssh->waitfor('mysql>');
#print ("$sql_start\n\n");



$ssh->print("select level2_id,ems_alias from cm_v_level2andcoord_lsm;");
my $BUCKETS = $ssh->waitfor('mysql>');
#print ("$BUCKETS\n");


##########################
# START GET BUCKET NAMES #
##########################


my (@array_split_get_level_id, $array_split_get_level_id);



@array_split_get_level_id = split(/\n/, $BUCKETS);
foreach $array_split_get_level_id (@array_split_get_level_id) {
$array_split_get_level_id =~ s/^\|\s+//g;
$array_split_get_level_id =~ s/\|\s+$//g;
$array_split_get_level_id =~ s/\s+$//g;
$array_split_get_level_id =~ s/\s+\|\s+/\t/g;
if (($array_split_get_level_id =~ m/^\d+/) && ($array_split_get_level_id !~ m/rows\s+in\s+set/)) {
#print ("$array_split_get_level_id\n");
@_ = split(/\t/, $array_split_get_level_id);
$_[1] = uc($_[1]);


$hash_level_id{$_[0]} = "$_[1]";				#hash level_id key is number and value is bucket

                                                                                                 }
                                                              }

#print Dumper(\%hash_level_id);
##########################
#  END GET BUCKET NAMES  #
##########################


$ssh->print("select system_id,ems_alias,level2_id,level3_id,ip_addr_1,version,cur_pkg_ver from cm_v_level3_lsm;");
my $ENODEBS = $ssh->waitfor('mysql>');
#print ("$ENODEBS\n");
#print (FILE "$ENODEBS\n");

#########################
# START GET ENODEB INFO #
#########################


my (@array_get_enodeb_ids, $array_get_enodeb_ids);
@array_get_enodeb_ids = split(/\n/, $ENODEBS);
foreach $array_get_enodeb_ids (@array_get_enodeb_ids) {
$array_get_enodeb_ids =~ s/^\|\s+//g;
$array_get_enodeb_ids =~ s/\|\s+$//g;
$array_get_enodeb_ids =~ s/\s+$//g;
$array_get_enodeb_ids =~ s/\s+\|\s+/\t/g;
$array_get_enodeb_ids =~ s/\r+//g;
if (($array_get_enodeb_ids !~ m/rows\s+in\s+set/) && ($array_get_enodeb_ids !~ m/system_id/)) {
@_ = split(/\t+/, $array_get_enodeb_ids);

if (($_[0] =~ m/\d+/)) {		#start if $_[0]

$hash_enode_name{$_[0]} = $_[1];
$hash_bucket{$_[0]} = $_[2];
$hash_ip{$_[0]} = $_[4];
$hash_current_pkg{$_[0]} = "$_[6]";

my $bucket_4g = "$hash_level_id{$_[2]}";


                       }		#end if $_[0]




                                                                                              }
                                                       }

#########################
#  END GET ENODEB INFO  #
#########################




$ssh->print('exit');
my $sql_exit = $ssh->waitfor(']');






my $enodeb = $hash_enode_name{$enode_num};
my $ip = $hash_ip{$enode_num};

if ($ip !~ m/\d+\.\d+\.\d+\.\d+/) {		#start if no ip address

$ssh->print("pwd");
$ssh->waitfor('/home/');

#########################
# START RTRV IP ADDRESS #
#########################
$ssh->print("cmd $enodeb RTRV-IP-ADDR");
$ssh->waitfor("]");
$ssh->waitfor("]");
my $RTRV_IP_ADDR_4G = $ssh->waitfor(';');
$RTRV_IP_ADDR_4G = "$RTRV_IP_ADDR_4G$colon";
print ("$RTRV_IP_ADDR_4G\n");
print (FILE_4G "$RTRV_IP_ADDR_4G\n");





my (@array_4G_IP_ADDR_each_line, $array_4G_IP_ADDR_each_line);
@array_4G_IP_ADDR_each_line = split(/\n/, $RTRV_IP_ADDR_4G);
foreach $array_4G_IP_ADDR_each_line (@array_4G_IP_ADDR_each_line) {
$array_4G_IP_ADDR_each_line =~ s/^\s+//g;
if ($array_4G_IP_ADDR_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_4G_IP_ADDR_each_line);
if (($_[3] eq "30") && ($_[0] eq "1")) {
$ip = $_[2];				#MMBS_OAM_IP_4G_LSM from lsm
#print ("$_[0] $_[2]\n");
                                       }
                                            }
                                                                  }
#print ("MMBS_OAM_IP_4G_LSM:$MMBS_OAM_IP_4G_LSM\nMMBS_S_B_IP_4G_LSM:$MMBS_S_B_IP_4G_LSM\n");
#########################
#  END RTRV IP ADDRESS  #
#########################

                                }		#end if no ip address



my $bucket_num = $hash_bucket{$enode_num};
my $bucket = $hash_level_id{$bucket_num};
#my $ip = $hash_ip{$enode_num};
my $pkg = $hash_current_pkg{$enode_num};

print ("Bin - $Bin\n");

print ("\n4G ATP WILL BE PERFORMED ON\n\nLSM: $lsm_selected\nENODEB: $enodeb\nENODEB NUMBER: $enode_num\nBUCKET: $bucket\nIP: $ip\n\n");
print ("CONTINUE WITH 4G ATP:\n");
print ("1 - YES\n");
print ("2 - NO\n");
print ("CHOOSE A NUMBER: ");
my ($continue);
$continue = <STDIN>;
chomp ($continue);
$continue =~ s/\s+//g;

if ($continue == 2) {
exit;
                    }







my ($value);


$ssh->print("cd .ssh");
$ssh->waitfor(']');
$ssh->print("rm known_hosts");
$ssh->print("y");
$ssh->waitfor(']');
$ssh->print("cd");
$ssh->waitfor(']');


$ssh->print("pwd");
$ssh->waitfor('/home/');

$ssh->print("cmd $enodeb RTRV-CELL-CONF;");
$ssh->waitfor(";");
$ssh->waitfor("]");
my $RTRV_CELL_CONF = $ssh->waitfor(';');
$RTRV_CELL_CONF = "$RTRV_CELL_CONF$colon";
print ("$RTRV_CELL_CONF\n");
$value .= "$RTRV_CELL_CONF";


my (@split_CELL_CONF, $split_CELL_CONF);
my (%hash_cell_state, $hash_cell_state);
my (%hash_cell_status, $hash_cell_status);
%hash_cell_state = ();
%hash_cell_status = ();

@split_CELL_CONF = split(/\n/, $RTRV_CELL_CONF);

foreach $split_CELL_CONF (@split_CELL_CONF) {
$split_CELL_CONF =~ s/^\s+//g;
if (($split_CELL_CONF =~ m/^0 /) || ($split_CELL_CONF =~ m/^1 /) || ($split_CELL_CONF =~ m/^2 /)) {
@_ = split(/\s+/, $split_CELL_CONF);
$hash_cell_state{$_[0]} = $_[2];
$hash_cell_status{$_[0]} = $_[1];

if ($_[1] eq "EQUIP") {
$equip_count++;
                      }
                                                                                                  }
                                            }





######################
# START UNLOCK CELLS #
######################
$ssh->print("cmd $enodeb CHG-SYS-CONF:unlocked;");
$ssh->waitfor("]");
$ssh->waitfor("]");
my $SYS_CONF = $ssh->waitfor(';');
$SYS_CONF = "$SYS_CONF$colon";
print ("$SYS_CONF\n");
$value .= "$SYS_CONF";

&CHG_CELL_CONF(0,unlocked);
&CHG_CELL_CONF(1,unlocked);
&CHG_CELL_CONF(2,unlocked);

sub CHG_CELL_CONF {				#START CHG_CELL_CONF SUBROUTINE
if ($hash_cell_status{$_[0]} eq "EQUIP") {
$ssh->print("cmd $enodeb CHG-CELL-CONF:CELL_NUM=$_[0],ADMINISTRATIVE_STATE=$_[1]");
$ssh->waitfor("]");
$ssh->waitfor("]");
sleep 5;
my $CHG_CELL_CONF_0 = $ssh->waitfor(';');
$CHG_CELL_CONF_0 = "$CHG_CELL_CONF_0$colon";
print ("$CHG_CELL_CONF_0\n");
$value .= "$CHG_CELL_CONF_0";
                                         }
                  }				#END CHG_CELL_CONF SUBROUTINE
######################
#  END UNLOCK CELLS  #
######################



$ssh->print("cmd $enodeb RTRV-CELL-STS");
$ssh->waitfor("]");
$ssh->waitfor("]");
my $RTRV_CELL_STS = $ssh->waitfor(';');
$RTRV_CELL_STS = "$RTRV_CELL_STS$colon";
print ("$RTRV_CELL_STS\n");
$value .= "$RTRV_CELL_STS";


my (@split_CELL_STS, $split_CELL_STS);
my (%hash_CELL_STS_OP_STATE, $hash_CELL_STS_OP_STATE);
my (%hash_CELL_STS_USE_STATE, $hash_CELL_STS_USE_STATE);
%hash_CELL_STS_OP_STATE = ();
%hash_CELL_STS_USE_STATE = ();

@split_CELL_STS = split(/\n/, $RTRV_CELL_STS);

foreach $split_CELL_STS (@split_CELL_STS) {
$split_CELL_STS =~ s/^\s+//g;
if ($split_CELL_STS =~ m/^\d+/) {
@_ = split(/\s+/, $split_CELL_STS);
$hash_CELL_STS_OP_STATE{$_[0]} = $_[1];
$hash_CELL_STS_USE_STATE{$_[0]} = $_[2];

if (($_[0] eq "0") || ($_[0] eq "1") || ($_[0] eq "2")) {
if ($_[1] eq "disabled") {
$disable_count++;
                         }

                                                        }

                                }


                                          }

if ($equip_count ne "$disable_count") {		#START IF $equip_count ne $disable_count
my ($error_num, $error);

#&ERROR_CELL_DISABLE(0);
#&ERROR_CELL_DISABLE(1);
#&ERROR_CELL_DISABLE(2);

sub ERROR_CELL_DISABLE {			#START ERROR_CELL_DISABLE SUBROUTINE
if (($hash_cell_status{$_[0]} eq "EQUIP") && ($hash_CELL_STS_OP_STATE{$_[0]} eq "disabled")) {
print ("ERROR: CELL_NUM $_[0] OPERATIONAL_STATE IS DISABLED AFTER UNLOCKING CELL\n");
$error_num = 1;
$error = "ERROR: CELL_NUM $_[0] OPERATIONAL_STATE IS DISABLED AFTER UNLOCKING CELL";

                                                                                             }
                      }				#END ERROR_CELL_DISABLE SUBROUTINE

if ($error_num == 1) {
&CHG_CELL_CONF(0,locked);
&CHG_CELL_CONF(1,locked);
&CHG_CELL_CONF(2,locked);


$ssh->print("cmd $enodeb RTRV-CELL-STS");
$ssh->waitfor("]");
$ssh->waitfor("]");
my $RTRV_CELL_STS_error = $ssh->waitfor(';');
$RTRV_CELL_STS_error = "$RTRV_CELL_STS_error$colon";
print ("$RTRV_CELL_STS_error\n");
$value .= "$RTRV_CELL_STS_error";


$ssh->print("cmd $enodeb RTRV-CELL-CONF");
$ssh->waitfor("]");
$ssh->waitfor("]");
my $RTRV_CELL_CONF_error = $ssh->waitfor(';');
$RTRV_CELL_CONF_error = "$RTRV_CELL_CONF_error$colon";
print ("$RTRV_CELL_CONF_error\n");
$value .= "$RTRV_CELL_CONF_error";


$ssh->disconnect;

print ("$error\n");
sleep 10;
exit;
                      }



#$ssh->print("cd .ssh");
#$ssh->print("rm known_hosts");
#$ssh->print("cd ..");


print ("\nPLEASE WAIT LOGGING INTO UAMA CARD........\n\n");


$ip =~ s/\s+//g;

$ssh->cmd("ssh lteuser\@$ip");
sleep 5;
$ssh->print("yes");
sleep 5;
my $log = $ssh->waitfor('password:');
print ("$log\n");

$ssh->print("samsunglte");
#$ssh->waitfor('lteuser@UAMA');
my $log = $ssh->waitfor('lteuser');
print ("$log\n");

$ssh->print("su -");
my $log = $ssh->waitfor('Password:');
print ("$log\n");
#if ($pkg =~ m/^3/) {
#$ssh->print("123qwe");
#$ssh->waitfor('root');
#                   }

#if ($pkg =~ m/^4/) {
#$ssh->print("S\@msung1te");
#$ssh->waitfor('root');
#                   }

$ssh->print("123qwe");
my $Log = $ssh->waitfor('UAMA');

print ("$Log\n");

if (($Log =~ m/failure/) || ($Log =~ m/incorrect\s+password/)){

$ssh->print("su -");
$ssh->waitfor('Password:');


$ssh->print("S\@msung1te");
my $LOG = $ssh->waitfor('UAMA');
print ("$Log\n");
}

$ssh->print("cd /pkg");
my $log = $ssh->waitfor('/pkg');
print ("$log\n");

$ssh->print("cd $pkg");
my $log = $ssh->waitfor('root');
print ("$log\n");

$ssh->print("cd ENB/r-01/bin");
my $log = $ssh->waitfor('/ENB/r-01/bin>');
print ("$log\n");
#if ($pkg =~ m/^3/) {
$ssh->print("cli.opw");
$ssh->waitfor('USERNAME :');
 #                  }

#if ($pkg =~ m/^4/) {
#$ssh->print("cli.otm");
#$ssh->waitfor('USERNAME :');
#                   }
				   
my ($user_pkg, $pass_pkg);

my $pkg_info = "$pkg";
$pkg_info =~ s/\s+//g;




$user_pkg = "ROOT";
$pass_pkg = "ROOT";



$ssh->print("$user_pkg");
my $log = $ssh->waitfor('PASSWORD :');
print ("$log\n");


$ssh->print("$pass_pkg");
my $log = $ssh->waitfor('] ');
print ("$log\n");

sleep 5;









$value .= "\n----->TEST-TXPWR WITHOUT OCNS\n\n";

&TEST_TXPWR(0,0,0,NO_OCNS,TEST_TXPWR,0);
&TEST_TXPWR(1,0,1,NO_OCNS,TEST_TXPWR,0);
&TEST_TXPWR(2,0,2,NO_OCNS,TEST_TXPWR,0);


sub TEST_TXPWR {		#START TEST_TXPWR SUBROUTINE

if (($hash_cell_status{$_[0]} eq "EQUIP") && ($hash_CELL_STS_OP_STATE{$_[0]} eq "enabled")) {


$ssh->print("TEST-TXPWR:$_[1],$_[2];");

$ssh->waitfor('NOTIFY TEST RESULT');
sleep 5;
my $tst_pwr_no_ocns_0_0 = $ssh->waitfor(';');
$tst_pwr_no_ocns_0_0 = "$tst_pwr_no_ocns_0_0$colon";
print ("$tst_pwr_no_ocns_0_0\n");
$value .= "$tst_pwr_no_ocns_0_0";


my (@array_tst_pwr, $array_tst_pwr);
@array_tst_pwr = split(/\n/, $tst_pwr_no_ocns_0_0);


foreach $array_tst_pwr (@array_tst_pwr) {		#START FOREACH @ARRAY_TST_PWR
$array_tst_pwr =~ s/Tx RF Power/RF Pwr/g;
$array_tst_pwr =~ s/Fa0 Rssi/FA0 RSSI/g;


if (($array_tst_pwr =~ m/RF Pwr/) && ($array_tst_pwr =~ m/\(dBm\)/)) {	#get RF PWR value
$array_tst_pwr =~ s/^\s+//g;
my (@array, $array);
@array = split(/\=/, $array_tst_pwr);
$array[1] =~ s/^\s+//g;
my (@array_each_pwr, $array_each_pwr);
@array_each_pwr = split(/\s+/, $array[1]);
$RF_PWR = $array_each_pwr[0];
$RF_PWR =~ s/\s+//g;
$RF_PWR_1 = $array_each_pwr[1];
$RF_PWR_1 =~ s/\s+//g;

                                                                     }

if (($array_tst_pwr =~ m/FA0 RSSI/) && ($array_tst_pwr =~ m/\(dBm\)/)) {			#get RSSI value
$array_tst_pwr =~ s/^\s+//g;
my (@array, $array);
@array = split(/\=/, $array_tst_pwr);
$array[1] =~ s/^\s+//g;
my (@array_each_rssi, $array_each_rssi);
@array_each_rssi = split(/\s+/, $array[1]);
$RSSI = $array_each_rssi[0];
$RSSI =~ s/\s+//g;
$RSSI_1 = $array_each_rssi[1];
$RSSI_1 =~ s/\s+//g;
$RSSI_2 = $array_each_rssi[2];
$RSSI_2 =~ s/\s+//g;
$RSSI_3 = $array_each_rssi[3];
$RSSI_3 =~ s/\s+//g;

#print ("$RSSI $RSSI_1 $RSSI_2 $RSSI_3\n");
                                                                      }

#place here


                                        }		#END FOREACH @ARRAY_TST_PWR

#print ("$_[0] $_[1] $_[2] $RF_PWR $RF_PWR_1 $RSSI $RSSI_1 $_[3] $_[4] $_[5]\n");
#$value .= "$_[0] $_[1] $_[2] $RF_PWR $RF_PWR_1 $RSSI $RSSI_1 $_[3] $_[4] $_[5]";

$hash_TEST_TXPWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{RF_PWR}{PORT_0} = "$RF_PWR";
$hash_TEST_TXPWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{RF_PWR}{PORT_1} = "$RF_PWR_1";



$hash_TEST_TXPWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{RSSI}{PORT_0} = "$RSSI";
$hash_TEST_TXPWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{RSSI}{PORT_1} = "$RSSI_1";
$hash_TEST_TXPWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{RSSI}{PORT_2} = "$RSSI_2";
$hash_TEST_TXPWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{RSSI}{PORT_3} = "$RSSI_3";

                                      }


               }		#END TEST_TXPWR SUBROUTINE



$value .= "\n----->TEST-VSWR WITHOUT OCNS\n\n";


&TEST_VSWR(0,0,0,NO_OCNS,TEST_VSWR,0);
&TEST_VSWR(1,0,1,NO_OCNS,TEST_VSWR,0);
&TEST_VSWR(2,0,2,NO_OCNS,TEST_VSWR,0);

sub TEST_VSWR {			#START TEST_VSWR SUBROUTINE
if (($hash_cell_status{$_[0]} eq "EQUIP") && ($hash_CELL_STS_OP_STATE{$_[0]} eq "enabled")) {
$ssh->print("TEST-VSWR:$_[1],$_[2];");
$ssh->waitfor('NOTIFY TEST RESULT');
sleep 5;
my $tst_vswr_no_ocns_0_0 = $ssh->waitfor(';');
$tst_vswr_no_ocns_0_0 = "$tst_vswr_no_ocns_0_0$colon";
print ("$tst_vswr_no_ocns_0_0\n");
$value .= "$tst_vswr_no_ocns_0_0";


my (@array_tst_vswr, $array_tst_vswr);
@array_tst_vswr = split(/\n/, $tst_vswr_no_ocns_0_0);


foreach $array_tst_vswr (@array_tst_vswr) {		#START FOREACH ARRAY_TST_VSWR
$array_tst_vswr =~ s/Vswr/VSWR/g;

if ($array_tst_vswr =~ m/VSWR\s+\=/) {				#get VSWR value
$array_tst_vswr =~ s/^\s+//g;
my (@array, $array);
@array = split(/\=/, $array_tst_vswr);
$array[1] =~ s/^\s+//g;
my (@array_each_vswr, $array_each_vswr);
@array_each_vswr = split(/\s+/, $array[1]);
$VSWR = $array_each_vswr[0];
$VSWR =~ s/\s+//g;
$VSWR_1 = $array_each_vswr[1];
$VSWR_1 =~ s/\s+//g;


                                     }

#place here


                                          }		#END FOREACH ARRAY_TST_VSWR


#print ("$_[0] $_[1] $_[2] $VSWR $VSWR_1 $_[3] $_[4] $_[5]\n");
#$value .= "$_[0] $_[1] $_[2] $VSWR $VSWR_1 $_[3] $_[4] $_[5]";
$hash_TEST_VSWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{VSWR}{PORT_0} = "$VSWR";
$hash_TEST_VSWR{$_[0]}{$_[1]}{$_[2]}{$_[3]}{$_[5]}{VSWR}{PORT_1} = "$VSWR_1";



                                      }
              }			#END TEST_VSWR SUBROUTINE




$value .= "\n----->TEST-OCNS\n\n";

&TEST_OCNS(0,OCNS_SET);
&TEST_OCNS(1,OCNS_SET);
&TEST_OCNS(2,OCNS_SET);


&SLEEP;

$value .= "\n----->SLEEP 1 MINUTE\n\n";

sub SLEEP {
print ("PLEASE WAIT - SLEEP 1 MIN\n");

$ssh->print("RTRV-ALM-LIST;");
$ssh->waitfor('RETRIEVE ACTIVE ALARMS');
sleep 6;
my $ALARMS_SLEEP = $ssh->waitfor(';');
#print ("$ALARMS_SLEEP\n");
sleep 6;

$ssh->print("RTRV-ALM-LIST;");
$ssh->waitfor('RETRIEVE ACTIVE ALARMS');
sleep 6;
my $ALARMS_SLEEP = $ssh->waitfor(';');
#print ("$ALARMS_SLEEP\n");
sleep 6;

$ssh->print("RTRV-ALM-LIST;");
$ssh->waitfor('RETRIEVE ACTIVE ALARMS');
sleep 6;
my $ALARMS_SLEEP = $ssh->waitfor(';');
#print ("$ALARMS_SLEEP\n");
sleep 6;

$ssh->print("RTRV-ALM-LIST;");
$ssh->waitfor('RETRIEVE ACTIVE ALARMS');
sleep 6;
my $ALARMS_SLEEP = $ssh->waitfor(';');
#print ("$ALARMS_SLEEP\n");
sleep 6;

$ssh->print("RTRV-ALM-LIST;");
$ssh->waitfor('RETRIEVE ACTIVE ALARMS');
sleep 6;
my $ALARMS_SLEEP = $ssh->waitfor(';');
#print ("$ALARMS_SLEEP\n");
sleep 6;
          }






sub TEST_OCNS {			#START TEST_OCNS SUBROUTINE
if (($hash_cell_status{$_[0]} eq "EQUIP") && ($hash_CELL_STS_OP_STATE{$_[0]} eq "enabled")) {
$ssh->print("TEST-OCNS:$_[0],QPSK,PORTION_100;");
$ssh->waitfor('NOTIFY TEST RESULT');
sleep 5;
my $tst_ocns_0 = $ssh->waitfor(';');
$tst_ocns_0 = "$tst_ocns_0$colon";
print ("$tst_ocns_0\n");
sleep 5;
$value .= "$tst_ocns_0";

my (@array_tst_ocns, $array_tst_ocns);
@array_tst_ocns = split(/\n/, $tst_ocns_0);

foreach $array_tst_ocns (@array_tst_ocns) {		#START FOREACH ARRAY_TST_OCNS

$array_tst_ocns =~ s/Error Reason/ErrorReason/g;
$array_tst_ocns =~ s/ModulationId/Modulation/g;
$array_tst_ocns =~ s/Cell Load/CellLoad/g;
$array_tst_ocns =~ s/Test State/TestState/g;

if ($array_tst_ocns =~ m/Result\s+\=/) {		#get Result
$array_tst_ocns =~ s/^\s+//g;
my (@array, $array);
@array = split(/\=/, $array_tst_ocns);
$array[1] =~ s/\s+//g;
$Result = "$array[1]";
$Result =~ s/^\s//g;
$Result =~ s/\s+$//g;
                                       }

if ($array_tst_ocns =~ m/ErrorReason\s+\=/) {		#get ErrorReason
$array_tst_ocns =~ s/^\s+//g;
my (@array, $array);
@array = split(/\=/, $array_tst_ocns);
$ErrorReason = "$array[1]";
$ErrorReason =~ s/^\s//g;
$ErrorReason =~ s/\s+$//g;
                                            }

if ($array_tst_ocns =~ m/Modulation\s+\=/) {		#get ModulationId
$array_tst_ocns =~ s/^\s+//g;
my (@array, $array);
@array = split(/\=/, $array_tst_ocns);
$ModulationId = "$array[1]";
$ModulationId =~ s/^\s//g;
$ModulationId =~ s/\s+$//g;
                                           }

if ($array_tst_ocns =~ m/CellLoad\s+\=/) {		#get CellLoad
$array_tst_ocns =~ s/^\s+//g;
my (@array, $array);
@array = split(/\s+/, $array_tst_ocns);
$CellLoad = "$array[2]";
$CellLoad =~ s/^\s//g;
$CellLoad =~ s/\s+$//g;
                                         }

if ($array_tst_ocns =~ m/TestState\s+\=/) {		#get TestState
$array_tst_ocns =~ s/^\s+//g;
my (@array, $array);
@array = split(/\s+/, $array_tst_ocns);
$TestState = "$array[2]";
$TestState =~ s/^\s//g;
$TestState =~ s/\s+$//g;
                                          }

#place here


                                          }		#END FOREACH ARRAY_TST_OCNS

#print ("$_[0] $_[1] $Result $ErrorReason $ModulationId $CellLoad $TestState\n");
#$value .= "$_[0] $_[1] $Result $ErrorReason $ModulationId $CellLoad $TestState";

$hash_OCNS{$_[0]}{$_[1]}{RESULT} = "$Result";
$hash_OCNS{$_[0]}{$_[1]}{ERROR_REASON} = "$ErrorReason";
$hash_OCNS{$_[0]}{$_[1]}{MODULATION_ID} = "$ModulationId";
$hash_OCNS{$_[0]}{$_[1]}{CELL_LOAD} = "$CellLoad";
$hash_OCNS{$_[0]}{$_[1]}{TEST_STATE} = "$TestState";

                                         }

              }			#END TEST_OCNS SUBROUTINE


$value .= "\n----->TEST-TXPWR WITH OCNS PASS 1\n\n";

#####################################
# START TEST-TXPWR WITH OCNS PASS 1 #
#####################################
&TEST_TXPWR(0,0,0,OCNS,TEST_TXPWR,1);
&TEST_TXPWR(1,0,1,OCNS,TEST_TXPWR,1);
&TEST_TXPWR(2,0,2,OCNS,TEST_TXPWR,1);
#####################################
#  END TEST-TXPWR WITH OCNS PASS 1  #
#####################################

$value .= "\n----->TEST_VSWR WITH OCNS PASS 1\n\n";

####################################
# START TEST_VSWR WITH OCNS PASS 1 #
####################################
&TEST_VSWR(0,0,0,OCNS,TEST_VSWR,1);
&TEST_VSWR(1,0,1,OCNS,TEST_VSWR,1);
&TEST_VSWR(2,0,2,OCNS,TEST_VSWR,1);
####################################
#  END TEST_VSWR WITH OCNS PASS 1  #
####################################

&SLEEP;

$value .= "\n----->SLEEP 1 MINUTE\n\n";

$value .= "\n----->TEST-TXPWR WITH OCNS PASS 2\n\n";

#####################################
# START TEST-TXPWR WITH OCNS PASS 2 #
#####################################
&TEST_TXPWR(0,0,0,OCNS,TEST_TXPWR,2);
&TEST_TXPWR(1,0,1,OCNS,TEST_TXPWR,2);
&TEST_TXPWR(2,0,2,OCNS,TEST_TXPWR,2);
#####################################
#  END TEST-TXPWR WITH OCNS PASS 2  #
#####################################

$value .= "\n----->TEST_VSWR WITH OCNS PASS 2\n\n";

####################################
# START TEST_VSWR WITH OCNS PASS 2 #
####################################
&TEST_VSWR(0,0,0,OCNS,TEST_VSWR,2);
&TEST_VSWR(1,0,1,OCNS,TEST_VSWR,2);
&TEST_VSWR(2,0,2,OCNS,TEST_VSWR,2);
####################################
#  END TEST_VSWR WITH OCNS PASS 2  #
####################################


&SLEEP;

$value .= "\n----->SLEEP 1 MINUTE\n\n";

$value .= "\n----->TEST-TXPWR WITH OCNS PASS 3\n\n";

#####################################
# START TEST-TXPWR WITH OCNS PASS 3 #
#####################################
&TEST_TXPWR(0,0,0,OCNS,TEST_TXPWR,3);
&TEST_TXPWR(1,0,1,OCNS,TEST_TXPWR,3);
&TEST_TXPWR(2,0,2,OCNS,TEST_TXPWR,3);
#####################################
#  END TEST-TXPWR WITH OCNS PASS 3  #
#####################################

$value .= "\n----->TEST_VSWR WITH OCNS PASS 3\n\n";

####################################
# START TEST_VSWR WITH OCNS PASS 3 #
####################################
&TEST_VSWR(0,0,0,OCNS,TEST_VSWR,3);
&TEST_VSWR(1,0,1,OCNS,TEST_VSWR,3);
&TEST_VSWR(2,0,2,OCNS,TEST_VSWR,3);
####################################
#  END TEST_VSWR WITH OCNS PASS 3  #
####################################



$value .= "\n----->MON-TEST\n\n";



$ssh->print("MON-TEST;");
sleep 5;
$ssh->waitfor('MONITOR TEST STATUS');
sleep 5;
my $mon_test = $ssh->waitfor(';');
$mon_test = "$mon_test$colon";
print ("$mon_test\n");
$value .= "$mon_test";


$value .= "\n----->TERM-TEST\n\n";

&TERM_TEST(0,0,TERM_OCNS);
&TERM_TEST(1,1,TERM_OCNS);
&TERM_TEST(2,2,TERM_OCNS);


sub TERM_TEST {				#START TERM_TEST SUBROUTINE


if (($hash_cell_status{$_[0]} eq "EQUIP") && ($hash_CELL_STS_OP_STATE{$_[0]} eq "enabled")) {
$ssh->print("TERM-TEST:$_[1];");
$ssh->waitfor('NOTIFY TEST RESULT');
sleep 5;
my $term_test_0 = $ssh->waitfor(';');
$term_test_0 = "$term_test_0$colon";
print ("$term_test_0\n");
$value .= "$term_test_0";


my (@array_term_test, $array_term_test);
@array_term_test = split(/\n/, $term_test_0);

foreach $array_term_test (@array_term_test) {		#START FOREACH ARRAY_TST_OCNS

$array_term_test =~ s/^\s+//g;

if ($array_term_test =~ m/Test State\s+\=/) {		#get Test State
$array_term_test =~ s/^\s+//g;
my (@array, $array);
@array = split(/\=/, $array_term_test);
$array[1] =~ s/\s+//g;
$Test_State = $array[1];
                                                      }
if ($array_term_test =~ m/TEST_OUTCOME\s+\=/) {	#get TEST_OUTCOME
$array_term_test =~ s/^\s+//g;
@array = split(/\=/, $array_term_test);
$array[1] =~ s/\s+//g;
$TEST_OUTCOME = $array[1];
                                                      }

                                            }		#END FOREACH ARRAY_TST_OCNS

#print ("$_[0] $_[1] $_[2] $Test_State $TEST_OUTCOME\n");
#$value .= "$_[0] $_[1] $_[2] $Test_State $TEST_OUTCOME";

$hash_OCNS{$_[0]}{$_[2]}{TEST_STATE} = "$Test_State";
$hash_OCNS{$_[0]}{$_[2]}{TEST_OUTCOME} = "$TEST_OUTCOME";


                                         }


              }				#END TERM_TEST SUBROUTINE




$ssh->print("exit;");
$ssh->waitfor('/ENB/r-01/bin>');


$ssh->print("exit");
$ssh->waitfor('lteuser');

$ssh->print("exit");
$ssh->waitfor(']');

                                      }		#END IF $equip_count ne $disable_count


##############################
# START GET ALARM LIST & LOG #
##############################
$ssh->print("cmd $enodeb RTRV-ALM-LIST;");
$ssh->waitfor(';');
$ssh->waitfor(' ]');
my $RTRV_ALM_LIST = $ssh->waitfor(';');
$RTRV_ALM_LIST = "$RTRV_ALM_LIST$colon";
print ("$RTRV_ALM_LIST\n");
$value .= "$RTRV_ALM_LIST";



if ($RTRV_ALM_LIST =~ m/REASON\s+\=\s+NO\s+DATA/) {
$ALARM_NO_DATA = "YES";
                                                  }

else {				#START ELSE IF ALARMS
my (@each_line_4g_alm, $each_line_4g_alm);

@each_line_4g_alm = split(/\n/, $RTRV_ALM_LIST);

my $NUMBER = 1;
foreach $each_line_4g_alm (@each_line_4g_alm) {
my $UNIT = "";
my $ALARM_TYPE = "";
my $LOCATION = "";
my $RAISED_TIME = "";
my $PROBABLE_CAUSE = "";
my $SEVERITY = "";
my $ALARM_CODE = "";


$each_line_4g_alm =~ s/^\s+//g;
if (($each_line_4g_alm =~ m/critical/) || ($each_line_4g_alm =~ m/major/) || ($each_line_4g_alm =~ m/minor/)) {
@_ = split(/\s+/, $each_line_4g_alm);

$UNIT = "$_[0]";
$ALARM_TYPE = "$_[1]";
$LOCATION = "$_[2]";
$RAISED_TIME = "$_[3] $_[4]";
$PROBABLE_CAUSE = "$_[6]";
$SEVERITY = "$_[7]";
$ALARM_CODE = "$_[8]";

$hash_ALM_4G{$NUMBER}{UNIT} = "$UNIT";
$hash_ALM_4G{$NUMBER}{ALARM_TYPE} = "$ALARM_TYPE";
$hash_ALM_4G{$NUMBER}{LOCATION} = "$LOCATION";
$hash_ALM_4G{$NUMBER}{RAISED_TIME} = "$RAISED_TIME";
$hash_ALM_4G{$NUMBER}{PROBABLE_CAUSE} = "$PROBABLE_CAUSE";
$hash_ALM_4G{$NUMBER}{SEVERITY} = "$SEVERITY";
$hash_ALM_4G{$NUMBER}{ALARM_CODE} = "$ALARM_CODE";

#print ("$NUMBER $UNIT $ALARM_TYPE $LOCATION $RAISED_TIME $PROBABLE_CAUSE $SEVERITY $ALARM_CODE\n");
$NUMBER++;

                                                                                                              }

                                              }
#print Dumper(\%hash_ALM_4G);

     }				#END ELSE IF ALARMS

$ssh->print("cmd $enodeb RTRV-ALM-LOG;");
$ssh->waitfor(';');
$ssh->waitfor(' ]');
my $RTRV_ALM_LOG = $ssh->waitfor(';');
$RTRV_ALM_LOG = "$RTRV_ALM_LOG$colon";
print ("$RTRV_ALM_LOG\n");
$value .= "$RTRV_ALM_LOG";
##############################
#  END GET ALARM LIST & LOG  #
##############################


######################
#  START LOCK CELLS  #
######################
&CHG_CELL_CONF(0,locked);
&CHG_CELL_CONF(1,locked);
&CHG_CELL_CONF(2,locked);
######################
#   END LOCK CELLS   #
######################


$ssh->print('exit');

$ssh->disconnect;

#################
#  END SSH LSM  #
#################


my $eNB = "eNB";
###########################
# START SAVE LOGS TO FILE #
###########################
open (FILE, ">$Bin\\DATA_COLLECTED\\ATP_4G_1900\_$cascade\_$eNB$enode_num\_$year$month$mday\.txt");
if (($hash_CELL_STS_OP_STATE{0} eq "disabled") || ($hash_CELL_STS_OP_STATE{1} eq "disabled") || ($hash_CELL_STS_OP_STATE{2} eq "disabled")) {
print (FILE "NOTE:THIS IS AN INVALID REPORT - OPERATIONAL_STATE IS disabled\n\n\n");

                                                                                                                                            }
print (FILE "$value\n");

close (FILE);
###########################
#  END SAVE LOGS TO FILE  #
###########################

#print Dumper(\%hash_TEST_TXPWR);
#print Dumper(\%hash_TEST_VSWR);
#print Dumper(\%hash_OCNS);


################
# START REPORT #
################
open (HTMLFILE, ">$Bin\\REPORTS\\4G_1900_ATP_Report\_$cascade\_$eNB$enode_num\_$year$month$mday\.html");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=0>\n");
print (HTMLFILE "<tr><td align=center><font size=+3>$cascade $eNB$enode_num 4G 1900 ATP REPORT  For $day $month_full $mday $year $hour:$minute:$second</font></td></tr>\n");
if (($hash_CELL_STS_OP_STATE{0} eq "disabled") || ($hash_CELL_STS_OP_STATE{1} eq "disabled") || ($hash_CELL_STS_OP_STATE{2} eq "disabled")) {
print (HTMLFILE "<tr><td align=center bgcolor=#FF0000><font size=+3>NOTE:THIS IS AN INVALID REPORT - OPERATIONAL_STATE IS disabled</font></td></tr>\n");

                                                                                                                                            }

print (HTMLFILE "</table>\n");

#######################
# START RTRV-CELL-STS #
#######################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=3 align=center bgcolor=#FFFF00><b>RTRV-CELL-STS - RETRIEVE CELL STATE/STATUS</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>CELL_NUM</th>\n");
print (HTMLFILE "<th>OPERATIONAL_STATE</th>\n");
print (HTMLFILE "<th>USAGE_STATE</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_CELL_STS_OP_STATE) {				#START FOREACH CELL_NUM
my $OPERATIONAL_STATE = $hash_CELL_STS_OP_STATE{$CELL_NUM};
my $USAGE_STATE = $hash_CELL_STS_USE_STATE{$CELL_NUM};

print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
if ($OPERATIONAL_STATE eq "enabled") {
print (HTMLFILE "<td>$OPERATIONAL_STATE</td>\n");
                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$OPERATIONAL_STATE</td>\n");
     }
print (HTMLFILE "<td>$USAGE_STATE</td>\n");
print (HTMLFILE "</tr>\n");


                                                                }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

#######################
#  END RTRV-CELL-STS  #
#######################

########################################
# START TEST_TYPE_TXPOWER WITHOUT OCNS #
########################################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=8 align=center bgcolor=#FFFF00><b>TEST_TYPE_TXPOWER WITHOUT OCNS</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 0)</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 0)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 2)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 3)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $RF_PWR = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{RF_PWR}{PORT_0}";
my $RF_PWR_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{RF_PWR}{PORT_1}";



my $RSSI = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{RSSI}{PORT_0}";
my $RSSI_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{RSSI}{PORT_1}";
my $RSSI_2 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{RSSI}{PORT_2}";
my $RSSI_3 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{RSSI}{PORT_3}";


print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($RF_PWR>=28) && ($RF_PWR<=32)) {
print (HTMLFILE "<td>$RF_PWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR</td>\n");
     }

if (($RF_PWR_1>=28) && ($RF_PWR_1<=32)) {
print (HTMLFILE "<td>$RF_PWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR_1</td>\n");
     }

if (($RSSI <= -102) && ($RSSI >= -108)) {
print (HTMLFILE "<td>$RSSI</td>\n");
                                        }


else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI</td>\n");
     }



if (($RSSI_1 <= -102) && ($RSSI_1 >= -108)) {
print (HTMLFILE "<td>$RSSI_1</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_1</td>\n");
     }


if (($RSSI_2 <= -102) && ($RSSI_2 >= -108)) {
print (HTMLFILE "<td>$RSSI_2</td>\n");
                                        }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_2</td>\n");
     }


if (($RSSI_3 <= -102) && ($RSSI_3 >= -108)) {
print (HTMLFILE "<td>$RSSI_3</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_3</td>\n");
     }


print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

########################################
#  END TEST_TYPE_TXPOWER WITHOUT OCNS  #
########################################




################################
# START TEST_VSWR WITHOUT OCNS #
################################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=4 align=center bgcolor=#FFFF00><b>TEST_VSWR WITHOUT OCNS</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>VSWR (Port 0)</th>\n");
print (HTMLFILE "<th>VSWR (Port 1)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $VSWR = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{VSWR}{PORT_0}";
my $VSWR_1 = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{NO_OCNS}{0}{VSWR}{PORT_1}";


print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($VSWR <= 1.5) && ($VSWR >= 1)) {
print (HTMLFILE "<td>$VSWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR</td>\n");
     }

if (($VSWR_1 <= 1.5) && ($VSWR_1 >= 1)) {
print (HTMLFILE "<td>$VSWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR_1</td>\n");
     }
print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

################################
#  END TEST_VSWR WITHOUT OCNS  #
################################





#####################################
# START TEST_TYPE_TXPOWER WITH OCNS #
#####################################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=8 align=center bgcolor=#FFFF00><b>TEST_TYPE_TXPOWER WITH OCNS (FIRST PASS)</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 0)</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 0)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 2)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 3)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $RF_PWR = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{RF_PWR}{PORT_0}";
my $RF_PWR_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{RF_PWR}{PORT_1}";
my $RSSI = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{RSSI}{PORT_0}";
my $RSSI_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{RSSI}{PORT_1}";
my $RSSI_2 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{RSSI}{PORT_2}";
my $RSSI_3 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{RSSI}{PORT_3}";


print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($RF_PWR>=38) && ($RF_PWR<=42)) {
print (HTMLFILE "<td>$RF_PWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR</td>\n");
     }

if (($RF_PWR_1>=38) && ($RF_PWR_1<=42)) {
print (HTMLFILE "<td>$RF_PWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR_1</td>\n");
     }

if (($RSSI <= -102) && ($RSSI >= -108)) {
print (HTMLFILE "<td>$RSSI</td>\n");
                                        }


else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI</td>\n");
     }



if (($RSSI_1 <= -102) && ($RSSI_1 >= -108)) {
print (HTMLFILE "<td>$RSSI_1</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_1</td>\n");
     }


if (($RSSI_2 <= -102) && ($RSSI_2 >= -108)) {
print (HTMLFILE "<td>$RSSI_2</td>\n");
                                        }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_2</td>\n");
     }


if (($RSSI_3 <= -102) && ($RSSI_3 >= -108)) {
print (HTMLFILE "<td>$RSSI_3</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_3</td>\n");
     }

print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

#####################################
#  END TEST_TYPE_TXPOWER WITH OCNS  #
#####################################


#############################
# START TEST_VSWR WITH OCNS #
#############################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=4 align=center bgcolor=#FFFF00><b>TEST_VSWR WITH OCNS (FIRST PASS)</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>VSWR (Port 0)</th>\n");
print (HTMLFILE "<th>VSWR (Port 1)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $VSWR = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{VSWR}{PORT_0}";
my $VSWR_1 = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{1}{VSWR}{PORT_1}";


print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($VSWR <= 1.5) && ($VSWR >= 1)) {
print (HTMLFILE "<td>$VSWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR</td>\n");
     }

if (($VSWR_1 <= 1.5) && ($VSWR_1 >= 1)) {
print (HTMLFILE "<td>$VSWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR_1</td>\n");
     }
print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

#############################
#  END TEST_VSWR WITH OCNS  #
#############################


#####################################
# START TEST_TYPE_TXPOWER WITH OCNS #
#####################################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=8 align=center bgcolor=#FFFF00><b>TEST_TYPE_TXPOWER WITH OCNS (SECOND PASS)</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 0)</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 0)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 2)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 3)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $RF_PWR = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{RF_PWR}{PORT_0}";
my $RF_PWR_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{RF_PWR}{PORT_1}";
my $RSSI = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{RSSI}{PORT_0}";
my $RSSI_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{RSSI}{PORT_1}";
my $RSSI = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{RSSI}{PORT_2}";
my $RSSI_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{RSSI}{PORT_3}";

print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($RF_PWR>=38) && ($RF_PWR<=42)) {
print (HTMLFILE "<td>$RF_PWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR</td>\n");
     }

if (($RF_PWR_1>=38) && ($RF_PWR_1<=42)) {
print (HTMLFILE "<td>$RF_PWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR_1</td>\n");
     }
if (($RSSI <= -102) && ($RSSI >= -108)) {
print (HTMLFILE "<td>$RSSI</td>\n");
                                        }


else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI</td>\n");
     }



if (($RSSI_1 <= -102) && ($RSSI_1 >= -108)) {
print (HTMLFILE "<td>$RSSI_1</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_1</td>\n");
     }


if (($RSSI_2 <= -102) && ($RSSI_2 >= -108)) {
print (HTMLFILE "<td>$RSSI_2</td>\n");
                                        }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_2</td>\n");
     }


if (($RSSI_3 <= -102) && ($RSSI_3 >= -108)) {
print (HTMLFILE "<td>$RSSI_3</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_3</td>\n");
     }

print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

#####################################
#  END TEST_TYPE_TXPOWER WITH OCNS  #
#####################################


#############################
# START TEST_VSWR WITH OCNS #
#############################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=4 align=center bgcolor=#FFFF00><b>TEST_VSWR WITH OCNS (SECOND PASS)</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>VSWR (Port 0)</th>\n");
print (HTMLFILE "<th>VSWR (Port 1)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $VSWR = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{VSWR}{PORT_0}";
my $VSWR_1 = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{2}{VSWR}{PORT_1}";


print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($VSWR <= 1.5) && ($VSWR >= 1)) {
print (HTMLFILE "<td>$VSWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR</td>\n");
     }

if (($VSWR_1 <= 1.5) && ($VSWR_1 >= 1)) {
print (HTMLFILE "<td>$VSWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR_1</td>\n");
     }
print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

#############################
#  END TEST_VSWR WITH OCNS  #
#############################



#####################################
# START TEST_TYPE_TXPOWER WITH OCNS #
#####################################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=8 align=center bgcolor=#FFFF00><b>TEST_TYPE_TXPOWER WITH OCNS (THIRD PASS)</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 0)</th>\n");
print (HTMLFILE "<th>RF Pwr(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 0)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 1)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 2)</th>\n");
print (HTMLFILE "<th>FA0 RSSI(Port 3)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $RF_PWR = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{RF_PWR}{PORT_0}";
my $RF_PWR_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{RF_PWR}{PORT_1}";
my $RSSI = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{RSSI}{PORT_0}";
my $RSSI_1 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{RSSI}{PORT_1}";
my $RSSI_2 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{RSSI}{PORT_2}";
my $RSSI_3 = "$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{RSSI}{PORT_3}";

print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($RF_PWR>=38) && ($RF_PWR<=42)) {
print (HTMLFILE "<td>$RF_PWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR</td>\n");
     }

if (($RF_PWR_1>=38) && ($RF_PWR_1<=42)) {
print (HTMLFILE "<td>$RF_PWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RF_PWR_1</td>\n");
     }
if (($RSSI <= -102) && ($RSSI >= -108)) {
print (HTMLFILE "<td>$RSSI</td>\n");
                                        }


else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI</td>\n");
     }



if (($RSSI_1 <= -102) && ($RSSI_1 >= -108)) {
print (HTMLFILE "<td>$RSSI_1</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_1</td>\n");
     }


if (($RSSI_2 <= -102) && ($RSSI_2 >= -108)) {
print (HTMLFILE "<td>$RSSI_2</td>\n");
                                        }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_2</td>\n");
     }


if (($RSSI_3 <= -102) && ($RSSI_3 >= -108)) {
print (HTMLFILE "<td>$RSSI_3</td>\n");
                                            }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$RSSI_3</td>\n");
     }

print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

#####################################
#  END TEST_TYPE_TXPOWER WITH OCNS  #
#####################################


#############################
# START TEST_VSWR WITH OCNS #
#############################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=4 align=center bgcolor=#FFFF00><b>TEST_VSWR WITH OCNS (THIRD PASS)</b></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<th>BoardId</th>\n");
print (HTMLFILE "<th>PortId</th>\n");
print (HTMLFILE "<th>VSWR (Port 0)</th>\n");
print (HTMLFILE "<th>VSWR (Port 1)</th>\n");
print (HTMLFILE "</tr>\n");


foreach $CELL_NUM (sort {$a<=>$b} keys %hash_TEST_TXPWR) {				#START FOREACH CELL_NUM
foreach $BOARD_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}}) {		#START FOREACH BOARD_ID
foreach $PORT_ID (sort {$a<=>$b} keys %{$hash_TEST_TXPWR{$CELL_NUM}{$BOARD_ID}}) {	#START FOREACH PORT_ID
my $VSWR = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{VSWR}{PORT_0}";
my $VSWR_1 = "$hash_TEST_VSWR{$CELL_NUM}{$BOARD_ID}{$PORT_ID}{OCNS}{3}{VSWR}{PORT_1}";


print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$BOARD_ID</td>\n");
print (HTMLFILE "<td>$PORT_ID</td>\n");
if (($VSWR <= 1.5) && ($VSWR >= 1)) {
print (HTMLFILE "<td>$VSWR</td>\n");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR</td>\n");
     }

if (($VSWR_1 <= 1.5) && ($VSWR_1 >= 1)) {
print (HTMLFILE "<td>$VSWR_1</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$VSWR_1</td>\n");
     }
print (HTMLFILE "</tr>\n");


                                                                                 }	#END FOREACH PORT_ID
                                                                       }		#END FOREACH BOARD_ID
                                                         }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");

#############################
#  END TEST_VSWR WITH OCNS  #
#############################




###############################
# START TEST_OCNS & TERM_TEST #
###############################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=6 align=center bgcolor=#FFFF00><b>TEST_OCNS</b></td><td colspan=2 align=center bgcolor=#FFFF00><b>TERM-TEST</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CellNum</th><th align=center>ModulationId</th><th align=center>CellLoad</th><th align=center>TestState</th><th align=center>RESULT</th><th align=center>ErrorReason</th><th align=center>TEST_OUTCOME</th><th align=center>Test State</th></tr>\n");

foreach $CELL_NUM (sort {$a<=>$b} keys %hash_OCNS) {				#START FOREACH CELL_NUM

my $Result = "$hash_OCNS{$CELL_NUM}{OCNS_SET}{RESULT}";
my $ErrorReason = "$hash_OCNS{$CELL_NUM}{OCNS_SET}{ERROR_REASON}";
my $ModulationId = "$hash_OCNS{$CELL_NUM}{OCNS_SET}{MODULATION_ID}";
my $CellLoad = "$hash_OCNS{$CELL_NUM}{OCNS_SET}{CELL_LOAD}";
my $TestState_OCNS = "$hash_OCNS{$CELL_NUM}{OCNS_SET}{TEST_STATE}";


my $Test_State_TERM = "$hash_OCNS{$CELL_NUM}{TERM_OCNS}{TEST_STATE}";
my $TEST_OUTCOME = "$hash_OCNS{$CELL_NUM}{TERM_OCNS}{TEST_OUTCOME}";


print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
print (HTMLFILE "<td>$ModulationId</td>\n");
print (HTMLFILE "<td>$CellLoad</td>\n");
print (HTMLFILE "<td>$TestState_OCNS</td>\n");
if ($Result eq "OK") {
print (HTMLFILE "<td>$Result</td>\n");
                     }
if ($Result eq "NOK") {
print (HTMLFILE "<td bgcolor=#FF0000>$Result</td>\n");
                      }
if ($Result eq "OK") {
print (HTMLFILE "<td>$ErrorReason</td>\n");
                     }
if ($Result eq "NOK") {
print (HTMLFILE "<td bgcolor=#FF0000>$ErrorReason</td>\n");
                      }

if ($TEST_OUTCOME eq "TEST_OUTCOME_PASS") {
print (HTMLFILE "<td>$TEST_OUTCOME</td>\n");
	                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$TEST_OUTCOME</td>\n");
     }
	

if ($Test_State_TERM eq "TEST_STATE_TERMINATING") {
print (HTMLFILE "<td>$Test_State_TERM</td>\n");
                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$Test_State_TERM</td>\n");
     }




                                                   }				#END FOREACH CELL_NUM


print (HTMLFILE "</table><br><br>\n");
###############################
#  END TEST_OCNS & TERM_TEST  #
###############################





################
# START ALARMS #
################
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=6 align=center bgcolor=#FFFF00><b>RTRV-ALM-LIST - RETRIEVE ACTIVE ALARMS</b></td></tr>\n");

if ($ALARM_NO_DATA) {
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td align=center><font size = +2>$eNB$enode_num HAS NO ALARMS</font></td>\n");
print (HTMLFILE "</tr>\n");
                    }

else {
print (HTMLFILE "<tr><th align=center>ALARM_TYPE</th><th align=center>LOCATION</th><th align=center>RAISED_TIME</th><th align=center>PROBABLE_CAUSE</th><th align=center>SEVERITY</th><th align=center>ALARM_CODE</th></tr>\n");

foreach my $NUMBER (sort {$a<=>$b} keys %hash_ALM_4G) {

my $ALARM_TYPE = "$hash_ALM_4G{$NUMBER}{ALARM_TYPE}";
my $LOCATION = "$hash_ALM_4G{$NUMBER}{LOCATION}";
my $RAISED_TIME = "$hash_ALM_4G{$NUMBER}{RAISED_TIME}";
my $PROBABLE_CAUSE = "$hash_ALM_4G{$NUMBER}{PROBABLE_CAUSE}";
my $SEVERITY = "$hash_ALM_4G{$NUMBER}{SEVERITY}";
my $ALARM_CODE = "$hash_ALM_4G{$NUMBER}{ALARM_CODE}";



print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$ALARM_TYPE</td>\n");
print (HTMLFILE "<td>$LOCATION</td>\n");
print (HTMLFILE "<td>$RAISED_TIME</td>\n");
print (HTMLFILE "<td>$PROBABLE_CAUSE</td>\n");
print (HTMLFILE "<td>$SEVERITY</td>\n");
print (HTMLFILE "<td>$ALARM_CODE</td>\n");
print (HTMLFILE "</tr>\n");

                                                      }



     }


print (HTMLFILE "</table><br><br>\n");
################
#  END ALARMS  #
################





close (HTMLFILE);
################
#  END REPORT  #
################