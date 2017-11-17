#!/usr/bin/perl
use FindBin qw($Bin);
use lib "$Bin/../lib";
use POSIX;
use Net::SSH2;
use Control::CLI;

#$Bin from FindBin will give path to directory from where alarm script was invoked

$Bin =~ s/\//\\/g;

use Data::Dumper;

##############
# Start TIME #
##############
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =localtime(time);

my $day = strftime "%a", localtime;	#day
$day =~ s/\s+//g;
my $month = strftime "%b", localtime;	#month
$month =~ s/\s+//g;
my $month_num = ($mon + 1);		#month number
my $year = strftime "%Y", localtime;	#year
$year =~ s/\s+//g;

my $hour = strftime "%H", localtime;	#time hour
$hour =~ s/\s+//g;
my $minute = strftime "%M", localtime;	#time minute
$minute =~ s/\s+//g;
my $second = strftime "%S", localtime;	#time seconds
$second =~ s/\s+//g;

#print ("$day $month $month_num $mday $year $hour:$minute:$second\n");

##############
#  End TIME  #
##############




print ("\n#########################################\n");
print ("#  RAN COMMISSIONING 3G & 4G AUDIT TOOL #\n");
print ("#########################################\n\n");







my $completed = "COMPLETED";


my ($enodeb_name, $enodeb_id);
my ($Cascade_ID, $bts_id, $enodeb_name, $enodeb_id, $onair_3g, $onair_4g, $onair_info, $onair_date_info, $market);
my ($bsm_name);
my ($bts_ip, $sector, $pn, $MMBS_Cabinet_Type, $carrier, $tilt, $GRM_COMBINER_EXCEL);
my ($Backhaul_Type, $MMBS_Qty, $Sectors_NUM);
my ($RRU_Qty_800, $RRU_Qty_1900, $CDMA_BBU_Qty);
my ($CICA_A_Qty_BBU1, $CICA_D_Qty_BBU1, $CICA_A_Qty_BBU2, $CICA_D_Qty_BBU2);
my ($NON_COMM_SID, $NON_COMM_NID);
my ($COMM_SID, $COMM_NID);
my ($bsm_ip_address);

my (%hash_non_comm_sid_1900, $hash_non_comm_sid_1900);
my (%hash_non_comm_sid_800, $hash_non_comm_sid_800);
my (%hash_non_comm_nid_1900, $hash_non_comm_nid_1900);
my (%hash_non_comm_nid_800, $hash_non_comm_nid_800);
my (%hash_comm_sid_1900, $hash_comm_sid_1900);
my (%hash_comm_sid_800, $hash_comm_sid_800);
my (%hash_comm_nid_1900, $hash_comm_nid_1900);
my (%hash_comm_nid_800, $hash_comm_nid_800);
%hash_non_comm_sid_1900 = ();
%hash_non_comm_sid_800 = ();
%hash_non_comm_nid_1900 = ();
%hash_non_comm_nid_800 = ();
%hash_comm_sid_1900 = ();
%hash_comm_sid_800 = ();
%hash_comm_nid_1900 = ();
%hash_comm_nid_800 = ();

my ($RRH_PORT_0, $RRH_PORT_1, $RRH_PORT_2, $RRH_PORT_3, $RRH_PORT_4, $RRH_PORT_5);
my ($Vlan16_CSR_OAM_IP_3G, $Vlan16_MMBS_OAM_IP_3G, $Vlan24_CSR_Side_IP_3G, $Vlan24_MMBS_Side_IP_3G);
my ($CSR_OAM_IP_4G, $MMBS_OAM_IP_4G, $CSR_S_B_IP_4G, $MMBS_S_B_IP_4G);
my ($color_code, $ltm_off);
my ($lat, $long);
my ($lsm_user, $lsm_pass);
my ($lsm_name, $lsm_ip);
my ($sector_pci_rach_tac, $pci, $rach, $freq, $MHz, $tac_hex);
my ($reg_zone, $m1_m2);
my (%hash_sector_pci_rach_tac, $hash_sector_pci_rach_tac);
my (%hash_pci, $hash_pci);
my (%hash_rach, $hash_rach);
my (%hash_tac, $hash_tac);
my (%hash_fa_carrier, $hash_fa_carrier);		#hash for fa carriers
%hash_sector_pci_rach_tac = ();
%hash_pci = ();
%hash_rach = ();
%hash_tac = ();
%hash_fa_carrier = ();


my ($SLOT_1, $SLOT_2, $SLOT_3);				#slots for 4g

my (%hash_CELL_UECNT, $hash_CELL_UECNT);
%hash_CELL_UECNT = ();

my (%hash_sector_excel, $hash_sector_excel);
my (%hash_pn_excel, $hash_pn_excel);
%hash_sector_excel = ();
%hash_pn_excel = ();

my (%hash_color_code_info, $hash_color_code_info);
%hash_color_code_info = ();

$hash_color_code_info{"DVNPIAHQ-IBSC-1"} = 100;	#Daven Port
$hash_color_code_info{"BRDVILBO-IBSC-1"} = 102;	#Bridgeview 1
$hash_color_code_info{"BRDVILBO-IBSC-2"} = 101;	#Bridgeview 2
$hash_color_code_info{"AURRILVN-IBSC-1"} = 99;	#Aurora 1
$hash_color_code_info{"ARLHILJQ-IBSC-1"} = 98;	#Arlington 1
$hash_color_code_info{"ARLHILJQ-IBSC-2"} = 97;	#Arlington 2
$hash_color_code_info{"ERIEPAUH-IBSC-1"} = 29;	#Erie
$hash_color_code_info{"FTWZINDW-IBSC-1"} = 16;	#Ft Wayne
$hash_color_code_info{"IPLTINWB-IBSC-1"} = 17;	#Indianapolis
$hash_color_code_info{"KNWDMIJD-IBSC-1"} = 20;	#Kentwood 1
$hash_color_code_info{"PITBPAWO-IBSC-1"} = 30;	#Pittsburg
$hash_color_code_info{"BYMNPRAG-IBSC-1"} = 100;	#Bayamon
$hash_color_code_info{"SPSPK_1"} = 12;		#Spokane
$hash_color_code_info{"SPKNWAGQ-IBSC-1"} = 12;	#Spokane
$hash_color_code_info{"STCDMNUC-IBSC-1"} = 60;	#St Cloud 1
$hash_color_code_info{"TGRDORDO-IBSC-1"} = 63;	#Tigard
$hash_color_code_info{"BRSBCABE-IBSC-1"} = 8;	#Brisbane
$hash_color_code_info{"SNTDCAIK-IBSC-1"} = 9;	#Santa Clara
$hash_color_code_info{"SNRSCARN-IBSC-1"} = 10;	#Santa Rosa
$hash_color_code_info{"SF-SANTR_1"} = 10;	#Santa Rosa
$hash_color_code_info{"OKLDCA61-IBSC-1"} = 11;	#Oakland
$hash_color_code_info{"SF-OAKLA_1"} = 11;	#Oakland
$hash_color_code_info{"DTRTMIPM-IBSC-1"} = 18;	#Detriot 1
$hash_color_code_info{"DTRTMIPM-IBSC-2"} = 19;	#Detriot 1
$hash_color_code_info{"LNNGMI55-IBSC-1"} = 22;	#Lansing 1
$hash_color_code_info{"LNNGMI55-IBSC-2"} = 23;	#Lansing 1
$hash_color_code_info{"RDMDWAJE-IBSC-2"} = 53;	#Redmond 1
$hash_color_code_info{"RDMDWAJE-IBSC-1"} = 52;	#Redmond 1
$hash_color_code_info{"MPLSMNCD-IBSC-1"} = 31;	#Minne
$hash_color_code_info{"MPLSMNCD-IBSC-2"} = 32;	#Minne
$hash_color_code_info{"NWBLWIDP-IBSC-1"} = 24;	#New Berlin
$hash_color_code_info{"NWBLWIDP-IBSC-2"} = 25;	#New Berlin
$hash_color_code_info{"CHKTNYFU-IBSC-1"} = 58;	#Cheektowaga
$hash_color_code_info{"CLEWOH20-IBSC-1"} = 28;	#Cleveland
$hash_color_code_info{"ENWDCO69-IBSC-1"} = 40;	#Englewood 1
$hash_color_code_info{"ENWDCO69-IBSC-2"} = 41;	#Englewood 2
$hash_color_code_info{"FRN-FRES_1"} = 42;	#Fresno
$hash_color_code_info{"FRSNCA72-IBSC-1"} = 42;	#Fresno
$hash_color_code_info{"OMAHNEXK-IBSC-1"} = 43;	#Omaha
$hash_color_code_info{"PITBPAWO-IBSC-1"} = 30;	#Pittsburgh
$hash_color_code_info{"RENPNVAT-IBSC-1"} = 55;	#Reno
$hash_color_code_info{"RNO-REN_1"} = 55;	#Reno
$hash_color_code_info{"ROCHNYAG-IBSC-1"} = 56;	#Rochester
$hash_color_code_info{"SAC-SACR_1"} = 72;	#Sacramento
$hash_color_code_info{"SCRMCAXJ-IBSC-1"} = 72;	#Sacramento
$hash_color_code_info{"SHAVOHDY-IBSC-1"} = 62;	#Sharonville
$hash_color_code_info{"SLC-SLTLK_1"} = 14;	#Salt Lake 1
$hash_color_code_info{"SLKDUTGN-IBSC-1"} = 14;	#Salt Lake 2
$hash_color_code_info{"SLC-SLTLK_2"} = 57;	#Salt Lake 1
$hash_color_code_info{"SLKDUTGN-IBSC-2"} = 57;	#Salt Lake 2
$hash_color_code_info{"SREDM_1"} = 12;		#Spokane
$hash_color_code_info{"SREDM_2"} = 12;		#Spokane
$hash_color_code_info{"URDLIACB-IBSC-1"} = 61;	#Urbandale
$hash_color_code_info{"WOTNOHDT-IBSC-1"} = 39;	#Worthington



my (%hash_ltm_off_info, $hash_ltm_off_info);
%hash_ltm_off_info = ();

$hash_ltm_off_info{"DVNPIAHQ-IBSC-1"} = "-12";	#Daven Port
$hash_ltm_off_info{"BRDVILBO-IBSC-1"} = "-12";	#Bridgeview 1
$hash_ltm_off_info{"BRDVILBO-IBSC-2"} = "-12";	#Bridgeview 2
$hash_ltm_off_info{"AURRILVN-IBSC-1"} = "-12";	#Aurora 1
$hash_ltm_off_info{"ARLHILJQ-IBSC-1"} = "-12";	#Arlington 1
$hash_ltm_off_info{"ARLHILJQ-IBSC-2"} = "-12";	#Arlington 2
$hash_ltm_off_info{"ERIEPAUH-IBSC-1"} = "-10";	#Erie
$hash_ltm_off_info{"FTWZINDW-IBSC-1"} = "-10";	#Ft Wayne
$hash_ltm_off_info{"IPLTINWB-IBSC-1"} = "-10";	#Indianapolis
$hash_ltm_off_info{"KNWDMIJD-IBSC-1"} = "-10";	#Kentwood 1
$hash_ltm_off_info{"PITBPAWO-IBSC-1"} = "-10";	#Pittsburg
$hash_ltm_off_info{"BYMNPRAG-IBSC-1"} = "-8";	#Bayamon
$hash_ltm_off_info{"SPSPK_1"} = "-16";		#Spokane
$hash_ltm_off_info{"SPKNWAGQ-IBSC-1"} = "-16";	#Spokane
$hash_ltm_off_info{"STCDMNUC-IBSC-1"} = "-12";	#St Cloud 1
$hash_ltm_off_info{"TGRDORDO-IBSC-1"} = "-16";	#Tigard
$hash_ltm_off_info{"BRSBCABE-IBSC-1"} = "-16";	#Brisbane
$hash_ltm_off_info{"SNTDCAIK-IBSC-1"} = "-16";	#Santa Clara
$hash_ltm_off_info{"SNRSCARN-IBSC-1"} = "-16";	#Santa Rosa
$hash_ltm_off_info{"SF-SANTR_1"} = "-16";	#Santa Rosa
$hash_ltm_off_info{"OKLDCA61-IBSC-1"} = "-16";	#Oakland
$hash_ltm_off_info{"SF-OAKLA_1"} = "-16";	#Oakland
$hash_ltm_off_info{"DTRTMIPM-IBSC-1"} = "-10";	#Detriot 1
$hash_ltm_off_info{"DTRTMIPM-IBSC-2"} = "-10";	#Detriot 1
$hash_ltm_off_info{"LNNGMI55-IBSC-1"} = "-10";	#Lansing 1
$hash_ltm_off_info{"LNNGMI55-IBSC-2"} = "-10";	#Lansing 1
$hash_ltm_off_info{"RDMDWAJE-IBSC-2"} = "-16";	#Redmond 1
$hash_ltm_off_info{"RDMDWAJE-IBSC-1"} = "-16";	#Redmond 1
$hash_ltm_off_info{"MPLSMNCD-IBSC-1"} = "-12";	#Minne
$hash_ltm_off_info{"MPLSMNCD-IBSC-2"} = "-12";	#Minne
$hash_ltm_off_info{"NWBLWIDP-IBSC-1"} = "-12";	#New Berlin
$hash_ltm_off_info{"NWBLWIDP-IBSC-2"} = "-12";	#New Berlin
$hash_ltm_off_info{"CHKTNYFU-IBSC-1"} = "-10";	#Cheektowaga
$hash_ltm_off_info{"CLEWOH20-IBSC-1"} = "-10";	#Cleveland
$hash_ltm_off_info{"ENWDCO69-IBSC-1"} = "-14";	#Englewood 1
$hash_ltm_off_info{"ENWDCO69-IBSC-2"} = "-14";	#Englewood 2
$hash_ltm_off_info{"FRN-FRES_1"} = "-16";	#Fresno
$hash_ltm_off_info{"FRSNCA72-IBSC-1"} = "-16";	#Fresno
$hash_ltm_off_info{"OMAHNEXK-IBSC-1"} = "-12";	#Omaha
$hash_ltm_off_info{"PITBPAWO-IBSC-1"} = "-10";	#Pittsburgh
$hash_ltm_off_info{"RENPNVAT-IBSC-1"} = "-14";	#Reno
$hash_ltm_off_info{"RNO-REN_1"} = "-14";	#Reno
$hash_ltm_off_info{"ROCHNYAG-IBSC-1"} = "-10";	#Rochester
$hash_ltm_off_info{"SAC-SACR_1"} = "-16";	#Sacramento
$hash_ltm_off_info{"SCRMCAXJ-IBSC-1"} = "-16";	#Sacramento
$hash_ltm_off_info{"SHAVOHDY-IBSC-1"} = "-10";	#Sharonville
$hash_ltm_off_info{"SLC-SLTLK_1"} = "-14";	#Salt Lake 1
$hash_ltm_off_info{"SLKDUTGN-IBSC-1"} = "-14";	#Salt Lake 2
$hash_ltm_off_info{"SLC-SLTLK_2"} = "-14";	#Salt Lake 1
$hash_ltm_off_info{"SLKDUTGN-IBSC-2"} = "-14";	#Salt Lake 2
$hash_ltm_off_info{"SREDM_1"} = "-16";		#Spokane
$hash_ltm_off_info{"SREDM_2"} = "-16";		#Spokane
$hash_ltm_off_info{"URDLIACB-IBSC-1"} = "-12";	#Urbandale
$hash_ltm_off_info{"WOTNOHDT-IBSC-1"} = "-10";	#Worthington




my (%hash_BSC_SID, $hash_BSC_SID);
%hash_BSC_SID = ();

$hash_BSC_SID{"DVNPIAHQ-IBSC-1"} = 4384;	#Daven Port
$hash_BSC_SID{"BRDVILBO-IBSC-1"} = 4384;	#Bridgeview 1
$hash_BSC_SID{"BRDVILBO-IBSC-2"} = 4384;	#Bridgeview 2
$hash_BSC_SID{"AURRILVN-IBSC-1"} = 4384;	#Aurora 1
$hash_BSC_SID{"ARLHILJQ-IBSC-1"} = 4384;	#Arlington 1
$hash_BSC_SID{"ARLHILJQ-IBSC-2"} = 4384;	#Arlington 2
$hash_BSC_SID{"ERIEPAUH-IBSC-1"} = 4162;	#Erie
$hash_BSC_SID{"FTWZINDW-IBSC-1"} = 4384;	#Ft Wayne
$hash_BSC_SID{"IPLTINWB-IBSC-1"} = 4135;	#Indianapolis
$hash_BSC_SID{"KNWDMIJD-IBSC-1"} = 4126;	#Kentwood 1
$hash_BSC_SID{"PITBPAWO-IBSC-1"} = 4171;	#Pittsburg
$hash_BSC_SID{"BYMNPRAG-IBSC-1"} = 5142;	#Bayamon
$hash_BSC_SID{"SPSPK_1"} = 4188;		#Spokane
$hash_BSC_SID{"SPKNWAGQ-IBSC-1"} = 4188;	#Spokane
$hash_BSC_SID{"STCDMNUC-IBSC-1"} = 4155;	#St Cloud 1
$hash_BSC_SID{"TGRDORDO-IBSC-1"} = 4174;	#Tigard
$hash_BSC_SID{"BRSBCABE-IBSC-1"} = 4183;	#Brisbane
$hash_BSC_SID{"SNTDCAIK-IBSC-1"} = 4183;	#Santa Clara
$hash_BSC_SID{"SNRSCARN-IBSC-1"} = 4183;	#Santa Rosa
$hash_BSC_SID{"SF-SANTR_1"} = 4183;		#Santa Rosa
$hash_BSC_SID{"OKLDCA61-IBSC-1"} = 4183;	#Oakland
$hash_BSC_SID{"SF-OAKLA_1"} = 4183;		#Oakland
$hash_BSC_SID{"DTRTMIPM-IBSC-1"} = 4126;	#Detriot 1
$hash_BSC_SID{"DTRTMIPM-IBSC-2"} = 4126;	#Detriot 1
$hash_BSC_SID{"LNNGMI55-IBSC-1"} = 4126;	#Lansing 1
$hash_BSC_SID{"LNNGMI55-IBSC-2"} = 4126;	#Lansing 1
$hash_BSC_SID{"RDMDWAJE-IBSC-2"} = 4186;	#Redmond 1
$hash_BSC_SID{"RDMDWAJE-IBSC-1"} = 4186;	#Redmond 1
$hash_BSC_SID{"MPLSMNCD-IBSC-1"} = 4155;	#Minne
$hash_BSC_SID{"MPLSMNCD-IBSC-2"} = 4155;	#Minne
$hash_BSC_SID{"NWBLWIDP-IBSC-1"} = 4153;	#New Berlin
$hash_BSC_SID{"NWBLWIDP-IBSC-2"} = 4153;	#New Berlin
$hash_BSC_SID{"CHKTNYFU-IBSC-1"} = 4107;	#Cheektowaga
$hash_BSC_SID{"CLEWOH20-IBSC-1"} = 4396;	#Cleveland
$hash_BSC_SID{"ENWDCO69-IBSC-1"} = 4121;	#Englewood 1
$hash_BSC_SID{"ENWDCO69-IBSC-2"} = 4121;	#Englewood 2
$hash_BSC_SID{"FRN-FRES_1"} = 4183;		#Fresno
$hash_BSC_SID{"FRSNCA72-IBSC-1"} = 4183;	#Fresno
$hash_BSC_SID{"OMAHNEXK-IBSC-1"} = 4166;	#Omaha
$hash_BSC_SID{"PITBPAWO-IBSC-1"} = 4171;	#Pittsburgh
$hash_BSC_SID{"RENPNVAT-IBSC-1"} = 4183;		#Reno
$hash_BSC_SID{"RNO-REN_1"} = 4183;		#Reno
$hash_BSC_SID{"ROCHNYAG-IBSC-1"} = 4107;	#Rochester
$hash_BSC_SID{"SAC-SACR_1"} = 4183;		#Sacramento
$hash_BSC_SID{"SCRMCAXJ-IBSC-1"} = 4183;	#Sacramento
$hash_BSC_SID{"SHAVOHDY-IBSC-1"} = 4390;	#Sharonville
$hash_BSC_SID{"SLC-SLTLK_1"} = 4180;		#Salt Lake 1
$hash_BSC_SID{"SLKDUTGN-IBSC-1"} = 4180;	#Salt Lake 2
$hash_BSC_SID{"SLC-SLTLK_2"} = 4180;		#Salt Lake 1
$hash_BSC_SID{"SLKDUTGN-IBSC-2"} = 4180;	#Salt Lake 2
$hash_BSC_SID{"SREDM_1"} = 4188;		#Spokane
$hash_BSC_SID{"SREDM_2"} = 4188;		#Spokane
$hash_BSC_SID{"URDLIACB-IBSC-1"} = 4124;	#Urbandale
$hash_BSC_SID{"WOTNOHDT-IBSC-1"} = 4418;	#Worthington


my (%hash_BSC_NID, $hash_BSC_NID);
%hash_BSC_NID = ();

$hash_BSC_NID{"DVNPIAHQ-IBSC-1"} = 124;	#Daven Port
$hash_BSC_NID{"BRDVILBO-IBSC-1"} = 2;	#Bridgeview 1
$hash_BSC_NID{"BRDVILBO-IBSC-2"} = 122;	#Bridgeview 2
$hash_BSC_NID{"AURRILVN-IBSC-1"} = 123;	#Aurora 1
$hash_BSC_NID{"ARLHILJQ-IBSC-1"} = 120;	#Arlington 1
$hash_BSC_NID{"ARLHILJQ-IBSC-2"} = 121;	#Arlington 2
$hash_BSC_NID{"ERIEPAUH-IBSC-1"} = 204;	#Erie
$hash_BSC_NID{"FTWZINDW-IBSC-1"} = 221;	#Ft Wayne
$hash_BSC_NID{"IPLTINWB-IBSC-1"} = 222;	#Indianapolis
$hash_BSC_NID{"KNWDMIJD-IBSC-1"} = 210;	#Kentwood 1
$hash_BSC_NID{"PITBPAWO-IBSC-1"} = 212;	#Pittsburg
$hash_BSC_NID{"BYMNPRAG-IBSC-1"} = 200;	#Bayamon
$hash_BSC_NID{"SPSPK_1"} = 247;		#Spokane
$hash_BSC_NID{"SPKNWAGQ-IBSC-1"} = 247;	#Spokane
$hash_BSC_NID{"STCDMNUC-IBSC-1"} = 244;	#St Cloud 1
$hash_BSC_NID{"TGRDORDO-IBSC-1"} = 245;	#Tigard
$hash_BSC_NID{"BRSBCABE-IBSC-1"} = 231;	#Brisbane
$hash_BSC_NID{"SNTDCAIK-IBSC-1"} = 233;	#Santa Clara
$hash_BSC_NID{"SNRSCARN-IBSC-1"} = 234;	#Santa Rosa
$hash_BSC_NID{"SF-SANTR_1"} = 234;	#Santa Rosa
$hash_BSC_NID{"OKLDCA61-IBSC-1"} = 232;	#Oakland
$hash_BSC_NID{"SF-OAKLA_1"} = 232;	#Oakland
$hash_BSC_NID{"DTRTMIPM-IBSC-1"} = 213;	#Detriot 1
$hash_BSC_NID{"DTRTMIPM-IBSC-2"} = 213;	#Detriot 1
$hash_BSC_NID{"LNNGMI55-IBSC-1"} = 208;	#Lansing 1
$hash_BSC_NID{"LNNGMI55-IBSC-2"} = 214;	#Lansing 1
$hash_BSC_NID{"RDMDWAJE-IBSC-2"} = 240;	#Redmond 1
$hash_BSC_NID{"RDMDWAJE-IBSC-1"} = 246;	#Redmond 1
$hash_BSC_NID{"MPLSMNCD-IBSC-1"} = 242;	#Minne
$hash_BSC_NID{"MPLSMNCD-IBSC-2"} = 241;	#Minne
$hash_BSC_NID{"NWBLWIDP-IBSC-1"} = 224;	#New Berlin
$hash_BSC_NID{"NWBLWIDP-IBSC-2"} = 225;	#New Berlin
$hash_BSC_NID{"CHKTNYFU-IBSC-1"} = 201;	#Cheektowaga
$hash_BSC_NID{"CLEWOH20-IBSC-1"} = 214;	#Cleveland
$hash_BSC_NID{"ENWDCO69-IBSC-1"} = 236;	#Englewood 1
$hash_BSC_NID{"ENWDCO69-IBSC-2"} = 236;	#Englewood 2
$hash_BSC_NID{"FRN-FRES_1"} = 248;	#Fresno
$hash_BSC_NID{"FRSNCA72-IBSC-1"} = 248;	#Fresno
$hash_BSC_NID{"OMAHNEXK-IBSC-1"} = 243;	#Omaha
$hash_BSC_NID{"PITBPAWO-IBSC-1"} = 212;	#Pittsburgh
$hash_BSC_NID{"RENPNVAT-IBSC-1"} = 250;	#Reno
$hash_BSC_NID{"RNO-REN_1"} = 250;	#Reno
$hash_BSC_NID{"ROCHNYAG-IBSC-1"} = 216;	#Rochester
$hash_BSC_NID{"SAC-SACR_1"} = 230;	#Sacramento
$hash_BSC_NID{"SCRMCAXJ-IBSC-1"} = 230;	#Sacramento
$hash_BSC_NID{"SHAVOHDY-IBSC-1"} = 203;	#Sharonville
$hash_BSC_NID{"SLC-SLTLK_1"} = 237;	#Salt Lake 1
$hash_BSC_NID{"SLKDUTGN-IBSC-1"} = 237;	#Salt Lake 2
$hash_BSC_NID{"SLC-SLTLK_2"} = 237;	#Salt Lake 1
$hash_BSC_NID{"SLKDUTGN-IBSC-2"} = 237;	#Salt Lake 2
$hash_BSC_NID{"SREDM_1"} = 247;		#Spokane
$hash_BSC_NID{"SREDM_2"} = 247;		#Spokane
$hash_BSC_NID{"URDLIACB-IBSC-1"} = 251;	#Urbandale
$hash_BSC_NID{"WOTNOHDT-IBSC-1"} = 214;	#Worthington




my ($mon_test, $pkg);

my (%hash_MME_INFO, $hash_MME_INFO);
%hash_MME_INFO = ();

my (%hash_RTRV_BTS_PARA, $hash_RTRV_BTS_PARA);
%hash_RTRV_BTS_PARA = ();

my (%hash_RTRV_OOS_STS, $hash_RTRV_OOS_STS);
%hash_RTRV_OOS_STS = ();

my (%hash_ALM_HIST, $hash_ALM_HIST);
%hash_ALM_HIST = ();

my (%hash_ALM_HIST_4G, $hash_ALM_HIST_4G);
%hash_ALM_HIST_4G = ();

my (%hash_ALM_4G, $hash_ALM_4G);
%hash_ALM_4G = ();

my (%hash_RTRV_CELL_CONF, $hash_RTRV_CELL_CONF);
%hash_RTRV_CELL_CONF = ();

my ($network_name);
my ($cascade);
my ($onair_info_3g, $onair_date_info_3g, $onair_info_4g, $onair_date_info_4g);
my (@input, $input);

my ($bsm_user, $bsm_pass);

##################################
# START VALUES FROM SASHA'S TOOL #
##################################
if (!$ARGV[0]) {
print ("ERROR: TOOL CAN ONLY BE EXECUTE FROM DATABASE\n");
sleep 60;
exit;
               }

@input = split(/,/,$ARGV[0]);
$network_name = "$input[0]";				#NETWORK TYPE 3G, 4G, ALL
$cascade = "$input[1]";					#CASCADE
$bts_id = "$input[2]";					#BTS ID
$bsm_ip_address = "$input[3]";				#BSM IP ADDRESS
$bsm_name = "$input[4]";				#BSM NAME
$color_code = "$hash_color_code_info{$bsm_name}";	#COLOR CODE FROM BSM NAME AND $HASH_COLOR_CODE_INFO{$BSM_NAME}
$ltm_off = "$hash_ltm_off_info{$bsm_name}";		#LSM OFF FROM BSM NAME AND $hash_ltm_off_info{$bsm_name}
$market = "$input[5]";					#MARKET NAME
$market =~ s/\_+/ /g;
$market =~ s/\.//g;

$hash_pn_excel{1} = "$input[6]";			#PNs SECTOR 0
$hash_pn_excel{2} = "$input[7]";			#PNs SECTOR 1
$hash_pn_excel{3} = "$input[8]";			#PNs SECTOR 2
$RRH_PORT_0 = "$input[9]";				#TILT PORT 0
$RRH_PORT_1 = "$input[10]";				#TILT PORT 1
$RRH_PORT_2 = "$input[11]";				#TILT PORT 2
$RRH_PORT_3 = "$input[12]";				#TILT PORT 3
$RRH_PORT_4 = "$input[13]";				#TILT PORT 4
$RRH_PORT_5 = "$input[14]";				#TILT PORT 5
$hash_non_comm_sid_1900{$cascade} = "$input[15]";	#NON COMM SID 1900
$hash_non_comm_nid_1900{$cascade} = "$input[16]";	#NON COMM NID 1900
$hash_comm_sid_1900{$cascade} = "$input[17]";		#COMM SID 1900
$hash_comm_nid_1900{$cascade} = "$input[18]";		#COMM NID 1900
$hash_non_comm_sid_800{$cascade} = "$input[19]";	#NON COMM SID 800
$hash_non_comm_nid_800{$cascade} = "$input[20]";	#NON COMM NID 800
$hash_comm_sid_800{$cascade} = "$input[21]";		#COMM SID 800
$hash_comm_nid_800{$cascade} = "$input[22]";		#COMM NID 800


$MMBS_Cabinet_Type = "$input[23]";			#MMBS_Cabinet_Type
$MMBS_Cabinet_Type = uc($MMBS_Cabinet_Type);

if ($MMBS_Cabinet_Type =~ m/OUTDOOR/) {
$MMBS_Cabinet_Type = "OUTDOOR";
                                      }
if ($MMBS_Cabinet_Type =~ m/INDOOR/) {
$MMBS_Cabinet_Type = "INDOOR";
                                     }

$Backhaul_Type = "$input[24]";				#Backhaul_Type
$Backhaul_Type = uc($Backhaul_Type);
$Sectors_NUM = "$input[25]";				#NUMBER OF SECTORS
$RRU_Qty_800 = "$input[26]";				#RRU_Qty_800
$RRU_Qty_1900 = "$input[27]";				#RRU_Qty_1900
$CDMA_BBU_Qty = "$input[28]";				#CDMA_BBU_Qty
$CICA_A_Qty_BBU1 = "$input[29]";			#CICA_A_Qty_BBU1
$CICA_D_Qty_BBU1 = "$input[30]";			#CICA_D_Qty_BBU1
$CICA_A_Qty_BBU2 = "$input[31]";			#CICA_A_Qty_BBU2
$CICA_D_Qty_BBU2 = "$input[32]";			#CICA_D_Qty_BBU2
$GRM_COMBINER_EXCEL = "$input[33]";			#GRM & Combiner
if ($GRM_COMBINER_EXCEL == 1) {
$GRM_COMBINER_EXCEL = "";
                              }

$hash_fa_carrier{0} = "$input[34]";			#FA CARRIER 0
$hash_fa_carrier{1} = "$input[35]";			#FA CARRIER 1
$hash_fa_carrier{2} = "$input[36]";			#FA CARRIER 2
if (!$hash_fa_carrier{2}) {
$hash_fa_carrier{2} = "No";				#IF FA CARRIER 2 EQUAL BLANK SET TO NO
                          }
$hash_fa_carrier{3} = "$input[37]";			#FA CARRIER 3
$hash_fa_carrier{4} = "$input[38]";			#FA CARRIER 4
$hash_fa_carrier{5} = "$input[39]";			#FA CARRIER 5
$hash_fa_carrier{6} = "$input[40]";			#FA CARRIER 6
$hash_fa_carrier{7} = "$input[41]";			#FA CARRIER 7
$hash_fa_carrier{8} = "$input[42]";			#FA CARRIER 8
$hash_fa_carrier{9} = "$input[43]";			#FA CARRIER 9
$hash_fa_carrier{10} = "$input[44]";			#FA CARRIER 10
$hash_fa_carrier{11} = "$input[45]";			#FA CARRIER 11
$hash_fa_carrier{12} = "$input[46]";			#FA CARRIER 12
$hash_fa_carrier{13} = "$input[47]";			#FA CARRIER 13
$hash_fa_carrier{14} = "$input[48]";			#FA CARRIER 14



$Vlan16_CSR_OAM_IP_3G = "$input[49]";			#Vlan16_CSR_OAM_IP_3G
$Vlan16_MMBS_OAM_IP_3G = "$input[50]";			#Vlan16_MMBS_OAM_IP_3G
$Vlan24_CSR_Side_IP_3G = "$input[51]";			#Vlan24_CSR_Side_IP_3G
$Vlan24_MMBS_Side_IP_3G = "$input[52]";			#Vlan24_MMBS_Side_IP_3G
$bts_ip = $Vlan16_MMBS_OAM_IP_3G;

$lsm_user = "$input[53]";				#LSM USER NAME
$lsm_pass = "$input[54]";				#LSM PASSWORD

if (($lsm_user eq "admin") && ($lsm_pass eq "ranadmin")) {
$lsm_user = "rz252372";				#LSM USER NAME
$lsm_pass = "Mina0803";				#LSM PASSWORD
                                                         }


$CSR_OAM_IP_4G = "$input[55]";				#CSR_OAM_IP_4G
$MMBS_OAM_IP_4G = "$input[56]";				#MMBS_OAM_IP_4G
$CSR_S_B_IP_4G = "$input[57]";				#CSR_S_B_IP_4G
$MMBS_S_B_IP_4G = "$input[58]";				#MMBS_S_B_IP_4G

$enodeb_id = "$input[59]";				#ENODEB ID
$enodeb_name = "$input[60]";				#ENODEB NAME
$tac_hex = "$input[61]";				#TAC Example: 3F38
$tac_hex = "H'$tac_hex";
$lat = "$input[62]";					#LAT
$long = "$input[63]";					#LONG


$lsm_name = "$input[64]";				#LSM NAME
$lsm_ip = "$input[65]";					#LSM IP
$freq = "$input[66]";					#FREQUENCY Example: 5
$MHz = "MHz";
$freq = "$freq$MHz";



$hash_sector_pci_rach_tac{0} = 0;
$hash_pci{0} = "$input[67]";				#ALPHA PCI
$hash_rach{0} = "$input[68]";				#ALPHA RACH
$hash_tac{0} = "$tac_hex";

$hash_sector_pci_rach_tac{1} = 1;
$hash_pci{1} = "$input[69]";				#BETA PCI
$hash_rach{1} = "$input[70]";				#BETA RACH
$hash_tac{1} = "$tac_hex";

$hash_sector_pci_rach_tac{2} = 2;
$hash_pci{2} = "$input[71]";				#GAMMA PCI
$hash_rach{2} = "$input[72]";				#GAMMA RACH
$hash_tac{2} = "$tac_hex";

$hash_sector_pci_rach_tac{3} = 3;
$hash_pci{3} = "$input[67]";				#ALPHA PCI
$hash_rach{3} = "$input[68]";				#ALPHA RACH
$hash_tac{3} = "$tac_hex";

$hash_sector_pci_rach_tac{4} = 4;
$hash_pci{4} = "$input[69]";				#BETA PCI
$hash_rach{4} = "$input[70]";				#BETA RACH
$hash_tac{4} = "$tac_hex";

$hash_sector_pci_rach_tac{5} = 5;
$hash_pci{5} = "$input[71]";				#GAMMA PCI
$hash_rach{5} = "$input[72]";				#GAMMA RACH
$hash_tac{5} = "$tac_hex";

$hash_sector_pci_rach_tac{6} = 6;
$hash_pci{6} = "$input[67]";				#ALPHA PCI
$hash_rach{6} = "$input[68]";				#ALPHA RACH
$hash_tac{6} = "$tac_hex";

$hash_sector_pci_rach_tac{7} = 7;
$hash_pci{7} = "$input[69]";				#BETA PCI
$hash_rach{7} = "$input[70]";				#BETA RACH
$hash_tac{7} = "$tac_hex";

$hash_sector_pci_rach_tac{8} = 8;
$hash_pci{8} = "$input[71]";				#GAMMA PCI
$hash_rach{8} = "$input[72]";				#GAMMA RACH
$hash_tac{8} = "$tac_hex";

$hash_sector_pci_rach_tac{15} = 15;
$hash_pci{15} = "$input[78]";				#ALPHA PCI
$hash_rach{15} = "$input[68]";				#ALPHA RACH
$hash_tac{15} = "$tac_hex";

$hash_sector_pci_rach_tac{16} = 16;
$hash_pci{16} = "$input[79]";				#BETA PCI
$hash_rach{16} = "$input[70]";				#BETA RACH
$hash_tac{16} = "$tac_hex";

$hash_sector_pci_rach_tac{17} = 17;
$hash_pci{17} = "$input[80]";				#GAMMA PCI
$hash_rach{17} = "$input[72]";				#GAMMA RACH
$hash_tac{17} = "$tac_hex";


$onair_info_3g = "$input[73]";				#3G ONAIR STATUS Example: 3G_1900MHz_On_Air
$onair_date_info_3g = "$input[74]";			#3G ONAIR DATE Example: 4/26/2012

$onair_info_4g = "$input[75]";				#4G ONAIR STATUS Example: 4G_1900MHz_On_Air
$onair_date_info_4g = "$input[76]";			#4G ONAIR DATE Example: 3/15/2013


$reg_zone = "$input[77]";				#3G REG ZONE



if ($bsm_ip_address eq "111.4.0.166") {			#ARLINGTON_HEIGHTS_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.4.0.198") {			#ARLINGTON_HEIGHTS_BSM2
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.2.0.166") {			#AURORA_BSM
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.10.0.166") {		#BAYAMON_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.3.0.166") {			#BRIDGEVIEW_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.3.0.182") {			#BRIDGEVIEW_BSM2
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.9.0.150") {			#BRISBANE_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.22.0.166") {		#CHEEKTOWAGA_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.23.0.166") {		#CLEVELAND_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }

if ($bsm_ip_address eq "111.23.0.198") {		#CLEVELAND_BSM2
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.1.0.68") {			#DAVENPORT_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                     }

if ($bsm_ip_address eq "111.1.1.100") {		#DAVENPORT_BSM2
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.15.0.166") {		#DETROIT_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }



if ($bsm_ip_address eq "111.15.0.198") {		#DETROIT_BSM2
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.24.0.166") {		#ENGLEWOOD_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.25.0.166") {		#ERIE_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.21.0.166") {		#FRESNO_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.5.0.166") {			#FT_WAYNE_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.18.0.166") {		#INDIANAPOLIS_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.17.0.166") {		#KENTWOOD_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.16.0.166") {		#LANSING_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }

if ($bsm_ip_address eq "111.16.0.198") {		#LANSING_BSM2
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.19.0.166") {		#MINNEAPOLIS_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.26.0.166") {		#NEW_BERLIN_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }

if ($bsm_ip_address eq "111.26.0.198") {		#NEW_BERLIN_BSM2
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.6.0.150") {			#OAKLAND_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.27.0.166") {		#OMAHA_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.33.0.166") {		#PITTSBURGH_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.14.0.166") {		#REDMOND_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.28.0.166") {		#RENO_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.29.0.166") {		#ROCHESTER_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.11.0.166") {		#SACRAMENTO_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.31.0.166") {		#SALT_LAKE_CITY_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.8.0.150") {			#SANTA_CLARA_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.7.0.150") {			#SANTA_ROSA_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                      }


if ($bsm_ip_address eq "111.30.0.166") {		#SHARONVILLE_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.12.0.166") {		#SPOKANE_BSM1

$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }

if ($bsm_ip_address eq "111.20.0.166") {		#ST_CLOUD_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.13.0.166") {		#TIGARD_BSM1

$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }

if ($bsm_ip_address eq "111.34.0.166") {		#URBANDALE_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ($bsm_ip_address eq "111.32.0.166") {		#WORTHINGTON_BSM1
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                       }


if ((!$bsm_user) || (!$bsm_pass)) {
$bsm_user = "cdmaone";
$bsm_pass = "cdmaone";
                                  }

if (($onair_info_3g =~ m/3G/) && ($onair_info_3g =~ m/On_Air/) && ($onair_info_3g =~ m/1900/) && ($onair_date_info_3g)) {
$onair_3g = "YES";
                                                                                                                        }
if (($onair_info_3g =~ m/3G/) && ($onair_info_3g =~ m/On_Air/) && ($onair_info_3g =~ m/1900/) && (!$onair_date_info_3g)) {
$onair_3g = "NO";
                                                                                                                         }



if (($onair_info_4g =~ m/4G/) && ($onair_info_4g =~ m/On_Air/) && ($onair_date_info_4g)) {
$onair_4g = "YES";
                                                                                         }
else {
$onair_4g = "NO";
     }



my $validate = `C:\\3G_4G_TOOL_Scripts\\bin\\validate.exe`;
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


###################################
# START GET DATA FROM EXCEL SHEET #
###################################
$GRM_COMBINER_EXCEL =~ s/\_/ /g;
$GRM_COMBINER_EXCEL = uc($GRM_COMBINER_EXCEL);


if (($GRM_COMBINER_EXCEL =~ m/GMR/) || ($GRM_COMBINER_EXCEL =~ m/CONNECTOR/)) {
$GRM_COMBINER_EXCEL = "Ground Mount";
                                                                              }

else {
$GRM_COMBINER_EXCEL = "Normal";
     }


############################################################
# START EXIT IF BTS ID ENODEB NAME NOT PRESENT IN DATABASE #
############################################################
if (($network_name eq "3G") || ($network_name eq "ALL")) {
if (!$bts_id) {
print ("ERROR: $cascade CASCADE IS NOT IN DATABASE\n");
sleep 10;
exit;
              }
                                                         }

if (($network_name eq "4G") || ($network_name eq "ALL")) {
if (!$enodeb_name) {
print ("ERROR: $cascade CASCADE IS NOT IN DATABASE\n");
sleep 10; 
exit;
                   }
                                                         }
############################################################
#  END EXIT IF BTS ID ENODEB NAME NOT PRESENT IN DATABASE  #
############################################################

###################################################################
# START FIGURE LATITUDE DEGREES MINUTES SECONDS FROM SPREAD SHEET #
###################################################################
my (@split_lat_info, $split_lat_info);
my (@split_lat_min, $split_lat_min);
my ($lat_direction);
my ($lat_degree);
my ($lat_minutes);

@split_lat_info = split(/\./, $lat);


my $dot_min = ".$split_lat_info[1]";
if ($dot_min !~ m/.\d+/) {
$dot_min =~ s/.//g;
                         }


my $dot_min_value = ($dot_min * 60);
@split_lat_min = split(/\./, $dot_min_value);

if ($split_lat_min[0] eq 0) {
$split_lat_min[0] = "";

                            }


my $dot_sec = ".$split_lat_min[1]";
if ($dot_sec !~ m/.\d+/) {
$dot_sec =~ s/.//g;
                         }

my $dot_sec_value = ($dot_sec * 60);



$dot_sec_value = sprintf("%.3f", $dot_sec_value);

if ($dot_sec_value  == 0) {
$dot_sec_value = "";

                          }

$split_lat_info[0] = sprintf("%03d", $split_lat_info[0]);
if ($split_lat_info[0] =~ m/\d+/) {
$split_lat_info[0] = "$split_lat_info[0]";
                                  }

if ($split_lat_min[0]) {
$split_lat_min[0] = "$split_lat_min[0]";
                       }

if ($dot_sec_value) {
$dot_sec_value = "$dot_sec_value";
                    }

$lat_degree = $split_lat_info[0];
$lat_minutes = $split_lat_min[0];

if ($lat_degree > 0) {
$lat_direction = "N";
                     }

if ($lat_degree < 0) {
$lat_direction = "S";
                     }

$lat_degree =~ s/-//g;
$lat_degree = sprintf("%03d", $lat_degree);
$lat_minutes = sprintf("%02d", $lat_minutes);
#print ("$lat_direction $lat_degree $lat_minutes $dot_sec_value\n");

###################################################################
#  END FIGURE LATITUDE DEGREES MINUTES SECONDS FROM SPREAD SHEET  #
###################################################################

####################################################################
# START FIGURE LONGITUDE DEGREES MINUTES SECONDS FROM SPREAD SHEET #
####################################################################
my (@split_lon_info, $split_lon_info);
my (@split_lon_min, $split_lon_min);
my ($long_direction);
my ($long_degree);
my ($long_minutes);

@split_long_info = split(/\./, $long);


my $dot_min = ".$split_long_info[1]";
if ($dot_min !~ m/.\d+/) {
$dot_min =~ s/.//g;
                         }


my $dot_min_value = ($dot_min * 60);
@split_long_min = split(/\./, $dot_min_value);

if ($split_long_min[0] eq 0) {
$split_long_min[0] = "";

                            }


my $dot_sec_long = ".$split_long_min[1]";
if ($dot_sec_long !~ m/.\d+/) {
$dot_sec_long =~ s/.//g;
                         }

my $dot_sec_value_long = ($dot_sec_long * 60);



$dot_sec_value_long = sprintf("%.3f", $dot_sec_value_long);

if ($dot_sec_value_long  == 0) {
$dot_sec_value_long = "";

                          }

$split_long_info[0] = sprintf("%03d", $split_long_info[0]);
if ($split_long_info[0] =~ m/\d+/) {
$split_long_info[0] = "$split_long_info[0]";
                                  }

if ($split_long_min[0]) {
$split_long_min[0] = "$split_long_min[0]";
                       }

if ($dot_sec_value_long) {
$dot_sec_value_long = "$dot_sec_value_long";
                    }

$long_degree = $split_long_info[0];
$long_minutes = $split_long_min[0];

if ($long_degree > 0) {
$long_direction = "E";
                     }

if ($long_degree < 0) {
$long_direction = "W";
                     }

$long_degree =~ s/-//g;
$long_degree = sprintf("%03d", $long_degree);
$long_minutes = sprintf("%02d", $long_minutes);
#print ("$long_direction $long_degree $long_minutes $dot_sec_value_long\n");

####################################################################
#  END FIGURE LONGITUDE DEGREES MINUTES SECONDS FROM SPREAD SHEET  #
####################################################################













my ($f);
my $fa_1900_excel_carrier_count = 0;
for ($f=0; $f<=14; $f++) {

if ($hash_fa_carrier{$f}) {
#print ("FA $f CARRIER: $hash_fa_carrier{$f}\n");
if ($hash_fa_carrier{$f} =~ m/\d+/) {
$fa_1900_excel_carrier_count++;
                                    }
                          }
                         }



###################################
#  END GET DATA FROM EXCEL SHEET  #
###################################

#########################################
#  START GET 3G FA MAPPING INFORMATION  #
#########################################
my (@split_map_each_line, $split_map_each_line);
my (%mapping_fa_index, $mapping_fa_index);
my (%mapping_fa_id, $mapping_fa_id);
my (%mapping_serv_type, $mapping_serv_type);
my (%mapping_normal, $mapping_normal);
my (%mapping_normal_gt_6, $mapping_normal_gt_6);
my (%mapping_gmr_lt_5, $mapping_gmr_lt_5);
my (%mapping_gmr_gt_4, $mapping_gmr_gt_4);
my (%mapping_combiner, $mapping_combiner);


%mapping_fa_index = ();
%mapping_fa_id = ();
%mapping_serv_type = ();
%mapping_normal = ();
%mapping_normal_gt_6 = ();
%mapping_gmr_lt_5 = ();
%mapping_gmr_gt_4 = ();
%mapping_combiner = ();

$market =~ s/\s+/ /g;				#substitute any multiple spaces

my $mapping_file =`type $Bin\\FA_DATABASE\\"$market"\_fa_mapping.txt`;
@split_map_each_line = split(/\n/, $mapping_file);
foreach $split_map_each_line (@split_map_each_line) {
@_ = split(/\t+/, $split_map_each_line);
if ($_[0] =~ m/\d+/) {	#Start if 1st value match digits
$mapping_fa_index{$_[0]} = $_[0];
$mapping_fa_id{$_[0]} = $_[1];
if ($_[2]) {
$mapping_serv_type{$_[0]} = "SERVICE_$_[2]";
           }
else {
$mapping_serv_type{$_[0]} = $_[2];
     }

if ($_[3] =~ m/\d+/) {
$mapping_normal{$_[0]} = "PATH_$_[3]";
                     }
else {
$mapping_normal{$_[0]} = $_[3];
     }

if ($_[4] =~ m/\d+/) {
$mapping_normal_gt_6{$_[0]} = "PATH_$_[4]";
                     }
else {
$mapping_normal_gt_6{$_[0]} = $_[4];
     }

if ($_[5] =~ m/\d+/) {
$mapping_gmr_lt_5{$_[0]} = "PATH_$_[5]";
                     }
else {
$mapping_gmr_lt_5{$_[0]} = $_[5];
     }

if ($_[6] =~ m/\d+/) {
$mapping_gmr_gt_4{$_[0]} = "PATH_$_[6]";
                     }
else {
$mapping_gmr_gt_4{$_[0]} = $_[6];
     }

if ($_[7] =~ m/\d+/) {
$mapping_combiner{$_[0]} = "PATH_$_[7]";
                     }
else {
$mapping_combiner{$_[0]} = $_[7];
     }

                     }	#End if 1st value match digits

                                                    }




#########################################
#   END GET 3G FA MAPPING INFORMATION   #
#########################################

my ($buf_3g_data, $cmd_value_3G, $buf_ret_3g_data);



if (($network_name eq "3G") || ($network_name eq "ALL")) {
print ("\n\n");
print ("##############\n");
print ("#  3G AUDIT  #\n");
print ("##############\n\n");

&OPEN_3G_DATA;
&ssh_3g_data;
&CLOSE_3G_DATA;
                                                         }
if (($network_name eq "4G") || ($network_name eq "ALL")) {
print ("\n\n");
print ("##############\n");
print ("#  4G AUDIT  #\n");
print ("##############\n\n");
&OPEN_4G_DATA;
&LSM_INFO;
&CLOSE_4G_DATA;
                                                         }

&OPEN_HTML;
if (($network_name eq "3G") || ($network_name eq "ALL")) {
&AUDIT_REPORT_3G;
                                                         }
if (($network_name eq "4G") || ($network_name eq "ALL")) {
&AUDIT_REPORT_4G;
                                                         }
&CLOSE_HTML;

sub OPEN_3G_DATA {
open (FILE_3G, ">$Bin\\3G_DATA\\$cascade\_3G\_AUDIT\_$month_num\_$mday\_$year\_$hour\_$minute\.txt");
                 }

#########################
# START SSH 3G GET DATA #
#########################
my ($RET_LOG, $BTS_FA_CONF_LOG, $RTRV_SUBC_STS, $INVT_INF_RRH_LOG, $BTS_CEP_CONF_LOG);
my ($BTS_IP_ADD_CONF_LOG, $BTS_STATIC_ROUTE_CONF_LOG, $ALM_LIST_LOG);
my ($INVT_INF_BCP_LOG, $INVT_INF_GPSR_LOG, $CMPR_ROM_INF_LOG);
my ($RTRV_BTS_CALL_ACCESS_DATA, $RTRV_BTS_EVDO_CALL_ACCESS_DATA, $RTRV_BTS_EVDO_SUBNET_PARA, $RTRV_BSC_PCF_BTS_PARA);
my ($RTRV_CALL_CNT, $RTRV_ALM_INH);




my ($RTRV_BTS_SUBSYSTEM_CONF);
my ($i);
my (%hash_SUBSYS_CONF_STATUS, $hash_SUBSYS_CONF_STATUS);
my (%hash_SUBSYS_CONF_BTS_TYPE, $hash_SUBSYS_CONF_BTS_TYPE);
my (%hash_SUBSYS_CONF_NET_TYPE, $hash_SUBSYS_CONF_NET_TYPE);
my (%hash_SUBSYS_CONF_OAM_IP, $hash_SUBSYS_CONF_OAM_IP);
my (%hash_SUBSYS_CONF_BCP_COUNT, $hash_SUBSYS_CONF_BCP_COUNT);
my (%hash_SUBSYS_CONF_SECTOR_COUNT, $hash_SUBSYS_CONF_SECTOR_COUNT);
my (%hash_SUBSYS_CONF_PN_OFFSET, $hash_SUBSYS_CONF_PN_OFFSET);
my (%hash_SUBSYS_CONF_FA_INDEX, $hash_SUBSYS_CONF_FA_INDEX);
%hash_SUBSYS_CONF_STATUS = ();
%hash_SUBSYS_CONF_BTS_TYPE = ();
%hash_SUBSYS_CONF_NET_TYPE = ();
%hash_SUBSYS_CONF_OAM_IP = ();
%hash_SUBSYS_CONF_BCP_COUNT = ();
%hash_SUBSYS_CONF_SECTOR_COUNT = ();
%hash_SUBSYS_CONF_PN_OFFSET = ();
%hash_SUBSYS_CONF_FA_INDEX = ();





my ($RET_SERIAL, $CONTROL_RRH, $RET_TILT);
my (%hash_ret, $hash_ret);
my (%hash_TILT, $hash_TILT);
%hash_ret = ();
%hash_TILT = ();

my ($ret_sts_nok);

my (%hash_RRH_PORT, $hash_RRH_PORT);
my (%hash_RRH_CASCADE, $hash_RRH_CASCADE);
my (%hash_RET, $hash_RET);
%hash_RRH_PORT = ();
%hash_RRH_CASCADE = ();
%hash_RET = ();

my ($RET_BCP);


my (%hash_subsc_sts_sector, $hash_subsc_sts_sector);
my (%hash_subsc_sts_fa, $hash_subsc_sts_fa);
my (%hash_subsc_sts_sector_fa, $hash_subsc_sts_sector_fa);
my (%hash_subsc_sts_info, $hash_subsc_sts_info);
%hash_subsc_sts_sector = ();
%hash_subsc_sts_fa = ();
%hash_subsc_sts_sector_fa = ();
%hash_subsc_sts_info = ();


my (%hash_num_carriers, $hash_num_carriers);
%hash_num_carriers = ();
my ($FA_INDEX);
my (%BTS_FA_CONF_BTS_ID, $BTS_FA_CONF_BTS_ID);
my (%BTS_FA_CONF_FA_INDEX, $BTS_FA_CONF_FA_INDEX);
my (%BTS_FA_CONF_FA_KIND, $BTS_FA_CONF_FA_KIND);
my (%BTS_FA_CONF_BCP, $BTS_FA_CONF_BCP);
my (%BTS_FA_CONF_STATUS, $BTS_FA_CONF_STATUS);
my (%BTS_FA_CONF_FA_ID, $BTS_FA_CONF_FA_ID);
my (%BTS_FA_CONF_RRH_PORT_GROUP, $BTS_FA_CONF_RRH_PORT_GROUP);
my (%BTS_FA_CONF_PATH, $BTS_FA_CONF_PATH);
my (%BTS_FA_CONF_MAX_NEW_CALL_LOAD, $BTS_FA_CONF_MAX_NEW_CALL_LOAD);
my (%BTS_FA_CONF_BND_CLS_IND, $BTS_FA_CONF_BND_CLS_IND);
my (%BTS_FA_CONF_OTA_SID, $BTS_FA_CONF_OTA_SID);
my (%BTS_FA_CONF_OTA_NID, $BTS_FA_CONF_OTA_NID);
my (%BTS_FA_CONF_RC_QPCH_HASH_IND, $BTS_FA_CONF_RC_QPCH_HASH_IND);
my (%BTS_FA_CONF_CLK_ADV, $BTS_FA_CONF_CLK_ADV);
my (%BTS_FA_CONF_HO_CE_RESERVE_RATIO, $BTS_FA_CONF_HO_CE_RESERVE_RATIO);
my (%BTS_FA_CONF_SERV_TYPE, $BTS_FA_CONF_SERV_TYPE);
my (%BTS_FA_CONF_TX_DIVERSITY, $BTS_FA_CONF_TX_DIVERSITY);
my (%BTS_FA_CONF_DATA_FA_FLAG, $BTS_FA_CONF_DATA_FA_FLAG);

%BTS_FA_CONF_BTS_ID = ();
%BTS_FA_CONF_FA_INDEX = ();
%BTS_FA_CONF_FA_KIND = ();
%BTS_FA_CONF_BCP = ();
%BTS_FA_CONF_STATUS = ();
%BTS_FA_CONF_FA_ID = ();
%BTS_FA_CONF_RRH_PORT_GROUP = ();
%BTS_FA_CONF_PATH = ();
%BTS_FA_CONF_MAX_NEW_CALL_LOAD = ();
%BTS_FA_CONF_BND_CLS_IND = ();
%BTS_FA_CONF_OTA_SID = ();
%BTS_FA_CONF_OTA_NID = ();
%BTS_FA_CONF_RC_QPCH_HASH_IND = ();
%BTS_FA_CONF_CLK_ADV = ();
%BTS_FA_CONF_HO_CE_RESERVE_RATIO = ();
%BTS_FA_CONF_TX_DIVERSITY = ();
%BTS_FA_CONF_SERV_TYPE = ();
%BTS_FA_CONF_DATA_FA_FLAG = ();
my ($fa_800_bsm);
my ($commerical_3G);

my (@split_each_location, $split_each_location);
my (@split_each_line, $split_each_line);


my (%hash_bcp_loc, $hash_bcp_loc);
my (%hash_bcp_processor, $hash_bcp_processor);
my (%hash_bcp_ctrl, $hash_bcp_ctrl);
my (%hash_bcp_clock, $hash_bcp_clock);
%hash_bcp_loc = ();
%hash_bcp_processor = ();
%hash_bcp_ctrl = ();
%hash_bcp_clock = ();


my (%hash_gpsr_loc, $hash_gpsr_loc);
my (%hash_gpsr_fw, $hash_gpsr_fw);
%hash_gpsr_loc = ();
%hash_gpsr_fw = ();


my (%hash_eaiu_loc, $hash_eaiu_loc);
my (%hash_eaiu_fw, $hash_eaiu_fw);
%hash_eaiu_loc = ();
%hash_eaiu_fw = ();


my (%hash_cmpr_rom_loc, $hash_cmpr_rom_loc);
my (%hash_cmpr_rom_info, $hash_cmpr_rom_info);
%hash_cmpr_rom_loc = ();
%hash_cmpr_rom_info = ();

my (%hash_1900_count, $hash_1900_count);
my (%hash_800_count, $hash_800_count);
%hash_1900_count = ();
%hash_800_count = ();

my (%hash_inf_rrh_loc, $hash_inf_rrh_loc);
my (%hash_inf_rrh_fw, $hash_inf_rrh_fw);
%hash_inf_rrh_loc = ();
%hash_inf_rrh_fw = ();


my (@array_cep_conf_each_loc, $array_cep_conf_each_loc);
my (@array_cep_conf_each_line, $array_cep_conf_each_line);
my ($cep_conf_BCP, $cep_conf_CEP);
my (%hash_cep_type, $hash_cep_type);
%hash_cep_type = ();
my (%hash_bbu1_cica_a_bsm, $hash_bbu1_cica_a_bsm);
my (%hash_bbu1_cica_d_bsm, $hash_bbu1_cica_d_bsm);
my (%hash_bbu2_cica_a_bsm, $hash_bbu2_cica_a_bsm);
my (%hash_bbu2_cica_d_bsm, $hash_bbu2_cica_d_bsm);
%hash_bbu1_cica_a_bsm = ();
%hash_bbu1_cica_d_bsm = ();
%hash_bbu2_cica_a_bsm = ();
%hash_bbu2_cica_d_bsm = ();

my (%hash_vlan16_mmbs_ip_bsm, $hash_vlan16_mmbs_ip_bsm);
my (%hash_vlan24_mmbs_ip_bsm, $hash_vlan24_mmbs_ip_bsm);
%hash_vlan16_mmbs_ip_bsm = ();
%hash_vlan24_mmbs_ip_bsm = ();

my (%hash_vlan16_csr_ip_bsm, $hash_vlan16_csr_ip_bsm);
my (%hash_vlan24_csr_ip_bsm, $hash_vlan24_csr_ip_bsm);
%hash_vlan16_csr_ip_bsm = ();
%hash_vlan24_csr_ip_bsm = ();


my ($BCP_CEP);

my (%hash_bts_ip_conf_info, $hash_bts_ip_conf_info);
%hash_bts_ip_conf_info = ();


my (%hash_BTS_CALL_ACCESS_DATA, $hash_BTS_CALL_ACCESS_DATA);
%hash_BTS_CALL_ACCESS_DATA = ();

my (%hash_BTS_EVDO_CALL_ACCESS_DATA, $hash_BTS_EVDO_CALL_ACCESS_DATA);
%hash_BTS_EVDO_CALL_ACCESS_DATA = ();

my (%hash_BTS_EVDO_SUBNET_PARA, $hash_BTS_EVDO_SUBNET_PARA);
%hash_BTS_EVDO_SUBNET_PARA = ();

my (%hash_BSC_PCF_BTS_PARA, $hash_BSC_PCF_BTS_PARA);
my (%hash_BSC_PCF_BTS_PARA_PARM, $hash_BSC_PCF_BTS_PARA_PARM);
%hash_BSC_PCF_BTS_PARA = ();
%hash_BSC_PCF_BTS_PARA_PARM = ();
my ($BSC_PCF_BTS_PARA_loc);

my (%hash_CALL_CNT, $hash_CALL_CNT);
%hash_CALL_CNT = ();

my (%hash_is_active_alms, $hash_is_active_alms);
%hash_is_active_alms = ();
my (%hash_active_alm_key, $hash_active_alm_key);
my (%hash_active_alm_grd, $hash_active_alm_grd);
my (%hash_active_alm_cd, $hash_active_alm_cd);
my (%hash_active_alm_evnt_tm, $hash_active_alm_evnt_tm);
my (%hash_active_alarm, $hash_active_alarm);
my (%hash_active_alm_loc, $hash_active_alm_loc);
%hash_active_alm_key = ();
%hash_active_alm_grd = ();
%hash_active_alm_cd = ();
%hash_active_alm_evnt_tm = ();
%hash_active_alarm = ();
%hash_active_alm_loc = ();

my (@array_active_alm_each_line, $array_active_alm_each_line);
my (@split_alm_grd_cd_time, $split_alm_grd_cd_time);

my ($alm_count);
my ($version, $bsm_version, $bts_version);


my (%hash_BOOTER, $hash_BOOTER);
%hash_BOOTER = ();

my (%hash_KERNEL, $hash_KERNEL);
%hash_KERNEL = ();


my (%hash_ALM_INH, $hash_ALM_INH);
%hash_ALM_INH = ();

my (%hash_TXATT_DATA, $hash_TXATT_DATA);
%hash_TXATT_DATA = ();

my ($RTRV_BTS_RRH_TXATT_DATA);

my (%hash_RTRV_BTS_RC_PARA, $hash_RTRV_BTS_RC_PARA);
%hash_RTRV_BTS_RC_PARA = ();


my (%hash_SUBSYS_CONF_NAME_DESC, $hash_SUBSYS_CONF_NAME_DESC);
%hash_SUBSYS_CONF_NAME_DESC = ();

my (%hash_RX_DIVERSITY, $hash_RX_DIVERSITY);
%hash_RX_DIVERSITY = ();

my (%CICA_TYPE_Diversity, $CICA_TYPE_Diversity);
%CICA_TYPE_Diversity = ();

my (%hash_DIVERSITY_CHECK, $hash_DIVERSITY_CHECK);
%hash_DIVERSITY_CHECK = ();


my (%hash_800_INFO, $hash_800_INFO);
%hash_800_INFO = ();

my (%hash_BTS_STATIC_ROUTE_CONF, $hash_BTS_STATIC_ROUTE_CONF);
%hash_BTS_STATIC_ROUTE_CONF = ();


my ($CMPR_FW_INF_BTS_LOG, $CMPR_FW_INF_NO_RESULT);

my (%hash_CMPR_FW_INF_BTS, $hash_CMPR_FW_INF_BTS);
%hash_CMPR_FW_INF_BTS = ();


my (%hash_ENV_VAR, $hash_ENV_VAR);
%hash_ENV_VAR = ();

sub ssh_3g_data {
my (%hash_bts_comm_fail, $hash_bts_comm_fail);
%hash_bts_comm_fail = ();

my $ssh = new Control::CLI(Use => 'SSH',
                        Prompt => ']',
			Errmode=> 'return',
                        Timeout=> '180');

$ssh->connect(Host => $bsm_ip_address,
          Username => $bsm_user,
          Password => $bsm_pass,
        PrivateKey => '.ssh/id_dsa');



$ssh->read(Blocking => 1);

$ssh->print("/usr/local/mysql/bin/mysql -ucdmaone -pt0days emsdb");
my $sql_start = $ssh->waitfor('mysql>');
#print ("$sql_start\n\n");



########################
# START FIND SITE DOWN #
########################
$ssh->print("select BTS,AlmCode,AlmDesc,Location,ClearTime from TB_ALM_LATEST where AlmCode = 3236 and ClearTime is NULL;");
my $sql_SITE_DOWN = $ssh->waitfor('mysql>');
#print ("$sql_SITE_DOWN\n");


my (@array_SITE_DOWN, $array_SITE_DOWN);
@array_SITE_DOWN = split(/\n/, $sql_SITE_DOWN);

foreach $array_SITE_DOWN (@array_SITE_DOWN) {	#start array_SITE_DOWN
$array_SITE_DOWN =~ s/^\|\s+//g;
$array_SITE_DOWN =~ s/\s+\|\s+/\t/g;
if (($array_SITE_DOWN =~ m/^\d+/) && ($array_SITE_DOWN !~ m/rows in set/)) {
@_ = split(/\t/, $array_SITE_DOWN);

my (@array_split_to_get_bcp, $array_split_to_get_bcp);
@array_split_to_get_bcp = split(/\//, $_[3]);
my $bcp_num = "$array_split_to_get_bcp[4]";
$bcp_num =~ s/BCP_//g;
$bcp_num =~ s/\s+//g;
#print ("$_[0] $bcp_num\n");
$hash_bts_comm_fail{$_[0]}{$bcp_num} = "BCP $bcp_num COMMUNICATION FAIL";
#print ("$array_SITE_DOWN\n");
                                                                           }

                                            }	#end array_SITE_DOWN


if ($hash_bts_comm_fail{$bts_id}{0}) {
print ("ERROR: BTS $bts_id SITE DOWN\n");
print (FILE_3G "ERROR: BTS $bts_id SITE DOWN\n");
sleep 5;
$ssh->print('exit');

$ssh->disconnect;
exit;

                                     }

########################
#  END FIND SITE DOWN  #
########################


######################
# START GET RRH INFO #
######################
$ssh->print("select BTS,RRHId from TB_EQUIP_INFO where BTS != '-1' and SystemName = 'RRH';");
my $sql_TB_EQUIP_INFO_RRH = $ssh->waitfor('mysql>');
#print ("$sql_TB_EQUIP_INFO_RRH\n");

my (@array_TB_EQUIP_INFO_RRH_each_line, $array_TB_EQUIP_INFO_RRH_each_line);
@array_TB_EQUIP_INFO_RRH_each_line = split(/\n/, $sql_TB_EQUIP_INFO_RRH);

foreach $array_TB_EQUIP_INFO_RRH_each_line (@array_TB_EQUIP_INFO_RRH_each_line) {
$array_TB_EQUIP_INFO_RRH_each_line =~ s/^\|\s+//g;
$array_TB_EQUIP_INFO_RRH_each_line =~ s/\s+\|\s+/\t/g;
if (($array_TB_EQUIP_INFO_RRH_each_line =~ m/^\d+/) && ($array_TB_EQUIP_INFO_RRH_each_line !~ m/rows in set/)) {
@_ = split(/\t/, $array_TB_EQUIP_INFO_RRH_each_line);

if (($_[1] eq "30") || ($_[1] eq "40") || ($_[1] eq "50") || ($_[1] eq "130") || ($_[1] eq "140") || ($_[1] eq "150")) {
$hash_800_INFO{$_[0]} = "YES";
                                                                                                                       }


                                                                                                               }

                                                                                }
######################
#  END GET RRH INFO  #
######################



$ssh->print("exit");
my $sql_exit = $ssh->waitfor('/home1/cdmaone]');
#print ("$sql_exit\n\n");


#print Dumper(\%hash_bts_cascade);
#print Dumper(\%hash_800_INFO);



$ssh->print("cd pkg");
my $BSM_VERSION = $ssh->waitfor(']');
#print ("$BSM_VERSION\n\n");

if ($BSM_VERSION =~ m/3.0.0/) {
$version = "3.0.0";
                              }

if ($BSM_VERSION =~ m/4.0.0/) {
$version = "4.0.0";
                              }

$ssh->print("cd");
#$ssh->waitfor(']');
my $CD_HOME = $ssh->waitfor(']');
#print ("$CD_HOME\n\n");




$ssh->print("cmdx 1 RTRV-PKG-VER:SUBSYSTEM=BSM;");
$ssh->waitfor(';');
my $bsm_pkg = $ssh->waitfor('COMPLETED');
print ("$bsm_pkg\n\n");
print (FILE_3G "$bsm_pkg\n");

my (@array_split_pkg, $array_split_pkg);
@array_split_pkg = split(/\n/, $bsm_pkg);

foreach $array_split_pkg (@array_split_pkg) {
if ($array_split_pkg =~ m/BSM\s+\:\s+/) {
$array_split_pkg =~ s/^\s+BSM\s+\:\s+//g;
$array_split_pkg =~ s/\s+//g;
$bsm_version = "$array_split_pkg";
#print ("$array_split_pkg\n");
                                        }
                                            }


#print ("\nBSM VERSION: $bsm_version\n\n");




$ssh->print("cmdx 1 RTRV-PKG-VER:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
my $bts_pkg = $ssh->waitfor('COMPLETED');
$bts_pkg = "$bts_pkg$COMPLETED";
print ("$bts_pkg\n\n");
print (FILE_3G "$bts_pkg\n\n");

my (@array_each_line_bts_pkg, $array_each_line_bts_pkg);
@array_each_line_bts_pkg = split(/\n/, $bts_pkg);

foreach $array_each_line_bts_pkg (@array_each_line_bts_pkg) {
if ($array_each_line_bts_pkg =~ m/^\s+BTS\_/) {
$array_each_line_bts_pkg =~ s/^\s+BTS\_\d+\s+\:\s+//g;
$array_each_line_bts_pkg =~ s/\s+//g;
$array_each_line_bts_pkg =~ s/\*//g;
$bts_version = "$array_each_line_bts_pkg";
#print ("BTS $hash_bts_cascade VERSION: $array_each_line_bts_pkg\n");
                                              }
                                                            }






#####################################
#   START RTRV_BTS_SUBSYSTEM_CONF   #
#####################################
if ($version eq "3.0.0") {
$ssh->print("cmdx 1 RTRV-BTS_SUBSYSTEM-CONF:BTS=$bts_id;");
$ssh->waitfor(';');
$RTRV_BTS_SUBSYSTEM_CONF = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_SUBSYSTEM_CONF$completed\n\n");
print (FILE_3G "$RTRV_BTS_SUBSYSTEM_CONF$completed\n\n");
                         }

if ($version eq "4.0.0") {
$ssh->print("cmdx 1 RTRV-BTS_SUBSYSTEM-CONF:BTS=$bts_id,EXPORT_CSV=NO;");
$ssh->waitfor(';');
$RTRV_BTS_SUBSYSTEM_CONF = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_SUBSYSTEM_CONF$completed\n\n");
print (FILE_3G "$RTRV_BTS_SUBSYSTEM_CONF$completed\n\n");
                         }



my (@array_each_SUB_CONF_TITLE, $array_each_SUB_CONF_TITLE);

$RTRV_BTS_SUBSYSTEM_CONF =~ s/\[/~/g;
$RTRV_BTS_SUBSYSTEM_CONF =~ s/\]//g;
@array_each_SUB_CONF_TITLE = split(/~/, $RTRV_BTS_SUBSYSTEM_CONF);

foreach $array_each_SUB_CONF_TITLE (@array_each_SUB_CONF_TITLE) {
if ($array_each_SUB_CONF_TITLE =~ m/BTS COMMON DATA/) {
$array_each_SUB_CONF_TITLE =~ s/\s+\:\s+/:/g;
@_ = split(/\n/, $array_each_SUB_CONF_TITLE);
foreach $_ (@_) {
$_ =~ s/^\s+//g;
$_ =~ s/\s+//g;
if ($_ =~ m/STATUS:/) {
$_ =~ s/STATUS://g;
$hash_SUBSYS_CONF_STATUS{$cascade} = $_;		#BTS COMMON DATA (STATUS)
#print ("$hash_SUBSYS_CONF_STATUS{$cascade}\n");
                      }


if ($_ =~ m/BTS_NAME:/) {
$_ =~ s/BTS_NAME://g;
$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{NAME} = $_;		#BTS COMMON DATA (BTS_NAME)
#print ("$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{NAME}\n");
                        }

if ($_ =~ m/DESCRIPTION:/) {
$_ =~ s/DESCRIPTION://g;
$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{DESCRIPTION} = $_;		#BTS COMMON DATA (DESCRIPTION)
#print ("$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{DESCRIPTION}\n");
                           }


if ($_ =~ m/BTS_PLACEMENT_TYPE:/) {
$_ =~ s/BTS_PLACEMENT_TYPE://g;
$hash_SUBSYS_CONF_BTS_TYPE{$cascade} = $_;		#BTS COMMON DATA (BTS_PLACEMENT_TYPE)
#print ("$hash_SUBSYS_CONF_BTS_TYPE{$cascade}\n");
                                  }

if ($_ =~ m/NET_TYPE:/) {
$_ =~ s/NET_TYPE://g;
$hash_SUBSYS_CONF_NET_TYPE{$cascade} = $_;		#BTS COMMON DATA (NET_TYPE)
#print ("$hash_SUBSYS_CONF_NET_TYPE{$cascade}\n");
                        }

                }
                                                      }


if ($array_each_SUB_CONF_TITLE =~ m/OAM IP DATA/) {
$array_each_SUB_CONF_TITLE =~ s/\s+\:\s+/:/g;
@_ = split(/\n/, $array_each_SUB_CONF_TITLE);
foreach $_ (@_) {
$_ =~ s/^\s+//g;
if ($_ =~ m/\d+\.\d+\.\d+\.\d+/) {
$_ =~ s/STATUS://g;
$hash_SUBSYS_CONF_OAM_IP{$cascade} = $_;		#BTS COMMON DATA (OAM IP DATA)
#print ("$hash_SUBSYS_CONF_OAM_IP{$cascade}\n");
                                 }
                }

                                                  }


if ($array_each_SUB_CONF_TITLE =~ m/FA DATA/) {
@_ = split(/\n/, $array_each_SUB_CONF_TITLE);
my (@fa_i, $fa_i);
foreach $_ (@_) {
$_ =~ s/^\s+//g;
if ($_ =~ m/^\d+/) {
@fa_i = split(/\s+/, $_);
#print ("$fa_i[0]\n");
$hash_SUBSYS_CONF_FA_INDEX{$fa_i[0]} = $fa_i[0];	#BTS COMMON DATA (FA DATA)
#print ("$hash_SUBSYS_CONF_OAM_IP{$cascade}\n");
                   }
                }

                                             }


if ($array_each_SUB_CONF_TITLE =~ m/BCP DATA/) {
$i = 0;
$array_each_SUB_CONF_TITLE =~ s/\s+\:\s+/:/g;
@_ = split(/\n/, $array_each_SUB_CONF_TITLE);
foreach $_ (@_) {
$_ =~ s/^\s+//g;
if ($_ =~ m/^\d+/) {
$i++;
                   }

                }
$hash_SUBSYS_CONF_BCP_COUNT{$cascade} = $i;		#BTS COMMON DATA (Number of BCP/ BCP DATA)
#print ("$hash_SUBSYS_CONF_BCP_COUNT{$cascade}\n");

                                               }


if ($array_each_SUB_CONF_TITLE =~ m/SECTOR DATA/) {
my (@array_sector, $array_sector);
$i = 0;
$array_each_SUB_CONF_TITLE =~ s/\s+\:\s+/:/g;
@_ = split(/\n/, $array_each_SUB_CONF_TITLE);
foreach $_ (@_) {
$_ =~ s/^\s+//g;
if ($_ =~ m/^\d+/) {
@array_sector = split(/\s+/, $_);
$hash_SUBSYS_CONF_PN_OFFSET{$array_sector[0]} = $array_sector[2];	#BTS COMMON DATA (PN_OFFSET per SECTOR)
#print ("$array_sector[0] $array_sector[2]\n");
$i++;
                   }

                }
$hash_SUBSYS_CONF_SECTOR_COUNT{$cascade} = $i;		#BTS COMMON DATA (Number of Sectors / SECTOR DATA)
#print ("$hash_SUBSYS_CONF_SECTOR_COUNT{$cascade}\n");

                                                  }

#place here

                                                                }


#####################################
#    END RTRV_BTS_SUBSYSTEM_CONF    #
#####################################



###########################################
#   START GET RET SERIAL NUMBER & TILT    #
###########################################
#if ($BSM_VERSION =~ m/package\/3.0.0/) {			#START IF BSM VERSION MATCH 3.0.0
$ssh->print("cmdx 1 RTRV-RET-STS:BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
$RET_LOG = $ssh->waitfor('COMPLETED');
print ("$RET_LOG$completed\n\n");
print (FILE_3G "$RET_LOG$completed\n\n");



my (@array_ret_sts_each_line_3, $array_ret_sts_each_line_3);
@array_ret_sts_each_line_3 = split(/\n/,$RET_LOG);

foreach $array_ret_sts_each_line_3 (@array_ret_sts_each_line_3) {
$array_ret_sts_each_line_3 =~ s/^\s+//g;
if (($array_ret_sts_each_line_3 =~ m/SINGLE/) || ($array_ret_sts_each_line_3 =~ m/MULTI/)) {	#start if line match SINGLE or MULTI

if ($array_ret_sts_each_line_3 =~ m/^\d+/) {
@_ = split(/\s+/,$array_ret_sts_each_line_3);
$RET_SERIAL = $_[1];
$CONTROL_RRH = $_[5];
if ($_[6] =~ m/\d+/) {
$RET_TILT = $_[6];
                     }

if ($_[6] !~ m/\d+/) {
$RET_TILT = "$_[6] $_[7] $_[8]";
                     }



if ($CONTROL_RRH eq "000") {		#start BCP 0
$hash_ret{0} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "010") {
$hash_ret{1} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "020") {
$hash_ret{2} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "030") {
$hash_ret{3} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "040") {
$hash_ret{4} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "050") {
$hash_ret{5} = "$RET_SERIAL";
                           }		#end BCP 0
if ($CONTROL_RRH eq "100") {		#start BCP 1
$hash_ret{6} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "110") {
$hash_ret{7} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "120") {
$hash_ret{8} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "130") {
$hash_ret{9} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "140") {
$hash_ret{10} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "150") {
$hash_ret{11} = "$RET_SERIAL";
                           }		#end BCP 1

my ($port_info);
if ($CONTROL_RRH eq "000") {
$port_info = 0;
                           }
if ($CONTROL_RRH eq "010") {
$port_info = 1;
                           }
if ($CONTROL_RRH eq "020") {
$port_info = 2;
                           }
if ($CONTROL_RRH eq "030") {
$port_info = 3;
                           }
if ($CONTROL_RRH eq "040") {
$port_info = 4;
                           }
if ($CONTROL_RRH eq "050") {
$port_info = 5;
                           }

$hash_TILT{$port_info} = $RET_TILT;
#print ("$RET_SERIAL $CONTROL_RRH $RET_TILT\n");
                                           }

if ($array_ret_sts_each_line_3 =~ m/^\D+/) {
@_ = split(/\s+/,$array_ret_sts_each_line_3);
$CONTROL_RRH = $_[3];
if ($_[4] =~ m/\d+/) {
$RET_TILT = $_[4];
                     }

if ($_[4] !~ m/\d+/) {
$RET_TILT = "$_[4] $_[5] $_[6]";
                     }

if ($CONTROL_RRH eq "000") {		#start BCP 0
$hash_ret{0} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "010") {
$hash_ret{1} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "020") {
$hash_ret{2} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "030") {
$hash_ret{3} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "040") {
$hash_ret{4} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "050") {
$hash_ret{5} = "$RET_SERIAL";
                           }		#end BCP 0
if ($CONTROL_RRH eq "100") {		#start BCP 1
$hash_ret{6} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "110") {
$hash_ret{7} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "120") {
$hash_ret{8} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "130") {
$hash_ret{9} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "140") {
$hash_ret{10} = "$RET_SERIAL";
                           }
if ($CONTROL_RRH eq "150") {
$hash_ret{11} = "$RET_SERIAL";
                           }		#end BCP 1

my ($port_info);
if ($CONTROL_RRH eq "000") {
$port_info = 0;
                           }
if ($CONTROL_RRH eq "010") {
$port_info = 1;
                           }
if ($CONTROL_RRH eq "020") {
$port_info = 2;
                           }
if ($CONTROL_RRH eq "030") {
$port_info = 3;
                           }
if ($CONTROL_RRH eq "040") {
$port_info = 4;
                           }
if ($CONTROL_RRH eq "050") {
$port_info = 5;
                           }

$hash_TILT{$port_info} = $RET_TILT;
#print ("$RET_SERIAL $CONTROL_RRH $RET_TILT\n");
                                           }


                                                                                           }	#end if line match SINGLE or MULTI

                                                                }





$RET_LOG =~ s/\n+\s+REASON\s+\=\s+/ REASON=/g;
$RET_LOG =~ s/RESULT\s+\=\s+/RESULT=/g;
@array_RTRV_RET_STS_each_line = split(/\n/, $RET_LOG);
foreach $array_RTRV_RET_STS_each_line (@array_RTRV_RET_STS_each_line) {
$array_RTRV_RET_STS_each_line =~ s/^\s+//g;
if (($array_RTRV_RET_STS_each_line =~ m/RESULT/) && ($array_RTRV_RET_STS_each_line =~ m/NOK/) && ($array_RTRV_RET_STS_each_line =~ m/REASON/)) {
$ret_sts_nok = $array_RTRV_RET_STS_each_line;
                                                                                                                                               }
                                                                      }



#                                       }			#END IF BSM VERSION MATCH 3.0.0

###########################################
#    END GET RET SERIAL NUMBER & TILT     #
###########################################

########################
# START RTRV_SUBC_STS  #
########################

$ssh->print("cmdx 1 RTRV-SUBC-STS:BTS=$bts_id;");
$ssh->waitfor(';');
$RTRV_SUBC_STS = $ssh->waitfor('COMPLETED');
print ("$RTRV_SUBC_STS$completed\n\n");
print (FILE_3G "$RTRV_SUBC_STS$completed\n\n");

my (@array_RTRV_SUBC_STS_each_line, $array_RTRV_SUBC_STS_each_line);
@array_RTRV_SUBC_STS_each_line = split(/\n/, $RTRV_SUBC_STS);

my ($SECTOR,$FA,$SUBC_STS,$TX_STS,$SERV,$SEC_CONF,$FA_CONF,$FA_TYPE,$RRH_PATH);
my ($RRH_PORT,$OVCH,$LINK,$IPC,$PCF,$VOICE,$PACKET_FDCH);




foreach $array_RTRV_SUBC_STS_each_line (@array_RTRV_SUBC_STS_each_line) {
if ($array_RTRV_SUBC_STS_each_line =~ m/^\s+\d+/) {

if ($array_RTRV_SUBC_STS_each_line =~ m/^\s+\d+\s+\d+/) {
$array_RTRV_SUBC_STS_each_line =~ s/^\s+//g;
$array_RTRV_SUBC_STS_each_line =~ s/\s+\(/\(/g;
($SECTOR,$FA,$SUBC_STS,$TX_STS,$SERV,$SEC_CONF,$FA_CONF,$FA_TYPE,$RRH_PATH,$RRH_PORT,$OVCH,$LINK,$IPC,$PCF,$VOICE,$PACKET_FDCH) = split(/\s+/, $array_RTRV_SUBC_STS_each_line);
$SERV =~ s/\(/ \(/g;
#print ("$SECTOR $FA $SUBC_STS $TX_STS $SERV $SEC_CONF $FA_CONF $FA_TYPE $RRH_PATH $RRH_PORT $OVCH $LINK $IPC $PCF $VOICE $PACKET_FDCH\n");
$hash_subsc_sts_sector{$SECTOR} = $SECTOR;
$hash_subsc_sts_fa{$FA} = $FA;
$hash_subsc_sts_sector_fa{$SECTOR}{$FA} = "$SECTOR $FA";
$hash_subsc_sts_info{$SECTOR}{$FA}{SUBC_STS} = $SUBC_STS;
$hash_subsc_sts_info{$SECTOR}{$FA}{TX_STS} = $TX_STS;
$hash_subsc_sts_info{$SECTOR}{$FA}{SERV} = $SERV;
$hash_subsc_sts_info{$SECTOR}{$FA}{SEC_CONF} = $SEC_CONF;
$hash_subsc_sts_info{$SECTOR}{$FA}{FA_CONF} = $FA_CONF;
$hash_subsc_sts_info{$SECTOR}{$FA}{FA_TYPE} = $FA_TYPE;
$hash_subsc_sts_info{$SECTOR}{$FA}{RRH_PATH} = $RRH_PATH;
$hash_subsc_sts_info{$SECTOR}{$FA}{RRH_PORT} = $RRH_PORT;
$hash_subsc_sts_info{$SECTOR}{$FA}{OVCH} = $OVCH;
$hash_subsc_sts_info{$SECTOR}{$FA}{LINK} = $LINK;
$hash_subsc_sts_info{$SECTOR}{$FA}{IPC} = $IPC;
$hash_subsc_sts_info{$SECTOR}{$FA}{PCF} = $PCF;
$hash_subsc_sts_info{$SECTOR}{$FA}{VOICE} = $VOICE;
$hash_subsc_sts_info{$SECTOR}{$FA}{PACKET_FDCH} = $PACKET_FDCH;
                                                        }
else {
$array_RTRV_SUBC_STS_each_line =~ s/^\s+//g;
$array_RTRV_SUBC_STS_each_line =~ s/\s+\(/\(/g;
($FA,$SUBC_STS,$TX_STS,$SERV,$SEC_CONF,$FA_CONF,$FA_TYPE,$RRH_PATH,$RRH_PORT,$OVCH,$LINK,$IPC,$PCF,$VOICE,$PACKET_FDCH) = split(/\s+/, $array_RTRV_SUBC_STS_each_line);
$SERV =~ s/\(/ \(/g;
#print ("$SECTOR $FA $SUBC_STS $TX_STS $SERV $SEC_CONF $FA_CONF $FA_TYPE $RRH_PATH $RRH_PORT $OVCH $LINK $IPC $PCF $VOICE $PACKET_FDCH\n");
$hash_subsc_sts_sector{$SECTOR} = $SECTOR;
$hash_subsc_sts_fa{$FA} = $FA;
$hash_subsc_sts_sector_fa{$SECTOR}{$FA} = "$SECTOR $FA";
$hash_subsc_sts_info{$SECTOR}{$FA}{SUBC_STS} = $SUBC_STS;
$hash_subsc_sts_info{$SECTOR}{$FA}{TX_STS} = $TX_STS;
$hash_subsc_sts_info{$SECTOR}{$FA}{SERV} = $SERV;
$hash_subsc_sts_info{$SECTOR}{$FA}{SEC_CONF} = $SEC_CONF;
$hash_subsc_sts_info{$SECTOR}{$FA}{FA_CONF} = $FA_CONF;
$hash_subsc_sts_info{$SECTOR}{$FA}{FA_TYPE} = $FA_TYPE;
$hash_subsc_sts_info{$SECTOR}{$FA}{RRH_PATH} = $RRH_PATH;
$hash_subsc_sts_info{$SECTOR}{$FA}{RRH_PORT} = $RRH_PORT;
$hash_subsc_sts_info{$SECTOR}{$FA}{OVCH} = $OVCH;
$hash_subsc_sts_info{$SECTOR}{$FA}{LINK} = $LINK;
$hash_subsc_sts_info{$SECTOR}{$FA}{IPC} = $IPC;
$hash_subsc_sts_info{$SECTOR}{$FA}{PCF} = $PCF;
$hash_subsc_sts_info{$SECTOR}{$FA}{VOICE} = $VOICE;
$hash_subsc_sts_info{$SECTOR}{$FA}{PACKET_FDCH} = $PACKET_FDCH;
     }

                                                  }
                                                                        }
########################
#  END RTRV_SUBC_STS   #
########################


#########################################################
#    START GET FA INFORMATION FROM RTRV-BTS_FA-CONF     #
#########################################################
foreach $hash_SUBSYS_CONF_FA_INDEX (sort keys %hash_SUBSYS_CONF_FA_INDEX) {	#start fa_index
$ssh->print("cmdx 1 RTRV-BTS_FA-CONF:BTS=$bts_id,FA_INDEX=$hash_SUBSYS_CONF_FA_INDEX~$hash_SUBSYS_CONF_FA_INDEX;");
$ssh->waitfor(';');
$BTS_FA_CONF_LOG = $ssh->waitfor('COMPLETED');
print ("$BTS_FA_CONF_LOG$completed\n\n");
print (FILE_3G "$BTS_FA_CONF_LOG$completed\n\n");


$BTS_FA_CONF_FA_INDEX{$hash_SUBSYS_CONF_FA_INDEX} = $hash_SUBSYS_CONF_FA_INDEX;

#foreach $split_each_location (@split_each_location) {	#start foreach location


@split_each_line = split(/\n/, $BTS_FA_CONF_LOG);
#if (($split_each_location =~ m/PCS/) || ($split_each_location =~ m/CELLULAR/)) {	#start if pcs or cellular
foreach $split_each_line (@split_each_line) {	#start foreach line







if ($split_each_line =~ m/\s+STATUS/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/STATUS/) {
$_ =~ s/STATUS://g;
#$STATUS = $_;
$BTS_FA_CONF_STATUS{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                    }
                } 
                                     } 


if ($split_each_line =~ m/\s+FA_ID/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/FA_ID/) {
$_ =~ s/FA_ID://g;
#$FA_ID = $_;
$BTS_FA_CONF_FA_ID{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                   }
                } 
                                     } 



if ($split_each_line =~ m/\s+FA_KIND/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/FA_KIND/) {
$_ =~ s/FA_KIND://g;
#$FA_KIND = $_;
$BTS_FA_CONF_FA_KIND{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                     }
                } 
                                       }

if ($split_each_line =~ m/\s+BCP/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/BCP/) {
$_ =~ s/BCP://g;
#$BCP = $_;
$BTS_FA_CONF_BCP{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                 }
                } 
                                   }

if (($split_each_line =~ m/\s+RRH_PORT_GROUP/) || ($split_each_line =~ m/\s+RU_PORT_GROUP/)) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if (($_ =~m/RRH_PORT_GROUP/) || ($_ =~m/RU_PORT_GROUP/)) {
$_ =~ s/RRH_PORT_GROUP://g;
$_ =~ s/RU_PORT_GROUP://g;
#$RRH_PORT_GROUP = $_;

$BTS_FA_CONF_RRH_PORT_GROUP{$hash_SUBSYS_CONF_FA_INDEX} = $_;
#print ("$BTS_FA_CONF_RRH_PORT_GROUP{$hash_SUBSYS_CONF_FA_INDEX}\n");
                                                         }
                } 
                                                                                             }


if ($split_each_line =~ m/\s+PATH/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/PATH/) {
$_ =~ s/PATH://g;
#$PATH = $_;
$BTS_FA_CONF_PATH{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                  }
                } 
                                    }

if ($split_each_line =~ m/\s+MAX_NEW_CALL_LOAD/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/MAX_NEW_CALL_LOAD/) {
$_ =~ s/MAX_NEW_CALL_LOAD://g;
#$MAX_NEW_CALL_LOAD = $_;
$BTS_FA_CONF_MAX_NEW_CALL_LOAD{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                               }
                } 
                                                 }

if ($split_each_line =~ m/\s+BAND_CLASS_INDEX/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/BAND_CLASS_INDEX/) {
$_ =~ s/BAND_CLASS_INDEX://g;
#$BND_CLS_IND = $_;
$BTS_FA_CONF_BND_CLS_IND{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                              }
                } 
                                                }


if ($split_each_line =~ m/\s+RC_QPCH_HASH_IND/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/RC_QPCH_HASH_IND/) {
$_ =~ s/RC_QPCH_HASH_IND://g;
#$RC_QPCH_HASH_IND = $_;
$BTS_FA_CONF_RC_QPCH_HASH_IND{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                              }
                } 
                                                }

if ($split_each_line =~ m/\s+CLK_ADV/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/CLK_ADV/) {
$_ =~ s/CLK_ADV://g;
#$CLK_ADV = $_;
$BTS_FA_CONF_CLK_ADV{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                     }
                } 
                                       }
if ($split_each_line =~ m/\s+HO_CE_RESERVE_RATIO/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/HO_CE_RESERVE_RATIO/) {
$_ =~ s/HO_CE_RESERVE_RATIO://g;
#$HO_CE_RESERVE_RATIO = $_;
$BTS_FA_CONF_HO_CE_RESERVE_RATIO{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                                 }
                } 
                                                   }


if ($split_each_line =~ m/\s+SERV_TYPE/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/SERV_TYPE/) {
$_ =~ s/SERV_TYPE://g;
#$SERV_TYPE = $_;
$BTS_FA_CONF_SERV_TYPE{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                       }
                } 
                                                   }


if ($split_each_line =~ m/\s+OTA_SID/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/OTA_SID/) {
$_ =~ s/OTA_SID://g;
#$OTA_SID = $_;
$BTS_FA_CONF_OTA_SID{$hash_SUBSYS_CONF_FA_INDEX} = $_;
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
#$OTA_NID = $_;
$BTS_FA_CONF_OTA_NID{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                    }
                } 
                                       }

if ($split_each_line =~ m/\s+TX_DIVERSITY/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/TX_DIVERSITY/) {
$_ =~ s/TX_DIVERSITY://g;
#$TX_DIVERSITY = $_;
$BTS_FA_CONF_TX_DIVERSITY{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                    }
                } 
                                            }


if ($split_each_line =~ m/\s+DATA_FA_FLAG/) {
$split_each_line =~ s/\s+\:\s+/\:/g; 
$split_each_line =~ s/^\s+//g; 
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
if ($_ =~m/DATA_FA_FLAG/) {
$_ =~ s/DATA_FA_FLAG://g;
#$DATA_FA_FLAG = $_;
$BTS_FA_CONF_DATA_FA_FLAG{$hash_SUBSYS_CONF_FA_INDEX} = $_;
                          }
                } 
                                            }


                            

                                                                               #}	#end if pcs or cellular


                                            }	#end foreach line

                                                    #}	#end foreach location

                                                                          }	#end fa_index

#start print all values
my $count_carriers = 0;


foreach $BTS_FA_CONF_FA_INDEX (sort keys %BTS_FA_CONF_FA_INDEX) {
if ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "PCS") {
$count_carriers++;
                                                              }
if ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "CELLULAR") {
$fa_800_bsm = "Yes";
                                                                   }
                                                                 }

if (!$fa_800_bsm) {
$fa_800_bsm = "No";
                  }
#end print all values
$hash_num_carriers{$cascade} = $count_carriers;		#number of carrier
#print ("$hash_num_carriers{$cascade}\n");




#if (($BTS_FA_CONF_FA_ID{0} eq "$mapping_fa_id{0}") && ($BTS_FA_CONF_FA_KIND{0} eq "NOR_FA")) {
#$commerical_3G = "YES";
#                                                                                             }
#else {
#$commerical_3G = "NO";
#     }


#########################################################
#     END GET FA INFORMATION FROM RTRV-BTS_FA-CONF      #
#########################################################

###################################
# START GET BCP SOFTWARE/FIRMWARE #
###################################
$ssh->print("cmdx 1 RTRV-INVT-INF:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id,BD_TYPE=BCP,BCP=0~1;");
$ssh->waitfor(';');
$INVT_INF_BCP_LOG = $ssh->waitfor('COMPLETED');
print ("$INVT_INF_BCP_LOG$completed\n\n");
print (FILE_3G "$INVT_INF_BCP_LOG$completed\n\n");

$INVT_INF_BCP_LOG =~ s/\s+\n+/\n/g;
my ($loc_bcp);
my (@array_invt_bcp_each_line, $array_invt_bcp_each_line);
@array_invt_bcp_each_line = split(/\n+/, $INVT_INF_BCP_LOG);
foreach $array_invt_bcp_each_line (@array_invt_bcp_each_line) {
$array_invt_bcp_each_line =~ s/^\s+//g;
if ($array_invt_bcp_each_line =~ m/LOC\s+\:\s+/) {
$loc_bcp = $array_invt_bcp_each_line;
$loc_bcp =~ s/LOC\s+\:\s+//g;
$hash_bcp_loc{$loc_bcp} = $loc_bcp;				#hash bcp location
#print ("$loc_bcp\n");
                                                 }
if ($array_invt_bcp_each_line =~ m/PROCESSOR\s+H\/W\s+NAME/) {
$array_invt_bcp_each_line =~ s/PROCESSOR\s+H\/W\s+NAME\s+\=\s+//g;
$hash_bcp_processor{$loc_bcp} = $array_invt_bcp_each_line;	#hash bcp processor
#print ("$array_invt_bcp_each_line\n");
                                                             }

if ($array_invt_bcp_each_line =~ m/EPLD-CTRL\s+VER/) {
$array_invt_bcp_each_line =~ s/EPLD-CTRL\s+VER\s+\=\s+//g;
$hash_bcp_ctrl{$loc_bcp} = $array_invt_bcp_each_line;		#hash bcp ctrl
#print ("$array_invt_bcp_each_line\n");
                                                     }

if ($array_invt_bcp_each_line =~ m/EPLD-CLOCK\s+VER/) {
$array_invt_bcp_each_line =~ s/EPLD-CLOCK\s+VER\s+\=\s+//g;
$hash_bcp_clock{$loc_bcp} = $array_invt_bcp_each_line;		#hash bcp clock
#print ("$array_invt_bcp_each_line\n");
                                                      }

if ($array_invt_bcp_each_line =~ m/REASON\s+\=\s+BCP\s+NO\s+RESPONSE/) {
$hash_bcp_ctrl{$loc_bcp} = "BCP NO RESPONSE";			#bcp no response (ctrl)
$hash_bcp_clock{$loc_bcp} = "BCP NO RESPONSE";			#bcp no response (clock)
                                                                       }


                                                              }

###################################
#  END GET BCP SOFTWARE/FIRMWARE  #
###################################



####################################
# START GET GPSR SOFTWARE/FIRMWARE #
####################################
$ssh->print("cmdx 1 RTRV-INVT-INF:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id,BD_TYPE=GPSR,BCP=0~1;");
$ssh->waitfor(';');
$INVT_INF_GPSR_LOG = $ssh->waitfor('COMPLETED');
print ("$INVT_INF_GPSR_LOG$completed\n\n");
print (FILE_3G "$INVT_INF_GPSR_LOG$completed\n\n");

$INVT_INF_GPSR_LOG =~ s/\s+\n+/\n/g;
my ($gpsr_loc);
my (@array_gpsr_each_line, $array_gpsr_each_line);
$INVT_INF_GPSR_LOG =~ s/\[//g;
$INVT_INF_GPSR_LOG =~ s/\]//g;
$INVT_INF_GPSR_LOG =~ s/\n+\s+VERSION/ VERSION/g;
@array_gpsr_each_line = split(/\n+/, $INVT_INF_GPSR_LOG);
foreach $array_gpsr_each_line (@array_gpsr_each_line) {
if ($array_gpsr_each_line =~ m/LOC\s+\:\s+/) {
$array_gpsr_each_line =~ s/^\s+LOC\s+\:\s+//g;
$gpsr_loc = $array_gpsr_each_line;
$hash_gpsr_loc{$gpsr_loc} = $gpsr_loc;			#gpsr location
#print ("$gpsr_loc\n");
                                             }
if ($array_gpsr_each_line =~ m/FW\s+INFORMATION\s+VERSION\s+\:\s+/) {
$array_gpsr_each_line =~ s/^\s+FW\s+INFORMATION\s+VERSION\s+\:\s+//g;
$hash_gpsr_fw{$gpsr_loc} = $array_gpsr_each_line;	#gpsr firmware
#print ("$array_gpsr_each_line\n");
                                                                    }

if ($array_gpsr_each_line =~ m/REASON = BCP NO RESPONSE/) {
$hash_gpsr_fw{$gpsr_loc} = "BCP NO RESPONSE";
                                                          }

                                                      }


####################################
#  END GET GPSR SOFTWARE/FIRMWARE  #
####################################


####################################
# START GET EAIU SOFTWARE/FIRMWARE #
####################################
$ssh->print("cmdx 1 RTRV-INVT-INF:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id,BD_TYPE=EAIU;");
$ssh->waitfor(';');
$INVT_INF_EAIU_LOG = $ssh->waitfor('COMPLETED');
print ("$INVT_INF_EAIU_LOG$completed\n\n");
print (FILE_3G "$INVT_INF_EAIU_LOG$completed\n\n");

$INVT_INF_EAIU_LOG =~ s/\s+\n+/\n/g;
my $eaiu_loc = "BTS\_$bts_id\/EAIU";
$hash_eaiu_loc{$eaiu_loc} = $eaiu_loc;					#eaiu location
$INVT_INF_EAIU_LOG =~ s/\[//g;
$INVT_INF_EAIU_LOG =~ s/\]//g;
$INVT_INF_EAIU_LOG =~ s/\n+\s+VERSION/ VERSION/g;

my (@array_eaiu_each_line, $array_eaiu_each_line);
@array_eaiu_each_line = split(/\n+/, $INVT_INF_EAIU_LOG);

foreach $array_eaiu_each_line (@array_eaiu_each_line) {
if ($array_eaiu_each_line =~ m/^\s+FW\s+INFORMATION\s+VERSION\s+\:\s+/) {
$array_eaiu_each_line =~ s/^\s+FW\s+INFORMATION\s+VERSION\s+\:\s+//g;
$hash_eaiu_fw{$eaiu_loc} = $array_eaiu_each_line;			#eaiu firmware
#print ("$eaiu_loc $array_eaiu_each_line\n");
                                                                        }

if ($array_eaiu_each_line =~ m/REASON = BCP NO RESPONSE/) {
$hash_eaiu_fw{$eaiu_loc} = "BCP NO RESPONSE";
                                                          }

                                                      }
####################################
#  END GET EAIU SOFTWARE/FIRMWARE  #
####################################

####################################################
# START GET COMPARE BTS FIRMWARE WITH BSM FIRMWARE #
####################################################
$ssh->print("cmdx 1 CMPR-FW-INF:SUBSYSTEM=BTS,BTS=$bts_id,BASE_VERSION=BSM;");
$ssh->waitfor(';');
$CMPR_FW_INF_BTS_LOG = $ssh->waitfor('COMPLETED');
print ("$CMPR_FW_INF_BTS_LOG$completed\n\n");
print (FILE_3G "$CMPR_FW_INF_BTS_LOG$completed\n\n");

if ($CMPR_FW_INF_BTS_LOG =~ m/NO\s+DIFFERENT\s+RESULT/) {	#start if log match NO DIFFERENT RESULT
$CMPR_FW_INF_NO_RESULT = "NO DIFFERENT RESULT";


                                                        }	#end if log match NO DIFFERENT RESULT

if ($CMPR_FW_INF_BTS_LOG =~ m/\./) {		#start if log match \.
my (@array_CMPR_FW_INF_BTS_each_line, $array_CMPR_FW_INF_BTS_each_line);
@array_CMPR_FW_INF_BTS_each_line = split(/\n+/, $CMPR_FW_INF_BTS_LOG);

foreach $array_CMPR_FW_INF_BTS_each_line (@array_CMPR_FW_INF_BTS_each_line) {
if ($array_CMPR_FW_INF_BTS_each_line =~ m/\./) {
$array_CMPR_FW_INF_BTS_each_line =~ s/^\s+//g;
@_ = split(/\s+/, $array_CMPR_FW_INF_BTS_each_line);
#print ("$_[0] $_[3] $_[4]\n");
$hash_CMPR_FW_INF_BTS{$_[0]}{BASE_VERSION} = "$_[3]";
$hash_CMPR_FW_INF_BTS{$_[0]}{TARGET_VERSION} = "$_[4]";
                                               }




                                                                            }



                                   }     	#end if log match \.
            
#print Dumper(\%hash_CMPR_FW_INF_BTS);
####################################################
#  END GET COMPARE BTS FIRMWARE WITH BSM FIRMWARE  #
####################################################

############################################
# START GET CMPR ROM MISMATCH INFORMATION  #
############################################
$ssh->print("cmdx 1 CMPR-ROM-INF:SUBSYSTEM=BTS,BTS_TYPE=IP,BTS=$bts_id~$bts_id,PROCESSOR=ALL,ROM_IMG_TYPE=ALL,ROM_IMG_LOC_TYPE=MEMORY_RUNNING;");
$ssh->waitfor(';');
$CMPR_ROM_INF_LOG = $ssh->waitfor('COMPLETED');
print ("$CMPR_ROM_INF_LOG$completed\n\n");
print (FILE_3G "$CMPR_ROM_INF_LOG$completed\n\n");


my ($cmpr_rom_loc);
$CMPR_ROM_INF_LOG =~ s/\s+\n+/\n/g;
my (@array_cmpr_rom_each_line, $array_cmpr_rom_each_line);
@array_cmpr_rom_each_line = split(/\n+/, $CMPR_ROM_INF_LOG);
foreach $array_cmpr_rom_each_line (@array_cmpr_rom_each_line) {
$array_cmpr_rom_each_line =~ s/^\s+//g;
if ($array_cmpr_rom_each_line =~ m/BCP_/) {

@_ = split(/\s+/, $array_cmpr_rom_each_line);
$cmpr_rom_loc = $_[0];
if ($array_cmpr_rom_each_line =~ m/NO\s+MISMATCH\s+INFORMATION/) {
$hash_cmpr_rom_info{$cmpr_rom_loc}{"NO MISMATCH INFORMATION"} = "NO MISMATCH INFORMATION";
#print ("$array_cmpr_rom_each_line\n");
                                                                 }

if ($array_cmpr_rom_each_line =~ m/DIFF_VER/) {
$hash_cmpr_rom_info{$cmpr_rom_loc}{$_[1]} = "$_[1] MISMATCH";
#print ("$array_cmpr_rom_each_line\n");
                                              }

if ($array_cmpr_rom_each_line =~ m/BCP NO RESPONSE/) {
$hash_cmpr_rom_info{$cmpr_rom_loc}{"BCP NO RESPONSE"} = "BCP NO RESPONSE";
#print ("$array_cmpr_rom_each_line\n");
                                                     }

if ($array_cmpr_rom_each_line =~ m/CEP NO RESPONSE/) {
$hash_cmpr_rom_info{$cmpr_rom_loc}{"CEP NO RESPONSE"} = "CEP NO RESPONSE";
#print ("$array_cmpr_rom_each_line\n");
                                                     }



                                          }


                                                              }


#print Dumper(\%hash_cmpr_rom_info);



############################################
#  END GET CMPR ROM MISMATCH INFORMATION   #
############################################




################################
#  START GET ROM INFORMATION   #
################################
$ssh->print("cmdx 1 RTRV-ROM-INF:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id,PROCESSOR=BCP,BCP=0~0,ROM_INFO_TYPE=ALL;");
$ssh->waitfor(';');
my $RTRV_ROM_INF = $ssh->waitfor('COMPLETED');
$RTRV_ROM_INF = "$RTRV_ROM_INF$completed";
#print ("$RTRV_ROM_INF\n\n");
print (FILE_3G "$RTRV_ROM_INF\n\n");


if ($RTRV_ROM_INF =~ m/REASON = BCP NO RESPONSE/) {
$hash_BOOTER{$bts_id}{BOOTER_RUN} = "BCP NO RESPONSE";
$hash_BOOTER{$bts_id}{BOOTER_SAVE} = "BCP NO RESPONSE";
$hash_KERNEL{$bts_id}{KERNEL_RUN} = "BCP NO RESPONSE";
$hash_KERNEL{$bts_id}{KERNEL_SAVE0} = "BCP NO RESPONSE";
$hash_KERNEL{$bts_id}{KERNEL_SAVE1} = "BCP NO RESPONSE";

                                                  }


my (@ROM_each_line, $ROM_each_line);
@ROM_each_line = split(/\n/, $RTRV_ROM_INF);
foreach $ROM_each_line (@ROM_each_line) {	#START FOREACH LINE OF ROM LOG
$ROM_each_line =~ s/^\s+//g;
$ROM_each_line =~ s/^\*\s+/*/g;
$ROM_each_line =~ s/\s+/,/g;
@_ = split(/,/, $ROM_each_line);

my ($booter_run, $booter_saved, $KERNEL_run, $KERNEL_saved);
$_[0] =~ s/\s+//g;
$_[5] =~ s/\s+//g;
if ($_[0] eq "*BOOTER") {
$booter_run = "$_[5]";
$hash_BOOTER{$bts_id}{BOOTER_RUN} = "$booter_run";
#print ("BTS $bts_id BOOTER_RUN: $booter_run\n");
                        }
if ($_[0] eq "BOOTER") {
$booter_saved = "$_[5]";
$hash_BOOTER{$bts_id}{BOOTER_SAVE} = "$booter_saved";
#print ("BTS $bts_id BOOTER_SAVE: $booter_saved\n");
                       }

if ($_[0] eq "*KERNEL") {
$KERNEL_run = "$_[5]";
$hash_KERNEL{$bts_id}{KERNEL_RUN} = "$KERNEL_run";
#print ("BTS $bts_id KERNEL_RUN: $KERNEL_run\n");
                        }
if ($_[0] eq "KERNEL0") {
$KERNEL_saved = "$_[5]";
$hash_KERNEL{$bts_id}{KERNEL_SAVE0} = "$KERNEL_saved";
#print ("BTS $bts_id KERNEL_SAVE0: $KERNEL_saved\n");
                        }
if ($_[0] eq "KERNEL1") {
$KERNEL_saved = "$_[5]";
$hash_KERNEL{$bts_id}{KERNEL_SAVE1} = "$KERNEL_saved";
#print ("BTS $bts_id KERNEL_SAVE1: $KERNEL_saved\n\n")
                        }



                                        }	#END FOREACH LINE OF ROM LOG
#print Dumper(\%hash_BOOTER);
#print Dumper(\%hash_KERNEL);
################################
#   END GET ROM INFORMATION    #
################################


##################################
# START GET 800 AND 1900 RRU QTY #
##################################
$ssh->print("cmdx 1 RTRV-INVT-INF:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id,BD_TYPE=RRH,BCP=0~1,PORT=0~5,CASCADE=0~0;");
$ssh->waitfor(';');
$INVT_INF_RRH_LOG = $ssh->waitfor('COMPLETED');
print ("$INVT_INF_RRH_LOG$completed\n\n");
print (FILE_3G "$INVT_INF_RRH_LOG$completed\n\n");

my (@invt_inf_rrh_each_line, $invt_inf_rrh_each_line);


my $rru_1900_count = 0;
my $rru_800_count = 0;
@invt_inf_rrh_each_line = split(/\n+/, $INVT_INF_RRH_LOG);
foreach $invt_inf_rrh_each_line (@invt_inf_rrh_each_line) {
$invt_inf_rrh_each_line =~ s/^\s+//g;
if ($invt_inf_rrh_each_line =~ m/RRH_/) {

if (($invt_inf_rrh_each_line =~ m/000/) || ($invt_inf_rrh_each_line =~ m/010/) || ($invt_inf_rrh_each_line =~ m/020/) || ($invt_inf_rrh_each_line =~ m/100/) || ($invt_inf_rrh_each_line =~ m/110/) || ($invt_inf_rrh_each_line =~ m/120/)) {
#print ("$invt_inf_rrh_each_line\n");
$rru_1900_count++;
                                                                                                                                                                                                                                            }

if (($invt_inf_rrh_each_line =~ m/030/) || ($invt_inf_rrh_each_line =~ m/040/) || ($invt_inf_rrh_each_line =~ m/050/) || ($invt_inf_rrh_each_line =~ m/130/) || ($invt_inf_rrh_each_line =~ m/140/) || ($invt_inf_rrh_each_line =~ m/150/)) {
#print ("$invt_inf_rrh_each_line\n");
$rru_800_count++;
                                                                                                                                                                                                                                            }



                                        }
                                                          }
$hash_1900_count{$cascade} = $rru_1900_count;			#1900 rru quantity
$hash_800_count{$cascade} = $rru_800_count;			#800 rru quantity
#print ("1900 RRU QTY: $hash_1900_count{$cascade}\n800 RRU QTY: $hash_800_count{$cascade}\n");


##################################
#  END GET 800 AND 1900 RRU QTY  #
##################################


###################################
# START GET RRH FIRMWARE/SOFTWARE #
###################################
my ($inf_rrh_loc);
my (@array_rrh_each_line, $array_rrh_each_line);
$INVT_INF_RRH_LOG =~ s/\[//g;
$INVT_INF_RRH_LOG =~ s/\]//g;
$INVT_INF_RRH_LOG =~ s/\n+\s+VERSION/ VERSION/g;

@array_rrh_each_line = split(/\n+/, $INVT_INF_RRH_LOG);
foreach $array_rrh_each_line (@array_rrh_each_line) {
$array_rrh_each_line =~ s/^\s+//g;
if ($array_rrh_each_line =~ m/RRH_/) {
$inf_rrh_loc = $array_rrh_each_line;
$inf_rrh_loc =~ s/\s+//g;
$hash_inf_rrh_loc{$inf_rrh_loc} = $inf_rrh_loc;		#rrh location
#print ("$array_rrh_each_line\n");
                                     }
if ($array_rrh_each_line =~ m/FW\s+INFORMATION\s+VERSION\s+\:\s+/) {
$array_rrh_each_line =~ s/FW\s+INFORMATION\s+VERSION\s+\:\s+//g;
$inf_rrh_loc =~ s/\s+//g;
$array_rrh_each_line =~ s/\s+//g;
$hash_inf_rrh_fw{$inf_rrh_loc} = $array_rrh_each_line;	#rrh firmware
#print ("$array_rrh_each_line\n");
                                                                   }


if ($array_rrh_each_line =~ m/NO\s+RESPONSE/) {
$hash_inf_rrh_fw{$inf_rrh_loc} = "NO RESPONSE";		#no response
                                              }


                                                    }
###################################
#  END GET RRH FIRMWARE/SOFTWARE  #
###################################

#################################
# START RTRV-BTS_DIVERSITY-DATA #
#################################
$ssh->print("cmdx 1 RTRV-BTS_DIVERSITY-DATA:BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
my $RTRV_BTS_DIVERSITY = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_DIVERSITY$completed\n\n");
print (FILE_3G "$RTRV_BTS_DIVERSITY$completed\n\n");

my (@array_each_line_DIVERSITY, $array_each_line_DIVERSITY);
@array_each_line_DIVERSITY = split(/\n+/, $RTRV_BTS_DIVERSITY);

foreach $array_each_line_DIVERSITY (@array_each_line_DIVERSITY) {		#START FOREACH LINE DIVERSITY
if ($array_each_line_DIVERSITY =~ m/RX_DIVERSITY\[PCS\]/) {			#START IF LINE MATCH RX_DIVERSITY[PCS]
$array_each_line_DIVERSITY =~ s/^\s+//g;
$array_each_line_DIVERSITY =~ s/\s+\:\s+/\:/g;
$array_each_line_DIVERSITY =~ s/\s+/ /g;


my (@array_each_div, $array_each_div);
@array_each_div = split(/\s+/, $array_each_line_DIVERSITY);

foreach $array_each_div (@array_each_div) {					#START FOREACH $ARRAY_EACH_DIV
@_ = split(/\:/, $array_each_div);
$_[0] =~ s/\s+//g;
if ($_[0] eq "RX_DIVERSITY[PCS]") {						#START IF $_[0] MATCH RX_DIVERSITY[PCS]
$_[1] =~ s/\s+//g;
$hash_RX_DIVERSITY{$bts_id} = "$_[1]";
#print ("$_[1]\n");
                                  }						#END IF $_[0] MATCH RX_DIVERSITY[PCS]
                                          }					#END FOREACH $ARRAY_EACH_DIV


                                                          }			#END IF LINE MATCH RX_DIVERSITY[PCS]

                                                                }		#END FOREACH LINE DIVERSITY
#################################
#  END RTRV-BTS_DIVERSITY-DATA  #
#################################


#######################################
# START FIND CICA QTY FOR BCP 0 AND 1 #
#######################################
$ssh->print("cmdx 1 RTRV-BTS_CEP-CONF:BTS=$bts_id,BCP=0~1,CEP=0~2;");
$ssh->waitfor(';');
$BTS_CEP_CONF_LOG = $ssh->waitfor('COMPLETED');
print ("$BTS_CEP_CONF_LOG$completed\n\n");
print (FILE_3G "$BTS_CEP_CONF_LOG$completed\n\n");

my $RTRV_BTS_CEP_CONF = "$BTS_CEP_CONF_LOG";					#WILL USE FOR DIVERSITY

$BTS_CEP_CONF_LOG =~ s/\-+\n+//g;
$BTS_CEP_CONF_LOG =~ s/\s+\:\s+/:/g;
@array_cep_conf_each_loc = split(/LOCATION:/, $BTS_CEP_CONF_LOG);

foreach $array_cep_conf_each_loc (@array_cep_conf_each_loc) {
if ($array_cep_conf_each_loc =~ m/BTS_CEP\(/) {

@array_cep_conf_each_line = split(/\n/, $array_cep_conf_each_loc);

foreach $array_cep_conf_each_line (@array_cep_conf_each_line) {
$array_cep_conf_each_line =~ s/^\s+//g;

if ($array_cep_conf_each_line =~ m/BTS_CEP\(/) {
$array_cep_conf_each_line =~ s/BTS_CEP\(//g;
$array_cep_conf_each_line =~ s/\)//g;

@_= split(/,/, $array_cep_conf_each_line);
foreach $_ (@_) {
if ($_ =~ m/BCP=/) {
$_ =~ s/BCP=/BCP_/g;
$cep_conf_BCP = $_;
#print ("$cep_conf_BCP\n");
                   }
if ($_ =~ m/CEP=/) {
$_ =~ s/CEP=/CEP_/g;
$cep_conf_CEP = $_;
$BCP_CEP = "$cep_conf_BCP~$cep_conf_CEP";		#will use for hash for all cep conf parms
#print ("$BCP_CEP\n");
$hash_bcp_cep{$BCP_CEP} = $BCP_CEP;
                   }

                }
                                               }

if ($array_cep_conf_each_line =~ m/STATUS:/) {
@_= split(/\s+/, $array_cep_conf_each_line);
foreach $_ (@_) {
if ($_ =~ m/STATUS:/) {
$_ =~ s/STATUS://g;
#print ("$BCP_CEP $_\n");
                      }
                }
                                             }

if ($array_cep_conf_each_line =~ m/CEP_TYPE:/) {
@_= split(/\s+/, $array_cep_conf_each_line);
foreach $_ (@_) {
if ($_ =~ m/CEP_TYPE:/) {
$_ =~ s/CEP_TYPE://g;
#print ("$BCP_CEP $_\n");
$hash_cep_type{$BCP_CEP} = $_;
                        }
                }
                                               }

if ($array_cep_conf_each_line =~ m/SERV_TYPE:/) {
@_= split(/\s+/, $array_cep_conf_each_line);
foreach $_ (@_) {
if ($_ =~ m/SERV_TYPE:/) {
$_ =~ s/SERV_TYPE://g;
#print ("$BCP_CEP $_\n");
                         }
                }
                                                }


if ($array_cep_conf_each_line =~ m/RX_DIVERSITY_FOR_MODEM_0:/) {
@_= split(/\s+/, $array_cep_conf_each_line);
foreach $_ (@_) {
if ($_ =~ m/RX_DIVERSITY_FOR_MODEM_0:/) {
$_ =~ s/RX_DIVERSITY_FOR_MODEM_0://g;
#print ("$BCP_CEP $_\n");
                                        }
                }
                                                               }


if ($array_cep_conf_each_line =~ m/RX_DIVERSITY_FOR_MODEM_1:/) {
@_= split(/\s+/, $array_cep_conf_each_line);
foreach $_ (@_) {
if ($_ =~ m/RX_DIVERSITY_FOR_MODEM_1:/) {
$_ =~ s/RX_DIVERSITY_FOR_MODEM_1://g;
#print ("$BCP_CEP $_\n\n");
                                        }
                }
                                                               }



#place here
                                                              }
                                              }
                                                            }

my $cica_a_count_0 = 0;
my $cica_d_count_0 = 0;
my $cica_a_count_1 = 0;
my $cica_d_count_1 = 0;
foreach $hash_bcp_cep (sort keys %hash_bcp_cep) {

if (($hash_bcp_cep =~ m/BCP_0/) && ($hash_cep_type{$hash_bcp_cep} eq "CICA_A")) {
$cica_a_count_0++;
                                                                                }
if (($hash_bcp_cep =~ m/BCP_0/) && ($hash_cep_type{$hash_bcp_cep} eq "CICA_D")) {
$cica_d_count_0++;
                                                                                }


if (($hash_bcp_cep =~ m/BCP_1/) && ($hash_cep_type{$hash_bcp_cep} eq "CICA_A")) {
$cica_a_count_1++;
                                                                                }
if (($hash_bcp_cep =~ m/BCP_1/) && ($hash_cep_type{$hash_bcp_cep} eq "CICA_D")) {
$cica_d_count_1++;
                                                                                }



                                                }

$hash_bbu1_cica_a_bsm{$cascade} = $cica_a_count_0;	#bbu1 cica_a count from bsm
$hash_bbu1_cica_d_bsm{$cascade} = $cica_d_count_0;	#bbu1 cica_d count from bsm
$hash_bbu2_cica_a_bsm{$cascade} = $cica_a_count_1;	#bbu2 cica_a count from bsm
$hash_bbu2_cica_d_bsm{$cascade} = $cica_d_count_1;	#bbu2 cica_d count from bsm

#print ("BBU0 CONFIG: A$hash_bbu1_cica_a_bsm{$cascade}D$hash_bbu1_cica_d_bsm{$cascade}\n");
#print ("BBU1 CONFIG: A$hash_bbu2_cica_a_bsm{$cascade}D$hash_bbu2_cica_d_bsm{$cascade}\n");

#######################################
#  END FIND CICA QTY FOR BCP 0 AND 1  #
#######################################

#######################
# START CEP DIVERSITY #
#######################
$RTRV_BTS_CEP_CONF =~ s/LOCATION/~LOCATION/g;
my (@split_CEP_CONF, $split_CEP_CONF);
@split_CEP_CONF = split(/~/, $RTRV_BTS_CEP_CONF);


foreach $split_CEP_CONF (@split_CEP_CONF) {			#START FOREACH $split_CEP_CONF
$split_CEP_CONF =~ s/\s+\n+/\n/g;
my ($location, $cep_type, $BCP, $CEP);
my (@CEP_CONF_each_line, $CEP_CONF_each_line);
@CEP_CONF_each_line = split(/\n/, $split_CEP_CONF);

foreach $CEP_CONF_each_line (@CEP_CONF_each_line) {		#START FOREACH $CEP_CONF_each_line
$CEP_CONF_each_line =~ s/^\s+//g;
$CEP_CONF_each_line =~ s/\s+\:\s+/\:/g;
$CEP_CONF_each_line =~ s/\s+/ /g;
$CEP_CONF_each_line =~ s/\s+/ /g;
if ($CEP_CONF_each_line =~ m/LOCATION/) {			#START IF MATCH LOCATION
$CEP_CONF_each_line =~ s/LOCATION\:BTS_CEP//g;
$CEP_CONF_each_line =~ s/\(//g;
$CEP_CONF_each_line =~ s/\)//g;
#$location = "$CEP_CONF_each_line";
#$location =~ s/BTS\=\d+,//g;
@_ = split(/,/, $CEP_CONF_each_line);

foreach $_ (@_) {						#START FOREACH $_
if ($_ =~ m/BCP/) {						#START IF MATCH BCP
$BCP = "$_";
$BCP =~ s/BCP\=//g;
$BCP =~ s/\s+//g;
                  }						#END IF MATCH BCP
if ($_ =~ m/CEP/) {						#START IF MATCH CEP
$CEP = "$_";
$CEP =~ s/CEP\=//g;
$CEP =~ s/\s+//g;
                  }						#END IF MATCH CEP
                }						#END FOREACH $_
                                        }			#END IF MATCH LOCATION


if ($CEP_CONF_each_line =~ m/CEP_TYPE/) {			#START IF LINE MATCH CEP_TYPE
@_ = split(/\s+/, $CEP_CONF_each_line);
foreach $_ (@_) {						#START FOREACH $_
if ($_ =~ m/CEP_TYPE/) {					#START IF MATCH CEP_TYPE
my (@array_cep_type, $array_cep_type);
@array_cep_type = split(/\:/, $_);
$cep_type = "$array_cep_type[1]";
$cep_type =~ s/\s+//g;
#print ("$cep_type\n");
                       }					#END IF MATCH CEP_TYPE
                }						#END FOREACH $_
                                        }			#END IF LINE MATCH CEP_TYPE

if ($CEP_CONF_each_line =~ m/RX_DIVERSITY_FOR_MODEM/) {		#START IF LINE MATCH RX_DIVERSITY_FOR_MODEM
@_ = split(/\s+/, $CEP_CONF_each_line);

foreach $_ (@_) {						#START FOREACH $_
if ($_ =~ m/RX_DIVERSITY_FOR_MODEM_0/) {			#START IF MATCH RX_DIVERSITY_FOR_MODEM_0
my (@array_diversity, $array_diversity);
@array_diversity = split(/\:/, $_);
$array_diversity[1] =~ s/\s+//g;
$CICA_TYPE_Diversity{$bts_id}{$BCP}{$CEP}{$cep_type}{RX_DIVERSITY_FOR_MODEM_0} = "$array_diversity[1]";
#print ("$bts_id $BCP $CEP $cep_type RX_DIVERSITY_FOR_MODEM_0 $array_diversity[1]\n");
                                       }			#END IF MATCH RX_DIVERSITY_FOR_MODEM_0

if ($_ =~ m/RX_DIVERSITY_FOR_MODEM_1/) {			#START IF MATCH RX_DIVERSITY_FOR_MODEM_1
my (@array_diversity, $array_diversity);
@array_diversity = split(/\:/, $_);
$array_diversity[1] =~ s/\s+//g;
$CICA_TYPE_Diversity{$bts_id}{$BCP}{$CEP}{$cep_type}{RX_DIVERSITY_FOR_MODEM_1} = "$array_diversity[1]";
#print ("$bts_id $BCP $CEP $cep_type RX_DIVERSITY_FOR_MODEM_1 $array_diversity[1]\n");
                                       }			#END IF MATCH RX_DIVERSITY_FOR_MODEM_1
                }						#END FOREACH $_
                                                      }		#END IF LINE MATCH RX_DIVERSITY_FOR_MODEM





                                                  }		#END FOREACH $CEP_CONF_each_line


                                          }			#END FOREACH $split_CEP_CONF



#print Dumper(\%hash_RX_DIVERSITY);
#print Dumper(\%CICA_TYPE_Diversity);

#######################
#  END CEP DIVERSITY  #
#######################



######################################
#  START GET VLAN MMBS IP ADDRESSES  #
######################################
$ssh->print("cmdx 1 RTRV-BTS_IP_ADDRESS-CONF:BTS=$bts_id,INDEX=0~39;");
$ssh->waitfor(';');
$BTS_IP_ADD_CONF_LOG = $ssh->waitfor('COMPLETED');
print ("$BTS_IP_ADD_CONF_LOG$completed\n\n");
print (FILE_3G "$BTS_IP_ADD_CONF_LOG$completed\n\n");

my (@array_bts_ip_each_line, $array_bts_ip_each_line);
@array_bts_ip_each_line = split(/\n/, $BTS_IP_ADD_CONF_LOG);
foreach $array_bts_ip_each_line (@array_bts_ip_each_line) {
$array_bts_ip_each_line =~ s/^\s+//g;
if ($array_bts_ip_each_line =~ m/^\d+/) {
@_= split(/\s+/, $array_bts_ip_each_line);
if ($_[6] eq "16") {
$hash_vlan16_mmbs_ip_bsm{$cascade} = $_[7];	#VLAN 16 MMBS OAM IP
#print ("$_[6] $_[7]\n");
                   }
if ($_[6] eq "24") {
$hash_vlan24_mmbs_ip_bsm{$cascade} = $_[7];	#VLAN 24 MMBS Side IP
#print ("$_[6] $_[7]\n");
                   }
                                        }


if ($array_bts_ip_each_line =~ m/^\d+/) {
@_= split(/\s+/, $array_bts_ip_each_line);
if ($_[0] eq "0") {
$hash_bts_ip_conf_info{$_[0]}{INDEX} = $_[0];
$hash_bts_ip_conf_info{$_[0]}{STATUS} = $_[1];
$hash_bts_ip_conf_info{$_[0]}{INTF_TYPE} = $_[2];
$hash_bts_ip_conf_info{$_[0]}{SHELF_ID} = $_[3];
$hash_bts_ip_conf_info{$_[0]}{SLOT_ID} = $_[4];
$hash_bts_ip_conf_info{$_[0]}{PORT_ID} = $_[5];
$hash_bts_ip_conf_info{$_[0]}{VLAN_ID} = $_[6];
$hash_bts_ip_conf_info{$_[0]}{IPV4_ADDRESS} = $_[7];
$hash_bts_ip_conf_info{$_[0]}{IPV4_PREFIX_LENGTH} = $_[8];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_OAM} = $_[9];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_1X_SIGNAL} = $_[10];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_1X_BEARER} = $_[11];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_DO_SIGNAL} = $_[12];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_DO_BEARER} = $_[13];
                  }
if ($_[0] eq "1") {
$hash_bts_ip_conf_info{$_[0]}{INDEX} = $_[0];
$hash_bts_ip_conf_info{$_[0]}{STATUS} = $_[1];
$hash_bts_ip_conf_info{$_[0]}{INTF_TYPE} = $_[2];
$hash_bts_ip_conf_info{$_[0]}{SHELF_ID} = $_[3];
$hash_bts_ip_conf_info{$_[0]}{SLOT_ID} = $_[4];
$hash_bts_ip_conf_info{$_[0]}{PORT_ID} = $_[5];
$hash_bts_ip_conf_info{$_[0]}{VLAN_ID} = $_[6];
$hash_bts_ip_conf_info{$_[0]}{IPV4_ADDRESS} = $_[7];
$hash_bts_ip_conf_info{$_[0]}{IPV4_PREFIX_LENGTH} = $_[8];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_OAM} = $_[9];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_1X_SIGNAL} = $_[10];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_1X_BEARER} = $_[11];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_DO_SIGNAL} = $_[12];
$hash_bts_ip_conf_info{$_[0]}{ATTRIBUTE_DO_BEARER} = $_[13];
                  }

                                        }





                                                          }
#print ("VLAN 16 MMBS IP: $hash_vlan16_mmbs_ip_bsm{$cascade}\nVLAN24 MMBS IP: $hash_vlan24_mmbs_ip_bsm{$cascade}\n");

######################################
#   END GET VLAN MMBS IP ADDRESSES   #
######################################


####################################
# START GET VLAN CSR IP ADDRESSES  #
####################################
$ssh->print("cmdx 1 RTRV-BTS_STATIC_ROUTE-CONF:BTS=$bts_id,INDEX=0~127;");
$ssh->waitfor(';');
$BTS_STATIC_ROUTE_CONF_LOG = $ssh->waitfor('COMPLETED');
print ("$BTS_STATIC_ROUTE_CONF_LOG$completed\n\n");
print (FILE_3G "$BTS_STATIC_ROUTE_CONF_LOG$completed\n\n");

my (@array_bts_static_rt_each_line, $array_bts_static_rt_each_line);
@array_bts_static_rt_each_line = split(/\n/, $BTS_STATIC_ROUTE_CONF_LOG);
foreach $array_bts_static_rt_each_line (@array_bts_static_rt_each_line) {
$array_bts_static_rt_each_line =~ s/^\s+//g;
if ($array_bts_static_rt_each_line =~ m/^\d+/) {
@_= split(/\s+/, $array_bts_static_rt_each_line);

$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$_[0]}{STATUS} = "$_[1]";
$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$_[0]}{IPV4_PREFIX} = "$_[2]";
$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$_[0]}{IPV4_PREFIX_LENGTH} = "$_[3]";
$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$_[0]}{DISTANCE} = "$_[4]";
$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$_[0]}{GW_ADDRESS} = "$_[5]";


if ($_[3] eq "32") {
$hash_vlan16_csr_ip_bsm{$cascade} = $_[5];	#VLAN 16 CSR OAM IP
#print ("$_[0] $_[5]\n");
                  }
if ($_[3] eq "0") {
$hash_vlan24_csr_ip_bsm{$cascade} = $_[5];	#VLAN 24 CSR Side IP
#print ("$_[0] $_[5]\n");
                  }

                                               }

                                                                        }
#print ("VLAN 16 CSR IP: $hash_vlan16_csr_ip_bsm{$cascade}\nVLAN 24 CSR IP: $hash_vlan24_csr_ip_bsm{$cascade}\n");
####################################
#  END GET VLAN CSR IP ADDRESSES   #
####################################


###################################
# START RTRV_BTS_CALL_ACCESS_DATA #
###################################
$ssh->print("cmdx 1 RTRV-BTS_CALL_ACCESS-DATA:BTS=$bts_id;");
$ssh->waitfor(';');
$RTRV_BTS_CALL_ACCESS_DATA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_CALL_ACCESS_DATA$completed\n\n");
print (FILE_3G "$RTRV_BTS_CALL_ACCESS_DATA$completed\n\n");

my (@array_each_line_RTRV_BTS_CALL_ACCESS_DATA, $array_each_line_RTRV_BTS_CALL_ACCESS_DATA);
my (@array_each_parm_RTRV_BTS_CALL_ACCESS_DATA, $array_each_parm_RTRV_BTS_CALL_ACCESS_DATA);
@array_each_line_RTRV_BTS_CALL_ACCESS_DATA = split(/\n/, $RTRV_BTS_CALL_ACCESS_DATA);

foreach $array_each_line_RTRV_BTS_CALL_ACCESS_DATA (@array_each_line_RTRV_BTS_CALL_ACCESS_DATA) {
if ($array_each_line_RTRV_BTS_CALL_ACCESS_DATA =~ m/\s+\:\s+/) {
$array_each_line_RTRV_BTS_CALL_ACCESS_DATA =~ s/^\s+//g;
$array_each_line_RTRV_BTS_CALL_ACCESS_DATA =~ s/\s+\:\s+/:/g;

@array_each_parm_RTRV_BTS_CALL_ACCESS_DATA = split(/\s+/, $array_each_line_RTRV_BTS_CALL_ACCESS_DATA);

foreach $array_each_parm_RTRV_BTS_CALL_ACCESS_DATA (@array_each_parm_RTRV_BTS_CALL_ACCESS_DATA) {
@_ = split(/\:/, $array_each_parm_RTRV_BTS_CALL_ACCESS_DATA);
$hash_BTS_CALL_ACCESS_DATA{$_[0]} = $_[1];
#print ("$_[0] $_[1]\n");

                                                                                                }
                                                               }

                                                                                                }
###################################
#  END RTRV_BTS_CALL_ACCESS_DATA  #
###################################

########################################
# START RTRV_BTS_EVDO_CALL_ACCESS_DATA #
########################################
$ssh->print("cmdx 1 RTRV-BTS_EVDO_CALL_ACCESS-DATA:BTS=$bts_id;");
$ssh->waitfor(';');
$RTRV_BTS_EVDO_CALL_ACCESS_DATA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_EVDO_CALL_ACCESS_DATA$completed\n\n");
print (FILE_3G "$RTRV_BTS_EVDO_CALL_ACCESS_DATA$completed\n\n");

my (@array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA, $array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA);
my (@array_each_parm_RTRV_BTS_EVDO_CALL_ACCESS_DATA, $array_each_parm_RTRV_BTS_EVDO_CALL_ACCESS_DATA);
@array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA = split(/\n/, $RTRV_BTS_EVDO_CALL_ACCESS_DATA);

foreach $array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA (@array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA) {
if ($array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA =~ m/\s+\:\s+/) {
$array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA =~ s/^\s+//g;
$array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA =~ s/\s+\:\s+/:/g;

@array_each_parm_RTRV_BTS_EVDO_CALL_ACCESS_DATA = split(/\s+/, $array_each_line_RTRV_BTS_EVDO_CALL_ACCESS_DATA);

foreach $array_each_parm_RTRV_BTS_EVDO_CALL_ACCESS_DATA (@array_each_parm_RTRV_BTS_EVDO_CALL_ACCESS_DATA) {
@_ = split(/\:/, $array_each_parm_RTRV_BTS_EVDO_CALL_ACCESS_DATA);
$hash_BTS_EVDO_CALL_ACCESS_DATA{$_[0]} = $_[1];
#print ("$_[0] $_[1]\n");

                                                                                                }
                                                               }

                                                                                                }
########################################
#  END RTRV_BTS_EVDO_CALL_ACCESS_DATA  #
########################################


###################################
# START RTRV_BTS_EVDO_SUBNET_PARA #
###################################
$ssh->print("cmdx 1 RTRV-BTS_EVDO_SUBNET-PARA:BTS=$bts_id,BAND_CLASS_INDEX=PCS;");
$ssh->waitfor(';');
$RTRV_BTS_EVDO_SUBNET_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_EVDO_SUBNET_PARA$completed\n\n");
print (FILE_3G "$RTRV_BTS_EVDO_SUBNET_PARA$completed\n\n");

my (@array_each_line_RTRV_BTS_EVDO_SUBNET_PARA, $array_each_line_RTRV_BTS_EVDO_SUBNET_PARA);
my (@array_each_parm_RTRV_BTS_EVDO_SUBNET_PARA, $array_each_parm_RTRV_BTS_EVDO_SUBNET_PARA);
@array_each_line_RTRV_BTS_EVDO_SUBNET_PARA = split(/\n/, $RTRV_BTS_EVDO_SUBNET_PARA);

foreach $array_each_line_RTRV_BTS_EVDO_SUBNET_PARA (@array_each_line_RTRV_BTS_EVDO_SUBNET_PARA) {
if ($array_each_line_RTRV_BTS_EVDO_SUBNET_PARA =~ m/\s+\:\s+/) {
$array_each_line_RTRV_BTS_EVDO_SUBNET_PARA =~ s/^\s+//g;
$array_each_line_RTRV_BTS_EVDO_SUBNET_PARA =~ s/\s+\:\s+/:/g;

@array_each_parm_RTRV_BTS_EVDO_SUBNET_PARA = split(/\s+/, $array_each_line_RTRV_BTS_EVDO_SUBNET_PARA);

foreach $array_each_parm_RTRV_BTS_EVDO_SUBNET_PARA (@array_each_parm_RTRV_BTS_EVDO_SUBNET_PARA) {
@_ = split(/\:/, $array_each_parm_RTRV_BTS_EVDO_SUBNET_PARA);
$hash_BTS_EVDO_SUBNET_PARA{$_[0]} = $_[1];
#print ("$_[0] $_[1]\n");

                                                                                                }
                                                               }

                                                                                                }
###################################
#  END RTRV_BTS_EVDO_SUBNET_PARA  #
###################################





##################################
# START RTRV-BTS_OTA_SYSTEM-PARA #
##################################
$ssh->print("cmdx 1 RTRV-BTS_OTA_SYSTEM-PARA:BTS=$bts_id;");
$ssh->waitfor(';');
my $RTRV_BTS_OTA_SYSTEM_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_OTA_SYSTEM_PARA$completed\n\n");
print (FILE_3G "$RTRV_BTS_OTA_SYSTEM_PARA$completed\n\n");


my (@each_line_RTRV_BTS_OTA_SYSTEM_PARA, $each_line_RTRV_BTS_OTA_SYSTEM_PARA);


@each_line_RTRV_BTS_OTA_SYSTEM_PARA = split(/\n/, $RTRV_BTS_OTA_SYSTEM_PARA);


foreach $each_line_RTRV_BTS_OTA_SYSTEM_PARA (@each_line_RTRV_BTS_OTA_SYSTEM_PARA) {		#start foreach line



if ($each_line_RTRV_BTS_OTA_SYSTEM_PARA =~ m/GLOBAL_REDIRECT/) {			#start if match GLOBAL_REDIRECT
$each_line_RTRV_BTS_OTA_SYSTEM_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_OTA_SYSTEM_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_OTA_SYSTEM_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_OTA_SYSTEM_PARA);
foreach $_ (@_) {
if ($_ =~ m/GLOBAL_REDIRECT/) {
$GLOBAL_REDIRECT = $_;
$GLOBAL_REDIRECT =~ s/GLOBAL_REDIRECT\://g;
#print ("$GLOBAL_REDIRECT\n");
$hash_BTS_OTA_SYSTEM_PARA{$cascade}{GLOBAL_REDIRECT} = "$GLOBAL_REDIRECT";

                              }
                }

                                                               }			#end if match GLOBAL_REDIRECT



#place here


                                                                                 }		#end foreach line
#print Dumper(\%hash_BTS_OTA_SYSTEM_PARA);
##################################
#  END RTRV-BTS_OTA_SYSTEM-PARA  #
##################################



##################################
# START RTRV-BTS_BRC_ACCESS-PARA #
##################################

$ssh->print("cmdx 1 RTRV-BTS_BRC_ACCESS-PARA:BTS=$bts_id,SECTOR=0~2,FA_INDEX=0~14;");
$ssh->waitfor(';');
my $RTRV_BTS_BRC_ACCESS_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_BRC_ACCESS_PARA$completed\n\n");
print (FILE_3G "$RTRV_BTS_BRC_ACCESS_PARA$completed\n\n");

my (@each_line_RTRV_BTS_BRC_ACCESS_PARA, $each_line_RTRV_BTS_BRC_ACCESS_PARA);


@each_line_RTRV_BTS_BRC_ACCESS_PARA = split(/\n/, $RTRV_BTS_BRC_ACCESS_PARA);


foreach $each_line_RTRV_BTS_BRC_ACCESS_PARA (@each_line_RTRV_BTS_BRC_ACCESS_PARA) {		#start foreach line


if ($each_line_RTRV_BTS_BRC_ACCESS_PARA =~ m/LOCATION/) {		#start if match LOCATION
$each_line_RTRV_BTS_BRC_ACCESS_PARA =~ s/\s+//g;
$each_line_RTRV_BTS_BRC_ACCESS_PARA =~ s/\)//g;

@_ = split(/,/, $each_line_RTRV_BTS_BRC_ACCESS_PARA);

foreach $_ (@_) {
if ($_ =~ m/SECTOR/) {
$SECTOR = $_;
$SECTOR =~ s/SECTOR\=//g;
#print ("$SECTOR\n");

                     }
if ($_ =~ m/FA_INDEX/) {
$FA_INDEX = $_;
$FA_INDEX =~ s/FA_INDEX\=//g;
#print ("$FA_INDEX\n");

                       }
                }
                                                        }		#end if match LOCATION


if ($each_line_RTRV_BTS_BRC_ACCESS_PARA =~ m/GSRDM_ACT/) {			#start if match GSRDM_ACT
$each_line_RTRV_BTS_BRC_ACCESS_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_BRC_ACCESS_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_BRC_ACCESS_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_BRC_ACCESS_PARA);
foreach $_ (@_) {
if ($_ =~ m/GSRDM_ACT/) {
$GSRDM_ACT = $_;
$GSRDM_ACT =~ s/GSRDM_ACT\://g;
#print ("$GSRDM_ACT\n");
$hash_BTS_BRC_ACCESS_PARA{$cascade}{$SECTOR}{$FA_INDEX}{GSRDM_ACT} = "$GSRDM_ACT";

                              }
                }

                                                               }			#end if match GSRDM_ACT



#place here


                                                                                 }		#end foreach line
#print Dumper(\%hash_BTS_BRC_ACCESS_PARA);
##################################
#  END RTRV-BTS_BRC_ACCESS-PARA  #
##################################


#####################################
# START RTRV-BTS_CDMA_REDIRECT-PARA #
#####################################
$ssh->print("cmdx 1 RTRV-BTS_CDMA_REDIRECT-PARA:BTS=$bts_id;");
$ssh->waitfor(';');
my $RTRV_BTS_CDMA_REDIRECT_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_CDMA_REDIRECT_PARA$completed\n\n");
print (FILE_3G "$RTRV_BTS_CDMA_REDIRECT_PARA$completed\n\n");


my (@each_line_RTRV_BTS_CDMA_REDIRECT_PARA, $each_line_RTRV_BTS_CDMA_REDIRECT_PARA);


@each_line_RTRV_BTS_CDMA_REDIRECT_PARA = split(/\n/, $RTRV_BTS_CDMA_REDIRECT_PARA);


foreach $each_line_RTRV_BTS_CDMA_REDIRECT_PARA (@each_line_RTRV_BTS_CDMA_REDIRECT_PARA) {		#start foreach line



if ($each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ m/REDIRECT_ACCOLC/) {			#start if match REDIRECT_ACCOLC
$each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_CDMA_REDIRECT_PARA);
foreach $_ (@_) {
if ($_ =~ m/REDIRECT_ACCOLC/) {
$REDIRECT_ACCOLC = $_;
$REDIRECT_ACCOLC =~ s/REDIRECT_ACCOLC\://g;
#print ("$REDIRECT_ACCOLC\n");
$hash_BTS_CDMA_REDIRECT_PARA{$cascade}{REDIRECT_ACCOLC} = "$REDIRECT_ACCOLC";

                              }
                }

                                                               }			#end if match REDIRECT_ACCOLC



if ($each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ m/NUM_CHAN/) {			#start if match NUM_CHAN
$each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_CDMA_REDIRECT_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_CDMA_REDIRECT_PARA);
foreach $_ (@_) {
if ($_ =~ m/NUM_CHAN/) {
$NUM_CHAN = $_;
$NUM_CHAN =~ s/NUM_CHAN\://g;
#print ("$NUM_CHAN\n");
$hash_BTS_CDMA_REDIRECT_PARA{$cascade}{NUM_CHAN} = "$NUM_CHAN";

                              }
                }

                                                           }			#end if match NUM_CHAN


#place here


                                                                                 }		#end foreach line
#print Dumper(\%hash_BTS_CDMA_REDIRECT_PARA);
#####################################
#  END RTRV-BTS_CDMA_REDIRECT-PARA  #
#####################################

#######################################
# START RTRV-BTS_EVDO_ACCESS_MSG-PARA #
#######################################
for (my $SECTOR_NUM = 0; $SECTOR_NUM<=2; $SECTOR_NUM++) {		#start foreach sector_num
$ssh->print("cmdx 1 RTRV-BTS_EVDO_ACCESS_MSG-PARA:BTS=$bts_id,BAND_CLASS_INDEX=PCS,SECTOR=$SECTOR_NUM;");
$ssh->waitfor(';');
my $RTRV_BTS_EVDO_ACCESS_MSG_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_EVDO_ACCESS_MSG_PARA$completed\n\n");
print (FILE_3G "$RTRV_BTS_EVDO_ACCESS_MSG_PARA$completed\n\n");


my (@each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA, $each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA);


@each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA = split(/\n/, $RTRV_BTS_EVDO_ACCESS_MSG_PARA);


foreach $each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA (@each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA) {		#start foreach line


if ($each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ m/APERSISTENCE\[0\]/) {			#start if match APERSISTENCE[0]
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA);
foreach $_ (@_) {
if ($_ =~ m/APERSISTENCE\[0\]/) {
$APERSISTENCE_0 = $_;
$APERSISTENCE_0 =~ s/APERSISTENCE\[0\]\://g;
#print ("$APERSISTENCE_0\n");
$hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_NUM}{'APERSISTENCE[0]'} = "$APERSISTENCE_0";

                              }
                }

                                                                      }			#end if match APERSISTENCE[0]


if ($each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ m/APERSISTENCE\[1\]/) {			#start if match APERSISTENCE[1]
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA);
foreach $_ (@_) {
if ($_ =~ m/APERSISTENCE\[1\]/) {
$APERSISTENCE_1 = $_;
$APERSISTENCE_1 =~ s/APERSISTENCE\[1\]\://g;
#print ("$APERSISTENCE_1\n");
$hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_NUM}{'APERSISTENCE[1]'} = "$APERSISTENCE_1";

                              }
                }

                                                                    }			#end if match APERSISTENCE[1]


if ($each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ m/APERSISTENCE\[2\]/) {			#start if match APERSISTENCE[2]
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA);
foreach $_ (@_) {
if ($_ =~ m/APERSISTENCE\[2\]/) {
$APERSISTENCE_2 = $_;
$APERSISTENCE_2 =~ s/APERSISTENCE\[2\]\://g;
#print ("$APERSISTENCE[2]\n");
$hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_NUM}{'APERSISTENCE[2]'} = "$APERSISTENCE_2";

                              }
                }

                                                                    }			#end if match APERSISTENCE[2]



if ($each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ m/APERSISTENCE\[3\]/) {			#start if match APERSISTENCE[3]
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+\:\s+/\:/g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/\s+/ /g;
$each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA =~ s/^\s+//g;
@_ = split(/\s+/, $each_line_RTRV_BTS_EVDO_ACCESS_MSG_PARA);
foreach $_ (@_) {
if ($_ =~ m/APERSISTENCE\[3\]/) {
$APERSISTENCE_3 = $_;
$APERSISTENCE_3 =~ s/APERSISTENCE\[3\]\://g;
#print ("$APERSISTENCE_3\n");
$hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_NUM}{'APERSISTENCE[3]'} = "$APERSISTENCE_3";

                              }
                }

                                                                    }			#end if match APERSISTENCE[3]





#place here


                                                                                 }		#end foreach line
                                                        }		#end foreach sector_num
#print Dumper(\%hash_BTS_EVDO_ACCESS_MSG_PARA);
#######################################
#  END RTRV-BTS_EVDO_ACCESS_MSG-PARA  #
#######################################






###############################
# START RTRV_BSC_PCF_BTS_PARA #
###############################
$ssh->print("cmdx 1 RTRV-BSC_PCF_BTS-PARA:BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
$RTRV_BSC_PCF_BTS_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BSC_PCF_BTS_PARA$completed\n\n");
print (FILE_3G "$RTRV_BSC_PCF_BTS_PARA$completed\n\n");

$RTRV_BSC_PCF_BTS_PARA =~ s/LOCATION/~LOCATION/g;
$RTRV_BSC_PCF_BTS_PARA =~ s/\-+//g;
#print ("$RTRV_BSC_PCF_BTS_PARA\n");
my (@array_each_loc_RTRV_BSC_PCF_BTS_PARA, $array_each_loc_RTRV_BSC_PCF_BTS_PARA);
my (@array_each_line_RTRV_BSC_PCF_BTS_PARA, $array_each_line_RTRV_BSC_PCF_BTS_PARA);

my (@array_each_parm_RTRV_BSC_PCF_BTS_PARA, $array_each_parm_RTRV_BSC_PCF_BTS_PARA);
@array_each_loc_RTRV_BSC_PCF_BTS_PARA = split(/~/, $RTRV_BSC_PCF_BTS_PARA);
foreach $array_each_loc_RTRV_BSC_PCF_BTS_PARA (@array_each_loc_RTRV_BSC_PCF_BTS_PARA) {
@array_each_line_RTRV_BSC_PCF_BTS_PARA = split(/\n/, $array_each_loc_RTRV_BSC_PCF_BTS_PARA);

foreach $array_each_line_RTRV_BSC_PCF_BTS_PARA (@array_each_line_RTRV_BSC_PCF_BTS_PARA) {
if ($array_each_line_RTRV_BSC_PCF_BTS_PARA =~ m/LOCATION/) {
$array_each_line_RTRV_BSC_PCF_BTS_PARA =~ s/LOCATION\s+\:\s+//g;
$BSC_PCF_BTS_PARA_loc = $array_each_line_RTRV_BSC_PCF_BTS_PARA;
#print ("$array_each_line_RTRV_BSC_PCF_BTS_PARA\n");
$hash_BSC_PCF_BTS_PARA{$BSC_PCF_BTS_PARA_loc} = $BSC_PCF_BTS_PARA_loc;
                                                           }

if (($array_each_line_RTRV_BSC_PCF_BTS_PARA =~ m/\s+\:\s+/) && ($array_each_line_RTRV_BSC_PCF_BTS_PARA !~ m/LOCATION/)) {
$array_each_line_RTRV_BSC_PCF_BTS_PARA =~ s/^\s+//g;
$array_each_line_RTRV_BSC_PCF_BTS_PARA =~ s/\s+\:\s+/:/g;

@array_each_parm_RTRV_BSC_PCF_BTS_PARA = split(/\s+/, $array_each_line_RTRV_BSC_PCF_BTS_PARA);

foreach $array_each_parm_RTRV_BSC_PCF_BTS_PARA (@array_each_parm_RTRV_BSC_PCF_BTS_PARA) {
@_ = split(/\:/, $array_each_parm_RTRV_BSC_PCF_BTS_PARA);
$hash_BSC_PCF_BTS_PARA_PARM{$BSC_PCF_BTS_PARA_loc}{$_[0]} = $_[1];
#print ("$_[0] $_[1]\n");
                                                                                        }
                                                                                                                        }
                                                                                        }

                                                                                      }
###############################
#  END RTRV_BSC_PCF_BTS_PARA  #
###############################


#######################
# START RTRV_BTS_PARA #
#######################
$ssh->print("cmdx 1 RTRV-BTS_PARA:BTS=$bts_id;");
$ssh->waitfor(';');
$RTRV_BTS_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_PARA$completed\n\n");
print (FILE_3G "$RTRV_BTS_PARA$completed\n\n");

my (@split_eachline_RTRV_BTS_PARA, $split_eachline_RTRV_BTS_PARA);
@split_eachline_RTRV_BTS_PARA = split(/\n/, $RTRV_BTS_PARA);

foreach $split_eachline_RTRV_BTS_PARA (@split_eachline_RTRV_BTS_PARA) {
$split_eachline_RTRV_BTS_PARA =~ s/^\s+//g;
$split_eachline_RTRV_BTS_PARA =~ s/\s+\:\s+/\:/g;
my (@array_each_parm_BTS_PARA, $array_each_parm_BTS_PARA);
@array_each_parm_BTS_PARA = split(/\s+/, $split_eachline_RTRV_BTS_PARA);

foreach $array_each_parm_BTS_PARA (@array_each_parm_BTS_PARA) {
$array_each_parm_BTS_PARA =~ s/\d+\:\d+\:\d+//g;
$array_each_parm_BTS_PARA =~ s/RTRV-BTS_PARA\://g;
if ($array_each_parm_BTS_PARA =~ m/\:/) {
@_ = split(/\:/, $array_each_parm_BTS_PARA);
$hash_RTRV_BTS_PARA{$_[0]} = "$_[1]";
                                        }
                                                              }


                                                                      }
#######################
#  END RTRV_BTS_PARA  #
#######################


######################
# START RTRV_OOS_STS #
######################
$ssh->print("cmdx 1 RTRV-OOS-STS:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
$RTRV_OOS_STS = $ssh->waitfor('COMPLETED');
print ("$RTRV_OOS_STS$completed\n\n");
print (FILE_3G "$RTRV_OOS_STS$completed\n\n");


my (@split_eachline_RTRV_OOS_STS, $split_eachline_RTRV_OOS_STS);
@split_eachline_RTRV_OOS_STS = split(/\n/, $RTRV_OOS_STS);

foreach $split_eachline_RTRV_OOS_STS (@split_eachline_RTRV_OOS_STS) {
$split_eachline_RTRV_OOS_STS =~ s/^\s+//g;
if (($split_eachline_RTRV_OOS_STS =~ m/CE_1X/) || ($split_eachline_RTRV_OOS_STS =~ m/CE_DO/)){

if ($split_eachline_RTRV_OOS_STS =~ m/^\d+/) {
@_ = split(/\s+/, $split_eachline_RTRV_OOS_STS);
$hash_RTRV_OOS_STS{$_[1]} = "$_[5]";
                                             }
else {
@_ = split(/\s+/, $split_eachline_RTRV_OOS_STS);
$hash_RTRV_OOS_STS{$_[0]} = "$_[4]";
     }
                                                                                             }
                                                                    }

######################
#  END RTRV_OOS_STS  #
######################


#################################
# START RTRV-BTS_RRH_TXATT-DATA #
#################################
$ssh->print("cmdx 1 RTRV-BTS_RRH_TXATT-DATA:BTS=$bts_id,BCP=0~1,PORT=0~5,CASCADE=0~0,FA_INDEX=0~14;");
$ssh->waitfor(';');
$RTRV_BTS_RRH_TXATT_DATA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_RRH_TXATT_DATA$completed\n\n");
print (FILE "$RTRV_BTS_RRH_TXATT_DATA$completed\n\n");
$RTRV_BTS_RRH_TXATT_DATA =~ s/BTS_RRH_TXATT\(/LOCATION:/g;
$RTRV_BTS_RRH_TXATT_DATA =~ s/\)\s+\:\s+TX_ATTEN\s+\=\s+/\,TX_ATTEN=/g;



#print ("$RTRV_BTS_RRH_TXATT_DATA\n");


my (@split_each_line_TXATT_DATA, $split_each_line_TXATT_DATA);
@split_each_line_TXATT_DATA = split(/\n/, $RTRV_BTS_RRH_TXATT_DATA);

foreach $split_each_line_TXATT_DATA (@split_each_line_TXATT_DATA) {	#start eachline TXATT_DATA
if ($split_each_line_TXATT_DATA =~ m/LOCATION/) {			#start if line match LOCATION:
$split_each_line_TXATT_DATA =~ s/LOCATION://g;
@_ = split(/,/, $split_each_line_TXATT_DATA);

my ($BTS, $BCP, $PORT, $CASCADE, $FA_INDEX, $TX_ATTEN);
foreach $_ (@_) {							#start foreach parameter

if ($_ =~ m/BTS/) {
$_ =~ s/BTS=//g;
$_ =~ s/\s+//g;
$BTS = "$_";
                  }

if ($_ =~ m/BCP/) {
$_ =~ s/BCP=//g;
$_ =~ s/\s+//g;
$BCP = "$_";
                  }

if ($_ =~ m/PORT/) {
$_ =~ s/PORT=//g;
$_ =~ s/\s+//g;
$PORT = "$_";
                   }

if ($_ =~ m/CASCADE/) {
$_ =~ s/CASCADE=//g;
$_ =~ s/\s+//g;
$CASCADE = "$_";
                      }

if ($_ =~ m/FA_INDEX/) {
$_ =~ s/FA_INDEX=//g;
$_ =~ s/\s+//g;
$FA_INDEX = "$_";
                       }

if ($_ =~ m/TX_ATTEN/) {
$_ =~ s/TX_ATTEN=//g;
$_ =~ s/\s+//g;
$TX_ATTEN = "$_";
                       }

                }							#end foreach parameter

$hash_TXATT_DATA{$BTS}{$BCP}{$PORT}{$CASCADE}{$FA_INDEX} = "$TX_ATTEN";
#print ("$split_each_line_TXATT_DATA\n");
                                                }			#start if line match LOCATION:


                                                                  }	#end eachline TXATT_DATA


#print Dumper(\%hash_TXATT_DATA);
#################################
#  END RTRV-BTS_RRH_TXATT-DATA  #
#################################



##########################
# START RTRV_BTS_RC_PARA #
##########################
$ssh->print("cmdx 1 RTRV-BTS_RC-PARA:BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
$RTRV_BTS_RC_PARA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_RC_PARA$completed\n\n");
print (FILE_3G "$RTRV_BTS_RC_PARA$completed\n\n");


my (@split_eachline_RTRV_BTS_RC_PARA, $split_eachline_RTRV_BTS_RC_PARA);
@split_eachline_RTRV_BTS_RC_PARA = split(/\n/, $RTRV_BTS_RC_PARA);

foreach $split_eachline_RTRV_BTS_RC_PARA (@split_eachline_RTRV_BTS_RC_PARA) {
$split_eachline_RTRV_BTS_RC_PARA =~ s/^\s+//g;
$split_eachline_RTRV_BTS_RC_PARA =~ s/\s+\:\s+/:/g;
if (($split_eachline_RTRV_BTS_RC_PARA =~ m/F_V_LOAD_BALANCING_THRESHOLD/) || ($split_eachline_RTRV_BTS_RC_PARA =~ m/F_P_LOAD_BALANCING_THRESHOLD/)){
my (@array_each_parm_RTRV_BTS_RC_PARA, $array_each_parm_RTRV_BTS_RC_PARA);
@array_each_parm_RTRV_BTS_RC_PARA = split(/\s+/, $split_eachline_RTRV_BTS_RC_PARA);

foreach $array_each_parm_RTRV_BTS_RC_PARA (@array_each_parm_RTRV_BTS_RC_PARA) {

if ($array_each_parm_RTRV_BTS_RC_PARA =~ m/F_V_LOAD_BALANCING_THRESHOLD/) {
@_ = split(/\:/, $array_each_parm_RTRV_BTS_RC_PARA);
$_[0] =~ s/\s+//g;
$_[1] =~ s/\s+//g;
my $parm = "$_[0]";
my $value = "$_[1]";
$hash_RTRV_BTS_RC_PARA{$parm} = "$value";
#print ("$parm $value\n");
                                                                          }

if ($array_each_parm_RTRV_BTS_RC_PARA =~ m/F_P_LOAD_BALANCING_THRESHOLD/) {
@_ = split(/\:/, $array_each_parm_RTRV_BTS_RC_PARA);
$_[0] =~ s/\s+//g;
$_[1] =~ s/\s+//g;
my $parm = "$_[0]";
my $value = "$_[1]";
$hash_RTRV_BTS_RC_PARA{$parm} = "$value";
#print ("$parm $value\n");
                                                                          }


                                                                              }



                                                                                                                                                   }
                                                                            }
##########################
#  END RTRV_BTS_RC_PARA  #
##########################
#print Dumper(\%hash_RTRV_BTS_RC_PARA);



#######################
# START RTRV_CALL_CNT #
#######################
$ssh->print("cmdx 1 RTRV-CALL-CNT:SUBSYSTEM=BTS,BTS=$bts_id;");
$ssh->waitfor(';');
$RTRV_CALL_CNT = $ssh->waitfor('COMPLETED');
print ("$RTRV_CALL_CNT$completed\n\n");
print (FILE_3G "$RTRV_CALL_CNT$completed\n\n");

my (@split_eachline_RTRV_CALL_CNT, $split_eachline_RTRV_CALL_CNT);
@split_eachline_RTRV_CALL_CNT = split(/\n/, $RTRV_CALL_CNT);
my ($FA_INDEX, $TYPE, $SECTOR, $VOICE_3G, $PACKET_3G, $TOTAL_3G);
foreach $split_eachline_RTRV_CALL_CNT (@split_eachline_RTRV_CALL_CNT) {
if (($split_eachline_RTRV_CALL_CNT =~ m/^\s+\d+/) || ($split_eachline_RTRV_CALL_CNT =~ m/^\s+\(/) || ($split_eachline_RTRV_CALL_CNT =~ m/^\s+TOTAL/)) {		#start if line match ^\d+
$split_eachline_RTRV_CALL_CNT =~ s/^\s+//g;
$split_eachline_RTRV_CALL_CNT =~ s/\/\s+/\//g;
$split_eachline_RTRV_CALL_CNT =~ s/^\(//g;
$split_eachline_RTRV_CALL_CNT =~ s/\(/ /g;
$split_eachline_RTRV_CALL_CNT =~ s/\)//g;
if (($split_eachline_RTRV_CALL_CNT !~ m/2\s+G/) && ($split_eachline_RTRV_CALL_CNT !~ m/3\s+G/)) {		#start if not 2 G and 3 G

#print ("$split_eachline_RTRV_CALL_CNT\n");

if (($split_eachline_RTRV_CALL_CNT =~ m/^\d+\s+1X/) || ($split_eachline_RTRV_CALL_CNT =~ m/^\d+\s+DO/) || ($split_eachline_RTRV_CALL_CNT =~ m/^\d+\s+DOA/)) {
@_ = split(/\s+/, $split_eachline_RTRV_CALL_CNT);
$FA_INDEX = $_[0];
$TYPE = $_[1];
$SECTOR = $_[2];
$VOICE_3G = $_[4];
$PACKET_3G = $_[6];
$TOTAL_3G = $_[8];
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{VOICE_3G} = "$VOICE_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{PACKET_3G} = "$PACKET_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{TOTAL_3G} = "$TOTAL_3G";
#print ("$FA_INDEX $TYPE $SECTOR $VOICE_3G $PACKET_3G $TOTAL_3G\n");
                                                                                                                                                            }

if ($split_eachline_RTRV_CALL_CNT =~ m/^TOTAL/) {
@_ = split(/\s+/, $split_eachline_RTRV_CALL_CNT);
$FA_INDEX = $_[0];
$TYPE = $_[1];
$SECTOR = $_[2];
$VOICE_3G = $_[4];
$PACKET_3G = $_[6];
$TOTAL_3G = $_[8];
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{VOICE_3G} = "$VOICE_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{PACKET_3G} = "$PACKET_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{TOTAL_3G} = "$TOTAL_3G";
#print ("$FA_INDEX $TYPE $SECTOR $VOICE_3G $PACKET_3G $TOTAL_3G\n");
                                                }


if (($split_eachline_RTRV_CALL_CNT =~ m/^1X/) || ($split_eachline_RTRV_CALL_CNT =~ m/^DO/) || ($split_eachline_RTRV_CALL_CNT =~ m/^DOA/)) {
@_ = split(/\s+/, $split_eachline_RTRV_CALL_CNT);
$TYPE = $_[0];
$VOICE_3G = $_[3];
$PACKET_3G = $_[5];
$TOTAL_3G = $_[7];
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{VOICE_3G} = "$VOICE_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{PACKET_3G} = "$PACKET_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{TOTAL_3G} = "$TOTAL_3G";
#print ("$FA_INDEX $TYPE $SECTOR $VOICE_3G $PACKET_3G $TOTAL_3G\n");
                                                                                                                                          }

if ($split_eachline_RTRV_CALL_CNT =~ m/^\d+\s+\d+\//) {
@_ = split(/\s+/, $split_eachline_RTRV_CALL_CNT);
$SECTOR = $_[0];
$VOICE_3G = $_[2];
$PACKET_3G = $_[4];
$TOTAL_3G = $_[6];
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{VOICE_3G} = "$VOICE_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{PACKET_3G} = "$PACKET_3G";
$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{TOTAL_3G} = "$TOTAL_3G";
#print ("$FA_INDEX $TYPE $SECTOR $VOICE_3G $PACKET_3G $TOTAL_3G\n");
                                                      }
                                                                                                }		#end if not 2 G and 3 G
                                                                                                                                                      }		#end if line match ^\d+
                                                                      }
#print Dumper(\%hash_CALL_CNT);
#######################
#  END RTRV_CALL_CNT  #
#######################




########################
#  START RTRV-ALM-INH  #
########################
$ssh->print("cmdx 1 RTRV-ALM-INH:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
$RTRV_ALM_INH = $ssh->waitfor('COMPLETED');
print ("$RTRV_ALM_INH$completed\n\n");
print (FILE_3G "$RTRV_ALM_INH$completed\n\n");

my (@split_eachline_RTRV_ALM_INH, $split_eachline_RTRV_ALM_INH);
@split_eachline_RTRV_ALM_INH = split(/\n/, $RTRV_ALM_INH);

foreach $split_eachline_RTRV_ALM_INH (@split_eachline_RTRV_ALM_INH) {
$split_eachline_RTRV_ALM_INH =~ s/^\s+//g;
$split_eachline_RTRV_ALM_INH =~ s/\s\s/~/g;
$split_eachline_RTRV_ALM_INH =~ s/\~+/~/g;
$split_eachline_RTRV_ALM_INH =~ s/\~\s+/~/g;
$split_eachline_RTRV_ALM_INH =~ s/\s+\~/~/g;

if (($split_eachline_RTRV_ALM_INH =~ m/^A\d\d\d\d/) || ($split_eachline_RTRV_ALM_INH =~ m/^\d\d\d\d/)) {
#print ("$split_eachline_RTRV_ALM_INH\n");
@_ = split(/~/, $split_eachline_RTRV_ALM_INH);
my $CODE = "$_[0]";
my $OBJECT = "$_[1]";
my $ALARM_DESCRIPTION = "$_[2]";
#print ("$CODE $OBJECT $ALARM_DESCRIPTION\n");
$hash_ALM_INH{$CODE}{$OBJECT} = "$ALARM_DESCRIPTION";
                                                                                                       }
                                                                    }


#print Dumper(\%hash_ALM_INH);

########################
#   END RTRV-ALM-INH   #
########################



#####################################
#  START RTRV-BTS_RRH_SHARING-DATA  #
#####################################
$ssh->print("cmdx 1 RTRV-BTS_RRH_SHARING-DATA:BTS=$bts_id;");
$ssh->waitfor(';');
my $RTRV_BTS_RRH_SHARING_DATA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_RRH_SHARING_DATA$completed\n\n");
print (FILE_3G "$RTRV_BTS_RRH_SHARING_DATA$completed\n\n");
#####################################
#   END RTRV-BTS_RRH_SHARING-DATA   #
#####################################


#########################
# START RTRV-SERVFA-STS #
#########################
$ssh->print("cmdx 1 RTRV-SERVFA-STS:BTS=$bts_id;");
$ssh->waitfor(';');
my $SERVFA_LOG = $ssh->waitfor('COMPLETED');
print ("$SERVFA_LOG$completed\n\n");
print (FILE_3G "$SERVFA_LOG$completed\n\n");
#########################
#  END RTRV-SERVFA-STS  #
#########################

#################################
# START RTRV-BTS_DIVERSITY-DATA #
#################################
$ssh->print("cmdx 1 RTRV-BTS_DIVERSITY-DATA:BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
my $RTRV_BTS_DIVERSITY = $ssh->waitfor('COMPLETED');
print ("$RTRV_BTS_DIVERSITY$completed\n\n");
print (FILE_3G "$RTRV_BTS_DIVERSITY$completed\n\n");
#################################
#  END RTRV-BTS_DIVERSITY-DATA  #
#################################


#################################
# START RTRV-BSM_BTS_ONAIR-DATA #
#################################
$ssh->print("cmdx 1 RTRV-BSM_BTS_ONAIR-DATA:BTS=$bts_id~$bts_id;");
$ssh->waitfor(';');
my $RTRV_BSM_BTS_ONAIR_DATA = $ssh->waitfor('COMPLETED');
print ("$RTRV_BSM_BTS_ONAIR_DATA$completed\n\n");
print (FILE_3G "$RTRV_BSM_BTS_ONAIR_DATA$completed\n\n");

if ($RTRV_BSM_BTS_ONAIR_DATA =~ m/SITE_TYPE\s+\=\s+ON_AIR/) {
$commerical_3G = "YES";
                                                            }
else {
$commerical_3G = "NO";
     }

#################################
#  END RTRV-BSM_BTS_ONAIR-DATA  #
#################################

#####################
# START CHG-ENV-VAR #
#####################
$ssh->print("cmdx 1 CHG-ENV-VAR:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id,ENV_OPTION=DISPLAY;");
$ssh->waitfor(';');
my $CHG_ENV_VAR = $ssh->waitfor('COMPLETED');
print ("$CHG_ENV_VAR$completed\n\n");
print (FILE_3G "$CHG_ENV_VAR$completed\n\n");


my (@array_each_line_ENV_VAR, $array_each_line_ENV_VAR);
@array_each_line_ENV_VAR = split(/\n/,$CHG_ENV_VAR);

foreach $array_each_line_ENV_VAR (@array_each_line_ENV_VAR) {
$array_each_line_ENV_VAR =~ s/^\s+//g;

if ($array_each_line_ENV_VAR =~ m/^BCP\_/) {
@_ = split (/\s+/,$array_each_line_ENV_VAR);

if ($_[2] =~ m/STACKING/) {
$hash_ENV_VAR{$_[0]}{$_[1]} = $_[2];
                          }

                                           }
                                                            }

#####################
#  END CHG-ENV-VAR  #
#####################



##########################
# START ACTIVE 3G ALARMS #
##########################
$ssh->print("cmdx 1 RTRV-ALM-LIST:SUBSYSTEM=BTS,BTS=$bts_id~$bts_id,OUTPUT=DETAIL;");
$ssh->waitfor(';');
$ALM_LIST_LOG = $ssh->waitfor('COMPLETED');
print ("$ALM_LIST_LOG$completed\n\n");
print (FILE_3G "$ALM_LIST_LOG$completed\n\n");

$ALM_LIST_LOG =~ s/CRI\s+MAJ\s+MIN\n+\s+/CRI MAJ MIN /g;
if ($ALM_LIST_LOG =~ m/CRI MAJ MIN 0\s+0\s+0/) {
$hash_is_active_alms{$cascade} = 0;			#there are no active alarms
                                               }
else {
$hash_is_active_alms{$cascade} = 1;			#there are active alarms
     }

if ($hash_is_active_alms{$cascade} == 1) {
@array_active_alm_each_line = split(/\n/, $ALM_LIST_LOG);
foreach $array_active_alm_each_line (@array_active_alm_each_line) {
if (($array_active_alm_each_line =~ m/^\s+CR /) || ($array_active_alm_each_line =~ m/^\s+MJ /) || ($array_active_alm_each_line =~ m/^\s+MN /)) {
$array_active_alm_each_line =~ s/^\s+//g;
$array_active_alm_each_line =~ s/\s+BTS_/~BTS_/g;
$array_active_alm_each_line =~ s/\s+\[/~[/g;
$array_active_alm_each_line =~ s/\s\s/~/g;
@_ = split(/~/, $array_active_alm_each_line);
@split_alm_grd_cd_time = split(/\s+/, $_[0]);
my $grd = $split_alm_grd_cd_time[0];	#alm grade
my $cd = $split_alm_grd_cd_time[1];	#alm code
my $evnt_tm = "$split_alm_grd_cd_time[2] $split_alm_grd_cd_time[3]";	#alm time
my $alm = "$_[1]";	#alm
my $alm_loc = "$_[2]";	#alm loc
my $alm_loc_no_slash = $alm_loc;	#alm loc no /
$alm_loc_no_slash =~ s/\//_/g;	#key for alarm hash
my $alm_key_for_hash = "$grd\_$alm_loc_no_slash\_$cd";


$hash_active_alm_key{$alm_key_for_hash} = $alm_key_for_hash;	#active alarms key for printing in report
$hash_active_alm_grd{$alm_key_for_hash} = $grd;			#active alarms grade
$hash_active_alm_cd{$alm_key_for_hash} = $cd;			#active alarms alarm code
$hash_active_alm_evnt_tm{$alm_key_for_hash} = $evnt_tm;		#active alarms event time
$hash_active_alarm{$alm_key_for_hash} = $alm;			#active alarms alarm
$hash_active_alm_loc{$alm_key_for_hash} = $alm_loc;		#active alarms location                                                                                          
                                                                                                                                               }
                                                                  }
                                         }

$alm_count = 0;
foreach $hash_active_alarm (sort keys %hash_active_alarm) {	#start count to see if any alarms
if ($hash_active_alarm) {
$alm_count++;
                        }
                                                          }	#end count to see if any alarms

##########################
#  END ACTIVE 3G ALARMS  #
##########################

#############################
#  START 3G ALARMS HISTORY  #
#############################
$ssh->print("cmdx 1 RTRV-ALM-LOG:HIS_TYPE=ALM_COUNT,SUBSYSTEM=BTS,BTS=$bts_id,MAX_COUNT=500;");
$ssh->waitfor(';');
my $ALRM_HISTORY_3G = $ssh->waitfor('COMPLETED');
print ("$ALRM_HISTORY_3G$completed\n\n");
print (FILE_3G "$ALRM_HISTORY_3G$completed\n\n");

my (@split_eachline_ALRM_HISTORY, $split_eachline_ALRM_HISTORY);
@split_eachline_ALRM_HISTORY = split(/\n/, $ALRM_HISTORY_3G);

my $count_alm_his = 1;
foreach $split_eachline_ALRM_HISTORY (@split_eachline_ALRM_HISTORY) {
my $GRD = "";
my $CODE = "";
my $ALARM_TYPE = "";
my $LOCATION = "";
my $START_TIME = "";
my $END_TIME = "";


$split_eachline_ALRM_HISTORY =~ s/^\s+//g;
if (($split_eachline_ALRM_HISTORY =~ m/^CR/) || ($split_eachline_ALRM_HISTORY =~ m/^MJ/) || ($split_eachline_ALRM_HISTORY =~ m/^MN/)) {
@_ = split(/\s+/, $split_eachline_ALRM_HISTORY);
my $GRD = "$_[0]";
my $CODE = "$_[1]";
my $ALARM_TYPE = "$_[2]";

if ($_[3] =~ m/\d+\/\d+/) {
$LOCATION = "-";
$START_TIME = "$_[3] $_[4]";
$END_TIME = "$_[5] $_[6]";

                          }
else {
$LOCATION = "$_[3]";
$START_TIME = "$_[4] $_[5]";
$END_TIME = "$_[6] $_[7]";
     }
#print ("$GRD $CODE $ALARM_TYPE $LOCATION $START_TIME $END_TIME $count_alm_his\n");
$hash_ALM_HIST{$count_alm_his}{GRD} = "$GRD";
$hash_ALM_HIST{$count_alm_his}{CODE} = "$CODE";
$hash_ALM_HIST{$count_alm_his}{ALARM_TYPE} = "$ALARM_TYPE";
$hash_ALM_HIST{$count_alm_his}{LOCATION} = "$LOCATION";
$hash_ALM_HIST{$count_alm_his}{START_TIME} = "$START_TIME";
$hash_ALM_HIST{$count_alm_his}{END_TIME} = "$END_TIME";
$count_alm_his++;
                                                                                                                                      }
                                                                    }


#print Dumper(\%hash_ALM_HIST);

#############################
#   END 3G ALARMS HISTORY   #
#############################

$ssh->print('exit');

$ssh->disconnect;

                }
#########################
#  END SSH 3G GET DATA  #
#########################

sub CLOSE_3G_DATA {
close (FILE_3G);
                  }



############
# START 4G #
############

sub OPEN_4G_DATA {
open (FILE_4G, ">$Bin\\4G_DATA\\$cascade\_4G\_AUDIT\_$month_num\_$mday\_$year\_$hour\_$minute\.txt");
                 }



###############################################
# START GET ALARM, BUCKET, ENODEB INFORMATION #
###############################################
my (%hash_level_id, $hash_level_id);
%hash_level_id = ();
my ($bucket_4g);
my ($alarm_4g_enodeb_num);
my (@array_get_enodeb_ids, $array_get_enodeb_ids);
my (%hash_enode_name, $hash_enode_name);
my (%hash_enodeb_bucket, $hash_enodeb_bucket);
my (%hash_enodeb_num, $hash_enodeb_num);
my (%hash_enodeb_ip, $hash_enodeb_ip);
my (%hash_enodeb_sw, $hash_enodeb_sw);
my (%hash_enodeb_num_for_alm, $hash_enodeb_num_for_alm);
%hash_enode_name = ();
%hash_enodeb_bucket = ();
%hash_enodeb_num = ();
%hash_enodeb_ip = ();
%hash_enodeb_sw = ();
%hash_enodeb_num_for_alm = ();

my (@array_alarms_each_line, $array_alarms_each_line);
my (%hash_4g_alm_key, $hash_4g_alm_key);
my (%hash_4g_alm_serv, $hash_4g_alm_serv);
my (%hash_4g_alm_tm, $hash_4g_alm_tm);
my (%hash_4g_alm_loc, $hash_4g_alm_loc);
my (%hash_4g_alm_prob_cause, $hash_4g_alm_prob_cause);
my (%hash_num_4g_alarms, $hash_num_4g_alarms);

%hash_4g_alm_key = ();
%hash_4g_alm_serv = ();
%hash_4g_alm_tm = ();
%hash_4g_alm_loc = ();
%hash_4g_alm_prob_cause = ();
%hash_num_4g_alarms = ();

my ($enodeb_ip_address_LSM);

my ($x2_nok, $s1_nok, $ip_add_nok, $ip_rt_nok, $gps_nok, $firm_nok, $cell_idle_nok);
my ($nbr_eutran_nok, $rrh_invt_nok, $gps_invt_nok, $cell_sts_nok, $eaiu_4g_invt_nok, $nbr_hrpd_nok);

my (%hash_s1_mme_index, $hash_s1_mme_index);
my (%hash_s1_mme_id, $hash_s1_mme_id);
my (%hash_s1_sctp, $hash_s1_mme_sctp);
my (%hash_s1_s1ap, $hash_s1_s1ap);
my (%hash_s1_mme_name, $hash_s1_mme_name);
my (%hash_s1_mme_ip_v4, $hash_s1_mme_ip_v4);
%hash_s1_mme_index = ();
%hash_s1_mme_id = ();
%hash_s1_sctp = ();
%hash_s1_s1ap = ();
%hash_s1_mme_name = ();
%hash_s1_mme_ip_v4 = ();


my (%hash_x2_nbr_index, $hash_x2_nbr_index);
my (%hash_x2_nbr_enodeb_id, $hash_x2_nbr_enodeb_id);
my (%hash_x2_sctp, $hash_x2_sctp);
my (%hash_x2_x2ap, $hash_x2_s1x2ap);
%hash_x2_nbr_index = ();
%hash_x2_nbr_enodeb_id = ();
%hash_x2_sctp = ();
%hash_x2_x2ap = ();

my (%hash_IDLE_CELL_NUM, $hash_IDLE_CELL_NUM);
my (%hash_IDLE_DL_ANT_COUNT, $hash_IDLE_DL_ANT_COUNT);
my (%hash_IDLE_UL_ANT_COUNT, $hash_IDLE_UL_ANT_COUNT);
my (%hash_IDLE_EARFCN_DL, $hash_IDLE_EARFCN_DL);
my (%hash_IDLE_EARFCN_UL, $hash_IDLE_EARFCN_UL);
my (%hash_IDLE_PHY_CELL_ID, $hash_IDLE_PHY_CELL_ID);
%hash_IDLE_CELL_NUM = ();
%hash_IDLE_DL_ANT_COUNT = ();
%hash_IDLE_UL_ANT_COUNT = ();
%hash_IDLE_EARFCN_DL = ();
%hash_IDLE_EARFCN_UL = ();
%hash_IDLE_PHY_CELL_ID = ();

my (%hash_num_4g_sectors, $hash_num_4g_sectors);
%hash_num_4g_sectors = ();

my (%hash_4g_tac, $hash_4g_tac);
%hash_4g_tac = ();

my (%hash_cell_info_title, $hash_cell_info_title);
my (%hash_4g_tac, $hash_4g_tac);
%hash_4g_tac = ();
%hash_cell_info_title = ();


my (%hash_4g_CELL_NUM, $hash_4g_CELL_NUM);
my (%hash_4g_ROOT_SEQUENCE_INDEX, $hash_4g_ROOT_SEQUENCE_INDEX);
%hash_4g_CELL_NUM = ();
%hash_4g_ROOT_SEQUENCE_INDEX = ();

my (%hash_lat_direction, $hash_lat_direction);
my (%hash_lat_degrees, $hash_lat_degrees);
my (%hash_lat_minutes, $hash_lat_minutes);
my (%hash_lat_seconds, $hash_lat_seconds);
%hash_lat_direction = ();
%hash_lat_degrees = ();
%hash_lat_minutes = ();
%hash_lat_seconds = ();
my (@array_lat_space, $array_lat_space);
my (@array_lat_colon, $array_lat_colon);


my (%hash_long_direction, $hash_long_direction);
my (%hash_long_degrees, $hash_long_degrees);
my (%hash_long_minutes, $hash_long_minutes);
my (%hash_long_seconds, $hash_long_seconds);
%hash_long_direction = ();
%hash_long_degrees = ();
%hash_long_minutes = ();
%hash_long_seconds = ();
my (@array_long_space, $array_long_space);
my (@array_long_colon, $array_long_colon);

my (%hash_4g_tac, $hash_4g_tac);
my (%hash_4g_cell_reserved, $hash_4g_cell_reserved);
%hash_4g_tac = ();
%hash_4g_cell_reserved = ();
my (@array_cell_info_each_line, $array_cell_info_each_line);

my ($MMBS_OAM_IP_4G_LSM, $MMBS_S_B_IP_4G_LSM);

my ($CSR_OAM_IP_4G_LSM);
my (%hash_CSR_S_B_IP_4G_LSM, $hash_CSR_S_B_IP_4G_LSM);
%hash_CSR_S_B_IP_4G_LSM = ();
my $csr_s_b_ip_count = 0;

my (%hash_RTRV_NBR_EUTRAN_TITLE, $hash_RTRV_NBR_EUTRAN_TITLE);
my (%hash_RTRV_NBR_EUTRAN_CELL_NUM, $hash_RTRV_NBR_EUTRAN_CELL_NUM);
my (%hash_RTRV_NBR_EUTRAN_REL_IDX, $hash_RTRV_NBR_EUTRAN_REL_IDX);
my (%hash_RTRV_NBR_EUTRAN, $hash_RTRV_NBR_EUTRAN);
%hash_RTRV_NBR_EUTRAN_TITLE = ();
%hash_RTRV_NBR_EUTRAN_CELL_NUM = ();
%hash_RTRV_NBR_EUTRAN_REL_IDX = ();
%hash_RTRV_NBR_EUTRAN = ();

my (%hash_RTRV_RRH_INVT_TITLE, $hash_RTRV_RRH_INVT_TITLE);
my (%hash_RTRV_RRH_INVT_CONN_BD_ID, $hash_RTRV_RRH_INVT_CONN_BD_ID);
my (%hash_RTRV_RRH_INVT_CONN_PORT_ID, $hash_RTRV_RRH_INVT_CONN_PORT_ID);
my (%hash_RTRV_RRH_INVT, $hash_RTRV_RRH_INVT);
%hash_RTRV_RRH_INVT_TITLE = ();
%hash_RTRV_RRH_INVT_CONN_BD_ID = ();
%hash_RTRV_RRH_INVT_CONN_PORT_ID = ();
%hash_RTRV_RRH_INVT = ();

my (%hash_RTRV_RRH_CONF_TITLE, $hash_RTRV_RRH_CONF_TITLE);
%hash_RTRV_RRH_CONF_TITLE = ();

my (%hash_RTRV_RRH_CONF, $hash_RTRV_RRH_CONF);
%hash_RTRV_RRH_CONF = ();

my (%hash_RTRV_EUTRA_FA_TITLE, $hash_RTRV_EUTRA_FA_TITLE);
%hash_RTRV_EUTRA_FA_TITLE = ();

my (%hash_RTRV_EUTRA_FA, $hash_RTRV_EUTRA_FA);
%hash_RTRV_EUTRA_FA = ();

my (%hash_RTRV_GPS_INVT_TITLE, $hash_RTRV_GPS_INVT_TITLE);
my (%hash_RTRV_GPS_INVT, $hash_RTRV_GPS_INVT);
my (%hash_RTRV_GPS_INVT_UNIT_ID, $hash_RTRV_GPS_INVT_UNIT_ID);
%hash_RTRV_GPS_INVT_TITLE = ();
%hash_RTRV_GPS_INVT = ();
%hash_RTRV_GPS_INVT_UNIT_ID = ();

my (%hash_RTRV_CELL_STS_CELL_NUM, $hash_RTRV_CELL_STS_CELL_NUM);
my (%hash_RTRV_CELL_STS, $hash_RTRV_CELL_STS);
%hash_RTRV_CELL_STS_CELL_NUM = ();
%hash_RTRV_CELL_STS = ();


my (%hash_C1XRTT_MOBIL, $hash_C1XRTT_MOBIL);
%hash_C1XRTT_MOBIL = ();

my (@array_prc_fw, $array_prc_fw);
my ($prc_fw_value);

my (%hash_RTRV_EAIU_INVT, $hash_RTRV_EAIU_INVT);
%hash_RTRV_EAIU_INVT = ();

my (%hash_C1XRTT_PREG_TITLE, $hash_C1XRTT_PREG_TITLE);
%hash_C1XRTT_PREG_TITLE = ();

my (%hash_C1XRTT_PREG, $hash_C1XRTT_PREG);
%hash_C1XRTT_PREG = ();

my (%hash_C1XRTT_PREGSECTOR_TITLE, $hash_C1XRTT_PREGSECTOR_TITLE);
%hash_C1XRTT_PREGSECTOR_TITLE = ();

my (%hash_C1XRTT_PREGSECTOR, $hash_C1XRTT_PREGSECTOR);
%hash_C1XRTT_PREGSECTOR = ();

my (%hash_SYS_CONF_TITLE, $hash_SYS_CONF_TITLE);
%hash_SYS_CONF_TITLE = ();

my (%hash_SYS_CONF, $hash_SYS_CONF);
%hash_SYS_CONF = ();

my (%hash_NBR_C1XRTT, $hash_NBR_C1XRTT);
%hash_NBR_C1XRTT = ();

my (%hash_SONFN_CELL, $hash_SONFN_CELL);
%hash_SONFN_CELL = ();

my (%hash_SON_ANR, $hash_SON_ANR);
%hash_SON_ANR = ();

my (%hash_NBR_HRPD, $hash_NBR_HRPD);
%hash_NBR_HRPD = ();

my (%hash_CELL_ACS, $hash_CELL_ACS);
%hash_CELL_ACS = ();

my (%hash_cell, $hash_cell);
%hash_cell = ();

my (%hash_RTRV_CELL_DATA, $hash_RTRV_CELL_DATA);
%hash_RTRV_CELL_DATA = ();

my (%hash_RTRV_CELL_CAC, $hash_RTRV_CELL_CAC);
%hash_RTRV_CELL_CAC = ();

my (%hash_CELL_IDLE_INFO, $hash_CELL_IDLE_INFO);
%hash_CELL_IDLE_INFO = ();

my ($load_name);

my ($VERSION);
my ($TIME_ZONE);

my (%hash_CELL_NUMS, $hash_CELL_NUMS);
%hash_CELL_NUMS = ();

my (%hash_PDSCH_IDLE, $hash_PDSCH_IDLE);
%hash_PDSCH_IDLE = ();

my (%hash_INVENTORY_MAN, $hash_INVENTORY_MAN);
%hash_INVENTORY_MAN = ();

#############################
# START LSM_INFO SUBROUTINE #
#############################
sub LSM_INFO {
my $colon = ";";

####################
# START SSH TO LSM #
####################
my $ssh_lsm = new Control::CLI(Use => 'SSH',
                        Prompt => ']',
			Errmode=> 'return',
                        Timeout=> '80');

$ssh_lsm->connect(Host => $lsm_ip,
          Username => $lsm_user,
          Password => $lsm_pass,
        PrivateKey => '.ssh/id_dsa');



$ssh_lsm->read(Blocking => 1);

sleep 2;

my $date_info = $ssh_lsm->print("date;");
$ssh_lsm->waitfor(';');
my $date_info = $ssh_lsm->waitfor(']');
$date_info =~ s/\[.*$//g;
$date_info =~ s/\n+//g;
$date_info =~ s/\r+//g;
#print ("$date_info\n");

if ($date_info =~ m/EST/) {
$TIME_ZONE = "EST";
                          }

if ($date_info =~ m/AST/) {
$TIME_ZONE = "AST";
                          }

if ($date_info =~ m/CST/) {
$TIME_ZONE = "CST";
                          }

if ($date_info =~ m/PST/) {
$TIME_ZONE = "PST";
                          }







$ssh_lsm->print("pwd");

$ssh_lsm->print("source /home/lsm/.profile");
$ssh_lsm->waitfor(']');
my $profile = $ssh_lsm->waitfor(']');
#print ("$profile\n");

sleep 1;

$ssh_lsm->print("INFO.sh;");
$ssh_lsm->waitfor(';');
my $info = $ssh_lsm->waitfor(']');
$info =~ s/\[.*//g;
print ("$info\n");


my ($database_name, $load);

if  (($info =~ m/4.0/)||($info =~ m/5.0/)) {
$database_name = "mc_db";
$load = "4.0";
                                 }
else {
$database_name = "lsm_db";
     }


#print ("$database_name $load\n");


my (@array_each_line_info, $array_each_line_info);
@array_each_line_info = split(/\n/, $info);

foreach $array_each_line_info (@array_each_line_info) {
if ($array_each_line_info =~ m/Version\s+\:/) {
$load_name = $array_each_line_info;
#$load_name =~ s/.*SPRINT_SSLR_//g;
#$load_name =~ s/_LSM.*//g;
#$load_name =~ s/.*LSM_//g;
#$load_name =~ s/_Bundle.*//g;
#$load_name =~ s/_.*//g;
$load_name =~ s/.*\:\s+//g;
$load_name =~ s/\s+//g;
#print ("$load_name\n");
                                              }

                                                      }


###############################################
# START GET ALARM, BUCKET, ENODEB INFORMATION #
###############################################

$ssh_lsm->print("/db/mysql/app/bin/mysql -ulsm -plsm $database_name");
my $sql_start = $ssh_lsm->waitfor('mysql>');
#print ("$sql_start\n\n");





##########################
# START GET BUCKET NAMES #
##########################
$ssh_lsm->print("select level2_id,ems_alias from cm_v_level2andcoord_lsm;");
$BUCKETS = $ssh_lsm->waitfor('mysql>');
#print ("$BUCKETS\n");

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




$ssh_lsm->print("select level2_id,ems_alias,level3_id,system_id,ip_addr_1,version,cur_pkg_ver from cm_v_level3_lsm where system_id = '$enodeb_id';");
$ENODEBS = $ssh_lsm->waitfor('mysql>');
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
if (($array_get_enodeb_ids !~ m/rows\s+in\s+set/) && ($array_get_enodeb_ids !~ m/row\s+in\s+set/) && ($array_get_enodeb_ids !~ m/system_id/)) {
@_ = split(/\t+/, $array_get_enodeb_ids);


if ($_[3] eq "$enodeb_id") {
$hash_enode_name{$_[1]} = $_[1];		#enodeb name
$bucket_4g = $hash_level_id{$_[0]};
$hash_enodeb_bucket{$_[1]} = $bucket_4g;	#enodeb bucket name
$hash_enodeb_num{$_[1]} = $_[3];		#enodeb number
$hash_enodeb_ip{$_[1]} = $_[4];			#endodeb ip
$VERSION = $_[5];

##################
# START MME INFO #
##################
my $bucket_info_mme = $bucket_4g;
$bucket_info_mme =~ s/_TEST.*//g;
$bucket_info_mme =~ s/_GROW.*//g;
$bucket_info_mme =~ s/_COMMERCIAL.*//g;
$bucket_info_mme =~ s/_GMR.*//g;
$bucket_info_mme =~ s/\s+//g;
$bucket_info_mme = uc($bucket_info_mme);

#print ("$bucket_info_mme\n");


$lsm_name =~ s/\s+//g;

my $lsm_NAME_UC = uc($lsm_name);


if (($lsm_NAME_UC =~ m/CHICAGO/) || ($lsm_NAME_UC =~ m/AKRON/) || ($lsm_NAME_UC =~ m/BAYAMON/) || ($lsm_NAME_UC eq "TACOMA_LSMR_1") || ($lsm_NAME_UC eq "TACOMA_LSMR_3")) {
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'AKRNOHIJ-MME-11'} = "10.156.35.12";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'AKRNOHIJ-MME-12'} = "10.156.35.172";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'AKRNOHIJ-MME-13'} = "10.156.35.188";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'AKRNOHIJ-MME-14'} = "10.156.35.204";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'AKRNOHIJ-MME-15'} = "10.156.35.220";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'CHCGILFF-MME-01'} = "10.158.211.12";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'CHCGILFF-MME-02'} = "10.158.211.172";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'CHCGILFF-MME-03'} = "10.158.211.188";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'CHCGILFF-MME-04'} = "10.158.211.204";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'CHCGILFF-MME-05'} = "10.158.211.220";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'CHCGILFF-MME-07'} = "10.158.212.20";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'AKRNOHIJ-MME-17'} = "10.156.34.28";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'CHCGILFF-MME-06'} = "10.158.212.4";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'AKRNOHIJ-MME-16'} = "10.156.35.44";
                                                                                                                                                                         }


if (($lsm_NAME_UC =~ m/SAN_JOSE/) || ($lsm_NAME_UC eq "TACOMA_LSMR_2")) {
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'SNJSCASP-MME-01'} = "10.156.11.12";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'TACMWA44-MME-11'} = "10.156.3.12";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'SNJSCASP-MME-02'} = "10.156.11.172";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'TACMWA44-MME-12'} = "10.156.3.172";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'SNJSCASP-MME-03'} = "10.156.11.188";
$hash_MME_INFO{$lsm_name}{$bucket_info_mme}{'TACMWA44-MME-13'} = "10.156.3.188";
                                                                        }

##################
#  END MME INFO  #
##################


if ($_[4] !~ m/\d+\.\d+\.\d+\.\d+/) {
print ("ENODEB $enodeb_name SITE DOWN\n");
print (FILE_4G "ENODEB $enodeb_name SITE DOWN\n");
sleep 5;
$ssh_lsm->print('exit');

$ssh_lsm->disconnect;
exit;

                                    }


$enodeb_ip_address_LSM = $_[4];			#endodeb ip
$hash_enodeb_sw{$_[1]} = $_[6];			#enodeb software
$pkg = $_[6];
$hash_enodeb_num_for_alm{$_[2]} = $_[1];	#enodeb number for alarms
$alarm_4g_enodeb_num = $_[2];			#variable number for enodeb in alarm
print ("ENODEB_NAME:$hash_enode_name{$_[1]}\nBUCKET:$hash_enodeb_bucket{$_[1]}\nENODEB_NUM:$hash_enodeb_num{$_[1]}\nIP:$hash_enodeb_ip{$_[1]}\nSOFTWARE:$hash_enodeb_sw{$_[1]}\nENODE_FOR_ALARM:$hash_enodeb_num_for_alm{$_[2]}\n\n");
                           }




                                                                                                                                              }
                                                       }


#########################
#  END GET ENODEB INFO  #
#########################

###############################################
#  END GET ALARM, BUCKET, ENODEB INFORMATION  #
###############################################

$ssh_lsm->print("select level3_id,alarm_id from fm_v_uncleared_alarms where alarm_id ='2006';");
$ALARMS = $ssh_lsm->waitfor('mysql>');
#print ("$ALARMS\n");

########################
# START GET SITES DOWN #
########################
my (@array_split_ALARMS, $array_split_ALARMS);
@array_split_ALARMS = split(/\n/, $ALARMS);

foreach $array_split_ALARMS (@array_split_ALARMS) {
$array_split_ALARMS =~ s/^\|\s+//g;
$array_split_ALARMS =~ s/\|\s+$//g;
$array_split_ALARMS =~ s/\s+$//g;
$array_split_ALARMS =~ s/\s+\|\s+/\t/g;
if (($array_split_ALARMS =~ m/^\d+/) && ($array_split_ALARMS !~ m/row\s+in\s+set/) && ($array_split_ALARMS !~ m/rows\s+in\s+set/)) {
#print ("$array_split_ALARMS\n");
@_ = split(/\t/, $array_split_ALARMS);
$_[0] =~ s/\s+//g;
if ($_[0]) {
my $enodeb = "$hash_enodeb_num_for_alm{$_[0]}";
if ($enodeb eq "$enodeb_name") {
print ("ENODEB $enodeb_name SITE DOWN\n");
print (FILE_4G "ENODEB $enodeb_name SITE DOWN\n");
sleep 5;
$ssh_lsm->print('exit');

$ssh_lsm->disconnect;
exit;

                               }


           }
                                                                                                                                  }
                                                  }

########################
#  END GET SITES DOWN  #
########################


$ssh_lsm->print("exit");
my $sql_exit = $ssh_lsm->waitfor(']');
#print ("$sql_exit\n\n");

#print Dumper(\%hash_MME_INFO);



if ($hash_enode_name{$enodeb_name}) {			#start if enodeb exists
my $SW = $hash_enodeb_sw{$enodeb_name};

$ssh_lsm->print('pwd');
$ssh_lsm->waitfor('/home/');

#######################
# START RTRV-ALM-LIST #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-ALM-LIST");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_ALM_LIST = $ssh_lsm->waitfor(';');
$RTRV_ALM_LIST = "$RTRV_ALM_LIST$colon";
print ("$RTRV_ALM_LIST\n");
print (FILE_4G "$RTRV_ALM_LIST\n");



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

#if (($RTRV_ALM_LIST =~ m/REASON/) && ($RTRV_ALM_LIST =~ m/NO DATA/) && ($RTRV_ALM_LIST =~ m/NOK/)) {
#print ("THERE ARE NO 4G ALARMS\n");
#                                                                                                   }
#print Dumper(\%hash_ALM_4G);

#######################
#  END RTRV-ALM-LIST  #
#######################


######################
# START RTRV-ALM-LOG #
######################
$ssh_lsm->print("cmd $enodeb_name RTRV-ALM-LOG");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_ALM_LOG = $ssh_lsm->waitfor(';');
$RTRV_ALM_LOG = "$RTRV_ALM_LOG$colon";
print ("$RTRV_ALM_LOG\n");
print (FILE_4G "$RTRV_ALM_LOG\n");


my (@each_line_4g_alm_history, $each_line_4g_alm_history);

@each_line_4g_alm_history = split(/\n/, $RTRV_ALM_LOG);


foreach $each_line_4g_alm_history (@each_line_4g_alm_history) {
my $number = "";
my $unit = "";
my $alarm_type = "";
my $location = "";
my $start_time = "";
my $end_time = "";
my $probable_cause = "";
my $serverity = "";
my $alarm_code = "";


$each_line_4g_alm_history =~ s/^\s+//g;
if ($each_line_4g_alm_history =~ m/^\d+/) {
@_ = split(/\s+/, $each_line_4g_alm_history);

$number = "$_[0]";

$unit = "$_[1]";
$hash_ALM_HIST_4G{$number}{UNIT} = "$unit";
$alarm_type = "$_[2]";
$hash_ALM_HIST_4G{$number}{ALARM_TYPE} = "$alarm_type";
$location = "$_[3]";
$hash_ALM_HIST_4G{$number}{LOCATION} = "$location";
$start_time = "$_[4] $_[5]";
$hash_ALM_HIST_4G{$number}{START_TIME} = "$start_time";

if ($_[6] eq "-") {
$end_time = "$_[6]";
$hash_ALM_HIST_4G{$number}{END_TIME} = "$end_time";
$probable_cause = "$_[8]";
$hash_ALM_HIST_4G{$number}{PROBABLE_CAUSE} = "$probable_cause";
$serverity = "$_[9]";
$hash_ALM_HIST_4G{$number}{SERVERITY} = "$serverity";
$alarm_code = "$_[10]";
$hash_ALM_HIST_4G{$number}{ALARM_CODE} = "$alarm_code";
                  }

else {
$end_time = "$_[6] $_[7]";
$hash_ALM_HIST_4G{$number}{END_TIME} = "$end_time";
$probable_cause = "$_[9]";
$hash_ALM_HIST_4G{$number}{PROBABLE_CAUSE} = "$probable_cause";
$serverity = "$_[10]";
$hash_ALM_HIST_4G{$number}{SERVERITY} = "$serverity";
$alarm_code = "$_[11]";
$hash_ALM_HIST_4G{$number}{ALARM_CODE} = "$alarm_code";
     }

                                          }
                                                              }

#print Dumper(\%hash_ALM_HIST_4G);



######################
#  END RTRV-ALM-LOG #
######################

########################
# START RTRV-CELL-CONF #
########################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-CONF");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_CONF = $ssh_lsm->waitfor(';');
$RTRV_CELL_CONF = "$RTRV_CELL_CONF$colon";
print ("$RTRV_CELL_CONF\n");
print (FILE_4G "$RTRV_CELL_CONF\n");

my (@array_cell_conf_each_line, $array_cell_conf_each_line);
@array_cell_conf_each_line = split(/\n/, $RTRV_CELL_CONF);

foreach $array_cell_conf_each_line (@array_cell_conf_each_line) {
$array_cell_conf_each_line =~ s/^\s+//g;
if ($array_cell_conf_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_cell_conf_each_line);
$_[0] =~ s/\s+//g;
$_[1] =~ s/\s+//g;
$_[2] =~ s/\s+//g;
if ($_[1] eq "EQUIP") {
$hash_RTRV_CELL_CONF{$_[0]}{$_[1]} = "$_[2]";
$hash_CELL_NUMS{$_[0]} = $_[1];
                      }
#print ("\n$_[0] $_[1] $_[2]\n");
                                           }


                                                                }
#print Dumper(\%hash_RTRV_CELL_CONF);
########################
# START RTRV-CELL-CONF #
########################


#####################
# START RTRV-S1-STS #
#####################
$ssh_lsm->print("cmd $enodeb_name RTRV-S1-STS");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $S1_STATUS = $ssh_lsm->waitfor(';');
$S1_STATUS = "$S1_STATUS$colon";
print ("$S1_STATUS\n");
print (FILE_4G "$S1_STATUS\n");

if (($S1_STATUS =~ m/RESULT/) && ($S1_STATUS =~ m/NOK/) && ($S1_STATUS =~ m/REASON/)) {
$S1_STATUS =~ s/\n+\s+REASON/ REASON/g;
$S1_STATUS =~ s/\s+\:\s+/=/g;
$S1_STATUS =~ s/\s+\=\s+/=/g;
$S1_STATUS =~ s/\!//g;
#print ("$S1_STATUS\n");
@_ = split(/\n+/, $S1_STATUS);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$s1_nok = $_;
#print ("$s1_nok\n");
                         }
                }
                                                                                      }

my (@array_4g_s1_each_line, $array_4g_s1_each_line);
@array_4g_s1_each_line = split(/\n/, $S1_STATUS);

foreach $array_4g_s1_each_line (@array_4g_s1_each_line) {
$array_4g_s1_each_line =~ s/^\s+//g;
if ($array_4g_s1_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_4g_s1_each_line);
my $mme_names = "$_[4]";
$mme_names = uc($mme_names);
$hash_s1_mme_index{$_[0]} = $_[0];			#s1 mme index key and value mme index
$hash_s1_mme_id{$_[0]} = $_[1];				#s1 mme id key = mme index value = mme id
$hash_s1_mme_sctp{$_[0]} = $_[2];			#s1 sctp key = mme index value = sctp
$hash_s1_s1ap{$_[0]} = $_[3];				#s1 s1ap key = mme index value s1ap
$hash_s1_mme_name{$_[0]} = $mme_names;			#s1 mme name key = mme index value mme_name
$hash_s1_mme_ip_v4{$_[0]} = $_[6];			#s1 mme ip key = mme index value mme_ip_v4
#print ("$_[0] $_[2] $_[3] $_[4] $_[6]\n");
                                       }
                                                        }

#####################
#  END RTRV-S1-STS  #
#####################


################
# START GET X2 #
################
$ssh_lsm->print("cmd $enodeb_name RTRV-X2-STS");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $X2_STATUS = $ssh_lsm->waitfor(';');
$X2_STATUS = "$X2_STATUS$colon";
print ("$X2_STATUS\n");
print (FILE_4G "$X2_STATUS\n");


if (($X2_STATUS =~ m/RESULT/) && ($X2_STATUS =~ m/NOK/) && ($X2_STATUS =~ m/REASON/)) {
$X2_STATUS =~ s/\n+\s+REASON/ REASON/g;
$X2_STATUS =~ s/\s+\:\s+/=/g;
$X2_STATUS =~ s/\s+\=\s+/=/g;
$X2_STATUS =~ s/\!//g;
#print ("$X2_STATUS\n");
@_ = split(/\n+/, $X2_STATUS);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$x2_nok = $_;
#print ("$x2_nok\n");
                         }
                }
                                                                                      }

my (@array_4g_x2_each_line, $array_4g_x2_each_line);
@array_4g_x2_each_line = split(/\n/, $X2_STATUS);

foreach $array_4g_x2_each_line (@array_4g_x2_each_line) {
$array_4g_x2_each_line =~ s/^\s+//g;
if ($array_4g_x2_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_4g_x2_each_line);
$hash_x2_nbr_index{$_[0]} = $_[0];		#NBR_ENB_INDEX
$hash_x2_nbr_enodeb_id{$_[0]} = $_[1];		#NBR_ENB_ID
$hash_x2_sctp{$_[0]} = $_[2];			#SCTP_STATE
$hash_x2_x2ap{$_[0]} = $_[3];			#X2AP_STATE

#print ("$array_4g_x2_each_line\n");
                                       }

                                                        }

################
#  END GET X2  #
################


##########################################################################
# START GET RTRV-CELL-IDLE DL_ANT_COUNT UL_ANT_COUNT EARFCN_DL EARFCN_UL #
##########################################################################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-IDLE");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_IDLE_4G = $ssh_lsm->waitfor(';');
$RTRV_CELL_IDLE_4G = "$RTRV_CELL_IDLE_4G$colon";
print ("$RTRV_CELL_IDLE_4G\n");
print (FILE_4G "$RTRV_CELL_IDLE_4G\n");


if (($RTRV_CELL_IDLE_4G =~ m/RESULT/) && ($RTRV_CELL_IDLE_4G =~ m/NOK/) && ($RTRV_CELL_IDLE_4G =~ m/REASON/)) {
$RTRV_CELL_IDLE_4G =~ s/\n+\s+REASON/ REASON/g;
$RTRV_CELL_IDLE_4G =~ s/\s+\:\s+/=/g;
$RTRV_CELL_IDLE_4G =~ s/\s+\=\s+/=/g;
$RTRV_CELL_IDLE_4G =~ s/\!//g;
#print ("$RTRV_CELL_IDLE_4G\n");
@_ = split(/\n+/, $RTRV_CELL_IDLE_4G);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$cell_idle_nok = $_;
#print ("$cell_idle_nok\n");
                         }
                }
                                                                                                              }


my $sector_count_4g = 0;
my (@array_cell_info_each_line, $array_cell_info_each_line);
@array_cell_info_each_line = split(/\n/, $RTRV_CELL_IDLE_4G);

my $cell_value_num = 0;
foreach $array_cell_info_each_line (@array_cell_info_each_line) {


if ($array_cell_info_each_line =~ m/^\s+CELL_NUM/) {
$array_cell_info_each_line =~ s/^\s+//g;
@_ = split(/\s+/, $array_cell_info_each_line);
foreach $_ (@_) {
$hash_cell_info_title{$_} = $cell_value_num;
$cell_value_num++;
                }
                                                   }


$array_cell_info_each_line =~ s/^\s+//g;
if ($array_cell_info_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_cell_info_each_line);
my $cell_num_value = $hash_cell_info_title{"CELL_NUM"};
my $pci_num_value = $hash_cell_info_title{"PHY_CELL_ID"};
my $dlant_count_num_value = $hash_cell_info_title{"DL_ANT_COUNT"};
my $ulant_count_num_value = $hash_cell_info_title{"UL_ANT_COUNT"};
my $earfcn_dl_num_value = $hash_cell_info_title{"EARFCN_DL"};
my $earfcn_ul_num_value = $hash_cell_info_title{"EARFCN_UL"};
my $dl_bandwidth_num_value = $hash_cell_info_title{"DL_BANDWIDTH"};
my $ul_bandwidth_num_value = $hash_cell_info_title{"UL_BANDWIDTH"};
my $tac_num_value = $hash_cell_info_title{"TRACKING_AREA_CODE"};

if (($_[$tac_num_value] ne "H'0000") && ($_[$tac_num_value] =~m/H'/)) {
$hash_4g_tac{$_[$cell_num_value]} = $_[$tac_num_value];		#hash sector key tac value
                                                                      } 
                 
$hash_IDLE_CELL_NUM{$_[$cell_num_value]} = $_[$cell_num_value];	#CELL_NUM
$hash_IDLE_PHY_CELL_ID{$_[$cell_num_value]} = $_[$pci_num_value];	#PHY_CELL_ID
$hash_IDLE_DL_ANT_COUNT{$_[$cell_num_value]} = $_[$dlant_count_num_value];	#DL_ANT_COUNT
$hash_IDLE_UL_ANT_COUNT{$_[$cell_num_value]} = $_[$ulant_count_num_value];	#UL_ANT_COUNT
$hash_IDLE_EARFCN_DL{$_[$cell_num_value]} = $_[$earfcn_dl_num_value];	#EARFCN_DL
$hash_IDLE_EARFCN_UL{$_[$cell_num_value]} = $_[$earfcn_ul_num_value];	#EARFCN_UL

my $CELL_NUM = "$_[$cell_num_value]";
my $DL_ANT_COUNT = "$_[$dlant_count_num_value]";
my $UL_ANT_COUNT = "$_[$ulant_count_num_value]";
my $EARFCN_DL = "$_[$earfcn_dl_num_value]";
my $EARFCN_UL = "$_[$earfcn_ul_num_value]";

my $DL_BANDWIDTH = "$_[$dl_bandwidth_num_value]";
my $UL_BANDWIDTH = "$_[$ul_bandwidth_num_value]";

$hash_CELL_IDLE_INFO{$CELL_NUM}{DL_ANT_COUNT} = "$DL_ANT_COUNT";
$hash_CELL_IDLE_INFO{$CELL_NUM}{UL_ANT_COUNT} = "$UL_ANT_COUNT";
$hash_CELL_IDLE_INFO{$CELL_NUM}{EARFCN_DL} = "$EARFCN_DL";
$hash_CELL_IDLE_INFO{$CELL_NUM}{EARFCN_UL} = "$EARFCN_UL";
$hash_CELL_IDLE_INFO{$CELL_NUM}{DL_BANDWIDTH} = "$DL_BANDWIDTH";
$hash_CELL_IDLE_INFO{$CELL_NUM}{UL_BANDWIDTH} = "$UL_BANDWIDTH";


                                           }
                                                                }


foreach $hash_IDLE_CELL_NUM (sort keys %hash_IDLE_CELL_NUM) {
$sector_count_4g++;
#print ("CELL_NUM:$hash_IDLE_CELL_NUM PCI:$hash_IDLE_PHY_CELL_ID{$hash_IDLE_CELL_NUM} DL_ANT_COUNT:$hash_IDLE_DL_ANT_COUNT{$hash_IDLE_CELL_NUM} UL_ANT_COUNT:$hash_IDLE_UL_ANT_COUNT{$hash_IDLE_CELL_NUM} EARFCN_DL:$hash_IDLE_EARFCN_DL{$hash_IDLE_CELL_NUM} EARFCN_UL:$hash_IDLE_EARFCN_UL{$hash_IDLE_CELL_NUM}\n");
                                                            }

$hash_num_4g_sectors{$cascade} = $sector_count_4g;	#Number of 4g sectors
#print ("Number 4G Sectors: $hash_num_4g_sectors{$cascade}\n");


##########################################################################
#  END GET RTRV-CELL-IDLE DL_ANT_COUNT UL_ANT_COUNT EARFCN_DL EARFCN_UL  #
##########################################################################

#########################
# START RTRV_PRACH_CONF #
#########################

$ssh_lsm->print("cmd $enodeb_name RTRV-PRACH-CONF");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_PRACH_CONF_4G = $ssh_lsm->waitfor(';');
$RTRV_PRACH_CONF_4G = "$RTRV_PRACH_CONF_4G$colon";
print ("$RTRV_PRACH_CONF_4G\n");
print (FILE_4G "$RTRV_PRACH_CONF_4G\n");

my (@array_prach_each_line, $array_prach_each_line);
@array_prach_each_line = split(/\n/, $RTRV_PRACH_CONF_4G);

foreach $array_prach_each_line (@array_prach_each_line) {
$array_prach_each_line =~ s/^\s+//g;
if ($array_prach_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_prach_each_line);
$hash_4g_CELL_NUM{$_[0]} = $_[0];		#CELL_NUM
$hash_4g_ROOT_SEQUENCE_INDEX{$_[0]} = $_[4];	#ROOT_SEQUENCE_INDEX
#print ("$_[0] $_[4]\n");
                                       }
                                                        }
#########################
#  END RTRV_PRACH_CONF  #
#########################


#######################
# START  RTRV-GPS-STS #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-GPS-STS");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_GPS_STS_4G = $ssh_lsm->waitfor(';');
$RTRV_GPS_STS_4G = "$RTRV_GPS_STS_4G$colon";
print ("$RTRV_GPS_STS_4G\n");
print (FILE_4G "$RTRV_GPS_STS_4G\n");

if (($RTRV_GPS_STS_4G =~ m/RESULT/) && ($RTRV_GPS_STS_4G =~ m/NOK/) && ($RTRV_GPS_STS_4G =~ m/REASON/)) {
$RTRV_GPS_STS_4G =~ s/\n+\s+REASON/ REASON/g;
$RTRV_GPS_STS_4G =~ s/\s+\:\s+/=/g;
$RTRV_GPS_STS_4G =~ s/\s+\=\s+/=/g;
$RTRV_GPS_STS_4G =~ s/\!//g;
#print ("$RTRV_GPS_STS_4G\n");
@_ = split(/\n+/, $RTRV_GPS_STS_4G);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$gps_nok = $_;
#print ("$gps_nok\n");
                         }
                }
                                                                                                        }


my (@array_each_line_gps_sts, $array_each_line_gps_sts);
@array_each_line_gps_sts = split(/\n/, $RTRV_GPS_STS_4G);
foreach $array_each_line_gps_sts (@array_each_line_gps_sts) {
$array_each_line_gps_sts =~ s/^\s+//g;
if (($array_each_line_gps_sts =~ m/Latitude:/) && ($array_each_line_gps_sts =~ m/Longitude:/)) {
$array_each_line_gps_sts =~ s/Latitude:/,Latitude:/g;
$array_each_line_gps_sts =~ s/,\s+/,/g;
@_ = split(/,/, $array_each_line_gps_sts);
$_[1] =~ s/Latitude:\s+//g;
$_[2] =~ s/Longitude:\s+//g;

@array_lat_space = split(/\s+/, $_[1]);
$hash_lat_direction{$cascade} = $array_lat_space[0];	#latitude direction from lsm

@array_lat_colon = split(/\:/, $array_lat_space[1]);
$hash_lat_degrees{$cascade} = $array_lat_colon[0];	#latitude degrees from lsm
$hash_lat_minutes{$cascade} = $array_lat_colon[1];	#latitude minutes from lsm
$hash_lat_seconds{$cascade} = $array_lat_colon[2];	#latitude seconds from lsm



@array_long_space = split(/\s+/, $_[2]);
$hash_long_direction{$cascade} = $array_long_space[0];	#longitude direction from lsm

@array_long_colon = split(/\:/, $array_long_space[1]);
$hash_long_degrees{$cascade} = $array_long_colon[0];	#longitude degrees from lsm
$hash_long_minutes{$cascade} = $array_long_colon[1];	#longitude minutes from lsm
$hash_long_seconds{$cascade} = $array_long_colon[2];	#longitude seconds from lsm

#print ("Latitude: $hash_lat_direction{$cascade} $hash_lat_degrees{$cascade} $hash_lat_minutes{$cascade} $hash_lat_seconds{$cascade} Longitude: $hash_long_direction{$cascade} $hash_long_degrees{$cascade} $hash_long_minutes{$cascade} $hash_long_seconds{$cascade}\n");

                                                                                               }

                                                            }
#######################
#  END RTRV-GPS-STS   #
#######################

###########################
#  START  RTRV_CELL_INFO  #
###########################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-INFO");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_INFO_4G = $ssh_lsm->waitfor(';');
$RTRV_CELL_INFO_4G = "$RTRV_CELL_INFO_4G$colon";
print ("$RTRV_CELL_INFO_4G\n");
print (FILE_4G "$RTRV_CELL_INFO_4G\n");


@array_cell_info_each_line = split(/\n/, $RTRV_CELL_INFO_4G);
foreach $array_cell_info_each_line (@array_cell_info_each_line) {
$array_cell_info_each_line =~ s/^\s+//g;
@_ = split(/\s+/, $array_cell_info_each_line);






#if ($SW eq "3.1.0") {			#start if sw eq 3.1.0
my ($d);
for ($d=0; $d<9; $d++) {
if (($_[0] == $d) && (!$hash_4g_tac{$_[0]})) {
$hash_4g_tac{$_[0]} = $_[4];			#hash sector key tac value
                                             }

                       }

for ($d=15; $d<18; $d++) {
if (($_[0] == $d) && (!$hash_4g_tac{$_[0]})) {
$hash_4g_tac{$_[0]} = $_[4];			#hash sector key tac value
                                             }

                         }

#                    }			#end if sw eq 3.1.0






                                                                }
###########################
#   END  RTRV_CELL_INFO   #
###########################


$ssh_lsm->print("cmd $enodeb_name RTRV-CELLPLMN-INFO");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELLPLMN_INFO_4G = $ssh_lsm->waitfor(';');
$RTRV_CELLPLMN_INFO_4G = "$RTRV_CELLPLMN_INFO_4G$colon";
print ("$RTRV_CELLPLMN_INFO_4G\n");
print (FILE_4G "$RTRV_CELLPLMN_INFO_4G\n");

if ($SW eq "3.1.0") {			#start if sw eq 3.1.0
###################################################################
# START RTRV-CELLPLMN-INFO TO GET RESERVE/NOT_RESERVE IF SW 3.1.0 #
###################################################################
@array_PLMN_info_each_line = split(/\n/, $RTRV_CELLPLMN_INFO_4G);
foreach $array_PLMN_info_each_line (@array_PLMN_info_each_line) {
$array_PLMN_info_each_line =~ s/^\s+//g;
my (@each_value_PLMN, $each_value_PLMN);
@each_value_PLMN = split(/\s+/, $array_PLMN_info_each_line);

if ($each_value_PLMN[1] eq "0") {		#START IF PLMN_IDX IS 0




my ($d);
for ($d=0; $d<9; $d++) {
if ($each_value_PLMN[0] == $d) {
$hash_4g_cell_reserved{$each_value_PLMN[0]} = $each_value_PLMN[3];		#CELL_RESERVED_OP_USE0
                               }

                       }

for ($d=15; $d<18; $d++) {
if ($each_value_PLMN[0] == $d) {
$hash_4g_cell_reserved{$each_value_PLMN[0]} = $each_value_PLMN[3];		#CELL_RESERVED_OP_USE0
                               }

                         }






                                }		#END IF PLMN_IDX IS 0



                                                                }

###################################################################
#  END RTRV-CELLPLMN-INFO TO GET RESERVE/NOT_RESERVE IF SW 3.1.0  #
###################################################################
                    }			#end if sw eq 3.1.0


#########################
# START RTRV IP ADDRESS #
#########################
$ssh_lsm->print("cmd $enodeb_name RTRV-IP-ADDR");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_IP_ADDR_4G = $ssh_lsm->waitfor(';');
$RTRV_IP_ADDR_4G = "$RTRV_IP_ADDR_4G$colon";
print ("$RTRV_IP_ADDR_4G\n");
print (FILE_4G "$RTRV_IP_ADDR_4G\n");



if (($RTRV_IP_ADDR_4G =~ m/RESULT/) && ($RTRV_IP_ADDR_4G =~ m/NOK/) && ($RTRV_IP_ADDR_4G =~ m/REASON/)) {
$RTRV_IP_ADDR_4G =~ s/\n+\s+REASON/ REASON/g;
$RTRV_IP_ADDR_4G =~ s/\s+\:\s+/=/g;
$RTRV_IP_ADDR_4G =~ s/\s+\=\s+/=/g;
$RTRV_IP_ADDR_4G =~ s/\!//g;
#print ("$RTRV_IP_ADDR_4G\n");
@_ = split(/\n+/, $RTRV_IP_ADDR_4G);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$ip_add_nok = $_;
#print ("$ip_add_nok\n");
                         }
                }
                                                                                                       }


my (@array_4G_IP_ADDR_each_line, $array_4G_IP_ADDR_each_line);
@array_4G_IP_ADDR_each_line = split(/\n/, $RTRV_IP_ADDR_4G);
foreach $array_4G_IP_ADDR_each_line (@array_4G_IP_ADDR_each_line) {
$array_4G_IP_ADDR_each_line =~ s/^\s+//g;
if ($array_4G_IP_ADDR_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_4G_IP_ADDR_each_line);
if (($_[3] eq "30") && ($_[0] eq "1")) {
$MMBS_OAM_IP_4G_LSM = $_[2];				#MMBS_OAM_IP_4G_LSM from lsm
#print ("$_[0] $_[2]\n");
                                       }
if (($_[3] eq "30") && ($_[0] eq "2")) {
$MMBS_S_B_IP_4G_LSM = $_[2];				#MMBS_S_B_IP_4G_LSM from lsm
#print ("$_[0] $_[2]\n");
                                       }
                                            }
                                                                  }
#print ("MMBS_OAM_IP_4G_LSM:$MMBS_OAM_IP_4G_LSM\nMMBS_S_B_IP_4G_LSM:$MMBS_S_B_IP_4G_LSM\n");
#########################
#  END RTRV IP ADDRESS  #
#########################

#######################
# START RTRV IP ROUTE #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-IP-ROUTE");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_IP_ROUTE_4G = $ssh_lsm->waitfor(';');
$RTRV_IP_ROUTE_4G = "$RTRV_IP_ROUTE_4G$colon";
print ("$RTRV_IP_ROUTE_4G\n");
print (FILE_4G "$RTRV_IP_ROUTE_4G\n");


if (($RTRV_IP_ROUTE_4G =~ m/RESULT/) && ($RTRV_IP_ROUTE_4G =~ m/NOK/) && ($RTRV_IP_ROUTE_4G =~ m/REASON/)) {
$RTRV_IP_ROUTE_4G =~ s/\n+\s+REASON/ REASON/g;
$RTRV_IP_ROUTE_4G =~ s/\s+\:\s+/=/g;
$RTRV_IP_ROUTE_4G =~ s/\s+\=\s+/=/g;
$RTRV_IP_ROUTE_4G =~ s/\!//g;
#print ("$RTRV_IP_ROUTE_4G\n");
@_ = split(/\n+/, $RTRV_IP_ROUTE_4G);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$ip_rt_nok = $_;
#print ("$ip_rt_nok\n");
                         }
                }
                                                                                                          }

my (@array_4G_IP_ROUTE_each_line, $array_4G_IP_ROUTE_each_line);
@array_4G_IP_ROUTE_each_line = split(/\n/, $RTRV_IP_ROUTE_4G);
foreach $array_4G_IP_ROUTE_each_line (@array_4G_IP_ROUTE_each_line) {
$array_4G_IP_ROUTE_each_line =~ s/^\s+//g;
if ($array_4G_IP_ROUTE_each_line =~ m/^\d+/) {
@_ = split(/\s+/, $array_4G_IP_ROUTE_each_line);
#if (($_[3] eq "0") && ($_[1] eq "0")) {
if (($_[3] eq "32") && ($_[0] eq "0")) {
$CSR_OAM_IP_4G_LSM = $_[4];
#print ("$CSR_OAM_IP_4G_LSM\n");			#CSR_OAM_IP_4G_LSM
                                      }

if ($_[3] eq "16") {
$hash_CSR_S_B_IP_4G_LSM{$_[1]} = $_[4];			#CSR_S_B_IP_4G_LSM
#print ("$_[4]\n");
                   }


                                             }


                                                                    }

foreach $hash_CSR_S_B_IP_4G_LSM(sort keys %hash_CSR_S_B_IP_4G_LSM) {
$csr_s_b_ip_count++;

                                                                   }

#print ("CSR_OAM_IP_4G_LSM: $CSR_OAM_IP_4G_LSM\n");
#######################
#  END RTRV IP ROUTE  #
#######################


##########################
# START RTRV_NBR_EUTRAN  #
##########################
my ($RTRV_NBR_EUTRAN);

my ($cell);
#my (%hash_cell, $hash_cell);
#%hash_cell = ();

$hash_cell{0} = "0";
$hash_cell{1} = "1";
$hash_cell{2} = "2";

$hash_cell{3} = "3";
$hash_cell{4} = "4";
$hash_cell{5} = "5";

$hash_cell{6} = "6";
$hash_cell{7} = "7";
$hash_cell{8} = "8";

$hash_cell{9} = "9";
$hash_cell{10} = "10";
$hash_cell{11} = "11";

$hash_cell{15} = "15";
$hash_cell{16} = "16";
$hash_cell{17} = "17";

my ($RTRV_NBR_EUTRAN_COMBINED);
foreach $cell (sort {$a<=>$b} keys %hash_cell) {		#start cell numbers 0-1, 9-10, 15-17

$ssh_lsm->print("cmd $enodeb_name RTRV-NBR-EUTRAN:$cell");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
$RTRV_NBR_EUTRAN = $ssh_lsm->waitfor(';');
$RTRV_NBR_EUTRAN = "$RTRV_NBR_EUTRAN$colon";

if (($RTRV_NBR_EUTRAN !~ m/REASON = NO DATA/) && ($cell <= 2)) {		#start if $cell <=2
print ("$RTRV_NBR_EUTRAN\n");
print (FILE_4G "$RTRV_NBR_EUTRAN\n");
$RTRV_NBR_EUTRAN_COMBINED .= "$RTRV_NBR_EUTRAN";


#if (($RTRV_NBR_EUTRAN =~ m/RESULT/) && ($RTRV_NBR_EUTRAN =~ m/NOK/) && ($RTRV_NBR_EUTRAN =~ m/REASON/)) {
#$RTRV_NBR_EUTRAN =~ s/\n+\s+REASON/ REASON/g;
#$RTRV_NBR_EUTRAN =~ s/\s+\:\s+/=/g;
#$RTRV_NBR_EUTRAN =~ s/\s+\=\s+/=/g;
#$RTRV_NBR_EUTRAN =~ s/\!//g;
#print ("$RTRV_NBR_EUTRAN\n");
#@_ = split(/\n+/, $RTRV_NBR_EUTRAN);
#foreach $_ (@_) {
#if ($_ =~ m/^\s+RESULT/) {
#$_ =~ s/^\s+RESULT/RESULT/g;
#$nbr_eutran_nok = $_;
#print ("$nbr_eutran_nok\n");
#                         }
#                }
#                                                                                                        }
                                                              }		#end if $cell <=2

if (($RTRV_NBR_EUTRAN !~ m/REASON = NO DATA/) && ($cell > 2)) {	#start if log not match no data and cell greater than 2
print ("$RTRV_NBR_EUTRAN\n");
print (FILE_4G "$RTRV_NBR_EUTRAN\n");
$RTRV_NBR_EUTRAN_COMBINED .= "$RTRV_NBR_EUTRAN";
                                                              }	#end if log not match no data and cell greater than 2

                                               }		#end cell numbers 0-1, 9-10, 15-17




my (@array_each_line_RTRV_NBR_EUTRAN, $array_each_line_RTRV_NBR_EUTRAN);
@array_each_line_RTRV_NBR_EUTRAN = split(/\n/, $RTRV_NBR_EUTRAN_COMBINED);



foreach $array_each_line_RTRV_NBR_EUTRAN (@array_each_line_RTRV_NBR_EUTRAN) {
$array_each_line_RTRV_NBR_EUTRAN =~ s/^\s+//g;

if ($array_each_line_RTRV_NBR_EUTRAN =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_RTRV_NBR_EUTRAN);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_NBR_EUTRAN_TITLE{$_} = $num_title;
$num_title++;
                }
                                                      }


if ($array_each_line_RTRV_NBR_EUTRAN =~ m/^\d+/) {
@_ = split(/\s+/, $array_each_line_RTRV_NBR_EUTRAN);
my $cell_num_value = $hash_RTRV_NBR_EUTRAN_TITLE{CELL_NUM};
my $relation_idx_value = $hash_RTRV_NBR_EUTRAN_TITLE{RELATION_IDX};
my $status_value = $hash_RTRV_NBR_EUTRAN_TITLE{STATUS};
my $enb_id_value = $hash_RTRV_NBR_EUTRAN_TITLE{ENB_ID};
my $target_cell_id_value = $hash_RTRV_NBR_EUTRAN_TITLE{TARGET_CELL_ID};
my $phy_cell_id_value = $hash_RTRV_NBR_EUTRAN_TITLE{PHY_CELL_ID};
my $is_remove_allowed_value = $hash_RTRV_NBR_EUTRAN_TITLE{IS_REMOVE_ALLOWED};
my $is_hoallowed_value = $hash_RTRV_NBR_EUTRAN_TITLE{IS_HOALLOWED};
my $tac_value = $hash_RTRV_NBR_EUTRAN_TITLE{TAC};
my $ind_offset_value =  $hash_RTRV_NBR_EUTRAN_TITLE{'IND_OFFSET[dB]'};

$hash_RTRV_NBR_EUTRAN_CELL_NUM{$_[$cell_num_value]} = $_[$cell_num_value];		#CELL_NUM
$hash_RTRV_NBR_EUTRAN_REL_IDX{$_[$relation_idx_value]} = $_[$relation_idx_value];	#RELATION_IDX
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{STATUS} = $_[$status_value];	#STATUS
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{ENB_ID} = $_[$enb_id_value];	#ENB_ID
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{TARGET_CELL_ID} = $_[$target_cell_id_value];	#TARGET_CELL_ID
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{PHY_CELL_ID} = $_[$phy_cell_id_value];	#PHY_CELL_ID
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{IS_REMOVE_ALLOWED} = $_[$is_remove_allowed_value];	#IS_REMOVE_ALLOWED
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{IS_HOALLOWED} = $_[$is_hoallowed_value];	#IS_HOALLOWED
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{TAC} = $_[$tac_value];	#TAC
$hash_RTRV_NBR_EUTRAN{$_[$cell_num_value]}{$_[$relation_idx_value]}{IND_OFFSET} = $_[$ind_offset_value];	#IND_OFFSET
                                                 }
                                                                            }
##########################
#  END RTRV_NBR_EUTRAN   #
##########################

#########################
#  START RTRV_RRH_INVT  #
#########################
$ssh_lsm->print("cmd $enodeb_name RTRV-RRH-INVT");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_RRH_INVT = $ssh_lsm->waitfor(';');
$RTRV_RRH_INVT = "$RTRV_RRH_INVT$colon";
print ("$RTRV_RRH_INVT\n");
print (FILE_4G "$RTRV_RRH_INVT\n");


if (($RTRV_RRH_INVT =~ m/RESULT/) && ($RTRV_RRH_INVT =~ m/NOK/) && ($RTRV_RRH_INVT =~ m/REASON/)) {
$RTRV_RRH_INVT =~ s/\n+\s+REASON/ REASON/g;
$RTRV_RRH_INVT =~ s/\s+\:\s+/=/g;
$RTRV_RRH_INVT =~ s/\s+\=\s+/=/g;
$RTRV_RRH_INVT =~ s/\!//g;
#print ("$RTRV_RRH_INVT\n");
@_ = split(/\n+/, $RTRV_RRH_INVT);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$rrh_invt_nok = $_;
#print ("$rrh_invt_nok\n");
                         }
                }
                                                                                                  }


my (@array_each_line_RTRV_RRH_INVT, $array_each_line_RTRV_RRH_INVT);
@array_each_line_RTRV_RRH_INVT = split(/\n/, $RTRV_RRH_INVT);



foreach $array_each_line_RTRV_RRH_INVT (@array_each_line_RTRV_RRH_INVT) {
$array_each_line_RTRV_RRH_INVT =~ s/^\s+//g;

if ($array_each_line_RTRV_RRH_INVT =~ m/^CONN_BD_ID/) {
@_ = split(/\s+/, $array_each_line_RTRV_RRH_INVT);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_RRH_INVT_TITLE{$_} = $num_title;
$num_title++;
                }
                                                      }

if ($array_each_line_RTRV_RRH_INVT =~ m/^\d+/) {
@_ = split(/\s+/, $array_each_line_RTRV_RRH_INVT);
my $conn_bd_id_value = $hash_RTRV_RRH_INVT_TITLE{CONN_BD_ID};
my $conn_port_id_value = $hash_RTRV_RRH_INVT_TITLE{CONN_PORT_ID};
my $fw_version_value = $hash_RTRV_RRH_INVT_TITLE{FW_VERSION};



$hash_RTRV_RRH_INVT_CONN_BD_ID{$_[$conn_bd_id_value]} = $_[$conn_bd_id_value];		#CONN_BD_ID
$hash_RTRV_RRH_INVT_CONN_PORT_ID{$_[$conn_port_id_value]} = $_[$conn_port_id_value];	#CONN_PORT_ID
$hash_RTRV_RRH_INVT{$_[$conn_bd_id_value]}{$_[$conn_port_id_value]}{FW_VERSION} = $_[$fw_version_value];	#FW_VERSION

                                               }



                                                                        }
#########################
#   END RTRV_RRH_INVT   #
#########################


########################
#  START RTRV_RRH_CONF #
########################
$ssh_lsm->print("cmd $enodeb_name RTRV-RRH-CONF");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_RRH_CONF= $ssh_lsm->waitfor(';');
$RTRV_RRH_CONF= "$RTRV_RRH_CONF$colon";
print ("$RTRV_RRH_CONF\n");
print (FILE_4G "$RTRV_RRH_CONF\n");

$RTRV_RRH_CONF =~ s/\[0\.1dBm\]//g;

my (@array_each_line_RTRV_RRH_CONF, $array_each_line_RTRV_RRH_CONF);
@array_each_line_RTRV_RRH_CONF = split(/\n/, $RTRV_RRH_CONF);


foreach $array_each_line_RTRV_RRH_CONF (@array_each_line_RTRV_RRH_CONF) {
$array_each_line_RTRV_RRH_CONF =~ s/^\s+//g;
$array_each_line_RTRV_RRH_CONF =~ s/\s+\d+\:\d+\:\d+\.\d+//g;

if ($array_each_line_RTRV_RRH_CONF =~ m/^CONNECT_BOARD_ID/) {
@_ = split(/\s+/, $array_each_line_RTRV_RRH_CONF);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_RRH_CONF_TITLE{$_} = $num_title;
$num_title++;
                }
                                                            }

if ($array_each_line_RTRV_RRH_CONF =~ m/^\d+/) {
@_ = split(/\s+/, $array_each_line_RTRV_RRH_CONF);
my $conn_bd_id_value = $hash_RTRV_RRH_CONF_TITLE{CONNECT_BOARD_ID};
my $conn_port_id_value = $hash_RTRV_RRH_CONF_TITLE{CONNECT_PORT_ID};
my $status_value = $hash_RTRV_RRH_CONF_TITLE{STATUS};
my $cell_num_value = $hash_RTRV_RRH_CONF_TITLE{CELL_NUM};
my $POWER_BOOST_value = $hash_RTRV_RRH_CONF_TITLE{POWER_BOOST};
my $BOARD_TYPE_value = $hash_RTRV_RRH_CONF_TITLE{BOARD_TYPE};
my $DL_MAX_TX_POWER_value = $hash_RTRV_RRH_CONF_TITLE{DL_MAX_TX_POWER};

if ($_[$status_value] eq "EQUIP") {
my (@array_split_cell, $array_split_cell);
@array_split_cell = split(/\,/, $_[$cell_num_value]);

$hash_RTRV_RRH_CONF{$_[$conn_bd_id_value]}{$_[$conn_port_id_value]}{$_[$status_value]}{$_[$POWER_BOOST_value]}{$_[$BOARD_TYPE_value]}{FIRST} = $array_split_cell[0];
$hash_RTRV_RRH_CONF{$_[$conn_bd_id_value]}{$_[$conn_port_id_value]}{$_[$status_value]}{$_[$POWER_BOOST_value]}{$_[$BOARD_TYPE_value]}{SECOND} = $array_split_cell[1];
$hash_RTRV_RRH_CONF{$_[$conn_bd_id_value]}{$_[$conn_port_id_value]}{$_[$status_value]}{$_[$POWER_BOOST_value]}{$_[$BOARD_TYPE_value]}{THIRD} = $array_split_cell[2];

$hash_RTRV_RRH_CONF{$_[$conn_bd_id_value]}{$_[$conn_port_id_value]}{$_[$status_value]}{$_[$POWER_BOOST_value]}{$_[$BOARD_TYPE_value]}{DL_MAX_TX_POWER} = $_[$DL_MAX_TX_POWER_value];

                                  }

                                               }



                                                                        }
########################
#   END RTRV_RRH_CONF  #
########################


#######################
# START RTRV_GPS_INVT #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-GPS-INVT");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_GPS_INVT = $ssh_lsm->waitfor(';');
$RTRV_GPS_INVT = "$RTRV_GPS_INVT$colon";
print ("$RTRV_GPS_INVT\n");
print (FILE_4G "$RTRV_GPS_INVT\n");


if (($RTRV_GPS_INVT =~ m/RESULT/) && ($RTRV_GPS_INVT =~ m/NOK/) && ($RTRV_GPS_INVT =~ m/REASON/)) {
$RTRV_GPS_INVT =~ s/\n+\s+REASON/ REASON/g;
$RTRV_GPS_INVT =~ s/\s+\:\s+/=/g;
$RTRV_GPS_INVT =~ s/\s+\=\s+/=/g;
$RTRV_GPS_INVT =~ s/\!//g;
#print ("$RTRV_GPS_INVT\n");
@_ = split(/\n+/, $RTRV_GPS_INVT);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$gps_invt_nok = $_;
#print ("$gps_invt_nok\n");
                         }
                }
                                                                                                  }

my (@array_each_line_RTRV_GPS_INVT, $array_each_line_RTRV_GPS_INVT);
@array_each_line_RTRV_GPS_INVT = split(/\n/, $RTRV_GPS_INVT);



foreach $array_each_line_RTRV_GPS_INVT (@array_each_line_RTRV_GPS_INVT) {
$array_each_line_RTRV_GPS_INVT =~ s/^\s+//g;

if ($array_each_line_RTRV_GPS_INVT =~ m/^UNIT_ID/) {
@_ = split(/\s+/, $array_each_line_RTRV_GPS_INVT);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_GPS_INVT_TITLE{$_} = $num_title;
#print ("$_ $num_title\n");
$num_title++;

                }
                                                   }

if ($array_each_line_RTRV_GPS_INVT =~ m/\.\d+/) {
@_ = split(/\s+/, $array_each_line_RTRV_GPS_INVT);
my $unit_id_value = $hash_RTRV_GPS_INVT_TITLE{UNIT_ID};
$hash_RTRV_GPS_INVT_UNIT_ID{$_[$unit_id_value]} = $_[$unit_id_value];
my $fw_version_value = $hash_RTRV_GPS_INVT_TITLE{FW_VERSION};
$hash_RTRV_GPS_INVT{$_[$unit_id_value]}{FW_VERSION} = $_[$fw_version_value];
                                                }
                                                                       }
#######################
#  END RTRV_GPS_INVT  #
#######################



#######################
# START RTRV_CELL_STS #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-STS");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_STS = $ssh_lsm->waitfor(';');
$RTRV_CELL_STS = "$RTRV_CELL_STS$colon";
print ("$RTRV_CELL_STS\n");
print (FILE_4G "$RTRV_CELL_STS\n");

if (($RTRV_CELL_STS =~ m/RESULT/) && ($RTRV_CELL_STS =~ m/NOK/) && ($RTRV_CELL_STS =~ m/REASON/)) {
$RTRV_CELL_STS =~ s/\n+\s+REASON/ REASON/g;
$RTRV_CELL_STS =~ s/\s+\:\s+/=/g;
$RTRV_CELL_STS =~ s/\s+\=\s+/=/g;
$RTRV_CELL_STS =~ s/\!//g;
#print ("$RTRV_CELL_STS\n");
@_ = split(/\n+/, $RTRV_CELL_STS);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$cell_sts_nok = $_;
#print ("$cell_sts_nok\n");
                         }
                }
                                                                                                  }

my (@array_each_line_RTRV_CELL_STS, $array_each_line_RTRV_CELL_STS);
@array_each_line_RTRV_CELL_STS = split(/\n/, $RTRV_CELL_STS);

foreach $array_each_line_RTRV_CELL_STS (@array_each_line_RTRV_CELL_STS) {
$array_each_line_RTRV_CELL_STS =~ s/^\s+//g;
if ($array_each_line_RTRV_CELL_STS =~ m/^\d+/) {
@_ = split(/\s+/, $array_each_line_RTRV_CELL_STS);
$hash_RTRV_CELL_STS_CELL_NUM{$_[0]} = $_[0];
$hash_RTRV_CELL_STS{$_[0]}{OPERATIONAL_STATE} = $_[1];
$hash_RTRV_CELL_STS{$_[0]}{USAGE_STATE} = $_[2];
#print ("$_[0] $_[1] $_[2]\n");
                                               }

                                                                        }
#######################
#  END RTRV_CELL_STS  #
#######################


########################
#  START PRC FIRMWARE  #
########################
$ssh_lsm->print("cmd $enodeb_name RTRV-PRC-FW");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_PRC_FW = $ssh_lsm->waitfor(';');
$RTRV_PRC_FW = "$RTRV_PRC_FW$colon";
print ("$RTRV_PRC_FW\n");
print (FILE_4G "$RTRV_PRC_FW\n");

if (($RTRV_PRC_FW =~ m/RESULT/) && ($RTRV_PRC_FW =~ m/NOK/) && ($RTRV_PRC_FW =~ m/REASON/)) {
$RTRV_PRC_FW =~ s/\n+\s+REASON/ REASON/g;
$RTRV_PRC_FW =~ s/\s+\:\s+/=/g;
$RTRV_PRC_FW =~ s/\s+\=\s+/=/g;
$RTRV_PRC_FW =~ s/\!//g;
#print ("$RTRV_PRC_FW\n");
@_ = split(/\n+/, $RTRV_PRC_FW);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$firm_nok = $_;
#print ("$firm_nok\n");
                         }
                }
                                                                                            }

my (@array_each_line_PRC_FW, $array_each_line_PRC_FW);
@array_each_line_PRC_FW = split(/\n+/, $RTRV_PRC_FW);
foreach $array_each_line_PRC_FW (@array_each_line_PRC_FW) {
$array_each_line_PRC_FW =~ s/^\s+//g;
@_ = split(/\s+/, $array_each_line_PRC_FW);
if (($_[4] eq "BOOTER") || ($_[4] eq "KERNEL_A") || ($_[4] eq "KERNEL_B") || ($_[4] eq "RFS_RAW") || ($_[4] eq "RFS_A") || ($_[4] eq "RFS_B")) {
if ($RTRV_PRC_FW =~ m/PAT_VER/) {
$prc_fw_value = "$_[0],$_[1],$_[2],$_[3],$_[4],$_[5],$_[6],$_[8]";
                                }
else {
$prc_fw_value = "$_[0],$_[1],$_[2],$_[3],$_[4],$_[5],$_[6],$_[7]";
     }
#if ($_[2] eq "RUNNING") {
push (@array_prc_fw, $prc_fw_value);				#prc_fw array
#                        }
                                                                                                                                               }


if (($_[4] eq "POST") && ($_[0] eq "ECP")) {
if ($RTRV_PRC_FW =~ m/PAT_VER/) {
$prc_fw_value = "$_[0],$_[1],$_[2],$_[3],$_[4],$_[5],$_[6],$_[8]";
                                }
else {
$prc_fw_value = "$_[0],$_[1],$_[2],$_[3],$_[4],$_[5],$_[6],$_[7]";
     }
#if ($_[2] eq "RUNNING") {
#push (@array_prc_fw, $prc_fw_value);				#prc_fw array
#                        }
                                           }


if ($_[4] eq "EPLD") {
if (($_[5] =~ m/ctrl/) || ($_[5] =~ m/clock/)) {
$prc_fw_value = "$_[0],$_[1],$_[2],$_[3],$_[4],$_[5],$_[6],$_[7]";
#if ($_[2] eq "RUNNING") {
push (@array_prc_fw, $prc_fw_value);				#prc_fw array
#                        }
                                               }
                     }

                                                          }
########################
#   END PRC FIRMWARE   #
########################

#########################
# START RTRV_CELL_UECNT #
#########################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-UECNT");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_UECNT = $ssh_lsm->waitfor(';');
$RTRV_CELL_UECNT = "$RTRV_CELL_UECNT$colon";
print ("$RTRV_CELL_UECNT\n");
print (FILE_4G "$RTRV_CELL_UECNT\n");

my (@array_each_line_CELL_UECNT, $array_each_line_CELL_UECNT);
@array_each_line_CELL_UECNT = split(/\n+/, $RTRV_CELL_UECNT);
foreach $array_each_line_CELL_UECNT (@array_each_line_CELL_UECNT) {
$array_each_line_CELL_UECNT =~ s/^\s+//g;
if ($array_each_line_CELL_UECNT =~ m/^\d+/) {
@_ = split(/\s+/, $array_each_line_CELL_UECNT);
$_[0] =~ s/\s+//g;
$_[1] =~ s/\s+//g;
$hash_CELL_UECNT{$_[0]} = "$_[1]";
                                            }
                                                                  }

#########################
#  END RTRV_CELL_UECNT  #
#########################


########################
# START RTRV-EAIU-INVT #
########################
$ssh_lsm->print("cmd $enodeb_name RTRV-EAIU-INVT");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_EAIU_INVT = $ssh_lsm->waitfor(';');
$RTRV_EAIU_INVT = "$RTRV_EAIU_INVT$colon";
print ("$RTRV_EAIU_INVT\n");
print (FILE_4G "$RTRV_EAIU_INVT\n");

if (($RTRV_EAIU_INVT =~ m/RESULT/) && ($RTRV_EAIU_INVT =~ m/NOK/) && ($RTRV_EAIU_INVT =~ m/REASON/)) {
$RTRV_EAIU_INVT =~ s/\n+\s+REASON/ REASON/g;
$RTRV_EAIU_INVT =~ s/\s+\:\s+/=/g;
$RTRV_EAIU_INVT =~ s/\s+\=\s+/=/g;
$RTRV_EAIU_INVT =~ s/\!//g;
#print ("$RTRV_EAIU_INVT\n");
@_ = split(/\n+/, $RTRV_EAIU_INVT);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$eaiu_4g_invt_nok = $_;
#print ("$eaiu_4g_invt_nok\n");
                         }
                }
                                                                                                    }

my (@array_each_line_RTRV_EAIU_INVT, $array_each_line_RTRV_EAIU_INVT);
@array_each_line_RTRV_EAIU_INVT = split(/\n/, $RTRV_EAIU_INVT);



foreach $array_each_line_RTRV_EAIU_INVT (@array_each_line_RTRV_EAIU_INVT) {
$array_each_line_RTRV_EAIU_INVT =~ s/^\s+//g;

if ($array_each_line_RTRV_EAIU_INVT =~ m/^UNIT_ID/) {
@_ = split(/\s+/, $array_each_line_RTRV_EAIU_INVT);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_EAIU_INVT_TITLE{$_} = $num_title;
#print ("$_ $num_title\n");
$num_title++;

                }
                                                    }

if ($array_each_line_RTRV_EAIU_INVT =~ m/\.\d+/) {
@_ = split(/\s+/, $array_each_line_RTRV_EAIU_INVT);
my $unit_id_value = $hash_RTRV_EAIU_INVT_TITLE{UNIT_ID};
my $fw_version_value = $hash_RTRV_EAIU_INVT_TITLE{FW_VERSION};
$hash_RTRV_EAIU_INVT{$_[$unit_id_value]}{FW_VERSION} = $_[$fw_version_value];
                                                 }
                                                                          }
########################
#  END RTRV-EAIU-INVT  #
########################

#########################
#  START RTRV-EUTRA-FA  #
#########################
$ssh_lsm->print("cmd $enodeb_name RTRV-EUTRA-FA");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_EUTRA_FA = $ssh_lsm->waitfor(';');
$RTRV_EUTRA_FA = "$RTRV_EUTRA_FA$colon";
print ("$RTRV_EUTRA_FA\n");
print (FILE_4G "$RTRV_EUTRA_FA\n");



my (@array_each_line_RTRV_EUTRA_FA, $array_each_line_RTRV_EUTRA_FA);
@array_each_line_RTRV_EUTRA_FA = split(/\n/, $RTRV_EUTRA_FA);


foreach $array_each_line_RTRV_EUTRA_FA (@array_each_line_RTRV_EUTRA_FA) {
$array_each_line_RTRV_EUTRA_FA =~ s/^\s+//g;

if ($array_each_line_RTRV_EUTRA_FA =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_RTRV_EUTRA_FA);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_EUTRA_FA_TITLE{$_} = $num_title;
$num_title++;
                }
                                                    }

if ($array_each_line_RTRV_EUTRA_FA =~ m/^\d+/) {
@_ = split(/\s+/, $array_each_line_RTRV_EUTRA_FA);
my $CELL_NUM_value = $hash_RTRV_EUTRA_FA_TITLE{CELL_NUM};
my $FA_INDEX_value = $hash_RTRV_EUTRA_FA_TITLE{FA_INDEX};
my $STATUS_value = $hash_RTRV_EUTRA_FA_TITLE{STATUS};
my $EARFCN_UL_value = $hash_RTRV_EUTRA_FA_TITLE{EARFCN_UL};
my $EARFCN_DL_value = $hash_RTRV_EUTRA_FA_TITLE{EARFCN_DL};



if ($_[$STATUS_value] eq "EQUIP") {
if (($_[$FA_INDEX_value] >=0) && ($_[$FA_INDEX_value] <=3)) {
$hash_RTRV_EUTRA_FA{$_[$CELL_NUM_value]}{$_[$FA_INDEX_value]}{$_[$STATUS_value]}{EARFCN_UL} = "$_[$EARFCN_UL_value]";
$hash_RTRV_EUTRA_FA{$_[$CELL_NUM_value]}{$_[$FA_INDEX_value]}{$_[$STATUS_value]}{EARFCN_DL} = "$_[$EARFCN_DL_value]";
                                                            }
if ($_[$FA_INDEX_value] eq "5") {
$hash_RTRV_EUTRA_FA{$_[$CELL_NUM_value]}{$_[$FA_INDEX_value]}{$_[$STATUS_value]}{EARFCN_UL} = "$_[$EARFCN_UL_value]";
$hash_RTRV_EUTRA_FA{$_[$CELL_NUM_value]}{$_[$FA_INDEX_value]}{$_[$STATUS_value]}{EARFCN_DL} = "$_[$EARFCN_DL_value]";
                                }
                                  }

                                               }



                                                                        }
#########################
#   END RTRV-EUTRA-FA   #
#########################


##########################
# START RTRV-C1XRTT-PREG #
##########################
$ssh_lsm->print("cmd $enodeb_name RTRV-C1XRTT-PREG");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_C1XRTT_PREG = $ssh_lsm->waitfor(';');
$RTRV_C1XRTT_PREG = "$RTRV_C1XRTT_PREG$colon";
print ("$RTRV_C1XRTT_PREG\n");
print (FILE_4G "$RTRV_C1XRTT_PREG\n");


my (@array_each_line_C1XRTT_PREG, $array_each_line_C1XRTT_PREG);
@array_each_line_C1XRTT_PREG = split(/\n/,$RTRV_C1XRTT_PREG);




foreach $array_each_line_C1XRTT_PREG (@array_each_line_C1XRTT_PREG) {	#start foreach line of log
$array_each_line_C1XRTT_PREG =~ s/^\s+//g;
if ($array_each_line_C1XRTT_PREG =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_C1XRTT_PREG);
my $num_title = 0;
foreach $_ (@_) {
$hash_C1XRTT_PREG_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                  }

if ($array_each_line_C1XRTT_PREG =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_C1XRTT_PREG);
my $CELL_NUM_value = $hash_C1XRTT_PREG_TITLE{CELL_NUM};
my $CSFB_PRE_REG_USAGE_value = $hash_C1XRTT_PREG_TITLE{CSFB_PRE_REG_USAGE};
my $SID_value = $hash_C1XRTT_PREG_TITLE{SID};
my $NID_value = $hash_C1XRTT_PREG_TITLE{NID};

my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;
my $CSFB_PRE_REG_USAGE = "$_[$CSFB_PRE_REG_USAGE_value]";
$CSFB_PRE_REG_USAGE =~ s/\s+//g;

my $SID = "$_[$SID_value]";
$SID =~ s/\s+//g;

my $NID = "$_[$NID_value]";
$NID =~ s/\s+//g;

$hash_C1XRTT_PREG{$CELL_NUM}{CSFB_PRE_REG_USAGE} = "$CSFB_PRE_REG_USAGE";
$hash_C1XRTT_PREG{$CELL_NUM}{SID} = "$SID";
$hash_C1XRTT_PREG{$CELL_NUM}{NID} = "$NID";


                                             }



                                                                    }	#end foreach line of log
##########################
#  END RTRV-C1XRTT-PREG  #
##########################



################################
# START RTRV-C1XRTT-PREGSECTOR #
################################
$ssh_lsm->print("cmd $enodeb_name RTRV-C1XRTT-PREGSECTOR");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_C1XRTT_PREGSECTOR = $ssh_lsm->waitfor(';');
$RTRV_C1XRTT_PREGSECTOR = "$RTRV_C1XRTT_PREGSECTOR$colon";
print ("$RTRV_C1XRTT_PREGSECTOR\n");
print (FILE_4G "$RTRV_C1XRTT_PREGSECTOR\n");


my (@array_each_line_C1XRTT_PREGSECTOR, $array_each_line_C1XRTT_PREGSECTOR);
@array_each_line_C1XRTT_PREGSECTOR = split(/\n/,$RTRV_C1XRTT_PREGSECTOR);




foreach $array_each_line_C1XRTT_PREGSECTOR (@array_each_line_C1XRTT_PREGSECTOR) {	#start foreach line of log
$array_each_line_C1XRTT_PREGSECTOR =~ s/^\s+//g;
if ($array_each_line_C1XRTT_PREGSECTOR =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_C1XRTT_PREGSECTOR);
my $num_title = 0;
foreach $_ (@_) {
$hash_C1XRTT_PREGSECTOR_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                        }

if ($array_each_line_C1XRTT_PREGSECTOR =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_C1XRTT_PREGSECTOR);
my $CELL_NUM_value = $hash_C1XRTT_PREGSECTOR_TITLE{CELL_NUM};
my $MARKET_ID_value = $hash_C1XRTT_PREGSECTOR_TITLE{MARKET_ID};
my $SWITCH_NUM_value = $hash_C1XRTT_PREGSECTOR_TITLE{SWITCH_NUM};
my ($CELL_ID_value);
if ($pkg eq "4.0.0") {
$CELL_ID_value = $hash_C1XRTT_PREGSECTOR_TITLE{TARGET_CELL_ID};
                     }
else {
$CELL_ID_value = $hash_C1XRTT_PREGSECTOR_TITLE{CELL_ID};
     }
my $SECTOR_NUM_value = $hash_C1XRTT_PREGSECTOR_TITLE{SECTOR_NUM};

my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $MARKET_ID = "$_[$MARKET_ID_value]";
$MARKET_ID =~ s/\s+//g;

my $SWITCH_NUM = "$_[$SWITCH_NUM_value]";
$SWITCH_NUM =~ s/\s+//g;

my $CELL_ID = "$_[$CELL_ID_value]";
$CELL_ID =~ s/\s+//g;

my $SECTOR_NUM = "$_[$SECTOR_NUM_value]";
$SECTOR_NUM =~ s/\s+//g;

$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{MARKET_ID} = "$MARKET_ID";
$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{SWITCH_NUM} = "$SWITCH_NUM";
$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{CELL_ID} = "$CELL_ID";
$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{SECTOR_NUM} = "$SECTOR_NUM";
                                             }



                                                                                   }	#end foreach line of log
################################
#  END RTRV-C1XRTT-PREGSECTOR  #
################################


###########################
# START RTRV-C1XRTT-MOBIL #
###########################
$ssh_lsm->print("cmd $enodeb_name RTRV-C1XRTT-MOBIL");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_C1XRTT_MOBIL = $ssh_lsm->waitfor(';');
$RTRV_C1XRTT_MOBIL = "$RTRV_C1XRTT_MOBIL$colon";
print ("$RTRV_C1XRTT_MOBIL\n");
print (FILE_4G "$RTRV_C1XRTT_MOBIL\n");


my (@array_each_line_C1XRTT_MOBIL, $array_each_line_C1XRTT_MOBIL);
@array_each_line_C1XRTT_MOBIL = split(/\n/,$RTRV_C1XRTT_MOBIL);




foreach $array_each_line_C1XRTT_MOBIL (@array_each_line_C1XRTT_MOBIL) {	#start foreach line of log
$array_each_line_C1XRTT_MOBIL =~ s/^\s+//g;
if ($array_each_line_C1XRTT_MOBIL =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_C1XRTT_MOBIL);
my $num_title = 0;
foreach $_ (@_) {
$hash_C1XRTT_MOBIL_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                        }

if ($array_each_line_C1XRTT_MOBIL =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_C1XRTT_MOBIL);
my $CELL_NUM_value = $hash_C1XRTT_MOBIL_TITLE{CELL_NUM};
my $S_ID_value = $hash_C1XRTT_MOBIL_TITLE{S_ID};
my $N_ID_value = $hash_C1XRTT_MOBIL_TITLE{N_ID};
my $REG_ZONE_value = $hash_C1XRTT_MOBIL_TITLE{REG_ZONE};
my $LTM_OFF_value = $hash_C1XRTT_MOBIL_TITLE{LTM_OFF};
my $DAYLT_value = $hash_C1XRTT_MOBIL_TITLE{DAYLT};

my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $S_ID = "$_[$S_ID_value]";
$S_ID =~ s/\s+//g;

my $N_ID = "$_[$N_ID_value]";
$N_ID =~ s/\s+//g;

my $REG_ZONE = "$_[$REG_ZONE_value]";
$REG_ZONE =~ s/\s+//g;

my $LTM_OFF = "$_[$LTM_OFF_value]";
$LTM_OFF =~ s/\s+//g;

my $DAYLT = "$_[$DAYLT_value]";
$DAYLT =~ s/\s+//g;

$hash_C1XRTT_MOBIL{$CELL_NUM}{S_ID} = "$S_ID";
$hash_C1XRTT_MOBIL{$CELL_NUM}{N_ID} = "$N_ID";
$hash_C1XRTT_MOBIL{$CELL_NUM}{REG_ZONE} = "$REG_ZONE";
$hash_C1XRTT_MOBIL{$CELL_NUM}{LTM_OFF} = "$LTM_OFF";
$hash_C1XRTT_MOBIL{$CELL_NUM}{DAYLT} = "$DAYLT";
                                             }



                                                                     }	#end foreach line of log
###########################
#  END RTRV-C1XRTT-MOBIL  #
###########################



##########################
#  START RTRV-NBR-C1XRTT #
##########################
$ssh_lsm->print("cmd $enodeb_name RTRV-NBR-C1XRTT");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_NBR_C1XRTT = $ssh_lsm->waitfor(';');
$RTRV_NBR_C1XRTT = "$RTRV_NBR_C1XRTT$colon";
print ("$RTRV_NBR_C1XRTT\n");
print (FILE_4G "$RTRV_NBR_C1XRTT\n");


my (@array_each_line_NBR_C1XRTT, $array_each_line_NBR_C1XRTT);
@array_each_line_NBR_C1XRTT = split(/\n/,$RTRV_NBR_C1XRTT);




foreach $array_each_line_NBR_C1XRTT (@array_each_line_NBR_C1XRTT) {	#start foreach line of log
$array_each_line_NBR_C1XRTT =~ s/^\s+//g;
if ($array_each_line_NBR_C1XRTT =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_NBR_C1XRTT);
my $num_title = 0;
foreach $_ (@_) {
$hash_NBR_C1XRTT_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                        }

if ($array_each_line_NBR_C1XRTT =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_NBR_C1XRTT);
my $CELL_NUM_value = $hash_NBR_C1XRTT_TITLE{CELL_NUM};
my $RELATION_IDX_value = $hash_NBR_C1XRTT_TITLE{RELATION_IDX};
my $STATUS_value = $hash_NBR_C1XRTT_TITLE{STATUS};
my $MARKET_ID_value = $hash_NBR_C1XRTT_TITLE{MARKET_ID};
my $SWITCH_NUM_value = $hash_NBR_C1XRTT_TITLE{SWITCH_NUM};

my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $RELATION_IDX = "$_[$RELATION_IDX_value]";
$RELATION_IDX =~ s/\s+//g;

my $STATUS = "$_[$STATUS_value]";
$STATUS =~ s/\s+//g;

my $MARKET_ID = "$_[$MARKET_ID_value]";
$MARKET_ID =~ s/\s+//g;

my $SWITCH_NUM = "$_[$SWITCH_NUM_value]";
$SWITCH_NUM =~ s/\s+//g;

$hash_NBR_C1XRTT{$CELL_NUM}{$RELATION_IDX}{STATUS} = "$STATUS";
$hash_NBR_C1XRTT{$CELL_NUM}{$RELATION_IDX}{MARKET_ID} = "$MARKET_ID";
$hash_NBR_C1XRTT{$CELL_NUM}{$RELATION_IDX}{SWITCH_NUM} = "$SWITCH_NUM";

                                             }



                                                                     }	#end foreach line of log
##########################
#   END RTRV-NBR-C1XRTT  #
##########################



#######################
# START RTRV-SYS-CONF #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-SYS-CONF");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_SYS_CONF = $ssh_lsm->waitfor(';');
$RTRV_SYS_CONF = "$RTRV_SYS_CONF$colon";
print ("$RTRV_SYS_CONF\n");
print (FILE_4G "$RTRV_SYS_CONF\n");


my (@array_each_line_SYS_CONF, $array_each_line_SYS_CONF);
@array_each_line_SYS_CONF = split(/\n/,$RTRV_SYS_CONF);

foreach $array_each_line_SYS_CONF (@array_each_line_SYS_CONF) {	#start foreach line of log
$array_each_line_SYS_CONF =~ s/^\s+//g;
if ($array_each_line_SYS_CONF =~ m/^SYS_ID/) {
@_ = split(/\s+/, $array_each_line_SYS_CONF);
my $num_title = 0;
foreach $_ (@_) {
$hash_SYS_CONF_TITLE{$_} = "$num_title";
$num_title++;
                }
                                             }

if ($array_each_line_SYS_CONF =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_SYS_CONF);
my $SYS_TYPE_value = $hash_SYS_CONF_TITLE{SYS_TYPE};

my $SYS_TYPE = "$_[$SYS_TYPE_value]";

if ($SYS_TYPE =~ m/OUTDOOR/) {
$SYS_TYPE = "OUTDOOR";
                             }

if ($SYS_TYPE =~ m/INDOOR/) {
$SYS_TYPE = "INDOOR";
                            }

$hash_SYS_CONF{$enodeb_name} = "$SYS_TYPE";
                                          }



                                                               }	#end foreach line of log
#######################
#  END RTRV-SYS-CONF  #
#######################


######################
# START RTRV-SON-ANR #
######################
$ssh_lsm->print("cmd $enodeb_name RTRV-SON-ANR");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_SON_ANR = $ssh_lsm->waitfor(';');
$RTRV_SON_ANR = "$RTRV_SON_ANR$colon";
print ("$RTRV_SON_ANR\n");
print (FILE_4G "$RTRV_SON_ANR\n");

my (@array_each_line_SON_ANR, $array_each_line_SON_ANR);
@array_each_line_SON_ANR = split(/\n/,$RTRV_SON_ANR);




foreach $array_each_line_SON_ANR (@array_each_line_SON_ANR) {	#start foreach line of log
$array_each_line_SON_ANR =~ s/^\s+//g;
if ($array_each_line_SON_ANR =~ m/^MAX_NRTSIZE/) {
@_ = split(/\s+/, $array_each_line_SON_ANR);
my $num_title = 0;
foreach $_ (@_) {
$hash_SON_ANR_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                 }

if ($array_each_line_SON_ANR =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_SON_ANR);
my $MAX_NRTSIZE_value = $hash_SON_ANR_TITLE{MAX_NRTSIZE};
my $NR_DEL_FLAG_value = $hash_SON_ANR_TITLE{NR_DEL_FLAG};

my $MAX_NRTSIZE = "$_[$MAX_NRTSIZE_value]";
$MAX_NRTSIZE =~ s/\s+//g;

my $NR_DEL_FLAG = "$_[$NR_DEL_FLAG_value]";
$NR_DEL_FLAG =~ s/\s+//g;

$hash_SON_ANR{MAX_NRTSIZE} = "$MAX_NRTSIZE";
$hash_SON_ANR{NR_DEL_FLAG} = "$NR_DEL_FLAG";



                                             }



                                                            }	#end foreach line of log
######################
#  END RTRV-SON-ANR  #
######################

#########################
# START RTRV-SONFN-CELL #
#########################
$ssh_lsm->print("cmd $enodeb_name RTRV-SONFN-CELL");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_SONFN_CELL = $ssh_lsm->waitfor(';');
$RTRV_SONFN_CELL = "$RTRV_SONFN_CELL$colon";
print ("$RTRV_SONFN_CELL\n");
print (FILE_4G "$RTRV_SONFN_CELL\n");


my (@array_each_line_SONFN_CELL, $array_each_line_SONFN_CELL);
@array_each_line_SONFN_CELL = split(/\n/,$RTRV_SONFN_CELL);




foreach $array_each_line_SONFN_CELL (@array_each_line_SONFN_CELL) {	#start foreach line of log
$array_each_line_SONFN_CELL =~ s/^\s+//g;
if ($array_each_line_SONFN_CELL =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_SONFN_CELL);
my $num_title = 0;
foreach $_ (@_) {
$hash_SONFN_CELL_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                        }

if ($array_each_line_SONFN_CELL =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_SONFN_CELL);
my $CELL_NUM_value = $hash_SONFN_CELL_TITLE{CELL_NUM};
my $ANR_ENABLE_value = $hash_SONFN_CELL_TITLE{ANR_ENABLE};

my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $ANR_ENABLE = "$_[$ANR_ENABLE_value]";
$ANR_ENABLE =~ s/\s+//g;

if ($hash_RTRV_CELL_CONF{$CELL_NUM}{EQUIP}) {
$hash_SONFN_CELL{$CELL_NUM}{ANR_ENABLE} = "$ANR_ENABLE";
                                            }


                                             }



                                                                     }	#end foreach line of log
#########################
#  END RTRV-SONFN-CELL  #
#########################

#######################
# START RTRV-POS-CONF #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-POS-CONF");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_POS_CONF = $ssh_lsm->waitfor(';');
$RTRV_POS_CONF = "$RTRV_POS_CONF$colon";
print ("$RTRV_POS_CONF\n");
print (FILE_4G "$RTRV_POS_CONF\n");
#######################
#  END RTRV-POS-CONF  #
#######################

#######################
# START RTRV-NBR-HRPD #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-NBR-HRPD");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_NBR_HRPD = $ssh_lsm->waitfor(';');
$RTRV_NBR_HRPD = "$RTRV_NBR_HRPD$colon";
print ("$RTRV_NBR_HRPD\n");
print (FILE_4G "$RTRV_NBR_HRPD\n");


my (@array_each_line_NBR_HRPD, $array_each_line_NBR_HRPD);
@array_each_line_NBR_HRPD = split(/\n/,$RTRV_NBR_HRPD);


if (($RTRV_NBR_HRPD =~ m/RESULT/) && ($RTRV_NBR_HRPD =~ m/NOK/) && ($RTRV_NBR_HRPD =~ m/REASON/)) {
$RTRV_NBR_HRPD =~ s/\n+\s+REASON/ REASON/g;
$RTRV_NBR_HRPD =~ s/\s+\:\s+/=/g;
$RTRV_NBR_HRPD =~ s/\s+\=\s+/=/g;
$RTRV_NBR_HRPD =~ s/\!//g;
#print ("$RTRV_NBR_HRPD\n");
@_ = split(/\n+/, $RTRV_NBR_HRPD);
foreach $_ (@_) {
if ($_ =~ m/^\s+RESULT/) {
$_ =~ s/^\s+RESULT/RESULT/g;
$nbr_hrpd_nok = $_;
#print ("$nbr_hrpd_nok\n");
                         }
                }
                                                                                                 }



foreach $array_each_line_NBR_HRPD (@array_each_line_NBR_HRPD) {	#start foreach line of log
$array_each_line_NBR_HRPD =~ s/^\s+//g;
if ($array_each_line_NBR_HRPD =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_NBR_HRPD);
my $num_title = 0;
foreach $_ (@_) {
$hash_NBR_HRPD_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                        }

if ($array_each_line_NBR_HRPD =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_NBR_HRPD);
my $CELL_NUM_value = $hash_NBR_HRPD_TITLE{CELL_NUM};
my $RELATION_IDX_value = $hash_NBR_HRPD_TITLE{RELATION_IDX};
my $STATUS_value = $hash_NBR_HRPD_TITLE{STATUS};
my $BAND_CLASS_value = $hash_NBR_HRPD_TITLE{BAND_CLASS};
my $ARFCN_value = $hash_NBR_HRPD_TITLE{ARFCN};


my $PN_OFFSET_value = $hash_NBR_HRPD_TITLE{PN_OFFSET};
my $IS_REMOVE_ALLOWED_value = $hash_NBR_HRPD_TITLE{IS_REMOVE_ALLOWED};
my $IS_HOALLOWED_value = $hash_NBR_HRPD_TITLE{IS_HOALLOWED};

my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $RELATION_IDX = "$_[$RELATION_IDX_value]";
$RELATION_IDX =~ s/\s+//g;

my $STATUS = "$_[$STATUS_value]";
$STATUS =~ s/\s+//g;

my $BAND_CLASS = "$_[$BAND_CLASS_value]";
$BAND_CLASS =~ s/\s+//g;

my $ARFCN = "$_[$ARFCN_value]";
$ARFCN =~ s/\s+//g;


my $PN_OFFSET = "$_[$PN_OFFSET_value]";
$PN_OFFSET =~ s/\s+//g;

my $IS_REMOVE_ALLOWED = "$_[$IS_REMOVE_ALLOWED_value]";
$IS_REMOVE_ALLOWED =~ s/\s+//g;

my $IS_HOALLOWED = "$_[$IS_HOALLOWED_value]";
$IS_HOALLOWED =~ s/\s+//g;






$hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{STATUS} = "$STATUS";
$hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{BAND_CLASS} = "$BAND_CLASS";
$hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{ARFCN} = "$ARFCN";
$hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{PN_OFFSET} = "$PN_OFFSET";
$hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{IS_REMOVE_ALLOWED} = "$IS_REMOVE_ALLOWED";
$hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{IS_HOALLOWED} = "$IS_HOALLOWED";

                                             }



                                                              }	#end foreach line of log
#######################
#  END RTRV-NBR-HRPD  #
#######################


#######################
# START RTRV-CELL-ACS #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-ACS");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_ACS = $ssh_lsm->waitfor(';');
$RTRV_CELL_ACS = "$RTRV_CELL_ACS$colon";
print ("$RTRV_CELL_ACS\n");
print (FILE_4G "$RTRV_CELL_ACS\n");

my (@array_each_line_CELL_ACS, $array_each_line_CELL_ACS);
@array_each_line_CELL_ACS = split(/\n/,$RTRV_CELL_ACS);




foreach $array_each_line_CELL_ACS (@array_each_line_CELL_ACS) {	#start foreach line of log
$array_each_line_CELL_ACS =~ s/^\s+//g;
if ($array_each_line_CELL_ACS =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_CELL_ACS);
my $num_title = 0;
foreach $_ (@_) {
$hash_CELL_ACS_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                        }

if ($array_each_line_CELL_ACS =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_CELL_ACS);
my $CELL_NUM_value = $hash_CELL_ACS_TITLE{CELL_NUM};
my $CELL_BARRED_value = $hash_CELL_ACS_TITLE{CELL_BARRED};
my $INTRA_FREQ_CELL_RESELECT_value = $hash_CELL_ACS_TITLE{INTRA_FREQ_CELL_RESELECT};
my $BARRING_CTR_USAGE_value = $hash_CELL_ACS_TITLE{BARRING_CTR_USAGE};
my $HANDOVER_BARRING_STATUS_value = $hash_CELL_ACS_TITLE{HANDOVER_BARRING_STATUS};
my $CELL_RESERVED_OP_USE_value = $hash_CELL_ACS_TITLE{CELL_RESERVED_OP_USE};


my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $CELL_BARRED = "$_[$CELL_BARRED_value]";
$CELL_BARRED =~ s/\s+//g;

my $INTRA_FREQ_CELL_RESELECT = "$_[$INTRA_FREQ_CELL_RESELECT_value]";
$INTRA_FREQ_CELL_RESELECT =~ s/\s+//g;

my $BARRING_CTR_USAGE = "$_[$BARRING_CTR_USAGE_value]";
$BARRING_CTR_USAGE =~ s/\s+//g;

my $HANDOVER_BARRING_STATUS = "$_[$HANDOVER_BARRING_STATUS_value]";
$HANDOVER_BARRING_STATUS =~ s/\s+//g;

my $CELL_RESERVED_OP_USE = "$_[$CELL_RESERVED_OP_USE_value]";
$CELL_RESERVED_OP_USE =~ s/\s+//g;


if ($CELL_RESERVED_OP_USE =~ m/\,/) {
$CELL_RESERVED_OP_USE_INFO = $CELL_RESERVED_OP_USE;
$CELL_RESERVED_OP_USE_INFO =~ s/\,.*$//g;
$hash_4g_cell_reserved{$CELL_NUM} = $CELL_RESERVED_OP_USE_INFO;
                                    }



$hash_CELL_ACS{$CELL_NUM}{CELL_BARRED} = "$CELL_BARRED";
$hash_CELL_ACS{$CELL_NUM}{INTRA_FREQ_CELL_RESELECT} = "$INTRA_FREQ_CELL_RESELECT";
$hash_CELL_ACS{$CELL_NUM}{BARRING_CTR_USAGE} = "$BARRING_CTR_USAGE";
$hash_CELL_ACS{$CELL_NUM}{HANDOVER_BARRING_STATUS} = "$HANDOVER_BARRING_STATUS";
                                             }



                                                              }	#end foreach line of log
#######################
#  END RTRV-CELL-ACS  #
#######################

########################
# START RTRV-CELL-DATA #
########################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-DATA");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_DATA = $ssh_lsm->waitfor(';');
$RTRV_CELL_DATA = "$RTRV_CELL_DATA$colon";
print ("$RTRV_CELL_DATA\n");
print (FILE_4G "$RTRV_CELL_DATA\n");



my (@array_each_line_CELL_DATA, $array_each_line_CELL_DATA);
@array_each_line_CELL_DATA = split(/\n/,$RTRV_CELL_DATA);




foreach $array_each_line_CELL_DATA (@array_each_line_CELL_DATA) {	#start foreach line of log
$array_each_line_CELL_DATA =~ s/^\s+//g;
if ($array_each_line_CELL_DATA =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_CELL_DATA);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_CELL_DATA_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                }

if ($array_each_line_CELL_DATA =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_CELL_DATA);
my $CELL_NUM_value = $hash_RTRV_CELL_DATA_TITLE{CELL_NUM};
my $CELL_TXPATH_TYPE_value = $hash_RTRV_CELL_DATA_TITLE{CELL_TXPATH_TYPE};




my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $CELL_TXPATH_TYPE = "$_[$CELL_TXPATH_TYPE_value]";
$CELL_TXPATH_TYPE =~ s/\s+//g;









$hash_RTRV_CELL_DATA{$CELL_NUM} = "$CELL_TXPATH_TYPE";

                                         }



                                                                }	#end foreach line of log
########################
#  END RTRV-CELL-DATA  #
########################


#######################
# START RTRV–CELL–CAC #
#######################
$ssh_lsm->print("cmd $enodeb_name RTRV-CELL-CAC");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_CELL_CAC = $ssh_lsm->waitfor(';');
$RTRV_CELL_CAC = "$RTRV_CELL_CAC$colon";
print ("$RTRV_CELL_CAC\n");
print (FILE_4G "$RTRV_CELL_CAC\n");


my (@array_each_line_CELL_CAC, $array_each_line_CELL_CAC);
@array_each_line_CELL_CAC = split(/\n/,$RTRV_CELL_CAC);




foreach $array_each_line_CELL_CAC (@array_each_line_CELL_CAC) {	#start foreach line of log
$array_each_line_CELL_CAC =~ s/^\s+//g;
if ($array_each_line_CELL_CAC =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_CELL_CAC);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_CELL_CAC_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                }

if ($array_each_line_CELL_CAC =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_CELL_CAC);
my $CELL_NUM_value = $hash_RTRV_CELL_CAC_TITLE{CELL_NUM};
my $MAX_CALL_COUNT_value = $hash_RTRV_CELL_CAC_TITLE{MAX_CALL_COUNT};
my $MAX_DRB_COUNT_value = $hash_RTRV_CELL_CAC_TITLE{MAX_DRB_COUNT};



my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $MAX_CALL_COUNT = "$_[$MAX_CALL_COUNT_value]";
$MAX_CALL_COUNT =~ s/\s+//g;

my $MAX_DRB_COUNT = "$_[$MAX_DRB_COUNT_value]";
$MAX_DRB_COUNT =~ s/\s+//g;







$hash_RTRV_CELL_CAC{$CELL_NUM}{MAX_CALL_COUNT} = "$MAX_CALL_COUNT";
$hash_RTRV_CELL_CAC{$CELL_NUM}{MAX_DRB_COUNT} = "$MAX_DRB_COUNT";


                                         }



                                                                }	#end foreach line of log

#######################
#  END RTRV–CELL–CAC  #
#######################


#########################
# START RTRV–PDSCH-IDLE #
#########################
$ssh_lsm->print("cmd $enodeb_name RTRV-PDSCH-IDLE");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_PDSCH_IDLE = $ssh_lsm->waitfor(';');
$RTRV_PDSCH_IDLE = "$RTRV_PDSCH_IDLE$colon";
print ("$RTRV_PDSCH_IDLE\n");
print (FILE_4G "$RTRV_PDSCH_IDLE\n");

my (@array_each_line_PDSCH_IDLE, $array_each_line_PDSCH_IDLE);
@array_each_line_PDSCH_IDLE = split(/\n/,$RTRV_PDSCH_IDLE);




foreach $array_each_line_PDSCH_IDLE (@array_each_line_PDSCH_IDLE) {	#start foreach line of log
$array_each_line_PDSCH_IDLE =~ s/^\s+//g;
if ($array_each_line_PDSCH_IDLE =~ m/^CELL_NUM/) {
@_ = split(/\s+/, $array_each_line_PDSCH_IDLE);
my $num_title = 0;
foreach $_ (@_) {
$hash_RTRV_PDSCH_IDLE_TITLE{$_} = "$num_title";
$num_title++;
                }
                                                }

if ($array_each_line_PDSCH_IDLE =~ m/^\d+/) { 
@_ = split(/\s+/, $array_each_line_PDSCH_IDLE);
my $CELL_NUM_value = $hash_RTRV_PDSCH_IDLE_TITLE{CELL_NUM};
my $DL_POWER_OPTION_value = $hash_RTRV_PDSCH_IDLE_TITLE{DL_POWER_OPTION};
my $FORCED_MODE_value = $hash_RTRV_PDSCH_IDLE_TITLE{FORCED_MODE};


my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;

my $DL_POWER_OPTION = "$_[$DL_POWER_OPTION_value]";
$DL_POWER_OPTION =~ s/\s+//g;

my $FORCED_MODE = "$_[$FORCED_MODE_value]";
$FORCED_MODE =~ s/\s+//g;

if ($hash_CELL_NUMS{$CELL_NUM}) {
$hash_PDSCH_IDLE{$CELL_NUM}{DL_POWER_OPTION} = "$DL_POWER_OPTION";
$hash_PDSCH_IDLE{$CELL_NUM}{FORCED_MODE} = "$FORCED_MODE";
                                }

                                         }



                                                                }	#end foreach line of log

#########################
#  END RTRV–PDSCH-IDLE  #
#########################


######################
# START RTRV-HRPD-FREQ #
######################
$ssh_lsm->print("cmd $enodeb_name RTRV-HRPD-FREQ");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_HRPD_FREQ = $ssh_lsm->waitfor(';');
$RTRV_HRPD_FREQ = "$RTRV_HRPD_FREQ $colon";
print ("$RTRV_HRPD_FREQ\n");
print (FILE_4G "RTRV_HRPD_FREQ\n");
print (FILE_4G "$RTRV_HRPD_FREQ\n");

######################
# START RTRV-RLC-INF #
######################
$ssh_lsm->print("cmd $enodeb_name RTRV-RLC-INF");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_RLC_INF = $ssh_lsm->waitfor(';');
$RTRV_RLC_INF = "$RTRV_RLC_INF $colon";
print ("$RTRV_RLC_INF\n");
print (FILE_4G "RTRV_RLC_INF\n");
print (FILE_4G "$RTRV_RLC_INF\n");

######################
# START RTRV-INACT-TIMER #
######################
$ssh_lsm->print("cmd $enodeb_name RTRV-INACT-TIMER");
$ssh_lsm->waitfor("]");
$ssh_lsm->waitfor("]");
my $RTRV_INACT_TIMER = $ssh_lsm->waitfor(';');
$RTRV_INACT_TIMER = "$RTRV_INACT_TIMER $colon";
print ("$RTRV_INACT_TIMER\n");
print (FILE_4G "RTRV_INACT_TIMER\n");
print (FILE_4G "$RTRV_INACT_TIMER\n");



print (FILE_4G "\n\nINSTALLED SLOTS\n");
my ($PING_CHECK);

$ssh_lsm->cmd("ping -c 1 $enodeb_ip_address_LSM");
sleep 5;
$PING_CHECK = $ssh_lsm->waitfor(',\s+time');
#print ("$PING_CHECK\n");



if (($PING_CHECK =~ m/100\%\s+packet\s+loss/) || ($PING_CHECK !~ m/packet\s+loss/)) {			#START IF SITE COULD NOT BE PINGED
print ("CAN NOT CONNECT TO $enodeb_ip_address_LSM\n");
print (FILE_4G "CAN NOT CONNECT TO $enodeb_ip_address_LSM\n");
$SLOT_1 = "CAN NOT CONNECT";
$SLOT_2 = "CAN NOT CONNECT";
$SLOT_3 = "CAN NOT CONNECT";
                                                                                    }			#END IF SITE COULD NOT BE PINGED


else {			#START IF SITE COULD BE PINGED

#################################
# START GET 4G SLOT INFORMATION #
#################################

#$ssh_lsm->print("cd .ssh");
#$ssh_lsm->print("rm known_hosts");
#$ssh_lsm->print("cd ..");

$ssh_lsm->print("cd .ssh");
$ssh_lsm->waitfor(']');
$ssh_lsm->print("rm known_hosts");
$ssh_lsm->print("y");
$ssh_lsm->waitfor(']');
$ssh_lsm->print("cd");
$ssh_lsm->waitfor(']');

$ssh_lsm->print("pwd");
$ssh_lsm->waitfor('/home/');

print ("\n###########################################\n");
print ("# PLEASE WAIT...LOGGING INTO UAMA CARD... #\n");
print ("###########################################\n\n");

$ssh_lsm->cmd("ssh lteuser\@$enodeb_ip_address_LSM");
#$ssh_lsm->waitfor('yes/no');
sleep 5;
$ssh_lsm->print("yes");
sleep 5;
my $pass = $ssh_lsm->waitfor('password:');
#print ("$pass\n");

$ssh_lsm->print("samsunglte");
my $UAMA = $ssh_lsm->waitfor('UAMA');
#print ("$UAMA\n");

$ssh_lsm->print("su -");
my $su = $ssh_lsm->waitfor('Password:');
#print ("$su\n");

#my ($root_password);
#if ($pkg =~ m/^4/) {
#$root_password = "S\@msung1te";
#                   }
#else {
#$root_password = "123qwe";
#     }

#$ssh_lsm->print("$root_password");
#my $root = $ssh_lsm->waitfor('root');
#print ("$root\n");

$ssh_lsm->print("123qwe");
my $Log = $ssh_lsm->waitfor('UAMA');


if (($Log =~ m/failure/) || ($Log =~ m/incorrect\s+password/)){

$ssh_lsm->print("su -");
$ssh_lsm->waitfor('Password:');


$ssh_lsm->print("S\@msung1te");
my $LOG = $ssh_lsm->waitfor('UAMA');
}

$ssh_lsm->print("vrctl 31 bash;");
$ssh_lsm->waitfor(';');
$ssh_lsm->waitfor('root');

$ssh_lsm->print("arp | grep 192.168.9.27;");
$ssh_lsm->waitfor(';');
$SLOT_1 = $ssh_lsm->waitfor('root');
print ("$SLOT_1\n");
$SLOT_1 =~ s/.*arp.*\n//g;
$SLOT_1 =~ s/\n+//g;
$SLOT_1 =~ s/\s+/ /g;
print (FILE_4G "$SLOT_1\n");

$ssh_lsm->print("arp | grep 192.168.10.27;");
$ssh_lsm->waitfor(';');
$SLOT_2 = $ssh_lsm->waitfor('root');
print ("$SLOT_2\n");
$SLOT_2 =~ s/.*arp.*\n//g;
$SLOT_2 =~ s/\n+//g;
$SLOT_2 =~ s/\s+/ /g;
print (FILE_4G "$SLOT_2\n");

$ssh_lsm->print("arp | grep 192.168.11.27;");
$ssh_lsm->waitfor(';');
$SLOT_3 = $ssh_lsm->waitfor('root');
print ("$SLOT_3\n");
$SLOT_3 =~ s/.*arp.*\n//g;
$SLOT_3 =~ s/\n+//g;
$SLOT_3 =~ s/\s+/ /g;
print (FILE_4G "$SLOT_3\n");


my (%hash_RRH_TELNET, $hash_RRH_TELNET);
%hash_RRH_TELNET = ();


$hash_RRH_TELNET{0} = "192.168.200.3";
$hash_RRH_TELNET{1} = "192.168.200.131";
$hash_RRH_TELNET{2} = "192.168.201.3";

print ("\n###############################\n");
print ("#HW Desc & Manufacture Company#\n");
print ("###############################\n");

foreach my $RRH_TYPE (sort {$a<=>$b} keys %hash_RRH_TELNET) {		#start $RRH_IP
if ($hash_CELL_NUMS{$RRH_TYPE}) {		#start if cell present
my $RRH_IP = $hash_RRH_TELNET{$RRH_TYPE};




$ssh_lsm->print("telnet $RRH_IP");
sleep 5;
my $Log = $ssh_lsm->waitfor('RRH login');
#print ("$Log\n");
#print (FILE_4G "$Log\n");



$ssh_lsm->print("root\r");
my $Log = $ssh_lsm->waitfor('Password');
#print ("$Log\n");


$ssh_lsm->print("123qwe\r");
my $Log = $ssh_lsm->waitfor('RRH_fw');
#print ("$Log\n");

$ssh_lsm->print("iminfo\r");
$ssh_lsm->waitfor('iminfo');
my $iminfo = $ssh_lsm->waitfor('RRH_fw');
$iminfo =~ s/\^M\^J//g;
#print ("$iminfo\n");
#print (FILE_4G "$iminfo\n");

my (@array_each_dash, $array_each_dash);
@array_each_dash = split(/\----+/,$iminfo);
print (FILE_4G "\nInventory Management Information\n\n");
foreach my $array_each_dash (@array_each_dash) {
if ($array_each_dash =~ m/Manufacture\s+Company/) {
$array_each_dash =~ s/^\s+//g;
print ("\n\n$RRH_IP\n$array_each_dash\n");
print (FILE_4G "\n\n$RRH_IP\n$array_each_dash\n");
$hash_INVENTORY_MAN{$RRH_IP} = "$array_each_dash";


                                                  }
                                               }

$ssh_lsm->print("exit\r");
$ssh_lsm->waitfor('root');

		  

                                 }		#end if cell present
                                                            }		#end $RRH_IP


$ssh_lsm->print("exit");
$ssh_lsm->waitfor('exit');


$ssh_lsm->print("cd /pkg");
$ssh_lsm->waitfor('/pkg');


$ssh_lsm->print("cd $pkg");
#$ssh_lsm->waitfor('root@UAMA:/pkg/');
$ssh_lsm->waitfor('/pkg/');

$ssh_lsm->print("cd ENB/r-01/bin");
$ssh_lsm->waitfor('/ENB/r-01/bin>');


$ssh_lsm->print("cli.opw");
$ssh_lsm->waitfor('USERNAME :');

my ($user_pkg, $pass_pkg);

my $pkg_info = "$pkg";
$pkg_info =~ s/\s+//g;

if ($pkg_info eq "2.5.0") {
$user_pkg = "EMSR";
$pass_pkg = "EMSR";

                          }

else {
$user_pkg = "ROOT";
$pass_pkg = "ROOT";

     }


$ssh_lsm->print("$user_pkg");
$ssh_lsm->waitfor('PASSWORD :');



$ssh_lsm->print("$pass_pkg");
$ssh_lsm->waitfor('] ');

print ("\n###########################\n");
print ("#PLEASE WAIT...MON-TEST...#\n");
print ("###########################\n");
sleep 5;

$ssh_lsm->print("MON-TEST;");
sleep 5;
$ssh_lsm->waitfor('MONITOR TEST STATUS');
sleep 5;
$mon_test = $ssh_lsm->waitfor(';');
my $mon_data = "  M0508 MONITOR TEST STATUS";

$mon_test = "$mon_data$mon_test$colon";
print ("\n\n$mon_test\n");
print (FILE_4G  "\n\n$mon_test");

$ssh_lsm->print("exit;");
$ssh_lsm->waitfor('/ENB/r-01/bin>');

$ssh_lsm->print("exit");
$ssh_lsm->waitfor('UAMA');

$ssh_lsm->print("exit");
$ssh_lsm->waitfor(']');
#################################
#  END GET 4G SLOT INFORMATION  #
#################################
     }			#END IF SITE COULD BE PINGED

                                    }			#end if enodeb exists


else {
print ("$enodeb_name HAS NOT BEEN GROWN\n");
print (FILE_4G "$enodeb_name HAS NOT BEEN GROWN\n");
     }

$ssh_lsm->print('exit');

$ssh_lsm->disconnect;

####################
#  END SSH TO LSM  #
####################


                  }
#############################
# START LSM_INFO SUBROUTINE #
#############################










sub CLOSE_4G_DATA {
close (FILE_4G);
                  }


############
#  END 4G  #
############


sub OPEN_HTML {


############################
# START M1/M2 IN FILE NAME #
############################
if ($network_name eq "3G") {
if (($onair_3g eq "YES") || ($commerical_3G eq "YES")) {
$m1_m2 = "3G_M2";
                                                       }
else {
$m1_m2 = "3G_M1";
     }
                           }

if ($network_name eq "4G") {
my ($commerical_4G);
if ($hash_enodeb_bucket{$enodeb_name} =~ m/COMMERCIAL/) {
$commerical_4G = "YES";
                                                        }
else {
$commerical_4G = "NO";
     }



if (($onair_4g eq "YES") || ($commerical_4G eq "YES")) {
$m1_m2 = "4G_M2";
                                                       }
else {
$m1_m2 = "4G_M1";
     }
                           }

if ($network_name eq "ALL") {
if (($onair_3g eq "YES") || ($commerical_3G eq "YES")) {
$m1_m2 .= "3G_M2";
                                                       }
else {
$m1_m2 .= "3G_M1";
     }

my ($commerical_4G);
if ($hash_enodeb_bucket{$enodeb_name} =~ m/COMMERCIAL/) {
$commerical_4G = "YES";
                                                        }
else {
$commerical_4G = "NO";
     }


if (($onair_4g eq "YES") || ($commerical_4G eq "YES")) {
$m1_m2 .= "_4G_M2";
                                                       }
else {
$m1_m2 .= "_4G_M1";
     }

                            }
############################
#  END M1/M2 IN FILE NAME  #
############################



open (HTMLFILE, ">$Bin\\AUDIT_REPORT\\$cascade\_$m1_m2\_3G_4G_AUDIT\_$month_num\_$mday\_$year\_$hour\_$minute\.html");
              }


sub AUDIT_REPORT_3G {
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=0>\n");
print (HTMLFILE "<tr><td align=center><font size=+3><b><u>3G AUDIT FOR $day $month $mday $year $hour:$minute:$second</u></b></font></td></tr>");
print (HTMLFILE "</table>");

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CASCADE</th><th>BTS ID</th><th>BSM NAME</th><th>BSM IP</th><th>MARKET</th><th>BTS STATUS</th><th>TYPE</th><th>SPRINT 3G ONAIR</th><th>3G COMMERICAL (BSM)</th><th>BSM VERSION</th><th>BTS VERSION</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$cascade</td>");
print (HTMLFILE "<td>$bts_id</td>");
print (HTMLFILE "<td>$bsm_name</td>");
print (HTMLFILE "<td>$bsm_ip_address</td>");
print (HTMLFILE "<td>$market</td>");
print (HTMLFILE "<td>$hash_SUBSYS_CONF_STATUS{$cascade}</td>");
print (HTMLFILE "<td>$GRM_COMBINER_EXCEL</td>");
print (HTMLFILE "<td>$onair_3g</td>");
if ($commerical_3G eq "$onair_3g") {
print (HTMLFILE "<td>$commerical_3G</td>");
                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$commerical_3G</td>");
     }

print (HTMLFILE "<td>$bsm_version</td>");

if ($bts_version eq "$bsm_version") {
print (HTMLFILE "<td>$bts_version</td>");
                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$bts_version</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>VALUES FROM</th><th>BTS IP</th><th>MMBS CABINET TYPE</th><th>BACKHAUL TYPE</th><th>NUMBER OF 1900 CARRIERS</th><th>800 CONFIGURED</th><th>SECTORS</th><th>800 RRU QTY</th><th>1900 RRU QTY</th><th>CDMA BBU QTY</th><th>CICA A QTY BBU1</th><th>CICA D QTY BBU1</th><th>CICA A QTY BBU2</th><th>CICA D QTY BBU2</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td>$bts_ip</td>");
print (HTMLFILE "<td>$MMBS_Cabinet_Type</td>");
print (HTMLFILE "<td>$Backhaul_Type</td>");
print (HTMLFILE "<td>$fa_1900_excel_carrier_count</td>\n");
print (HTMLFILE "<td>$hash_fa_carrier{2}</td>\n");
print (HTMLFILE "<td>$Sectors_NUM</td>");
print (HTMLFILE "<td>$RRU_Qty_800</td>");
print (HTMLFILE "<td>$RRU_Qty_1900</td>");
print (HTMLFILE "<td>$CDMA_BBU_Qty</td>");
print (HTMLFILE "<td>$CICA_A_Qty_BBU1</td>");
print (HTMLFILE "<td>$CICA_D_Qty_BBU1</td>");
print (HTMLFILE "<td>$CICA_A_Qty_BBU2</td>");
print (HTMLFILE "<td>$CICA_D_Qty_BBU2</td>");
print (HTMLFILE "</tr>");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>BSM</td>");
if ($hash_SUBSYS_CONF_OAM_IP{$cascade} ne "$bts_ip") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_OAM_IP{$cascade}</td>");
                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_OAM_IP{$cascade}</td>");
     }

if ($hash_SUBSYS_CONF_BTS_TYPE{$cascade} eq "$MMBS_Cabinet_Type") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_BTS_TYPE{$cascade}</td>");
                                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_BTS_TYPE{$cascade}</td>");
     }

if ($hash_SUBSYS_CONF_NET_TYPE{$cascade} eq "$Backhaul_Type") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_NET_TYPE{$cascade}</td>");
                                                              }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_NET_TYPE{$cascade}</td>");
     }

if ($hash_num_carriers{$cascade} eq "$fa_1900_excel_carrier_count") {
print (HTMLFILE "<td>$hash_num_carriers{$cascade}</td>");
                                                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_num_carriers{$cascade}</td>");
     }

if ($fa_800_bsm eq "$hash_fa_carrier{2}") {
print (HTMLFILE "<td>$fa_800_bsm</td>\n");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$fa_800_bsm</td>\n");
     }

if ($hash_SUBSYS_CONF_SECTOR_COUNT{$cascade} eq "$Sectors_NUM") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_SECTOR_COUNT{$cascade}</td>");
                                                                }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_SECTOR_COUNT{$cascade}</td>");
     }

if ($hash_800_count{$cascade} eq "$RRU_Qty_800") {
print (HTMLFILE "<td>$hash_800_count{$cascade}</td>");
                                                 }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_800_count{$cascade}</td>");
     }

if ($hash_1900_count{$cascade} eq "$RRU_Qty_1900") {
print (HTMLFILE "<td>$hash_1900_count{$cascade}</td>");
                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_1900_count{$cascade}</td>");
     }

if ($hash_SUBSYS_CONF_BCP_COUNT{$cascade} eq "$CDMA_BBU_Qty") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_BCP_COUNT{$cascade}</td>");
                                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_BCP_COUNT{$cascade}</td>");
     }
if ($hash_bbu1_cica_a_bsm{$cascade} eq "$CICA_A_Qty_BBU1") {
print (HTMLFILE "<td>$hash_bbu1_cica_a_bsm{$cascade}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bbu1_cica_a_bsm{$cascade}</td>");
     }

if ($hash_bbu1_cica_d_bsm{$cascade} eq "$CICA_D_Qty_BBU1") {
print (HTMLFILE "<td>$hash_bbu1_cica_d_bsm{$cascade}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bbu1_cica_d_bsm{$cascade}</td>");
     }

if ($hash_bbu2_cica_a_bsm{$cascade} eq "$CICA_A_Qty_BBU2") {
print (HTMLFILE "<td>$hash_bbu2_cica_a_bsm{$cascade}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bbu2_cica_a_bsm{$cascade}</td>");
     }

if ($hash_bbu2_cica_d_bsm{$cascade} eq "$CICA_D_Qty_BBU2") {
print (HTMLFILE "<td>$hash_bbu2_cica_d_bsm{$cascade}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bbu2_cica_d_bsm{$cascade}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=7 align=center><font size=+2><b>CEP DIVERSITY</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>BCP</th><th>CEP</th><th>RX_DIVERSITY[PCS]</th><th>CEP_TYPE</th><th>RX_DIVERSITY [MODEM_0]</th><th>RX_DIVERSITY [MODEM_1]</th><th>800</th></tr>");

foreach my $BTS (sort {$a<=>$b} keys %CICA_TYPE_Diversity) {

%hash_DIVERSITY_CHECK = ();


my $RX_DIVERSITY_PCS = "$hash_RX_DIVERSITY{$BTS}";

foreach my $BCP (sort keys %{$CICA_TYPE_Diversity{$BTS}}) {
foreach my $CEP (sort keys %{$CICA_TYPE_Diversity{$BTS}{$BCP}}) {
foreach my $CEP_TYPE (sort keys %{$CICA_TYPE_Diversity{$BTS}{$BCP}{$CEP}}) {
my $RX_DIVERSITY_FOR_MODEM_0 = "$CICA_TYPE_Diversity{$BTS}{$BCP}{$CEP}{$CEP_TYPE}{RX_DIVERSITY_FOR_MODEM_0}";
my $RX_DIVERSITY_FOR_MODEM_1 = "$CICA_TYPE_Diversity{$BTS}{$BCP}{$CEP}{$CEP_TYPE}{RX_DIVERSITY_FOR_MODEM_1}";

#If 1st card is CICA-A then our Modem0 should be 4RX & Modem1 should be 2RX
 
#If 1st card is CICA-D, then Modem0 is 2RX & Modem1 will be 4RX.
 
#All other cards (2nd, 3rd) will be 4RX / 4RX


my $IS_800 = "$hash_800_INFO{$BTS}";

if ($RX_DIVERSITY_PCS eq "4RX") {			#START IF $RX_DIVERSITY_PCS eq 4RX
if ($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_A}) {
if (($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_A}{RX_DIVERSITY_FOR_MODEM_0}) && (!$IS_800)) {
$hash_DIVERSITY_CHECK{0}{0}{MODEM_0} = "4RX";		#$hash_DIVERSITY_CHECK{$BCP}{$CEP}{MODEM_0}
$hash_DIVERSITY_CHECK{0}{0}{MODEM_1} = "4RX";
                                                                                        }

if (($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_A}{RX_DIVERSITY_FOR_MODEM_0} eq "4RX") && ($IS_800)) {
$hash_DIVERSITY_CHECK{0}{0}{MODEM_0} = "4RX";		#$hash_DIVERSITY_CHECK{$BCP}{$CEP}{MODEM_0}
$hash_DIVERSITY_CHECK{0}{0}{MODEM_1} = "2RX";
                                                                                                }
if (($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_A}{RX_DIVERSITY_FOR_MODEM_0} eq "2RX") && ($IS_800)) {
$hash_DIVERSITY_CHECK{0}{0}{MODEM_0} = "2RX";		#$hash_DIVERSITY_CHECK{$BCP}{$CEP}{MODEM_0}
$hash_DIVERSITY_CHECK{0}{0}{MODEM_1} = "4RX";
                                                                                                }

$hash_DIVERSITY_CHECK{0}{1}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{0}{1}{MODEM_1} = "4RX";

$hash_DIVERSITY_CHECK{0}{2}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{0}{2}{MODEM_1} = "4RX";
                                              }


if ($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_D}) {
if (($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_D}{RX_DIVERSITY_FOR_MODEM_0}) && (!$IS_800)) {
$hash_DIVERSITY_CHECK{0}{0}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{0}{0}{MODEM_1} = "4RX";
                                                                                        }

if (($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_D}{RX_DIVERSITY_FOR_MODEM_0} eq "2RX") && ($IS_800)) {
$hash_DIVERSITY_CHECK{0}{0}{MODEM_0} = "2RX";
$hash_DIVERSITY_CHECK{0}{0}{MODEM_1} = "4RX";
                                                                                                }
if (($CICA_TYPE_Diversity{$BTS}{0}{0}{CICA_D}{RX_DIVERSITY_FOR_MODEM_0} eq "4RX") && ($IS_800)) {
$hash_DIVERSITY_CHECK{0}{0}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{0}{0}{MODEM_1} = "2RX";
                                                                                                }

$hash_DIVERSITY_CHECK{0}{1}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{0}{1}{MODEM_1} = "4RX";

$hash_DIVERSITY_CHECK{0}{2}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{0}{2}{MODEM_1} = "4RX";
                                              }

if ($CICA_TYPE_Diversity{$BTS}{1}) {
$hash_DIVERSITY_CHECK{1}{0}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{1}{0}{MODEM_1} = "4RX";

$hash_DIVERSITY_CHECK{1}{1}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{1}{1}{MODEM_1} = "4RX";

$hash_DIVERSITY_CHECK{1}{2}{MODEM_0} = "4RX";
$hash_DIVERSITY_CHECK{1}{2}{MODEM_1} = "4RX";

                                   }
                                }			#END IF $RX_DIVERSITY_PCS eq 4RX

if ($RX_DIVERSITY_PCS eq "2RX") {			#START IF $RX_DIVERSITY_PCS eq 2RX

$hash_DIVERSITY_CHECK{0}{0}{MODEM_0} = "2RX";
$hash_DIVERSITY_CHECK{0}{0}{MODEM_1} = "2RX";

$hash_DIVERSITY_CHECK{0}{1}{MODEM_0} = "2RX";
$hash_DIVERSITY_CHECK{0}{1}{MODEM_1} = "2RX";

$hash_DIVERSITY_CHECK{0}{2}{MODEM_0} = "2RX";
$hash_DIVERSITY_CHECK{0}{2}{MODEM_1} = "2RX";


if ($CICA_TYPE_Diversity{$BTS}{1}) {
$hash_DIVERSITY_CHECK{1}{0}{MODEM_0} = "2RX";
$hash_DIVERSITY_CHECK{1}{0}{MODEM_1} = "2RX";

$hash_DIVERSITY_CHECK{1}{1}{MODEM_0} = "2RX";
$hash_DIVERSITY_CHECK{1}{1}{MODEM_1} = "2RX";

$hash_DIVERSITY_CHECK{1}{2}{MODEM_0} = "2RX";
$hash_DIVERSITY_CHECK{1}{2}{MODEM_1} = "2RX";

                                   }
                                }			#END IF $RX_DIVERSITY_PCS eq 2RX

my $DIV_MODEM_0 = "$hash_DIVERSITY_CHECK{$BCP}{$CEP}{MODEM_0}";
my $DIV_MODEM_1 = "$hash_DIVERSITY_CHECK{$BCP}{$CEP}{MODEM_1}";
my ($INFO_800);
if ($hash_800_INFO{$BTS}) {
$INFO_800 = "YES";
                          }
else {
$INFO_800 = "NO";
     }



print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$BCP</td>");
print (HTMLFILE "<td>$CEP</td>");
print (HTMLFILE "<td>$RX_DIVERSITY_PCS</td>");
print (HTMLFILE "<td>$CEP_TYPE</td>");
if (($RX_DIVERSITY_FOR_MODEM_0 eq "$DIV_MODEM_0") || (!$RX_DIVERSITY_FOR_MODEM_0)) {
print (HTMLFILE "<td>$RX_DIVERSITY_FOR_MODEM_0</td>");
                                                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RX_DIVERSITY_FOR_MODEM_0</td>");
     }
if (($RX_DIVERSITY_FOR_MODEM_1 eq "$DIV_MODEM_1") || (!$RX_DIVERSITY_FOR_MODEM_1)) {
print (HTMLFILE "<td>$RX_DIVERSITY_FOR_MODEM_1</td>");
                                                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$RX_DIVERSITY_FOR_MODEM_1</td>");
     }


print (HTMLFILE "<td>$INFO_800</td>");


print (HTMLFILE "</tr>");
                                                                           }
                                                                }
                                                          }
                                                           }


print (HTMLFILE "</table><br>");
#print Dumper(\%hash_DIVERSITY_CHECK);




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>BTS NAME / DESCRIPTION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CASCADE</th><th>BTS NAME (BSM)</th><th>DESCRIPTION (BSM)</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$cascade</td>");
if ($hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{NAME} eq "$cascade") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{NAME}</td>");
                                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{NAME}</td>");
     }

if ($hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{DESCRIPTION} eq "$cascade") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{DESCRIPTION}</td>");
                                                                               }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_NAME_DESC{$cascade}{$bts_id}{DESCRIPTION}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");


my ($sid_800, $nid_800, $nid_1900, $sid_1900);
my ($sid_data, $nid_data);
my ($commercial_value);


if (($onair_3g eq "YES") || ($commerical_3G eq "YES")) {
$sid_1900 = $hash_comm_sid_1900{$cascade};
$sid_800 = $hash_comm_sid_800{$cascade};
$nid_1900 = $hash_comm_nid_1900{$cascade};
$nid_800 = $hash_comm_nid_800{$cascade};
$commercial_value = "COMMERCIAL";
                                                       }

else {
$sid_1900 = $hash_non_comm_sid_1900{$cascade};
$sid_800 = $hash_non_comm_sid_800{$cascade};
$nid_1900 = $hash_non_comm_nid_1900{$cascade};
$nid_800 = $hash_non_comm_nid_800{$cascade};
$commercial_value = "NON COMMERCIAL";
     }


my ($type_information);
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=15 align=center><font size=+2><b>3G FA CONFIGURATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>FA INDEX</th><th>STATUS</th><th>FA ID</th><th>FA KIND</th><th>BCP</th><th>RRH PORT GROUP</th><th>DATABASE PATH</th><th>PATH</th><th>BND CLS IND</th><th>DATABASE SERV TYPE</th><th>SERV TYPE</th><th>DATABASE $commercial_value SID VALUE</th><th>OTA SID</th><th>DATABASE $commercial_value NID VALUE</th><th>OTA NID</th></tr>");
foreach $BTS_FA_CONF_FA_INDEX (sort {$a<=>$b} keys %BTS_FA_CONF_FA_INDEX) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$BTS_FA_CONF_FA_INDEX</td>");
if ($BTS_FA_CONF_STATUS{$BTS_FA_CONF_FA_INDEX} eq "EQUIP") {
print (HTMLFILE "<td>$BTS_FA_CONF_STATUS{$BTS_FA_CONF_FA_INDEX}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_STATUS{$BTS_FA_CONF_FA_INDEX}</td>");
     }

print (HTMLFILE "<td>$BTS_FA_CONF_FA_ID{$BTS_FA_CONF_FA_INDEX}</td>");
print (HTMLFILE "<td>$BTS_FA_CONF_FA_KIND{$BTS_FA_CONF_FA_INDEX}</td>");
print (HTMLFILE "<td>$BTS_FA_CONF_BCP{$BTS_FA_CONF_FA_INDEX}</td>");


if (($BTS_FA_CONF_FA_INDEX !=2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RRH_PORT_0_1_2")) {
print (HTMLFILE "<td>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                             } 

if (($BTS_FA_CONF_FA_INDEX ==2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RRH_PORT_0_1_2")) {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                             }                                                                               

if (($BTS_FA_CONF_FA_INDEX ==2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RRH_PORT_3_4_5")) {
print (HTMLFILE "<td>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                             } 
if (($BTS_FA_CONF_FA_INDEX !=2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RRH_PORT_3_4_5")) {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                             }               
 


if (($BTS_FA_CONF_FA_INDEX !=2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RU_PORT_0_1_2")) {
print (HTMLFILE "<td>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                            } 

if (($BTS_FA_CONF_FA_INDEX ==2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RU_PORT_0_1_2")) {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                            }                                                                               

if (($BTS_FA_CONF_FA_INDEX ==2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RU_PORT_3_4_5")) {
print (HTMLFILE "<td>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                            } 
if (($BTS_FA_CONF_FA_INDEX !=2) && ($BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX} eq "RU_PORT_3_4_5")) {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_RRH_PORT_GROUP{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                            } 

#########################
# Start figure out PATH #
#########################
if ($BTS_FA_CONF_FA_INDEX != 2) {
if (($GRM_COMBINER_EXCEL eq "Normal") && ($hash_num_carriers{$cascade} <= 6)) {	#Normal less than or equal to 6 carriers
$type_information = $mapping_normal{$BTS_FA_CONF_FA_INDEX};			#combine PATH_<num>
                                                                              }
if (($GRM_COMBINER_EXCEL eq "Normal") && ($hash_num_carriers{$cascade} > 6)) {	#Normal greater than to 6 carriers
$type_information = $mapping_normal_gt_6{$BTS_FA_CONF_FA_INDEX};		#combine PATH_<num>
                                                                             }
if (($GRM_COMBINER_EXCEL eq "Ground Mount") && ($hash_num_carriers{$cascade} <= 5)) {	#Ground Mount less than to 5 carriers
$type_information = $mapping_gmr_lt_5{$BTS_FA_CONF_FA_INDEX};				#combine PATH_<num>
                                                                                    }
if (($GRM_COMBINER_EXCEL eq "Grount Mount") && ($hash_num_carriers{$cascade} > 5)) {	#Ground Mount greater than 4 carriers
$type_information = $mapping_gmr_gt_4{$BTS_FA_CONF_FA_INDEX};				#combine PATH_<num>
                                                                                   }
if ($GRM_COMBINER_EXCEL eq "Combiner") {						#Combiner
$type_information = $mapping_combiner{$BTS_FA_CONF_FA_INDEX};				#combine PATH_<num>
                                       }
                                }
if ($BTS_FA_CONF_FA_INDEX == 2) {
$type_information = $BTS_FA_CONF_PATH{$BTS_FA_CONF_FA_INDEX};
                                }


print (HTMLFILE "<td>$type_information</td>");
 
if ($BTS_FA_CONF_FA_INDEX == 2) {
print (HTMLFILE "<td>$BTS_FA_CONF_PATH{$BTS_FA_CONF_FA_INDEX}</td>");
                                }

if (($BTS_FA_CONF_PATH{$BTS_FA_CONF_FA_INDEX} eq "$type_information") && ($BTS_FA_CONF_FA_INDEX ne "2")) {
print (HTMLFILE "<td>$BTS_FA_CONF_PATH{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                         }
if (($BTS_FA_CONF_PATH{$BTS_FA_CONF_FA_INDEX} ne "$type_information") && ($BTS_FA_CONF_FA_INDEX ne "2")) {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_PATH{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                         }
#########################
#  End figure out PATH  #
#########################





if (($BTS_FA_CONF_FA_INDEX !=2) && ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "PCS")) {
print (HTMLFILE "<td>$BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                               }

if (($BTS_FA_CONF_FA_INDEX ==2) && ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "PCS")) {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                               }
if (($BTS_FA_CONF_FA_INDEX ==2) && ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "CELLULAR")) {
print (HTMLFILE "<td>$BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                    }

if (($BTS_FA_CONF_FA_INDEX !=2) && ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "CELLULAR")) {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                    }

print (HTMLFILE "<td>$mapping_serv_type{$BTS_FA_CONF_FA_INDEX}</td>");
if ($BTS_FA_CONF_SERV_TYPE{$BTS_FA_CONF_FA_INDEX} eq "$mapping_serv_type{$BTS_FA_CONF_FA_INDEX}") {
print (HTMLFILE "<td>$BTS_FA_CONF_SERV_TYPE{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_SERV_TYPE{$BTS_FA_CONF_FA_INDEX}</td>");
     }

if ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "PCS") {
$sid_data = $sid_1900;
print (HTMLFILE "<td>$sid_1900</td>");
                                                              }
if ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "CELLULAR") {
$sid_data = $sid_800;
print (HTMLFILE "<td>$sid_800</td>");
                                                                   }

if ($BTS_FA_CONF_OTA_SID{$BTS_FA_CONF_FA_INDEX} eq "$sid_data") {
print (HTMLFILE "<td>$BTS_FA_CONF_OTA_SID{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_OTA_SID{$BTS_FA_CONF_FA_INDEX}</td>");
     }

if ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "PCS") {
$nid_data = $nid_1900;
print (HTMLFILE "<td>$nid_1900</td>");
                                                              }
if ($BTS_FA_CONF_BND_CLS_IND{$BTS_FA_CONF_FA_INDEX} eq "CELLULAR") {
$nid_data = $nid_800;
print (HTMLFILE "<td>$nid_800</td>");
                                                                   }

if ($BTS_FA_CONF_OTA_NID{$BTS_FA_CONF_FA_INDEX} eq "$nid_data") {
print (HTMLFILE "<td>$BTS_FA_CONF_OTA_NID{$BTS_FA_CONF_FA_INDEX}</td>");
                                                                }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$BTS_FA_CONF_OTA_NID{$BTS_FA_CONF_FA_INDEX}</td>");
     }

print (HTMLFILE "</tr>");
                                                                          }
print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=12 align=center><font size=+2><b>3G RET SERIAL NUMBERS</b></font></td></tr>");
if (!$ret_sts_nok) {			#start if !$ret_sts_nok
print (HTMLFILE "<tr bgcolor=#FFFF00>");
if ($hash_ret{0}) {
print (HTMLFILE "<th>BCP 0 PORT 0</th>");
                  }
if ($hash_ret{1}) {
print (HTMLFILE "<th>BCP 0 PORT 1</th>");
                  }
if ($hash_ret{2}) {
print (HTMLFILE "<th>BCP 0 PORT 2</th>");
                  }
if ($hash_ret{3}) {
print (HTMLFILE "<th>BCP 0 PORT 3</th>");
                  }
if ($hash_ret{4}) {
print (HTMLFILE "<th>BCP 0 PORT 4</th>");
                  }
if ($hash_ret{5}) {
print (HTMLFILE "<th>BCP 0 PORT 5</th>");
                  }
if ($hash_ret{6}) {
print (HTMLFILE "<th>BCP 1 PORT 0</th>");
                  }
if ($hash_ret{7}) {
print (HTMLFILE "<th>BCP 1 PORT 1</th>");
                  }
if ($hash_ret{8}) {
print (HTMLFILE "<th>BCP 1 PORT 2</th>");
                  }
if ($hash_ret{9}) {
print (HTMLFILE "<th>BCP 1 PORT 3</th>");
                  }
if ($hash_ret{10}) {
print (HTMLFILE "<th>BCP 1 PORT 4</th>");
                   }
if ($hash_ret{11}) {
print (HTMLFILE "<th>BCP 1 PORT 5</th>");
                   }
print (HTMLFILE "</tr>");




print (HTMLFILE "<tr>");
if ($hash_ret{0}) {
print (HTMLFILE "<td>$hash_ret{0}</td>");
                  }
if ($hash_ret{1}) {
print (HTMLFILE "<td>$hash_ret{1}</td>");
                  }
if ($hash_ret{2}) {
print (HTMLFILE "<td>$hash_ret{2}</td>");
                  }
if ($hash_ret{3}) {
print (HTMLFILE "<td>$hash_ret{3}</td>");
                  }
if ($hash_ret{4}) {
print (HTMLFILE "<td>$hash_ret{4}</td>");
                  }
if ($hash_ret{5}) {
print (HTMLFILE "<td>$hash_ret{5}</td>");
                  }
if ($hash_ret{6}) {
print (HTMLFILE "<td>$hash_ret{6}</td>");
                  }
if ($hash_ret{7}) {
print (HTMLFILE "<td>$hash_ret{7}</td>");
                  }
if ($hash_ret{8}) {
print (HTMLFILE "<td>$hash_ret{8}</td>");
                  }
if ($hash_ret{9}) {
print (HTMLFILE "<td>$hash_ret{9}</td>");
                  }
if ($hash_ret{10}) {
print (HTMLFILE "<td>$hash_ret{10}</td>");
                   }
if ($hash_ret{11}) {
print (HTMLFILE "<td>$hash_ret{11}</td>");
                   }

print (HTMLFILE "</tr>");

                   }			#end if !$ret_sts_nok


if ($ret_sts_nok) {			#start if $ret_sts_nok
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#FF0000 align=center><b>$ret_sts_nok</b></td>");
print (HTMLFILE "</tr>");
                  }			#end if $ret_sts_nok
print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=12 align=center><font size=+2><b>3G TILT VALUES</b></font></td></tr>");
if (!$ret_sts_nok) {		#start if !$ret_sts_nok
print (HTMLFILE "<tr bgcolor=#FFFF00>");
print (HTMLFILE "<th>VALUES FROM</th>");

if ($hash_TILT{0}) {
print (HTMLFILE "<th>BCP 0 PORT 0</th>");
                   }
if ($hash_TILT{1}) {
print (HTMLFILE "<th>BCP 0 PORT 1</th>");
                   }
if ($hash_TILT{2}) {
print (HTMLFILE "<th>BCP 0 PORT 2</th>");
                   }
if ($hash_TILT{3}) {
print (HTMLFILE "<th>BCP 0 PORT 3</th>");
                   }
if ($hash_TILT{4}) {
print (HTMLFILE "<th>BCP 0 PORT 4</th>");
                   }
if ($hash_TILT{5}) {
print (HTMLFILE "<th>BCP 0 PORT 5</th>");
                   }
if ($hash_TILT{6}) {
print (HTMLFILE "<th>BCP 1 PORT 0</th>");
                   }
if ($hash_TILT{7}) {
print (HTMLFILE "<th>BCP 1 PORT 1</th>");
                   }
if ($hash_TILT{8}) {
print (HTMLFILE "<th>BCP 1 PORT 2</th>");
                   }
if ($hash_TILT{9}) {
print (HTMLFILE "<th>BCP 1 PORT 3</th>");
                   }
if ($hash_TILT{10}) {
print (HTMLFILE "<th>BCP 1 PORT 4</th>");
                   }
if ($hash_TILT{11}) {
print (HTMLFILE "<th>BCP 1 PORT 5</th>");
                   }
print (HTMLFILE "</tr>");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
if ($hash_TILT{0}) {
print (HTMLFILE "<td>$RRH_PORT_0</td>");
                   }
if ($hash_TILT{1}) {
print (HTMLFILE "<td>$RRH_PORT_1</td>");
                   }
if ($hash_TILT{2}) {
print (HTMLFILE "<td>$RRH_PORT_2</td>");
                   }
if ($hash_TILT{3}) {
print (HTMLFILE "<td>$RRH_PORT_3</td>");
                   }
if ($hash_TILT{4}) {
print (HTMLFILE "<td>$RRH_PORT_4</td>");
                   }
if ($hash_TILT{5}) {
print (HTMLFILE "<td>$RRH_PORT_5</td>");
                   }
if ($hash_TILT{6}) {
print (HTMLFILE "<td>$RRH_PORT_0</td>");
                   }
if ($hash_TILT{7}) {
print (HTMLFILE "<td>$RRH_PORT_1</td>");
                   }
if ($hash_TILT{8}) {
print (HTMLFILE "<td>$RRH_PORT_2</td>");
                   }
if ($hash_TILT{9}) {
print (HTMLFILE "<td>$RRH_PORT_3</td>");
                   }
if ($hash_TILT{10}) {
print (HTMLFILE "<td>$RRH_PORT_4</td>");
                    }
if ($hash_TILT{11}) {
print (HTMLFILE "<td>$RRH_PORT_5</td>");
                    }
print (HTMLFILE "</tr>");




my $RRH_PORT_0_float = $RRH_PORT_0;
$RRH_PORT_0_float =~ s/\-//g;
$RRH_PORT_0_float = sprintf("%.2f", $RRH_PORT_0_float);

my $RRH_PORT_1_float = $RRH_PORT_1;
$RRH_PORT_1_float =~ s/\-//g;
$RRH_PORT_1_float = sprintf("%.2f", $RRH_PORT_1_float);

my $RRH_PORT_2_float = $RRH_PORT_2;
$RRH_PORT_2_float =~ s/\-//g;
$RRH_PORT_2_float = sprintf("%.2f", $RRH_PORT_2_float);

my $RRH_PORT_3_float = $RRH_PORT_3;
$RRH_PORT_3_float =~ s/\-//g;
$RRH_PORT_3_float = sprintf("%.2f", $RRH_PORT_3_float);

my $RRH_PORT_4_float = $RRH_PORT_4;
$RRH_PORT_4_float =~ s/\-//g;
$RRH_PORT_4_float = sprintf("%.2f", $RRH_PORT_4_float);

my $RRH_PORT_5_float = $RRH_PORT_5;
$RRH_PORT_5_float =~ s/\-//g;
$RRH_PORT_5_float = sprintf("%.2f", $RRH_PORT_5_float);


print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>BSM</td>");
if ($hash_TILT{0}) {
if ($hash_TILT{0} eq "$RRH_PORT_0_float") {
print (HTMLFILE "<td>$hash_TILT{0}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{0}</td>");
     }
                   }
if ($hash_TILT{1}) {
if ($hash_TILT{1} eq "$RRH_PORT_1_float") {
print (HTMLFILE "<td>$hash_TILT{1}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{1}</td>");
     }
                   }
if ($hash_TILT{2}) {
if ($hash_TILT{2} eq "$RRH_PORT_2_float") {
print (HTMLFILE "<td>$hash_TILT{2}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{2}</td>");
     }
                   }
if ($hash_TILT{3}) {
if ($hash_TILT{3} eq "$RRH_PORT_3_float") {
print (HTMLFILE "<td>$hash_TILT{3}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{3}</td>");
     }
                   }
if ($hash_TILT{4}) {
if ($hash_TILT{4} eq "$RRH_PORT_4_float") {
print (HTMLFILE "<td>$hash_TILT{4}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{4}</td>");
     }
                   }
if ($hash_TILT{5}) {
if ($hash_TILT{5} eq "$RRH_PORT_5_float") {
print (HTMLFILE "<td>$hash_TILT{5}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{5}</td>");
     }
                   }

if ($hash_TILT{6}) {
if ($hash_TILT{6} eq "$RRH_PORT_0_float") {
print (HTMLFILE "<td>$hash_TILT{6}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{6}</td>");
     }
                   }
if ($hash_TILT{7}) {
if ($hash_TILT{7} eq "$RRH_PORT_1_float") {
print (HTMLFILE "<td>$hash_TILT{7}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{7}</td>");
     }
                   }
if ($hash_TILT{8}) {
if ($hash_TILT{8} eq "$RRH_PORT_2_float") {
print (HTMLFILE "<td>$hash_TILT{8}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{8}</td>");
     }
                   }
if ($hash_TILT{9}) {
if ($hash_TILT{9} eq "$RRH_PORT_3_float") {
print (HTMLFILE "<td>$hash_TILT{9}</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{9}</td>");
     }
                   }
if ($hash_TILT{10}) {
if ($hash_TILT{10} eq "$RRH_PORT_4_float") {
print (HTMLFILE "<td>$hash_TILT{10}</td>");
                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{10}</td>");
     }
                   }
if ($hash_TILT{11}) {
if ($hash_TILT{11} eq "$RRH_PORT_5_float") {
print (HTMLFILE "<td>$hash_TILT{11}</td>");
                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_TILT{11}</td>");
     }
                   }

print (HTMLFILE "</tr>");

                   }		#end if !$ret_sts_nok 

if ($ret_sts_nok) {			#start if $ret_sts_nok
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#FF0000 align=center><b>$ret_sts_nok</b></td>");
print (HTMLFILE "</tr>");
                  }			#end if $ret_sts_nok
print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=4 align=center><font size=+2><b>3G PNs</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>VALUES FROM</th><th>SECTOR 0</th><th>SECTOR 1</th><th>SECTOR 2</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td>$hash_pn_excel{1}</td>");
print (HTMLFILE "<td>$hash_pn_excel{2}</td>");
print (HTMLFILE "<td>$hash_pn_excel{3}</td>");
print (HTMLFILE "</tr>");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>BSM</td>");
if ($hash_SUBSYS_CONF_PN_OFFSET{0} eq "$hash_pn_excel{1}") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_PN_OFFSET{0}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_PN_OFFSET{0}</td>");
     }

if ($hash_SUBSYS_CONF_PN_OFFSET{1} eq "$hash_pn_excel{2}") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_PN_OFFSET{1}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_PN_OFFSET{1}</td>");
     }

if ($hash_SUBSYS_CONF_PN_OFFSET{2} eq "$hash_pn_excel{3}") {
print (HTMLFILE "<td>$hash_SUBSYS_CONF_PN_OFFSET{2}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SUBSYS_CONF_PN_OFFSET{2}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>3G IPs</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>VALUES FROM</th><th>Vlan16_CSR_OAM_IP</th><th>Vlan16_MMBS_OAM_IP</th><th>Vlan24_CSR_Side_IP</th><th>Vlan24_MMBS_Side_IP</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td>$Vlan16_CSR_OAM_IP_3G</td>");
print (HTMLFILE "<td>$Vlan16_MMBS_OAM_IP_3G</td>");
print (HTMLFILE "<td>$Vlan24_CSR_Side_IP_3G</td>");
print (HTMLFILE "<td>$Vlan24_MMBS_Side_IP_3G</td>");
print (HTMLFILE "</tr>");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>BSM</td>");
if ($hash_vlan16_csr_ip_bsm{$cascade} eq "$Vlan16_CSR_OAM_IP_3G") {
print (HTMLFILE "<td>$hash_vlan16_csr_ip_bsm{$cascade}</td>");
                                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_vlan16_csr_ip_bsm{$cascade}</td>");
     }
if ($hash_vlan16_mmbs_ip_bsm{$cascade} eq "$Vlan16_MMBS_OAM_IP_3G") {
print (HTMLFILE "<td>$hash_vlan16_mmbs_ip_bsm{$cascade}</td>");
                                                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_vlan16_mmbs_ip_bsm{$cascade}</td>");
     }
if ($hash_vlan24_csr_ip_bsm{$cascade} eq "$Vlan24_CSR_Side_IP_3G") {
print (HTMLFILE "<td>$hash_vlan24_csr_ip_bsm{$cascade}</td>");
                                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_vlan24_csr_ip_bsm{$cascade}</td>");
     }
if ($hash_vlan24_mmbs_ip_bsm{$cascade} eq "$Vlan24_MMBS_Side_IP_3G") {
print (HTMLFILE "<td>$hash_vlan24_mmbs_ip_bsm{$cascade}</td>");
                                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_vlan24_mmbs_ip_bsm{$cascade}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>RTRV-BTS_STATIC_ROUTE-CONF - RETRIEVE BTS STATIC ROUTE CONFIGURATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>INDEX</th><th>STATUS</th><th>IPV4_PREFIX</th><th>IPV4_PREFIX_LENGTH</th><th>DISTANCE</th><th>GW_ADDRESS</th></tr>");
foreach my $INDEX (sort {$a<=>$b} keys %{$hash_BTS_STATIC_ROUTE_CONF{$cascade}}) {

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$INDEX</td>");
print (HTMLFILE "<td>$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$INDEX}{STATUS}</td>");
print (HTMLFILE "<td>$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$INDEX}{IPV4_PREFIX}</td>");
print (HTMLFILE "<td>$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$INDEX}{IPV4_PREFIX_LENGTH}</td>");
print (HTMLFILE "<td>$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$INDEX}{DISTANCE}</td>");
print (HTMLFILE "<td>$hash_BTS_STATIC_ROUTE_CONF{$cascade}{$INDEX}{GW_ADDRESS}</td>");
print (HTMLFILE "</tr>");

                                                                                 }
print (HTMLFILE "</table><br>");





print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=14 align=center><font size=+2><b>BTS IP ADDRESS CONFIGURATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00>");
print (HTMLFILE "<th>INDEX</th>");
print (HTMLFILE "<th>STATUS</th>");
print (HTMLFILE "<th>INTF TYPE</th>");
print (HTMLFILE "<th>SHELF ID</th>");
print (HTMLFILE "<th>SLOT ID</th>");
print (HTMLFILE "<th>PORT ID</th>");
print (HTMLFILE "<th>VLAN ID</th>");
print (HTMLFILE "<th>IPV4 ADDRESS</th>");
print (HTMLFILE "<th>IPV4 PREFIX LENGTH</th>");
print (HTMLFILE "<th>ATTRIBUTE OAM</th>");
print (HTMLFILE "<th>ATTRIBUTE 1X SIGNAL</th>");
print (HTMLFILE "<th>ATTRIBUTE 1X BEARER</th>");
print (HTMLFILE "<th>ATTRIBUTE DO SIGNAL</th>");
print (HTMLFILE "<th>ATTRIBUTE DO BEARER</th>");
print (HTMLFILE "</tr>");
my ($s);
for ($s=0; $s<2; $s++) {

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{INDEX}</td>");
if ($hash_bts_ip_conf_info{$s}{STATUS} eq "EQUIP") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{STATUS}</td>");
                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{STATUS}</td>");
     }
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{INTF_TYPE}</td>");
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{SHELF_ID}</td>");
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{SLOT_ID}</td>");
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{PORT_ID}</td>");
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{VLAN_ID}</td>");
if ($s==0) {
if ($hash_bts_ip_conf_info{$s}{IPV4_ADDRESS} eq "$Vlan16_MMBS_OAM_IP_3G") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{IPV4_ADDRESS}</td>");
                                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{IPV4_ADDRESS}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{IPV4_PREFIX_LENGTH} eq "30") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{IPV4_PREFIX_LENGTH}</td>");
                                                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{IPV4_PREFIX_LENGTH}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_OAM} eq "ON") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_OAM}</td>");
                                                       }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_OAM}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_SIGNAL} eq "OFF") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_SIGNAL}</td>");
                                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_SIGNAL}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_BEARER} eq "OFF") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_BEARER}</td>");
                                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_BEARER}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_SIGNAL} eq "OFF") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_SIGNAL}</td>");
                                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_SIGNAL}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_BEARER} eq "OFF") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_BEARER}</td>");
                                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_BEARER}</td>");
     }
           }

if ($s==1) {
if ($hash_bts_ip_conf_info{$s}{IPV4_ADDRESS} eq "$Vlan24_MMBS_Side_IP_3G") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{IPV4_ADDRESS}</td>");
                                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{IPV4_ADDRESS}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{IPV4_PREFIX_LENGTH} eq "30") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{IPV4_PREFIX_LENGTH}</td>");
                                                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{IPV4_PREFIX_LENGTH}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_OAM} eq "OFF") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_OAM}</td>");
                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_OAM}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_SIGNAL} eq "ON") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_SIGNAL}</td>");
                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_SIGNAL}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_BEARER} eq "ON") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_BEARER}</td>");
                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_1X_BEARER}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_SIGNAL} eq "ON") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_SIGNAL}</td>");
                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_SIGNAL}</td>");
     }
if ($hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_BEARER} eq "ON") {
print (HTMLFILE "<td>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_BEARER}</td>");
                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bts_ip_conf_info{$s}{ATTRIBUTE_DO_BEARER}</td>");
     }
           }



print (HTMLFILE "</tr>");





                       }
print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=16 align=center><font size=+2><b>RTRV-SUBC-STS - RETRIEVE SUBCELL STATUS</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>SECTOR</th><th>FA</th><th>SUBC_STS</th><th>TX_STS</th><th>SERV</th><th>SEC_CONF</th><th>FA_CONF</th><th>FA_TYPE</th><th>RRH_PATH</th><th>RRH_PORT</th><th>OVCH</th><th>LINK</th><th>IPC</th><th>PCF</th><th>VOICE</th><th>PACKET_FDCH</th></tr>");

foreach $hash_subsc_sts_sector (sort keys %hash_subsc_sts_sector) {		#start foreach sector
foreach $hash_subsc_sts_fa (sort keys %hash_subsc_sts_fa) {			#start foreach fa
if ($hash_subsc_sts_sector_fa{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}) {	#start if hash_subsc_sts_sector_fa sector and fa
#print ("SECTOR: $hash_subsc_sts_sector FA: $hash_subsc_sts_fa\n");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_subsc_sts_sector</td>");
print (HTMLFILE "<td>$hash_subsc_sts_fa</td>");
if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{SUBC_STS} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{SUBC_STS}</td>");
                                                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{SUBC_STS}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{TX_STS} eq "ON") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{TX_STS}</td>");
                                                                                      }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{TX_STS}</td>");
     }

print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{SERV}</td>");

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{SEC_CONF} eq "EQUIP") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{SEC_CONF}</td>");
                                                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{SEC_CONF}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{FA_CONF} eq "EQUIP") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{FA_CONF}</td>");
                                                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{FA_CONF}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{FA_TYPE} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{FA_TYPE}</td>");
                                                                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{FA_TYPE}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{RRH_PATH} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{RRH_PATH}</td>");
                                                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{RRH_PATH}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{RRH_PORT} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{RRH_PORT}</td>");
                                                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{RRH_PORT}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{OVCH} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{OVCH}</td>");
                                                                                      }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{OVCH}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{LINK} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{LINK}</td>");
                                                                                      }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{LINK}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{IPC} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{IPC}</td>");
                                                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{IPC}</td>");
     }

if ($hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{PCF} eq "NORM") {
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{PCF}</td>");
                                                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{PCF}</td>");
     }

print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{VOICE}</td>");
print (HTMLFILE "<td>$hash_subsc_sts_info{$hash_subsc_sts_sector}{$hash_subsc_sts_fa}{PACKET_FDCH}</td>");
print (HTMLFILE "</tr>");

                                                                           }	#end if hash_subsc_sts_sector_fa sector and fa

                                                          }			#end foreach fa


                                                                  }		#end foreach sector
print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>RTRV-BTS_CALL_ACCESS-DATA - RETRIEVE BTS CALL ACCESS DATA</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>PRIMARY_BSC_ID</th><th>PRIMARY_BSC_RACK_ID</th><th>PRIMARY_CMP_IP_V4</th><th>SECONDARY_BSC_RACK_ID</th><th>SECONDARY_CMP_IP_V4</th><th>SECONDARY_USED_FLAG</th></tr>");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_BTS_CALL_ACCESS_DATA{PRIMARY_BSC_ID}</td>");
print (HTMLFILE "<td>$hash_BTS_CALL_ACCESS_DATA{PRIMARY_BSC_RACK_ID}</td>");
print (HTMLFILE "<td>$hash_BTS_CALL_ACCESS_DATA{PRIMARY_CMP_IP_V4}</td>");
print (HTMLFILE "<td>$hash_BTS_CALL_ACCESS_DATA{SECONDARY_BSC_RACK_ID}</td>");
print (HTMLFILE "<td>$hash_BTS_CALL_ACCESS_DATA{SECONDARY_CMP_IP_V4}</td>");
if ($hash_BTS_CALL_ACCESS_DATA{SECONDARY_USED_FLAG} eq "ON") {
print (HTMLFILE "<td>$hash_BTS_CALL_ACCESS_DATA{SECONDARY_USED_FLAG}</td>");
                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_BTS_CALL_ACCESS_DATA{SECONDARY_USED_FLAG}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>RTRV-BTS_EVDO_CALL_ACCESS-DATA - RETRIEVE BTS EVDO CALL ACCESS DATA</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>PRIMARY_BSC_ID</th><th>PRIMARY_BSC_RACK_ID</th><th>PRIMARY_CMP_IP_V4</th><th>SECONDARY_BSC_RACK_ID</th><th>SECONDARY_CMP_IP_V4</th><th>SECONDARY_USED_FLAG</th></tr>");


print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_BTS_EVDO_CALL_ACCESS_DATA{PRIMARY_BSC_ID}</td>");
print (HTMLFILE "<td>$hash_BTS_EVDO_CALL_ACCESS_DATA{PRIMARY_BSC_RACK_ID}</td>");
print (HTMLFILE "<td>$hash_BTS_EVDO_CALL_ACCESS_DATA{PRIMARY_CMP_IP_V4}</td>");
print (HTMLFILE "<td>$hash_BTS_EVDO_CALL_ACCESS_DATA{SECONDARY_BSC_RACK_ID}</td>");
print (HTMLFILE "<td>$hash_BTS_EVDO_CALL_ACCESS_DATA{SECONDARY_CMP_IP_V4}</td>");
if ($hash_BTS_EVDO_CALL_ACCESS_DATA{SECONDARY_USED_FLAG} eq "ON") {
print (HTMLFILE "<td>$hash_BTS_EVDO_CALL_ACCESS_DATA{SECONDARY_USED_FLAG}</td>");
                                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_BTS_EVDO_CALL_ACCESS_DATA{SECONDARY_USED_FLAG}</td>");
     }
print (HTMLFILE "</tr>");

print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>RTRV-BTS_EVDO_SUBNET-PARA - RETRIEVE DO SUBNET PARAMETER</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>COLOR_CODE</th><th>SECTOR_ID_104[12]</th><th>SUBNET</th></tr>");

print (HTMLFILE "<tr>");
if ($hash_BTS_EVDO_SUBNET_PARA{COLOR_CODE} eq "$color_code") {
print (HTMLFILE "<td>$hash_BTS_EVDO_SUBNET_PARA{COLOR_CODE}</td>");
                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_BTS_EVDO_SUBNET_PARA{COLOR_CODE}</td>");
     }

if (($hash_BTS_EVDO_SUBNET_PARA{'SECTOR_ID_104[12]'} eq "$color_code") && ($hash_BTS_EVDO_SUBNET_PARA{'SECTOR_ID_104[12]'} eq "$hash_BTS_EVDO_SUBNET_PARA{COLOR_CODE}")) {
print (HTMLFILE "<td>$hash_BTS_EVDO_SUBNET_PARA{'SECTOR_ID_104[12]'}</td>");
                                                                                                                                                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_BTS_EVDO_SUBNET_PARA{'SECTOR_ID_104[12]'}</td>");
     }
print (HTMLFILE "<td>$hash_BTS_EVDO_SUBNET_PARA{SUBNET}</td>");
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>RTRV-BSC_PCF_BTS-PARA - RETRIEVE BSC PCF BTS PARAMETER</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>LOCATION</th><th>USED_FLAG</th><th>BSC_RACK_ID</th><th>A_BAND_COLOR_CODE</th><th>B_BAND_COLOR_CODE</th></tr>");
foreach $hash_BSC_PCF_BTS_PARA (sort keys %hash_BSC_PCF_BTS_PARA) {
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$hash_BSC_PCF_BTS_PARA</td>\n");
if ($hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{USED_FLAG} eq "ON") {
print (HTMLFILE "<td>$hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{USED_FLAG}</td>\n");
                                                                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{USED_FLAG}</td>\n");
     }
print (HTMLFILE "<td>$hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{BSC_RACK_ID}</td>\n");
if ($hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{A_BAND_COLOR_CODE} eq "$color_code") {
print (HTMLFILE "<td>$hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{A_BAND_COLOR_CODE}</td>\n");
                                                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{A_BAND_COLOR_CODE}</td>\n");
     }

if ($hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{B_BAND_COLOR_CODE} eq "$color_code") {
print (HTMLFILE "<td>$hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{B_BAND_COLOR_CODE}</td>\n");
                                                                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_BSC_PCF_BTS_PARA_PARM{$hash_BSC_PCF_BTS_PARA}{B_BAND_COLOR_CODE}</td>\n");
     }
print (HTMLFILE "</tr>\n");
                                                                  }
print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-BTS_PARA - RETRIEVE BTS PARAMETER</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>REG_ZONE</th><th>LTM_OFF</th></tr>");
print (HTMLFILE "<tr>\n");
if ($hash_RTRV_BTS_PARA{REG_ZONE} eq "$reg_zone") {
print (HTMLFILE "<td>$hash_RTRV_BTS_PARA{REG_ZONE}</td>\n");
                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_RTRV_BTS_PARA{REG_ZONE}</td>\n");
     }
if ($hash_RTRV_BTS_PARA{LTM_OFF} eq "$ltm_off") {
print (HTMLFILE "<td>$hash_RTRV_BTS_PARA{LTM_OFF}</td>\n");
                                                }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_RTRV_BTS_PARA{LTM_OFF}</td>\n");
     }
print (HTMLFILE "</tr>\n");
print (HTMLFILE "</table><br>");






print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-OOS-STS - RETRIEVE OUT OF SERVICE RATE STATUS</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>DEVICE</th><th>OOS(%)</th></tr>");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>CE_1X</td>\n");
if ($hash_RTRV_OOS_STS{CE_1X} eq "0.00") {
print (HTMLFILE "<td>$hash_RTRV_OOS_STS{CE_1X}</td>\n");
                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_RTRV_OOS_STS{CE_1X}</td>\n");
     }
print (HTMLFILE "</tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>CE_DO</td>\n");
if ($hash_RTRV_OOS_STS{CE_DO} eq "0.00") {
print (HTMLFILE "<td>$hash_RTRV_OOS_STS{CE_DO}</td>\n");
                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_RTRV_OOS_STS{CE_DO}</td>\n");
     }
print (HTMLFILE "</tr>\n");
print (HTMLFILE "</table><br>");



my (%hash_if_comm_parms, $hash_if_comm_parms);
%hash_if_comm_parms = ();
if (($onair_3g eq "YES") || ($commerical_3G eq "YES")) {
$hash_if_comm_parms{BTS_OTA_SYSTEM_PARA}{GLOBAL_REDIRECT} = "OFF";
$hash_if_comm_parms{BRC_ACCESS_PARA}{GSRDM_ACT} = "0";
$hash_if_comm_parms{BTS_CDMA_REDIRECT}{REDIRECT_ACCOLC} = "0";
$hash_if_comm_parms{BTS_CDMA_REDIRECT}{NUM_CHAN} = "0";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_0} = "1";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_1} = "0";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_2} = "1";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_3} = "1";
                                                       }
else {
$hash_if_comm_parms{BTS_OTA_SYSTEM_PARA}{GLOBAL_REDIRECT} = "ON";
$hash_if_comm_parms{BRC_ACCESS_PARA}{GSRDM_ACT} = "1";
$hash_if_comm_parms{BTS_CDMA_REDIRECT}{REDIRECT_ACCOLC} = "65527";
$hash_if_comm_parms{BTS_CDMA_REDIRECT}{NUM_CHAN} = "1";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_0} = "63";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_1} = "0";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_2} = "1";
$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_3} = "63";
     }




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=1 align=center><font size=+2><b>RTRV-BTS_OTA_SYSTEM-PARA - RETRIEVE BTS OTA SYSTEM PARAMETER</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>GLOBAL_REDIRECT</th></tr>");
print (HTMLFILE "<tr>");
if ($hash_BTS_OTA_SYSTEM_PARA{$cascade}{GLOBAL_REDIRECT} eq "$hash_if_comm_parms{BTS_OTA_SYSTEM_PARA}{GLOBAL_REDIRECT}") {
print (HTMLFILE "<td align=center>$hash_BTS_OTA_SYSTEM_PARA{$cascade}{GLOBAL_REDIRECT}</td>");
                                                                                                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_BTS_OTA_SYSTEM_PARA{$cascade}{GLOBAL_REDIRECT}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>RTRV-BTS_BRC_ACCESS-PARA - RETRIEVE BTS BRC ACCESS PARAMETER</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>SECTOR</th><th>FA_INDEX</th><th>GSRDM_ACT</th></tr>");
foreach my $SECTOR_BRC (sort {$a<=>$b} keys %{$hash_BTS_BRC_ACCESS_PARA{$cascade}}) {
foreach my $FA_INDEX_BRC (sort {$a<=>$b} keys %{$hash_BTS_BRC_ACCESS_PARA{$cascade}{$SECTOR_BRC}}) {

my $GSRDM_ACT = "$hash_BTS_BRC_ACCESS_PARA{$cascade}{$SECTOR_BRC}{$FA_INDEX_BRC}{GSRDM_ACT}";

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$SECTOR_BRC</td>");
print (HTMLFILE "<td>$FA_INDEX_BRC</td>");
if ($GSRDM_ACT eq "$hash_if_comm_parms{BRC_ACCESS_PARA}{GSRDM_ACT}") {
print (HTMLFILE "<td>$GSRDM_ACT</td>");
                                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$GSRDM_ACT</td>");
     }
print (HTMLFILE "</tr>");
                                                                                                   }

                                                                                    }
print (HTMLFILE "</table><br>");






print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-BTS_CDMA_REDIRECT-PARA - RETRIEVE BTS CDMA REDIRECT PARAMETER</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>REDIRECT_ACCOLC</th><th>NUM_CHAN</th></tr>");
print (HTMLFILE "<tr>");
if ($hash_BTS_CDMA_REDIRECT_PARA{$cascade}{REDIRECT_ACCOLC} eq "$hash_if_comm_parms{BTS_CDMA_REDIRECT}{REDIRECT_ACCOLC}") {
print (HTMLFILE "<td align=center>$hash_BTS_CDMA_REDIRECT_PARA{$cascade}{REDIRECT_ACCOLC}</td>");
                                                                                                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_BTS_CDMA_REDIRECT_PARA{$cascade}{REDIRECT_ACCOLC}</td>");
     }

if ($hash_BTS_CDMA_REDIRECT_PARA{$cascade}{NUM_CHAN} eq "$hash_if_comm_parms{BTS_CDMA_REDIRECT}{NUM_CHAN}") {
print (HTMLFILE "<td align=center>$hash_BTS_CDMA_REDIRECT_PARA{$cascade}{NUM_CHAN}</td>");
                                                                                                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_BTS_CDMA_REDIRECT_PARA{$cascade}{NUM_CHAN}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>RTRV-BTS_EVDO_ACCESS_MSG-PARA - RETRIEVE DO ACCESS MESSAGE PARAMETER</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>SECTOR</th><th>APERSISTENCE[0]</th><th>APERSISTENCE[1]</th><th>APERSISTENCE[2]</th><th>APERSISTENCE[3]</th></tr>");
foreach my $SECTOR_EVDO_ACC (sort {$a<=>$b} keys %{$hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}}) {

my $APERSISTENCE_0 = $hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_EVDO_ACC}{'APERSISTENCE[0]'};
my $APERSISTENCE_1 = $hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_EVDO_ACC}{'APERSISTENCE[1]'};
my $APERSISTENCE_2 = $hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_EVDO_ACC}{'APERSISTENCE[2]'};
my $APERSISTENCE_3 = $hash_BTS_EVDO_ACCESS_MSG_PARA{$cascade}{$SECTOR_EVDO_ACC}{'APERSISTENCE[3]'};

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$SECTOR_EVDO_ACC</td>");
if ($APERSISTENCE_0 eq "$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_0}") {
print (HTMLFILE "<td>$APERSISTENCE_0</td>");
                                                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$APERSISTENCE_0</td>");
     }

if ($APERSISTENCE_1 eq "$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_1}") {
print (HTMLFILE "<td>$APERSISTENCE_1</td>");
                                                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$APERSISTENCE_1</td>");
     }

if ($APERSISTENCE_2 eq "$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_2}") {
print (HTMLFILE "<td>$APERSISTENCE_2</td>");
                                                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$APERSISTENCE_2</td>");
     }

if ($APERSISTENCE_3 eq "$hash_if_comm_parms{BTS_EVDO_ACCESS_MSG_PARA}{APERSISTENCE_3}") {
print (HTMLFILE "<td>$APERSISTENCE_3</td>");
                                                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$APERSISTENCE_3</td>");
     }


print (HTMLFILE "</tr>");


                                                                                    }
print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>RTRV-CALL-CNT - RETRIEVE CALL COUNT</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>FA</th><th>SECTOR</th><th>3G VOICE(L/H)</th><th>3G PACKET(L/H)</th><th>3G TOTAL(L/H)</th></tr>");

#$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{VOICE_3G} = "$VOICE_3G";
#$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{PACKET_3G} = "$PACKET_3G";
#$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{TOTAL_3G} = "$TOTAL_3G";

foreach my $FA_INDEX (sort keys %hash_CALL_CNT) {
foreach my $TYPE (sort keys %{$hash_CALL_CNT{$FA_INDEX}}) {
foreach my $SECTOR (sort keys %{$hash_CALL_CNT{$FA_INDEX}{$TYPE}}) {

my $VOICE_3G = "$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{VOICE_3G}";
my $PACKET_3G = "$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{PACKET_3G}";
my $TOTAL_3G = "$hash_CALL_CNT{$FA_INDEX}{$TYPE}{$SECTOR}{TOTAL_3G}";

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$FA_INDEX($TYPE)</td>");
print (HTMLFILE "<td>$SECTOR</td>");
if (($VOICE_3G eq "0/0") && ($TYPE ne "DO") && ($TYPE ne "DOA")) {
print (HTMLFILE "<td bgcolor=#FFA500>$VOICE_3G</td>");
                                                                 }
else {
print (HTMLFILE "<td>$VOICE_3G</td>");
     }
if ($PACKET_3G eq "0/0") {
print (HTMLFILE "<td bgcolor=#FFA500>$PACKET_3G</td>");
                         }
else {
print (HTMLFILE "<td>$PACKET_3G</td>");
     }
if ($TOTAL_3G eq "0/0") {
print (HTMLFILE "<td bgcolor=#FFA500>$TOTAL_3G</td>");
                        }
else {
print (HTMLFILE "<td>$TOTAL_3G</td>");
     }
print (HTMLFILE "</tr>");

                                                                  }
                                                          }
                                                }

print (HTMLFILE "</table><br>");




my (%hash_FW_VERIFY, $hash_FW_VERIFY);
if ($bsm_version eq "3.0.0") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.8";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW} = "1.0.0.4";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";

$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.1'} = "0.1.1.1";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.2.9'} = "0.0.2.9";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.2'} = "0.1.1.2";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";


$hash_FW_VERIFY{RRH}{FW}{800}{'1.2.22.22'} = "1.2.22.22";
$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.2.7'} = "0.0.2.7";
$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.3.8'} = "0.0.3.8";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";
$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.25.25'} = "2.0.25.25";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }


if ($bsm_version eq "3.0.1") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW} = "1.0.0.4";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";

$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.2'} = "0.1.1.2";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.2.9'} = "0.0.2.9";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";


$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";
$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.3.8'} = "0.0.3.8";
$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.25.25'} = "2.0.25.25";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }

if ($bsm_version eq "3.0.2") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW} = "1.0.0.4";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";


$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";

$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }

if ($bsm_version eq "3.0.3") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";


$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";

$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }


if ($bsm_version eq "3.0.4") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";


$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";

$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }

if ($bsm_version eq "3.5.1") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";


$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";

$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }

if ($bsm_version eq "3.5.2") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";


$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";

$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }

if ($bsm_version eq "3.5.3") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

#$hash_FW_VERIFY{CEP}{EPLD} = "1.3";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.21";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.5";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.21";


$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.3'} = "0.1.1.3";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.0'} = "0.0.3.0";

$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.3'} = "0.0.4.3";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }

if ($bsm_version eq "4.0.3") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.26";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.10";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.24";



$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.1.9'} = "0.1.1.9";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.2.6.0'} = "0.2.6.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.3.4'} = "0.0.3.4";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.3.3.0'} = "0.3.3.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.5.0'} = "0.0.5.0";


$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.9'} = "0.0.4.9";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.32.32'} = "2.0.32.32";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }


if ($bsm_version eq "4.1.0") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.26";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.10";
$hash_FW_VERIFY{EAIU}{FW}{3} = "1.0.0.24";



$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.3.0'} = "0.1.3.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.2.8.0'} = "0.2.8.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.0.5.0'} = "0.0.5.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.3.6.0'} = "0.3.6.0";



$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.9'} = "0.0.4.9";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";

                             }


if ($bsm_version eq "4.2.0") {
$hash_FW_VERIFY{BCP}{CLOCK} = "0.9";
$hash_FW_VERIFY{BCP}{CTRL} = "0.9";

$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.5'} = "1.0.0.5";
$hash_FW_VERIFY{GPSR}{FW}{'1.0.0.6'} = "1.0.0.6";

$hash_FW_VERIFY{EAIU}{FW}{1} = "0.1.12.27";
$hash_FW_VERIFY{EAIU}{FW}{2} = "0.1.12.11";
$hash_FW_VERIFY{EAIU}{FW}{2} = "1.0.0.24";


$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.5.0'} = "0.1.5.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.2.9.0'} = "0.2.9.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.1.0.0'} = "0.1.0.0";
$hash_FW_VERIFY{RRH}{FW}{1900}{'0.4.0.0'} = "0.4.0.0";

$hash_FW_VERIFY{RRH}{FW}{800}{'0.0.4.9'} = "0.0.4.9";
$hash_FW_VERIFY{RRH}{FW}{800}{'2.0.24.24'} = "2.0.24.24";

$hash_FW_VERIFY{FAN}{FW}{1} = "1.2.0.0";
$hash_FW_VERIFY{FAN}{FW}{2} = "1.2.0.1";


                             }




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>3G FIRMWARE</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>LOCATION</th><th>BD_TYPE</th><th>FIRMWARE VERISON</th></tr>");
foreach $hash_inf_rrh_loc (sort keys %hash_inf_rrh_loc) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_inf_rrh_loc</td>");
print (HTMLFILE "<td>RRH</td>");

if (($hash_inf_rrh_loc eq "RRH_000") || ($hash_inf_rrh_loc eq "RRH_010") || ($hash_inf_rrh_loc eq "RRH_020") || ($hash_inf_rrh_loc eq "RRH_100") || ($hash_inf_rrh_loc eq "RRH_110") || ($hash_inf_rrh_loc eq "RRH_120")) {
my $RRH_FW_VALUE = "$hash_inf_rrh_fw{$hash_inf_rrh_loc}";
if ($hash_FW_VERIFY{RRH}{FW}{1900}{$RRH_FW_VALUE}) {
print (HTMLFILE "<td>$hash_inf_rrh_fw{$hash_inf_rrh_loc}</td>");
                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_inf_rrh_fw{$hash_inf_rrh_loc}</td>");
     }
                                                                                                                                                                                                                          }

if (($hash_inf_rrh_loc eq "RRH_030") || ($hash_inf_rrh_loc eq "RRH_040") || ($hash_inf_rrh_loc eq "RRH_050") || ($hash_inf_rrh_loc eq "RRH_130") || ($hash_inf_rrh_loc eq "RRH_140") || ($hash_inf_rrh_loc eq "RRH_150")) {
my $RRH_FW_VALUE = "$hash_inf_rrh_fw{$hash_inf_rrh_loc}";
if ($hash_FW_VERIFY{RRH}{FW}{800}{$RRH_FW_VALUE}) {
print (HTMLFILE "<td>$hash_inf_rrh_fw{$hash_inf_rrh_loc}</td>");
                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_inf_rrh_fw{$hash_inf_rrh_loc}</td>");
     }
                                                                                                                                                                                                                          }


print (HTMLFILE "</tr>");
                                                        }


foreach $hash_eaiu_loc (sort keys %hash_eaiu_loc) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_eaiu_loc</td>");
print (HTMLFILE "<td>EAIU</td>");
if (($hash_eaiu_fw{$hash_eaiu_loc} eq "$hash_FW_VERIFY{EAIU}{FW}{1}") || ($hash_eaiu_fw{$hash_eaiu_loc} eq "$hash_FW_VERIFY{EAIU}{FW}{2}") || ($hash_eaiu_fw{$hash_eaiu_loc} eq "$hash_FW_VERIFY{EAIU}{FW}{3}")) {
print (HTMLFILE "<td>$hash_eaiu_fw{$hash_eaiu_loc}</td>");
                                                                                                                                                                                                                 }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_eaiu_fw{$hash_eaiu_loc}</td>");
     }
print (HTMLFILE "</tr>");
                                                  }

foreach $hash_gpsr_loc (sort keys %hash_gpsr_loc) {
my $GPSR_FW_INFO = "$hash_gpsr_fw{$hash_gpsr_loc}";
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_gpsr_loc</td>");
print (HTMLFILE "<td>GPSR</td>");
if ($hash_gpsr_fw{$hash_gpsr_loc} eq "$hash_FW_VERIFY{GPSR}{FW}{$GPSR_FW_INFO}") {
print (HTMLFILE "<td>$hash_gpsr_fw{$hash_gpsr_loc}</td>");
                                                                                 }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_gpsr_fw{$hash_gpsr_loc}</td>");
     }
print (HTMLFILE "</tr>");
                                                  }

foreach $hash_bcp_loc (sort keys %hash_bcp_loc) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_bcp_loc</td>");
print (HTMLFILE "<td>BCP (EPLD-CTRL VER)</td>");
if ($hash_bcp_ctrl{$hash_bcp_loc} eq "$hash_FW_VERIFY{BCP}{CTRL}") {
print (HTMLFILE "<td>$hash_bcp_ctrl{$hash_bcp_loc}</td>");
                                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bcp_ctrl{$hash_bcp_loc}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_bcp_loc</td>");
print (HTMLFILE "<td>BCP (EPLD-CLOCK VER)</td>");
if ($hash_bcp_clock{$hash_bcp_loc} eq "$hash_FW_VERIFY{BCP}{CLOCK}") {
print (HTMLFILE "<td>$hash_bcp_clock{$hash_bcp_loc}</td>");
                                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_bcp_clock{$hash_bcp_loc}</td>");
     }
print (HTMLFILE "</tr>");
                                                }
print (HTMLFILE "</table><br>");


if ($CMPR_FW_INF_NO_RESULT) {
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td align=center><font size=+2><b>COMPARE FIRMWARE IMAGE INFORMATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td align=center><font size=+2><b>$CMPR_FW_INF_NO_RESULT</b></font></td></tr></table><br>");
                            }

else {	#start else if not $CMPR_FW_INF_NO_RESULT
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>COMPARE FIRMWARE IMAGE INFORMATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>PROCESSOR</th><th>BASE_VERSION</th><th>TARGET_VERSION</th></tr>");
foreach my $PROCESSOR (sort keys %hash_CMPR_FW_INF_BTS) {

my $BASE_VERSION = "$hash_CMPR_FW_INF_BTS{$PROCESSOR}{BASE_VERSION}";
$BASE_VERSION =~ s/\s+//;
my $TARGET_VERSION = "$hash_CMPR_FW_INF_BTS{$PROCESSOR}{TARGET_VERSION}";
$TARGET_VERSION =~ s/\s+//;

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$PROCESSOR</td>");
print (HTMLFILE "<td>$BASE_VERSION</td>");
if ($BASE_VERSION eq "$TARGET_VERSION") {
print (HTMLFILE "<td>$TARGET_VERSION</td>");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$TARGET_VERSION</td>");
     }
print (HTMLFILE "</tr>");
                                                        }
print (HTMLFILE "</table><br>");

    }	#start else if not $CMPR_FW_INF_NO_RESULT
#print Dumper(\%hash_CMPR_FW_INF_BTS);





print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>3G ROM MISMATCH</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>LOCATION</th><th>ROM MISMATCH INFORMATION</th></tr>");
foreach my $location (sort keys %hash_cmpr_rom_info) {
foreach my $rom_title (sort keys %{$hash_cmpr_rom_info{$location}}) {

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$location</td>");

if ($rom_title eq "NO MISMATCH INFORMATION") {
print (HTMLFILE "<td>$hash_cmpr_rom_info{$location}{$rom_title}</td>");
                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_cmpr_rom_info{$location}{$rom_title}</td>");
     }
print (HTMLFILE "</tr>");
                                                                            }
                                                          }
print (HTMLFILE "</table><br>");




my ($kernel_version);
if ($bsm_version eq "3.0.0") {
$kernel_version = "3.0.0"
                             }

if (($bsm_version eq "3.0.1") || ($bsm_version eq "3.0.2") || ($bsm_version eq "3.0.3") || ($bsm_version eq "3.0.4") || ($bsm_version eq "3.5.1") || ($bsm_version eq "3.5.2") || ($bsm_version eq "3.5.3")) {
$kernel_version = "3.0.1"
                                                                                                                                                                                                             }

if (($bsm_version eq "4.0.3") || ($bsm_version eq "4.1.0") || ($bsm_version eq "4.2.0"))  {
$kernel_version = "4.0.0"
                                                                                          }

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>FLASH ROM IMAGE INFORMATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>BSM VERSION</th><th>*BOOTER RUNNING</th><th>BOOTER SAVED</th><th>*KERNEL RUNNING</th><th>KERNEL0 RUNNING</th><th>KERNEL1 RUNNING</th></tr>");

my $BOOTER_RUN = "$hash_BOOTER{$bts_id}{BOOTER_RUN}";
my $BOOTER_SAVED = "$hash_BOOTER{$bts_id}{BOOTER_SAVE}";
my $KERNEL_SAVED = "$hash_KERNEL{$bts_id}{KERNEL_RUN}";
my $KERNEL0_RUN = "$hash_KERNEL{$bts_id}{KERNEL_SAVE0}";
my $KERNEL1_RUN = "$hash_KERNEL{$bts_id}{KERNEL_SAVE1}";


print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$bsm_version</td>");
if ($BOOTER_RUN eq "$version") {
print (HTMLFILE "<td>$BOOTER_RUN</td>");
                               }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$BOOTER_RUN</td>");
     }
if ($BOOTER_SAVED eq "$version") {
print (HTMLFILE "<td>$BOOTER_SAVED</td>");
                                 }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$BOOTER_SAVED</td>");
     }
if ($KERNEL_SAVED eq "$kernel_version") {
print (HTMLFILE "<td>$KERNEL_SAVED</td>");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$KERNEL_SAVED</td>");
     }
if ($KERNEL0_RUN eq "$kernel_version") {
print (HTMLFILE "<td>$KERNEL0_RUN</td>");
                                       }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$KERNEL0_RUN</td>");
     }
if ($KERNEL1_RUN eq "$kernel_version") {
print (HTMLFILE "<td>$KERNEL1_RUN</td>");
                                       }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$KERNEL1_RUN</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>RRH TX ATTENUATION DATA</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>BCP</th><th>PORT</th><th>CASCADE</th><th>FA_INDEX</th><th>TX_ATTEN</th></tr>");

foreach my $BTS (sort {$a<=>$b} keys %hash_TXATT_DATA) {					#START FOREACH BTS
foreach my $BCP (sort {$a<=>$b} keys %{$hash_TXATT_DATA{$BTS}}) {				#START FOREACH BCP
foreach my $PORT (sort {$a<=>$b} keys %{$hash_TXATT_DATA{$BTS}{$BCP}}) {			#START FOREACH PORT
foreach my $CASCADE (sort {$a<=>$b} keys %{$hash_TXATT_DATA{$BTS}{$BCP}{$PORT}}) {		#START FOREACH CASCADE
foreach my $FA_INDEX (sort {$a<=>$b} keys %{$hash_TXATT_DATA{$BTS}{$BCP}{$PORT}{$CASCADE}}) {	#START FOREACH FA_INDEX
my $TX_ATTEN = "$hash_TXATT_DATA{$BTS}{$BCP}{$PORT}{$CASCADE}{$FA_INDEX}";			#TX_ATTEN
my ($MASTER_TX_ATTEN);

if (($PORT == 0) || ($PORT == 1) || ($PORT == 2)) {
if ($FA_INDEX != 2) {
$MASTER_TX_ATTEN = 0;
                    }
                                                  }

if (($PORT == 3) || ($PORT == 4) || ($PORT == 5)) {
if ($FA_INDEX != 2) {
$MASTER_TX_ATTEN = 100;
                    }
                                                  }


if (($PORT == 3) || ($PORT == 4) || ($PORT == 5)) {
if ($FA_INDEX == 2) {
$MASTER_TX_ATTEN = 0;
                    }
                                                  }

if (($PORT == 0) || ($PORT == 1) || ($PORT == 2)) {
if ($FA_INDEX == 2) {
$MASTER_TX_ATTEN = 100;
                    }
                                                  }

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$BCP</td>");
print (HTMLFILE "<td>$PORT</td>");
print (HTMLFILE "<td>$CASCADE</td>");
print (HTMLFILE "<td>$FA_INDEX</td>");
if ($TX_ATTEN eq "$MASTER_TX_ATTEN") {
print (HTMLFILE "<td>$TX_ATTEN</td>");
                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$TX_ATTEN</td>");
     }
print (HTMLFILE "</tr>");

                                                                                            }	#END FOREACH FA_INDEX
                                                                                 }		#END FOREACH CASCADE
                                                                       }			#END FOREACH PORT
                                                               }				#END FOREACH BCP
                                                       }					#END FOREACH BTS


print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-BTS_RC-PARA - RETRIEVE BTS RC PARAMETER</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>F_V_LOAD_BALANCING_THRESHOLD</th><th>F_P_LOAD_BALANCING_THRESHOLD</th></tr>");

my $F_V_LOAD_BALANCING_THRESHOLD = "$hash_RTRV_BTS_RC_PARA{F_V_LOAD_BALANCING_THRESHOLD}";
my $F_P_LOAD_BALANCING_THRESHOLD = "$hash_RTRV_BTS_RC_PARA{F_P_LOAD_BALANCING_THRESHOLD}";

print (HTMLFILE "<tr>");
if ($F_V_LOAD_BALANCING_THRESHOLD eq "85") {
print (HTMLFILE "<td>$F_V_LOAD_BALANCING_THRESHOLD</td>");
                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$F_V_LOAD_BALANCING_THRESHOLD</td>");
     }

if ($F_P_LOAD_BALANCING_THRESHOLD eq "85") {
print (HTMLFILE "<td>$F_P_LOAD_BALANCING_THRESHOLD</td>");
                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$F_P_LOAD_BALANCING_THRESHOLD</td>");
     }
print (HTMLFILE "</tr>");

print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>RTRV-ALM-INH - RETRIEVE ALARM INHIBIT</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CODE</th><th>OBJECT</th><th>ALARM DESCRIPTION</th></tr>");


foreach my $CODE (sort keys %hash_ALM_INH) {
print (HTMLFILE "<tr>");

foreach my $OBJECT (sort keys %{$hash_ALM_INH{$CODE}}) {
print (HTMLFILE "<td bgcolor=#FFA500>$CODE</td>");
print (HTMLFILE "<td bgcolor=#FFA500>$OBJECT</td>");

my $DES = "$hash_ALM_INH{$CODE}{$OBJECT}";
print (HTMLFILE "<td bgcolor=#FFA500>$DES</td>");
                                                       }
print (HTMLFILE "</tr>");
                                            }
print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>CHG-ENV-VAR (DISPLAY) - 3G ENV VARIABLE</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>PROCESSOR</th><th>ENV NAME</th><th>ENV VALUE</th></tr>");


foreach my $PROCESSOR (sort keys %hash_ENV_VAR) {


foreach my $ENV_NAME (sort keys %{$hash_ENV_VAR{$PROCESSOR}}) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$PROCESSOR</td>");
print (HTMLFILE "<td>$ENV_NAME</td>");

my $ENV_VALUE = "$hash_ENV_VAR{$PROCESSOR}{$ENV_NAME}";
print (HTMLFILE "<td>$ENV_VALUE</td>");
print (HTMLFILE "</tr>");
                                                              }

                                                }
print (HTMLFILE "</table><br>");



if ($hash_is_active_alms{$cascade} == 0) {

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>3G ALARMS</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td align=center><font size =+2><b>THERE ARE NO 3G ALARMS</b></font></td></tr>");

print (HTMLFILE "</table><br>");
                                         }

if ($hash_is_active_alms{$cascade} == 1) {
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>3G ALARMS</b></font></td></tr>");
if ($alm_count > 0) {
print (HTMLFILE "<tr bgcolor=#FFFF00><th>GRADE</th><th>ALARM CODE</th><th>EVENT TIME</th><th>ALARM</th><th>LOCATION</th></tr>");
                    }
else {
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>THERE ARE NO 3G ALARMS</b></font></td></tr>");
     }
foreach $hash_active_alm_key (sort keys %hash_active_alm_key) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_active_alm_grd{$hash_active_alm_key}</td>");
print (HTMLFILE "<td>$hash_active_alm_cd{$hash_active_alm_key}</td>");
print (HTMLFILE "<td>$hash_active_alm_evnt_tm{$hash_active_alm_key}</td>");
print (HTMLFILE "<td>$hash_active_alarm{$hash_active_alm_key}</td>");
print (HTMLFILE "<td>$hash_active_alm_loc{$hash_active_alm_key}</td>");
print (HTMLFILE "</tr>");
                                                              }


print (HTMLFILE "</table><br>");

                                         }




my $count_history_alarms = keys %hash_ALM_HIST;
#print ("$count_history_alarms\n");
if ($count_history_alarms == 0) {

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>3G ALARM HISTORY</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td align=center><font size =+2><b>THERE'S NO 3G ALARM HISTORY</b></font></td></tr>");

print (HTMLFILE "</table><br>");
                                }

if ($count_history_alarms > 0) {
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>3G ALARM HISTORY</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>GRADE</th><th>CODE</th><th>ALARM TYPE</th><th>LOCATION</th><th>START TIME</th><th>END TIME</th></tr>");

my ($bgcolor);
foreach $hash_ALM_HIST (sort keys %hash_ALM_HIST) {
if ($hash_ALM_HIST{$hash_ALM_HIST}{GRD} eq "CR") {
$bgcolor = "#FF0000";
                                                 }
if ($hash_ALM_HIST{$hash_ALM_HIST}{GRD} eq "MJ") {
$bgcolor = "#FFA500";
                                                 }
if ($hash_ALM_HIST{$hash_ALM_HIST}{GRD} eq "MN") {
$bgcolor = "#FFFF00";
                                                 }
print (HTMLFILE "<tr bgcolor=$bgcolor>");
print (HTMLFILE "<td>$hash_ALM_HIST{$hash_ALM_HIST}{GRD}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST{$hash_ALM_HIST}{CODE}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST{$hash_ALM_HIST}{ALARM_TYPE}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST{$hash_ALM_HIST}{LOCATION}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST{$hash_ALM_HIST}{START_TIME}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST{$hash_ALM_HIST}{END_TIME}</td>");
print (HTMLFILE "</tr>");
                                                  }


print (HTMLFILE "</table><br>");

                                }




                 }



sub AUDIT_REPORT_4G {


my (%hash_FW_BASELINE, $hash_FW_BASELINE);
%hash_FW_BASELINE = ();

my ($LSM_LOAD_NAME);
if ($hash_enodeb_sw{$enodeb_name} eq "3.1.0") {
$hash_FW_BASELINE{RRH}{1900}{'0.1.3.0'} = "0.1.3.0";
$hash_FW_BASELINE{RRH}{1900}{'0.1.1.9'} = "0.1.1.9";
$hash_FW_BASELINE{RRH}{1900}{'0.2.6.0'} = "0.2.6.0";
$hash_FW_BASELINE{RRH}{1900}{'0.0.3.4'} = "0.0.3.4";
$hash_FW_BASELINE{RRH}{1900}{'0.3.3.0'} = "0.3.3.0";
$hash_FW_BASELINE{RRH}{1900}{'0.0.5.0'} = "0.0.5.0";

$hash_FW_BASELINE{RRH}{800}{'0.0.4.9'} = "0.0.4.9";
$hash_FW_BASELINE{RRH}{800}{'2.0.32.32'} = "2.0.32.32";


$hash_FW_BASELINE{UAMA}{BOOTER}{'3.5.1 VER=01'} = "3.5.1 VER=01";
$hash_FW_BASELINE{UAMA}{KERNEL_A}{'3.5.1 VER=17'} = "3.5.1 VER=17";
$hash_FW_BASELINE{UAMA}{CLOCK}{'0.1.4'} = "0.1.4";
$hash_FW_BASELINE{UAMA}{CTRL}{'0.1.4'} = "0.1.4";
$hash_FW_BASELINE{UAMA}{RFS_RAW}{'2.5.0'} = "2.5.0";
$hash_FW_BASELINE{UAMA}{RFS_A}{'3.5.1'} = "3.5.1";

$hash_FW_BASELINE{L9CA}{BOOTER}{'3.5.0'} = "3.5.0";
$hash_FW_BASELINE{L9CA}{KERNEL_A}{'3.5.1'} = "3.5.1";
$hash_FW_BASELINE{L9CA}{CLOCK}{'0.1.5'} = "0.1.5";
$hash_FW_BASELINE{L9CA}{CTRL}{'0.1.6'} = "0.1.6";
$hash_FW_BASELINE{L9CA}{RFS_RAW}{'2.5.0'} = "2.5.0";
$hash_FW_BASELINE{L9CA}{RFS_A}{'3.5.1 VER=22'} = "3.5.1 VER=22";

$hash_FW_BASELINE{EAIU}{INVT}{'0.1.12.26'} = "0.1.12.26";
$hash_FW_BASELINE{EAIU}{INVT}{'0.1.12.10'} = "0.1.12.10";
$hash_FW_BASELINE{EAIU}{INVT}{'1.0.0.24'} = "1.0.0.24";
$hash_FW_BASELINE{EAIU}{INVT}{'0.1.12.27'} = "0.1.12.27";


$hash_FW_BASELINE{GPS}{INVT}{'1.0.0.5'} = "1.0.0.5";


                                                    }


if ($hash_enodeb_sw{$enodeb_name} eq "3.5.2") {

$hash_FW_BASELINE{RRH}{1900}{'0.1.3.0'} = "0.1.3.0";
$hash_FW_BASELINE{RRH}{1900}{'0.1.1.9'} = "0.1.1.9";
$hash_FW_BASELINE{RRH}{1900}{'0.2.6.0'} = "0.2.6.0";
$hash_FW_BASELINE{RRH}{1900}{'0.0.3.4'} = "0.0.3.4";
$hash_FW_BASELINE{RRH}{1900}{'0.3.3.0'} = "0.3.3.0";
$hash_FW_BASELINE{RRH}{1900}{'0.0.5.0'} = "0.0.5.0";

$hash_FW_BASELINE{RRH}{800}{'0.0.4.9'} = "0.0.4.9";
$hash_FW_BASELINE{RRH}{800}{'2.0.32.32'} = "2.0.32.32";


$hash_FW_BASELINE{RRH}{'2_5'}{'1.0.6.1'} = "1.0.6.1";


$hash_FW_BASELINE{UAMA}{BOOTER}{'4.1.0 VER=01'} = "4.1.0 VER=01";
$hash_FW_BASELINE{UAMA}{KERNEL_A}{'5.0.0 VER=04'} = "5.0.0 VER=04";
$hash_FW_BASELINE{UAMA}{CLOCK}{'0.1.1'} = "0.1.1";
$hash_FW_BASELINE{UAMA}{CTRL}{'0.1.1'} = "0.1.1";
$hash_FW_BASELINE{UAMA}{RFS_RAW}{'3.5.1'} = "3.5.1";
$hash_FW_BASELINE{UAMA}{RFS_A}{'5.0.0'} = "5.0.0";

$hash_FW_BASELINE{L9CA}{BOOTER}{'5.0.0'} = "5.0.0";
$hash_FW_BASELINE{L9CA}{KERNEL_A}{'5.0.0'} = "5.0.0";
$hash_FW_BASELINE{L9CA}{CLOCK}{'0.1.4'} = "0.1.4";
$hash_FW_BASELINE{L9CA}{CTRL}{'0.1.2'} = "0.1.2";
$hash_FW_BASELINE{L9CA}{RFS_RAW}{'3.5.1'} = "3.5.1";
$hash_FW_BASELINE{L9CA}{RFS_A}{'5.0.0 VER=22'} = "5.0.0 VER=22";

$hash_FW_BASELINE{EAIU}{INVT}{'1.0.0.23'} = "1.0.0.23";

$hash_FW_BASELINE{GPS}{INVT}{'1.0.0.1'} = "1.0.0.1";


                                                     }

if ($hash_enodeb_sw{$enodeb_name} eq "4.0.0") {
$hash_FW_BASELINE{RRH}{1900}{'0.1.5.0'} = "0.1.5.0";
$hash_FW_BASELINE{RRH}{1900}{'0.1.0.0'} = "0.1.0.0";
$hash_FW_BASELINE{RRH}{800}{'0.0.4.9'} = "0.0.4.9";
$hash_FW_BASELINE{RRH}{800}{'2.0.32.32'} = "2.0.32.32";



$hash_FW_BASELINE{RRH}{'2_5'}{'1.1.0.5'} = "1.1.0.5";


$hash_FW_BASELINE{UAMA}{BOOTER}{'3.5.1 VER=01'} = "3.5.1 VER=01";
$hash_FW_BASELINE{UAMA}{KERNEL_A}{'5.5.0 VER=12'} = "5.5.0 VER=12";
$hash_FW_BASELINE{UAMA}{CLOCK}{'0.1.4'} = "0.1.4";
$hash_FW_BASELINE{UAMA}{CTRL}{'0.1.4'} = "0.1.4";
$hash_FW_BASELINE{UAMA}{RFS_RAW}{'2.5.0'} = "2.5.0";
$hash_FW_BASELINE{UAMA}{RFS_A}{'5.5.0'} = "5.5.0";

$hash_FW_BASELINE{L9CA}{BOOTER}{'3.5.0'} = "3.5.0";
$hash_FW_BASELINE{L9CA}{KERNEL_A}{'5.5.0'} = "5.5.0";
$hash_FW_BASELINE{L9CA}{CLOCK}{'0.1.5'} = "0.1.5";
$hash_FW_BASELINE{L9CA}{CTRL}{'0.1.6'} = "0.1.6";
$hash_FW_BASELINE{L9CA}{RFS_RAW}{'2.5.0'} = "2.5.0";
$hash_FW_BASELINE{L9CA}{RFS_A}{'5.5.0 VER=13'} = "5.5.0 VER=13";

$hash_FW_BASELINE{EAIU}{INVT}{'1.0.0.24'} = "1.0.0.24";
$hash_FW_BASELINE{EAIU}{INVT}{'0.1.12.27'} = "0.1.12.27";
$hash_FW_BASELINE{EAIU}{INVT}{'0.1.12.11'} = "0.1.12.11";

$hash_FW_BASELINE{GPS}{INVT}{'1.0.0.1'} = "1.0.0.1";
$hash_FW_BASELINE{GPS}{INVT}{'1.0.0.5'} = "1.0.0.5";


                                                    }

if ($hash_enodeb_sw{$enodeb_name} eq "4.0.3") {
$hash_FW_BASELINE{RRH}{1900}{'0.1.5.0'} = "0.1.5.0";
$hash_FW_BASELINE{RRH}{800}{'0.0.4.9'} = "0.0.4.9";
$hash_FW_BASELINE{RRH}{800}{'2.0.32.32'} = "2.0.32.32";



$hash_FW_BASELINE{RRH}{'2_5'}{'1.1.0.5'} = "1.1.0.5";


$hash_FW_BASELINE{UAMA}{BOOTER}{'5.5.0 VER=02'} = "5.5.0 VER=02";
$hash_FW_BASELINE{UAMA}{KERNEL_A}{'5.5.0 VER=12'} = "5.5.0 VER=12";
$hash_FW_BASELINE{UAMA}{CLOCK}{'0.1.4'} = "0.1.4";
$hash_FW_BASELINE{UAMA}{CTRL}{'0.1.4'} = "0.1.4";
$hash_FW_BASELINE{UAMA}{RFS_RAW}{'3.5.1'} = "3.5.1";
$hash_FW_BASELINE{UAMA}{RFS_A}{'5.5.0'} = "5.5.0";

$hash_FW_BASELINE{L9CA}{BOOTER}{'5.5.0'} = "5.5.0";
$hash_FW_BASELINE{L9CA}{KERNEL_A}{'5.5.0'} = "5.5.0";
$hash_FW_BASELINE{L9CA}{CLOCK}{'0.1.5'} = "0.1.5";
$hash_FW_BASELINE{L9CA}{CTRL}{'0.1.6'} = "0.1.6";
$hash_FW_BASELINE{L9CA}{RFS_RAW}{'3.5.1'} = "3.5.1";
$hash_FW_BASELINE{L9CA}{RFS_A}{'5.5.0 VER=18'} = "5.5.0 VER=18";

$hash_FW_BASELINE{EAIU}{INVT}{'0.1.12.21'} = "0.1.12.21";
$hash_FW_BASELINE{EAIU}{INVT}{'0.1.12.27'} = "0.1.12.27";

$hash_FW_BASELINE{GPS}{INVT}{'1.0.0.1'} = "1.0.0.1";
$hash_FW_BASELINE{GPS}{INVT}{'1.0.0.5'} = "1.0.0.5";


                                                    }


#############################################################################
# START CHECK IF FA_INDEX 1 RTRV_EUTRA_FA TO DETERMINE IF 2ND CARRIER 3,4,5 #
#############################################################################
my $IF_FA_INDEX_1 = 0;
my $IF_FA_INDEX_5 = 0;

foreach my $CELL_NUM (sort keys %hash_RTRV_EUTRA_FA) {
foreach my $FA_INDEX (sort {$a<=>$b} keys %{$hash_RTRV_EUTRA_FA{$CELL_NUM}}) {
if ($FA_INDEX eq "1") {
$IF_FA_INDEX_1++;
                      }
if ($FA_INDEX eq "5") {
$IF_FA_INDEX_5++;
                      }					  

                                                                             }
                                                     }
#############################################################################
# START CHECK IF FA_INDEX 1 RTRV_EUTRA_FA TO DETERMINE IF 2ND CARRIER 3,4,5 #
#############################################################################


#######################################
# START CHECK IF CELL_NUM 3,4,5,6,7,8 #
#######################################
my $IF_CELL_2ND_CARR = 0;
foreach $CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_CELL_CONF) {
if (($CELL_NUM >= 3) && ($CELL_NUM <= 8)) {
$IF_CELL_2ND_CARR++;
                                          }

                                                             }

#print ("$IF_FA_INDEX_1 $IF_CELL_2ND_CARR\n");
#######################################
#  END CHECK IF CELL_NUM 3,4,5,6,7,8  #
#######################################

######################################
# START GET MME INFORATION FROM HASH #
######################################
my $bucket_for_mme_info = "$hash_enodeb_bucket{$enodeb_name}";
$bucket_for_mme_info =~ s/_TEST.*//g;
$bucket_for_mme_info =~ s/_GROW.*//g;
$bucket_for_mme_info =~ s/_COMMERCIAL.*//g;
$bucket_for_mme_info =~ s/_GMR.*//g;
$bucket_for_mme_info =~ s/\s+//g;
$bucket_for_mme_info = uc($bucket_for_mme_info);

#print ("$bucket_for_mme_info\n");


$lsm_name =~ s/\s+//g;

my (%hash_ENODEB_MME, $hash_ENODEB_MME);
%hash_ENODEB_MME = ();

foreach my $MME (sort keys %{$hash_MME_INFO{$lsm_name}{$bucket_for_mme_info}}) {
my $MME_IP = "$hash_MME_INFO{$lsm_name}{$bucket_for_mme_info}{$MME}";

$hash_ENODEB_MME{$MME} = "$MME_IP";
#print ("$lsm_name $bucket_for_mme_info $MME $MME_IP\n");

                                                                               }
#print Dumper(\%hash_ENODEB_MME);




######################################
#  END GET MME INFORATION FROM HASH  #
######################################



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=0>\n");
print (HTMLFILE "<tr><td align=center><font size=+3><b><u>4G AUDIT FOR $day $month $mday $year $hour:$minute:$second</u></b></font></td></tr>");
print (HTMLFILE "</table>");

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CASCADE</th><th>ENODEB ID</th><th>ENODEB NAME</th><th>LSM NAME</th><th>LSM IP</th><th>MARKET</th><th>SPRINT 4G ONAIR</th><th>4G COMMERICAL (LSM)</th><th>ENODEB BUCKET (LSM)</th><th>ENODEB IP</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$cascade</td>");
print (HTMLFILE "<td>$enodeb_id</td>");
print (HTMLFILE "<td>$enodeb_name</td>");
print (HTMLFILE "<td>$lsm_name</td>");
print (HTMLFILE "<td>$lsm_ip</td>");
print (HTMLFILE "<td>$market</td>");

print (HTMLFILE "<td>$onair_4g</td>");
my ($commerical_4G);
if ($hash_enodeb_bucket{$enodeb_name} =~ m/COMMERCIAL/) {
$commerical_4G = "YES";
                                                        }
else {
$commerical_4G = "NO";
     }
if ($commerical_4G eq "$onair_4g") {
print (HTMLFILE "<td>$commerical_4G</td>");
                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$commerical_4G</td>");
     }
print (HTMLFILE "<td>$hash_enodeb_bucket{$enodeb_name}</td>");
if ($enodeb_ip_address_LSM =~ m/\d+\.\d+\.\d+\.\d+/) {
print (HTMLFILE "<td>$enodeb_ip_address_LSM</td>");
                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$enodeb_ip_address_LSM</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=4 align=center><font size=+2><b>4G IPs</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>VALUES FROM</th><th>4G CSR_OAM_IP</th><th>4G MMBS_OAM_IP</th><th>MMBS_S_B_IP</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td>$CSR_OAM_IP_4G</td>");
print (HTMLFILE "<td>$MMBS_OAM_IP_4G</td>");
print (HTMLFILE "<td>$MMBS_S_B_IP_4G</td>");

print (HTMLFILE "</tr>");

if (!$ip_add_nok) {		#start if not $ip_add_nok
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>LSM</td>");
if ($CSR_OAM_IP_4G_LSM eq "$CSR_OAM_IP_4G") {
print (HTMLFILE "<td>$CSR_OAM_IP_4G_LSM</td>");
                                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CSR_OAM_IP_4G_LSM</td>");
     }

if ($MMBS_OAM_IP_4G_LSM eq "$MMBS_OAM_IP_4G") {
print (HTMLFILE "<td>$MMBS_OAM_IP_4G_LSM</td>");
                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$MMBS_OAM_IP_4G_LSM</td>");
     }

if ($MMBS_S_B_IP_4G_LSM eq "$MMBS_S_B_IP_4G") {
print (HTMLFILE "<td>$MMBS_S_B_IP_4G_LSM</td>");
                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$MMBS_S_B_IP_4G_LSM</td>");
     }
print (HTMLFILE "</tr>");
                  }		#end if not $ip_add_nok

else {		#start else if $ip_add_nok
print (HTMLFILE "<tr>");
print (HTMLFILE "<td colspan=4 align=center bgcolor=#FF0000><font size=4><b>$ip_add_nok</b></font></td>");
print (HTMLFILE "</tr>");
     }		#end else if $ip_add_nok

print (HTMLFILE "<tr bgcolor=#FFFF00><th>VALUES FROM</th><th colspan=1>DB_INDEX</th><th colspan=2>CSR_S_B_IP</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td colspan=1><font color=#FFFFFF>-</font></td>");
print (HTMLFILE "<td colspan=2>$CSR_S_B_IP_4G</td>");
print (HTMLFILE "</tr>");

if (!$ip_rt_nok) {		#start if not $ip_rt_nok
if ($csr_s_b_ip_count) {
foreach $hash_CSR_S_B_IP_4G_LSM (sort keys %hash_CSR_S_B_IP_4G_LSM) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>LSM</td>");
print (HTMLFILE "<td colspan=1>$hash_CSR_S_B_IP_4G_LSM</td>");
if ($hash_CSR_S_B_IP_4G_LSM{$hash_CSR_S_B_IP_4G_LSM} eq "$CSR_S_B_IP_4G") {
print (HTMLFILE "<td colspan=2>$hash_CSR_S_B_IP_4G_LSM{$hash_CSR_S_B_IP_4G_LSM}</td>");
                                                                          }
else {
print (HTMLFILE "<td colspan=2 bgcolor=#FF0000>$hash_CSR_S_B_IP_4G_LSM{$hash_CSR_S_B_IP_4G_LSM}</td>");
     }
print (HTMLFILE "</tr>");
                                                                    }
                       }
                 }		#end if not $ip_rt_nok
else {				#start else if $ip_rt_nok
print (HTMLFILE "<tr>");
print (HTMLFILE "<td colspan=4 align=center bgcolor=#FF0000><font size=4><b>$ip_rt_nok</b></font></td>");
print (HTMLFILE "</tr>");
     }				#end else if $ip_rt_nok
print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-SYS-CONF - RETRIEVE SYSTEM CONFIGURATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>VALUES FROM</th><th>SYS_TYPE</th></tr>");
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td>$MMBS_Cabinet_Type</td>");
print (HTMLFILE "</tr>");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>LSM</td>");
if ($hash_SYS_CONF{$enodeb_name} eq "$MMBS_Cabinet_Type") {
print (HTMLFILE "<td>$hash_SYS_CONF{$enodeb_name}</td>");
                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_SYS_CONF{$enodeb_name}</td>");
     }
print (HTMLFILE "</tr>");
print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>4G PCI-RACH-TAC INFORMATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>VALUES FROM</th><th>SECTOR</th><th>PCI</th><th>RACH</th><th>TAC</th><th>CELL_RESERVED_OP_USE0</th></tr>");

my ($COMM_INFO);
if (($commerical_4G eq "YES") || ($onair_4g eq "YES")) {
$COMM_INFO = "YES";
                                                       }
else {
$COMM_INFO = "NO";
     }

foreach $hash_sector_pci_rach_tac (sort {$a<=>$b} keys %hash_sector_pci_rach_tac) {
my $sector_pci_rach_tac = $hash_sector_pci_rach_tac;
#$hash_sector_pci_rach_tac = ($hash_sector_pci_rach_tac -1);
$hash_sector_pci_rach_tac = $hash_sector_pci_rach_tac;

if ($hash_sector_pci_rach_tac eq "$hash_IDLE_CELL_NUM{$hash_sector_pci_rach_tac}") {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td>$hash_sector_pci_rach_tac</td>");
print (HTMLFILE "<td>$hash_pci{$sector_pci_rach_tac}</td>");
print (HTMLFILE "<td>$hash_rach{$sector_pci_rach_tac}</td>");
print (HTMLFILE "<td>$tac_hex</td>");
print (HTMLFILE "<td><font color=#FFFFFF>-</font></td>");

print (HTMLFILE "</tr>");
                                                                                   }
                                                                                  }

if (!$cell_idle_nok) {			#start if not $cell_idle_nok
foreach $hash_IDLE_CELL_NUM (sort {$a<=>$b} keys %hash_IDLE_CELL_NUM) {
my $sector_number = $hash_IDLE_CELL_NUM;
print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>LSM</td>");
print (HTMLFILE "<td>$hash_IDLE_CELL_NUM</td>");

if ($hash_IDLE_PHY_CELL_ID{$hash_IDLE_CELL_NUM} eq "$hash_pci{$sector_number}") {
print (HTMLFILE "<td>$hash_IDLE_PHY_CELL_ID{$hash_IDLE_CELL_NUM}</td>");
                                                                                }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_IDLE_PHY_CELL_ID{$hash_IDLE_CELL_NUM}</td>");
     }

if ($hash_4g_ROOT_SEQUENCE_INDEX{$hash_IDLE_CELL_NUM} eq "$hash_rach{$sector_number}") {
print (HTMLFILE "<td>$hash_4g_ROOT_SEQUENCE_INDEX{$hash_IDLE_CELL_NUM}</td>");
                                                                                       }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_4g_ROOT_SEQUENCE_INDEX{$hash_IDLE_CELL_NUM}</td>");
     }

if ($hash_4g_tac{$hash_IDLE_CELL_NUM} eq "$tac_hex") {
print (HTMLFILE "<td>$hash_4g_tac{$hash_IDLE_CELL_NUM}</td>");
                                                     }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_4g_tac{$hash_IDLE_CELL_NUM}</td>");
     }


if (($hash_4g_cell_reserved{$hash_IDLE_CELL_NUM} eq "ci_notReserved") || ($hash_4g_cell_reserved{$hash_IDLE_CELL_NUM} eq "notReserved")) {
print (HTMLFILE "<td>$hash_4g_cell_reserved{$hash_IDLE_CELL_NUM}</td>");
                                                                                                                                         }

else {
print (HTMLFILE "<td bgcolor=#FFFF00>$hash_4g_cell_reserved{$hash_IDLE_CELL_NUM}</td>");
     }




print (HTMLFILE "</tr>");

                                                                       }

                    }			#end if not $cell_idle_nok

else {					#start if $cell_idle_nok
print (HTMLFILE "<tr><td colspan=9 bgcolor=#FF0000 align=center><font size=3><b>$cell_idle_nok</b></font></td></tr>");
     }					#end if $cell_idle_nok
print (HTMLFILE "</table><br>");






print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=9 align=center><font size=+2><b>4G GPS LATITUDE & LONGITUDE</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th colspan=1><font color=#FFFF00>-</font></th><th colspan=4>LATITUDE</th><th colspan=4>LONGITUDE</th></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00>");
print (HTMLFILE "<th>VALUES FROM</th>");
print (HTMLFILE "<th>DIRECTION</th>");
print (HTMLFILE "<th>DEGREES</th>");
print (HTMLFILE "<th>MINUTES</th>");
print (HTMLFILE "<th>SECONDS</th>");
print (HTMLFILE "<th>DIRECTION</th>");
print (HTMLFILE "<th>DEGREES</th>");
print (HTMLFILE "<th>MINUTES</th>");
print (HTMLFILE "<th>SECONDS</th>");
print (HTMLFILE "</tr>");

print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>DATABASE</td>");
print (HTMLFILE "<td>$lat_direction</td>");
print (HTMLFILE "<td>$lat_degree</td>");
print (HTMLFILE "<td>$lat_minutes</td>");
print (HTMLFILE "<td>$dot_sec_value</td>");
print (HTMLFILE "<td>$long_direction</td>");
print (HTMLFILE "<td>$long_degree</td>");
print (HTMLFILE "<td>$long_minutes</td>");
print (HTMLFILE "<td>$dot_sec_value_long</td>");
print (HTMLFILE "</tr>");


if (!$gps_nok) {			#start if not $gps_nok

print (HTMLFILE "<tr>");
print (HTMLFILE "<td bgcolor=#EEEEEE>LSM</td>");
if ($hash_lat_direction{$cascade} eq "$lat_direction") {
print (HTMLFILE "<td>$hash_lat_direction{$cascade}</td>");
                                                       }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_lat_direction{$cascade}</td>");
     }

if ($hash_lat_degrees{$cascade} eq "$lat_degree") {
print (HTMLFILE "<td>$hash_lat_degrees{$cascade}</td>");
                                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_lat_degrees{$cascade}</td>");
     }

if ($hash_lat_minutes{$cascade} eq "$lat_minutes") {
print (HTMLFILE "<td>$hash_lat_minutes{$cascade}</td>");
                                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_lat_minutes{$cascade}</td>");
     }

if ($hash_lat_seconds{$cascade} eq "$dot_sec_value") {
print (HTMLFILE "<td>$hash_lat_seconds{$cascade}</td>");
                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_lat_seconds{$cascade}</td>");
     }

if ($hash_long_direction{$cascade} eq "$long_direction") {
print (HTMLFILE "<td>$hash_long_direction{$cascade}</td>");
                                                         }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_long_direction{$cascade}</td>");
     }

if ($hash_long_degrees{$cascade} eq "$long_degree") {
print (HTMLFILE "<td>$hash_long_degrees{$cascade}</td>");
                                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_long_degrees{$cascade}</td>");
     }

if ($hash_long_minutes{$cascade} eq "$long_minutes") {
print (HTMLFILE "<td>$hash_long_minutes{$cascade}</td>");
                                                     }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_long_minutes{$cascade}</td>");
     }

if ($hash_long_seconds{$cascade} eq "$dot_sec_value_long") {
print (HTMLFILE "<td>$hash_long_seconds{$cascade}</td>");
                                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_long_seconds{$cascade}</td>");
     }

print (HTMLFILE "</tr>");

               }			#end if not $gps_nok

else {					#start if $gps_nok
print (HTMLFILE "<tr><td colspan=9 bgcolor=#FF0000 align=center><font size=3><b>$gps_nok</b></font></td></tr>");
     }					#end if $gps_nok

print (HTMLFILE "</table><br>");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>RTRV-CELL-CONF - RETRIEVE CELL CONFIGURATION</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>STATUS</th><th>ADMINISTRATIVE_STATE</th></tr>");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_CELL_CONF) {
foreach my $CELL_STATUS (sort keys %{$hash_RTRV_CELL_CONF{$CELL_NUM}}) {
my $ADMINISTRATIVE_STATE = "$hash_RTRV_CELL_CONF{$CELL_NUM}{$CELL_STATUS}";
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CELL_NUM</td>");
print (HTMLFILE "<td>$CELL_STATUS</td>");
if ($ADMINISTRATIVE_STATE eq "unlocked") {
if ($commerical_4G eq "YES") {
print (HTMLFILE "<td>$ADMINISTRATIVE_STATE</td>");
                             }
if ($commerical_4G eq "NO") {
print (HTMLFILE "<td bgcolor=#FF0000>$ADMINISTRATIVE_STATE</td>");
                            }
                                         }
else {
print (HTMLFILE "<td>$ADMINISTRATIVE_STATE</td>");
     }
print (HTMLFILE "</tr>");
                                                                       }

                                                                }
print (HTMLFILE "</table><br>");

###################################################
#  START FIND MISSING MME CONFIGURATION ON ENODEB #
###################################################
my (%hash_MISSING_MME_CONFIG, $hash_MISSING_MME_CONFIG);
%hash_MISSING_MME_CONFIG = ();

foreach $hash_ENODEB_MME (sort keys %hash_ENODEB_MME) {
my $MME_NAME_INFO = "$hash_s1_mme_name{$hash_s1_mme_index}";

if (!grep { $_ eq "$hash_ENODEB_MME" } values %hash_s1_mme_name ) {
$hash_MISSING_MME_CONFIG{$hash_ENODEB_MME} = "$hash_ENODEB_MME{$hash_ENODEB_MME}";
                                                                  }
                                                      }

my $count_missing_mme = keys %hash_MISSING_MME_CONFIG;
###################################################
#   END FIND MISSING MME CONFIGURATION ON ENODEB  #
###################################################


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>4G S1 STATUS</b></font></td></tr>");
if (!$s1_nok) {		#start if s1 not nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>MME_INDEX</th><th>MME_ID</th><th>SCTP_STATE</th><th>S1AP_STATE</th><th>MME_NAME</th><th>MME_IP_V4</th></tr>");

foreach $hash_s1_mme_index (sort {$a<=>$b} keys %hash_s1_mme_index) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_s1_mme_index</td>");
print (HTMLFILE "<td>$hash_s1_mme_id{$hash_s1_mme_index}</td>");
if ($hash_s1_mme_sctp{$hash_s1_mme_index} eq "enabled") {
print (HTMLFILE "<td>$hash_s1_mme_sctp{$hash_s1_mme_index}</td>");
                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_s1_mme_sctp{$hash_s1_mme_index}</td>");
     }
if ($hash_s1_s1ap{$hash_s1_mme_index} eq "enabled") {
print (HTMLFILE "<td>$hash_s1_s1ap{$hash_s1_mme_index}</td>");
                                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_s1_s1ap{$hash_s1_mme_index}</td>");
     }

my $MME_NAME_INFO = "$hash_s1_mme_name{$hash_s1_mme_index}";
if ($hash_ENODEB_MME{$MME_NAME_INFO}) {
print (HTMLFILE "<td>$hash_s1_mme_name{$hash_s1_mme_index}</td>");
                                      }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_s1_mme_name{$hash_s1_mme_index}</td>");
     }

my $MME_IP_INFO = "$hash_s1_mme_ip_v4{$hash_s1_mme_index}";
if ($MME_IP_INFO eq "$hash_ENODEB_MME{$MME_NAME_INFO}") {
print (HTMLFILE "<td>$hash_s1_mme_ip_v4{$hash_s1_mme_index}</td>");
                                                        }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_s1_mme_ip_v4{$hash_s1_mme_index}</td>");
     }
print (HTMLFILE "</tr>");



                                                                  }

######################################
# START IF MISSING MME CONFIGURATION #
######################################
if ($count_missing_mme > 0) {
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=6 align=center><font size=+2><b>MISSING MME CONFIGURATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th colspan=3>MME_NAME</th><th colspan=3>MME_IP_V4</th></tr>");

foreach my $MISSING_MME (sort keys %hash_MISSING_MME_CONFIG) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td colspan=3 bgcolor=#FF0000>$MISSING_MME</td>");
print (HTMLFILE "<td colspan=3 bgcolor=#FF0000>$hash_MISSING_MME_CONFIG{$MISSING_MME}</td>");
print (HTMLFILE "</tr>");
                                                             }
                            }
######################################
#  END IF MISSING MME CONFIGURATION  #
######################################



              }		#end if s1 not nok
else {			#start else if s1 nok
print (HTMLFILE "<tr><td bgcolor=#FF0000 align=center><font size=3><b>$s1_nok</b></font></td></tr>");
     }			#end else if s1 nok
print (HTMLFILE "</table><br>\n");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=7 align=center><font size=+2><b>RTRV-CELL-IDLE - RETRIEVE EUTRAN CELL CONF IDLE</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>DL_ANT_COUNT</th><th>UL_ANT_COUNT</th><th>EARFCN_DL</th><th>EARFCN_UL</th><th>DL_BANDWIDTH</th><th>UL_BANDWIDTH</th></tr>");



if (!$cell_idle_nok) {			#start if not $cell_idle_nok
foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_CELL_IDLE_INFO) {
my $DL_ANT_COUNT = $hash_CELL_IDLE_INFO{$CELL_NUM}{DL_ANT_COUNT};
my $UL_ANT_COUNT = $hash_CELL_IDLE_INFO{$CELL_NUM}{UL_ANT_COUNT};
my $EARFCN_DL = $hash_CELL_IDLE_INFO{$CELL_NUM}{EARFCN_DL};
my $EARFCN_UL = $hash_CELL_IDLE_INFO{$CELL_NUM}{EARFCN_UL};
my $DL_BANDWIDTH = $hash_CELL_IDLE_INFO{$CELL_NUM}{DL_BANDWIDTH};
my $UL_BANDWIDTH = $hash_CELL_IDLE_INFO{$CELL_NUM}{UL_BANDWIDTH};
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CELL_NUM</td>");
print (HTMLFILE "<td>$DL_ANT_COUNT</td>");
print (HTMLFILE "<td>$UL_ANT_COUNT</td>");
print (HTMLFILE "<td>$EARFCN_DL</td>");
print (HTMLFILE "<td>$EARFCN_UL</td>");
print (HTMLFILE "<td>$DL_BANDWIDTH</td>");
print (HTMLFILE "<td>$UL_BANDWIDTH</td>");
print (HTMLFILE "</tr>");
                                                                }
                      }			#end if not $cell_idle_nok

else {					#start if $cell_idle_nok
print (HTMLFILE "<tr><td colspan=7 bgcolor=#FF0000 align=center><font size=3><b>$cell_idle_nok</b></font></td></tr>");
     }					#start if $cell_idle_nok

print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=7 align=center><font size=+2><b>4G FIRMWARE CHECK</b></font></td></tr>");
if (!$firm_nok) {			#start if not $firm_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>PRC_UNIT_TYPE</th><th>PRC_UNIT_ID</th><th>LOC_TYPE</th><th>ID</th><th>TYPE</th><th>NAME</th><th>VERSION</th></tr>");

foreach $array_prc_fw (@array_prc_fw) {
@_ = split(/,/, $array_prc_fw);
if ($_[2] eq "RUNNING") {			#start if RUNNING
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$_[0]</td>");
print (HTMLFILE "<td>$_[1]</td>");
print (HTMLFILE "<td>$_[2]</td>");
print (HTMLFILE "<td>$_[3]</td>");
print (HTMLFILE "<td>$_[4]</td>");
print (HTMLFILE "<td>$_[5]</td>");
if ($_[4] eq "RFS_RAW") {
#if ($_[6] eq "2.5.0") {
if ($hash_FW_BASELINE{UAMA}{RFS_RAW}{$_[6]}) {
print (HTMLFILE "<td>$_[6]</td>");
                                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }
                       }

if ($_[4] eq "BOOTER") {
my $REL_VER_BOOT = "$_[6] VER=$_[7]";
if ($_[0] =~ m/UMP/) {
#if ($REL_VER_BOOT eq "3.5.1 REL_VER=01") {
if ($hash_FW_BASELINE{UAMA}{BOOTER}{$REL_VER_BOOT}) {

print (HTMLFILE "<td>$REL_VER_BOOT</td>");
                                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$REL_VER_BOOT</td>");
     }
                     }

if ($_[0] =~ m/ECP/) {
#if ($_[6] eq "3.5.0") {
if ($hash_FW_BASELINE{L9CA}{BOOTER}{$_[6]}) {

print (HTMLFILE "<td>$_[6]</td>");
                                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }
                     }

                       }

if ($_[4] eq "KERNEL_A") {
my $REL_VER_KERNEL_A = "$_[6] VER=$_[7]";
if ($_[0] =~ m/UMP/) {
#if ($REL_VER_KERNEL_A eq "3.5.1 REL_VER=17") {
if ($hash_FW_BASELINE{UAMA}{KERNEL_A}{$REL_VER_KERNEL_A}) {
print (HTMLFILE "<td>$REL_VER_KERNEL_A</td>");
                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$REL_VER_KERNEL_A</td>");
     }
                     }

if ($_[0] =~ m/ECP/) {
if ($hash_FW_BASELINE{L9CA}{KERNEL_A}{$_[6]}) {
print (HTMLFILE "<td>$_[6]</td>");
                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }
                     }

                         }


if ($_[4] eq "RFS_A") {
if ($_[0] =~ m/UMP/) {
if ($hash_FW_BASELINE{UAMA}{RFS_A}{$_[6]}) {
print (HTMLFILE "<td>$_[6]</td>");
                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }
                     }

if ($_[0] =~ m/ECP/) {
my $REL_VER_RFS_A = "$_[6] VER=$_[7]";
if ($hash_FW_BASELINE{L9CA}{RFS_A}{$REL_VER_RFS_A}) {
print (HTMLFILE "<td>$REL_VER_RFS_A</td>");
                                                    }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$REL_VER_RFS_A</td>");
     }
                     }

                      }


if (($_[0] eq "ECP") && ($_[4] eq "EPLD")) {
if ($_[5] =~ m/ctrl/) {
if ($hash_FW_BASELINE{L9CA}{CTRL}{$_[6]}) {
print (HTMLFILE "<td>$_[6]</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }
                      }



if ($_[5] =~ m/clock/) {
if ($hash_FW_BASELINE{L9CA}{CLOCK}{$_[6]}) {
print (HTMLFILE "<td>$_[6]</td>");
                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }
                       }


                                           }

if (($_[0] eq "UMP") && ($_[4] eq "EPLD")) {
if ($_[5] =~ m/ctrl/) {
if ($hash_FW_BASELINE{UAMA}{CTRL}{$_[6]}) {
print (HTMLFILE "<td>$_[6]</td>");
                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }
                      }


if ($_[5] =~ m/clock/) {
if ($hash_FW_BASELINE{UAMA}{CLOCK}{$_[6]}) {
print (HTMLFILE "<td>$_[6]</td>");
                                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$_[6]</td>");
     }

                      }


                                           }





print (HTMLFILE "</tr>");

                        }			#end if RUNNING
                                      }

                }			#end if not $firm_nok

else {			#start else if $firm_nok
print (HTMLFILE "<tr><td colspan=7 bgcolor=#FF0000 align=center><font size=3><b>$firm_nok</b></font></td></tr>");
     }			#end else if $firm_nok

print (HTMLFILE "</table><br>");

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=2 align=center bgcolor=#FFFF00><font size=+2><b>4G SOFTWARE CHECK</b></font></td></tr>\n");
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td bgcolor=#EEEEEE>VERSION</td>\n");
if ($hash_enodeb_sw{$enodeb_name} eq "$LSM_LOAD_NAME") {
print (HTMLFILE "<td>$hash_enodeb_sw{$enodeb_name}</td>\n");
                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_enodeb_sw{$enodeb_name}</td>\n");
     }
print (HTMLFILE "</tr>\n");


print (HTMLFILE "</table><br>\n");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=10 align=center><font size=+2><b>RTRV-NBR-EUTRAN - RETRIEVE EXTERNAL EUTRAN CELL FDD INFORMATION</b></font></td></tr>");

if (!$nbr_eutran_nok) {	#start if !$nbr_eutran_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>RELATION_IDX</th><th>STATUS</th><th>ENB_ID</th><th>TARGET_CELL_NUM</th><th>PHY_CELL_ID</th><th>TAC</th><th>IS_REMOVE_ALLOWED</th><th>IS_HOALLOWED</th><th>IND_OFFSET</th></tr>");


foreach $hash_RTRV_NBR_EUTRAN_CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_NBR_EUTRAN_CELL_NUM) {
foreach $hash_RTRV_NBR_EUTRAN_REL_IDX (sort {$a<=>$b} keys %hash_RTRV_NBR_EUTRAN_REL_IDX) {
my $CELL_NUM = $hash_RTRV_NBR_EUTRAN_CELL_NUM;
my $RELATION_IDX = $hash_RTRV_NBR_EUTRAN_REL_IDX;
my $STATUS = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{STATUS};
my $ENB_ID = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{ENB_ID};
my $TARGET_CELL_ID = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{TARGET_CELL_ID};
my $PHY_CELL_ID = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{PHY_CELL_ID};
my $IS_REMOVE_ALLOWED = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{IS_REMOVE_ALLOWED};
my $IS_HOALLOWED = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{IS_HOALLOWED};
my $TAC = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{TAC};
my $IND_OFFSET = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{IND_OFFSET};


if ($STATUS) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
print (HTMLFILE "<td>$RELATION_IDX</td>\n");
print (HTMLFILE "<td>$STATUS</td>\n");
print (HTMLFILE "<td>$ENB_ID</td>\n");
print (HTMLFILE "<td>$TARGET_CELL_ID</td>\n");
print (HTMLFILE "<td>$PHY_CELL_ID</td>\n");
#print (HTMLFILE "<td>$TAC</td>\n");
################################
 
if ($TAC eq "H'0000")                              {
print (HTMLFILE "<td bgcolor=#FF0000>$TAC</td>\n");
                                                   }
else {
print (HTMLFILE "<td>$TAC</td>\n");
     }
########################
# START FOR INTRA NBRS #
########################
if ($ENB_ID eq "$enodeb_id") {
if ($IS_REMOVE_ALLOWED eq "False") {
print (HTMLFILE "<td>$IS_REMOVE_ALLOWED</td>\n");
                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_REMOVE_ALLOWED</td>\n");
     }
                             }
########################
#  END FOR INTRA NBRS  #
########################

if ($ENB_ID ne "$enodeb_id") {
if ($IS_REMOVE_ALLOWED eq "True") {
print (HTMLFILE "<td>$IS_REMOVE_ALLOWED</td>\n");
                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_REMOVE_ALLOWED</td>\n");
     }
                             }

if ($IS_HOALLOWED eq "True") {
print (HTMLFILE "<td>$IS_HOALLOWED</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_HOALLOWED</td>\n");
     }

print (HTMLFILE "<td>$IND_OFFSET</td>\n");
print (HTMLFILE "</tr>");
             }
                                                                                          }
                                                                                            }


                      }	#end if !$nbr_eutran_nok

else {			#start else if $nbr_eutran_nok
print (HTMLFILE "<tr><td colspan=8 bgcolor=#FF0000 align=center><font size=3><b>$nbr_eutran_nok</b></font></td></tr>");
     }			#end else if $nbr_eutran_nok

print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=10 align=center><font size=+2><b>INTRA NBRs</b></font></td></tr>");

if (!$nbr_eutran_nok) {	#start if !$nbr_eutran_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>RELATION_IDX</th><th>STATUS</th><th>ENB_ID</th><th>TARGET_CELL_NUM</th><th>PHY_CELL_ID</th><th>TAC</th><th>IS_REMOVE_ALLOWED</th><th>IS_HOALLOWED</th><th>IND_OFFSET</th></tr>");


foreach $hash_RTRV_NBR_EUTRAN_CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_NBR_EUTRAN_CELL_NUM) {
foreach $hash_RTRV_NBR_EUTRAN_REL_IDX (sort {$a<=>$b} keys %hash_RTRV_NBR_EUTRAN_REL_IDX) {
my $CELL_NUM = $hash_RTRV_NBR_EUTRAN_CELL_NUM;
my $RELATION_IDX = $hash_RTRV_NBR_EUTRAN_REL_IDX;
my $STATUS = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{STATUS};
my $ENB_ID = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{ENB_ID};
my $TARGET_CELL_ID = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{TARGET_CELL_ID};
my $PHY_CELL_ID = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{PHY_CELL_ID};
my $IS_REMOVE_ALLOWED = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{IS_REMOVE_ALLOWED};
my $IS_HOALLOWED = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{IS_HOALLOWED};
my $TAC = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{TAC};
my $IND_OFFSET = $hash_RTRV_NBR_EUTRAN{$CELL_NUM}{$RELATION_IDX}{IND_OFFSET};

if (($STATUS) && ($ENB_ID eq $enodeb_id)) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
print (HTMLFILE "<td>$RELATION_IDX</td>\n");
print (HTMLFILE "<td>$STATUS</td>\n");
print (HTMLFILE "<td>$ENB_ID</td>\n");
print (HTMLFILE "<td>$TARGET_CELL_ID</td>\n");
print (HTMLFILE "<td>$PHY_CELL_ID</td>\n");
#print (HTMLFILE "<td>$TAC</td>\n");

########################
# START FOR INTRA NBRS #
########################
################################
if ($ENB_ID eq "$enodeb_id") {
 
if ($TAC eq "H'0000")                              {
print (HTMLFILE "<td bgcolor=#FF0000>$TAC</td>\n");
                                                   }
else {
print (HTMLFILE "<td>$TAC</td>\n");
     }
                             }
################################
if ($ENB_ID eq "$enodeb_id") {
if ($IS_REMOVE_ALLOWED eq "False") {
print (HTMLFILE "<td>$IS_REMOVE_ALLOWED</td>\n");
                                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_REMOVE_ALLOWED</td>\n");
     }
	 
                             }
########################
#  END FOR INTRA NBRS  #
########################

if ($ENB_ID ne "$enodeb_id") {
if ($IS_REMOVE_ALLOWED eq "True") {
print (HTMLFILE "<td>$IS_REMOVE_ALLOWED</td>\n");
                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_REMOVE_ALLOWED</td>\n");
     }
                             }




if ($IS_HOALLOWED eq "True") {
print (HTMLFILE "<td>$IS_HOALLOWED</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_HOALLOWED</td>\n");
     }
print (HTMLFILE "<td>$IND_OFFSET</td>\n");
print (HTMLFILE "</tr>");
                                          }
                                                                                          }
                                                                                            }


                      }	#end if !$nbr_eutran_nok

else {			#start else if $nbr_eutran_nok
print (HTMLFILE "<tr><td colspan=8 bgcolor=#FF0000 align=center><font size=3><b>$nbr_eutran_nok</b></font></td></tr>");
     }			#end else if $nbr_eutran_nok

print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=3 align=center><font size=+2><b>RTRV-RRH-INVT - RRH INVENTORY LIST</b></font></td></tr>");
if (!$rrh_invt_nok) {	#start if not $rrh_invt_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CONN_BD_ID</th><th>CONN_PORT_ID</th><th>FW_VERSION</th></tr>");

foreach my $CONN_BD_ID (sort keys %hash_RTRV_RRH_INVT) {
foreach my $CONN_PORT_ID (sort keys %{$hash_RTRV_RRH_INVT{$CONN_BD_ID}}) {
my $FW_VERSION = $hash_RTRV_RRH_INVT{$CONN_BD_ID}{$CONN_PORT_ID}{FW_VERSION};
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CONN_BD_ID</td>\n");
print (HTMLFILE "<td>$CONN_PORT_ID</td>\n");
if (($CONN_PORT_ID eq "0") || ($CONN_PORT_ID eq "1") || ($CONN_PORT_ID eq "2")) {
#if (($FW_VERSION eq "0.1.1.9") || ($FW_VERSION eq "0.2.6.0") || ($FW_VERSION eq "0.0.3.4") || ($FW_VERSION eq "0.3.3.0") || ($FW_VERSION eq "0.0.5.0")) {
if ($hash_FW_BASELINE{RRH}{1900}{$FW_VERSION}) {
print (HTMLFILE "<td>$FW_VERSION</td>\n");
                                               }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$FW_VERSION</td>\n");
     }
                                                                                }

if (($CONN_PORT_ID eq "3") || ($CONN_PORT_ID eq "4") || ($CONN_PORT_ID eq "5")) {
#if (($FW_VERSION eq "0.0.4.9") || ($FW_VERSION eq "2.0.32.32")) {
if ($hash_FW_BASELINE{RRH}{800}{$FW_VERSION}) {
print (HTMLFILE "<td>$FW_VERSION</td>\n");
                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$FW_VERSION</td>\n");
     }
                                                                                }
print (HTMLFILE "</tr>");
                                                                         }


                                                       }

                    }	#end if not $rrh_invt_nok

else {	#start else if $rrh_invt_nok
print (HTMLFILE "<tr><td colspan=3 bgcolor=#FF0000 align=center><font size=3><b>$rrh_invt_nok</b></font></td></tr>");
     }	#end else if $rrh_invt_nok
print (HTMLFILE "</table><br>");

my (%hash_DL_MAX_TX_PWR, $hash_DL_MAX_TX_PWR);
%hash_DL_MAX_TX_PWR = ();

$hash_DL_MAX_TX_PWR{0} = "370";
$hash_DL_MAX_TX_PWR{1} = "370";
$hash_DL_MAX_TX_PWR{2} = "370";

$hash_DL_MAX_TX_PWR{3} = "370";
$hash_DL_MAX_TX_PWR{4} = "370";
$hash_DL_MAX_TX_PWR{5} = "370";

$hash_DL_MAX_TX_PWR{6} = "400";
$hash_DL_MAX_TX_PWR{7} = "400";
$hash_DL_MAX_TX_PWR{8} = "400";

$hash_DL_MAX_TX_PWR{15} = "400";
$hash_DL_MAX_TX_PWR{16} = "400";
$hash_DL_MAX_TX_PWR{17} = "400";

$hash_DL_MAX_TX_PWR{'-'} = "370";


my (%hash_RRH_CONF_CELL_NUM, $hash_RRH_CONF_CELL_NUM);
%hash_RRH_CONF_CELL_NUM = ();

$hash_RRH_CONF_CELL_NUM{0}{0}{FIRST} = "0";
$hash_RRH_CONF_CELL_NUM{0}{1}{FIRST} = "1";
$hash_RRH_CONF_CELL_NUM{0}{2}{FIRST} = "2";
$hash_RRH_CONF_CELL_NUM{0}{3}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{0}{4}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{0}{5}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{1}{0}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{1}{1}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{1}{2}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{1}{3}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{1}{4}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{1}{5}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{2}{0}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{2}{1}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{2}{2}{FIRST} = "-";
$hash_RRH_CONF_CELL_NUM{2}{3}{FIRST} = "15";
$hash_RRH_CONF_CELL_NUM{2}{4}{FIRST} = "16";
$hash_RRH_CONF_CELL_NUM{2}{5}{FIRST} = "17";

if (($hash_RTRV_CELL_CONF{3}) || ($hash_RTRV_CELL_CONF{4}) || ($hash_RTRV_CELL_CONF{5})) {
$hash_RRH_CONF_CELL_NUM{0}{0}{SECOND} = "3";
$hash_RRH_CONF_CELL_NUM{0}{1}{SECOND} = "4";
$hash_RRH_CONF_CELL_NUM{0}{2}{SECOND} = "5";
$hash_RRH_CONF_CELL_NUM{0}{3}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{0}{4}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{0}{5}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{0}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{1}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{2}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{3}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{4}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{5}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{0}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{1}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{2}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{3}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{4}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{5}{SECOND} = "-";
                                                                                       }

if (($hash_RTRV_CELL_CONF{6}) || ($hash_RTRV_CELL_CONF{7}) || ($hash_RTRV_CELL_CONF{8})) {
$hash_RRH_CONF_CELL_NUM{0}{0}{SECOND} = "6";
$hash_RRH_CONF_CELL_NUM{0}{1}{SECOND} = "7";
$hash_RRH_CONF_CELL_NUM{0}{2}{SECOND} = "8";
$hash_RRH_CONF_CELL_NUM{0}{3}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{0}{4}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{0}{5}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{0}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{1}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{2}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{3}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{4}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{1}{5}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{0}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{1}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{2}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{3}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{4}{SECOND} = "-";
$hash_RRH_CONF_CELL_NUM{2}{5}{SECOND} = "-";
                                                                                       }																					   
																					   
$hash_RRH_CONF_CELL_NUM{0}{0}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{0}{1}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{0}{2}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{0}{3}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{0}{4}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{0}{5}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{1}{0}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{1}{1}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{1}{2}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{1}{3}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{1}{4}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{1}{5}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{2}{0}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{2}{1}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{2}{2}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{2}{3}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{2}{4}{THIRD} = "-";
$hash_RRH_CONF_CELL_NUM{2}{5}{THIRD} = "-";

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=9 align=center><font size=+2><b>RTRV-RRH-CONF - RETRIEVE RRH CONFIGURATION</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>CONNECT_BOARD_ID</th><th>CONNECT_PORT_ID</th><th>STATUS</th><th>BOARD_TYPE</th><th>1ST CARRIER CELL_NUM</th><th>2ND CARRIER CELL_NUM</th><th>3RD CARRIER CELL_NUM</th><th>POWER_BOOST</th><th>DL_MAX_TX_POWER</th></tr>");

foreach my $CONNECT_BOARD_ID (sort {$a<=>$b} keys %hash_RTRV_RRH_CONF) {
foreach my $CONNECT_PORT_ID (sort {$a<=>$b} keys %{$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}}) {
foreach my $STATUS (sort keys %{$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}}) {
foreach my $POWER_BOOST (sort keys %{$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{$STATUS}}) {
foreach my $BOARD_TYPE (sort keys %{$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{$STATUS}{$POWER_BOOST}}) {
my $CELL_NUM_FIRST = "$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{$STATUS}{$POWER_BOOST}{$BOARD_TYPE}{FIRST}";
my $CELL_NUM_SECOND = "$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{$STATUS}{$POWER_BOOST}{$BOARD_TYPE}{SECOND}";
my $CELL_NUM_THIRD = "$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{$STATUS}{$POWER_BOOST}{$BOARD_TYPE}{THIRD}";
my $DL_MAX_TX_POWER = "$hash_RTRV_RRH_CONF{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{$STATUS}{$POWER_BOOST}{$BOARD_TYPE}{DL_MAX_TX_POWER}";

my $DL_MAX_TX_POWER_INPUT = "$hash_DL_MAX_TX_PWR{$CELL_NUM_FIRST},$hash_DL_MAX_TX_PWR{$CELL_NUM_SECOND},$hash_DL_MAX_TX_PWR{$CELL_NUM_THIRD},370";

print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CONNECT_BOARD_ID</td>\n");
print (HTMLFILE "<td>$CONNECT_PORT_ID</td>\n");
print (HTMLFILE "<td>$STATUS</td>\n");
print (HTMLFILE "<td>$BOARD_TYPE</td>\n");

if ($STATUS eq "EQUIP") {
if ($CELL_NUM_FIRST eq "$hash_RRH_CONF_CELL_NUM{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{FIRST}") {
print (HTMLFILE "<td>$CELL_NUM_FIRST</td>\n");
                                                                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_NUM_FIRST</td>\n");
     }


if (($CELL_NUM_SECOND eq "$hash_RRH_CONF_CELL_NUM{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{SECOND}") || ($CELL_NUM_SECOND eq "-")) {
print (HTMLFILE "<td>$CELL_NUM_SECOND</td>\n");
                                                                                                                               }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_NUM_SECOND</td>\n");
     }

if (($CELL_NUM_THIRD eq "$hash_RRH_CONF_CELL_NUM{$CONNECT_BOARD_ID}{$CONNECT_PORT_ID}{THIRD}") || ($CELL_NUM_THIRD eq "-")) {
print (HTMLFILE "<td>$CELL_NUM_THIRD</td>\n");
                                                                                                                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_NUM_THIRD</td>\n");
     }


                        }

if ($STATUS eq "N_EQUIP") {
if ($CELL_NUM_FIRST eq "-") {
print (HTMLFILE "<td>$CELL_NUM_FIRST</td>\n");
                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_NUM_FIRST</td>\n");
     }

if ($CELL_NUM_SECOND eq "-") {
print (HTMLFILE "<td>$CELL_NUM_SECOND</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_NUM_SECOND</td>\n");
     }

if ($CELL_NUM_THIRD eq "-") {
print (HTMLFILE "<td>$CELL_NUM_THIRD</td>\n");
                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_NUM_THIRD</td>\n");
     }

                          }

if ($hash_enodeb_sw{$enodeb_name} eq "2.5.0") {			#start if sw eq 2.5.0

if (($CELL_NUM_FIRST >=0) && ($CELL_NUM_FIRST <=2)) {
if ($POWER_BOOST eq "Boost") {
print (HTMLFILE "<td>$POWER_BOOST</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$POWER_BOOST</td>\n");
     }
                                                    }

else {
if ($POWER_BOOST eq "Boost") {
print (HTMLFILE "<td bgcolor=#FF0000>$POWER_BOOST</td>\n");
                             }
else {
print (HTMLFILE "<td>$POWER_BOOST</td>\n");
     }

     }

                                              }			#end if sw eq 2.5.0

if (($hash_enodeb_sw{$enodeb_name} eq "3.1.0") || ($hash_enodeb_sw{$enodeb_name} eq "4.0.0")) {			#start if sw eq 3.1.0 or 4.0.0
if (($CELL_NUM_FIRST >=0) && ($CELL_NUM_FIRST <=2)) {
if ($POWER_BOOST eq "3dB,3dB,3dB,3dB") {
print (HTMLFILE "<td>$POWER_BOOST</td>\n");
                                       }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$POWER_BOOST</td>\n");
     }
                                                    }

else {
if ($POWER_BOOST eq "3dB,3dB,3dB,3dB") {
print (HTMLFILE "<td bgcolor=#FF0000>$POWER_BOOST</td>\n");
                                       }
else {
print (HTMLFILE "<td>$POWER_BOOST</td>\n");
     }

     }

                                                                                              }			#end if sw eq 3.1.0 0r 4.0.0

if ($DL_MAX_TX_POWER eq "$DL_MAX_TX_POWER_INPUT") {
print (HTMLFILE "<td>$DL_MAX_TX_POWER</td>\n");
                                                  }
			
else {
print (HTMLFILE "<td bgcolor=#FF0000>$DL_MAX_TX_POWER</td>\n");
     }			

print (HTMLFILE "</tr>");


                                                                                                                        }
                                                                                                          }
                                                                                             }
                                                                                            }


                                                                       }


print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=5 align=center><font size=+2><b>RTRV-EUTRA-FA - RETRIEVE EUTRA FA PRIORITY INFORMATION</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>FA_INDEX</th><th>STATUS</th><th>EARFCN_UL</th><th>EARFCN_DL</th></tr>");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_EUTRA_FA) {
foreach my $FA_INDEX (sort {$a<=>$b} keys %{$hash_RTRV_EUTRA_FA{$CELL_NUM}}) {
foreach my $STATUS (sort keys %{$hash_RTRV_EUTRA_FA{$CELL_NUM}{$FA_INDEX}}) {
my $EARFCN_UL = "$hash_RTRV_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{$STATUS}{EARFCN_UL}";
my $EARFCN_DL = "$hash_RTRV_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{$STATUS}{EARFCN_DL}";
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
print (HTMLFILE "<td>$FA_INDEX</td>\n");
print (HTMLFILE "<td>$STATUS</td>\n");
print (HTMLFILE "<td>$EARFCN_UL</td>\n");
print (HTMLFILE "<td>$EARFCN_DL</td>\n");
print (HTMLFILE "</tr>");
                                                                            }
                                                                             }
                                                               }
print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=3 align=center bgcolor=#FFFF00><font size=+2><b>1900 2ND CARRIER VERIFICATION</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>1900 2ND CARRIER PRESENT (RTRV-CELL-CONF)</th><th>FA INDEX 1 PRESENT (RTRV-EUTRA-FA)</th><th>FA INDEX 5 PRESENT (RTRV-EUTRA-FA)</th></tr>");

my ($FA_INDEX_1_YES_NO, $FA_INDEX_5_YES_NO);
if ($IF_FA_INDEX_1 > 0) {
$FA_INDEX_1_YES_NO = "YES";
                        }

else {
$FA_INDEX_1_YES_NO = "NO";
     }
	 
if ($IF_FA_INDEX_5 > 0) {
$FA_INDEX_5_YES_NO = "YES";
                        }

else {
$FA_INDEX_5_YES_NO = "NO";
     }

my ($CELL_2ND_CARR_YES_NO);
if ($IF_CELL_2ND_CARR > 0) {
$CELL_2ND_CARR_YES_NO = "YES";
                           }
else {
$CELL_2ND_CARR_YES_NO = "NO";
     }

print (HTMLFILE "<tr>\n");
if ($FA_INDEX_1_YES_NO eq "YES") {
if ($CELL_2ND_CARR_YES_NO eq "YES") {
print (HTMLFILE "<td>$CELL_2ND_CARR_YES_NO</td>\n");
                                    }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_2ND_CARR_YES_NO</td>\n");
     }


                                }


if ($FA_INDEX_1_YES_NO eq "NO") {
if ($CELL_2ND_CARR_YES_NO eq "NO") {
print (HTMLFILE "<td>$CELL_2ND_CARR_YES_NO</td>\n");
                                   }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_2ND_CARR_YES_NO</td>\n");
     }


                                }

print (HTMLFILE "<td>$FA_INDEX_1_YES_NO</td>\n");
print (HTMLFILE "<td>$FA_INDEX_5_YES_NO</td>\n");
print (HTMLFILE "</tr>\n");





print (HTMLFILE "</table><br>\n");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-GPS-INVT - GPS INVENTORY LIST</b></font></td></tr>");
if (!$gps_invt_nok) {	#start if not $gps_invt_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>UNIT_ID</th><th>FW_VERSION</th></tr>");

foreach $hash_RTRV_GPS_INVT_UNIT_ID (sort keys %hash_RTRV_GPS_INVT_UNIT_ID) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_RTRV_GPS_INVT_UNIT_ID</td>\n");
my $GPS_VERSION = "$hash_RTRV_GPS_INVT{$hash_RTRV_GPS_INVT_UNIT_ID}{FW_VERSION}";
if ($hash_FW_BASELINE{GPS}{INVT}{$GPS_VERSION}) {
print (HTMLFILE "<td>$hash_RTRV_GPS_INVT{$hash_RTRV_GPS_INVT_UNIT_ID}{FW_VERSION}</td>\n");
                                                }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_RTRV_GPS_INVT{$hash_RTRV_GPS_INVT_UNIT_ID}{FW_VERSION}</td>\n");
     }
print (HTMLFILE "</tr>");
                                                                            }
                    }	#end if not $gps_invt_nok

else {	#start else if $gps_invt_nok
print (HTMLFILE "<tr><td colspan=2 bgcolor=#FF0000 align=center><font size=3><b>$gps_invt_nok</b></font></td></tr>");
     }	#end else if $gps_invt_nok

print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-EAIU-INVT - RETRIEVE EAIU INVENTORY LIST</b></font></td></tr>");
if (!$eaiu_4g_invt_nok) {	#start if not $eaiu_4g_invt_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>UNIT_ID</th><th>FW_VERSION</th></tr>");

foreach $hash_RTRV_EAIU_INVT (sort keys %hash_RTRV_EAIU_INVT) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_RTRV_EAIU_INVT</td>\n");
my $FW = "$hash_RTRV_EAIU_INVT{$hash_RTRV_EAIU_INVT}{FW_VERSION}";
#if (($FW eq "0.1.12.26") || ($FW eq "0.1.12.10") || ($FW eq "1.0.0.24")) {
if ($hash_FW_BASELINE{EAIU}{INVT}{$FW}) {
print (HTMLFILE "<td>$FW</td>\n");
                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$FW</td>\n");
     }
print (HTMLFILE "</tr>");
                                                              }
                        }	#end if not $eaiu_4g_invt_nok

else {	#start else if $eaiu_4g_invt_nok
print (HTMLFILE "<tr><td colspan=2 bgcolor=#FF0000 align=center><font size=3><b>$eaiu_4g_invt_nok</b></font></td></tr>");
     }	#end else if $eaiu_4g_invt_nok

print (HTMLFILE "</table><br>");







print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=8 align=center><font size=+2><b>RTRV-CELL-STS - RETRIEVE CELL STATE/STATUS</b></font></td></tr>");
if (!$cell_sts_nok) {	#start if not $cell_sts_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>OPERATIONAL_STATE</th><th>USAGE_STATE</th></tr>");

foreach $hash_RTRV_CELL_STS_CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_CELL_STS_CELL_NUM) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$hash_RTRV_CELL_STS_CELL_NUM</td>\n");
if ($hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{OPERATIONAL_STATE} eq "enabled") {
print (HTMLFILE "<td>$hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{OPERATIONAL_STATE}</td>\n");
                                                                                       }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{OPERATIONAL_STATE}</td>\n");
     }

if (($hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{USAGE_STATE} eq "active") && ($commerical_4G eq "YES")) {
print (HTMLFILE "<td>$hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{USAGE_STATE}</td>\n");
                                                                                                               }

if (($hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{USAGE_STATE} eq "idle") && ($commerical_4G eq "NO")) {
print (HTMLFILE "<td>$hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{USAGE_STATE}</td>\n");
                                                                                                            }
if (($hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{USAGE_STATE} eq "idle") && ($commerical_4G eq "YES")) {
print (HTMLFILE "<td bgcolor=#FF0000>$hash_RTRV_CELL_STS{$hash_RTRV_CELL_STS_CELL_NUM}{USAGE_STATE}</td>\n");
                                                                                                             }
print (HTMLFILE "</tr>");
                                                                                        }
                    }	#end if not $cell_sts_nok

else {	#start else if $cell_sts_nok
print (HTMLFILE "<tr><td colspan=8 bgcolor=#FF0000 align=center><font size=3><b>$cell_sts_nok</b></font></td></tr>");
     }	#end else if $cell_sts_nok

print (HTMLFILE "</table><br>");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=2 align=center bgcolor=#FFFF00><font size=+2><b>RTRV-CELL-UECNT - RETRIEVE CELL UE COUNT</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>ACTIVE_UECOUNT</th></tr>");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_CELL_UECNT) {
my $ACTIVE_UECOUNT = "$hash_CELL_UECNT{$CELL_NUM}";
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
if ($ACTIVE_UECOUNT eq "0") {
print (HTMLFILE "<td bgcolor=#FFA500>$ACTIVE_UECOUNT</td>\n");
                            }
else {
print (HTMLFILE "<td>$ACTIVE_UECOUNT</td>\n");
     }
print (HTMLFILE "</tr>\n");
                                                            }
print (HTMLFILE "</table><br>\n");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=4 align=center bgcolor=#FFFF00><font size=+2><b>RTRV-C1XRTT-PREG - RETRIEVE CDMA2000 1XRTT PREREGIST FUNCTION</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>CSFB_PRE_REG_USAGE</th><th>SID</th><th>NID</th></tr>");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_C1XRTT_PREG) {					#START FOREACH CELL_NUM
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
my $CSFB_PRE_REG_USAGE = "$hash_C1XRTT_PREG{$CELL_NUM}{CSFB_PRE_REG_USAGE}";
my $SID = "$hash_C1XRTT_PREG{$CELL_NUM}{SID}";
my $NID = "$hash_C1XRTT_PREG{$CELL_NUM}{NID}";
if ($CSFB_PRE_REG_USAGE eq "CI_no_use") {
print (HTMLFILE "<td bgcolor=#FF0000>$CSFB_PRE_REG_USAGE</td>\n");
                                        }
else {
print (HTMLFILE "<td>$CSFB_PRE_REG_USAGE</td>\n");
     }


my ($COMM_SID_1900, $COMM_NID_1900, $COMM_SID_800, $COMM_NID_800);

if (($CELL_NUM >=0) && ($CELL_NUM <=8)) {
$COMM_SID_1900 = "$hash_comm_sid_1900{$cascade}";		#COMM SID 1900
$COMM_NID_1900 = "$hash_comm_nid_1900{$cascade}";		#COMM NID 1900

if ($SID eq "$COMM_SID_1900") {
print (HTMLFILE "<td>$SID</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SID</td>\n");
     }

if ($NID eq "$COMM_NID_1900") {
print (HTMLFILE "<td>$NID</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$NID</td>\n");
     }
                                        }

if (($CELL_NUM >=15) && ($CELL_NUM <=17)) {
$COMM_SID_800 = "$hash_comm_sid_800{$cascade}";		#COMM SID 800
$COMM_NID_800 = "$hash_comm_nid_800{$cascade}";		#COMM NID 800

if ($SID eq "$COMM_SID_800") {
print (HTMLFILE "<td>$SID</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SID</td>\n");
     }

if ($NID eq "$COMM_NID_800") {
print (HTMLFILE "<td>$NID</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$NID</td>\n");
     }
                                          }



print (HTMLFILE "</tr>\n");

                                                              }					#END  FOREACH CELL_NUM


print (HTMLFILE "</table><br>\n");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=5 align=center bgcolor=#FFFF00><font size=+2><b>RETRIEVE CDMA2000 1XRTT PRE-REGISTRATION SECTOR</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>MARKET_ID</th><th>SWITCH_NUM</th><th>CELL_ID</th><th>SECTOR_NUM</th></tr>");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_C1XRTT_PREGSECTOR) {					#START FOREACH CELL_NUM
if ($hash_C1XRTT_PREG{$CELL_NUM}) {
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");

my $MARKET_ID = "$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{MARKET_ID}";
my $SWITCH_NUM = "$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{SWITCH_NUM}";
my $CELL_ID = "$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{CELL_ID}";
my $SECTOR_NUM = "$hash_C1XRTT_PREGSECTOR{$CELL_NUM}{SECTOR_NUM}";

my $BSC_SID = $hash_BSC_SID{$bsm_name};
my $BSC_NID = $hash_BSC_NID{$bsm_name};

if ($MARKET_ID eq "$BSC_SID") {
print (HTMLFILE "<td>$MARKET_ID</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$MARKET_ID</td>\n");
     }

if ($SWITCH_NUM eq "$BSC_NID") {
print (HTMLFILE "<td>$SWITCH_NUM</td>\n");
                               }

else {
print (HTMLFILE "<td bgcolor=#FF0000>$SWITCH_NUM</td>\n");
     }
if ($CELL_ID eq "$bts_id") {
print (HTMLFILE "<td>$CELL_ID</td>\n");
                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_ID</td>\n");
     }
print (HTMLFILE "<td>$SECTOR_NUM</td>\n");
print (HTMLFILE "</tr>\n");
                                 }

                                                                   }					#END  FOREACH CELL_NUM


print (HTMLFILE "</table><br>\n");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
if ($hash_enodeb_sw{$enodeb_name} =~ m/^4/) {
print (HTMLFILE "<tr><td colspan=4 align=center bgcolor=#FFFF00><font size=+2><b>RETRIEVE CDMA2000 1xRTT MOBILITY PARAM FUNCTION</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>S_ID</th><th>N_ID</th><th>REG_ZONE</th></tr>");
                                            }
else {
print (HTMLFILE "<tr><td colspan=6 align=center bgcolor=#FFFF00><font size=+2><b>RETRIEVE CDMA2000 1xRTT MOBILITY PARAM FUNCTION</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>S_ID</th><th>N_ID</th><th>REG_ZONE</th><th>LTM_OFF</th><th>DAYLT</th></tr>");
     }
foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_C1XRTT_MOBIL) {					#START FOREACH CELL_NUM
if ($hash_C1XRTT_PREG{$CELL_NUM}) {
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");

my $SID = $hash_C1XRTT_MOBIL{$CELL_NUM}{S_ID};
my $NID = $hash_C1XRTT_MOBIL{$CELL_NUM}{N_ID};
my $REG_ZONE = $hash_C1XRTT_MOBIL{$CELL_NUM}{REG_ZONE};
my $LTM_OFF = $hash_C1XRTT_MOBIL{$CELL_NUM}{LTM_OFF};
my $DAYLT = $hash_C1XRTT_MOBIL{$CELL_NUM}{DAYLT};

if (($CELL_NUM >=0) && ($CELL_NUM <=8)) {
$COMM_SID_1900 = "$hash_comm_sid_1900{$cascade}";		#COMM SID 1900
$COMM_NID_1900 = "$hash_comm_nid_1900{$cascade}";		#COMM NID 1900

if ($SID eq "$COMM_SID_1900") {
print (HTMLFILE "<td>$SID</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SID</td>\n");
     }

if ($NID eq "$COMM_NID_1900") {
print (HTMLFILE "<td>$NID</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$NID</td>\n");
     }
                                        }

if (($CELL_NUM >=15) && ($CELL_NUM <=17)) {
$COMM_SID_800 = "$hash_comm_sid_800{$cascade}";		#COMM SID 800
$COMM_NID_800 = "$hash_comm_nid_800{$cascade}";		#COMM NID 800

if ($SID eq "$COMM_SID_800") {
print (HTMLFILE "<td>$SID</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SID</td>\n");
     }

if ($NID eq "$COMM_NID_800") {
print (HTMLFILE "<td>$NID</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$NID</td>\n");
     }
                                          }

if ($REG_ZONE eq "$reg_zone") {
print (HTMLFILE "<td>$REG_ZONE</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$REG_ZONE</td>\n");
     }
	 
	 
if ($hash_enodeb_sw{$enodeb_name} !~ m/^4/) {

#DAYLT = 0
$hash_LTM_SETTING{EST} = "54";
$hash_LTM_SETTING{CST} = "52";
$hash_LTM_SETTING{AST} = "50";
$hash_LTM_SETTING{PST} = "48";

#DAYLT = 1
#$hash_LTM_SETTING{EST} = "56";
#$hash_LTM_SETTING{CST} = "54";
#$hash_LTM_SETTING{AST} = "52";
#$hash_LTM_SETTING{PST} = "50";

my $LTM_OFF_INFO = "$hash_LTM_SETTING{$TIME_ZONE}";

if ($LTM_OFF eq "$LTM_OFF_INFO") {
print (HTMLFILE "<td>$LTM_OFF</td>\n");
                                 }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$LTM_OFF</td>\n");
     }

if ($DAYLT eq "1") {
print (HTMLFILE "<td>$DAYLT</td>\n");
                   }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$DAYLT</td>\n");
     }

                                           }
print (HTMLFILE "</tr>\n");
                                 }

                                                                }					#END  FOREACH CELL_NUM


print (HTMLFILE "</table><br>\n");





$count_NBR_C1XRTT = 0;
foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_NBR_C1XRTT) {
foreach my $RELATION_IDX (sort keys %{$hash_NBR_C1XRTT{$CELL_NUM}}) {
$count_NBR_C1XRTT++;
                                                                    }
                                                            }


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=1 align=center bgcolor=#FFFF00><font size=+2><b>RETRIEVE EXTERNAL CDMA20001XRTT CELL INFORMATION</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>1XRTT NBRs (OK/NOK)</th></tr>");

if ($count_NBR_C1XRTT > 0) {
print (HTMLFILE "<td align=center>OK</td>\n");
                           }
else {
print (HTMLFILE "<td  align=center bgcolor=#FF0000>NOK</td>\n");
     }

print (HTMLFILE "</tr>\n");
print (HTMLFILE "</table><br>\n");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=2 align=center bgcolor=#FFFF00><font size=+2><b> SON FUNCTION CELL CONTROL FLAGS</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>ANR_ENABLE</th></tr>");

foreach my $CELL_NUM (sort  {$a<=>$b} keys %hash_SONFN_CELL) {

my $ANR_ENABLE = "$hash_SONFN_CELL{$CELL_NUM}{ANR_ENABLE}";
print (HTMLFILE "<td align=center>$CELL_NUM</td>\n");

if ($ANR_ENABLE eq "Auto") {
print (HTMLFILE "<td align=center>$ANR_ENABLE</td>\n");
                           }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$ANR_ENABLE</td>\n");
     }

print (HTMLFILE "</tr>\n");
                                                             }


print (HTMLFILE "</table><br>\n");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=2 align=center bgcolor=#FFFF00><font size=+2><b>RETRIEVE SON ANR PARAMETERS</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>MAX_NRTSIZE</th><th>NR_DEL_FLAG</th></tr>");

my $MAX_NRTSIZE = $hash_SON_ANR{MAX_NRTSIZE};
my $NR_DEL_FLAG = $hash_SON_ANR{NR_DEL_FLAG};

print (HTMLFILE "<td align=center>$MAX_NRTSIZE</td>\n");
if ($NR_DEL_FLAG eq "True") {
print (HTMLFILE "<td align=center>$NR_DEL_FLAG</td>\n");
                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$NR_DEL_FLAG</td>\n");
     }


print (HTMLFILE "</tr>\n");


print (HTMLFILE "</table><br>\n");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=8 align=center bgcolor=#FFFF00><font size=+2><b>RETRIEVE EXTERNAL CDMA2000HRPD CELL INFORMATION</b></font></td></tr>\n");
if (!$nbr_hrpd_nok) {		#start if !$nbr_hrpd_nok
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>RELATION_IDX</th><th>STATUS</th><th>BAND_CLASS</th><th>ARFCN</th><th>PN_OFFSET</th><th>IS_REMOVE_ALLOWED</th><th>IS_HOALLOWED</th></tr>");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_NBR_HRPD) {				#START FOREACH CELL_NUM
foreach my $RELATION_IDX (sort {$a<=>$b} keys %{$hash_NBR_HRPD{$CELL_NUM}}) {		#START FOREACH RELATION_IDX
my $STATUS = $hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{STATUS};
my $BAND_CLASS = $hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{BAND_CLASS};
my $ARFCN = $hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{ARFCN};
my $PN_OFFSET = $hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{PN_OFFSET};
my $IS_REMOVE_ALLOWED = $hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{IS_REMOVE_ALLOWED};
my $IS_HOALLOWED = $hash_NBR_HRPD{$CELL_NUM}{$RELATION_IDX}{IS_HOALLOWED};

print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
print (HTMLFILE "<td>$RELATION_IDX</td>\n");
if ($STATUS eq "EQUIP") {
print (HTMLFILE "<td>$STATUS</td>\n");
                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$STATUS</td>\n");
     }
print (HTMLFILE "<td>$BAND_CLASS</td>\n");
print (HTMLFILE "<td>$ARFCN</td>\n");
print (HTMLFILE "<td>$PN_OFFSET</td>\n");
if ($IS_REMOVE_ALLOWED eq "True") {
print (HTMLFILE "<td>$IS_REMOVE_ALLOWED</td>\n");
                                  }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_REMOVE_ALLOWED</td>\n");
     }

if ($IS_HOALLOWED eq "True") {
print (HTMLFILE "<td>$IS_HOALLOWED</td>\n");
                             }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$IS_HOALLOWED</td>\n");
     }

print (HTMLFILE "</tr>\n");
                                                                            }		#END FOREACH RELATION_IDX


                                                         }				#END  FOREACH CELL_NUM
                    }		#end if !$nbr_hrpd_nok

else {
print (HTMLFILE "<tr><td colspan=8 bgcolor=#FF0000 align=center><font size=3><b>$nbr_hrpd_nok</b></font></td></tr>");
     }

print (HTMLFILE "</table><br>\n");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=5 align=center bgcolor=#FFFF00><font size=+2><b>RETRIEVE CELL ACCESS INFORMATION</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>CELL_BARRED</th><th>INTRA_FREQ_CELL_RESELECT</th><th>BARRING_CTR_USAGE</th><th>HANDOVER_BARRING_STATUS</th></tr>");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_CELL_ACS) {				#START FOREACH CELL_NUM

my $CELL_BARRED = $hash_CELL_ACS{$CELL_NUM}{CELL_BARRED};
my $INTRA_FREQ_CELL_RESELECT = $hash_CELL_ACS{$CELL_NUM}{INTRA_FREQ_CELL_RESELECT};
my $BARRING_CTR_USAGE = $hash_CELL_ACS{$CELL_NUM}{BARRING_CTR_USAGE};
my $HANDOVER_BARRING_STATUS = $hash_CELL_ACS{$CELL_NUM}{HANDOVER_BARRING_STATUS};

print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");
if ($CELL_BARRED eq "notBarred") {
print (HTMLFILE "<td>$CELL_BARRED</td>\n");
                                 }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_BARRED</td>\n");
     }
print (HTMLFILE "<td>$INTRA_FREQ_CELL_RESELECT</td>\n");
print (HTMLFILE "<td>$BARRING_CTR_USAGE</td>\n");
if ($HANDOVER_BARRING_STATUS eq "barringOff") {
print (HTMLFILE "<td>$HANDOVER_BARRING_STATUS</td>\n");
                                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$HANDOVER_BARRING_STATUS</td>\n");
     }

print (HTMLFILE "</tr>\n");


                                                         }				#END  FOREACH CELL_NUM


print (HTMLFILE "</table><br>\n");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=2 align=center bgcolor=#FFFF00><font size=+2><b>RTRV-CELL-DATA - RETRIEVE CELL DATA</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>CELL_TXPATH_TYPE</th></tr>");

my (%hash_1900_CELL, $hash_1900_CELL);
%hash_1900_CELL = ();

$hash_1900_CELL{0} = "YES";
$hash_1900_CELL{1} = "YES";
$hash_1900_CELL{2} = "YES";
$hash_1900_CELL{3} = "YES";
$hash_1900_CELL{4} = "YES";
$hash_1900_CELL{5} = "YES";
$hash_1900_CELL{6} = "YES";
$hash_1900_CELL{7} = "YES";
$hash_1900_CELL{8} = "YES";

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_CELL_DATA) {				#START FOREACH CELL_NUM

my $CELL_TXPATH_TYPE = $hash_RTRV_CELL_DATA{$CELL_NUM};
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");


if (($hash_1900_CELL{$CELL_NUM}) && ($CELL_TXPATH_TYPE eq "SELECT_ABCD")) {
print (HTMLFILE "<td bgcolor=#FF0000>$CELL_TXPATH_TYPE</td>\n");
                                                                          }

else {
print (HTMLFILE "<td>$CELL_TXPATH_TYPE</td>\n");
     }


print (HTMLFILE "</tr>\n");


                                                                }				#END  FOREACH CELL_NUM


print (HTMLFILE "</table><br>\n");


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=3 align=center bgcolor=#FFFF00><font size=+2><b>RTRV-CELL-CAC - RETRIEVE CELL CAC FUNCTION</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>MAX_CALL_COUNT</th><th>MAX_DRB_COUNT</th></tr>");

my (%hash_check_cac_cell, $hash_check_cac_cell);
%hash_check_cac_cell = ();

$hash_check_cac_cell{0}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{1}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{2}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{3}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{4}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{5}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{6}{MAX_CALL_COUNT} = 600;
$hash_check_cac_cell{7}{MAX_CALL_COUNT} = 600;
$hash_check_cac_cell{8}{MAX_CALL_COUNT} = 600;
$hash_check_cac_cell{15}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{16}{MAX_CALL_COUNT} = 300;
$hash_check_cac_cell{17}{MAX_CALL_COUNT} = 300;


$hash_check_cac_cell{0}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{1}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{2}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{3}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{4}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{5}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{6}{MAX_DRB_COUNT} = 1200;
$hash_check_cac_cell{7}{MAX_DRB_COUNT} = 1200;
$hash_check_cac_cell{8}{MAX_DRB_COUNT} = 1200;
$hash_check_cac_cell{15}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{16}{MAX_DRB_COUNT} = 600;
$hash_check_cac_cell{17}{MAX_DRB_COUNT} = 600;



foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_RTRV_CELL_CAC) {					#START FOREACH CELL_NUM

print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td>$CELL_NUM</td>\n");

my $MAX_CALL_COUNT = $hash_RTRV_CELL_CAC{$CELL_NUM}{MAX_CALL_COUNT};
my $MAX_DRB_COUNT = $hash_RTRV_CELL_CAC{$CELL_NUM}{MAX_DRB_COUNT};

if ($MAX_CALL_COUNT eq "$hash_check_cac_cell{$CELL_NUM}{MAX_CALL_COUNT}") {
print (HTMLFILE "<td>$MAX_CALL_COUNT</td>\n");
                                                                          }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$MAX_CALL_COUNT</td>\n");
     }


if ($MAX_DRB_COUNT eq "$hash_check_cac_cell{$CELL_NUM}{MAX_DRB_COUNT}") {
print (HTMLFILE "<td>$MAX_DRB_COUNT</td>\n");
                                                                        }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$MAX_DRB_COUNT</td>\n");
     }

print (HTMLFILE "</tr>\n");


                                                                 }					#END  FOREACH CELL_NUM


print (HTMLFILE "</table><br>\n");

my ($OCNS_RELEASED);
if ($mon_test =~ m/TEST_TYPE_TEST_OCNS/) {
$OCNS_RELEASED = "NO";
                                         }
if ($mon_test =~ m/REASON\s+\=\s+No\s+Data/) {
$OCNS_RELEASED = "YES";
                                             }
if (!$mon_test) {
$OCNS_RELEASED = "MON TEST NOT EXECUTED";
                }

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=4 align=center bgcolor=#FFFF00><font size=+2><b>MON TEST - MONITOR TEST STATUS</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>OCNS RELEASED</th></tr>");


print (HTMLFILE "<tr>\n");
if ($OCNS_RELEASED eq "YES") {
print (HTMLFILE "<td align=center>$OCNS_RELEASED</td>\n");
                             }
else {
print (HTMLFILE "<td align=center bgcolor=#FF0000>$OCNS_RELEASED</td>\n");
     }
print (HTMLFILE "</tr>\n");




print (HTMLFILE "</table><br>\n");



print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>RTRV-PDSCH-IDLE - RETRIEVE PDSCH CONFIGURATION</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>CELL_NUM</th><th>DL_POWER_OPTION</th></tr>");


foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_PDSCH_IDLE) {
#if ($hash_IDLE_CELL_NUM{$CELL_NUM}) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$CELL_NUM</td>");

my $DL_POWER_OPTION = "$hash_PDSCH_IDLE{$CELL_NUM}{DL_POWER_OPTION}";
print (HTMLFILE "<td>$DL_POWER_OPTION</td>");

#my $FORCED_MODE = "$hash_PDSCH_IDLE{$CELL_NUM}{FORCED_MODE}";
#print (HTMLFILE "<td>$FORCED_MODE</td>");
print (HTMLFILE "</tr>");

#                                    }
                                                            }
print (HTMLFILE "</table><br>");




print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=2 align=center><font size=+2><b>Inventory Management Information</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>IP</th><th>HW Desc & Manufacture Company</th></tr>");


foreach my $RRH_IP (sort keys %hash_INVENTORY_MAN) {
print (HTMLFILE "<tr>");
print (HTMLFILE "<td>$RRH_IP</td>");

my $Desc_Manufacture = $hash_INVENTORY_MAN{$RRH_IP};
print (HTMLFILE "<td>$Desc_Manufacture</td>");


print (HTMLFILE "</tr>");


                                                   }
print (HTMLFILE "</table><br>");



my ($is_1900, $is_800, $is_1900_2nd);
if (($hash_IDLE_CELL_NUM{0}) || ($hash_IDLE_CELL_NUM{1}) || ($hash_IDLE_CELL_NUM{2})) {
$is_1900 = "YES";
                                                                                      }
else {
$is_1900 = "NO";
     }


if (($hash_IDLE_CELL_NUM{3}) || ($hash_IDLE_CELL_NUM{4}) || ($hash_IDLE_CELL_NUM{5}) || ($hash_IDLE_CELL_NUM{6}) || ($hash_IDLE_CELL_NUM{7}) || ($hash_IDLE_CELL_NUM{8})) {
$is_1900_2nd = "YES";
                                                                                                                                                                          }
else {
$is_1900_2nd = "NO";
     }



	 
	 
if (($hash_IDLE_CELL_NUM{15}) || ($hash_IDLE_CELL_NUM{16}) || ($hash_IDLE_CELL_NUM{17})) {
$is_800 = "YES";
                                                                                         }
else {
$is_800 = "NO";
     }


print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=3 align=center bgcolor=#FFFF00><font size=+2><b>INSTALLED SLOTS</b></font></td></tr>\n");
print (HTMLFILE "<tr bgcolor=#FFFF00><th>SLOT 1 (1900)</th><th>SLOT 2</th><th>SLOT 3 (800)</th></tr>");

print (HTMLFILE "<tr>\n");
if ($is_1900 eq "YES") {
if ($SLOT_1 !~ m/incomplete/) {
print (HTMLFILE "<td>$SLOT_1</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SLOT_1</td>\n");
     }
                       }

if ($is_1900 eq "NO") {
if ($SLOT_1 =~ m/incomplete/) {
print (HTMLFILE "<td>$SLOT_1</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SLOT_1</td>\n");
     }
                      }



#if ($SLOT_2 =~ m/incomplete/) {
#print (HTMLFILE "<td>$SLOT_2</td>\n");
#                              }
#else {
#print (HTMLFILE "<td bgcolor=#FF0000>$SLOT_2</td>\n");
#     }

if ($is_1900_2nd eq "YES") {
if ($SLOT_2 !~ m/incomplete/) {
print (HTMLFILE "<td>$SLOT_2</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SLOT_2</td>\n");
     }
                           }

if ($is_1900_2nd eq "NO") {
if ($SLOT_2 =~ m/incomplete/) {
print (HTMLFILE "<td>$SLOT_2</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SLOT_2</td>\n");
     }
                          }

if ($is_800 eq "YES") {
if ($SLOT_3 !~ m/incomplete/) {
print (HTMLFILE "<td>$SLOT_3</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SLOT_3</td>\n");
     }
                      }

if ($is_800 eq "NO") {
if ($SLOT_3 =~ m/incomplete/) {
print (HTMLFILE "<td>$SLOT_3</td>\n");
                              }
else {
print (HTMLFILE "<td bgcolor=#FF0000>$SLOT_3</td>\n");
     }
                     }
print (HTMLFILE "</tr>\n");

print (HTMLFILE "</table><br>\n");



my $count_4g_alarms = keys %hash_ALM_4G;
#print ("$count_history_alarms\n");
if ($count_4g_alarms == 0) {

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=8 align=center><font size=+2><b>4G ALARM HISTORY</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td align=center><font size =+2><b>THERE ARE NO 4G ALARMS</b></font></td></tr>");

print (HTMLFILE "</table><br>");
                           }


if ($count_4g_alarms > 0) {
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=7 align=center><font size=+2><b>4G ALARMS</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>UNIT TYPE</th><th>ALARM TYPE</th><th>LOCATION</th><th>RAISED TIME</th><th>PROBABLE CAUSE</th><th>SEVERITY</th><th>ALARM CODE</th></tr>");
my ($bgcolor);
foreach my $number_alm (sort {$a<=>$b} keys %hash_ALM_4G) {
if ($hash_ALM_4G{$number_alm}{SEVERITY} eq "critical") {
$bgcolor = "#FF0000";
                                                       }
if ($hash_ALM_4G{$number_alm}{SEVERITY} eq "major") {
$bgcolor = "#FFA500";
                                                    }
if ($hash_ALM_4G{$number_alm}{SEVERITY} eq "minor") {
$bgcolor = "#FFFF00";
                                                    }
print (HTMLFILE "<tr bgcolor=$bgcolor>");
print (HTMLFILE "<td>$hash_ALM_4G{$number_alm}{UNIT}</td>");
print (HTMLFILE "<td>$hash_ALM_4G{$number_alm}{ALARM_TYPE}</td>");
print (HTMLFILE "<td>$hash_ALM_4G{$number_alm}{LOCATION}</td>");
print (HTMLFILE "<td>$hash_ALM_4G{$number_alm}{RAISED_TIME}</td>");
print (HTMLFILE "<td>$hash_ALM_4G{$number_alm}{PROBABLE_CAUSE}</td>");
print (HTMLFILE "<td>$hash_ALM_4G{$number_alm}{SEVERITY}</td>");
print (HTMLFILE "<td>$hash_ALM_4G{$number_alm}{ALARM_CODE}</td>");
print (HTMLFILE "</tr>");

                                                          }


print (HTMLFILE "</table><br>");

                             }






my $count_history_4g_alarms = keys %hash_ALM_HIST_4G;
#print ("$count_history_alarms\n");
if ($count_history_4g_alarms == 0) {

print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=8 align=center><font size=+2><b>4G ALARM HISTORY</b></font></td></tr>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td align=center><font size =+2><b>THERE'S NO 4G ALARM HISTORY</b></font></td></tr>");

print (HTMLFILE "</table><br>");
                                   }

if ($count_history_4g_alarms > 0) {
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>");
print (HTMLFILE "<tr bgcolor=#FFFF00><td colspan=8 align=center><font size=+2><b>4G ALARM HISTORY</b></font></td></tr>");

print (HTMLFILE "<tr bgcolor=#FFFF00><th>UNIT TYPE</th><th>ALARM TYPE</th><th>LOCATION</th><th>RAISED TIME</th><th>CLEARED TIME</th><th>PROBABLE CAUSE</th><th>SEVERITY</th><th>ALARM CODE</th></tr>");
my ($bgcolor);
foreach my $number_alm (sort {$a<=>$b} keys %hash_ALM_HIST_4G) {
#foreach my $title_info (sort keys %{$hash_ALM_HIST_4G{$hash_ALM_HIST_4G}}) {
if ($hash_ALM_HIST_4G{$number_alm}{SERVERITY} eq "critical") {
$bgcolor = "#FF0000";
                                                             }
if ($hash_ALM_HIST_4G{$number_alm}{SERVERITY} eq "major") {
$bgcolor = "#FFA500";
                                                          }
if ($hash_ALM_HIST_4G{$number_alm}{SERVERITY} eq "minor") {
$bgcolor = "#FFFF00";
                                                          }
print (HTMLFILE "<tr bgcolor=$bgcolor>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{UNIT}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{ALARM_TYPE}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{LOCATION}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{START_TIME}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{END_TIME}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{PROBABLE_CAUSE}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{SERVERITY}</td>");
print (HTMLFILE "<td>$hash_ALM_HIST_4G{$number_alm}{ALARM_CODE}</td>");
print (HTMLFILE "</tr>");

                                                               }


print (HTMLFILE "</table><br>");

                                  }











                 }




sub CLOSE_HTML {
close (HTMLFILE);
               }