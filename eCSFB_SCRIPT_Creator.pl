#!/usr/bin/perl
use POSIX;
use Net::SSH2;

use Control::CLI;
use Data::Dumper;

my (@input,$input);
@input = split(/,/,$ARGV[0]);

my ($Cascade,$BTS_ID,$BSM,$IP,$user,$pass);
my ($FA_ID,$OTA_SID,$OTA_NID,$BSC_SID,$BSC_NID,$Alpha_PN,$Beta_PN,$Gamma_PN,$reg_zone,$FA_INDEX_BSM,$secondBTS,$carrier,$fdd_enb,$fdd_ip,$fdd_user,$fdd_pass,$ltm,$daylight);
my (@FA_INDEX_BSM);
my ($pkg_num);
my($now);

my %hash_localtimes = (
'111.4.0.166' => '-24',
'111.4.0.198' => '-24',
'111.2.0.166' => '-24',
'111.10.0.166' => '-16',
'111.3.0.166' => '-24',
'111.3.0.198' => '-24',
'111.3.0.230' => '-24',
'111.9.0.166 ' => '-32',
'111.22.0.166' => '-20',
'111.23.0.166' => '-20',
'111.23.0.198' => '-20',
'111.1.0.68' => '-24',
'111.1.1.100' => '-24',
'111.15.0.166' => '-20',
'111.15.0.198' => '-20',
'111.24.0.166' => '-28',
'111.24.0.198' => '-28',
'111.25.0.166' => '-20',
'111.5.0.166' => '-20',
'111.21.0.166' => '-32',
'111.18.0.166' => '-20',
'111.18.0.198' => '-20',
'111.17.0.166' => '-20',
'111.17.0.198' => '-20',
'111.16.0.166' => '-20',
'111.26.0.198' => '-20',
'111.19.0.166' => '-24',
'111.19.0.198' => '-24',
'111.26.0.166' => '-24',
'111.26.0.198' => '-24',
'111.6.0.166' => '-32',
'111.27.0.166' => '-24',
'111.33.0.166' => '-20',
'111.14.0.166' => '-32',
'111.14.0.198' => '-32',
'111.28.0.166' => '-32',
'111.29.0.166' => '-20',
'111.11.0.166' => '-32',
'111.31.0.166' => '-28',
'111.31.0.198' => '-28',
'111.8.0.166' => '-32',
'111.7.0.166' => '-32',
'111.30.0.166' => '-20',
'111.12.0.166' => '-32',
'111.20.0.166' => '-24',
'111.13.0.166' => '-32',
'111.13.0.198' => '-32',
'111.34.0.166' => '-24',
'111.32.0.166' => '-20',
);

$now = strftime("%m%d%Y_%H_%M_%S", localtime);

my (@inputMulti,$inputMulti);
# chop($ARGV[0]);
@inputMulti = split(/~/,$ARGV[0]);


my $validate = `C:\\3G_4G_TOOL_Scripts\\bin\\validate.exe`;
chomp ($validate);if ($validate eq "expired"){
print ("ERROR: YOUR TOOLS HAS EXPIRED\n\n");
sleep 15;
exit;
                           }



if ($validate ne "true"){
print ("ERROR: YOU ARE NOT A VALID USER\n");
sleep 15;
exit;
                        }
                        
                        
foreach $inputMulti (@inputMulti){

    
my (@input);
@input = split(/,/,$inputMulti);     
$Cascade = $input[0];
$BTS_ID = $input[1];
$BSM = $input[2];
$IP = $input[3];
$eNB_Name = $input[4];
$secondBTS = $input[5];
$carrier = $input[6];
$ltm = $input[7];
$pkg_num = $input[8];
#$pkg_num = 1 is 3.5.x
#$pkg_num = 2 is 4.0.x


#print ("Cascade $Cascade\n");
#print ("BTS_ID $BTS_ID\n");
#print ("BSM $BSM\n");
#print ("IP $IP\n");
#print ("eNB_Name $eNB_Name\n");
#print ("secondBTS $secondBTS\n");
#print ("carrier $carrier\n");
#print ("ltm $ltm\n");
#print ("pkg_num $pkg_num\n");

#sleep 10;
#exit;
$user = "cdmaone";
$pass = "cdmaone";
	

# if ($IP ne "111.15.0.198"){
# $pass = "cdmaone";	
	
# }	

# if ($IP eq "111.15.0.198"){
# $pass = "cdmaone1";	
	
# }


	
if ($carrier ne "3"){	
 open (FILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\BSM_Log\\$Cascade\_$BTS_ID\_eCSFB_BSM_LOGS_$now.txt");			
 
my $ssh = new Control::CLI(Use => 'SSH',
                        Prompt => ']',
			Errmode=> 'return',
                        Timeout=> '240');

my $connect = $ssh->connect(Host => $IP,
          Username => $user,
          Password => $pass,
        PrivateKey => '.ssh/id_dsa');

if ($connect) {		

$ssh->print("cd");
$ssh->waitfor('/home1/cdmaone]');



# if ($IP eq "111.27.0.166"){
# $ssh->print("cmdx 1 RTRV-BTS_SUBSYSTEM-CONF:BTS=$BTS_ID;");
# }
# if ($IP ne "111.27.0.166"){
$ssh->print("cmdx 1 RTRV-BTS_SUBSYSTEM-CONF:BTS=$BTS_ID~$BTS_ID,EXPORT_CSV=NO;");	# }


$ssh->waitfor(';');
my $LOG = $ssh->waitfor('COMPLETED');	
print $LOG;
print FILE $LOG;


my (@split_each_line,$split_each_line);

@split_each_line = split (/\n/,$LOG);

foreach $split_each_line (@split_each_line){
	
		if ($split_each_line =~ m/\s+[FA DATA]/) {
		
		@_ = split (/\n/,$split_each_line);
		my (@fa, $fa);
		foreach $_ (@_){

			if ($_ =~ m/^\s+\d+/){
				
			    @fa	= split (/\s+/,$_);
			    if (($fa[5] eq "SERVICE_1X") && ($fa[1] ne "2")){
			    	push (@FA_INDEX_BSM,$fa[1]);
						      }	
									     }				
							}
							       }

					   }




$FA_INDEX_BSM = $FA_INDEX_BSM[0];
$ssh->print("cmdx 1 RTRV-BTS_FA-CONF:BTS=$BTS_ID~$BTS_ID,FA_INDEX=$FA_INDEX_BSM~$FA_INDEX_BSM;");
$ssh->waitfor(';');
my $LOG = $ssh->waitfor('COMPLETED');	
print $LOG;
print FILE $LOG;

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$LOG);

foreach $split_each_line (@split_each_line){
          
	if ($split_each_line =~ m/\s+STATUS/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g; 
		@_ = split(/\s+/, $split_each_line);
		foreach $_ (@_) {         			if ($split_each_line =~ m/\s+FA_ID/) {
				$split_each_line =~ s/\s+\:\s+/\:/g; 
				$split_each_line =~ s/^\s+//g; 
				@_ = split(/\s+/, $split_each_line);
				foreach $_ (@_) {
					if ($_ =~m/FA_ID/) {
						$_ =~ s/FA_ID://g;
						$FA_ID = $_;
						
						
							  }
						} 
						          } 
				}						}
	if ($split_each_line =~ m/\s+OTA_SID/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g; 
		@_ = split(/\s+/, $split_each_line);
		foreach $_ (@_) {
			if ($_ =~m/OTA_SID/) {
				$_ =~ s/OTA_SID://g;
				$OTA_SID = $_;

					     }
				} 
                                               }

	if ($split_each_line =~ m/\s+OTA_NID/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g; 
		@_ = split(/\s+/, $split_each_line);
		foreach $_ (@_) {
			if ($_ =~m/OTA_NID/) {
				$_ =~ s/OTA_NID://g;
				$OTA_NID = $_;

					     }
				} 
                                               }
                                               
}
if (($IP ne "111.2.0.166") && ($IP ne "111.19.0.166")){

$ssh->print("cmdx 1 RTRV-BSC_SID_NID_MAP_INDEX-DATA:NETWORK_INDEX=0~0;");
$ssh->waitfor(';');
my $LOG = $ssh->waitfor('COMPLETED');	
print $LOG;
print FILE $LOG;
my (@split_each_line,$split_each_line);

@split_each_line = split (/\n/,$LOG);
                                     
foreach $split_each_line (@split_each_line){
          
	if ($split_each_line =~ m/\s+USED_FLAG/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g;  
		@_ = split(/\s+/, $split_each_line);
		
			if ($_[1] =~ m/SID/){
				$_[1] =~ s/SID://g;
				$BSC_SID = $_[1];
								
				
			     }				if ($_[2] =~ m/^NID/){
				$_[2] =~ s/NID://g;
				$BSC_NID = $_[2];				
				
			     }	 		
						  		
		                                    					      }
					   }		
}


if ($IP eq "111.2.0.166"){
	$BSC_SID = "4384";
	$BSC_NID = "123";
	}
if ($IP eq "111.19.0.166"){
	$BSC_SID = "4155";
	$BSC_NID = "242";	
	
}




if (($OTA_SID eq "") || ($OTA_SID eq "0")){
	
	$OTA_SID = $BSC_SID;					}
if (($OTA_NID eq "") || ($OTA_NID eq "0")){
	
	$OTA_NID = $BSC_NID;
					}
if ($FA_ID ne ""){
$FA_ID = $FA_ID * 25;}
$ssh->print("cmdx 1 RTRV-BTS_SECTOR-CONF:BTS=$BTS_ID~$BTS_ID,SECTOR=0~0;");
$ssh->waitfor(';');
my $LOG = $ssh->waitfor('COMPLETED');	
print $LOG;
print FILE $LOG;


my (@split_each_line,$split_each_line);

@split_each_line = split (/\n/,$LOG);
                                     
foreach $split_each_line (@split_each_line){
          
	if ($split_each_line =~ m/\s+PILOT_OFFSET/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g;  
		@_ = split(/\s+/, $split_each_line);
		
			if ($_[0] =~ m/PILOT_OFFSET/){
				$_[0] =~ s/PILOT_OFFSET://g;
				$Alpha_PN = $_[0];
								
				
			     }		

					      }
					   }		


$ssh->print("cmdx 1 RTRV-BTS_SECTOR-CONF:BTS=$BTS_ID~$BTS_ID,SECTOR=1~1;");
$ssh->waitfor(';');
my $LOG = $ssh->waitfor('COMPLETED');	
print $LOG;
print FILE $LOG;



my (@split_each_line,$split_each_line);

@split_each_line = split (/\n/,$LOG);
                                     
foreach $split_each_line (@split_each_line){
          
	if ($split_each_line =~ m/\s+PILOT_OFFSET/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g;  
		@_ = split(/\s+/, $split_each_line);
		
			if ($_[0] =~ m/PILOT_OFFSET/){
				$_[0] =~ s/PILOT_OFFSET://g;
				$Beta_PN = $_[0];
								
				
			     }		

					      }
					   }
					   
					   $ssh->print("cmdx 1 RTRV-BTS_SECTOR-CONF:BTS=$BTS_ID~$BTS_ID,SECTOR=2~2;");
$ssh->waitfor(';');
my $LOG = $ssh->waitfor('COMPLETED');	
print $LOG;
print FILE $LOG;



my (@split_each_line,$split_each_line);

@split_each_line = split (/\n/,$LOG);
                                     
foreach $split_each_line (@split_each_line){
          
	if ($split_each_line =~ m/\s+PILOT_OFFSET/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g;  
		@_ = split(/\s+/, $split_each_line);
		
			if ($_[0] =~ m/PILOT_OFFSET/){
				$_[0] =~ s/PILOT_OFFSET://g;
				$Gamma_PN = $_[0];
								
				
			     }		

					      }
					   }

##########3 Reg zone

$ssh->print("cmdx 1 RTRV-BTS_PARA:BTS=$BTS_ID~$BTS_ID;");
$ssh->waitfor(';');
my $LOG = $ssh->waitfor('COMPLETED');	
print $LOG;
print FILE $LOG;



my (@split_each_line,$split_each_line);

@split_each_line = split (/\n/,$LOG);
                                     
foreach $split_each_line (@split_each_line){
          
	if ($split_each_line =~ m/\s+MAX_SLOT_CYCLE_INDEX/) {
		$split_each_line =~ s/\s+\:\s+/\:/g; 
		$split_each_line =~ s/^\s+//g;  
		@_ = split(/\s+/, $split_each_line);
		
				foreach $_ (@_) {
					if ($_ =~m/REG_ZONE/) {
						$_ =~ s/REG_ZONE://g;
						$reg_zone = $_;
						
						
							  }
						} 	

					      }
					   }



					   					   

$ssh->print('exit');

$ssh->disconnect;
	      }
	      
close FILE;

}

if ($carrier eq "3"){
	

open (SCRIPTFILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Script\\$Cascade\_$eNB_Name\_eCSFB_GP_$now.vbs");
	
print SCRIPTFILE "Sub Main\n";             
print SCRIPTFILE "xsh.Session.LogFilePath =\"C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Log\\$Cascade\_$eNB_Name\_eCSFB_GP_Log_$now.txt\"\n";  
print SCRIPTFILE "xsh.Session.StartLog\n";


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:0,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:1,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:2,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:3,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:4,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:5,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:6,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:7,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:8,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:9,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:10,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:11,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:12,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:13,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:14,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:15,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:16,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:17,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:18,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:19,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:20,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:21,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:22,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:23,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:24,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:25,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:26,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:27,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:28,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:29,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:30,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:31,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:0,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:1,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:2,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:3,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:4,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:5,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:6,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:7,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:8,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:0,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:1,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:2,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:3,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:4,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:5,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:6,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:7,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:8,1,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

if ($pkg_num eq "1") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:0,0,,,,,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:0,1,,,,,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:1,0,,,,,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:1,1,,,,,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:2,0,,,,,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:2,1,,,,,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
                    }
					
if ($pkg_num eq "2") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:0,0,,,,,310,120,preferred_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,100.0,EventB2,None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:0,1,,,,,310,120,preferred_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,100.0,EventB2,None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:1,0,,,,,310,120,preferred_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,100.0,EventB2,None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:1,1,,,,,310,120,preferred_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,100.0,EventB2,None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:2,0,,,,,310,120,preferred_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,100.0,EventB2,None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:2,1,,,,,310,120,preferred_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,True,FFF,FFF,not_allowed_prefer,100.0,EventB2,None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
                    }					

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:0,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:1,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:2,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PRD:0,StrongestCells,Active,1,240ms,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PRD:1,StrongestCells,Active,1,240ms,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PRD:2,StrongestCells,Active,1,240ms,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:0,,,,True,True,True,True,True,False,True,58,,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:1,,,,True,True,True,True,True,False,True,58,,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:2,,,,True,True,True,True,True,False,True,58,,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:0,,,1,1,,2,1,0,0,0,0,0,0,0,0,6,1,-1,-1,-1,-1,-1,-1,-1,1,2,-1,-1,-1,-1,3,-1,-1,-1,1,1,1,1,1,0,58,-1,3,-1,-1,310,0,0,-1,-1,-1,-1,-1,-1,-1,-1,1,56,64,56,56,0,28,3,0,0,10,30;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:1,,,1,1,,2,1,0,0,0,0,0,0,0,0,6,1,-1,-1,-1,-1,-1,-1,-1,1,2,-1,-1,-1,-1,3,-1,-1,-1,1,1,1,1,1,0,58,-1,3,-1,-1,310,0,0,-1,-1,-1,-1,-1,-1,-1,-1,1,56,64,56,56,0,28,3,0,0,10,30;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:2,,,1,1,,2,1,0,0,0,0,0,0,0,0,6,1,-1,-1,-1,-1,-1,-1,-1,1,2,-1,-1,-1,-1,3,-1,-1,-1,1,1,1,1,1,0,58,-1,3,-1,-1,310,0,0,-1,-1,-1,-1,-1,-1,-1,-1,1,56,64,56,56,0,28,3,0,0,10,30;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
print SCRIPTFILE "xsh.Session.StopLog\n";
print SCRIPTFILE "End Sub\n";


close SCRIPTFILE;

print "\n\nGP SCRIPT is now loaded to C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Script\n\n\n";
sleep 2;
}


      
# if (($FA_ID ne "") && ($BSC_SID ne "") && ($BSC_NID ne "")){      
# if ($FA_ID ne ""){      


if ($carrier eq "1"){
open (SCRIPTFILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Script\\$Cascade\_$eNB_Name\_eCSFB_NBR_SCRIPT_1st_Carrier_$now.vbs");


print SCRIPTFILE "Sub Main\n";             
print SCRIPTFILE "xsh.Session.LogFilePath =\"C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Log\\$Cascade\_$eNB_Name\_eCSFB_NBR_1st_Carrier_Log_$now.txt\"\n";  
print SCRIPTFILE "xsh.Session.StartLog\n";
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:0,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:1,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:2,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:0,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:1,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:2,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
if ($pkg_num eq "1") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:0,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:1,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:2,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";                      }
					 
if ($pkg_num eq "2") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:0,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:1,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:2,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=0,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=1,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=2,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";



print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:0,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:1,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:2,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";
if ($pkg_num eq "1") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:0,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:1,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:2,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";                      }

if ($pkg_num eq "2") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:0,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:1,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:2,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }					 
					 print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:0,$BSC_SID,$BSC_NID,$BTS_ID,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";   
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:1,$BSC_SID,$BSC_NID,$BTS_ID,2;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:2,$BSC_SID,$BSC_NID,$BTS_ID,3;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-LTIME-INF:DAYLIGHT_SAVE_TIME=1,LOCAL_TIME_OFF=$ltm,SUMMER_TIME_AUTO_SET_FUNC_STATUS=1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

#added 11/4/16 cw
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNBname CHG-LTIME-INF:DAYLIGHT_SAVE_TIME_INCLUDED=True,LOCAL_TIME_OFF=$hash_localtimes($IP);\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

# end added 11/4/16 cw


if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:0,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:0,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:0,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }


if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:1,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:1,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:1,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }
     


if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:2,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:2,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:2,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }

}

if ($carrier eq "2"){
	
open (SCRIPTFILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Script\\$Cascade\_$eNB_Name\_eCSFB_NBR_SCRIPT_2nd_Carrier_$now.vbs");


print SCRIPTFILE "Sub Main\n";             
print SCRIPTFILE "xsh.Session.LogFilePath =\"C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Log\\$Cascade\_$eNB_Name\_eCSFB_NBR_2nd_Carrier_Log_$now.txt\"\n";  
print SCRIPTFILE "xsh.Session.StartLog\n";	
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:3,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:4,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:5,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:3,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:4,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:5,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

if ($pkg_num eq "1") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:3,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:4,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:5,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }
					 
if ($pkg_num eq "2") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:3,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:4,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:5,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }					 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=3,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=4,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=5,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";





print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:3,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:4,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:5,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

if ($pkg_num eq "1") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:3,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:4,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:5,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }

					 
if ($pkg_num eq "2") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:3,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:4,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:5,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }
					 
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:3,$BSC_SID,$BSC_NID,$BTS_ID,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";   
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:4,$BSC_SID,$BSC_NID,$BTS_ID,2;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:5,$BSC_SID,$BSC_NID,$BTS_ID,3;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-LTIME-INF:DAYLIGHT_SAVE_TIME=1,LOCAL_TIME_OFF=$ltm,SUMMER_TIME_AUTO_SET_FUNC_STATUS=1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:3,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:3,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:3,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }



if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:4,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:4,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:4,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }
     


if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:5,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:5,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:5,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }
		    }
if ($carrier eq "4"){
	
open (SCRIPTFILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Script\\$Cascade\_$eNB_Name\_eCSFB_NBR_SCRIPT_2nd_Carrier_4T_$now.vbs");


print SCRIPTFILE "Sub Main\n";             
print SCRIPTFILE "xsh.Session.LogFilePath =\"C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Log\\$Cascade\_$eNB_Name\_eCSFB_NBR_2nd_Carrier_Log_$now.txt\"\n";  
print SCRIPTFILE "xsh.Session.StartLog\n";	

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:9,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:10,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-BCLS:11,N_EQUIP,bc0,0,16,16;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:9,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:10,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-ECSFB:11,0,1,24,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

if ($pkg_num eq "1") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:9,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:10,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:11,0,EQUIP,bc1,$FA_ID,0,310,120,preferred_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,FFF,FFF,not_allowed_prefer,100.0,EventB2,ci_None;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }

if ($pkg_num eq "2") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:9,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:10,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-FREQ:11,0,EQUIP,bc1,$FA_ID,0;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                     }					 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=9,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=10,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-MOBIL:CELL_NUM=11,S_ID=$OTA_SID,N_ID=$OTA_NID,REG_ZONE=$reg_zone;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";





print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:9,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";    
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:10,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";  
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-OVL:11,5,no_use,oDot25,oDot25,use;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

if ($pkg_num eq "1") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:9,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:10,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:11,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,2,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                    }

if ($pkg_num eq "2") {
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:9,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:10,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREG:11,use,$OTA_SID,$OTA_NID,True,True,True,True,True,False,True,58,$reg_zone,7,ci_min1,True;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
                    }					
					
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:9,$BSC_SID,$BSC_NID,$BTS_ID,1;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";   
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:10,$BSC_SID,$BSC_NID,$BTS_ID,2;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 
print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-C1XRTT-PREGSECTOR:11,$BSC_SID,$BSC_NID,$BTS_ID,3;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


# print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CHG-LTIME-INF:DAYLIGHT_SAVE_TIME=1,LOCAL_TIME_OFF=$ltm,SUMMER_TIME_AUTO_SET_FUNC_STATUS=1;\"\n";
# print SCRIPTFILE "xsh.Screen.Send VbCr\n";
# print SCRIPTFILE "xsh.Session.Sleep 3000\n"; 


if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:9,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:9,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:9,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }



if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:10,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:10,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:10,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }
     


if ($Alpha_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:11,1,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,1,bc1,$FA_ID,$Alpha_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 		

if ($Beta_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:11,2,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,2,bc1,$FA_ID,$Beta_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     } 

if ($Gamma_PN ne ""){

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name CRTE-NBR-C1XRTT:11,3,EQUIP,$BSC_SID,$BSC_NID,$BTS_ID,3,bc1,$FA_ID,$Gamma_PN,True,True,CreatedByUserCommand;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 5000\n"; 
	
     }

		    }
		    print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name RTRV-C1XRTT-PREG;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name RTRV-NBR-C1XRTT;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";

print SCRIPTFILE "xsh.Screen.send \"/usr/bin/sudo -u lsm /home/lsm/aceman/bin/cmd.sprint $eNB_Name RTRV-LTIME-INF;\"\n";
print SCRIPTFILE "xsh.Screen.Send VbCr\n";
print SCRIPTFILE "xsh.Session.Sleep 3000\n";     
print SCRIPTFILE "xsh.Session.StopLog\n";
print SCRIPTFILE "End Sub\n";
close SCRIPTFILE;
print "\n\nSCRIPT is now loaded to C:\\3G_4G_TOOL_Scripts\\2.5\\eCSFB_Script_Creator\\eCSFB_NBR_Script\n\n\n";sleep 2;
# }
# else {
	# if ($carrier ne "3"){
	# if ($FA_ID eq ""){
		# print "\n\nCAN NOT CREATE THE SCRIPT FA_ID IS NOT AVAILABLE\n";
		
			 # }	# if ($BSC_SID eq ""){
		# print "\n\nCAN NOT CREATE THE SCRIPT BSC SID IS NOT AVAILABLE\n";
		
			 # }	# if ($BSC_NID eq ""){
		# print "\n\nCAN NOT CREATE THE SCRIPT BSC NPO60XC161ID IS NOT AVAILABLE\n";
		
			 # }
	# }
# sleep 2;# }

}
