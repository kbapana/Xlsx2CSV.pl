#!/usr/bin/perl
use POSIX;
use Net::SSH2;

use Control::CLI;
use Data::Dumper;

unless(-d "C:\\3G_4G_TOOL_Scripts\\2.5\\Audit_2.5\\REPORT\\"){
   `mkdir C:\\3G_4G_TOOL_Scripts\\2.5\\Audit_2.5\\REPORT\\`;		
 }  

my ($version_cq,$bucket,$LSMOAM,$LSM, $IP, $user, $pass, $eNBName,$cascade,$mmbsoamip,$mmbssbip,$alphapci,$betapci,$gammapci,$alpharsi,$betarsi,$gammarsi,$tac,$cabinet,$alphaid,$betaid,$gammaid,$alphatilt,$betatilt,$gammatilt,$earfcn,$startear,$enbid,$ltm,$zero_cq,$pkg);
my ($secondcar,$divciq,$convert_long,$convert_lat,$tddsecondcar,$tdd3rdcar,$thirdcar);
my($now);

$now = strftime("%m%d%Y_%H_%M_%S", localtime);

my (%hash_SONFN_CELL, $hash_SONFN_CELL);
%hash_SONFN_CELL = ();

my (%hash_sonfn_cell_values, $hash_sonfn_cell_values);
%hash_sonfn_cell_values = ();

my (%hash_EUTRA_FA, $hash_EUTRA_FA);
%hash_EUTRA_FA = ();

$hash_sonfn_cell_values{ANR_ENABLE} = "Auto";
$hash_sonfn_cell_values{INTER_RAT_ANR_ENABLE1_X_RTT} = "Off";
$hash_sonfn_cell_values{INTER_RAT_ANR_ENABLE_HRPD} = "Off";
$hash_sonfn_cell_values{ENERGY_SAVINGS_ENABLE} = "Off";
$hash_sonfn_cell_values{MOBILITY_ROBUSTNESS_ENABLE} = "Off";
$hash_sonfn_cell_values{RACH_OPT_ENABLE} = "Off";
$hash_sonfn_cell_values{PERIODIC_ANR_FLAG} = "False";
$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_TOTAL} = "5";
$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_INTRA_FREQ} = "0";
$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_INTER_FREQ} = "0";
$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_C1_XRTT} = "100";
$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_HRPD} = "100";
$hash_sonfn_cell_values{ANR_MEAS_DURATION_INTER_FREQ} = "10";
$hash_sonfn_cell_values{ANR_MEAS_DURATION_C1_XRTT} = "10";
$hash_sonfn_cell_values{ANR_MEAS_DURATION_HRPD} = "10";
$hash_sonfn_cell_values{PCI_DRC_FLAG} = "True";
$hash_sonfn_cell_values{ES_SCAILING_FACTOR_LB} = "OFF";
$hash_sonfn_cell_values{ES_SCALING_FACTOR_CAC} = "0.7";
$hash_sonfn_cell_values{RSI_CONFLICT_ENABLE} = "Off";
$hash_sonfn_cell_values{SON_CCO_PWR_CTRL_ENABLE} = "Off";
$hash_sonfn_cell_values{SON_COC_PWR_CTRL_ENABLE} = "Off";

my (%hash_EUTRA_FA_INFO, $hash_EUTRA_FA_INFO);
%hash_EUTRA_FA_INFO = ();

$hash_EUTRA_FA_INFO{0}{S_NON_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{0}{MNC5} = "FFF";
$hash_EUTRA_FA_INFO{0}{Q_OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{0}{SF_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{0}{STATUS} = "EQUIP";
$hash_EUTRA_FA_INFO{0}{HANDOVER_TYPE} = "A3";
$hash_EUTRA_FA_INFO{0}{PREFERENCE2} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{0}{THRESH_SERVING_LOW_QREL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{0}{S_INTRA_SEARCH_P} = "29";
$hash_EUTRA_FA_INFO{0}{MESA_BANDWIDTH_USAGE} = "use";
$hash_EUTRA_FA_INFO{0}{MCC0} = "310";
$hash_EUTRA_FA_INFO{0}{OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{0}{MNC3} = "FFF";
$hash_EUTRA_FA_INFO{0}{MCC2} = "FFF";
$hash_EUTRA_FA_INFO{0}{PREFERENCE1} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{0}{OVERLAPPING_EARFCN_DL} = "8750,8750,8750,8750,8750,8750,8750,8750";
$hash_EUTRA_FA_INFO{0}{S_INTRA_SEARCH_Q} = "5";
$hash_EUTRA_FA_INFO{0}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{0}{MOBILITY_PREFERENCE} = "None";
$hash_EUTRA_FA_INFO{0}{S_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{0}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{0}{NEIGH_CELL_CONFIG} = "1";
$hash_EUTRA_FA_INFO{0}{THRESH_XHIGH} = "0";
$hash_EUTRA_FA_INFO{0}{OVERLAPPING_BAND_ENABLE_FLAG} = "0,0,0,0,0,0,0,0";
$hash_EUTRA_FA_INFO{0}{PRESENCE_ANT_PORT1} = "True";
$hash_EUTRA_FA_INFO{0}{ANR_UE_SEARCH_RATE} = "100.0";
$hash_EUTRA_FA_INFO{0}{PLMN2_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{0}{VOICE_SUPPORT1} = "True";
$hash_EUTRA_FA_INFO{0}{T_RESELECTION_SF_HIGH} = "oneDot0";
$hash_EUTRA_FA_INFO{0}{PLMN5_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{0}{PLMN0_SEARCH_RATE_FOR_IDLE_LB} = "32750";
$hash_EUTRA_FA_INFO{0}{T_RESELECTION_SF_MEDIUM} = "oneDot0";
$hash_EUTRA_FA_INFO{0}{SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{0}{MNC0} = "120";
$hash_EUTRA_FA_INFO{0}{S_NON_INTRA_SEARCH_P} = "8";
$hash_EUTRA_FA_INFO{0}{PREFERENCE5} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{0}{S_NON_INTRA_SEARCH_Q} = "0";
$hash_EUTRA_FA_INFO{0}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{0}{P_MAX_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{0}{THRESH_SERVING_LOW_QREL9} = "0";
$hash_EUTRA_FA_INFO{0}{MCC1} = "FFF";
$hash_EUTRA_FA_INFO{0}{S_INTRA_SEARCH} = "29";
$hash_EUTRA_FA_INFO{0}{PLMN4_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{0}{Q_QUAL_MIN_REL9} = "-18";
$hash_EUTRA_FA_INFO{0}{Q_QUAL_MIN_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{0}{VOICE_SUPPORT2} = "True";
$hash_EUTRA_FA_INFO{0}{T_RESELECTION} = "2";
$hash_EUTRA_FA_INFO{0}{PREFERENCE3} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{0}{EARFCN_DL} = "40254";
$hash_EUTRA_FA_INFO{0}{OVERLAPPING_EARFCN_UL} = "26750,26750,26750,26750,26750,26750,26750,26750";
$hash_EUTRA_FA_INFO{0}{MNC4} = "FFF";
$hash_EUTRA_FA_INFO{0}{THRESH_XHIGH_QREL9} = "0";
$hash_EUTRA_FA_INFO{0}{S_NON_INTRA_SEARCH} = "5";
$hash_EUTRA_FA_INFO{0}{THRESH_XLOW_QREL9} = "4";
$hash_EUTRA_FA_INFO{0}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{0}{VOICE_SUPPORT0} = "True";
$hash_EUTRA_FA_INFO{0}{VOICE_SUPPORT4} = "True";
$hash_EUTRA_FA_INFO{0}{PREFERENCE0} = "preferred_prefer";
$hash_EUTRA_FA_INFO{0}{Q_RX_LEV_MIN} = "-62";
$hash_EUTRA_FA_INFO{0}{S_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{0}{THRESH_XLOW} = "2";
$hash_EUTRA_FA_INFO{0}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{0}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{0}{MEASUREMENT_BANDWIDTH} = "mbw100";
$hash_EUTRA_FA_INFO{0}{PRIORITY} = "6";
$hash_EUTRA_FA_INFO{0}{ADDITIONAL_SPECTRUM_EMISSION} = "1,1,1,1,1,1,1,1";
$hash_EUTRA_FA_INFO{0}{MCC5} = "FFF";
$hash_EUTRA_FA_INFO{0}{MIN_NRTSIZE_CARRIER} = "19";
$hash_EUTRA_FA_INFO{0}{VOICE_SUPPORT3} = "True";
$hash_EUTRA_FA_INFO{0}{SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{0}{EARFCN_UL} = "40254";
$hash_EUTRA_FA_INFO{0}{PLMN1_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{0}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{0}{ANR_ALLOW} = "use";
$hash_EUTRA_FA_INFO{0}{MEAS_CYCLE_SCELL} = "sf1280";
$hash_EUTRA_FA_INFO{0}{MNC1} = "FFF";
$hash_EUTRA_FA_INFO{0}{MCC3} = "FFF";
$hash_EUTRA_FA_INFO{0}{PREFERENCE4} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{0}{PLMN3_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{0}{MCC4} = "FFF";
$hash_EUTRA_FA_INFO{0}{VOICE_SUPPORT5} = "True";
$hash_EUTRA_FA_INFO{0}{FA_INDEX} = "0";
$hash_EUTRA_FA_INFO{0}{P_MAX} = "23";
$hash_EUTRA_FA_INFO{0}{MNC2} = "FFF";
$hash_EUTRA_FA_INFO{0}{S_NON_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{0}{THRESH_SERVING_LOW} = "3";
$hash_EUTRA_FA_INFO{0}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{1}{S_NON_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{1}{MNC5} = "FFF";
$hash_EUTRA_FA_INFO{1}{Q_OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{1}{SF_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{1}{STATUS} = "EQUIP";
$hash_EUTRA_FA_INFO{1}{HANDOVER_TYPE} = "A5";
$hash_EUTRA_FA_INFO{1}{PREFERENCE2} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{1}{THRESH_SERVING_LOW_QREL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{1}{S_INTRA_SEARCH_P} = "29";
$hash_EUTRA_FA_INFO{1}{MESA_BANDWIDTH_USAGE} = "use";
$hash_EUTRA_FA_INFO{1}{MCC0} = "310";
$hash_EUTRA_FA_INFO{1}{OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{1}{MNC3} = "FFF";
$hash_EUTRA_FA_INFO{1}{MCC2} = "FFF";
$hash_EUTRA_FA_INFO{1}{PREFERENCE1} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{1}{OVERLAPPING_EARFCN_DL} = "8750,8750,8750,8750,8750,8750,8750,8750";
$hash_EUTRA_FA_INFO{1}{S_INTRA_SEARCH_Q} = "5";
$hash_EUTRA_FA_INFO{1}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{1}{MOBILITY_PREFERENCE} = "None";
$hash_EUTRA_FA_INFO{1}{S_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{1}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{1}{NEIGH_CELL_CONFIG} = "1";
$hash_EUTRA_FA_INFO{1}{THRESH_XHIGH} = "0";
$hash_EUTRA_FA_INFO{1}{OVERLAPPING_BAND_ENABLE_FLAG} = "0,0,0,0,0,0,0,0";
$hash_EUTRA_FA_INFO{1}{PRESENCE_ANT_PORT1} = "True";
$hash_EUTRA_FA_INFO{1}{ANR_UE_SEARCH_RATE} = "100.0";
$hash_EUTRA_FA_INFO{1}{PLMN2_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{1}{VOICE_SUPPORT1} = "True";
$hash_EUTRA_FA_INFO{1}{T_RESELECTION_SF_HIGH} = "oneDot0";
$hash_EUTRA_FA_INFO{1}{PLMN5_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{1}{PLMN0_SEARCH_RATE_FOR_IDLE_LB} = "32750";
$hash_EUTRA_FA_INFO{1}{T_RESELECTION_SF_MEDIUM} = "oneDot0";
$hash_EUTRA_FA_INFO{1}{SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{1}{MNC0} = "120";
$hash_EUTRA_FA_INFO{1}{S_NON_INTRA_SEARCH_P} = "8";
$hash_EUTRA_FA_INFO{1}{PREFERENCE5} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{1}{S_NON_INTRA_SEARCH_Q} = "0";
$hash_EUTRA_FA_INFO{1}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{1}{P_MAX_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{1}{THRESH_SERVING_LOW_QREL9} = "0";
$hash_EUTRA_FA_INFO{1}{MCC1} = "FFF";
$hash_EUTRA_FA_INFO{1}{S_INTRA_SEARCH} = "29";
$hash_EUTRA_FA_INFO{1}{PLMN4_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{1}{Q_QUAL_MIN_REL9} = "-18";
$hash_EUTRA_FA_INFO{1}{Q_QUAL_MIN_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{1}{VOICE_SUPPORT2} = "True";
$hash_EUTRA_FA_INFO{1}{T_RESELECTION} = "2";
$hash_EUTRA_FA_INFO{1}{PREFERENCE3} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{1}{EARFCN_DL} = "40056";
$hash_EUTRA_FA_INFO{1}{OVERLAPPING_EARFCN_UL} = "26750,26750,26750,26750,26750,26750,26750,26750";
$hash_EUTRA_FA_INFO{1}{MNC4} = "FFF";
$hash_EUTRA_FA_INFO{1}{THRESH_XHIGH_QREL9} = "0";
$hash_EUTRA_FA_INFO{1}{S_NON_INTRA_SEARCH} = "5";
$hash_EUTRA_FA_INFO{1}{THRESH_XLOW_QREL9} = "4";
$hash_EUTRA_FA_INFO{1}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{1}{VOICE_SUPPORT0} = "True";
$hash_EUTRA_FA_INFO{1}{VOICE_SUPPORT4} = "True";
$hash_EUTRA_FA_INFO{1}{PREFERENCE0} = "preferred_prefer";
$hash_EUTRA_FA_INFO{1}{Q_RX_LEV_MIN} = "-62";
$hash_EUTRA_FA_INFO{1}{S_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{1}{THRESH_XLOW} = "2";
$hash_EUTRA_FA_INFO{1}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{1}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{1}{MEASUREMENT_BANDWIDTH} = "mbw100";
$hash_EUTRA_FA_INFO{1}{PRIORITY} = "6";
$hash_EUTRA_FA_INFO{1}{ADDITIONAL_SPECTRUM_EMISSION} = "1,1,1,1,1,1,1,1";
$hash_EUTRA_FA_INFO{1}{MCC5} = "FFF";
$hash_EUTRA_FA_INFO{1}{MIN_NRTSIZE_CARRIER} = "19";
$hash_EUTRA_FA_INFO{1}{VOICE_SUPPORT3} = "True";
$hash_EUTRA_FA_INFO{1}{SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{1}{EARFCN_UL} = "40056";
$hash_EUTRA_FA_INFO{1}{PLMN1_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{1}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{1}{ANR_ALLOW} = "use";
$hash_EUTRA_FA_INFO{1}{MEAS_CYCLE_SCELL} = "sf1280";
$hash_EUTRA_FA_INFO{1}{MNC1} = "FFF";
$hash_EUTRA_FA_INFO{1}{MCC3} = "FFF";
$hash_EUTRA_FA_INFO{1}{PREFERENCE4} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{1}{PLMN3_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{1}{MCC4} = "FFF";
$hash_EUTRA_FA_INFO{1}{VOICE_SUPPORT5} = "True";
$hash_EUTRA_FA_INFO{1}{FA_INDEX} = "1";
$hash_EUTRA_FA_INFO{1}{P_MAX} = "23";
$hash_EUTRA_FA_INFO{1}{MNC2} = "FFF";
$hash_EUTRA_FA_INFO{1}{S_NON_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{1}{THRESH_SERVING_LOW} = "3";
$hash_EUTRA_FA_INFO{1}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{2}{S_NON_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{2}{MNC5} = "FFF";
$hash_EUTRA_FA_INFO{2}{Q_OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{2}{SF_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{2}{STATUS} = "N_EQUIP";
$hash_EUTRA_FA_INFO{2}{HANDOVER_TYPE} = "A5";
$hash_EUTRA_FA_INFO{2}{PREFERENCE2} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{2}{THRESH_SERVING_LOW_QREL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{2}{S_INTRA_SEARCH_P} = "29";
$hash_EUTRA_FA_INFO{2}{MESA_BANDWIDTH_USAGE} = "use";
$hash_EUTRA_FA_INFO{2}{MCC0} = "310";
$hash_EUTRA_FA_INFO{2}{OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{2}{MNC3} = "FFF";
$hash_EUTRA_FA_INFO{2}{MCC2} = "FFF";
$hash_EUTRA_FA_INFO{2}{PREFERENCE1} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{2}{OVERLAPPING_EARFCN_DL} = "8750,8750,8750,8750,8750,8750,8750,8750";
$hash_EUTRA_FA_INFO{2}{S_INTRA_SEARCH_Q} = "5";
$hash_EUTRA_FA_INFO{2}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{2}{MOBILITY_PREFERENCE} = "None";
$hash_EUTRA_FA_INFO{2}{S_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{2}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{2}{NEIGH_CELL_CONFIG} = "1";
$hash_EUTRA_FA_INFO{2}{THRESH_XHIGH} = "0";
$hash_EUTRA_FA_INFO{2}{OVERLAPPING_BAND_ENABLE_FLAG} = "0,0,0,0,0,0,0,0";
$hash_EUTRA_FA_INFO{2}{PRESENCE_ANT_PORT1} = "True";
$hash_EUTRA_FA_INFO{2}{ANR_UE_SEARCH_RATE} = "100.0";
$hash_EUTRA_FA_INFO{2}{PLMN2_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{2}{VOICE_SUPPORT1} = "True";
$hash_EUTRA_FA_INFO{2}{T_RESELECTION_SF_HIGH} = "oneDot0";
$hash_EUTRA_FA_INFO{2}{PLMN5_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{2}{PLMN0_SEARCH_RATE_FOR_IDLE_LB} = "32750";
$hash_EUTRA_FA_INFO{2}{T_RESELECTION_SF_MEDIUM} = "oneDot0";
$hash_EUTRA_FA_INFO{2}{SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{2}{MNC0} = "120";
$hash_EUTRA_FA_INFO{2}{S_NON_INTRA_SEARCH_P} = "8";
$hash_EUTRA_FA_INFO{2}{PREFERENCE5} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{2}{S_NON_INTRA_SEARCH_Q} = "0";
$hash_EUTRA_FA_INFO{2}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{2}{P_MAX_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{2}{THRESH_SERVING_LOW_QREL9} = "0";
$hash_EUTRA_FA_INFO{2}{MCC1} = "FFF";
$hash_EUTRA_FA_INFO{2}{S_INTRA_SEARCH} = "29";
$hash_EUTRA_FA_INFO{2}{PLMN4_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{2}{Q_QUAL_MIN_REL9} = "-18";
$hash_EUTRA_FA_INFO{2}{Q_QUAL_MIN_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{2}{VOICE_SUPPORT2} = "True";
$hash_EUTRA_FA_INFO{2}{T_RESELECTION} = "2";
$hash_EUTRA_FA_INFO{2}{PREFERENCE3} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{2}{EARFCN_DL} = "8465";
$hash_EUTRA_FA_INFO{2}{OVERLAPPING_EARFCN_UL} = "26750,26750,26750,26750,26750,26750,26750,26750";
$hash_EUTRA_FA_INFO{2}{MNC4} = "FFF";
$hash_EUTRA_FA_INFO{2}{THRESH_XHIGH_QREL9} = "0";
$hash_EUTRA_FA_INFO{2}{S_NON_INTRA_SEARCH} = "5";
$hash_EUTRA_FA_INFO{2}{THRESH_XLOW_QREL9} = "4";
$hash_EUTRA_FA_INFO{2}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{2}{VOICE_SUPPORT0} = "True";
$hash_EUTRA_FA_INFO{2}{VOICE_SUPPORT4} = "True";
$hash_EUTRA_FA_INFO{2}{PREFERENCE0} = "preferred_prefer";
$hash_EUTRA_FA_INFO{2}{Q_RX_LEV_MIN} = "-62";
$hash_EUTRA_FA_INFO{2}{S_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{2}{THRESH_XLOW} = "2";
$hash_EUTRA_FA_INFO{2}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{2}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{2}{MEASUREMENT_BANDWIDTH} = "mbw100";
$hash_EUTRA_FA_INFO{2}{PRIORITY} = "6";
$hash_EUTRA_FA_INFO{2}{ADDITIONAL_SPECTRUM_EMISSION} = "1,1,1,1,1,1,1,1";
$hash_EUTRA_FA_INFO{2}{MCC5} = "FFF";
$hash_EUTRA_FA_INFO{2}{MIN_NRTSIZE_CARRIER} = "19";
$hash_EUTRA_FA_INFO{2}{VOICE_SUPPORT3} = "True";
$hash_EUTRA_FA_INFO{2}{SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{2}{EARFCN_UL} = "26465";
$hash_EUTRA_FA_INFO{2}{PLMN1_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{2}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{2}{ANR_ALLOW} = "use";
$hash_EUTRA_FA_INFO{2}{MEAS_CYCLE_SCELL} = "sf1280";
$hash_EUTRA_FA_INFO{2}{MNC1} = "FFF";
$hash_EUTRA_FA_INFO{2}{MCC3} = "FFF";
$hash_EUTRA_FA_INFO{2}{PREFERENCE4} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{2}{PLMN3_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{2}{MCC4} = "FFF";
$hash_EUTRA_FA_INFO{2}{VOICE_SUPPORT5} = "True";
$hash_EUTRA_FA_INFO{2}{FA_INDEX} = "2";
$hash_EUTRA_FA_INFO{2}{P_MAX} = "23";
$hash_EUTRA_FA_INFO{2}{MNC2} = "FFF";
$hash_EUTRA_FA_INFO{2}{S_NON_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{2}{THRESH_SERVING_LOW} = "3";
$hash_EUTRA_FA_INFO{2}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{3}{S_NON_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{3}{MNC5} = "FFF";
$hash_EUTRA_FA_INFO{3}{Q_OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{3}{SF_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{3}{STATUS} = "EQUIP";
$hash_EUTRA_FA_INFO{3}{HANDOVER_TYPE} = "A5";
$hash_EUTRA_FA_INFO{3}{PREFERENCE2} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{3}{THRESH_SERVING_LOW_QREL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{3}{S_INTRA_SEARCH_P} = "29";
$hash_EUTRA_FA_INFO{3}{MESA_BANDWIDTH_USAGE} = "use";
$hash_EUTRA_FA_INFO{3}{MCC0} = "310";
$hash_EUTRA_FA_INFO{3}{OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{3}{MNC3} = "FFF";
$hash_EUTRA_FA_INFO{3}{MCC2} = "FFF";
$hash_EUTRA_FA_INFO{3}{PREFERENCE1} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{3}{OVERLAPPING_EARFCN_DL} = "8750,8750,8750,8750,8750,8750,8750,8750";
$hash_EUTRA_FA_INFO{3}{S_INTRA_SEARCH_Q} = "5";
$hash_EUTRA_FA_INFO{3}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{3}{MOBILITY_PREFERENCE} = "None";
$hash_EUTRA_FA_INFO{3}{S_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{3}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{3}{NEIGH_CELL_CONFIG} = "1";
$hash_EUTRA_FA_INFO{3}{THRESH_XHIGH} = "0";
$hash_EUTRA_FA_INFO{3}{OVERLAPPING_BAND_ENABLE_FLAG} = "0,0,0,0,0,0,0,0";
$hash_EUTRA_FA_INFO{3}{PRESENCE_ANT_PORT1} = "True";
$hash_EUTRA_FA_INFO{3}{ANR_UE_SEARCH_RATE} = "100.0";
$hash_EUTRA_FA_INFO{3}{PLMN2_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{3}{VOICE_SUPPORT1} = "True";
$hash_EUTRA_FA_INFO{3}{T_RESELECTION_SF_HIGH} = "oneDot0";
$hash_EUTRA_FA_INFO{3}{PLMN5_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{3}{PLMN0_SEARCH_RATE_FOR_IDLE_LB} = "1";
$hash_EUTRA_FA_INFO{3}{T_RESELECTION_SF_MEDIUM} = "oneDot0";
$hash_EUTRA_FA_INFO{3}{SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{3}{MNC0} = "120";
$hash_EUTRA_FA_INFO{3}{S_NON_INTRA_SEARCH_P} = "8";
$hash_EUTRA_FA_INFO{3}{PREFERENCE5} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{3}{S_NON_INTRA_SEARCH_Q} = "0";
$hash_EUTRA_FA_INFO{3}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{3}{P_MAX_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{3}{THRESH_SERVING_LOW_QREL9} = "0";
$hash_EUTRA_FA_INFO{3}{MCC1} = "FFF";
$hash_EUTRA_FA_INFO{3}{S_INTRA_SEARCH} = "29";
$hash_EUTRA_FA_INFO{3}{PLMN4_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{3}{Q_QUAL_MIN_REL9} = "-18";
$hash_EUTRA_FA_INFO{3}{Q_QUAL_MIN_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{3}{VOICE_SUPPORT2} = "True";
$hash_EUTRA_FA_INFO{3}{T_RESELECTION} = "2";
$hash_EUTRA_FA_INFO{3}{PREFERENCE3} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{3}{EARFCN_DL} = "8665";
$hash_EUTRA_FA_INFO{3}{OVERLAPPING_EARFCN_UL} = "26750,26750,26750,26750,26750,26750,26750,26750";
$hash_EUTRA_FA_INFO{3}{MNC4} = "FFF";
$hash_EUTRA_FA_INFO{3}{THRESH_XHIGH_QREL9} = "0";
$hash_EUTRA_FA_INFO{3}{S_NON_INTRA_SEARCH} = "5";
$hash_EUTRA_FA_INFO{3}{THRESH_XLOW_QREL9} = "4";
$hash_EUTRA_FA_INFO{3}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{3}{VOICE_SUPPORT0} = "True";
$hash_EUTRA_FA_INFO{3}{VOICE_SUPPORT4} = "True";
$hash_EUTRA_FA_INFO{3}{PREFERENCE0} = "preferred_prefer";
$hash_EUTRA_FA_INFO{3}{Q_RX_LEV_MIN} = "-60";
$hash_EUTRA_FA_INFO{3}{S_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{3}{THRESH_XLOW} = "2";
$hash_EUTRA_FA_INFO{3}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{3}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{3}{MEASUREMENT_BANDWIDTH} = "mbw25";
$hash_EUTRA_FA_INFO{3}{PRIORITY} = "5";
$hash_EUTRA_FA_INFO{3}{ADDITIONAL_SPECTRUM_EMISSION} = "1,1,1,1,1,1,1,1";
$hash_EUTRA_FA_INFO{3}{MCC5} = "FFF";
$hash_EUTRA_FA_INFO{3}{MIN_NRTSIZE_CARRIER} = "19";
$hash_EUTRA_FA_INFO{3}{VOICE_SUPPORT3} = "True";
$hash_EUTRA_FA_INFO{3}{SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{3}{EARFCN_UL} = "26665";
$hash_EUTRA_FA_INFO{3}{PLMN1_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{3}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{3}{ANR_ALLOW} = "use";
$hash_EUTRA_FA_INFO{3}{MEAS_CYCLE_SCELL} = "sf1280";
$hash_EUTRA_FA_INFO{3}{MNC1} = "FFF";
$hash_EUTRA_FA_INFO{3}{MCC3} = "FFF";
$hash_EUTRA_FA_INFO{3}{PREFERENCE4} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{3}{PLMN3_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{3}{MCC4} = "FFF";
$hash_EUTRA_FA_INFO{3}{VOICE_SUPPORT5} = "True";
$hash_EUTRA_FA_INFO{3}{FA_INDEX} = "3";
$hash_EUTRA_FA_INFO{3}{P_MAX} = "23";
$hash_EUTRA_FA_INFO{3}{MNC2} = "FFF";
$hash_EUTRA_FA_INFO{3}{S_NON_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{3}{THRESH_SERVING_LOW} = "3";
$hash_EUTRA_FA_INFO{3}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{4}{S_NON_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{4}{MNC5} = "FFF";
$hash_EUTRA_FA_INFO{4}{Q_OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{4}{SF_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{4}{STATUS} = "N_EQUIP";
$hash_EUTRA_FA_INFO{4}{HANDOVER_TYPE} = "A5";
$hash_EUTRA_FA_INFO{4}{PREFERENCE2} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{4}{THRESH_SERVING_LOW_QREL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{4}{S_INTRA_SEARCH_P} = "29";
$hash_EUTRA_FA_INFO{4}{MESA_BANDWIDTH_USAGE} = "use";
$hash_EUTRA_FA_INFO{4}{MCC0} = "310";
$hash_EUTRA_FA_INFO{4}{OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{4}{MNC3} = "FFF";
$hash_EUTRA_FA_INFO{4}{MCC2} = "FFF";
$hash_EUTRA_FA_INFO{4}{PREFERENCE1} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{4}{OVERLAPPING_EARFCN_DL} = "8750,8750,8750,8750,8750,8750,8750,8750";
$hash_EUTRA_FA_INFO{4}{S_INTRA_SEARCH_Q} = "5";
$hash_EUTRA_FA_INFO{4}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{4}{MOBILITY_PREFERENCE} = "None";
$hash_EUTRA_FA_INFO{4}{S_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{4}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{4}{NEIGH_CELL_CONFIG} = "1";
$hash_EUTRA_FA_INFO{4}{THRESH_XHIGH} = "0";
$hash_EUTRA_FA_INFO{4}{OVERLAPPING_BAND_ENABLE_FLAG} = "0,0,0,0,0,0,0,0";
$hash_EUTRA_FA_INFO{4}{PRESENCE_ANT_PORT1} = "True";
$hash_EUTRA_FA_INFO{4}{ANR_UE_SEARCH_RATE} = "100.0";
$hash_EUTRA_FA_INFO{4}{PLMN2_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{4}{VOICE_SUPPORT1} = "True";
$hash_EUTRA_FA_INFO{4}{T_RESELECTION_SF_HIGH} = "oneDot0";
$hash_EUTRA_FA_INFO{4}{PLMN5_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{4}{PLMN0_SEARCH_RATE_FOR_IDLE_LB} = "1";
$hash_EUTRA_FA_INFO{4}{T_RESELECTION_SF_MEDIUM} = "oneDot0";
$hash_EUTRA_FA_INFO{4}{SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{4}{MNC0} = "120";
$hash_EUTRA_FA_INFO{4}{S_NON_INTRA_SEARCH_P} = "8";
$hash_EUTRA_FA_INFO{4}{PREFERENCE5} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{4}{S_NON_INTRA_SEARCH_Q} = "0";
$hash_EUTRA_FA_INFO{4}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{4}{P_MAX_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{4}{THRESH_SERVING_LOW_QREL9} = "0";
$hash_EUTRA_FA_INFO{4}{MCC1} = "FFF";
$hash_EUTRA_FA_INFO{4}{S_INTRA_SEARCH} = "29";
$hash_EUTRA_FA_INFO{4}{PLMN4_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{4}{Q_QUAL_MIN_REL9} = "-18";
$hash_EUTRA_FA_INFO{4}{Q_QUAL_MIN_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{4}{VOICE_SUPPORT2} = "True";
$hash_EUTRA_FA_INFO{4}{T_RESELECTION} = "1";
$hash_EUTRA_FA_INFO{4}{PREFERENCE3} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{4}{EARFCN_DL} = "8465";
$hash_EUTRA_FA_INFO{4}{OVERLAPPING_EARFCN_UL} = "26750,26750,26750,26750,26750,26750,26750,26750";
$hash_EUTRA_FA_INFO{4}{MNC4} = "FFF";
$hash_EUTRA_FA_INFO{4}{THRESH_XHIGH_QREL9} = "0";
$hash_EUTRA_FA_INFO{4}{S_NON_INTRA_SEARCH} = "7";
$hash_EUTRA_FA_INFO{4}{THRESH_XLOW_QREL9} = "4";
$hash_EUTRA_FA_INFO{4}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{4}{VOICE_SUPPORT0} = "True";
$hash_EUTRA_FA_INFO{4}{VOICE_SUPPORT4} = "True";
$hash_EUTRA_FA_INFO{4}{PREFERENCE0} = "preferred_prefer";
$hash_EUTRA_FA_INFO{4}{Q_RX_LEV_MIN} = "-60";
$hash_EUTRA_FA_INFO{4}{S_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{4}{THRESH_XLOW} = "5";
$hash_EUTRA_FA_INFO{4}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{4}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{4}{MEASUREMENT_BANDWIDTH} = "mbw25";
$hash_EUTRA_FA_INFO{4}{PRIORITY} = "5";
$hash_EUTRA_FA_INFO{4}{ADDITIONAL_SPECTRUM_EMISSION} = "1,1,1,1,1,1,1,1";
$hash_EUTRA_FA_INFO{4}{MCC5} = "FFF";
$hash_EUTRA_FA_INFO{4}{MIN_NRTSIZE_CARRIER} = "19";
$hash_EUTRA_FA_INFO{4}{VOICE_SUPPORT3} = "True";
$hash_EUTRA_FA_INFO{4}{SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{4}{EARFCN_UL} = "26465";
$hash_EUTRA_FA_INFO{4}{PLMN1_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{4}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{4}{ANR_ALLOW} = "use";
$hash_EUTRA_FA_INFO{4}{MEAS_CYCLE_SCELL} = "sf1280";
$hash_EUTRA_FA_INFO{4}{MNC1} = "FFF";
$hash_EUTRA_FA_INFO{4}{MCC3} = "FFF";
$hash_EUTRA_FA_INFO{4}{PREFERENCE4} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{4}{PLMN3_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{4}{MCC4} = "FFF";
$hash_EUTRA_FA_INFO{4}{VOICE_SUPPORT5} = "True";
$hash_EUTRA_FA_INFO{4}{FA_INDEX} = "4";
$hash_EUTRA_FA_INFO{4}{P_MAX} = "23";
$hash_EUTRA_FA_INFO{4}{MNC2} = "FFF";
$hash_EUTRA_FA_INFO{4}{S_NON_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{4}{THRESH_SERVING_LOW} = "3";
$hash_EUTRA_FA_INFO{4}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{5}{S_NON_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{5}{MNC5} = "FFF";
$hash_EUTRA_FA_INFO{5}{Q_OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{5}{SF_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{5}{STATUS} = "EQUIP";
$hash_EUTRA_FA_INFO{5}{HANDOVER_TYPE} = "A5";
$hash_EUTRA_FA_INFO{5}{PREFERENCE2} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{5}{THRESH_SERVING_LOW_QREL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{5}{S_INTRA_SEARCH_P} = "29";
$hash_EUTRA_FA_INFO{5}{MESA_BANDWIDTH_USAGE} = "use";
$hash_EUTRA_FA_INFO{5}{MCC0} = "310";
$hash_EUTRA_FA_INFO{5}{OFFSET_FREQ} = "0dB";
$hash_EUTRA_FA_INFO{5}{MNC3} = "FFF";
$hash_EUTRA_FA_INFO{5}{MCC2} = "FFF";
$hash_EUTRA_FA_INFO{5}{PREFERENCE1} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{5}{OVERLAPPING_EARFCN_DL} = "8750,8750,8750,8750,8750,8750,8750,8750";
$hash_EUTRA_FA_INFO{5}{S_INTRA_SEARCH_Q} = "5";
$hash_EUTRA_FA_INFO{5}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{5}{MOBILITY_PREFERENCE} = "None";
$hash_EUTRA_FA_INFO{5}{S_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{5}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{5}{NEIGH_CELL_CONFIG} = "1";
$hash_EUTRA_FA_INFO{5}{THRESH_XHIGH} = "0";
$hash_EUTRA_FA_INFO{5}{OVERLAPPING_BAND_ENABLE_FLAG} = "0,0,0,0,0,0,0,0";
$hash_EUTRA_FA_INFO{5}{PRESENCE_ANT_PORT1} = "True";
$hash_EUTRA_FA_INFO{5}{ANR_UE_SEARCH_RATE} = "100.0";
$hash_EUTRA_FA_INFO{5}{PLMN2_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{5}{VOICE_SUPPORT1} = "True";
$hash_EUTRA_FA_INFO{5}{T_RESELECTION_SF_HIGH} = "oneDot0";
$hash_EUTRA_FA_INFO{5}{PLMN5_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{5}{PLMN0_SEARCH_RATE_FOR_IDLE_LB} = "1";
$hash_EUTRA_FA_INFO{5}{T_RESELECTION_SF_MEDIUM} = "oneDot0";
$hash_EUTRA_FA_INFO{5}{SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{5}{MNC0} = "120";
$hash_EUTRA_FA_INFO{5}{S_NON_INTRA_SEARCH_P} = "8";
$hash_EUTRA_FA_INFO{5}{PREFERENCE5} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{5}{S_NON_INTRA_SEARCH_Q} = "0";
$hash_EUTRA_FA_INFO{5}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{5}{P_MAX_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{5}{THRESH_SERVING_LOW_QREL9} = "0";
$hash_EUTRA_FA_INFO{5}{MCC1} = "FFF";
$hash_EUTRA_FA_INFO{5}{S_INTRA_SEARCH} = "29";
$hash_EUTRA_FA_INFO{5}{PLMN4_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{5}{Q_QUAL_MIN_REL9} = "-18";
$hash_EUTRA_FA_INFO{5}{Q_QUAL_MIN_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{5}{VOICE_SUPPORT2} = "True";
$hash_EUTRA_FA_INFO{5}{T_RESELECTION} = "2";
$hash_EUTRA_FA_INFO{5}{PREFERENCE3} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{5}{EARFCN_DL} = "8763";
$hash_EUTRA_FA_INFO{5}{OVERLAPPING_EARFCN_UL} = "26750,26750,26750,26750,26750,26750,26750,26750";
$hash_EUTRA_FA_INFO{5}{MNC4} = "FFF";
$hash_EUTRA_FA_INFO{5}{THRESH_XHIGH_QREL9} = "0";
$hash_EUTRA_FA_INFO{5}{S_NON_INTRA_SEARCH} = "5";
$hash_EUTRA_FA_INFO{5}{THRESH_XLOW_QREL9} = "4";
$hash_EUTRA_FA_INFO{5}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{5}{VOICE_SUPPORT0} = "True";
$hash_EUTRA_FA_INFO{5}{VOICE_SUPPORT4} = "True";
$hash_EUTRA_FA_INFO{5}{PREFERENCE0} = "preferred_prefer";
$hash_EUTRA_FA_INFO{5}{Q_RX_LEV_MIN} = "-60";
$hash_EUTRA_FA_INFO{5}{S_INTRA_SEARCH_USAGE} = "use";
$hash_EUTRA_FA_INFO{5}{THRESH_XLOW} = "0";
$hash_EUTRA_FA_INFO{5}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{5}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA} = "100";
$hash_EUTRA_FA_INFO{5}{MEASUREMENT_BANDWIDTH} = "mbw25";
$hash_EUTRA_FA_INFO{5}{PRIORITY} = "4";
$hash_EUTRA_FA_INFO{5}{ADDITIONAL_SPECTRUM_EMISSION} = "1,1,1,1,1,1,1,1";
$hash_EUTRA_FA_INFO{5}{MCC5} = "FFF";
$hash_EUTRA_FA_INFO{5}{MIN_NRTSIZE_CARRIER} = "19";
$hash_EUTRA_FA_INFO{5}{VOICE_SUPPORT3} = "True";
$hash_EUTRA_FA_INFO{5}{SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{5}{EARFCN_UL} = "26763";
$hash_EUTRA_FA_INFO{5}{PLMN1_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{5}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA} = "0";
$hash_EUTRA_FA_INFO{5}{ANR_ALLOW} = "use";
$hash_EUTRA_FA_INFO{5}{MEAS_CYCLE_SCELL} = "sf1280";
$hash_EUTRA_FA_INFO{5}{MNC1} = "FFF";
$hash_EUTRA_FA_INFO{5}{MCC3} = "FFF";
$hash_EUTRA_FA_INFO{5}{PREFERENCE4} = "not_allowed_prefer";
$hash_EUTRA_FA_INFO{5}{PLMN3_SEARCH_RATE_FOR_IDLE_LB} = "0";
$hash_EUTRA_FA_INFO{5}{MCC4} = "FFF";
$hash_EUTRA_FA_INFO{5}{VOICE_SUPPORT5} = "True";
$hash_EUTRA_FA_INFO{5}{FA_INDEX} = "5";
$hash_EUTRA_FA_INFO{5}{P_MAX} = "23";
$hash_EUTRA_FA_INFO{5}{MNC2} = "FFF";
$hash_EUTRA_FA_INFO{5}{S_NON_INTRA_SEARCH_REL9_USAGE} = "no_use";
$hash_EUTRA_FA_INFO{5}{THRESH_SERVING_LOW} = "3";
$hash_EUTRA_FA_INFO{5}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA} = "100";


my (@inputMulti,$inputMulti);
# chop($ARGV[0]);
@inputMulti = split(/~/,$ARGV[0]);




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
      

foreach $inputMulti (@inputMulti){

    
my (@input);
@input = split(/,/,$inputMulti);          


$eNBName = $input[0];
$LSM = $input[1];
$IP = $input[2];
$user = $input[3];
$pass = $input[4];

if ($user eq "admin"){
     $user = "rz252372";
      
      }
if ($pass eq "ranadmin"){
     $pass = "Mina0803"; 
      
      }
# $user = "nacread01";
# $pass = "hmbrgr.246"; 

# if ($IP eq "10.158.34.233"){
# $pass = "hmrhed.643";     
# }      

  
$cascade = $input[5];
$mmbsoamip = $input[6];
$mmbssbip = $input[7];
$alphapci = $input[8];
$betapci  = $input[9];
$gammapci  = $input[10];
$alpharsi = $input[11];
$betarsi  = $input[12];
$gammarsi  = $input[13];
$tac  = $input[14];
$cabinet = $input[15];
$cabinet = uc($cabinet);

if (($cabinet eq "OUTDOOR (GROWTH CABINET)") || ($cabinet eq "OUTDOOR")){

$cabinet = "ADV_OUTDOOR_DIST_TYPE";

}

if ($cabinet eq "INDOOR"){

$cabinet = "ADV_INDOOR_DIST_TYPE";

}


print "\n$cabinet\n";
sleep 5;

$alphaid = $input[16];
$betaid = $input[17];
$gammaid = $input[18];
$alphatilt = $input[19];
$alphatilt = $alphatilt * 10;

$betatilt = $input[20];
$betatilt = $betatilt * 10;

$gammatilt = $input[21];
$gammatilt = $gammatilt * 10;
$earfcn = $input[22];
$startear = $input[23];
$enbid = $input[24];
$ltm = $input[25];
$zero_cq = $input[26];
$version_cq = $input[27];
$divciq = $input[28];
$triciq = $input[29];
$latciq = $input[30];
$longciq = $input[31];
$tddsecondcar = $input[32];
$tdd3rdcar = $input[33];
# sleep 5;
if ($alphatilt < 0){
      $alphatilt = $alphatilt * -1;
                   }
                  
if ($betatilt < 0){
      $betatilt = $betatilt * -1;
                   }                  

if ($gammatilt < 0){
      $gammatilt = $gammatilt * -1;
                   }


           if ($earfcn eq "40978"){
                  $startear = "40878";    
                                 } 
            if ($earfcn eq "39858"){
                  $startear = "39758";    
                                 }                                  
            if ($earfcn eq "40154"){
                  $startear = "40054";    
                                 }                                 
            if ($earfcn eq "41211"){
                  $startear = "41111";    
                                 }                                  
            if ($earfcn eq "40056"){
                  $startear = "39956";    
                                 }                                        
            if ($earfcn eq "41176"){
                  $startear = "41076";    
                                 } 
            if ($earfcn eq "40521"){
                  $startear = "40421";    
                                 } 
            if ($earfcn eq "39826"){
                  $startear = "39726";    
                                 } 
            if ($earfcn eq "39926"){
                  $startear = "39826";    
                                 }
            if ($earfcn eq "39891"){
                  $startear = "39791";    
                                 }   
                                 
            if ($earfcn eq "41013"){
                  $startear = "40913";    
                                 }                                   
            if ($earfcn eq "41374"){
                  $startear = "41190";    
                                 }  
            if ($earfcn eq "40254"){
                  $startear = "40154";    
                                 }                                      
            if ($earfcn eq "41276"){
                  $startear = "41176";    
                                 } 
                                 
            if ($earfcn eq "41078"){
                  $startear = "40978";    
                                 }           
            if ($earfcn eq "39956"){
                  $startear = "39856";    
                                 }  

	
	@split_lat_info = split(/\./, $latciq);


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

          # if ($lat_degree > 0) {
          # $lat_direction = "N";
                     # }

          # if ($lat_degree < 0) {
                    # $lat_direction = "W";
                     # }

          $lat_degree =~ s/-//g;
          $lat_degree = sprintf("%03d", $lat_degree);
          $lat_minutes = sprintf("%02d", $lat_minutes);

          if ($dot_sec_value < 10){
          $dot_sec_value = "0$dot_sec_value";           
                        }
          # print ("$lat_direction $lat_degree:$lat_minutes:$dot_sec_value\n");
	  my $convert_lat = "$lat_direction $lat_degree:$lat_minutes:$dot_sec_value";
          $convert_lat =~ s/\s+//g;

          @split_lat_info = "";
          @split_lat_min = "";
          $lat_direction = "";
          $lat_degree = "";
          $lat_minutes	 = ""; 
          $lat = "" ;
          
	@split_lat_info = split(/\./, $longciq);


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

          # if ($lat_degree > 0) {
          # $lat_direction = "N";
                     # }

          # if ($lat_degree < 0) {
                    # $lat_direction = "W";
                     # }

          $lat_degree =~ s/-//g;
          $lat_degree = sprintf("%03d", $lat_degree);
          $lat_minutes = sprintf("%02d", $lat_minutes);

          if ($dot_sec_value < 10){
          $dot_sec_value = "0$dot_sec_value";           
                        }
          # print ("$lat_direction $lat_degree:$lat_minutes:$dot_sec_value\n");
	  my $convert_long = "$lat_direction $lat_degree:$lat_minutes:$dot_sec_value";
          $convert_long =~ s/\s+//g;
          
my (@mme_ips,$mme_ips);
my (@vlan_conf,$vlan_conf);
my (@ip_addr,$ip_addr);
my (@ip_route,$ip_route);
my (@ntp);
my (@cell_idle);
my (@prach_conf);
my (@tac);
my (@gps);
my (@rrh_invt);
my ($port6,$port8,$port10);
my (@eaiu_invt);
my (@s1);
my (@x2);
my (@ret);
my (@alarm_data);
my (@alarm_log);
my ($punc_data,$timer_data);
my ($DL_ANT_COUNT,$UL_ANT_COUNT);
my (@alphaeutranlog,@betaeutranlog,@gammaeutranlog,@alphaeutranlog2,@betaeutranlog2,@gammaeutranlog2);
my (@src,@sonfn,@cdd,@rrh,@pos,@bf,@ltm,@ULRESCONF,@c1xrttpreg,@eutra_fa,@cellplmn35x,@enbplmn35x,@iact,@CTRL,@sel,@drx,@bfconf,@puschconf,@socfw,@socsw,@prcfw,@cell_bar);
my (@encacoloc,@CaInterFreq,@pucchconf,@encasched,@encacellinfo,@cabandinfo,@actlb,@aldinvt,@celluecnt);
my (@celldata);
my (@sys_conf);

my (@bcchconf,@anrsched,@bhbw,@bcls,@lsmFREQ,@lsmECSFB,@lsmPRD,@lsmOVL,@lsmMOBIL,@lsmPREG,@cddconf,@cdmaconf,@cellgp,@cellinfogp,@cellrsel,@cellsel,@dlshed,@A1cnf,@A2cnf,@A3cnf,@A5cnf,@A6cnf,@hoopt,@inacttimer,@intwoopt,@lochinf,@measfunc,@pcchconf,@qcival,@dscptrf,@rochinf,@sctpparam,@enbconnpara,@secuinf,@sibinf,@dscpsig,@sonanr,@sondlic,@sonso,@srbrlc,@dscpsys,@timeinf,@plmnsigtimer,@trchbsr,@ulpwrctrl,@ULRESCONF,@tpcconf,@eutrafagp,@cellcacgp,@encacgp);
my ($bhbwgp,$bcchgp,$anrgp,$bfconfgp,$bclsgp,$freqgp,$ovlgp,$prdgp,$preggp,$mobilgp,$ecsfbgp,$cddgp,$cdmagp,$cellgp,$cellinfogp,$cellrselgp,$cellselgp,$dlschedgp,$drxgp,$A1cnfgp,$A3cnfgp,$A5cnfgp,$A6cnfgp,$hooptgp,$inacttimergp,$intwooptgp,$lochinfgp,$measfunc,$pcchconf,$puschconf,$qcivalgp,$dscptrfgp,$rochinfgp,$sctpparam,$enbconnparagp,$secuinfgp,$sibinf,$dscpsiggp,$sonanrgp,$sondlic,$sonso,$sonfngp,$srbrlc,$dscpsysgp,$timeinfgp,$plmnsigtimergp,$trchbsrgp,$ulpwrctrlgp,$ULRESCONFgp,$tpcconfgp,$eutrafagp);

open (FILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\Audit_2.5\\Logs\\$cascade\_2500_AUDIT_$now.txt");

my $ssh_lsm = new Control::CLI(Use => 'SSH',
                        Prompt => ']',
			Errmode=> 'return',
                        Timeout=> '240');

my $connect = $ssh_lsm->connect(Host => $IP,
          Username => $user,
          Password => $pass,
        PrivateKey => '.ssh/id_dsa');

if ($connect) {		#start if connected


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cd /home/nacread01/");
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cd .ssh/");
$ssh_lsm->waitfor("]");
$ssh_lsm->print("rm known_hosts");
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cd ..");

######################################3

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


my ($database_name);

if (($info =~ m/4.0/) || ($info =~ m/5.0/)) {
$database_name = "mc_db";
                                                                    }
else {
$database_name = "lsm_db";
     }


#print ("$database_name\n");

$ssh_lsm->print("/db/mysql/app/bin/mysql -ulsm -plsm $database_name;");
my $sql_start = $ssh_lsm->waitfor('mysql>');

$ssh_lsm->print("select level2_id,ems_alias from cm_v_level2andcoord_lsm;");
my $BUCKETS = $ssh_lsm->waitfor('mysql>');


# print "$BUCKETS\n\n\n";

my (@raw_bucket, $raw_bucket);

@raw_bucket = split(/\n/, $BUCKETS);
foreach $raw_bucket (@raw_bucket) {
$raw_bucket =~ s/^\|\s+//g;
$$raw_bucket =~ s/\|\s+$//g;
$raw_bucket =~ s/\s+$//g;
$raw_bucket =~ s/\s+\|\s+/\t/g;
if (($raw_bucket =~ m/^\d+/) && ($raw_bucket !~ m/rows\s+in\s+set/)) {
push (@array_bucket,$raw_bucket);


                                                                     }
                               }
                                                              


# foreach $_ (@array_bucket){
            
    # print "$_\n";        
          
          # }




$ssh_lsm->print("select system_id,ems_alias,level2_id,level3_id,ip_addr_1,version,cur_pkg_ver from cm_v_level3_lsm;");
my $ENODEBS = $ssh_lsm->waitfor('mysql>');

# print "$ENODEBS\n\n\n";

my (@array_data_enb, $array_data_enb);
@array_data_enb = split(/\n/, $ENODEBS);
foreach $array_data_enb (@array_data_enb) {
$array_data_enb =~ s/^\|\s+//g;
$array_data_enb =~ s/\|\s+$//g;
$array_data_enb =~ s/\s+$//g;
$array_data_enb =~ s/\s+\|\s+/\t/g;
$array_data_enb =~ s/\r+//g;
if (($array_data_enb !~ m/rows\s+in\s+set/) && ($array_data_enb !~ m/system_id/)) {
@_ = split(/\t+/, $array_data_enb);

if (($_[0] =~ m/\d+/)) {		#start if $_[0]

my $level_enb = $_[2];           
my $enBname  = $_[1];
my $endid = $_[0];
my $data = "$enBname,$endid,$level_enb";

push (@grown_sites,$data); 


                       }		




                                                                                  }
                                           }

$ssh_lsm->print('exit');
$ssh_lsm->waitfor(']');

#######################################
# $ssh_lsm->waitfor("]");
# $ssh_lsm->print("cd /log/STATools/Scripts/4G_REPORTS");
# my $log = $ssh_lsm->waitfor("]");
# # print $log;

# $ssh_lsm->print("/usr/bin/sudo -u lsm /log/STATools/Scripts/4G_REPORTS/LSM_R_ActiveAlarm.sh;pwd");
# $ssh_lsm->waitfor("4G_REPORTS");
# my $buf_4g_alm = $ssh_lsm->waitfor("4G_REPORTS");
# # print "$buf_4g_alm\n";


# $buf_4g_alm =~s/~//g;
# $buf_4g_alm =~s/level2_id\tems_alias\tlevel3_id\tsystem_id\tip_addr_1\tversion\tcur_pkg_ver/~/g;
# $buf_4g_alm =~s/level2_id\tems_alias/~/g;
                                        
# # print $buf_4g_alm;

# my (@array_other_info, $array_other_info);
# @array_other_info = split(/~/, $buf_4g_alm);

# my (@array_bucket,$array_bucket);

# @array_bucket = split (/\n/,$array_other_info[1]);


# my (@array_enb,$array_enb);


# @array_enb = split (/\n/,$array_other_info[2]);

# foreach $array_enb(@array_enb){

# @_ = split(/\t+/, $array_enb);          
          
          

           
# if ($array_enb =~ m/\d+/){          

# my $level_enb = $_[0];           
# my $enBname  = $_[1];
# my $endid = $_[3];
# my $data = "$enBname,$endid,$level_enb";



            # push (@grown_sites,$data); 

                             # }   
                                  # }  
                                  

foreach $grown_sites(@grown_sites){

# print "$grown_sites\n\n\n";

@_ = split(/,/, $grown_sites);  

my $enbIdgrown = $_[1];
my $level = $_[2];
if ($enbIdgrown eq $enbid){
      
foreach $array_bucket (@array_bucket){
       
      @_ = split(/\t+/, $array_bucket);
      if ($level eq $_[0]){
            
          $bucket = $_[1];   
          $bucket =~ s/\s+//g;                         
                              }
                                    }
$bucket = uc($bucket); 
$bucket =~ s/\|//g;

}                                                      
}


# print "$bucket\n\n\n";

if (($bucket =~ m/CLEVELAND/) || ($bucket =~ m/TOLEDO/) || ($bucket =~ m/OHIO/) || ($bucket =~ m/PENNSYLVANIA/) || ($bucket =~ m/NORTHERN_JERSEY/) || ($bucket =~ m/COLUMBUS/) || ($bucket =~ m/PITTSBURGH/) || ($bucket =~ m/MICHIGAN/) || ($bucket =~ m/BUFFALO/) || ($bucket =~ m/ROCHESTER/) ||($bucket =~ m/UPSTATE/) || ($bucket =~ m/CINCINNATI/) || ($bucket =~ m/VIRGINIA/) || ($bucket =~ m/CHICAGO/) || ($bucket =~ m/KENTUCKY/) || ($bucket =~ m/ILLINOIS/) || ($bucket =~ m/INDIANAPOLIS/) || ($bucket =~ m/MILWAUKEE/) || ($bucket =~ m/INDY/) || ($bucket =~ m/BAYAMON/) || ($bucket =~ m/ROCKFORD/) || ($bucket =~ m/BERLIN/) || ($bucket =~ m/WAYNE/) || ($bucket =~ m/GOOGLE/) || ($bucket =~ m/IOWA/) || ($bucket =~ m/MISSOURI/) || ($bucket =~ m/MINNESOTA/) || ($bucket =~ m/DAKOTAS/) || ($bucket =~ m/WISCONSIN/)){
$mme_assignment = "Chicago_Akron";
$mme_bool = "true";	
}
	
	
if (($bucket =~ m/WASHINGTON/) || ($bucket =~ m/FRANCISCO/) || ($bucket =~ m/COLORADO/) || ($bucket =~ m/UTAH/) || ($bucket =~ m/INLAND/) || ($bucket =~ m/LCV/) || ($bucket =~ m/BAY/) || ($bucket =~ m/UCV/) || ($bucket =~ m/APPLE/) || ($bucket =~ m/RENO/) || ($bucket =~ m/RENO/) || ($bucket =~ m/OREGON/) || ($bucket =~ m/SWWA/) || ($bucket =~ m/IDAHO/)){
$mme_assignment = "San_Jose_Tacoma";	
$mme_bool = "true";	
}

if ($bucket =~ m/PRVI/) {
$mme_assignment = "Bayamon";	
$mme_bool = "true";	
}

if ($mme_bool ne "true"){
      
$mme_assignment = "Chicago_Akron";      
      }


# $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PKG-VER;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $STATUS = $_[4];
                    my $PKG_VER  = $_[2];
		    if ($STATUS eq "ACTIVE"){
		            $pkg  = $PKG_VER;

                    
                                            }                 
          
                                                   
                                                   }	
	       }



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-MME-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_mme,$split_each_line_mme);
@split_each_line_mme = split (/\n/,$Log);

foreach $split_each_line_mme (@split_each_line_mme){
          
          
          if ($split_each_line_mme =~ m/^\s+\d+/) {
                    
                    
                    @_ = split (/\s+/,$split_each_line_mme);
                    if ($_[1] <= 13){
                    my $mme_index = $_[1];
                    my $mme_ip = $_[5];
                    my $data = "$mme_index,$mme_ip";
                    push (@mme_ips,$data);
                    }
                                              }

          
                                                   
                                                   }



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SYS-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/) {
                    
                    
                    @_ = split (/\s+/,$split_each_line_vlan);
                    
                    my $SYS_ID = $_[1];
                    my $STATUS = $_[2];
                    my $ADMINISTRATIVE_STATE = $_[3];
                    my $TYPE = $_[4];
                    my $SYS_TYPE = $_[5];
					my $data = "$SYS_ID,$STATUS,$ADMINISTRATIVE_STATE,$TYPE,$SYS_TYPE";
					push(@sys_conf,$data);
                                              }

          
                                                   
                                                   }												   
												   
												   
												   
												   
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-VLAN-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/) {
                    
                    
                    @_ = split (/\s+/,$split_each_line_vlan);
                    
                    my $db_index = $_[1];
                    my $vr_id = $_[2];
                    my $if_name = $_[3];
                    my $vlan_id = $_[4];
                    my $admin = $_[5];
                    my $des = $_[6];
                    my $data = "$db_index,$vr_id,$if_name,$vlan_id,$admin,$des";
                    push (@vlan_conf,$data);
                   
                                              }

          
                                                   
                                                   }
                                                   
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-IP-ADDR;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/) {
                    
                    
                    @_ = split (/\s+/,$split_each_line_vlan);
                    
                    my $db_index = $_[1];
                    my $if_name = $_[2];
                    my $ip_addr = $_[3];
                    my $ip_len = $_[4];
                    my $oam = $_[6];
                    my $lte_signal_s1 = $_[7];
                    my $lte_signal_x2 = $_[8];
                    my $lte_bearer_s1 = $_[9];
                    my $lte_bearer_x2 = $_[10];
                    my $data = "$db_index,$if_name,$ip_addr,$ip_len,$oam,$lte_signal_s1,$lte_signal_x2,$lte_bearer_s1,$lte_bearer_x2";
                    push (@ip_addr,$data);
                   
                                              }

          
                                                   
                                                   }




$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-IP-ROUTE;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/) {
                    
                    
                    @_ = split (/\s+/,$split_each_line_vlan);
                    
                    my $VR_ID = $_[1];
                    my $DB_INDEX = $_[2];
                    my $IP_PREFIX = $_[3];
                    my $iIP_PFX_LEN = $_[4];
                    my $IP_GW = $_[5];
                    my $DISTANCE = $_[6];
                    my $data = "$VR_ID,$DB_INDEX,$IP_PREFIX,$iIP_PFX_LEN,$IP_GW,$DISTANCE";
                    push (@ip_route,$data);
                   
                                              }

          
                                                   
                                                   }



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NTP-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;



my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if (($split_each_line_vlan =~ m/PRIMARY/) || ($split_each_line_vlan =~ m/SECONDARY/)){
                @_ = split (/\s+/,$split_each_line_vlan);
                    my $prim_ntp_name = $_[1];
                    my $ntp_ip = $_[3];
                    my $data = "$prim_ntp_name,$ntp_ip";                   
                    push (@ntp,$data);                 
                    
                                                  }                 
          
                                                   
                                                   }
                                                   
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-IDLE;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                    
                    my $CELL_NUM = $_[1];
                    if (($CELL_NUM eq "3") || ($CELL_NUM eq "4") || ($CELL_NUM eq "5" )){
                          $secondcar = "true";
                          }
                    if (($CELL_NUM eq "9") || ($CELL_NUM eq "10") || ($CELL_NUM eq "11" )){
                          $secondcar4T = "true";
                          }
                    if (($CELL_NUM eq "6") || ($CELL_NUM eq "7") || ($CELL_NUM eq "8" )){
                          $thirdcar = "true";
                          
                          }                                   
                    my $PHY_CELL_ID = $_[3];
                    $DL_ANT_COUNT = $_[6];
                    $UL_ANT_COUNT = $_[7];
                    my $EARFCN_DL= $_[8];
                    my $EARFCN_UL= $_[9];
					my $CELL_TYPE= $_[4];
					my $DUPLEX_TYPE= $_[5];
					my $FREQUENCY_BAND_INDICATOR= $_[12];
                    my $SUBFRAME_ASSIGNMENT= $_[14];
                    my $SPECIAL_SUBFRAME_PATTERNS= $_[15];
					my $FORCED_MODE= $_[16];
					my $DL_CRS_PORT_COUNT= $_[17];
                    my $data = "$CELL_NUM,$PHY_CELL_ID,$DL_ANT_COUNT,$UL_ANT_COUNT,$EARFCN_DL,$EARFCN_UL,$CELL_TYPE,$DUPLEX_TYPE,$FREQUENCY_BAND_INDICATOR,$SUBFRAME_ASSIGNMENT,$SPECIAL_SUBFRAME_PATTERNS,$FORCED_MODE,$DL_CRS_PORT_COUNT";                    
                    push (@cell_idle,$data);                 
                    
                                                  }                 
          
                                                   
                                                   }
                                                   
                                                   
                                                   
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PRACH-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                    my $CELL_NUM = $_[1];
                    my $ROOT_SEQUENCE_INDEX = $_[5];
                    my $zero = $_[4];
                    my $data = "$CELL_NUM,$ROOT_SEQUENCE_INDEX,$zero";                    
                    push (@prach_conf,$data);                 
                    
                                                  }                 
          
                                                   
                                                   }
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-INFO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($pkg ne "3.5.2"){
                    if ($_[1] <= 11){
                    my $CELL_NUM = $_[1];
                    my $CELL_RESERVED_OP_USE0 = $_[6];
                    my $TRACKING_AREA_CODE = $_[23];
                    my $MCC0 = $_[4];
                    my $MNC0 = $_[5];               
                    my $MCC1 = $_[7];
                    my $MNC1 = $_[8];
                    my $CELL_RESERVED_OP_USE1 = $_[9];
                    my $data = "$CELL_NUM,$CELL_RESERVED_OP_USE0,$TRACKING_AREA_CODE,$MCC0,$MNC0,$MCC1,$MNC1,$CELL_RESERVED_OP_USE1";                    
                    push (@tac,$data);
                   }                 
                } 
                if (($pkg eq "3.5.2") || ($pkg eq "4.0.2")){
                    if ($_[1] <= 11){
                    my $CELL_NUM = $_[1];
                    my $CELL_SIZE = $_[2];
                    my $HNB_NAME = $_[3];
                    my $ADD_SPECTRUM_EMISSION = $_[4];
                    my $TRACKING_AREA_CODE = $_[5];
                    my $IMS_EMERGENCY_SUPPORT = $_[6];
                    my $data = "$CELL_NUM,$CELL_SIZE,$HNB_NAME,$ADD_SPECTRUM_EMISSION,$TRACKING_AREA_CODE,$IMS_EMERGENCY_SUPPORT";                    
                    push (@tac,$data);
                   }                 
                }              
             
             
             
             
             
             
             
                                                  }                 
          
                                                   
                                                   }
                                                   
###################################
# START RTRV-CELL-ACS 11/25/2015  #
###################################
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-ACS;");
$ssh_lsm->waitfor(";");
my $RTRV_CELL_ACS = $ssh_lsm->waitfor(';');
print $RTRV_CELL_ACS;
print FILE $RTRV_CELL_ACS;

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
my $CELL_RESERVED_OP_USE_value = $hash_CELL_ACS_TITLE{CELL_RESERVED_OP_USE};


my $CELL_NUM = "$_[$CELL_NUM_value]";
$CELL_NUM =~ s/\s+//g;


my $CELL_RESERVED_OP_USE = "$_[$CELL_RESERVED_OP_USE_value]";
$CELL_RESERVED_OP_USE =~ s/\s+//g;


if ($CELL_RESERVED_OP_USE =~ m/\,/) {
$CELL_RESERVED_OP_USE_INFO = $CELL_RESERVED_OP_USE;
@_ = split(/,/, $CELL_RESERVED_OP_USE_INFO);

$hash_4g_cell_reserved{$CELL_NUM}{0} = $_[0];	#PLMN = 0
$hash_4g_cell_reserved{$CELL_NUM}{1} = $_[1];	#PLMN = 0
                                    }
                                             }



                                                              }	#end foreach line of log

                   }
###################################
#  END RTRV-CELL-ACS 11/25/2015   #
###################################
												   
if (($pkg eq "4.0.2") || ($pkg eq "5.0.2")){

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELLPLMN-INFO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                if ($secondcar eq "true"){
                if ((($_[1] eq "0") || ($_[1] eq "1") || ($_[1] eq "2") || ($_[1] eq "3") || ($_[1] eq "4") || ($_[1] eq "5")) && (($_[2] eq "0") || ($_[2] eq "1"))){
                    my ($CELL_RESERVED_OP_USE);  
                    my $CELL_NUM = $_[1];
                    my $PLMN_IDX = $_[2];
                    my $PLMN_USAGE = $_[3];
					if ($hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX}) {
					$CELL_RESERVED_OP_USE = $hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX};
					                                                  }
					else {
                    $CELL_RESERVED_OP_USE = $_[4];  
                         }                    
                    my $data = "$CELL_NUM,$PLMN_IDX,$PLMN_USAGE,$CELL_RESERVED_OP_USE";  
                    if ($PLMN_IDX <= 1){
                    push (@cellplmn35x,$data); 
                              }
                      }
                }
                if ($secondcar4T eq "true"){
                if ((($_[1] eq "0") || ($_[1] eq "1") || ($_[1] eq "2") || ($_[1] eq "9") || ($_[1] eq "10") || ($_[1] eq "11")) && (($_[2] eq "0") || ($_[2] eq "1"))){
                    my ($CELL_RESERVED_OP_USE);   
                    my $CELL_NUM = $_[1];
                    my $PLMN_IDX = $_[2];
                    my $PLMN_USAGE = $_[3];
					if ($hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX}) {
					$CELL_RESERVED_OP_USE = $hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX};
					                                                  }
					else {
                    $CELL_RESERVED_OP_USE = $_[4];  
                         }         
                    my $data = "$CELL_NUM,$PLMN_IDX,$PLMN_USAGE,$CELL_RESERVED_OP_USE";  
                    if ($PLMN_IDX <= 1){
                    push (@cellplmn35x,$data); 
                              }
                      }
                }  
                if ($thirdcar eq "true"){
                if ((($_[1] eq "0") || ($_[1] eq "1") || ($_[1] eq "2") || ($_[1] eq "3") || ($_[1] eq "4") || ($_[1] eq "5") || ($_[1] eq "6") || ($_[1] eq "7") || ($_[1] eq "8")) && (($_[2] eq "0") || ($_[2] eq "1"))){
                    my ($CELL_RESERVED_OP_USE);   
                    my $CELL_NUM = $_[1];
                    my $PLMN_IDX = $_[2];
                    my $PLMN_USAGE = $_[3];
					if ($hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX}) {
					$CELL_RESERVED_OP_USE = $hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX};
					                                                  }
					else {
                    $CELL_RESERVED_OP_USE = $_[4];  
                         }         
                    my $data = "$CELL_NUM,$PLMN_IDX,$PLMN_USAGE,$CELL_RESERVED_OP_USE";  
                    if ($PLMN_IDX <= 1){
                    push (@cellplmn35x,$data); 
                              }
                      }
                }                
                
                              
                if (($secondcar ne "true") && ($secondcar4T ne "true")){
                if (($_[1] eq "0") || ($_[1] eq "1") || ($_[1] eq "2")){
                    my ($CELL_RESERVED_OP_USE);   
                    my $CELL_NUM = $_[1];
                    my $PLMN_IDX = $_[2];
                    my $PLMN_USAGE = $_[3];
					if ($hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX}) {
					$CELL_RESERVED_OP_USE = $hash_4g_cell_reserved{$CELL_NUM}{$PLMN_IDX};
					                                                  }
					else {
                    $CELL_RESERVED_OP_USE = $_[4];  
                         }         
                    my $data = "$CELL_NUM,$PLMN_IDX,$PLMN_USAGE,$CELL_RESERVED_OP_USE"; 
                    if ($PLMN_IDX <= 1){ 
                    push (@cellplmn35x,$data); 
                    }
                      }
                }                
                
          }            
      
      
}      



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ENBPLMN-INFO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                      
                    my $PLMN_IDX = $_[1];
                    my $MCC = $_[2];
                    my $MNC = $_[3];
                    my $OP_ID = $_[4];                      
                    my $data = "$PLMN_IDX,$MCC,$MNC,$OP_ID";  
                    push (@enbplmn35x,$data); 
                
                
                
          }            
      
      
}    

}                                                  

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-GPS-INVT;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/UCCM/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CELL_NUM = $_[1];
                    my $VERSION = $_[5];
                    my $FW_VERSION = $_[6];
                    my $SERIAL = $_[7];
                    my $VENDOR = $_[8];
                    my $data = "$CELL_NUM,$VERSION,$FW_VERSION,$SERIAL,$VENDOR";                    
                    push (@gps,$data);
                                   
                    
                                                  }                 
          
                                                   
                                                   }
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-GPS-STS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-RRH-INVT;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CONN_BD_ID = $_[1];
                    my $CONN_PORT_ID = $_[2];
                    my $UNIT_ID = $_[3];
                    my $FAMILY_TYPE = $_[4];
                    my $FW_VERSION = $_[8];
                    my $SERIAL = $_[9];
                    my $data = "$CONN_BD_ID,$CONN_PORT_ID,$UNIT_ID,$FAMILY_TYPE,$FW_VERSION,$SERIAL";                    
                    push (@rrh_invt,$data);
                                  
                    
                                                  }                 
          
                                                   
                                                   }




$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-RRH-CONF:0,6;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    if ($pkg ne "3.5.2"){
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID = $_[2];
                    my $CELL_NUM = $_[4];
                    my $POWER_BOOST = $_[35];
                    my $NUM_OF_ALD = $_[36];
                    my $DIGITAL_INPUT_LOW_ALARM_TH = $_[39];
                    my $profile_id = $_[40];
                    my $START_EARFCN1 = $_[41];
                    # }                    
                    $port6 = "$CONNECT_BOARD_ID~$CONNECT_PORT_ID~$POWER_BOOST~$NUM_OF_ALD~$DIGITAL_INPUT_LOW_ALARM_TH~$START_EARFCN1~$profile_id~$CELL_NUM";                    
                    }
                    
                    if (($pkg eq "3.5.2") || ($pkg eq "4.0.2")||($pkg eq "5.0.2")){
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID = $_[2];
                    my $CELL_NUM = $_[4];
                    my $POWER_BOOST = $_[35];
                    my $NUM_OF_ALD = $_[36];
                    my $DIGITAL_INPUT_LOW_ALARM_TH = $_[39];
                    my $profile_id = $_[40];
                    my $START_EARFCN1 = $_[44];
                    # }                    
                    $port6 = "$CONNECT_BOARD_ID~$CONNECT_PORT_ID~$POWER_BOOST~$NUM_OF_ALD~$DIGITAL_INPUT_LOW_ALARM_TH~$START_EARFCN1~$profile_id~$CELL_NUM";                    
                    }                    
                                  
                    
                                                  }                 
          
                                                   
                                                   }
                                                    

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-RRH-CONF:0,8;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    if ($pkg ne "3.5.2"){
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID = $_[2];
                    my $CELL_NUM = $_[4];
                    my $POWER_BOOST = $_[35];
                    my $NUM_OF_ALD = $_[36];
                    my $DIGITAL_INPUT_LOW_ALARM_TH = $_[39];
                    my $profile_id = $_[40];
                    my $START_EARFCN1 = $_[41];

                    $port8 = "$CONNECT_BOARD_ID~$CONNECT_PORT_ID~$POWER_BOOST~$NUM_OF_ALD~$DIGITAL_INPUT_LOW_ALARM_TH~$START_EARFCN1~$profile_id~$CELL_NUM";                    
                   }
                    if (($pkg eq "3.5.2") || ($pkg eq "4.0.2")||($pkg eq "5.0.2")){
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID = $_[2];
                    my $CELL_NUM = $_[4];
                    my $POWER_BOOST = $_[35];
                    my $NUM_OF_ALD = $_[36];
                    my $DIGITAL_INPUT_LOW_ALARM_TH = $_[39];
                    my $profile_id = $_[40];
                    my $START_EARFCN1 = $_[44];

                    $port8 = "$CONNECT_BOARD_ID~$CONNECT_PORT_ID~$POWER_BOOST~$NUM_OF_ALD~$DIGITAL_INPUT_LOW_ALARM_TH~$START_EARFCN1~$profile_id~$CELL_NUM";                    
                   }              
              
                                  
                    
                                                  }                 
          
                                                   
                                                   }


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-RRH-CONF:0,10;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          # $split_each_line_vlan =~ s/-//g;
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    if ($pkg ne "3.5.2"){                    
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID = $_[2];
                    my $CELL_NUM = $_[4];
                    my $POWER_BOOST = $_[35];
                    my $NUM_OF_ALD = $_[36];
                    my $DIGITAL_INPUT_LOW_ALARM_TH = $_[39];
                    my $profile_id = $_[40];
                    my $START_EARFCN1 = $_[41];
                    # }  
                    $port10 = "$CONNECT_BOARD_ID~$CONNECT_PORT_ID~$POWER_BOOST~$NUM_OF_ALD~$DIGITAL_INPUT_LOW_ALARM_TH~$START_EARFCN1~$profile_id~$CELL_NUM";                    
                  }
                    if (($pkg eq "3.5.2") || ($pkg eq "4.0.2")||($pkg eq "5.0.2")){                   
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID = $_[2];
                    my $CELL_NUM = $_[4];
                    my $POWER_BOOST = $_[35];
                    my $NUM_OF_ALD = $_[36];
                    my $DIGITAL_INPUT_LOW_ALARM_TH = $_[39];
                    my $profile_id = $_[40];
                    my $START_EARFCN1 = $_[44];
                     
                    $port10 = "$CONNECT_BOARD_ID~$CONNECT_PORT_ID~$POWER_BOOST~$NUM_OF_ALD~$DIGITAL_INPUT_LOW_ALARM_TH~$START_EARFCN1~$profile_id~$CELL_NUM";                    
                  }                                  
                    
                                                  }                 
          
                                                   
                                                   }


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EAIU-INVT;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+EAIU/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $UNIT_ID = $_[1];
                    my $FAMILY_TYPE = $_[2];
                    my $TYPE_NUM = $_[4];
                    my $PKG_VERSION = $_[5];
                    my $FW_VERSION = $_[6];
                    my $SERIAL = $_[7];
                    
                    
                    my $data = "$UNIT_ID,$FAMILY_TYPE,$FW_VERSION,$SERIAL,$PKG_VERSION,$TYPE_NUM";                    
                    push (@eaiu_invt,$data);
                                   
                    
                                                  }                 
          
                                                   
                                                   }


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EAIU-STS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-S1-STS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;



my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $MME_INDEX = $_[1];
                    my $MME_ID = $_[2];
                    my $SCTP_STATE = $_[3];
                    my $S1AP_STATE = $_[4];
                    my $MME_NAME = $_[5];
                    my $IP_VER = $_[6];
                    my $MME_IP_V4 = $_[7];
                    my $data = "$MME_INDEX,$MME_ID,$SCTP_STATE,$S1AP_STATE,$MME_NAME,$IP_VER,$MME_IP_V4";                    
                    push (@s1,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-X2-STS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $NBR_ENB_INDEX = $_[1];
                    my $NBR_ENB_ID = $_[2];
                    my $SCTP_STATE = $_[3];
                    my $X2AP_STATE = $_[4];
                    my $data = "$NBR_ENB_INDEX,$NBR_ENB_ID,$SCTP_STATE,$X2AP_STATE";                    
                    push (@x2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EUTRA-FA;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CELL_NUM = $_[1];
                    my $FA_INDEX  = $_[2];
                    my $STATUS  = $_[3];
                    my $EARFCN_UL = $_[4];
                    my $EARFCN_DL = $_[5];
                    
                    if (($CELL_NUM eq "0") && ($FA_INDEX eq "0")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if (($CELL_NUM eq "1") && ($FA_INDEX eq "0")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if (($CELL_NUM eq "2") && ($FA_INDEX eq "0")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }      
                    
                    if ((($CELL_NUM eq "0") && ($FA_INDEX eq "1")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "1") && ($FA_INDEX eq "1")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "2") && ($FA_INDEX eq "1")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }                     

                    if ((($CELL_NUM eq "0") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "1") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "2") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }     
                                        
                                    
                    if ((($CELL_NUM eq "3") && ($FA_INDEX eq "0")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "4") && ($FA_INDEX eq "0")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "5") && ($FA_INDEX eq "0")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }                       


                    if ((($CELL_NUM eq "3") && ($FA_INDEX eq "1")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "4") && ($FA_INDEX eq "1")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "5") && ($FA_INDEX eq "1")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }    

                    if ((($CELL_NUM eq "3") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "4") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "5") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }                      



                    if ((($CELL_NUM eq "3") && ($FA_INDEX eq "0")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "4") && ($FA_INDEX eq "0")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "5") && ($FA_INDEX eq "0")) && ($secondcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }                       


                    if ((($CELL_NUM eq "6") && ($FA_INDEX eq "0")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "7") && ($FA_INDEX eq "0")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "8") && ($FA_INDEX eq "0")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }    

                    if ((($CELL_NUM eq "6") && ($FA_INDEX eq "1")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "7") && ($FA_INDEX eq "1")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "8") && ($FA_INDEX eq "1")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    } 

                    if ((($CELL_NUM eq "6") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "7") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "8") && ($FA_INDEX eq "2")) && ($thirdcar eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    } 



                    if ((($CELL_NUM eq "0") && ($FA_INDEX eq "1")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "1") && ($FA_INDEX eq "1")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "2") && ($FA_INDEX eq "1")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }                     
                    
                                    
                    if ((($CELL_NUM eq "9") && ($FA_INDEX eq "0")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "10") && ($FA_INDEX eq "0")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "11") && ($FA_INDEX eq "0")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }                       


                    if ((($CELL_NUM eq "9") && ($FA_INDEX eq "1")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }
                    if ((($CELL_NUM eq "10") && ($FA_INDEX eq "1")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                   
                    push (@eutra_fa,$data);               
                    }  
                    if ((($CELL_NUM eq "11") && ($FA_INDEX eq "1")) && ($secondcar4T eq "true")){
                    my $data = "$CELL_NUM,$FA_INDEX,$STATUS,$EARFCN_UL,$EARFCN_DL";                 
                    push (@eutra_fa,$data);               
                    }  

                                                                        
                    
                                                  }                 
          
                                                   
                                                   }
                                                   


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-RET-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID  = $_[2];
                    my $ALD_ID  = $_[3];
                    my $ANT_ID = $_[4];
                    my $TILT = $_[5];
                    my $data = "$CONNECT_BOARD_ID,$CONNECT_PORT_ID,$ALD_ID,$ANT_ID,$TILT";                    
                    push (@ret,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
                                                   


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ALM-LIST;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;
         
         
if (($Log =~ m/REASON/) && ($Log =~ m/NO DATA/) && ($Log =~ m/NOK/)) {
print "THERE ARE NO 4G ALARMS\n";
my $data = "THERE ARE NO 4G ALARMS";
push (@alarm_data,$data);

                                                                      }

my (@alarm_each_line,$alarm_each_line);
@alarm_each_line = split(/\n/, $Log);



foreach $alarm_each_line(@alarm_each_line){
          
if (($alarm_each_line =~ m/critical/) || ($alarm_each_line =~ m/major/) || ($alarm_each_line =~ m/minor/)) {
   
   @_ = split(/\s+/, $alarm_each_line);  
   
   my $UNIT_TYPE = $_[1];
   my $ALARM_TYPE = $_[2];
   my $LOCATION= $_[3]; 
   my $RAISED_DATE= $_[4];
   my $RAISED_Time= $_[5];     
   my $ALARM_GROUP= $_[6];        
   my $PROBABLE_CAUSE= $_[7];
   my $SEVERITY= $_[8];
   my $ALARM_CODE= $_[9];
   my $INFO= $_[10];
   my $SEQUENCE_ID= $_[11];
   my $data = "$enBname,$enbId,$UNIT_TYPE,$ALARM_TYPE,$LOCATION,$RAISED_DATE,$RAISED_Time,$ALARM_GROUP,$PROBABLE_CAUSE,$SEVERITY,$ALARM_CODE,$INFO,$SEQUENCE_ID";
   push (@alarm_data,$data);                                                                                                       }
                                            }             
         
         
         
         
               
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ALM-LOG;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;               

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $LOG_NO = $_[1];
                    my $UNIT_TYPE  = $_[2];
                    my $ALARM_TYPE  = $_[3];
                    my $LOCATION = $_[4];
                    my $raised_date = $_[5];
                    my $raised_time = $_[6];
                    my $clear_date = $_[7];
                    my $clear_time = $_[8];
                    my $ALARM_GROUP = $_[9];
                    my $PROBABLE_CAUSE = $_[10];
                    my $SEVERITY = $_[11];
                    my $ALARM_CODE = $_[12];
                    my $data = "$LOG_NO,$UNIT_TYPE,$ALARM_TYPE,$LOCATION,$raised_date,$raised_time,$clear_date,$clear_time,$ALARM_GROUP,$PROBABLE_CAUSE,$SEVERITY,$ALARM_CODE";                    
                    push (@alarm_log,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PUNCTMODE-IDLE;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if (($split_each_line =~ m/^\s+WiMAX/) || ($split_each_line =~ m/^\s+Not/)){
			
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			$punc_data = $split_each_line;
						
			                       
			                        }		
                  

						 }

if ($alphapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:0;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                    
                    push (@alphaeutranlog,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($betapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:1;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                       
                    push (@betaeutranlog,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($gammapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:2;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                
                    push (@gammaeutranlog,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}
			
if ($secondcar eq "true"){
if ($alphapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:3;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                    
                    push (@alphaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($betapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:4;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                       
                    push (@betaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($gammapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:5;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                
                    push (@gammaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}
}                                                                 



if ($thirdcar eq "true"){
if ($alphapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:6;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                    
                    push (@alphaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($betapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:7;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                       
                    push (@betaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($gammapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:8;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                
                    push (@gammaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}
}

if ($secondcar4T eq "true"){
if ($alphapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:9;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                    
                    push (@alphaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($betapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:10;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                       
                    push (@betaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}

if ($gammapci ne ""){						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-NBR-EUTRAN:11;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $cellnum = $_[1];
                    my $relation  = $_[2];
                    my $STATUS  = $_[3];
                    my $ENB_ID = $_[4];
                    my $TARGET_CELL_NUM = $_[5];
                    my $IS_REMOVE_ALLOWED = $_[29];
                    my $ENB_MCC = $_[7];
                    my $ENB_MNC = $_[8];
                    my $mcc0 = $_[11];
                    my $mnc0 = $_[12];
                    my $mcc1 = $_[13];
                    my $mnc1 = $_[14];                    

                    my $data = "$cellnum,$relation,$STATUS,$ENB_ID,$TARGET_CELL_NUM,$IS_REMOVE_ALLOWED,$ENB_MCC,$ENB_MNC,$mcc0,$mnc0,$mcc1,$mnc1";                
                    push (@gammaeutranlog2,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
}
} 



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-RRH-STS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CONNECT_BOARD_ID = $_[1];
                    my $CONNECT_PORT_ID  = $_[2];
                    my $PATH_ID  = $_[3];
                    my $OPERATIONAL_STATE  = $_[4];
                    my $PATH_STATE  = $_[5];
                    

                    my $data = "$CONNECT_BOARD_ID,$CONNECT_PORT_ID,$PATH_ID,$OPERATIONAL_STATE,$PATH_STATE";                    
                    push (@rrh,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
                                                    

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-POS-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    #if ($pkg ne "3.5.2"){
                    #my $CELL_NUM = $_[1];
                    #my $LAT  = $_[2];
                    #my $LATITUDE  = $_[3];
                    #my $LONG = $_[4];                                        
                    #my $LONGITUDE = $_[5];

                    

                    #my $data = "$CELL_NUM,$LAT,$LATITUDE,$LONG,$LONGITUDE";                    
                    #push (@pos,$data);               
                  #}    
                    if ($pkg =~ m/^5/){
                    my $CELL_NUM = $_[1];
                    my $LAT  = $_[3];
                    my $LATITUDE  = $_[4];
                    my $LONG = $_[5];                                        
                    my $LONGITUDE = $_[6];

                    

                    my $data = "$CELL_NUM,$LAT,$LATITUDE,$LONG,$LONGITUDE";                    
                    push (@pos,$data);               
                  }                      

                  if ($pkg =~ m/^4/){
                    my $CELL_NUM = $_[1];
                    my $LAT  = $_[3];
                    my $LATITUDE  = $_[4];
                    my $LONG = $_[5];                                        
                    my $LONGITUDE = $_[6];

                    

                    my $data = "$CELL_NUM,$LAT,$LATITUDE,$LONG,$LONGITUDE";                    
                    push (@pos,$data);               
                  }                     				  
                    
                                                  }                 
          
                                                   
                                                   }
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-BF-STS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CELL_NUM = $_[1];
                    my $BF_STATE  = $_[2];
                    my $CAL_REASON  = $_[3];
                    my $CAL_TYPE  = $_[4];

                    

                    my $data = "$CELL_NUM,$BF_STATE,$CAL_REASON,$CAL_TYPE";                    
                    push (@bf,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }
                                                   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SONFN-CELL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;
               
               

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);
if ($pkg =~ m/^3/) {  
foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@sonfn,$split_each_line);
			
			                   }		
       }    

                   }
				   
				   
if ($pkg =~ m/^4/) {  
foreach $split_each_line (@split_each_line){
$split_each_line =~ s/^\s+//g;
$split_each_line =~ s/\[\%\]//g;
$split_each_line =~ s/\[sec\]//g;
my $count = 0;
        if ($split_each_line =~ m/^CELL_NUM/){
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
$hash_TITLE{$_} = "$count";
$count++;
                }
		                                     }
         if ($split_each_line =~ m/^\d+/){

@_ = split(/\s+/, $split_each_line);



my $CELL_NUM_value = "$hash_TITLE{CELL_NUM}";
my $ANR_ENABLE_value = "$hash_TITLE{ANR_ENABLE}";
my $INTER_RAT_ANR_ENABLE1_X_RTT_value = "$hash_TITLE{INTER_RAT_ANR_ENABLE1_X_RTT}";
my $INTER_RAT_ANR_ENABLE_HRPD_value = "$hash_TITLE{INTER_RAT_ANR_ENABLE_HRPD}";
my $ENERGY_SAVINGS_ENABLE_value = "$hash_TITLE{ENERGY_SAVINGS_ENABLE}";
my $MOBILITY_ROBUSTNESS_ENABLE_value = "$hash_TITLE{MOBILITY_ROBUSTNESS_ENABLE}";
my $RACH_OPT_ENABLE_value = "$hash_TITLE{RACH_OPT_ENABLE}";
my $PERIODIC_ANR_FLAG_value = "$hash_TITLE{PERIODIC_ANR_FLAG}";
my $ANR_UE_SEARCH_RATE_TOTAL_value = "$hash_TITLE{ANR_UE_SEARCH_RATE_TOTAL}";
my $ANR_UE_SEARCH_RATE_INTRA_FREQ_value = "$hash_TITLE{ANR_UE_SEARCH_RATE_INTRA_FREQ}";
my $ANR_UE_SEARCH_RATE_INTER_FREQ_value = "$hash_TITLE{ANR_UE_SEARCH_RATE_INTER_FREQ}";
my $ANR_UE_SEARCH_RATE_C1_XRTT_value = "$hash_TITLE{ANR_UE_SEARCH_RATE_C1_XRTT}";
my $ANR_UE_SEARCH_RATE_HRPD_value = "$hash_TITLE{ANR_UE_SEARCH_RATE_HRPD}";
my $ANR_MEAS_DURATION_INTER_FREQ_value = "$hash_TITLE{ANR_MEAS_DURATION_INTER_FREQ}";
my $ANR_MEAS_DURATION_C1_XRTT_value = "$hash_TITLE{ANR_MEAS_DURATION_C1_XRTT}";
my $ANR_MEAS_DURATION_HRPD_value = "$hash_TITLE{ANR_MEAS_DURATION_HRPD}";
my $PCI_DRC_FLAG_value = "$hash_TITLE{PCI_DRC_FLAG}";
my $ES_SCAILING_FACTOR_LB_value = "$hash_TITLE{ES_SCAILING_FACTOR_LB}";
my $ES_SCALING_FACTOR_CAC_value = "$hash_TITLE{ES_SCALING_FACTOR_CAC}";
my $RSI_CONFLICT_ENABLE_value = "$hash_TITLE{RSI_CONFLICT_ENABLE}";
my $SON_CCO_PWR_CTRL_ENABLE_value = "$hash_TITLE{SON_CCO_PWR_CTRL_ENABLE}";
my $SON_COC_PWR_CTRL_ENABLE_value = "$hash_TITLE{SON_COC_PWR_CTRL_ENABLE}";



my $CELL_NUM = "$_[$CELL_NUM_value]";
my $ANR_ENABLE = "$_[$ANR_ENABLE_value]";
my $INTER_RAT_ANR_ENABLE1_X_RTT = "$_[$INTER_RAT_ANR_ENABLE1_X_RTT_value]";
my $INTER_RAT_ANR_ENABLE_HRPD = "$_[$INTER_RAT_ANR_ENABLE_HRPD_value]";
my $ENERGY_SAVINGS_ENABLE = "$_[$ENERGY_SAVINGS_ENABLE_value]";
my $MOBILITY_ROBUSTNESS_ENABLE = "$_[$MOBILITY_ROBUSTNESS_ENABLE_value]";
my $RACH_OPT_ENABLE = "$_[$RACH_OPT_ENABLE_value]";
my $PERIODIC_ANR_FLAG = "$_[$PERIODIC_ANR_FLAG_value]";
my $ANR_UE_SEARCH_RATE_TOTAL = "$_[$ANR_UE_SEARCH_RATE_TOTAL_value]";
my $ANR_UE_SEARCH_RATE_INTRA_FREQ = "$_[$ANR_UE_SEARCH_RATE_INTRA_FREQ_value]";
my $ANR_UE_SEARCH_RATE_INTER_FREQ = "$_[$ANR_UE_SEARCH_RATE_INTER_FREQ_value]";
my $ANR_UE_SEARCH_RATE_C1_XRTT = "$_[$ANR_UE_SEARCH_RATE_C1_XRTT_value]";
my $ANR_UE_SEARCH_RATE_HRPD = "$_[$ANR_UE_SEARCH_RATE_HRPD_value]";
my $ANR_MEAS_DURATION_INTER_FREQ = "$_[$ANR_MEAS_DURATION_INTER_FREQ_value]";
my $ANR_MEAS_DURATION_C1_XRTT = "$_[$ANR_MEAS_DURATION_C1_XRTT_value]";
my $ANR_MEAS_DURATION_HRPD = "$_[$ANR_MEAS_DURATION_HRPD_value]";
my $PCI_DRC_FLAG = "$_[$PCI_DRC_FLAG_value]";
my $ES_SCAILING_FACTOR_LB = "$_[$ES_SCAILING_FACTOR_LB_value]";
my $ES_SCALING_FACTOR_CAC = "$_[$ES_SCALING_FACTOR_CAC_value]";
my $RSI_CONFLICT_ENABLE = "$_[$RSI_CONFLICT_ENABLE_value]";
my $SON_CCO_PWR_CTRL_ENABLE = "$_[$SON_CCO_PWR_CTRL_ENABLE_value]";
my $SON_COC_PWR_CTRL_ENABLE = "$_[$SON_COC_PWR_CTRL_ENABLE_value]";


#print ("$CONNECT_BOARD_ID $CONNECT_PORT_ID $TILT\n");

$hash_SONFN_CELL{$CELL_NUM}{ANR_ENABLE} = "$ANR_ENABLE";
$hash_SONFN_CELL{$CELL_NUM}{INTER_RAT_ANR_ENABLE1_X_RTT} = "$INTER_RAT_ANR_ENABLE1_X_RTT";
$hash_SONFN_CELL{$CELL_NUM}{INTER_RAT_ANR_ENABLE_HRPD} = "$INTER_RAT_ANR_ENABLE_HRPD";
$hash_SONFN_CELL{$CELL_NUM}{ENERGY_SAVINGS_ENABLE} = "$ENERGY_SAVINGS_ENABLE";
$hash_SONFN_CELL{$CELL_NUM}{MOBILITY_ROBUSTNESS_ENABLE} = "$MOBILITY_ROBUSTNESS_ENABLE";
$hash_SONFN_CELL{$CELL_NUM}{RACH_OPT_ENABLE} = "$RACH_OPT_ENABLE";
$hash_SONFN_CELL{$CELL_NUM}{PERIODIC_ANR_FLAG} = "$PERIODIC_ANR_FLAG";
$hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_TOTAL} = "$ANR_UE_SEARCH_RATE_TOTAL";
$hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_INTRA_FREQ} = "$ANR_UE_SEARCH_RATE_INTRA_FREQ";
$hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_INTER_FREQ} = "$ANR_UE_SEARCH_RATE_INTER_FREQ";
$hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_C1_XRTT} = "$ANR_UE_SEARCH_RATE_C1_XRTT";
$hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_HRPD} = "$ANR_UE_SEARCH_RATE_HRPD";
$hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_INTER_FREQ} = "$ANR_MEAS_DURATION_INTER_FREQ";
$hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_C1_XRTT} = "$ANR_MEAS_DURATION_C1_XRTT";
$hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_HRPD} = "$ANR_MEAS_DURATION_HRPD";
$hash_SONFN_CELL{$CELL_NUM}{PCI_DRC_FLAG} = "$PCI_DRC_FLAG";
$hash_SONFN_CELL{$CELL_NUM}{ES_SCAILING_FACTOR_LB} = "$ES_SCAILING_FACTOR_LB";
$hash_SONFN_CELL{$CELL_NUM}{ES_SCALING_FACTOR_CAC} = "$ES_SCALING_FACTOR_CAC";
$hash_SONFN_CELL{$CELL_NUM}{RSI_CONFLICT_ENABLE} = "$RSI_CONFLICT_ENABLE";
$hash_SONFN_CELL{$CELL_NUM}{SON_CCO_PWR_CTRL_ENABLE} = "$SON_CCO_PWR_CTRL_ENABLE";
$hash_SONFN_CELL{$CELL_NUM}{SON_COC_PWR_CTRL_ENABLE} = "$SON_COC_PWR_CTRL_ENABLE";


		 
		                                 }

                                           }	   
 
                   }						 
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-MOBIL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;						 

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CELL_NUM = $_[1];
                    my $LTM_OFF_TDD  = $_[69];
                    my $DAYLT_TDD  = $_[70];

                    

                    my $data = "$CELL_NUM,$LTM_OFF_TDD,$DAYLT_TDD";                    
                    push (@ltm,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }     


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ULRESCONF-IDLE;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;						 

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                #CELL_NUM   RESOURCE_TABLE_USAGE   START_STATE_IDX   END_STATE_IDX   UL_BANDWIDTH_LIMIT
 
					if ($pkg =~ m/^3/) { 
                    my $CELL_NUM = $_[1];
                    my $RESOURCE_TABLE_USAGE = $_[2];
                    my $START_STATE_IDX = $_[3];
                    my $END_STATE_IDX = $_[4];



                    my $data = "$CELL_NUM,$RESOURCE_TABLE_USAGE,$START_STATE_IDX,$END_STATE_IDX";                    
                    push (@ULRESCONF,$data); 
                                       }		
 
					if ($pkg =~ m/^4/) { 
                    my $CELL_NUM = $_[1];
                    my $RESOURCE_TABLE_USAGE = $_[2];
                    my $START_STATE_IDX = $_[3];
                    my $END_STATE_IDX = $_[4];
                    my $UL_BANDWIDTH_LIMIT = $_[5];


                    my $data = "$CELL_NUM,$RESOURCE_TABLE_USAGE,$START_STATE_IDX,$END_STATE_IDX,$UL_BANDWIDTH_LIMIT";                    
                    push (@ULRESCONF,$data); 
                                       }					

                                  
                    
                                                  }                 
          
                                                   
                                                   }   



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-PREG;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;						 

my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
          
          
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                
                    
                    my $CELL_NUM = $_[1];
                    my $USAGE = $_[2];
                    my $SID = $_[3];
                    my $NID = $_[4];
                    

                    my $data = "$CELL_NUM,$USAGE,$SID,$NID";                    
                    push (@c1xrttpreg,$data);               

                                  
                    
                                                  }                 
          
                                                   
                                                   }


############################3

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-DRX-INF:0;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($_[2] <= 9){
                      
                    my $PLMN_IDX = $_[1];
                    my $QCI = $_[2];
                    my $DRX_CONFIG_SETUP = $_[3];
                    my $ON_DURATION_TIMER_NORMAL = $_[4]; 
                    my $DRX_INACTIVITY_TIMER_NORMAL = $_[5];
                    my $DRX_RETRANSMISSION_TIMER_NORMAL = $_[6];
                    my $LONG_DRXCYCLE_START_OFFSET_TYPE_NORMAL = $_[7];
                    my $SHORT_DRXCONFIG_SETUP = $_[8];
                    my $SHORT_DRXCYCLE_NORMAL = $_[9];
                    my $DRX_SHORT_CYCLE_TIMER_NORMAL = $_[10];
                    my $DRX_SELECTION_ORDER = $_[11];
                    my $ON_DURATION_TIMER_REPORT_CGI = $_[12];
                    my $DRX_INACTIVITY_TIMER_REPORT_CGI = $_[13];
                    my $DRX_RETRANSMISSION_TIMER_REPORT_CGI = $_[14];
                    my $LONG_DRXCYCLE_START_OFFSET_TYPE_REPORT_CGI = $_[15];
                    my $ON_DURATION_TIMER_INTER_RAT = $_[16];
                    my $DRX_INACTIVITY_TIMER_INTER_RAT = $_[17];
                    my $DRX_RETRANSMISSION_TIMER_INTER_RAT = $_[18];
                    my $LONG_DRXCYCLE_START_OFFSET_TYPE_INTER_RAT = $_[19];
                                                                             
                    my $data = "$PLMN_IDX,$QCI,$DRX_CONFIG_SETUP,$ON_DURATION_TIMER_NORMAL,$DRX_INACTIVITY_TIMER_NORMAL,$DRX_RETRANSMISSION_TIMER_NORMAL,$LONG_DRXCYCLE_START_OFFSET_TYPE_NORMAL,$SHORT_DRXCONFIG_SETUP,$SHORT_DRXCYCLE_NORMAL,$DRX_SHORT_CYCLE_TIMER_NORMAL,$DRX_SELECTION_ORDER,$ON_DURATION_TIMER_REPORT_CGI,$DRX_INACTIVITY_TIMER_REPORT_CGI,$DRX_RETRANSMISSION_TIMER_REPORT_CGI,$LONG_DRXCYCLE_START_OFFSET_TYPE_REPORT_CGI,$ON_DURATION_TIMER_INTER_RAT,$DRX_INACTIVITY_TIMER_INTER_RAT,$DRX_RETRANSMISSION_TIMER_INTER_RAT,$LONG_DRXCYCLE_START_OFFSET_TYPE_INTER_RAT";  
                    push (@drx,$data); 
                      }
                
                
                
          }            
      
      
}      


# $ssh_lsm->waitfor("]");
# $ssh_lsm->print("cmd $eNBName RTRV-CELL-SEL;");
# $ssh_lsm->waitfor(";");
# my $Log = $ssh_lsm->waitfor(';');
# print $Log;
# print FILE $Log;


# my (@split_each_line_vlan,$split_each_line_vlan);
# @split_each_line_vlan = split (/\n/,$Log);

# foreach $split_each_line_vlan (@split_each_line_vlan){
      
          # if ($split_each_line_vlan =~ m/^\s+\d+/){
                # @_ = split (/\s+/,$split_each_line_vlan);
                
                # if ($_[2] <= 9){
                      
                    # my $CELL_NUM = $_[1];
                    # my $Q_RX_LEV_MIN = $_[2];
                    # my $Q_RXLEV_MIN_OFFSET_USAGE = $_[3];
                    # my $Q_RXLEV_MIN_OFFSET = $_[4]; 
                    # my $P_MAX_USAGE = $_[5];
                    # my $P_MAX = $_[6];
                    # my $REL9_SEL_INFO_USAGE = $_[7];
                    # my $Q_QUAL_MIN = $_[8];
                    # my $Q_QUAL_MIN_OFFSET_USAGE = $_[9];
                    # my $Q_QUAL_MIN_OFFSET = $_[10];
                                                                             
                    # my $data = "$CELL_NUM,$Q_RX_LEV_MIN,$Q_RXLEV_MIN_OFFSET_USAGE,$Q_RXLEV_MIN_OFFSET,$P_MAX_USAGE,$P_MAX,$REL9_SEL_INFO_USAGE,$Q_QUAL_MIN,$Q_QUAL_MIN_OFFSET_USAGE,$Q_QUAL_MIN_OFFSET";  
                    # push (@sel,$data); 
                      # }
                
                
                
          # }            
      
      
# }      

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CLOCK-CTRL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($_[1] <= 11){
                      
                    my $CELL_NUM = $_[1];
                    my $CLOCK_ADVANCE = $_[2];
                    my $CLOCK_RETARD = $_[3];
                                        
                    my $data = "$CELL_NUM,$CLOCK_ADVANCE,$CLOCK_RETARD";  
                    push (@CTRL,$data); 
                      }
                
                
                
          }            
      
      
}      


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-TIMER-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                    $split_each_line_vlan =~ s/^\s+//g;  
                    $split_each_line_vlan =~ s/\s+/,/g;  
                    $timer_data =  $split_each_line_vlan;
                    chop ($timer_data);
                
                
          }                  
}   


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-BF-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($_[1] <= 11){
                      
                    my $CELL_NUM = $_[1];
                    my $BEAM_FORMING_ENABLE = $_[2];
                    my $CALIBRATION_PERIOD = $_[3];
                    my $SUBFRAME = $_[4];                   
                    my $data = "$CELL_NUM,$BEAM_FORMING_ENABLE,$CALIBRATION_PERIOD,$SUBFRAME";  
                    push (@bfconf,$data); 
                      }
                
                
                
          }            
      
      
}   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PUSCH-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($_[1] <= 11){
                      
                    my $CELL_NUM = $_[1];
                    my $N_SB = $_[2];
                    my $HOPPING_MODE = $_[3];
                    my $ENABLE_SIX_FOUR_QAM = $_[4]; 
                    my $GROUP_HOPPING_ENABLED = $_[5];
                    my $GROUP_ASSIGNMENT_PUSCH = $_[6];
                    my $SEQUENCE_HOPPING_ENABLED = $_[7];

                                                                     
                    my $data = "$CELL_NUM,$N_SB,$HOPPING_MODE,$ENABLE_SIX_FOUR_QAM,$GROUP_HOPPING_ENABLED,$GROUP_ASSIGNMENT_PUSCH,$SEQUENCE_HOPPING_ENABLED";  
                    push (@puschconf,$data); 
                      }
                
                
                
          }            
      
      
}   




$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PRC-FW;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if (($split_each_line_vlan =~ m/^\s+UMP/) || ($split_each_line_vlan =~ m/^\s+ECP/)){
                @_ = split (/\s+/,$split_each_line_vlan);
                
if ($pkg =~ m/^3/) {  
                    my $PRC_UNIT_TYPE = $_[1];
                    my $PRC_UNIT_ID = $_[2];
                    my $LOC_TYPE = $_[3];
                    my $ID = $_[4]; 
                    my $TYPE = $_[5];
                    my $NAME = $_[6];
                    my $VERSION = $_[7];
                    my $REL_VER = $_[9];
                                                                     
                    my $data = "$PRC_UNIT_TYPE,$PRC_UNIT_ID,$LOC_TYPE,$ID,$TYPE,$NAME,$VERSION,$REL_VER";  
                    push (@prcfw,$data); 
                
                   }               
if ($pkg =~ m/^4/) {  
                    my $PRC_UNIT_TYPE = $_[1];
                    my $PRC_UNIT_ID = $_[2];
                    my $LOC_TYPE = $_[3];
                    my $ID = $_[4]; 
                    my $TYPE = $_[5];
                    my $NAME = $_[6];
                    my $VERSION = $_[7];
                    my $REL_VER = $_[9];
                                                                     
                    my $data = "$PRC_UNIT_TYPE,$PRC_UNIT_ID,$LOC_TYPE,$ID,$TYPE,$NAME,$VERSION,$REL_VER";  
                    push (@prcfw,$data); 
                
                   }               				   
if ($pkg =~ m/^5/) {  
                    my $PRC_UNIT_TYPE = $_[1];
                    my $PRC_UNIT_ID = $_[2];
                    my $LOC_TYPE = $_[3];
                    my $ID = $_[4]; 
                    my $TYPE = $_[5];
                    my $NAME = $_[6];
                    my $VERSION = $_[7];
                    my $REL_VER = $_[9];
                                                                     
                    my $data = "$PRC_UNIT_TYPE,$PRC_UNIT_ID,$LOC_TYPE,$ID,$TYPE,$NAME,$VERSION,$REL_VER";  
                    push (@prcfw,$data); 
                   }                
                                                                                              }            

                                                     }   



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SOC-FW;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($_[1] <= 8){
                      
                    my $BD_ID = $_[1];
                    my $SOC_ID = $_[2];
                    my $LOC_TYPE = $_[3];
                    my $ID = $_[4]; 
                    my $TYPE = $_[5];
                    my $NAME = $_[6];
                    my $VERSION = $_[7];
                    my $REL_VER = $_[8];
                                                                     
                    my $data = "$BD_ID,$SOC_ID,$LOC_TYPE,$ID,$TYPE,$NAME,$VERSION,$REL_VER";  
                    push (@socfw,$data); 
                      }
                
                
                
          }            
      
      
}   


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SOC-SW;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($_[1] <= 8){
                      
                    my $BD_ID = $_[1];
                    my $SOC_ID = $_[2];
                    my $ID = $_[3];
                    my $NAME = $_[4]; 
                    my $VERSION = $_[7];
                    my $REL_VER = $_[8];
                                                                     
                    my $data = "$BD_ID,$SOC_ID,$ID,$NAME,$VERSION,$REL_VER";  
                    push (@socsw,$data); 
                      }
                
                
                
          }            
      
      
}   

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-ACS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

 foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                @_ = split (/\s+/,$split_each_line_vlan);
                
                if ($_[1] <= 11){
                      
                    my $cell = $_[1];
                    my $BARRED = $_[2];
                    my $INTRA_FREQ = $_[3];
                    my $BARRING_CTR = $_[4]; 
                    my $HANDOVER_BARRING = $_[5];
                          
                    my $data = "$cell,$BARRED,$INTRA_FREQ,$BARRING_CTR,$HANDOVER_BARRING";  
                    push (@cell_bar,$data); 
                      }
                }
                
                
           }            


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ANR-SCHED;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

 foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                
                    $split_each_line_vlan =~ s/^\s+//g;
                    $split_each_line_vlan =~ s/\s+/,/g;    
                    push (@anrsched,$split_each_line_vlan); 
                      
                
                
                
           }         
                      
                            
      
}   


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-BCCH-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

 foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                
                    $split_each_line_vlan =~ s/^\s+//g;
                    $split_each_line_vlan =~ s/\s+/,/g;    
                    push (@bcchconf,$split_each_line_vlan); 
                      
                
                
                
           }         
                      
                            
      
}   


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-BHBW-QCI;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

 foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                
                    $split_each_line_vlan =~ s/^\s+//g;
                    $split_each_line_vlan =~ s/\s+/,/g;    
                    push (@bhbw,$split_each_line_vlan); 
                      
                
                
                
           }         
                      
                            
      
}   



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-BCLS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;


my (@split_each_line_vlan,$split_each_line_vlan);
@split_each_line_vlan = split (/\n/,$Log);

 foreach $split_each_line_vlan (@split_each_line_vlan){
      
          if ($split_each_line_vlan =~ m/^\s+\d+/){
                
                    $split_each_line_vlan =~ s/^\s+//g;
                    $split_each_line_vlan =~ s/\s+/,/g;    
                    push (@bcls,$split_each_line_vlan); 
                      
                
                
                
           }         
                      
                            
      
}   


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-ECSFB;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log;               


my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@lsmECSFB,$split_each_line);
			
			                   }		
       }




$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-FREQ;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@lsmFREQ,$split_each_line);
			
			                   }		
       }


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-MOBIL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@lsmMOBIL,$split_each_line);
			
			                   }		
       }

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-OVL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@lsmOVL,$split_each_line);
			
			                   }		
       }
       
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-PRD;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 


my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);


foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@lsmPRD,$split_each_line);
			
			                   }		
       }       

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-C1XRTT-PREG;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@lsmPREG,$split_each_line);
			
			                   }		
       }



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CDD-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cddconf,$split_each_line);
			
			                   }		
       }

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CDMA-CNF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cdmaconf,$split_each_line);
			
			                   }		
       }

           

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-INFO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cellinfogp,$split_each_line);
			
			                   }		
       }  

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-RSEL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cellrsel,$split_each_line);
			
			                   }		
       }  



$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-SEL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cellsel,$split_each_line);
			
			                   }		
       }  


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-DL-SCHED;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@dlshed,$split_each_line);
			
			                   }		
       }        
                    
$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EUTRA-A1CNF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			@_ = split (/\s+/,$split_each_line);
			
			if ($_[2] eq "MeasGapDeact"){
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@A1cnf,$split_each_line);
			}
			                   }		
       }  


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EUTRA-A2CNF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			@_ = split (/\s+/,$split_each_line);
			
			if (($_[2] eq "LteHo") || ($_[2] eq "IRatBlind") || ($_[2] eq "Ca")){
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@A2cnf,$split_each_line);
			}
			                   }		
       }  

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EUTRA-A3CNF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			@_ = split (/\s+/,$split_each_line);
			
			if (($_[2] eq "IntraLteHandover") || ($_[2] eq "IntraFrequencyLb") || ($_[2] eq "IntraFrequncyCre")){
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@A3cnf,$split_each_line);
			}
			                   }		
       }  

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EUTRA-A5CNF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			@_ = split (/\s+/,$split_each_line);
			
			if (($_[2] eq "IntraLteHandover") && ($_[3] <= "5") ){
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@A5cnf,$split_each_line);
			}
			if (($_[2] eq "CaInterFreq") && ($_[3] eq "0") ){
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@CaInterFreq,$split_each_line);
			}			
			
			
			                   }		
       } 

$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EUTRA-A6CNF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){
			@_ = split (/\s+/,$split_each_line);
			
			if ($_[2] eq "Ca"){
			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@A6cnf,$split_each_line);
			}
			                   }		
       } 


$ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-HO-OPT;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@hoopt,$split_each_line);
			
			                   }		
       } 
 
 
 
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-HO-OPT;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@hoopt,$split_each_line);
			
			                   }		
       } 
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-INACT-TIMER;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@inacttimer,$split_each_line);
			
			                   }		
       }             



 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-INTWO-OPT;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@intwoopt,$split_each_line);
			
			                   }		
       }      

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-LOCH-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@lochinf,$split_each_line);
			
			                   }		
       }        

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-MEAS-FUNC;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@measfunc,$split_each_line);
			
			                   }		
       }     


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PCCH-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+rf128/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@pcchconf,$split_each_line);
			
			                   }		
       }    
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-QCI-VAL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@qcival,$split_each_line);
			
			                   }		
       }     
       


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-DSCP-TRF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@dscptrf,$split_each_line);
			
			                   }		
       }           
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ROHC-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@rochinf,$split_each_line);
			
			                   }		
       } 
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SCTP-PARAM;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@sctpparam,$split_each_line);
			
			                   }		
       } 


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ENBCONN-PARA;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@enbconnpara,$split_each_line);
			
			                   }		
       } 

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SECU-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+EIA2/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@secuinf,$split_each_line);
			
			                   }		
       } 
 
 
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SIB-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@sibinf,$split_each_line);
			
			                   }		
       }  


 
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-DSCP-SIG;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@dscpsig,$split_each_line);
			
			                   }		
       }        
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SON-ANR;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@sonanr,$split_each_line);
			
			                   }		
       }          

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SON-DLICIC;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@sondlic,$split_each_line);
			
			                   }		
       }  

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SON-SO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@sonso,$split_each_line);
			
			                   }		
       }                

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-SRB-RLC;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@srbrlc,$split_each_line);
			
			                   }		
       }  


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-DSCP-SYS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@dscpsys,$split_each_line);
			
			                   }		
       }  

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-TIME-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@timeinf,$split_each_line);
			
			                   }		
       }        
 
 
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PLMNSIGTIMER-INFO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@plmnsigtimer,$split_each_line);
			
			                   }		
       }  

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-TRCH-BSR;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@trchbsr,$split_each_line);
			
			                   }		
       } 


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ULPWR-CTRL;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@ulpwrctrl,$split_each_line);
			
			                   }		
       }   
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ULRESCONF-IDLE;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@ULRESCONF,$split_each_line);
			
			                   }		
       }        
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-TPC-CONF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@tpcconf,$split_each_line);
			
			                   }		
       }

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-EUTRA-FA;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
$split_each_line =~ s/^\s+//g;
$split_each_line =~ s/\[\%\]//g;
$split_each_line =~ s/\[sec\]//g;
my $count = 0;
        if ($split_each_line =~ m/^CELL_NUM/){
@_ = split(/\s+/, $split_each_line);
foreach $_ (@_) {
$_ =~ s/\[.*//g;
$hash_EUTRA_FA_TITLE{$count} = "$_";
$count++;
                }
		                                     }
         if ($split_each_line =~ m/^\d+/){

@_ = split(/\s+/, $split_each_line);
$count_val = 0;
foreach $_ (@_) {
my $TITLE = "$hash_EUTRA_FA_TITLE{$count_val}";
my $value = "$_";
if ($count_val > 1) {
if ($_[1] < 6) {
$hash_EUTRA_FA{$_[0]}{$_[1]}{$TITLE} = "$_";
               }
                    }
$count_val++;

                }




		 
		                                 }

                                           }	


my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@eutrafagp,$split_each_line);
			
			                   }		
       }      



foreach $_(@eutrafagp){

@_ = split (/,/,$_);

if (($_[3] eq $tddsecondcar) && ($_[1] ne "1") && ($_[1] ne "0") && ($_[2] eq "EQUIP")){
	
	my $cell = $_[0];
	my $fa = $_[1];
	my $status = $_[2];
	my $ul = $_[3];
	my $data = "$cell,$fa,$status,$ul";
	push (@inuse_2nd,$data);     
	      
	}
	
	
	
}


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-CAC;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cellcacgp,$split_each_line);
			
			                   }		
       }  

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ENB-CAC;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if (($split_each_line =~ m/^\s+use/) || ($split_each_line =~ m/^\s+no_use/)){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@encacgp,$split_each_line);
			
			                   }		
       }  




 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CA-COLOC;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@encacoloc,$split_each_line);
			
			                   }		
       }  


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CACELL-INFO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@encacellinfo,$split_each_line);
			
			                   }		
       }  

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-PUCCHCONF-IDLE;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@pucchconf,$split_each_line);
			
			                   }		
       }  


 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CASCHED-INF;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if (($split_each_line =~ m/^\s+ColocatedCell/) || ($split_each_line =~ m/^\s+IntraEnb/)){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@encasched,$split_each_line);
			
			                   }		
       } 
       



 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CABAND-INFO;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cabandinfo,$split_each_line);
			
			                   }		
       }  

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ALD-INVT:0,6,0;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@aldinvt,$split_each_line);
			
			                   }		
       }         

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ALD-INVT:0,8,0;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@aldinvt,$split_each_line);
			
			                   }		
       } 
       
 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ALD-INVT:0,10,0;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@aldinvt,$split_each_line);
			
			                   }		
       } 
                                   

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-ACTIVE-LB;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@actlb,$split_each_line);
			
			                   }		
       } 

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-UECNT;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@celluecnt,$split_each_line);
			
			                   }		
       } 

 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-STS;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@cellstsman,$split_each_line);
			
			                   }		
       } 




 $ssh_lsm->waitfor("]");
$ssh_lsm->print("cmd $eNBName RTRV-CELL-DATA;");
$ssh_lsm->waitfor(";");
my $Log = $ssh_lsm->waitfor(';');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^\s+\d+/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@celldata,$split_each_line);
			
			                   }		
       } 
       

print ("\n\n Connecting to DU \n\n");
					     
$ssh_lsm->cmd("ssh lteuser\@$mmbsoamip");
sleep 5;
$ssh_lsm->print('yes');
sleep 10;
my $Log = $ssh_lsm->waitfor('password:');
print "$Log\n";

$ssh_lsm->print("samsunglte");
# $ssh_lsm->waitfor('@LMA3');# 
$ssh_lsm->waitfor('LMA3');

$ssh_lsm->print("su -");
$ssh_lsm->waitfor('Password:');


$ssh_lsm->print("123qwe");
# my $Log = $ssh_lsm->waitfor('@LMA3');
my $Log = $ssh_lsm->waitfor('LMA3');



if ($Log =~ m/failure/){

$ssh_lsm->print("su -");
$ssh_lsm->waitfor('Password:');


my $Log = $ssh_lsm->print("S\@msung1te");
# $ssh_lsm->waitfor('@LMA3');
$ssh_lsm->waitfor('LMA3');

}

$ssh_lsm->print("vrctl 31 bash");
# $ssh_lsm->waitfor('@LMA3');
$ssh_lsm->waitfor('LMA3');

$ssh_lsm->print("arp | grep 192.168.13.27;");
$ssh_lsm->waitfor(";");
# my $Log = $ssh_lsm->waitfor('root@LMA3:~#');
 my $Log = $ssh_lsm->waitfor('LMA3');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^192/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@slot1,$split_each_line);
			
			                   }		
       } 

$ssh_lsm->print("arp | grep 192.168.14.27;");
$ssh_lsm->waitfor(";");
# my $Log = $ssh_lsm->waitfor('root@LMA3:~#');
 my $Log = $ssh_lsm->waitfor('LMA3');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^192/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@slot2,$split_each_line);
			
			                   }		
       } 

$ssh_lsm->print("arp | grep 192.168.15.27;");
$ssh_lsm->waitfor(";");
# my $Log = $ssh_lsm->waitfor('root@LMA3:~#');
 my $Log = $ssh_lsm->waitfor('LMA3');
print $Log;
print FILE $Log; 

my (@split_each_line,$split_each_line);
@split_each_line = split (/\n/,$Log);

foreach $split_each_line (@split_each_line){
          
          
          if ($split_each_line =~ m/^192/){

			$split_each_line =~ s/^\s+//g;
			$split_each_line =~ s/\s+/,/g;
			chop($split_each_line);
			push(@slot3,$split_each_line);
			
			                   }		
       } 

$ssh_lsm->print("exit");
# $ssh_lsm->waitfor('@LMA3');
$ssh_lsm->waitfor('LMA3');

$ssh_lsm->print("exit");
# $ssh_lsm->waitfor('@LMA3');
$ssh_lsm->waitfor('LMA3');


                                                                           
$ssh_lsm->print('exit');

$ssh_lsm->disconnect;

	}
                   
open (HTMLFILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\Audit_2.5\\REPORT\\$cascade\_$eNBName\_AUDIT_$now\.html");
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=0>\n");
print (HTMLFILE "<tr><td align=center><font size=+3>$cascade $eNBName AUDIT REPORT $now </font></td></tr>\n");
print (HTMLFILE "</table>\n");


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>$cascade</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CASCADE ID</th><th align=center>eNB ID</th><th align=center>eNB NAME</th><th align=center>LSM</th><th align=center>SW</th><th align=center>BUCKET</th><th align=center>DIVERSITY</th><th align=center>ANTENNA</th><th align=center>ADID</th><th align=center>GP VER</th><th align=center>CIQ VER</th></tr>\n");  

if ($DL_ANT_COUNT eq "n8TxAntCnt"){
      $DL_ANT_COUNT = "8T8R";
      }
if ($DL_ANT_COUNT eq "n4TxAntCnt"){
      $DL_ANT_COUNT = "4T4R";
      }
print (HTMLFILE "<td align=center>$cascade</td>\n");
print (HTMLFILE "<td align=center>$enbid</td>\n");
print (HTMLFILE "<td align=center>$eNBName</td>\n");
print (HTMLFILE "<td align=center>$LSM</td>\n");


if ($pkg eq "5.0.2"){
    
    print (HTMLFILE "<td align=center>$pkg</td>\n");
                    }           
if ($pkg ne "5.0.2"){
    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$pkg</td>\n");
                    }

					 
print (HTMLFILE "<td align=center>$bucket</td>\n");

if ($DL_ANT_COUNT eq $divciq){
print (HTMLFILE "<td align=center>$divciq</td>\n");
}
if ($DL_ANT_COUNT ne $divciq){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$divciq</td>\n");
} 

if ($triciq eq "TRIBAND"){
print (HTMLFILE "<td align=center>$triciq</td>\n");
}
if ($triciq ne "TRIBAND"){
      
print (HTMLFILE "<td align=center>NOT TRIBAND</td>\n");
} 
print (HTMLFILE "<td align=center>$user</td>\n");   
print (HTMLFILE "<td align=center>1.9</td>\n");   
print (HTMLFILE "<td align=center>$version_cq</td>\n");   
print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");
                    
                    
print (HTMLFILE "</table>\n");     


if (@inuse_2nd){
      
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>2nd CARRIER EARFCN IN USE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>FA_INDEX</th><th align=center>STATUS</th><th align=center>EARFCN_UL</th></tr>\n");

foreach $_(@inuse_2nd){     

@_ = split (/,/,$_);

print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n"); 
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n"); 
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 

print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");
      
}      

print (HTMLFILE "</table>\n");
}      

if (($secondcar eq "true") ||  ($secondcar4T eq "true")){
      
   if (($DL_ANT_COUNT eq "n8TxAntCnt") && ($secondcar4T eq "true")){
         
     print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
     print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#FF0000><b>2nd CARRIER GROWN WITH WRONG CELLS</b></td></tr>\n");
     print (HTMLFILE "</table>\n");             
         }   
      
   if (($DL_ANT_COUNT eq "n4TxAntCnt") && ($secondcar eq "true")){
         
     print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
     print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#FF0000><b>2nd CARRIER GROWN WITH WRONG CELLS</b></td></tr>\n");
     print (HTMLFILE "</table>\n");             
         }  
}      


if ($mme_assignment eq "Chicago_Akron"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-MME-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_IPV4</th></tr>\n");

foreach $_(@mme_ips){

@_ = split (/,/,$_);

if ($_[0] eq 0){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }


if ($_[0] eq 1){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 2){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 3){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 4){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }                                             

if ($_[0] eq 5){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               } 

if ($_[0] eq 6){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 7){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 8){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }               

if ($_[0] eq 9){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               } 

if ($_[0] eq 10){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               } 

if ($_[0] eq 11){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               } 

if ($_[0] eq 12){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               } 
               
if ($_[0] eq 13){

if (($_[1] eq "10.158.211.12") || ($_[1] eq "10.156.35.12") || ($_[1] eq "10.158.211.172") || ($_[1] eq "10.156.35.172") || ($_[1] eq "10.158.211.188") || ($_[1] eq "10.156.35.188") || ($_[1] eq "10.158.211.204") || ($_[1] eq "10.156.35.204") || ($_[1] eq "10.158.211.220") || ($_[1] eq "10.156.35.220") || ($_[1] eq "10.158.212.4") || ($_[1] eq "10.156.35.44") || ($_[1] eq "10.158.212.20") || ($_[1] eq "10.156.34.28")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               } 
                             
               
print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");


          
                           }  


print (HTMLFILE "</table>\n");
}                                    
  
if ($mme_assignment eq "San_Jose_Tacoma"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-MME-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_IPV4</th></tr>\n");

foreach $_(@mme_ips){

@_ = split (/,/,$_);

if ($_[0] eq 0){

if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }


if ($_[0] eq 1){

if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 2){

if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 3){

if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }

if ($_[0] eq 4){

if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }                                             

if ($_[0] eq 5){

if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               } 


print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");


          
                           }  


print (HTMLFILE "</table>\n");
} 

if ($mme_assignment eq "Bayamon"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-MME-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_IPV4</th></tr>\n");

foreach $_(@mme_ips){

@_ = split (/,/,$_);

if ($_[0] eq 0){

if (($_[1] eq "10.156.75.12") || ($_[1] eq "10.156.43.12")){	     
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }


if ($_[0] eq 1){

if (($_[1] eq "10.156.75.12") || ($_[1] eq "10.156.43.12")){	     
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");      
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
     }     

               }


print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");


          
                           }  


print (HTMLFILE "</table>\n");
} 
                              
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-VLAN-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>DB_INDEX</th><th align=center>VR_ID</th><th align=center>IF_NAME</th><th align=center>VLAN_ID</th><th align=center>ADMINISTRATIVE_STATE</th><th align=center>DESCRIPTION</th></tr>\n");  
  
foreach $_(@vlan_conf){

@_ = split (/,/,$_);


if ($_[0] eq 0){

if ($_[3] eq "34"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");    
    
        
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
    
    
          
     }  
     
     
     }   
if ($_[0] eq 1){

if ($_[3] eq "42"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");    
    
        
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
    
    
          
     }    
               } 
                              
               
print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");                    
                      
  
                    
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-IP-ADDR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>DB_INDEX</th><th align=center>IF_NAME</th><th align=center>IP_ADDR</th><th align=center>IP_PFX_LEN</th><th align=center>OAM</th><th align=center>LTE_SIGNAL_S1</th><th align=center>LTE_SIGNAL_X2</th><th align=center>LTE_BEARER_S1</th><th align=center>LTE_BEARER_X2</th></tr>\n");  
  
foreach $_(@ip_addr){

@_ = split (/,/,$_);


if ($_[0] eq 0){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");    
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");     
    print (HTMLFILE "<td align=center>$_[8]</td>\n");         
    
     
     }   
if ($_[0] eq 1){

if (($_[4] eq "True") && ($_[5] eq "False") && ($_[6] eq "False") && ($_[7] eq "False") && ($_[8] eq "False") && ($_[2] eq $mmbsoamip)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");    
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");     
    print (HTMLFILE "<td align=center>$_[8]</td>\n");     
    
        
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");           
     }    
               } 
                              
if ($_[0] eq 2){

if (($_[4] eq "False") && ($_[5] eq "True") && ($_[6] eq "True") && ($_[7] eq "True") && ($_[8] eq "True") && ($_[2] eq $mmbssbip)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");    
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");     
    print (HTMLFILE "<td align=center>$_[8]</td>\n");     
    
        
                             }
else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");     
    
    
          
     }    
               }                
print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");                    
                                          
                   


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-IP-ROUTE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>VR_ID</th><th align=center>DB_INDEX</th><th align=center>IP_PREFIX</th><th align=center>IP_PFX_LEN</th><th align=center>IP_GW</th><th align=center>DISTANCE</th></tr>\n");  
  
foreach $_(@ip_route){

@_ = split (/,/,$_);



    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");           
    
print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");                    
                                                          
############### SYS CONF

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>SYS-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SYS_ID</th><th align=center>STATUS</th><th align=center>ADMINISTRATIVE_STATE</th><th align=center>TYPE</th><th align=center>SYS_TYPE</th></tr>\n");  
  
foreach $_(@sys_conf){

@_ = split (/,/,$_);


	print (HTMLFILE "<td align=center>$_[0]</td>\n");
	print (HTMLFILE "<td align=center>$_[1]</td>\n");
	print (HTMLFILE "<td align=center>$_[2]</td>\n");
	print (HTMLFILE "<td align=center>$_[3]</td>\n");
	
	if ($_[4] eq $cabinet){
		print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	}
	if ($_[4] ne $cabinet){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
	}

        
    
print (HTMLFILE "</td>\n");
print (HTMLFILE "</tr>\n");
                    } 
                    
                    
print (HTMLFILE "</table>\n"); 

########################


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-NTP-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SVR_TYPE</th><th align=center>NTP_IPV4</th></tr>\n");  
  
foreach $_(@ntp){

@_ = split (/,/,$_);


if ($_[0] eq "PRIMARY_NTP_SERVER"){ 
if ($_[1] eq "112.255.255.252"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
          
    
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
              
         } 
         
       }      

if ($_[0] eq "SECONDARY_NTP_SERVER"){ 
if ($_[1] eq "112.255.255.253"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
          
    
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
              
         } 
         
       }      
    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");                    
                                  


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 bgcolor=#EEEEEE><b>RTRV-CELL-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PHY_CELL_ID</th><th align=center>DL_ANT_COUNT</th><th align=center>UL_ANT_COUNT</th><th align=center>EARFCN_DL</th><th align=center>EARFCN_UL</th><th align=center>CELL_TYPE</th><th align=center>DUPLEX_TYPE</th><th align=center>FREQUENCY_BAND_INDICATOR</th><th align=center>SUBFRAME_ASSIGNMENT</th><th align=center>SPECIAL_SUBFRAME_PATTERNS</th><th align=center>FORCED_MODE</th><th align=center>DL_CRS_PORT_COUNT</th></tr>\n");  
  
foreach $_(@cell_idle){

@_ = split (/,/,$_);


if (($_[0] eq 0) && ($divciq eq "8T8R")){ 
if (($_[1] eq $alphapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
	
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       }      

if (($_[0] eq 1) && ($divciq eq "8T8R")){ 
if (($_[1] eq $betapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

if (($_[0] eq 2) && ($divciq eq "8T8R")){ 
if (($_[1] eq $gammapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

###2nd

if (($_[0] eq 3) && ($divciq eq "8T8R")){ 
if (($_[1] eq $alphapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       }      

if (($_[0] eq 4) && ($divciq eq "8T8R")){ 
if (($_[1] eq $betapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

if (($_[0] eq 5) && ($divciq eq "8T8R")){ 
if (($_[1] eq $gammapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 


if (($_[0] eq 0) && ($divciq eq "4T4R")){ 
if (($_[1] eq $alphapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       }      

if (($_[0] eq 1) && ($divciq eq "4T4R")){ 
if (($_[1] eq $betapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

### 3rd


if (($_[0] eq 6) && ($divciq eq "8T8R")){ 
if (($_[1] eq $alphapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tdd3rdcar) && ($_[5] eq $tdd3rdcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       }      

if (($_[0] eq 7) && ($divciq eq "8T8R")){ 
if (($_[1] eq $betapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tdd3rdcar) && ($_[5] eq $tdd3rdcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

if (($_[0] eq 8) && ($divciq eq "8T8R")){ 
if (($_[1] eq $gammapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tdd3rdcar) && ($_[5] eq $tdd3rdcar ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 


if (($_[0] eq 2) && ($divciq eq "4T4R")){  
if (($_[1] eq $gammapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

###2nd

if (($_[0] eq 9) && ($divciq eq "4T4R")){ 
if (($_[1] eq $alphapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       }      

if (($_[0] eq 10) && ($divciq eq "4T4R")){ 
if (($_[1] eq $betapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

if (($_[0] eq 11) && ($divciq eq "4T4R")){  
if (($_[1] eq $gammapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         } 
         
       } 

                 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    
              

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-PRACH-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>ROOT_SEQUENCE_INDEX</th><th align=center>ZERO_CORREL_ZONE_CONFIG</th></tr>\n");  
  
foreach $_(@prach_conf){

@_ = split (/,/,$_);


if ($_[0] eq 0){ 
if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         } 
         
       }      

if ($_[0] eq 1){ 
if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         } 
         
       } 
        

if ($_[0] eq 2){ 
if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         } 
         
       }  

#2nd

if ($_[0] eq 3){ 
if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         } 
         
       }      

if ($_[0] eq 4){ 
if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         } 
         
       } 
        

if ($_[0] eq 5){ 
if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         } 
         
       }  


#### 3rd

if ($_[0] eq 6){ 
if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         } 
         
       }      

if ($_[0] eq 7){ 
if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         } 
         
       } 
        

if ($_[0] eq 8){ 
if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         } 
         
       }  


if ($_[0] eq 9){ 
if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         } 
         
       }      

if ($_[0] eq 10){ 
if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         } 
         
       } 
        

if ($_[0] eq 11){ 
if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         } 
         
       } 
          
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    


if ($pkg eq "3.5.2"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-CELL-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_SIZE</th><th align=center>HNB_NAME</th><th align=center>ADD_SPECTRUM_EMISSION</th><th align=center>TRACKING_AREA_CODE</th><th align=center>IMS_EMERGENCY_SUPPORT</th></tr>\n");  
  
foreach $_(@tac){

@_ = split (/,/,$_);
if (($_[0] eq "0") || ($_[0] eq "1") || ($_[0] eq "2")){ 
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    
  
    
if ($_[4] eq "H'$tac") {
    

    print (HTMLFILE "<td align=center>$_[4]</td>\n");   
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
                                 
         } 
        

    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
    }      
if  (($secondcar eq "true") && (($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5"))){ 
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    
  
    
if ($_[4] eq "H'$tac") {
    

    print (HTMLFILE "<td align=center>$_[4]</td>\n");   
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
                                 
         } 
        

    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
    }   
if  (($thirdcar eq "true") && (($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8"))){ 
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    
  
    
if ($_[4] eq "H'$tac") {
    

    print (HTMLFILE "<td align=center>$_[4]</td>\n");   
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
                                 
         } 
        

    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
    }     
     
if  (($secondcar4T eq "true") && (($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11"))){ 
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    
  
    
if ($_[4] eq "H'$tac") {
    

    print (HTMLFILE "<td align=center>$_[4]</td>\n");   
     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
                                 
         } 
        

    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
    }                 
       }      

                                 
print (HTMLFILE "</table>\n");    
}




################## PLMN 3.5.x



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-CELLPLMN-INFO PRE OAR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PLMN_IDX</th><th align=center>PLMN_USAGE</th><th align=center>CELL_RESERVED_OP_USE</th></tr>\n");  

foreach $_(@cellplmn35x){

@_ = split (/,/,$_);

print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n"); 

if ($_[2] eq "use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");       
      
      }
if ($_[2] ne "use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");       
      
      }
      
if ($_[3] eq "reserved"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");       
      
      }
if ($_[3] ne "reserved"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");       
      
      }
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}

print (HTMLFILE "</table>\n");   

if ($bucket !~ m/COMMERCIAL/){

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-CELLPLMN-INFO POST OAR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PLMN_IDX</th><th align=center>PLMN_USAGE</th><th align=center>CELL_RESERVED_OP_USE</th></tr>\n");  

foreach $_(@cellplmn35x){

@_ = split (/,/,$_);

if ($_[1] eq "0"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n"); 

if ($_[2] eq "use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");       
      
      }
if ($_[2] ne "use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");       
      
      }
      
if ($_[3] eq "reserved"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");       
      
      }
if ($_[3] ne "reserved"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");       
      
      }
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}


if ($_[1] eq "1"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n"); 

if ($_[2] eq "no_use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");       
      
      }
if ($_[2] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");       
      
      }
      
if ($_[3] eq "notReserved"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");       
      
      }
if ($_[3] ne "notReserved"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");       
      
      }
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}
}

print (HTMLFILE "</table>\n"); 

}

if ($bucket =~ m/COMMERCIAL/){

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-CELLPLMN-INFO POST OAR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PLMN_IDX</th><th align=center>PLMN_USAGE</th><th align=center>CELL_RESERVED_OP_USE</th></tr>\n");  

foreach $_(@cellplmn35x){

@_ = split (/,/,$_);

if ($_[1] eq "0"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n"); 

if ($_[2] eq "use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");       
      
      }
if ($_[2] ne "use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");       
      
      }
      
if ($_[3] eq "notReserved"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");       
      
      }
if ($_[3] ne "notReserved"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");       
      
      }
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}


if ($_[1] eq "1"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n"); 

if ($_[2] eq "no_use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");       
      
      }
if ($_[2] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");       
      
      }
      
if ($_[3] eq "notReserved"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");       
      
      }
if ($_[3] ne "notReserved"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");       
      
      }
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}
}

print (HTMLFILE "</table>\n"); 

}
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-ENBPLMN-INFO PRE OAR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>PLMN_IDX</th><th align=center>MCC</th><th align=center>MNC</th><th align=center>OP_ID</th></tr>\n"); 

foreach $_(@enbplmn35x){

@_ = split (/,/,$_);

print (HTMLFILE "<td align=center>$_[0]</td>\n");

if (($_[0] eq "0") && ($_[1] eq "777")){
 print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      }
if (($_[0] eq "0") && ($_[1] ne "777")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      }
      
if (($_[0] eq "1") && ($_[1] eq "310")){
 print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      }
if (($_[0] eq "1") && ($_[1] ne "310")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      }      


if (($_[0] eq "0") && ($_[2] eq "888")){
 print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      }
if (($_[0] eq "0") && ($_[2] ne "888")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      }
      
if (($_[0] eq "1") && ($_[2] eq "120")){
 print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      }
if (($_[0] eq "1") && ($_[2] ne "120")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      }   


      
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] eq "FFF")){
 print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      }
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] ne "FFF")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      }       


# if (($_[0] eq "0") && ($_[2] eq "888")){
 # print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      # }
# if (($_[0] eq "0") && ($_[2] ne "888")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      # }
      
# if (($_[0] eq "1") && ($_[2] eq "120")){
 # print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      # }
# if (($_[0] eq "1") && ($_[2] ne "120")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      # }      

      
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[2] eq "FFF")){
 print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      }
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[2] ne "FFF")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      } 

if ((($_[0] eq "0") ||($_[0] eq "1") ||($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[3] eq "0")){
 print (HTMLFILE "<td align=center>$_[3]</td>\n");           
      }
if ((($_[0] eq "0") ||($_[0] eq "1") ||($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8") ) && ($_[3] ne "0")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");           
      }

      

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}

print (HTMLFILE "</table>\n");  




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-ENBPLMN-INFO POST OAR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>PLMN_IDX</th><th align=center>MCC</th><th align=center>MNC</th><th align=center>OP_ID</th></tr>\n"); 

foreach $_(@enbplmn35x){

@_ = split (/,/,$_);

print (HTMLFILE "<td align=center>$_[0]</td>\n");

if (($_[0] eq "0") && ($_[1] eq "310")){
 print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      }
if (($_[0] eq "0") && ($_[1] ne "310")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      }
      
if (($_[0] eq "1") && ($_[1] eq "FFF")){
 print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      }
if (($_[0] eq "1") && ($_[1] ne "FFF")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      }      


if (($_[0] eq "0") && ($_[2] eq "120")){
 print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      }
if (($_[0] eq "0") && ($_[2] ne "120")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      }
      
if (($_[0] eq "1") && ($_[2] eq "FFF")){
 print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      }
if (($_[0] eq "1") && ($_[2] ne "FFF")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      }   


      
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] eq "FFF")){
 print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      }
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] ne "FFF")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      }       


# if (($_[0] eq "0") && ($_[2] eq "888")){
 # print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      # }
# if (($_[0] eq "0") && ($_[2] ne "888")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      # }
      
# if (($_[0] eq "1") && ($_[2] eq "120")){
 # print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      # }
# if (($_[0] eq "1") && ($_[2] ne "120")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      # }      

      
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[2] eq "FFF")){
 print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      }
if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[2] ne "FFF")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      } 

if ((($_[0] eq "0") ||($_[0] eq "1") ||($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[3] eq "0")){
 print (HTMLFILE "<td align=center>$_[3]</td>\n");           
      }
if ((($_[0] eq "0") ||($_[0] eq "1") ||($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[3] ne "0")){
 print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");           
      }

      

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}

print (HTMLFILE "</table>\n");  
#################################








print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-GPS-INVT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>UNIT_ID</th><th align=center>VERSION</th><th align=center>FW_VERSION</th><th align=center>SERIAL</th><th align=center>VENDOR</th></tr>\n");  
  
foreach $_(@gps){

@_ = split (/,/,$_);
print (HTMLFILE "<td align=center>$_[0]</td>\n");   
      
if ($_[4] eq "SAMSUNG"){
     if ($_[1] eq "1.0.0.2"){
           print (HTMLFILE "<td align=center>$_[1]</td>\n");                   
               }     
     if ($_[1] ne "1.0.0.2"){
           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                   
               }
     if ($_[2] eq "1.0.0.5"){
           print (HTMLFILE "<td align=center>$_[2]</td>\n");                   
               }     
     if ($_[2] ne "1.0.0.5"){
           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                   
               }                 
                          
          }
          
if ($_[4] eq "Trimble-D"){
     if ($_[1] eq "1.0.0.0"){
           print (HTMLFILE "<td align=center>$_[1]</td>\n");                   
               }     
     if ($_[1] ne "1.0.0.0"){
           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                   
               }
     if ($_[2] eq "1.0.0.1"){
           print (HTMLFILE "<td align=center>$_[2]</td>\n");                   
               }     
     if ($_[2] ne "1.0.0.1"){
           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                   
               }                 
                          
          }          
          
print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
print (HTMLFILE "<td align=center>$_[4]</td>\n"); 

         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    

                   

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-INVT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONN_BD_ID</th><th align=center>CONN_PORT_ID</th><th align=center>UNIT_ID</th><th align=center>FAMILY_TYPE</th><th align=center>FW_VERSION</th><th align=center>SERIAL</th></tr>\n");  
  
foreach $_(@rrh_invt){

@_ = split (/,/,$_);

if ($pkg =~ m/^3/) {
if ($_[1] eq 6){ 
if ($_[4] eq "1.0.6.1"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       }      

if ($_[1] eq 8){ 
if ($_[4] eq "1.0.6.1"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       } 
       
if ($_[1] eq 10){ 
if ($_[4] eq "1.0.6.1"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       }             
                    }
if ($pkg =~ m/^4/) {
if ($_[1] eq 6){ 
if ($_[4] eq "1.1.0.5"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       }      

if ($_[1] eq 8){ 
if ($_[4] eq "1.1.0.5"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       } 
       
if ($_[1] eq 10){ 
if ($_[4] eq "1.1.0.5"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       }         
                   }
if ($pkg =~ m/^5/) {
if ($_[1] eq 6){ 
if ($_[4] eq "1.2.0.1"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       }      

if ($_[1] eq 8){ 
if ($_[4] eq "1.2.0.1"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       } 
       
if ($_[1] eq 10){ 
if ($_[4] eq "1.2.0.1"){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
         } 
         
       }         
                   }  
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    

                                 
                                                     
                 

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-CONF:0,6</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>POWER_BOOST</th><th align=center>NUM_OF_ALD</th><th align=center>DIGITAL_INPUT_LOW_ALARM_TH</th><th align=center>START_EARFCN1</th><th align=center>ANTENNA_PROFILE_ID</th><th align=center>CELL_NUM</th></tr>\n");  

my ($boolEAR);

$boolEAR = "false";
  
@_ = split (/~/,$port6);
if ($pkg eq "3.5.2"){
if ($divciq eq "8T8R"){
if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    if ($_[6] eq $alphaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          }
    if ($_[6] ne $alphaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }     
                                                                 
    if (($secondcar ne "true") && ($_[7] eq "0,-,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }        
    if (($secondcar eq "true") && ($_[7] eq "0,3,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }
   
    if (($secondcar ne "true") && ($_[7] ne "0,-,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          } 
    if (($secondcar eq "true") && ($_[7] ne "0,3,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          }
                                                                                                 
    $boolEAR = "true"; 
            
    }
}
if ($divciq eq "4T4R"){
if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    if ($_[6] eq $alphaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          }
    if ($_[6] ne $alphaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                                         
    if (($secondcar4T ne "true") && ($_[7] eq "0,-,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }        
    if (($secondcar4T eq "true") && ($_[7] eq "0,9,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }
   
    if (($secondcar4T ne "true") && ($_[7] ne "0,-,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          } 
    if (($secondcar4T eq "true") && ($_[7] ne "0,9,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          }                                                                                        
    $boolEAR = "true"; 
            
    }
}      
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    # if ($_[6] eq $alphaid){
       # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          # }
    # $boolEAR = "true";    
    # }    
    
    
    if ($boolEAR eq "false") {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
	print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
         } 
}                   


if (($pkg eq "4.0.2")||($pkg eq "5.0.2")){
if ($divciq eq "8T8R"){
if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36,36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    if ($_[6] eq $alphaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          }
    if ($_[6] ne $alphaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                                            
                                                                                        
    $boolEAR = "true"; 
            
    }
	print (HTMLFILE "<td align=center>$_[7]</td>\n");
}
if ($divciq eq "4T4R"){
if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    if ($_[6] eq $alphaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          }
    if ($_[6] ne $alphaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                                         


                                                                                        
    $boolEAR = "true"; 
            
    }
	print (HTMLFILE "<td align=center>$_[7]</td>\n");
}      
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");     
    # if ($_[6] eq $alphaid){
       # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          # }
    # $boolEAR = "true";    
    # }    
    
    
    if ($boolEAR eq "false") {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
	print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
         } 
}                               
print (HTMLFILE "</table>\n");   



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-CONF:0,8</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>POWER_BOOST</th><th align=center>NUM_OF_ALD</th><th align=center>DIGITAL_INPUT_LOW_ALARM_TH</th><th align=center>START_EARFCN1</th><th align=center>ANTENNA_PROFILE_ID</th><th align=center>CELL_NUM</th></tr>\n");  
  
@_ = split (/~/,$port8);

if ($pkg eq "3.5.2"){
if ($divciq eq "8T8R"){
if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $betaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $betaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                                
    if (($secondcar ne "true") && ($_[7] eq "1,-,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }        
    if (($secondcar eq "true") && ($_[7] eq "1,4,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }
   
    if (($secondcar ne "true") && ($_[7] ne "1,-,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          } 
    if (($secondcar eq "true") && ($_[7] ne "1,4,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          }
    $boolEAR = "true";        
    }
 }

if ($divciq eq "4T4R"){
if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $betaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $betaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                                

    if (($secondcar4T ne "true") && ($_[7] eq "1,-,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }        
    if (($secondcar4T eq "true") && ($_[7] eq "1,10,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }
   
    if (($secondcar4T ne "true") && ($_[7] ne "1,-,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          } 
    if (($secondcar4T eq "true") && ($_[7] ne "1,10,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          }

    $boolEAR = "true";        
    }
 }     
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
    # if ($_[6] eq $betaid){
       # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          # }      
    # $boolEAR = "true";    
    # }    
    
    if ($boolEAR eq "false") {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
	print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
         } 
}                    
if (($pkg eq "4.0.2")||($pkg eq "5.0.2")){
if ($divciq eq "8T8R"){
if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36,36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $betaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $betaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                                
    $boolEAR = "true";        
    }
	print (HTMLFILE "<td align=center>$_[7]</td>\n");
 }

if ($divciq eq "4T4R"){
if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $betaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $betaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                                
    $boolEAR = "true";        
    }
	print (HTMLFILE "<td align=center>$_[7]</td>\n");
 }     
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
    # if ($_[6] eq $betaid){
       # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          # }      
    # $boolEAR = "true";    
    # }    
    
    if ($boolEAR eq "false") {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
	print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
         } 
}                      
print (HTMLFILE "</table>\n");   


 
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-CONF:0,10</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>POWER_BOOST</th><th align=center>NUM_OF_ALD</th><th align=center>DIGITAL_INPUT_LOW_ALARM_TH</th><th align=center>START_EARFCN1</th><th align=center>ANTENNA_PROFILE_ID</th><th align=center>CELL_NUM</th></tr>\n");  
  
@_ = split (/~/,$port10);
if ($pkg eq "3.5.2"){
if ($divciq eq "8T8R"){
if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $gammaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $gammaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                               
    if (($secondcar ne "true") && ($_[7] eq "2,-,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }        
    if (($secondcar eq "true") && ($_[7] eq "2,5,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }
   
    if (($secondcar ne "true") && ($_[7] ne "2,-,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          } 
    if (($secondcar eq "true") && ($_[7] ne "2,5,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          }
    $boolEAR = "true";          
    }
 }
if ($divciq eq "4T4R"){
if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $gammaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $gammaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                               
    if (($secondcar4T ne "true") && ($_[7] eq "2,-,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }        
    if (($secondcar4T eq "true") && ($_[7] eq "2,11,-,-,-,-")){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");           
          }
   
    if (($secondcar4T ne "true") && ($_[7] ne "2,-,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          } 
    if (($secondcar4T eq "true") && ($_[7] ne "2,11,-,-,-,-")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
          }
    $boolEAR = "true";          
    }
 }
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");
    # if ($_[6] eq $gammaid){
       # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          # }    
    # $boolEAR = "true";        
    # }       
    
    if ($boolEAR eq "false") {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
	print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
         } 
}                    
if (($pkg eq "4.0.2")||($pkg eq "5.0.2")){
if ($divciq eq "8T8R"){
if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36,36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $gammaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $gammaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                               
    $boolEAR = "true";          
    }
	print (HTMLFILE "<td align=center>$_[7]</td>\n");
 }
if ($divciq eq "4T4R"){
if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    if ($_[6] eq $gammaid){
       print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          } 
    if ($_[6] ne $gammaid){
       print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
                          }                               
    $boolEAR = "true";          
    }
	print (HTMLFILE "<td align=center>$_[7]</td>\n");
 }
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");
    # if ($_[6] eq $gammaid){
       # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
                          # }    
    # $boolEAR = "true";        
    # }       
    
    if ($boolEAR eq "false") {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
	print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
         } 
}                     
print (HTMLFILE "</table>\n");                       
                                      

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-EAIU-INVT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>UNIT_ID</th><th align=center>FAMILY_TYPE</th><th align=center>FW_VERSION</th><th align=center>SERIAL</th><th align=center>VERSION</th><th align=center>HW_NAME</th></tr>\n");  
  
foreach $_(@eaiu_invt){

@_ = split (/,/,$_);

my ($bool_find);

$bool_find = "false";
$bool_find_first = "false";

# if (($cabinet eq "OUTDOOR")  && ($_[0] eq "EAIU[0]")){ 
if ($_[0] eq "EAIU[0]"){
if ($pkg ne "5.0.2"){ 
# if ($_[2] eq "0.1.12.26"){
    
    if (($_[5] eq "EAIU4-U") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.26")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    $bool_find = "true";    
    }
	if (($_[5] eq "EAIU4-U") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.27")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    $bool_find = "true";    
    }
	
    if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.21")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");   
    $bool_find = "true";
    
    }
    if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.23")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");   
    $bool_find = "true";
    
    }      
    
    if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.24")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");   
    $bool_find = "true";
    
    }      
        
    if (($_[5] eq "EAIU4-U_I") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.5")){ # add 9
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    $bool_find = "true";  
    } 
    
    if (($_[5] eq "EAIU4-U_I") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.9")){ # add 9
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    $bool_find = "true";  
    }     
    
    if (($_[5] eq "EAIU4-UA") && ($_[4] eq "1.0.0.0") && ($_[2] eq "1.2.0.7")){ # add 9
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    $bool_find = "true";  
    }     
    
   if ($bool_find eq "false") {
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
   }        

                    }
if ($pkg eq "5.0.2"){
    if (($_[5] eq "EAIU4-U") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.27")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    $bool_find = "true";  
                                                                                }
    if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.24")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    $bool_find = "true";  
                                                                                }     
    if (($_[5] eq "EAIU4-U_I") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.11")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    $bool_find = "true";  
                                                                                  }
    if (($_[5] eq "EAIU4-UA") && ($_[4] eq "1.0.0.0") && ($_[2] eq "1.2.0.9")){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    $bool_find = "true";  
                                                                              }
   if ($bool_find eq "false") {
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
   print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
                              }        
					}
}
                    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
 }
 
print (HTMLFILE "</table>\n");    
                  

if ($mme_assignment eq "Chicago_Akron"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-S1-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_ID</th><th align=center>SCTP_STATE</th><th align=center>S1AP_STATE</th><th align=center>MME_NAME</th><th align=center>IP_VER</th><th align=center>MME_IP_V4</th></tr>\n");  
  
foreach $_(@s1){
my ($s1_boolean);
@_ = split (/,/,$_);

print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");
if ($_[2] eq "enabled"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");      
}      
if ($_[2] ne "enabled"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");      
} 
if ($_[3] eq "enabled"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");      
}      
if ($_[3] ne "enabled"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");      
} 
if (($_[4] eq "CHCGILFF-MME-01") || ($_[4] eq "AKRNOHIJ-MME-11") || ($_[4] eq "CHCGILFF-MME-02") || ($_[4] eq "AKRNOHIJ-MME-12") || ($_[4] eq "CHCGILFF-MME-03") || ($_[4] eq "AKRNOHIJ-MME-13") || ($_[4] eq "CHCGILFF-MME-04") || ($_[4] eq "AKRNOHIJ-MME-14") || ($_[4] eq "CHCGILFF-MME-05") || ($_[4] eq "AKRNOHIJ-MME-15") || ($_[4] eq "CHCGILFF-MME-06") || ($_[4] eq "AKRNOHIJ-MME-16") || ($_[4] eq "CHCGILFF-MME-07") || ($_[4] eq "AKRNOHIJ-MME-17") ){
print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
$s1_boolean = "true";
}
if ($s1_boolean ne "true"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");        
      
}      
if ($_[5] eq "IPV4"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");      
}      
if ($_[5] ne "IPV4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");      
}       
print (HTMLFILE "<td align=center>$_[6]</td>\n");       
       

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    
}


if ($mme_assignment eq "San_Jose_Tacoma"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-S1-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_ID</th><th align=center>SCTP_STATE</th><th align=center>S1AP_STATE</th><th align=center>MME_NAME</th><th align=center>IP_VER</th><th align=center>MME_IP_V4</th></tr>\n");  
  
foreach $_(@s1){
my ($s1_boolean);
@_ = split (/,/,$_);

print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");
if ($_[2] eq "enabled"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");      
}      
if ($_[2] ne "enabled"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");      
} 
if ($_[3] eq "enabled"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");      
}      
if ($_[3] ne "enabled"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");      
} 
if (($_[4] eq "SNJSCASP-MME-01") || ($_[4] eq "TACMWA44-MME-11") || ($_[4] eq "SNJSCASP-MME-02") || ($_[4] eq "TACMWA44-MME-12") || ($_[4] eq "SNJSCASP-MME-03") || ($_[4] eq "TACMWA44-MME-13")){
print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
$s1_boolean = "true";
}
if ($s1_boolean ne "true"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");        
      
}      
if ($_[5] eq "IPV4"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");      
}      
if ($_[5] ne "IPV4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");      
}       
print (HTMLFILE "<td align=center>$_[6]</td>\n");       
       

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    
}
if ($mme_assignment eq "Bayamon"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-S1-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_ID</th><th align=center>SCTP_STATE</th><th align=center>S1AP_STATE</th><th align=center>MME_NAME</th><th align=center>IP_VER</th><th align=center>MME_IP_V4</th></tr>\n");  
  
foreach $_(@s1){
my ($s1_boolean);
@_ = split (/,/,$_);

print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");
if ($_[2] eq "enabled"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");      
}      
if ($_[2] ne "enabled"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");      
} 
if ($_[3] eq "enabled"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");      
}      
if ($_[3] ne "enabled"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");      
} 
if (($_[4] eq "bymnprag-mme-01") || ($_[4] eq "miauflws-mme-11")){
print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
$s1_boolean = "true";
}
if ($s1_boolean ne "true"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");        
      
}      
if ($_[5] eq "IPV4"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");      
}      
if ($_[5] ne "IPV4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");      
}       
print (HTMLFILE "<td align=center>$_[6]</td>\n");       
       

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    
}

########3X2

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-X2-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>NBR_ENB_INDEX</th><th align=center>NBR_ENB_ID</th><th align=center>SCTP_STATE</th><th align=center>X2AP_STATE</th></tr>\n");  
  
foreach $_(@x2){

@_ = split (/,/,$_);


if (($_[2] eq "enable_INS")  && ($_[3] eq "enabled")){ 
   print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
   
    
          
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
         } 
         
       

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n");    



###### punct

########3X2

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-PUNCTMODE-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>USER_SPECIFIC_TIMING</th></tr>\n");  
  

if ($punc_data =~ m/^WiMAX29_18_LTE1_7_WITH_TDLTE_PUNCTURING_10650/){ 
   print (HTMLFILE "<td align=center>$punc_data</td>\n");
  
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$punc_data</td>\n");      
         } 
         
       

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                     
                    
                    
print (HTMLFILE "</table>\n");    






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RET-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>ALD_ID</th><th align=center>ANT_ID</th><th align=center>TILT</th></tr>\n");  
  
foreach $_(@ret){

@_ = split (/,/,$_);


if ($_[1] eq 6){ 
if (($_[3] eq "1") && ($_[4] eq $alphatilt)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
         
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");     
      
         } 
         
       }      

if ($_[1] eq 8){ 
if (($_[3] eq "1") && ($_[4] eq $betatilt)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
         
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");     
      
         } 
         
       }    

if ($_[1] eq 10){ 
if (($_[3] eq "1") && ($_[4] eq $gammatilt)){
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
         
    }
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");     
      
         } 
         
       }            
       
         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n"); 


###############################################3


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=12 align=center bgcolor=#EEEEEE><b>RTRV-NBR-EUTRAN</b></td></tr>\n");


if ((!@alphaeutranlog) && (!@betaeutranlog) && (!@gammaeutranlog) && (!@alphaeutranlog) && (!@betaeutranlog2) && (!@gammaeutranlog2)){
      
      print (HTMLFILE "<td bgcolor=#FF0000 align=center>NO EUTRAN NBR</td>\n"); 
      
      }
if ((@alphaeutranlog) || (@betaeutranlog) || (@gammaeutranlog) || (@alphaeutranlog) || (@betaeutranlog2) || (@gammaeutranlog2)){
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>RELATION_IDX</th><th align=center>STATUS</th><th align=center>ENB_ID</th><th align=center>TARGET_CELL_NUM</th><th align=center>IS_REMOVE_ALLOWED</th><th align=center>ENB_MCC</th><th align=center>ENB_MNC</th><th align=center>MCC0</th><th align=center>MNC0</th><th align=center>MCC1</th><th align=center>MNC1</th></tr>\n");  

if ($alphapci ne ""){  
foreach $_(@alphaeutranlog){

@_ = split (/,/,$_);


      
      print (HTMLFILE "<td align=center>$_[0]</td>\n");
      print (HTMLFILE "<td align=center>$_[1]</td>\n");
      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      if ($_[3] eq $enbid){
          print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            }
      if ($_[3] ne $enbid){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            }      
      print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      if ($_[5] eq "False"){
          print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            }
      if ($_[5] ne "False"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            }      
      if ($_[6] eq "310"){
          print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            }
      if ($_[6] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            }   
      if ($_[7] eq "120"){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            }
      if ($_[7] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            }             
      if ($_[8] eq "310"){
          print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            }
      if ($_[8] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            }             
      if ($_[9] eq "120"){
          print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            }
      if ($_[9] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            } 
      if ($_[10] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            }
      if ($_[10] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            }             
      if ($_[11] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            }
      if ($_[11] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            }             
            
                                 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                
                  }      

                    } 

if ($betapci ne ""){  
foreach $_(@betaeutranlog){

@_ = split (/,/,$_);


      
      print (HTMLFILE "<td align=center>$_[0]</td>\n");
      print (HTMLFILE "<td align=center>$_[1]</td>\n");
      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      if ($_[3] eq $enbid){
          print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            }
      if ($_[3] ne $enbid){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            }      
      print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      if ($_[5] eq "False"){
          print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            }
      if ($_[5] ne "False"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            }      
      if ($_[6] eq "310"){
          print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            }
      if ($_[6] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            }   
      if ($_[7] eq "120"){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            }
      if ($_[7] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            }             
      if ($_[8] eq "310"){
          print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            }
      if ($_[8] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            }             
      if ($_[9] eq "120"){
          print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            }
      if ($_[9] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            } 
      if ($_[10] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            }
      if ($_[10] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            }             
      if ($_[11] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            }
      if ($_[11] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            }             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                
                  }      

                    } 

if ($gammapci ne ""){  
foreach $_(@gammaeutranlog){

@_ = split (/,/,$_);


      
      print (HTMLFILE "<td align=center>$_[0]</td>\n");
      print (HTMLFILE "<td align=center>$_[1]</td>\n");
      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      if ($_[3] eq $enbid){
          print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            }
      if ($_[3] ne $enbid){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            }      
      print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      if ($_[5] eq "False"){
          print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            }
      if ($_[5] ne "False"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            }      
      if ($_[6] eq "310"){
          print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            }
      if ($_[6] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            }   
      if ($_[7] eq "120"){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            }
      if ($_[7] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            }             
      if ($_[8] eq "310"){
          print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            }
      if ($_[8] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            }             
      if ($_[9] eq "120"){
          print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            }
      if ($_[9] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            } 
      if ($_[10] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            }
      if ($_[10] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            }             
      if ($_[11] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            }
      if ($_[11] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            }               
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                
                  }      

                    } 
if ($alphapci ne ""){  
foreach $_(@alphaeutranlog2){

@_ = split (/,/,$_);


      
      print (HTMLFILE "<td align=center>$_[0]</td>\n");
      print (HTMLFILE "<td align=center>$_[1]</td>\n");
      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      if ($_[3] eq $enbid){
          print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            }
      if ($_[3] ne $enbid){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            }      
      print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      if ($_[5] eq "False"){
          print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            }
      if ($_[5] ne "False"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            }      
      if ($_[6] eq "310"){
          print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            }
      if ($_[6] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            }   
      if ($_[7] eq "120"){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            }
      if ($_[7] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            }             
      if ($_[8] eq "310"){
          print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            }
      if ($_[8] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            }             
      if ($_[9] eq "120"){
          print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            }
      if ($_[9] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            } 
      if ($_[10] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            }
      if ($_[10] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            }             
      if ($_[11] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            }
      if ($_[11] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            }             
            
                                 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                
                  }      

                    } 

if ($betapci ne ""){  
foreach $_(@betaeutranlog2){

@_ = split (/,/,$_);


      
      print (HTMLFILE "<td align=center>$_[0]</td>\n");
      print (HTMLFILE "<td align=center>$_[1]</td>\n");
      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      if ($_[3] eq $enbid){
          print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            }
      if ($_[3] ne $enbid){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            }      
      print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      if ($_[5] eq "False"){
          print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            }
      if ($_[5] ne "False"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            }      
      if ($_[6] eq "310"){
          print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            }
      if ($_[6] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            }   
      if ($_[7] eq "120"){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            }
      if ($_[7] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            }             
      if ($_[8] eq "310"){
          print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            }
      if ($_[8] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            }             
      if ($_[9] eq "120"){
          print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            }
      if ($_[9] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            } 
      if ($_[10] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            }
      if ($_[10] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            }             
      if ($_[11] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            }
      if ($_[11] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            }             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                
                  }      

                    } 

if ($gammapci ne ""){  
foreach $_(@gammaeutranlog2){

@_ = split (/,/,$_);


      
      print (HTMLFILE "<td align=center>$_[0]</td>\n");
      print (HTMLFILE "<td align=center>$_[1]</td>\n");
      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      if ($_[3] eq $enbid){
          print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            }
      if ($_[3] ne $enbid){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            }      
      print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      if ($_[5] eq "False"){
          print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            }
      if ($_[5] ne "False"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            }      
      if ($_[6] eq "310"){
          print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            }
      if ($_[6] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            }   
      if ($_[7] eq "120"){
          print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            }
      if ($_[7] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            }             
      if ($_[8] eq "310"){
          print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            }
      if ($_[8] ne "310"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            }             
      if ($_[9] eq "120"){
          print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            }
      if ($_[9] ne "120"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            } 
      if ($_[10] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            }
      if ($_[10] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            }             
      if ($_[11] eq "FFF"){
          print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            }
      if ($_[11] ne "FFF"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            }               
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                
                  }      

                    }                                                                 
}                    
print (HTMLFILE "</table>\n"); 






###############################################
                   

############################################## 

###############################################
                   
############################################## 

###############################################
                   

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>PATH_ID</th><th align=center>OPERATIONAL_STATE</th><th align=center>PATH_STATE</th></tr>\n");  
  
foreach $_(@rrh){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    print (HTMLFILE "<td align=center>$_[4]</td>\n");     
    
             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");




                    } 
                    
                    
print (HTMLFILE "</table>\n"); 



############################################## 

###############################################
                   

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-POS-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>LAT</th><th align=center>LATITUDE</th><th align=center>LONG</th><th align=center>LONGITUDE</th></tr>\n");  
  
foreach $_(@pos){

@_ = split (/,/,$_);

if (($_[0] <= 5) && ($secondcar eq "true")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    if ($_[2] eq $convert_lat){
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    }
    if ($_[2] ne $convert_lat){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }    
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    if ($_[4] eq $convert_long){
    print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    }
    if ($_[4] ne $convert_long){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    }     
    
             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}
if (($_[0] <= 8) && ($thirdcar eq "true")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    if ($_[2] eq $convert_lat){
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    }
    if ($_[2] ne $convert_lat){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }    
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    if ($_[4] eq $convert_long){
    print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    }
    if ($_[4] ne $convert_long){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    }     
    
             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}

if ((($_[0] <= "2") || (($_[0] >= "9") && ($_[0] <= "11"))) && ($secondcar4T eq "true")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    if ($_[2] eq $convert_lat){
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    }
    if ($_[2] ne $convert_lat){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }    
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    if ($_[4] eq $convert_long){
    print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    }
    if ($_[4] ne $convert_long){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    }     
    
             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}
if (($_[0] <= "2") && ($secondcar ne "true") && ($secondcar4T ne "true")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    if ($_[2] eq $convert_lat){
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    }
    if ($_[2] ne $convert_lat){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }    
    print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    if ($_[4] eq $convert_long){
    print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    }
    if ($_[4] ne $convert_long){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    }     
    
             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 



############################################## 


###############################################
                   

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-BF-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>BF_STATE</th><th align=center>CAL_REASON</th><th align=center>CAL_TYPE</th></tr>\n");  
  
foreach $_(@bf){

@_ = split (/,/,$_);
if ($_[0] <= 11){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");      
    
             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

}


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 



############################################## 

###############################################
                   
                    
if (($pkg ne "3.5.2") && ($pkg ne "4.0.2")&& ($pkg ne "5.0.2")){

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-C1XRTT-MOBIL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>LTM_OFF_TDD</th><th align=center>DAYLT_TDD</th></tr>\n");  

foreach $_(@ltm){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    
    if ($_[1] eq $ltm){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }
    if ($_[1] ne $ltm){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    }   
    
    if ($_[2] eq "0"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }
    if ($_[2] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }     
    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                     
                       
                       
print (HTMLFILE "</table>\n"); 
}


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-ULRESCONF-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>RESOURCE_TABLE_USAGE</th><th align=center>START_STATE_IDX</th><th align=center>END_STATE_IDX</th></tr>\n");  

foreach $_(@ULRESCONF){

@_ = split (/,/,$_);

  if ($_[0] <= 11){

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    
    if ($_[1] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }
    if ($_[1] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    }       
    if ($_[2] eq "0"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }
    if ($_[2] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }     

	if ($pkg =~ m/^3/) {
    if ($_[3] eq "0"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }
    if ($_[3] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    }
                       }
	if ($pkg =~ m/^4/) {
    if ($_[3] eq "3"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }
    if ($_[3] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    }
                       }
	if ($pkg =~ m/^5/) {
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
                       }
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }

   }
                     
                       
                       
print (HTMLFILE "</table>\n"); 


####PREG

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-C1XRTT-PREG</b></td></tr>\n");
 

if (!@c1xrttpreg){
      print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#FF0000><b>C1XRTT-PREG NOT CONFIGURED</b></td></tr>\n");  

      print (HTMLFILE "</td>\n");
      print (HTMLFILE "</tr>\n");  
      
      }
if (@c1xrttpreg){
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CSFB_PRE_REG_USAGE</th><th align=center>SID</th><th align=center>NID</th></tr>\n");       
foreach $_(@c1xrttpreg){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    
    if ($_[1] eq "use"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }
    if ($_[1] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    }   
    
    if ($_[2] ne "0"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }
    if ($_[2] eq "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }     

    if ($_[3] ne "0"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }
    if ($_[3] eq "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    }
         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

   }
                     
}                       
                       
print (HTMLFILE "</table>\n"); 


############################################### EUTRA FA


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-EUTRA-FA</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>FA_INDEX</th><th align=center>STATUS</th><th align=center>EARFCN_UL</th><th align=center>EARFCN_DL</th></tr>\n");  

foreach $_(@eutra_fa){

@_ = split (/,/,$_);

    if ((($_[0] eq "0") || ($_[0] eq "1") || ($_[0] eq "2")) && ($_[1] eq "0")){
    if (($_[3] eq $earfcn) &&  ($_[4] eq $earfcn)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $earfcn) ||  ($_[4] ne $earfcn)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }  
    if ((($_[0] eq "0") || ($_[0] eq "1") || ($_[0] eq "2")) && ($_[1] eq "1")){
    if (($_[3] eq $tddsecondcar) &&  ($_[4] eq $tddsecondcar)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $tddsecondcar) ||  ($_[4] ne $tddsecondcar)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }      

    if ((($_[0] eq "0") || ($_[0] eq "1") || ($_[0] eq "2")) && ($_[1] eq "2")){
    if (($_[3] eq $tdd3rdcar) &&  ($_[4] eq $tdd3rdcar)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $tdd3rdcar) ||  ($_[4] ne $tdd3rdcar)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    } 
        
    if ((($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5")) && ($_[1] eq "0")){
    if (($_[3] eq $tddsecondcar) &&  ($_[4] eq $tddsecondcar)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $tddsecondcar) ||  ($_[4] ne $tddsecondcar)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }      
    if ((($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5")) && ($_[1] eq "1")){
    if (($_[3] eq $earfcn) &&  ($_[4] eq $earfcn)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $earfcn) ||  ($_[4] ne $earfcn)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }  

    if ((($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5")) && ($_[1] eq "2")){
    if (($_[3] eq $tdd3rdcar) &&  ($_[4] eq $tdd3rdcar)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $tdd3rdcar) ||  ($_[4] ne $tdd3rdcar)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    } 
    if ((($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] eq "0")){
    if (($_[3] eq $tdd3rdcar) &&  ($_[4] eq $tdd3rdcar)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $tdd3rdcar) ||  ($_[4] ne $tdd3rdcar)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }    
    if ((($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] eq "1")){
    if (($_[3] eq $earfcn) &&  ($_[4] eq $earfcn)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $earfcn) ||  ($_[4] ne $earfcn)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }
 
    if ((($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] eq "2")){
    if (($_[3] eq $tddsecondcar) &&  ($_[4] eq $tddsecondcar)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $tddsecondcar) ||  ($_[4] ne $tddsecondcar)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }  
 
          
    if ((($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11")) && ($_[1] eq "0")){
    if (($_[3] eq $tddsecondcar) &&  ($_[4] eq $tddsecondcar)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $tddsecondcar) ||  ($_[4] ne $tddsecondcar)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }      
    if ((($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11")) && ($_[1] eq "1")){
    if (($_[3] eq $earfcn) &&  ($_[4] eq $earfcn)){
          
          print (HTMLFILE "<td align=center>$_[0]</td>\n");
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          
          } 
    if (($_[3] ne $earfcn) ||  ($_[4] ne $earfcn)){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          
          }
    }     
    
    
          
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");


############################################## 
                                                

print (HTMLFILE "<br><br><table width=300% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=19 bgcolor=#EEEEEE><b>RTRV-DRX-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>PLMN_IDX</th><th align=center>QCI</th><th align=center>DRX_CONFIG_SETUP</th><th align=center>ON_DURATION_TIMER_NORMAL</th><th align=center>DRX_INACTIVITY_TIMER_NORMAL</th><th align=center>DRX_RETRANSMISSION_TIMER_NORMAL</th><th align=center>LONG_DRXCYCLE_START_OFFSET_TYPE_NORMAL</th><th align=center>SHORT_DRXCONFIG_SETUP</th><th align=center>SHORT_DRXCYCLE_NORMAL</th><th align=center>DRX_SHORT_CYCLE_TIMER_NORMAL</th><th align=center>DRX_SELECTION_ORDER</th><th align=center>ON_DURATION_TIMER_REPORT_CGI</th><th align=center>DRX_INACTIVITY_TIMER_REPORT_CGI</th><th align=center>DRX_RETRANSMISSION_TIMER_REPORT_CGI</th><th align=center>LONG_DRXCYCLE_START_OFFSET_TYPE_REPORT_CGI</th><th align=center>ON_DURATION_TIMER_INTER_RAT</th><th align=center>DRX_INACTIVITY_TIMER_INTER_RAT</th><th align=center>DRX_RETRANSMISSION_TIMER_INTER_RAT</th><th align=center>LONG_DRXCYCLE_START_OFFSET_TYPE_INTER_RAT</th></tr>\n");  

foreach $_(@drx){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
if ($pkg =~ m/^3/) { 
 if (($_[2] eq "ReportCGI") &&  ($_[3] eq "psf10") &&  ($_[4] eq "psf200") &&  ($_[5] eq "psf8") &&  ($_[6] eq "sf320") &&  ($_[7] eq "Release") &&  ($_[8] eq "sf40") &&  ($_[9] eq "8") &&  ($_[10] eq "9") &&  ($_[11] eq "psf10") &&  ($_[12] eq "psf20") &&  ($_[13] eq "psf16") &&  ($_[14] eq "sf160") &&  ($_[15] eq "psf10") && ($_[16] eq "psf100") &&  ($_[17] eq "psf16") &&  ($_[18] eq "sf2560")){
          
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
          print (HTMLFILE "<td align=center>$_[8]</td>\n");
          print (HTMLFILE "<td align=center>$_[9]</td>\n");
          print (HTMLFILE "<td align=center>$_[10]</td>\n");
          print (HTMLFILE "<td align=center>$_[11]</td>\n");          
          print (HTMLFILE "<td align=center>$_[12]</td>\n");
          print (HTMLFILE "<td align=center>$_[13]</td>\n");
          print (HTMLFILE "<td align=center>$_[14]</td>\n");
          print (HTMLFILE "<td align=center>$_[15]</td>\n");
          print (HTMLFILE "<td align=center>$_[16]</td>\n");          
          print (HTMLFILE "<td align=center>$_[17]</td>\n");            
          print (HTMLFILE "<td align=center>$_[18]</td>\n"); 

          
          } 
    if (($_[2] ne "ReportCGI") ||  ($_[3] ne "psf10") ||  ($_[4] ne "psf200") ||  ($_[5] ne "psf8") ||  ($_[6] ne "sf320") ||  ($_[7] ne "Release") ||  ($_[8] ne "sf40") ||  ($_[9] ne "8") ||  ($_[10] ne "9") ||  ($_[11] ne "psf10") ||  ($_[12] ne "psf20") ||  ($_[13] ne "psf16") ||  ($_[14] ne "sf160") ||  ($_[15] ne "psf10") ||  ($_[16] ne "psf100") ||  ($_[17] ne "psf16") ||  ($_[18] ne "sf2560")){

          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n"); 
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n"); 
          $drxgp = "true";
          }
                   }
if ($pkg =~ m/^4/) {
 if (($_[2] eq "ReportCGI") &&  ($_[3] eq "psf10") &&  ($_[4] eq "psf200") &&  ($_[5] eq "psf8") &&  ($_[6] eq "sf320") &&  ($_[7] eq "Release") &&  ($_[8] eq "sf40") &&  ($_[9] eq "8") &&  ($_[10] eq "9") &&  ($_[11] eq "psf10") &&  ($_[12] eq "psf40") &&  ($_[13] eq "psf16") &&  ($_[14] eq "sf160") &&  ($_[15] eq "psf10") && ($_[16] eq "psf100") &&  ($_[17] eq "psf16") &&  ($_[18] eq "sf2560")){
          
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
          print (HTMLFILE "<td align=center>$_[8]</td>\n");
          print (HTMLFILE "<td align=center>$_[9]</td>\n");
          print (HTMLFILE "<td align=center>$_[10]</td>\n");
          print (HTMLFILE "<td align=center>$_[11]</td>\n");          
          print (HTMLFILE "<td align=center>$_[12]</td>\n");
          print (HTMLFILE "<td align=center>$_[13]</td>\n");
          print (HTMLFILE "<td align=center>$_[14]</td>\n");
          print (HTMLFILE "<td align=center>$_[15]</td>\n");
          print (HTMLFILE "<td align=center>$_[16]</td>\n");          
          print (HTMLFILE "<td align=center>$_[17]</td>\n");            
          print (HTMLFILE "<td align=center>$_[18]</td>\n"); 

          
          } 
    if (($_[2] ne "ReportCGI") ||  ($_[3] ne "psf10") ||  ($_[4] ne "psf200") ||  ($_[5] ne "psf8") ||  ($_[6] ne "sf320") ||  ($_[7] ne "Release") ||  ($_[8] ne "sf40") ||  ($_[9] ne "8") ||  ($_[10] ne "9") ||  ($_[11] ne "psf10") ||  ($_[12] ne "psf40") ||  ($_[13] ne "psf16") ||  ($_[14] ne "sf160") ||  ($_[15] ne "psf10") ||  ($_[16] ne "psf100") ||  ($_[17] ne "psf16") ||  ($_[18] ne "sf2560")){

          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n"); 
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n"); 
          $drxgp = "true";
          }

                   }		  
if ($pkg =~ m/^5/) {
 if (($_[2] eq "ReportCGI") &&  ($_[3] eq "psf10") &&  ($_[4] eq "psf200") &&  ($_[5] eq "psf8") &&  ($_[6] eq "sf320") &&  ($_[7] eq "Release") &&  ($_[8] eq "sf40") &&  ($_[9] eq "8") &&  ($_[10] eq "9") &&  ($_[11] eq "psf10") &&  ($_[12] eq "psf40") &&  ($_[13] eq "psf16") &&  ($_[14] eq "sf160") &&  ($_[15] eq "psf10") && ($_[16] eq "psf100") &&  ($_[17] eq "psf16") &&  ($_[18] eq "sf2560")){
          
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
          print (HTMLFILE "<td align=center>$_[8]</td>\n");
          print (HTMLFILE "<td align=center>$_[9]</td>\n");
          print (HTMLFILE "<td align=center>$_[10]</td>\n");
          print (HTMLFILE "<td align=center>$_[11]</td>\n");          
          print (HTMLFILE "<td align=center>$_[12]</td>\n");
          print (HTMLFILE "<td align=center>$_[13]</td>\n");
          print (HTMLFILE "<td align=center>$_[14]</td>\n");
          print (HTMLFILE "<td align=center>$_[15]</td>\n");
          print (HTMLFILE "<td align=center>$_[16]</td>\n");          
          print (HTMLFILE "<td align=center>$_[17]</td>\n");            
          print (HTMLFILE "<td align=center>$_[18]</td>\n"); 

          
          } 
    if (($_[2] ne "ReportCGI") ||  ($_[3] ne "psf10") ||  ($_[4] ne "psf200") ||  ($_[5] ne "psf8") ||  ($_[6] ne "sf320") ||  ($_[7] ne "Release") ||  ($_[8] ne "sf40") ||  ($_[9] ne "8") ||  ($_[10] ne "9") ||  ($_[11] ne "psf10") ||  ($_[12] ne "psf40") ||  ($_[13] ne "psf16") ||  ($_[14] ne "sf160") ||  ($_[15] ne "psf10") ||  ($_[16] ne "psf100") ||  ($_[17] ne "psf16") ||  ($_[18] ne "sf2560")){

          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n"); 
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n"); 
          $drxgp = "true";
          }

                   }

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
if ($pkg =~ m/^5/) {
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-PUSCH-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>N_SB</th><th align=center>HOPPING_MODE</th><th align=center>ENABLE_SIX_FOUR_QAM</th><th align=center>GROUP_HOPPING_ENABLED</th><th align=center>GROUP_ASSIGNMENT_PUSCH</th><th align=center>SEQUENCE_HOPPING_ENABLED</th></tr>\n");  
                   }
if ($pkg =~ m/^4/) {
print (HTMLFILE "<tr><td colspan=2 align=center bgcolor=#EEEEEE><b>RTRV-PUSCH-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>N_SB</th></tr>\n");  
                   }				   
foreach $_(@puschconf){

@_ = split (/,/,$_);


    print (HTMLFILE "<td align=center>$_[0]</td>\n");
	if ($pkg =~ m/^5/) {
    if (($_[1] eq "1") &&  ($_[2] eq "interSubFrame") &&  ($_[3] eq "False") &&  ($_[4] eq "False") &&  ($_[5] eq "0") &&  ($_[6] eq "False")){
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");           
          print (HTMLFILE "<td align=center>$_[6]</td>\n");           

          
          } 
    if (($_[1] ne "1") ||  ($_[2] ne "interSubFrame") ||  ($_[3] ne "False") ||  ($_[4] ne "False") ||  ($_[5] ne "0") ||  ($_[6] ne "False")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          $puschconf = "true";
          
          }
		  }
		  
	if ($pkg =~ m/^4/) {
    if ($_[1] eq "1") {
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
        

          
          } 
    if ($_[1] ne "1"){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");

          $puschconf = "true";
          
          }
		  }		  
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-BF-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>BEAM_FORMING_ENABLE</th><th align=center>CALIBRATION_PERIOD</th><th align=center>SUBFRAME</th></tr>\n");  

foreach $_(@bfconf){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
	
if ($pkg =~ m/^3/) {	
    if (($divciq eq "8T8R") && ($_[0] <= "8")){
    if (($_[1] eq "True") &&  ($_[2] eq "30") &&  ($_[3] eq "0")) {
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          } 
    if (($_[1] ne "True") ||  ($_[2] ne "30") ||  ($_[3] ne "0")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           $bfconfgp="true"; 
          
          }
    }    
    if ($divciq eq "4T4R"){
    if (($_[1] eq "False") &&  ($_[2] eq "30") &&  ($_[3] eq "0")) {
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          } 
    if (($_[1] ne "False") ||  ($_[2] ne "30") ||  ($_[3] ne "0")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           $bfconfgp="true"; 
          
          }
    } 
                   }
if ($pkg =~ m/^4/) {
    if (($divciq eq "8T8R") && ($_[0] <= "8")){
    if (($_[1] eq "True") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          } 
    if (($_[1] ne "True") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           $bfconfgp="true"; 
          
          }
    }    
    if ($divciq eq "4T4R"){
    if (($_[1] eq "False") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          } 
    if (($_[1] ne "False") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           $bfconfgp="true"; 
          
          }
    } 
                    }		  
if ($pkg =~ m/^5/) {
    if (($divciq eq "8T8R") && ($_[0] <= "8")){
    if (($_[1] eq "True") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          } 
    if (($_[1] ne "True") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           $bfconfgp="true"; 
          
          }
    }    
    if ($divciq eq "4T4R"){
    if (($_[1] eq "False") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");
          print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          } 
    if (($_[1] ne "False") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           $bfconfgp="true"; 
          
          }
    } 
                    }    

	print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");
                             



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CLOCK-CTRL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CLOCK_ADVANCE</th><th align=center>CLOCK_RETARD</th></tr>\n");  

foreach $_(@CTRL){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if (($_[1] eq "121000") &&  ($_[2] eq "99200")){
          
          print (HTMLFILE "<td align=center>$_[1]</td>\n");
          print (HTMLFILE "<td align=center>$_[2]</td>\n");

          
          

          
          } 
    if (($_[1] ne "121000") ||  ($_[2] ne "99200")){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");


          
          }
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");

                            

# print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CELL-SEL</b></td></tr>\n");
# print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>Q_RX_LEV_MIN</th><th align=center>Q_RXLEV_MIN_OFFSET_USAGE</th><th align=center>Q_RXLEV_MIN_OFFSET</th><th align=center>P_MAX_USAGE</th><th align=center>P_MAX</th><th align=center>REL9_SEL_INFO_USAGE</th><th align=center>Q_QUAL_MIN</th><th align=center>Q_QUAL_MIN_OFFSET_USAGE</th><th align=center>Q_QUAL_MIN_OFFSET</th></tr>\n");  

# foreach $_(@sel){

# @_ = split (/,/,$_);

    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # if (($_[1] eq "-62") &&  ($_[2] eq "no_use") &&  ($_[3] eq "3") &&  ($_[4] eq "no_use") &&  ($_[5] eq "0") &&  ($_[6] eq "no_use") &&  ($_[7] eq "-16") &&  ($_[8] eq "no_use") &&  ($_[9] eq "3")){
          
          # print (HTMLFILE "<td align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");
          # print (HTMLFILE "<td align=center>$_[4]</td>\n");
          # print (HTMLFILE "<td align=center>$_[5]</td>\n");
          # print (HTMLFILE "<td align=center>$_[6]</td>\n");
          # print (HTMLFILE "<td align=center>$_[7]</td>\n");
          # print (HTMLFILE "<td align=center>$_[8]</td>\n");
          # print (HTMLFILE "<td align=center>$_[9]</td>\n");

          
                    
          
          

          
          # } 
    # if (($_[1] ne "-62") ||  ($_[2] ne "no_use") ||  ($_[3] ne "3") ||  ($_[4] ne "no_use") ||  ($_[5] ne "0") ||  ($_[6] ne "no_use") ||  ($_[7] ne "-16") ||  ($_[8] ne "no_use") ||  ($_[9] ne "3")){
          
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
          


          
          # }
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");  
    # }                   
                       
                       
# print (HTMLFILE "</table>\n");


######################## cell bar
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CELL-ACS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_BARRED</th><th align=center>INTRA_FREQ_CELL_RESELECT</th><th align=center>BARRING_CTR_USAGE</th><th align=center>HANDOVER_BARRING_STATUS</th></tr>\n");  

foreach $_(@cell_bar){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "notBarred"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }
    if ($_[1] ne "notBarred"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    }
	if ($_[2] eq "NotAllowed"){
	print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	}
    if ($_[2] ne "NotAllowed"){
	print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[2]</td>\n");	
	}
	if ($_[3] eq "cpuStatusCtrl"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if ($_[3] ne "cpuStatusCtrl"){
    print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[3]</td>\n");	
	}
	if ($_[4] eq "barringOff"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n"); 	
	}
	if ($_[4] ne "barringOff"){
    print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[4]</td>\n"); 	
	}
      
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");

######################## cell bar



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-TIMER-INF</b></td></tr>\n");

if ($pkg =~ m/^3/) {
if ($timer_data eq "1000,1500,5000,2000,2000,100,5000,300,5000,5000,Thrice,5,10000,5000,5000,3000,2000,5000,2000,5000,5,5000,Thrice,5,2000,5000,10000,2000,100,2000,40,2000,2000,2000,2000,5000,5000,5000,5000,2000,5000,100,5000,5000,1000,1000,1280,180,2,9") {
      
      print (HTMLFILE "<td align=center>$timer_data</td>\n");
      
      
      }
if ($timer_data ne "1000,1500,5000,2000,2000,100,5000,300,5000,5000,Thrice,5,10000,5000,5000,3000,2000,5000,2000,5000,5,5000,Thrice,5,2000,5000,10000,2000,100,2000,40,2000,2000,2000,2000,5000,5000,5000,5000,2000,5000,100,5000,5000,1000,1000,1280,180,2,9") {
      
      print (HTMLFILE "<td bgcolor=#FF0000 align=center>$timer_data</td>\n");
      
      
      }
	              }
if ($pkg =~ m/^4/) {
if ($timer_data eq "3000,3000,5000,2000,2000,100,5000,300,5000,5000,Three,5,10000,5000,3000,2000,5000,2000,5000,5,5000,Three,5,2000,5000,10000,Three,2000,100,2000,40,2000,2000,2000,2000,5000,5000,5000,5000,2000,5000,100,5000,5000,1000,1000,3000,3000,1280,180,2,9,3,3,1000,10000") {
      
      print (HTMLFILE "<td align=center>$timer_data</td>\n");
      
      
      }
if ($timer_data ne "3000,3000,5000,2000,2000,100,5000,300,5000,5000,Three,5,10000,5000,3000,2000,5000,2000,5000,5,5000,Three,5,2000,5000,10000,Three,2000,100,2000,40,2000,2000,2000,2000,5000,5000,5000,5000,2000,5000,100,5000,5000,1000,1000,3000,3000,1280,180,2,9,3,3,1000,10000") {
      
      print (HTMLFILE "<td bgcolor=#FF0000 align=center>$timer_data</td>\n");
      
      
      }
	              }
if ($pkg =~ m/^5/) {
if ($timer_data eq "3000,3000,5000,2000,2000,100,5000,300,5000,5000,Three,5,10000,5000,3000,2000,5000,2000,5000,5,5000,Three,5,2000,5000,10000,Three,2000,100,2000,40,2000,2000,2000,2000,5000,5000,5000,5000,2000,5000,100,5000,5000,1000,1000,3000,3000,1280,180,2,9,3,3,1000,10000") {
      
      print (HTMLFILE "<td align=center>$timer_data</td>\n");
      
      
      }
if ($timer_data ne "3000,3000,5000,2000,2000,100,5000,300,5000,5000,Three,5,10000,5000,3000,2000,5000,2000,5000,5,5000,Three,5,2000,5000,10000,Three,2000,100,2000,40,2000,2000,2000,2000,5000,5000,5000,5000,2000,5000,100,5000,5000,1000,1000,3000,3000,1280,180,2,9,3,3,1000,10000") {
      
      print (HTMLFILE "<td bgcolor=#FF0000 align=center>$timer_data</td>\n");
      
      
      }
	              }
	print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
              
                       
                       
print (HTMLFILE "</table>\n");




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-SOC-FW</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>BD_ID</th><th align=center>SOC_ID</th><th align=center>LOC_TYPE</th><th align=center>ID</th><th align=center>TYPE</th><th align=center>NAME</th><th align=center>VERSION</th><th align=center>REL_VER</th></tr>\n");  

foreach $_(@socfw){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
if ($pkg =~ m/^3/) {
    if ($_[6] eq "5.0.0"){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
          

          
          

          
          } 
   if ($_[6] ne "5.0.0"){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          


          
          }
		         }
if ($pkg =~ m/^4/) {
    if ($_[6] eq "5.5.0"){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
          

          
          

          
          } 
   if ($_[6] ne "5.5.0"){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          


          
          }
		         }				 
if ($pkg =~ m/^5/) {
    if (($_[4] eq "BOOTER") && ($_[6] eq "5.5.0")){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                  } 
   if (($_[4] eq "BOOTER") && ($_[6] ne "5.5.0")){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                  }
    if ((($_[4] eq "KERNEL") || ($_[4] eq "RFS")) && ($_[6] eq "6.0.0")){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                        } 
    if ((($_[4] eq "KERNEL") || ($_[4] eq "RFS")) && ($_[6] ne "6.0.0")){
          print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[7]</td>\n");
                                                                        }
				 }	
	
	print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-SOC-SW</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>BD_ID</th><th align=center>SOC_ID</th><th align=center>ID</th><th align=center>NAME</th><th align=center>VERSION</th><th align=center>REL_VER</th></tr>\n");  

foreach $_(@socsw){

@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
if ($pkg =~ m/^3/) {      
    if ($_[4] eq "3.5.2"){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");

          } 
    if ($_[4] ne "3.5.2"){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
                  
          }
		          }
if ($pkg =~ m/^4/) {      
    if ($_[4] eq "4.0.2"){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");

          } 
    if ($_[4] ne "4.0.2"){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
                  
          }
		          }
if ($pkg =~ m/^5/) {      
    if ($_[4] eq "5.0.0"){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
                         } 
    if ($_[4] ne "5.0.0"){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
                         }
		           }				  
    
	print (HTMLFILE "<td align=center>$_[5]</td>\n");      
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-PRC-FW</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>BD_ID</th><th align=center>SOC_ID</th><th align=center>LOC_TYPE</th><th align=center>ID</th><th align=center>TYPE</th><th align=center>NAME</th><th align=center>VERSION</th><th align=center>PAT_VER</th></tr>\n");  

foreach $_(@prcfw){
my ($bool_find);
$bool_find = "false";
@_ = split (/,/,$_);

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
if ($pkg =~ m/^3/) {  	#start if $pkg match ^3
    if (($_[0] eq "UMP") &&  (($_[4] eq "BOOTER") && ($_[6] eq "4.1.0") && ($_[7] eq "01")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_A") && ($_[6] eq "5.0.0") && ($_[7] eq "04")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_B") && ($_[6] eq "5.0.0") && ($_[7] eq "04")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }           
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_RAW") && ($_[6] eq "3.5.1") && ($_[7] eq "05")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_A") && ($_[6] eq "5.0.0") && ($_[7] eq "21")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_B") && ($_[6] eq "5.0.0") && ($_[7] eq "21")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "POST") && ($_[6] eq "3.5.1") && ($_[7] eq "03")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }                                                   
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "EPLD") && ($_[6] eq "0.1.1") && ($_[7] eq "00")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }  
          
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "BOOTER") && ( ($_[6] ne "4.1.0") || ($_[7] ne "01"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_A") && ( ($_[6] ne "5.0.0") || ($_[7] ne "04"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_B") && ( ($_[6] ne "5.0.0") || ($_[7] ne "04"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }           
          
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_RAW") && ( ($_[6] ne "3.5.1") || ($_[7] ne "05"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_A") && (  ($_[6] ne "5.0.0") || ($_[7] ne "21"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_B") && ( ($_[6] ne "5.0.0") || ($_[7] ne "21"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "POST") && ( ($_[6] ne "3.5.1") || ($_[7] ne "03"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }                                                   
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "EPLD") && ( ($_[6] ne "0.1.1") || ($_[7] ne "00"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }  
          





    if (($_[0] eq "ECP") &&  (($_[4] eq "BOOTER") && ($_[6] eq "5.0.0") && ($_[7] eq "08")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }      
    
        
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_A") && ($_[6] eq "5.0.0") && ($_[7] eq "04")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_B") && ($_[6] eq "5.0.0") && ($_[7] eq "04")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }           
          
          
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_RAW") && ($_[6] eq "3.5.1") && ($_[7] eq "05")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_A") && ($_[6] eq "5.0.0") && ($_[7] eq "22")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_B") && ($_[6] eq "5.0.0") && ($_[7] eq "22")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "POST") && ($_[6] eq "2.5.7") && ($_[7] eq "04")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }                                                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "IF-FPGA") && ($_[6] eq "1.0.1") && ($_[7] eq "12")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "EPLD") && (($_[6] eq "0.1.2") || ($_[6] eq "0.1.4")) && ($_[7] eq "00")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }  
        
                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "BOOTER") && (($_[6] ne "5.0.0") || ($_[7] ne "08"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          }   


    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_A") && ( ($_[6] ne "5.0.0") || ($_[7] ne "04"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_B") && ( ($_[6] ne "5.0.0") || ($_[7] ne "04"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }           
          
          
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_RAW") && ( ($_[6] ne "3.5.1") || ($_[7] ne "05"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_A") && ( ($_[6] ne "5.0.0") || ($_[7] ne "22"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_B") && ( ($_[6] ne "5.0.0") || ($_[7] ne "22"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "POST") && ( ($_[6] ne "2.5.7") || ($_[7] ne "04"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }                                                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "IF-FPGA") && ( ($_[6] ne "1.0.1") || ($_[7] ne "12"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "EPLD") && ((($_[6] ne "0.1.2") && ($_[6] ne "0.1.4")) || ($_[7] ne "00"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }  

                   }  	#end if $pkg match ^3
if ($pkg =~ m/^4/) {  	#start if $pkg match ^4    

    if (($_[0] eq "UMP") &&  (($_[4] eq "BOOTER") && ($_[6] eq "5.5.0") && ($_[7] eq "02")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_A") && ($_[6] eq "5.5.0") && ($_[7] eq "08")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_B") && ($_[6] eq "5.5.0") && ($_[7] eq "08")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }           
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_RAW") && ($_[6] eq "3.5.1") && ($_[7] eq "05")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_A") && ($_[6] eq "5.5.0") && ($_[7] eq "18")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_B") && ($_[6] eq "5.5.0") && ($_[7] eq "18")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "POST") && ($_[6] eq "3.5.1") && ($_[7] eq "04")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }                                                   
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "EPLD") && ($_[6] eq "0.1.1") && ($_[7] eq "00")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }  
          
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "BOOTER") && ( ($_[6] ne "5.5.0") || ($_[7] ne "02"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_A") && ( ($_[6] ne "5.5.0") || ($_[7] ne "08"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "KERNEL_B") && ( ($_[6] ne "5.5.0") || ($_[7] ne "08"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }           
          
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_RAW") && ( ($_[6] ne "3.5.1") || ($_[7] ne "05"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_A") && (  ($_[6] ne "5.5.0") || ($_[7] ne "18"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "RFS_B") && ( ($_[6] ne "5.5.0") || ($_[7] ne "18"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "POST") && ( ($_[6] ne "3.5.1") || ($_[7] ne "04"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }                                                   
          
    if (($_[0] eq "UMP") &&  (($_[4] eq "EPLD") && ( ($_[6] ne "0.1.1") || ($_[7] ne "00"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }  
          





    if (($_[0] eq "ECP") &&  (($_[4] eq "BOOTER") && ($_[6] eq "5.5.0") && ($_[7] eq "10")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }      
    
        
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_A") && ($_[6] eq "5.5.0") && ($_[7] eq "08")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_B") && ($_[6] eq "5.5.0") && ($_[7] eq "08")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }           
          
          
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_RAW") && ($_[6] eq "3.5.1") && ($_[7] eq "05")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_A") && ($_[6] eq "5.5.0") && ($_[7] eq "18")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_B") && ($_[6] eq "5.5.0") && ($_[7] eq "18")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "POST") && ($_[6] eq "2.5.7") && ($_[7] eq "04")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }                                                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "IF-FPGA") && ($_[6] eq "3.0.0") && ($_[7] eq "02")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "EPLD") && (($_[6] eq "0.1.2") || ($_[6] eq "0.1.4")) && ($_[7] eq "00")) ){
          
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");

          }  
        
                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "BOOTER") && (($_[6] ne "5.5.0") || ($_[7] ne "10"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
          }   


    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_A") && ( ($_[6] ne "5.5.0") || ($_[7] ne "08"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_B") && ( ($_[6] ne "5.5.0") || ($_[7] ne "08"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }           
          
          
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_RAW") && ( ($_[6] ne "3.5.1") || ($_[7] ne "05"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_A") && ( ($_[6] ne "5.5.0") || ($_[7] ne "18"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_B") && ( ($_[6] ne "5.5.0") || ($_[7] ne "18"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "POST") && ( ($_[6] ne "2.5.7") || ($_[7] ne "04"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }                                                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "IF-FPGA") && ( ($_[6] ne "3.0.0") || ($_[7] ne "02"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "EPLD") && ((($_[6] ne "0.1.2") && ($_[6] ne "0.1.4")) || ($_[7] ne "00"))) ){
          
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");

          }  


                   }  	#end if $pkg match ^4        
if ($pkg =~ m/^5/) {  	#start if $pkg match ^5   

    if (($_[5] eq "booter.enb_lma.0") && ($_[6] eq "5.5.0") && ($_[7] eq "08")){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                } 
    if (($_[5] eq "kernel.enb_lma.0") && ($_[6] eq "6.0.0") && ($_[7] eq "07")){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                } 
    if (($_[5] eq "rfs_raw.enb_lma.0") && ($_[6] eq "3.5.1") && ($_[7] eq "05")){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                } 
    if (($_[5] eq "rfs.enb_lma.0") && ($_[6] eq "6.0.0") && ($_[7] eq "16")){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                            } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "POST") && ($_[6] eq "3.5.1") && ($_[7] eq "06")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                           }                                                   
    if (($_[0] eq "UMP") &&  (($_[4] eq "EPLD") && ($_[6] eq "0.1.1") && ($_[7] eq "00")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                           }  
 
 
          
    if (($_[5] eq "booter.enb_lma.0") && (($_[6] ne "5.5.0") || ($_[7] ne "08"))){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                 } 
    if (($_[5] eq "kernel.enb_lma.0") && (($_[6] ne "6.0.0") || ($_[7] ne "07"))){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                 } 
    if (($_[5] eq "rfs_raw.enb_lma.0") && (($_[6] ne "3.5.1") || ($_[7] ne "05"))){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                  } 
    if (($_[5] eq "rfs.enb_lma.0") && (($_[6] ne "6.0.0") || ($_[7] ne "16"))){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                              } 
    if (($_[0] eq "UMP") &&  (($_[4] eq "POST") && ( ($_[6] ne "3.5.1") || ($_[7] ne "06"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                              }                                                   
    if (($_[0] eq "UMP") &&  (($_[4] eq "EPLD") && ( ($_[6] ne "0.1.1") || ($_[7] ne "00"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                              }  
          


    if (($_[0] eq "ECP") &&  (($_[4] eq "BOOTER") && ($_[6] eq "5.5.0") && ($_[7] eq "09")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                             }      
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_A") && ($_[6] eq "6.0.0") && ($_[7] eq "07")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                               } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_B") && ($_[6] eq "6.0.0") && ($_[7] eq "07")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                               }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_RAW") && ($_[6] eq "3.5.1") && ($_[7] eq "05")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                              } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_A") && ($_[6] eq "6.0.0") && ($_[7] eq "16")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                            } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_B") && ($_[6] eq "6.0.0") && ($_[7] eq "16")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                            } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "POST") && ($_[6] eq "5.5.0") && ($_[7] eq "01")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                           }                                                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "IF-FPGA") && ($_[6] eq "3.0.0") && ($_[7] eq "11")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                              }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "EPLD") && (($_[6] eq "0.1.2") || ($_[6] eq "0.1.4")) && ($_[7] eq "00")) ){
          print (HTMLFILE "<td align=center>$_[4]</td>\n");
          print (HTMLFILE "<td align=center>$_[5]</td>\n");
          print (HTMLFILE "<td align=center>$_[6]</td>\n");
          print (HTMLFILE "<td align=center>$_[7]</td>\n");
                                                                                                                   }  
        
 

 
    if (($_[0] eq "ECP") &&  (($_[4] eq "BOOTER") && (($_[6] ne "5.5.0") || ($_[7] ne "09"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                               }   
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_A") && ( ($_[6] ne "6.0.0") || ($_[7] ne "07"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                                  } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "KERNEL_B") && ( ($_[6] ne "6.0.0") || ($_[7] ne "07"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                                  }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_RAW") && ( ($_[6] ne "3.5.1") || ($_[7] ne "05"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                                 } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_A") && ( ($_[6] ne "6.0.0") || ($_[7] ne "16"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                               } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "RFS_B") && ( ($_[6] ne "6.0.0") || ($_[7] ne "16"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                               } 
    if (($_[0] eq "ECP") &&  (($_[4] eq "POST") && ( ($_[6] ne "5.5.0") || ($_[7] ne "01"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                               }                                                   
    if (($_[0] eq "ECP") &&  (($_[4] eq "IF-FPGA") && ( ($_[6] ne "3.0.0") || ($_[7] ne "11"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                                  }           
    if (($_[0] eq "ECP") &&  (($_[4] eq "EPLD") && ((($_[6] ne "0.1.2") && ($_[6] ne "0.1.4")) || ($_[7] ne "00"))) ){
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
          print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
                                                                                                  }  


                   }  	#end if $pkg match ^5          
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");  
    }                   
                       
                       
print (HTMLFILE "</table>\n");



############################################## 
                                                
                                                                             



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>ANR-SCHED</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>ANR_STATE</th><th align=center>DAY</th><th align=center>HOUR</th><th align=center>MINUTE</th><th align=center>DURATION</th></tr>\n");       

foreach $_(@anrsched){
          
@_ = split (/,/,$_); 

if ($_[0] <=11){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "Inactive"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    }
    if ($_[1] ne "Inactive"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    $anrgp = "true"; 
    }    
    if ($_[2] eq "Sunday"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");  
    }
    if ($_[2] ne "Sunday"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");  
    $anrgp = "true"; 
    }       
    if ($_[3] eq "0"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");  
    }
    if ($_[3] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    $anrgp = "true"; 
    }   
    if ($_[4] eq "0"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");  
    }
    if ($_[4] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");  
    $anrgp = "true"; 
    }    
    if ($_[5] eq "1"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");  
    }
    if ($_[5] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    $anrgp = "true"; 
    }    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n"); 
    }

                       }


print (HTMLFILE "</table>\n"); 



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>BCCH-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>MODIFICATION_PERIOD_COEFF</th></tr>\n");       

foreach $_(@bcchconf){
          
@_ = split (/,/,$_); 


if ($_[0] <=11){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "n4"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    }
    if ($_[1] ne "n4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    $bcchgp = "true"; 
    }    
    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n"); 
    }
                               
                       }


print (HTMLFILE "</table>\n"); 



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>BHBW-QCI</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>QCI</th><th align=center>BH_BW_CAC_DL_THRESH_FOR_NORMAL</th><th align=center>BH_BW_CAC_DL_THRESH_FOR_EMER_HO</th><th align=center>BH_BW_CAC_UL_THRESH_FOR_NORMAL</th><th align=center>BH_BW_CAC_UL_THRESH_FOR_EMER_HO</th><th align=center>OVER_BOOKING_RATIO</th></tr>\n");       

foreach $_(@bhbw){
          
@_ = split (/,/,$_); 


if (($_[0] eq "8")||($_[0] eq "9")){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if (($_[1] eq "0") || ($_[1] eq "0.0")) {
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    }
 
	else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    $bhbwgp = "true"; 
    }    
    if (($_[2] eq "0") || ($_[2] eq "0.0")) {
    print (HTMLFILE "<td align=center>$_[2]</td>\n");  
    }
	
	else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n"); 
    $bhbwgp = "true"; 
    }  
    if (($_[3] eq "0") || ($_[3] eq "0.0")) {
    print (HTMLFILE "<td align=center>$_[3]</td>\n");  
    }

	else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    $bhbwgp = "true"; 
    } 
    if (($_[4] eq "0") || ($_[4] eq "0.0")) {
    print (HTMLFILE "<td align=center>$_[4]</td>\n");  
    }

	else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    $bhbwgp = "true"; 
    }       
     if ($_[5] eq "1.0"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");  
    }
    if ($_[5] ne "1.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    $bhbwgp = "true"; 
    }             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n"); 
    }
                               
                       }


print (HTMLFILE "</table>\n"); 




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>C1XRTT-BCLS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>BC_INDEX</th><th align=center>STATUS</th><th align=center>BAND_CLASS</th><th align=center>CELL_RESELECTION_PRIORITY</th><th align=center>THRESH_XHIGH</th><th align=center>THRESH_XLOW</th></tr>\n");       

foreach $_(@bcls){
          
@_ = split (/,/,$_); 


if ($_[0] <=31){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "N_EQUIP"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    }
    if ($_[1] ne "N_EQUIP"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    $bclsgp = "true"; 
    }    
    if ($_[2] eq "bc0"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");  
    }
    if ($_[2] ne "bc0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n"); 
    $bclsgp = "true"; 
    }   
    if ($_[3] eq "0"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");  
    }
    if ($_[3] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    $bclsgp = "true"; 
    }      
    if ($_[4] eq "16"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");  
    }
    if ($_[4] ne "16"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
    $bclsgp = "true"; 
    }       
    if ($_[5] eq "16"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");  
    }
    if ($_[5] ne "16"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    $bclsgp = "true"; 
    }      
    
        
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n"); 
    }
                               
                       }


print (HTMLFILE "</table>\n"); 

if ($pkg =~ m/^3/) {  	#start if $pkg match ^3
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=27 bgcolor=#EEEEEE><b>C1XRTT-FREQ</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CARRIER_INDEX</th><th align=center>STATUS</th><th align=center>BAND_CLASS</th><th align=center>ARFCN</th><th align=center>OFFSET_FREQ</th><th align=center>MCC0</th><th align=center>MNC0</th><th align=center>PREFERENCE0</th><th align=center>MCC1</th><th align=center>MNC1</th><th align=center>PREFERENCE1</th><th align=center>MCC2</th><th align=center>MNC2</th><th align=center>PREFERENCE2</th><th align=center>MCC3</th><th align=center>MNC3</th><th align=center>PREFERENCE3</th><th align=center>MCC4</th><th align=center>MNC4</th><th align=center>PREFERENCE4</th><th align=center>MCC5</th><th align=center>MNC5</th><th align=center>PREFERENCE5</th><th align=center>ANR_UE_SEARCH_RATE</th><th align=center>HANDOVER_TYPE</th><th align=center>MOBILITY_PREFERENCE</th></tr>\n");			      


foreach $_(@lsmFREQ){

@_ = split (/,/,$_);


#if ((($_[1] eq "0") || ($_[1] eq "1")) && ($_[0] <= "11")) {
if ($_[2] eq "EQUIP") {

print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");
print (HTMLFILE "<td align=center>$_[3]</td>\n");
print (HTMLFILE "<td align=center>$_[4]</td>\n");
if ($_[5] eq "0"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}	
if ($_[5] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$freqgp = "true";	
}


if ($_[6] eq "310"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}	
if ($_[6] ne "310"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$freqgp = "true";	
}

if ($_[7] eq "120"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}	
if ($_[7] ne "120"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$freqgp = "true";	
}


if ($_[8] eq "preferred_prefer"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}	
if ($_[8] ne "preferred_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$freqgp = "true";	
}


if ($_[9] eq "FFF"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}	
if ($_[9] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$freqgp = "true";	
}

if ($_[10] eq "FFF"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}	
if ($_[10] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$freqgp = "true";	
}


if ($_[11] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
$freqgp = "true";	
}	
if ($_[11] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$freqgp = "true";	
}


if ($_[12] eq "FFF"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
	
}	
if ($_[12] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$freqgp = "true";	
}

if ($_[13] eq "FFF"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}	
if ($_[13] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$freqgp = "true";	
}


if ($_[14] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[14]</td>\n");	
	
}	
if ($_[14] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");	
$freqgp = "true";	
}


if ($_[15] eq "FFF"){
print (HTMLFILE "<td align=center>$_[15]</td>\n");	
	
}	
if ($_[15] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");	
$freqgp = "true";	
}

if ($_[16] eq "FFF"){
print (HTMLFILE "<td align=center>$_[16]</td>\n");	
	
}	
if ($_[16] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");	
$freqgp = "true";	
}


if ($_[17] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[17]</td>\n");	
	
}	
if ($_[17] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");	
$freqgp = "true";	
}


if ($_[18] eq "FFF"){
print (HTMLFILE "<td align=center>$_[18]</td>\n");	
	
}	
if ($_[18] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");	
$freqgp = "true";	
}

if ($_[19] eq "FFF"){
print (HTMLFILE "<td align=center>$_[19]</td>\n");	
	
}	
if ($_[19] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");	
$freqgp = "true";	
}


if ($_[20] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[20]</td>\n");	
	
}	
if ($_[20] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");	
$freqgp = "true";	
}

if ($_[21] eq "FFF"){
print (HTMLFILE "<td align=center>$_[21]</td>\n");	
	
}	
if ($_[21] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");	
$freqgp = "true";	
}

if ($_[22] eq "FFF"){
print (HTMLFILE "<td align=center>$_[22]</td>\n");	
	
}	
if ($_[22] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");	
$freqgp = "true";	
}


if ($_[23] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[23]</td>\n");	
	
}	
if ($_[23] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");	
$freqgp = "true";	
}


if ($_[24] eq "100.0"){
print (HTMLFILE "<td align=center>$_[24]</td>\n");	
	
}	
if ($_[24] ne "100.0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");	
$freqgp = "true";	
}

if ($_[25] eq "EventB2"){
print (HTMLFILE "<td align=center>$_[25]</td>\n");	
	
}	
if ($_[25] ne "EventB2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");	
$freqgp = "true";	
}

if ($_[26] eq "ci_None"){
print (HTMLFILE "<td align=center>$_[26]</td>\n");	
	
}	
if ($_[26] ne "ci_None"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");	
$freqgp = "true";	
}


print (HTMLFILE "</tr>");
}		                        
}

                   }  	#end if $pkg match ^3
				   
				   
if ($pkg =~ m/^4/) {  	#start if $pkg match ^4

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=33 bgcolor=#EEEEEE><b>C1XRTT-FREQ</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CARRIER_INDEX</th><th align=center>STATUS</th><th align=center>BAND_CLASS</th><th align=center>ARFCN</th><th align=center>OFFSET_FREQ</th><th align=center>MCC0</th><th align=center>MNC0</th><th align=center>PREFERENCE0</th><th align=center>VOICE_SUPPORT0</th><th align=center>MCC1</th><th align=center>MNC1</th><th align=center>PREFERENCE1</th><th align=center>VOICE_SUPPORT1</th><th align=center>MCC2</th><th align=center>MNC2</th><th align=center>PREFERENCE2</th><th align=center>VOICE_SUPPORT2</th><th align=center>MCC3</th><th align=center>MNC3</th><th align=center>PREFERENCE3</th><th align=center>VOICE_SUPPORT3</th><th align=center>MCC4</th><th align=center>MNC4</th><th align=center>PREFERENCE4</th><th align=center>VOICE_SUPPORT4</th><th align=center>MCC5</th><th align=center>MNC5</th><th align=center>PREFERENCE5</th><th align=center>VOICE_SUPPORT5</th><th align=center>ANR_UE_SEARCH_RATE</th><th align=center>HANDOVER_TYPE</th><th align=center>MOBILITY_PREFERENCE</th></tr>\n");			      


foreach $_(@lsmFREQ){

@_ = split (/,/,$_);


#if ((($_[1] eq "0") || ($_[1] eq "1")) && ($_[0] <= "11")) {
if ($_[2] eq "EQUIP") {

print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");
print (HTMLFILE "<td align=center>$_[3]</td>\n");
print (HTMLFILE "<td align=center>$_[4]</td>\n");
if ($_[5] eq "0"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}	
if ($_[5] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$freqgp = "true";	
}


if ($_[6] eq "310"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}	
if ($_[6] ne "310"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$freqgp = "true";	
}

if ($_[7] eq "120"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}	
if ($_[7] ne "120"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$freqgp = "true";	
}


if ($_[8] eq "preferred_prefer"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}	
if ($_[8] ne "preferred_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$freqgp = "true";	
}


if ($_[9] eq "True"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}	
if ($_[9] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$freqgp = "true";	
}

if ($_[10] eq "FFF"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}	
if ($_[10] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$freqgp = "true";	
}

if ($_[11] eq "FFF"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}	
if ($_[11] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$freqgp = "true";	
}


if ($_[12] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
$freqgp = "true";	
}	
if ($_[12] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$freqgp = "true";	
}


if ($_[13] eq "True"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}	
if ($_[13] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$freqgp = "true";	
}


if ($_[14] eq "FFF"){
print (HTMLFILE "<td align=center>$_[14]</td>\n");	
	
}	
if ($_[14] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");	
$freqgp = "true";	
}

if ($_[15] eq "FFF"){
print (HTMLFILE "<td align=center>$_[15]</td>\n");	
	
}	
if ($_[15] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");	
$freqgp = "true";	
}


if ($_[16] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[16]</td>\n");	
	
}	
if ($_[16] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");	
$freqgp = "true";	
}

if ($_[17] eq "True"){
print (HTMLFILE "<td align=center>$_[17]</td>\n");	
	
}	
if ($_[17] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");	
$freqgp = "true";	
}


if ($_[18] eq "FFF"){
print (HTMLFILE "<td align=center>$_[18]</td>\n");	
	
}	
if ($_[18] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");	
$freqgp = "true";	
}

if ($_[19] eq "FFF"){
print (HTMLFILE "<td align=center>$_[19]</td>\n");	
	
}	
if ($_[19] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");	
$freqgp = "true";	
}


if ($_[20] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[20]</td>\n");	
	
}	
if ($_[20] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");	
$freqgp = "true";	
}

if ($_[21] eq "True"){
print (HTMLFILE "<td align=center>$_[21]</td>\n");	
	
}	
if ($_[21] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");	
$freqgp = "true";	
}

if ($_[22] eq "FFF"){
print (HTMLFILE "<td align=center>$_[22]</td>\n");	
	
}	
if ($_[22] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");	
$freqgp = "true";	
}

if ($_[23] eq "FFF"){
print (HTMLFILE "<td align=center>$_[23]</td>\n");	
	
}	
if ($_[23] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");	
$freqgp = "true";	
}


if ($_[24] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[24]</td>\n");	
	
}	
if ($_[24] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");	
$freqgp = "true";	
}

if ($_[25] eq "True"){
print (HTMLFILE "<td align=center>$_[25]</td>\n");	
	
}	
if ($_[25] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");	
$freqgp = "true";	
}

if ($_[26] eq "FFF"){
print (HTMLFILE "<td align=center>$_[26]</td>\n");	
	
}	
if ($_[26] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");	
$freqgp = "true";	
}

if ($_[27] eq "FFF"){
print (HTMLFILE "<td align=center>$_[27]</td>\n");	
	
}	
if ($_[27] ne "FFF"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");	
$freqgp = "true";	
}


if ($_[28] eq "not_allowed_prefer"){
print (HTMLFILE "<td align=center>$_[28]</td>\n");	
	
}	
if ($_[28] ne "not_allowed_prefer"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");	
$freqgp = "true";	
}


if ($_[29] eq "True"){
print (HTMLFILE "<td align=center>$_[29]</td>\n");	
	
}	
if ($_[29] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");	
$freqgp = "true";	
}

if ($_[30] eq "100.0"){
print (HTMLFILE "<td align=center>$_[30]</td>\n");	
	
}	
if ($_[30] ne "100.0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");	
$freqgp = "true";	
}

if ($_[31] eq "EventB2"){
print (HTMLFILE "<td align=center>$_[31]</td>\n");	
	
}	
if ($_[31] ne "EventB2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");	
$freqgp = "true";	
}

if ($_[32] eq "None"){
print (HTMLFILE "<td align=center>$_[32]</td>\n");	
	
}	
if ($_[32] ne "None"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");	
$freqgp = "true";	
}


print (HTMLFILE "</tr>");
}		                        
}


                   }  	#end if $pkg match ^4
print (HTMLFILE "</table>\n");		   
                              		  
     




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>C1XRTT-OVL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>T_RESELECTION_1XRTT</th><th align=center>T_RESELECTION_SF_USAGE_1XRTT</th><th align=center>T_RESELECTION_SF_MEDIUM_1XRTT</th><th align=center>T_RESELECTION_SF_HIGH_1XRTT</th><th align=center>USAGE_LONGCODESTATE_1XRTT</th></tr>\n");			      


foreach $_(@lsmOVL){

@_ = split (/,/,$_);


if ($_[0] <= "11") {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	

if ($_[1] eq "5"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "5"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$ovlgp = "true";	
}
if ($_[2] eq "no_use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$ovlgp = "true";	
}
if ($_[3] eq "oDot25"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "oDot25"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$ovlgp = "true";	
}


if ($_[4] eq "oDot25"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "oDot25"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$ovlgp = "true";	
}

if ($_[5] eq "use"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$ovlgp = "true";	
}
print (HTMLFILE "</tr>");
}		                        
}

print (HTMLFILE "</table>\n");	




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>C1XRTT-PRD</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>ACTIVE_STATE</th><th align=center>MAX_REPORT_CELL</th><th align=center>REPORT_INTERVAL</th><th align=center>REPORT_AMOUNT</th></tr>\n");			      


foreach $_(@lsmPRD){

@_ = split (/,/,$_);


if (($_[0] <= "11") && ($_[1] eq "StrongestCells")) {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "Active"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "Active"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$prdgp = "true";	
}
if ($_[3] eq "1"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$prdgp = "true";	
}
if ($_[4] eq "240ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$prdgp = "true";	
}

if ($_[5] eq "1"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$prdgp = "true";	
}

print (HTMLFILE "</tr>");
}		                        
}

print (HTMLFILE "</table>\n");	
	 
	 
	 
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=16 bgcolor=#EEEEEE><b>C1XRTT-PREG</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CSFB_PRE_REG_USAGE</th><th align=center>SID</th><th align=center>NID</th><th align=center>MULTIPLE_SID</th><th align=center>MULTIPLE_NID</th><th align=center>HOME_REG</th><th align=center>FOREIGN_SID_REG</th><th align=center>FOREIGN_NID_REG</th><th align=center>PARAMETER_REG</th><th align=center>POWER_UP_REG</th><th align=center>REGISTRATION_PERIOD</th><th align=center>REGISTRATION_ZONE</th><th align=center>TOTAL_ZONE</th><th align=center>ZONE_TIMER</th><th align=center>POWER_DOWN_REG_IND</th></tr>\n");			      


foreach $_(@lsmPREG){

@_ = split (/,/,$_);


if ($_[0] <= "11")  {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");
print (HTMLFILE "<td align=center>$_[3]</td>\n");

if ($_[4] eq "True"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$preggp = "true";	
}

if ($_[5] eq "True"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$preggp = "true";	
}

if ($_[6] eq "True"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$preggp = "true";	
}

if ($_[7] eq "True"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$preggp = "true";	
}

if ($_[8] eq "True"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$preggp = "true";	
}

if ($_[9] eq "False"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$preggp = "true";	
}

if ($_[10] eq "True"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$preggp = "true";	
}

if ($_[11] eq "58"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "58"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$preggp = "true";	
}
print (HTMLFILE "<td align=center>$_[12]</td>\n");

if ($pkg =~ m/^3/) {  
if ($_[13] eq "2"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}		
if ($_[13] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$preggp = "true";	
}
                   }
				   
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[13] eq "7"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}		
if ($_[13] ne "7"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$preggp = "true";	
}
                   }				   

if ($_[14] eq "min1"){
print (HTMLFILE "<td align=center>$_[14]</td>\n");	
	
}		
if ($_[14] ne "min1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");	
$preggp = "true";	
}


if ($_[15] eq "True"){
print (HTMLFILE "<td align=center>$_[15]</td>\n");	
	
}		
if ($_[15] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");	
$preggp = "true";	
}

print (HTMLFILE "</tr>");
}		                        
}

print (HTMLFILE "</table>\n");	
	 
	 
	                         		  






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=69 bgcolor=#EEEEEE><b>C1XRTT-MOBIL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>S_ID</th><th align=center>N_ID</th><th align=center>MULT_SIDS</th><th align=center>MULT_NIDS</th><th align=center>REG_ZONE</th><th align=center>TOTAL_ZONES</th><th align=center>ZONE_TIMER</th><th align=center>PACKET_ZONE_ID</th><th align=center>P_ZIDHYST_PARAM_INCLUDED</th><th align=center>P_ZHYST_ENABLED</th><th align=center>P_ZHYST_INFO_INCL</th><th align=center>P_ZHYST_LIST_LEN</th><th align=center>P_ZHYST_ACT_TIMER</th><th align=center>P_ZHYST_TIMER_MUL</th><th align=center>PZ_HYST_TIMER_EXP</th><th align=center>P_REV</th><th align=center>MIN_PREV</th><th align=center>NEG_SLOT_CYCLE_INDEX_SUP</th><th align=center>ENCRYPT_MODE</th><th align=center>ENC_SUPPORTED</th><th align=center>SIG_ENCRYPT_SUP</th><th align=center>MSG_INTEGRITY_SUP</th><th align=center>SIG_INTEGRITY_SUPINCL</th><th align=center>SIG_INTEGRITY_SUP</th><th align=center>AUTH</th><th align=center>MAX_NUM_ALT_SO</th><th align=center>USE_SYNC_ID</th><th align=center>MS_INIT_POS_LOC_SUP_IND</th><th align=center>MOB_QOS</th><th align=center>BAND_CLASS_INFO_REQ</th><th align=center>BAND_CLASS</th><th align=center>BYPASS_REG_IND</th><th align=center>ALT_BAND_CLASS</th><th align=center>MAX_ADD_SERV_INSTANCE</th><th align=center>HOME_REG</th><th align=center>FOR_SIDREG</th><th align=center>FOR_NIDREG</th><th align=center>POWER_UP_REG</th><th align=center>POWER_DOWN_REG</th><th align=center>PARAMETER_REG</th><th align=center>REG_PRD</th><th align=center>REG_DIST</th><th align=center>PREF_MSIDTYPE</th><th align=center>EXT_PREF_MSIDTYPE</th><th align=center>MEID_REQD</th><th align=center>MCC</th><th align=center>IMSI1112</th><th align=center>IMSI_TSUPPORTED</th><th align=center>RECONNECT_MSG_IND</th><th align=center>RER_MODE_SUPPORTED</th><th align=center>TKZ_MODE_SUPPORTED</th><th align=center>TKZ_ID</th><th align=center>PILOT_REPORT</th><th align=center>SDB_SUPPORTED</th><th align=center>AUTO_FCSOALLOWED</th><th align=center>SDB_IN_RCNMIND</th><th align=center>FPC_FCH_INCLUDED</th><th align=center>FPC_FCH_INIT_SETPT_RC3</th><th align=center>FPC_FCH_INIT_SETPT_RC4</th><th align=center>FPC_FCH_INIT_SETPT_RC5</th><th align=center>FPC_FCH_INIT_SETPT_RC11</th><th align=center>FPC_FCH_INIT_SETPT_RC12</th><th align=center>T_ADD</th><th align=center>PILOT_INC</th><th align=center>RAND_CDMA2000_INCLUDED</th><th align=center>RAND_CDMA2000</th><th align=center>G_CSNAL2_ACK_TIMER</th><th align=center>G_CSNASEQ_CONTEXT_TIMER</th></tr>\n");			      


foreach $_(@lsmMOBIL){

@_ = split (/,/,$_);
if ($_[0] <= 11){

print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");


if ($_[3] eq "1"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$mobilgp = "true";
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$mobilgp = "true";	
}
print (HTMLFILE "<td align=center>$_[5]</td>\n");

if ($pkg =~ m/^3/) {  
if ($_[6] eq "2"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$mobilgp = "true";	
}
                   }
				   
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[6] eq "7"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "7"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$mobilgp = "true";	
}
                   }				   

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$mobilgp = "true";	
}
                  
				 }
				 
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$mobilgp = "true";	
}
                  
				 }				 

if ($_[8] eq "0"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$mobilgp = "true";	
}

if ($_[9] eq "0"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$mobilgp = "true";	
}


if ($_[10] eq "0"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$mobilgp = "true";	
}

if ($_[11] eq "0"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$mobilgp = "true";	
}

if ($_[12] eq "0"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
	
}		
if ($_[12] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$mobilgp = "true";	
}

if ($_[13] eq "0"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}		
if ($_[13] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$mobilgp = "true";	
}

if ($_[14] eq "0"){
print (HTMLFILE "<td align=center>$_[14]</td>\n");	
	
}		
if ($_[14] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");	
$mobilgp = "true";	
}

if ($_[15] eq "0"){
print (HTMLFILE "<td align=center>$_[15]</td>\n");	
	
}		
if ($_[15] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");	
$mobilgp = "true";	
}

if ($_[16] eq "6"){
print (HTMLFILE "<td align=center>$_[16]</td>\n");	
	
}		
if ($_[16] ne "6"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");	
$mobilgp = "true";	
}

if ($_[17] eq "1"){
print (HTMLFILE "<td align=center>$_[17]</td>\n");	
	
}		
if ($_[17] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");	
$mobilgp = "true";	
}

if ($_[18] eq "-1"){
print (HTMLFILE "<td align=center>$_[18]</td>\n");	
	
}		
if ($_[18] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");	
$mobilgp = "true";	
}

if ($_[19] eq "-1"){
print (HTMLFILE "<td align=center>$_[19]</td>\n");	
	
}		
if ($_[19] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");	
$mobilgp = "true";	
}

if ($_[20] eq "-1"){
print (HTMLFILE "<td align=center>$_[20]</td>\n");	
	
}		
if ($_[20] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");	
$mobilgp = "true";	
}

if ($_[21] eq "-1"){
print (HTMLFILE "<td align=center>$_[21]</td>\n");	
	
}		
if ($_[21] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");	
$mobilgp = "true";	
}

if ($_[22] eq "-1"){
print (HTMLFILE "<td align=center>$_[22]</td>\n");	
	
}		
if ($_[22] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");	
$mobilgp = "true";	
}

if ($_[23] eq "-1"){
print (HTMLFILE "<td align=center>$_[23]</td>\n");	
	
}		
if ($_[23] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");	
$mobilgp = "true";	
}

if ($_[24] eq "-1"){
print (HTMLFILE "<td align=center>$_[24]</td>\n");	
	
}		
if ($_[24] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");	
$mobilgp = "true";	
}

if ($_[25] eq "1"){
print (HTMLFILE "<td align=center>$_[25]</td>\n");	
	
}		
if ($_[25] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");	
$mobilgp = "true";	
}

if ($_[26] eq "2"){
print (HTMLFILE "<td align=center>$_[26]</td>\n");	
	
}		
if ($_[26] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");	
$mobilgp = "true";	
}

if ($_[27] eq "-1"){
print (HTMLFILE "<td align=center>$_[27]</td>\n");	
	
}		
if ($_[27] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");	
$mobilgp = "true";	
}

if ($_[28] eq "-1"){
print (HTMLFILE "<td align=center>$_[28]</td>\n");	
	
}		
if ($_[28] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");	
$mobilgp = "true";	
}

if ($_[29] eq "-1"){
print (HTMLFILE "<td align=center>$_[29]</td>\n");	
	
}		
if ($_[29] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");	
$mobilgp = "true";	
}
if ($_[30] eq "-1"){
print (HTMLFILE "<td align=center>$_[30]</td>\n");	
	
}		
if ($_[30] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");	
$mobilgp = "true";	
}

if ($_[31] eq "3"){
print (HTMLFILE "<td align=center>$_[31]</td>\n");	
	
}		
if ($_[31] ne "3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");	
$mobilgp = "true";	
}

if ($_[32] eq "-1"){
print (HTMLFILE "<td align=center>$_[32]</td>\n");	
	
}		
if ($_[32] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");	
$mobilgp = "true";	
}

if ($_[33] eq "-1"){
print (HTMLFILE "<td align=center>$_[33]</td>\n");	
	
}		
if ($_[33] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[33]</td>\n");	
$mobilgp = "true";	
}

if ($_[34] eq "-1"){
print (HTMLFILE "<td align=center>$_[34]</td>\n");	
	
}		
if ($_[34] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[34]</td>\n");	
$mobilgp = "true";	
}

if ($_[35] eq "1"){
print (HTMLFILE "<td align=center>$_[35]</td>\n");	
	
}		
if ($_[35] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[35]</td>\n");	
$mobilgp = "true";	
}
if ($_[36] eq "1"){
print (HTMLFILE "<td align=center>$_[36]</td>\n");	
	
}		
if ($_[36] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[36]</td>\n");	
$mobilgp = "true";	
}
if ($_[37] eq "1"){
print (HTMLFILE "<td align=center>$_[37]</td>\n");	
	
}		
if ($_[37] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[37]</td>\n");	
$mobilgp = "true";	
}

if ($_[38] eq "1"){
print (HTMLFILE "<td align=center>$_[38]</td>\n");	
	
}		
if ($_[38] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[38]</td>\n");	
$mobilgp = "true";	
}

if ($_[39] eq "1"){
print (HTMLFILE "<td align=center>$_[39]</td>\n");	
	
}		
if ($_[39] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[39]</td>\n");	
$mobilgp = "true";	
}

if ($_[40] eq "0"){
print (HTMLFILE "<td align=center>$_[40]</td>\n");	
	
}		
if ($_[40] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[40]</td>\n");	
$mobilgp = "true";	
}

if ($_[41] eq "58"){
print (HTMLFILE "<td align=center>$_[41]</td>\n");	
	
}		
if ($_[41] ne "58"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[41]</td>\n");	
$mobilgp = "true";	
}

if ($_[42] eq "-1"){
print (HTMLFILE "<td align=center>$_[42]</td>\n");	
	
}		
if ($_[42] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[42]</td>\n");	
$mobilgp = "true";	
}

if ($_[43] eq "3"){
print (HTMLFILE "<td align=center>$_[43]</td>\n");	
	
}		
if ($_[43] ne "3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");	
$mobilgp = "true";	
}


if ($_[44] eq "-1"){
print (HTMLFILE "<td align=center>$_[44]</td>\n");	
	
}		
if ($_[44] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[44]</td>\n");	
$mobilgp = "true";	
}


if ($_[45] eq "-1"){
print (HTMLFILE "<td align=center>$_[45]</td>\n");	
	
}		
if ($_[45] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[45]</td>\n");	
$mobilgp = "true";	
}


if ($_[46] eq "310"){
print (HTMLFILE "<td align=center>$_[46]</td>\n");	
	
}		
if ($_[46] ne "310"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");	
$mobilgp = "true";	
}

if ($_[47] eq "0"){
print (HTMLFILE "<td align=center>$_[47]</td>\n");	
	
}		
if ($_[47] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[47]</td>\n");	
$mobilgp = "true";	
}

if ($_[48] eq "0"){
print (HTMLFILE "<td align=center>$_[48]</td>\n");	
	
}		
if ($_[48] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[48]</td>\n");	
$mobilgp = "true";	
}

if ($_[49] eq "-1"){
print (HTMLFILE "<td align=center>$_[49]</td>\n");	
	
}		
if ($_[49] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[49]</td>\n");	
$mobilgp = "true";	
}

if ($_[50] eq "-1"){
print (HTMLFILE "<td align=center>$_[50]</td>\n");	
	
}		
if ($_[50] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[50]</td>\n");	
$mobilgp = "true";	
}

if ($_[51] eq "-1"){
print (HTMLFILE "<td align=center>$_[51]</td>\n");	
	
}		
if ($_[51] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[51]</td>\n");	
$mobilgp = "true";	
}

if ($_[52] eq "-1"){
print (HTMLFILE "<td align=center>$_[52]</td>\n");	
	
}		
if ($_[52] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[52]</td>\n");	
$mobilgp = "true";	
}

if ($_[52] eq "-1"){
print (HTMLFILE "<td align=center>$_[53]</td>\n");	
	
}		
if ($_[53] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[53]</td>\n");	
$mobilgp = "true";	
}

if ($_[54] eq "-1"){
print (HTMLFILE "<td align=center>$_[54]</td>\n");	
	
}		
if ($_[54] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[54]</td>\n");	
$mobilgp = "true";	
}

if ($_[55] eq "-1"){
print (HTMLFILE "<td align=center>$_[55]</td>\n");	
	
}		
if ($_[55] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[55]</td>\n");	
$mobilgp = "true";	
}

if ($_[56] eq "-1"){
print (HTMLFILE "<td align=center>$_[56]</td>\n");	
	
}		
if ($_[56] ne "-1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[56]</td>\n");	
$mobilgp = "true";	
}

if ($_[57] eq "1"){
print (HTMLFILE "<td align=center>$_[57]</td>\n");	
	
}		
if ($_[57] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[57]</td>\n");	
$mobilgp = "true";	
}

if ($_[58] eq "56"){
print (HTMLFILE "<td align=center>$_[58]</td>\n");	
	
}		
if ($_[58] ne "56"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[58]</td>\n");	
$mobilgp = "true";	
}

if ($_[59] eq "64"){
print (HTMLFILE "<td align=center>$_[59]</td>\n");	
	
}		
if ($_[59] ne "64"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[59]</td>\n");	
$mobilgp = "true";	
}

if ($_[60] eq "56"){
print (HTMLFILE "<td align=center>$_[60]</td>\n");	
	
}		
if ($_[60] ne "56"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[60]</td>\n");	
$mobilgp = "true";	
}

if ($_[61] eq "56"){
print (HTMLFILE "<td align=center>$_[61]</td>\n");	
	
}		
if ($_[61] ne "56"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[61]</td>\n");	
$mobilgp = "true";	
}

if ($_[62] eq "0"){
print (HTMLFILE "<td align=center>$_[62]</td>\n");	
	
}		
if ($_[62] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[62]</td>\n");	
$mobilgp = "true";	
}

if ($_[63] eq "28"){
print (HTMLFILE "<td align=center>$_[63]</td>\n");	
	
}		
if ($_[63] ne "28"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");	
$mobilgp = "true";	
}

if ($_[64] eq "3"){
print (HTMLFILE "<td align=center>$_[64]</td>\n");	
	
}		
if ($_[64] ne "3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[64]</td>\n");	
$mobilgp = "true";	
}


if ($_[65] eq "0"){
print (HTMLFILE "<td align=center>$_[65]</td>\n");	
	
}		
if ($_[65] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[65]</td>\n");	
$mobilgp = "true";	
}



if ($_[66] eq "0"){
print (HTMLFILE "<td align=center>$_[66]</td>\n");	
	
}		
if ($_[66] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[66]</td>\n");	
$mobilgp = "true";	
}


if ($_[67] eq "10"){
print (HTMLFILE "<td align=center>$_[67]</td>\n");	
	
}		
if ($_[67] ne "10"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[67]</td>\n");	
$mobilgp = "true";	
}

if ($_[68] eq "30"){
print (HTMLFILE "<td align=center>$_[68]</td>\n");	
	
}		
if ($_[68] ne "30"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[68]</td>\n");	
$mobilgp = "true";	
}


print (HTMLFILE "</tr>");
}
}		                        

print (HTMLFILE "</table>\n");






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>C1XRTT-ECSFB</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CARRIER_INDEX</th><th align=center>NUM1_X_PN</th><th align=center>PILOT_STRENGTH_THRESHOLD</th><th align=center>STATUS_AFTER_HO_FAILURE</th></tr>\n");			      


foreach $_(@lsmECSFB){

@_ = split (/,/,$_);


if ((($_[1] eq "0") && ($_[0] <= "8")) && ($divciq eq "8T8R")) {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "1"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$ecsfbgp = "true";	
}
if ($_[3] eq "24"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "24"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$ecsfbgp = "true";	
}
if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$ecsfbgp = "true";	
}
print (HTMLFILE "</tr>");
}
if (($_[1] eq "0") && (($_[0] <=2) || ($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11")) && ($divciq eq "4T4R")) {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "1"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$ecsfbgp = "true";	
}
if ($_[3] eq "24"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "24"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$ecsfbgp = "true";	
}
if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$ecsfbgp = "true";	
}
print (HTMLFILE "</tr>");
}		                        
}


print (HTMLFILE "</table>\n");	





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>CDD-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CDD</th></tr>\n");			      


foreach $_(@cddconf){

@_ = split (/,/,$_);


if (($_[0] <= "8") && ($divciq eq "8T8R")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "False"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$cddgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ((($_[0] <= "2") || ($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11")) && ($divciq eq "4T4R")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "True"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$cddgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");	




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>CDMA-CNF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CDMA_EUTRA_SYNCHRONISATION</th><th align=center>SEARCH_WINDOW_SIZE</th><th align=center>CSFB_SUPPORT_DUAL_RX_UE</th><th align=center>CSFB_SUPPORT_DUAL_RX_TX_UE</th></tr>\n");			      


foreach $_(@cdmaconf){

@_ = split (/,/,$_);


if ($_[0] <= "11") {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "False"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$cdmagp = "true";	
}
if ($_[2] eq "10"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "10"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$cdmagp = "true";	
}
if ($_[3] eq "True"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$cdmagp = "true";	
}
if ($_[4] eq "False"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$cdmagp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");	



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>CELL-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_SIZE</th><th align=center>HNB_NAME</th><th align=center>ADD_SPECTRUM_EMISSION</th><th align=center>TRACKING_AREA_CODE</th><th align=center>IMS_EMERGENCY_SUPPORT</th></tr>\n");			      


foreach $_(@cellinfogp){

@_ = split (/,/,$_);


if ($_[0] <= "11") {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "SAMSUNG_LTE"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "SAMSUNG_LTE"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$cellinfogp = "true";	
}
if ($_[3] eq "1"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$cellinfogp = "true";	
}
if ($_[4] eq "H'$tac") {
print (HTMLFILE "<td align=center>$_[4]</td>\n");
}
if ($_[4] ne "H'$tac") {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
$cellinfogp = "true";	
}
if ($_[5] eq "False"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$cellinfogp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");	



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>CELL-RSEL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>Q_HYST</th><th align=center>Q_HYST_SFMEDIUM</th><th align=center>Q_HYST_SFHIGH</th></tr>\n");			      


foreach $_(@cellrsel){

@_ = split (/,/,$_);


if ($_[0] <= "11") {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "4dB"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "4dB"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$cellrselgp = "true";	
}
if ($_[2] eq "minus_6dB"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "minus_6dB"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$cellrselgp = "true";	
}
if ($_[3] eq "minus_6dB"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "minus_6dB"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$cellrselgp = "true";	
}
   
   
   
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");	


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>CELL-SEL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>Q_RX_LEV_MIN</th><th align=center>Q_RXLEV_MIN_OFFSET_USAGE</th><th align=center>Q_RXLEV_MIN_OFFSET</th><th align=center>P_MAX_USAGE</th><th align=center>P_MAX</th><th align=center>REL9_SEL_INFO_USAGE</th><th align=center>Q_QUAL_MIN</th><th align=center>Q_QUAL_MIN_OFFSET_USAGE</th><th align=center>Q_QUAL_MIN_OFFSET</th></tr>\n");			      


foreach $_(@cellsel){

@_ = split (/,/,$_);


if ($_[0] <= "11") {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "-62"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "-62"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$cellselgp = "true";	
}
if ($_[2] eq "no_use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$cellselgp = "true";	
}
if ($_[3] eq "3"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$cellselgp = "true";	
}
if ($_[4] eq "no_use"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$cellselgp = "true";	
}   
if ($_[5] eq "0"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$cellselgp = "true";	
}     



if ($_[6] eq "no_use"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$cellselgp = "true";	
}   
if ($_[7] eq "-16"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "-16"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$cellselgp = "true";	
}   

if ($_[8] eq "no_use"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$cellselgp = "true";	
}   
if ($_[9] eq "3"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$cellselgp = "true";	
}   
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");


if ($divciq eq "8T8R"){

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>DL-SCHED</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>DL_MIMO_MODE</th><th align=center>ALPHA</th><th align=center>BETA</th><th align=center>GAMMA</th></tr>\n");			      


foreach $_(@dlshed){

@_ = split (/,/,$_);


if ($_[0] <= "8") {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "TM8"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "TM8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dlschedgp = "true";	
}
if ($_[2] eq "1"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$dlschedgp = "true";	
}
if ($_[3] eq "1"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$dlschedgp = "true";	
}
if ($_[4] eq "4"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$dlschedgp = "true";	
}   
   
   
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");	


}


if ($divciq eq "4T4R"){

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>DL-SCHED</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>DL_MIMO_MODE</th><th align=center>ALPHA</th><th align=center>BETA</th><th align=center>GAMMA</th></tr>\n");			      


foreach $_(@dlshed){

@_ = split (/,/,$_);


if (($_[0] <= "2") || ($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "TM3"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "TM3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dlschedgp = "true";	
}
if ($_[2] eq "1"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$dlschedgp = "true";	
}
if ($_[3] eq "1"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$dlschedgp = "true";	
}
if ($_[4] eq "4"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$dlschedgp = "true";	
}   
   
   
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");	


}

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=12 bgcolor=#EEEEEE><b>EUTRA-A1CNF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>ACTIVE_STATE</th><th align=center>A1_THRESHOLD_RSRP[dBm]</th><th align=center>A1_THRESHOLD_RSRQ[dB]</th><th align=center>HYSTERESIS</th><th align=center>TIME_TO_TRIGGER[ms]</th><th align=center>TRIGGER_QUANTITY</th><th align=center>REPORT_QUANTITY</th><th align=center>MAX_REPORT_CELL</th><th align=center>REPORT_INTERVAL[ms]</th><th align=center>REPORT_AMOUNT</th></tr>\n");			      


foreach $_(@A1cnf){

@_ = split (/,/,$_);


if ($_[0] <= "11") {


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "Active"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "Active"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$A1cnfgp = "true";	
}
if ($_[3] eq "30"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "30"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A1cnfgp = "true";	
}
if ($_[4] eq "32"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "32"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A1cnfgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[5] eq "2"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A1cnfgp = "true";	
}
                  }

if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[5] eq "4"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A1cnfgp = "true";	
}
                  }				  

if ($_[6] eq "480ms"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A1cnfgp = "true";	
}  

if ($_[7] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A1cnfgp = "true";	
}  


if ($_[8] eq "both"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "both"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A1cnfgp = "true";	
}  

if ($_[9] eq "8"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A1cnfgp = "true";	
} 
if ($_[10] eq "240ms"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A1cnfgp = "true";	
} 

if ($_[11] eq "8"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A1cnfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}

print (HTMLFILE "</table>\n");	






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=12 bgcolor=#EEEEEE><b>EUTRA-A2CNF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>ACTIVE_STATE</th><th align=center>A2_THRESHOLD_RSRP[dBm]</th><th align=center>A2_THRESHOLD_RSRQ[dB]</th><th align=center>HYSTERESIS</th><th align=center>TIME_TO_TRIGGER[ms]</th><th align=center>TRIGGER_QUANTITY</th><th align=center>REPORT_QUANTITY</th><th align=center>MAX_REPORT_CELL</th><th align=center>REPORT_INTERVAL[ms]</th><th align=center>REPORT_AMOUNT</th></tr>\n");			      


foreach $_(@A2cnf){

@_ = split (/,/,$_);


if (($_[0] <= "11") && ($_[1] eq "LteHo")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "Active"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "Active"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[3] eq "25"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "25"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[4] eq "15"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "15"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A2cnfgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[5] eq "2"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A2cnfgp = "true";	
}
                  }

if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[5] eq "4"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A2cnfgp = "true";	
}
                  }				  

if ($_[6] eq "480ms"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[7] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A2cnfgp = "true";	
}  


if ($_[8] eq "both"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "both"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[9] eq "8"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A2cnfgp = "true";	
} 
if ($_[10] eq "240ms"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A2cnfgp = "true";	
} 

if ($_[11] eq "8"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A2cnfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}


if (($_[0] <= "11") && ($_[1] eq "IRatBlind")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "Inactive"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "Inactive"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[3] eq "20"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "20"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[4] eq "32"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "32"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[5] eq "0"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[6] eq "480ms"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[7] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A2cnfgp = "true";	
}  


if ($_[8] eq "both"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "both"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[9] eq "8"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A2cnfgp = "true";	
} 
if ($_[10] eq "240ms"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A2cnfgp = "true";	
} 

if ($_[11] eq "8"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A2cnfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if (($_[0] <= "11") && ($_[1] eq "Ca")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "Inactive"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "Inactive"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[3] eq "35"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "35"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[4] eq "32"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "32"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A2cnfgp = "true";	
}
if ($_[5] eq "0"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[6] eq "480ms"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[7] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A2cnfgp = "true";	
}  


if ($_[8] eq "both"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "both"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A2cnfgp = "true";	
}  

if ($_[9] eq "8"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A2cnfgp = "true";	
} 
if ($_[10] eq "240ms"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A2cnfgp = "true";	
} 

if ($_[11] eq "8"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A2cnfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}


}

print (HTMLFILE "</table>\n");	





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 bgcolor=#EEEEEE><b>EUTRA-A3CNF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>FA_INDEX</th><th align=center>ACTIVE_STATE</th><th align=center>A3_OFFSET[dB]</th><th align=center>A3_REPORT_ON_LEAVE</th><th align=center>HYSTERESIS</th><th align=center>TIME_TO_TRIGGER[ms]</th><th align=center>TRIGGER_QUANTITY</th><th align=center>REPORT_QUANTITY</th><th align=center>MAX_REPORT_CELL</th><th align=center>REPORT_INTERVAL[ms]</th><th align=center>REPORT_AMOUNT</th></tr>\n");			      


foreach $_(@A3cnf){

@_ = split (/,/,$_);


if (($_[0] <= "11") && ($_[1] eq "IntraLteHandover") && ($_[3] <= "2") && ($_[2] <= "2")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "Active"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "Active"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[4] eq "2"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[5] eq "False") {
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[6] eq "2"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[7] eq "320ms"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "320ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[8] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A3cnfgp = "true";	
}  


if ($_[9] eq "sameAsTriggerQuantity"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "sameAsTriggerQuantity"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[10] eq "8"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A3cnfgp = "true";	
} 
if ($_[11] eq "240ms"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A3cnfgp = "true";	
} 

if ($_[12] eq "8"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[12] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A3cnfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if (($_[0] <= "11") && ($_[1] eq "IntraFrequencyLb") && ($_[2] eq "0")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "Inactive"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "Inactive"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[4] eq "4"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[5] eq "False"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[6] eq "0"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[7] eq "480ms"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[8] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A3cnfgp = "true";	
}  


if ($_[9] eq "sameAsTriggerQuantity"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "sameAsTriggerQuantity"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[10] eq "8"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A3cnfgp = "true";	
} 
if ($_[11] eq "240ms"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A3cnfgp = "true";	
} 

if ($_[12] eq "8"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[12] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A3cnfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}


if (($_[0] <= "11") && ($_[1] eq "IntraFrequncyCre") && ($_[3] eq "0")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "Inactive"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "Inactive"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[4] eq "4"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[5] eq "False"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A3cnfgp = "true";	
}
if ($_[6] eq "0"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[7] eq "480ms"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[8] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A3cnfgp = "true";	
}  


if ($_[9] eq "sameAsTriggerQuantity"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "sameAsTriggerQuantity"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A3cnfgp = "true";	
}  

if ($_[10] eq "8"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A3cnfgp = "true";	
} 
if ($_[11] eq "240ms"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A3cnfgp = "true";	
} 

if ($_[12] eq "8"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[12] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A3cnfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}
print (HTMLFILE "</table>\n");







print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=15 bgcolor=#EEEEEE><b>EUTRA-A5CNF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>FA_INDEX</th><th align=center>ACTIVE_STATE</th><th align=center>A5_THRESHOLD1_RSRP[dBm]</th><th align=center>A5_THRESHOLD2_RSRP[dBm]</th><th align=center>A5_THRESHOLD1_RSRQ[dB]</th><th align=center>A5_THRESHOLD2_RSRQ[dB]</th><th align=center>HYSTERESIS</th><th align=center>TIME_TO_TRIGGER[ms]</th><th align=center>TRIGGER_QUANTITY</th><th align=center>REPORT_QUANTITY</th><th align=center>MAX_REPORT_CELL</th><th align=center>REPORT_INTERVAL[ms]</th><th align=center>REPORT_AMOUNT</th></tr>\n");			      


foreach $_(@A5cnf){

@_ = split (/,/,$_);


if (($_[0] <= "11EUTRA-A5CNF") && ($_[1] eq "IntraLteHandover") && ($_[3] <= "5") && ($_[2] ne "0")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "Active"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "Active"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A5cnfgp = "true";	
}
if ($_[4] eq "24"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "24"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A5cnfgp = "true";	
}
if (($_[5] eq "34") && ($_[2] ne "5")) {
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}
if (($_[5] eq "30") && ($_[2] eq "5")) {
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if (($_[5] ne "34") && ($_[2] ne "5")) {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A5cnfgp = "true";	
}
if (($_[5] ne "30") && ($_[2] eq "5")) {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A5cnfgp = "true";	
}

if ($_[6] eq "32"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "32"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A5cnfgp = "true";	
}  

if ($_[7] eq "32"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "32"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A5cnfgp = "true";	
}  

if ($_[8] eq "2"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A5cnfgp = "true";	
}  


if ($_[9] eq "480ms"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A5cnfgp = "true";	
}  

if ($_[10] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A5cnfgp = "true";	
} 
if ($_[11] eq "both"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "both"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A5cnfgp = "true";	
} 

if ($_[12] eq "8"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
	
}		
if ($_[12] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$A5cnfgp = "true";	
}
if ($_[13] eq "240ms"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}		
if ($_[13] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$A5cnfgp = "true";	
}
if ($_[14] eq "8"){
print (HTMLFILE "<td align=center>$_[14]</td>\n");	
	
}		
if ($_[14] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");	
$A5cnfgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}
print (HTMLFILE "</table>\n");





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 bgcolor=#EEEEEE><b>EUTRA-A6CNF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>FA_INDEX</th><th align=center>ACTIVE_STATE</th><th align=center>A6_OFFSET[dB]</th><th align=center>A6_REPORT_ON_LEAVE</th><th align=center>HYSTERESIS</th><th align=center>TIME_TO_TRIGGER[ms]</th><th align=center>TRIGGER_QUANTITY</th><th align=center>REPORT_QUANTITY</th><th align=center>MAX_REPORT_CELL</th><th align=center>REPORT_INTERVAL[ms]</th><th align=center>REPORT_AMOUNT</th></tr>\n");			      


foreach $_(@A6cnf){


@_ = split (/,/,$_);

if ($divciq eq "8T8R"){
if (($_[0] <= "8") && ($_[1] eq "Ca") && ($_[2] eq "0")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "Inactive"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "Inactive"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[4] eq "4"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[5] eq "False"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[6] eq "0"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A6cnfgp = "true";	
}  

if ($_[7] eq "480ms"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A6cnfgp = "true";	
}  

if ($_[8] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A6cnfgp = "true";	
} 
if ($_[9] eq "sameAsTriggerQuantity"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "sameAsTriggerQuantity"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A6cnfgp = "true";	
} 

if ($_[10] eq "8"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[11] eq "240ms"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[12] eq "8"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
	
}		
if ($_[12] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$A6cnfgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}
}
if ($divciq eq "4T4R"){
if ((($_[0] <= "2") || ($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11"))&& ($_[1] eq "Ca") && ($_[2] eq "0")){


print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "Inactive"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "Inactive"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[4] eq "4"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[5] eq "False"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[6] eq "0"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$A6cnfgp = "true";	
}  

if ($_[7] eq "480ms"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "480ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$A6cnfgp = "true";	
}  

if ($_[8] eq "rsrp"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "rsrp"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$A6cnfgp = "true";	
} 
if ($_[9] eq "sameAsTriggerQuantity"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "sameAsTriggerQuantity"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$A6cnfgp = "true";	
} 

if ($_[10] eq "8"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[11] eq "240ms"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "240ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$A6cnfgp = "true";	
}
if ($_[12] eq "8"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
	
}		
if ($_[12] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$A6cnfgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}
}
}
print (HTMLFILE "</table>\n");




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>HO-OPT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>ERAB_INTERACTION</th><th align=center>USED_NBR_LIST</th><th align=center>NUM_OF_ENB</th><th align=center>RIM_ENABLE</th><th align=center>MME_SELECT_FACTOR_FOR_RIM</th><th align=center>HANDOVER_BY_RLF</th><th align=center>S_CELL_SWITCH_FLAG</th></tr>\n");			      


foreach $_(@hoopt){


@_ = split (/,/,$_);

if ($_[0] eq "1"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
}		
if ($_[0] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");	
$hooptgp = "true";	
}

if ($_[1] eq "0"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$hooptgp = "true";	
}

if ($_[2] eq "1"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$hooptgp = "true";	
}

if ($_[3] eq "False"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$hooptgp = "true";	
}

if ($_[4] eq "0"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$hooptgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[5] eq "Off"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Off"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$hooptgp = "true";	
}
                   }
				   
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[5] eq "On"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "On"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$hooptgp = "true";	
}
                   }

				   
if ($_[6] eq "False"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$hooptgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}
print (HTMLFILE "</table>\n");


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>INACT-TIMER</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>QCI</th><th align=center>PLMN_IDX</th><th align=center>INTERNAL_USER_INACTIVITY</th></tr>\n");			      


foreach $_(@inacttimer){


@_ = split (/,/,$_);
if ($divciq eq "8T8R"){
if (($_[1] eq "0") && ($_[0] <= "9")){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "6"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
}		
if ($_[2] ne "6"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");	
$inacttimergp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}
if ($divciq eq "4T4R"){
if (($_[1] eq "0") && (($_[0] <= "2") || ($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11"))){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");

if ($_[2] eq "6"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
}		
if ($_[2] ne "6"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");	
$inacttimergp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}
}
print (HTMLFILE "</table>\n");




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>INTWO-OPT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>INTER_FREQ_REDIR_SUPPORT</th><th align=center>INTER_RAT_DATA_OPTION</th><th align=center>CSFB_BLIND_SUPPORT</th><th align=center>IDLE_CSFB_OPTIMIZED</th><th align=center>DUAL_RX_TX_REDIRECT_INDICATOR</th><th align=center>C1_X_HIGH_PRIORITY_SUPPORT</th></tr>\n");			      


foreach $_(@intwoopt){


@_ = split (/,/,$_);

if (($_[0] <= "8") && ($divciq eq "8T8R")){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "ci_Blind_Not_Support"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "ci_Blind_Not_Support"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$intwooptgp = "true";	
}

if ($_[4] eq "False"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$intwooptgp = "true";	
}

print (HTMLFILE "<td align=center>$_[5]</td>\n");
print (HTMLFILE "<td align=center>$_[6]</td>\n");


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          

}
if ((($_[0] <= "2") || ($_[0] eq "9") || ($_[0] eq "10") || ($_[0] eq "11"))  && ($divciq eq "4T4R")){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
print (HTMLFILE "<td align=center>$_[1]</td>\n");
print (HTMLFILE "<td align=center>$_[2]</td>\n");

if ($_[3] eq "ci_Blind_Not_Support"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "ci_Blind_Not_Support"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$intwooptgp = "true";	
}

if ($_[4] eq "False"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$intwooptgp = "true";	
}

print (HTMLFILE "<td align=center>$_[5]</td>\n");
print (HTMLFILE "<td align=center>$_[6]</td>\n");


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          

}
}
print (HTMLFILE "</table>\n");









print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>LOCH-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>QCI</th><th align=center>PRIORITIZED_BIT_RATE</th><th align=center>BUCKET_SIZE_DURATION</th><th align=center>LOGICAL_CHANNEL_PRIORITY</th><th align=center>NON_GBRPFWEIGHT</th></tr>\n");			      


foreach $_(@lochinf){


@_ = split (/,/,$_);

if ($_[0] eq "0"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "300ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "12"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "12"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "1"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "100ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "100ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "5"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "5"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}



if ($_[0] eq "2"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "150ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "150ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "7"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "7"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "3"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "50ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "50ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "6"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "6"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}



if ($_[0] eq "4"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "300ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "8"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}


if ($_[0] eq "5"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "16kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "16kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "100ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "100ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "1"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}



if ($_[0] eq "6"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "300ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "9"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "9"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}

                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[4] eq "0"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}

                  }				  


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}



if ($_[0] eq "7"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "100ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "100ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "10"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "10"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}




if ($_[0] eq "8"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "300ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "11"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "11"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "1"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}



if ($_[0] eq "9"){
      
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8kbps"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8kbps"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$lochinfgp = "true";	
}

if ($_[2] eq "300ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$lochinfgp = "true";	
}
if ($_[3] eq "12"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "12"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$lochinfgp = "true";	
}

if ($_[4] eq "3"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$lochinfgp = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}
}
print (HTMLFILE "</table>\n");






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>MEAS-FUNC</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>S_MEASURE</th><th align=center>SF_USAGE</th><th align=center>TIME_TO_TRIGGER_SF_MEDIUM</th><th align=center>TIME_TO_TRIGGER_SF_HIGH</th></tr>\n");			      


foreach $_(@measfunc){


@_ = split (/,/,$_);

if ($_[0] <= "11"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");
$_[1] =~ s/\s+//g;
if ($pkg =~ m/^3/) {  
if ($_[1] eq "90"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "90"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$measfunc = "true";	
}
                   }

if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[1] eq "80"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "80"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$measfunc = "true";	
}
                   }				   
				   
if ($_[2] eq "no_use"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "no_use"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$measfunc = "true";	
}
if ($_[3] eq "oneDot0"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "oneDot0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$measfunc = "true";	
}

if ($_[4] eq "oneDot0"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "oneDot0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$measfunc = "true";	
}



    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}
}
print (HTMLFILE "</table>\n");



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>PCCH-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>DEFAULT_PAGING_CYCLE</th><th align=center>N_B</th></tr>\n");			      


foreach $_(@pcchconf){


@_ = split (/,/,$_);


if ($_[0] eq "rf128"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
}		
if ($_[0] ne "rf128"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");	
$pcchconf = "true";	
}
if ($_[1] eq "one"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "one"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$pcchconf = "true";	
}


    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

print (HTMLFILE "</table>\n");





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>QCI-VAL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>QCI</th><th align=center>STATUS</th><th align=center>RESOURCE_TYPE</th><th align=center>PRIORITY</th><th align=center>PDB</th><th align=center>BH_SERVICE_GROUP</th><th align=center>SCHEDULING_TYPE</th><th align=center>UPLINK_FORWARD</th><th align=center>DOWNLINK_FORWARD</th><th align=center>CONFIGURED_BIT_RATE[bps]</th><th align=center>WEIGHT_FOR_CELL_LOAD</th></tr>\n");			      


foreach $_(@qcival){


@_ = split (/,/,$_);

if ($_[0] eq "1"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "GBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "GBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "2"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "100ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "100ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "VoIP"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "VoIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }				  
 
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}

print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 
 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}


if ($_[0] eq "2"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "GBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "GBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "4"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "150ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "150ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}



if ($_[0] eq "3"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "GBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "GBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "3"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "3"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "50ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "50ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}

print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}


if ($_[0] eq "4"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "GBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "GBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "5"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "5"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "300ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}


if ($_[0] eq "5"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "NonGBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "NonGBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "1"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "100ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "100ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}


if ($_[0] eq "6"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "NonGBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "NonGBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "6"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "6"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "300ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}


if ($_[0] eq "7"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "NonGBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "NonGBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "7"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "7"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "100ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "100ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}

if ($_[0] eq "8"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "NonGBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "NonGBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "8"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "300ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}


if ($_[0] eq "9"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "NonGBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "NonGBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "9"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "9"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "300ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}



if ($_[0] eq "0"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "N_EQUIP"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "N_EQUIP"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$qcivalgp = "true";	
}

if ($_[2] eq "NonGBR"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "NonGBR"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$qcivalgp = "true";	
}
if ($_[3] eq "9"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "9"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$qcivalgp = "true";	
}

if ($_[4] eq "300ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "300ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$qcivalgp = "true";	
}
if ($_[5] eq "Video"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "Video"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$qcivalgp = "true";	
}
if ($_[6] eq "Dynamic_scheduling"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "Dynamic_scheduling"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$qcivalgp = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[7] eq "1"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "0"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$qcivalgp = "true";	
}
                  }	
if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$qcivalgp = "true";	
}
print (HTMLFILE "<td align=center>$_[9]</td>\n");
print (HTMLFILE "<td align=center>$_[10]</td>\n"); 

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}


}
print (HTMLFILE "</table>\n");





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>DSCP-TRF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>QCI</th><th align=center>DSCP</th></tr>\n");			      


foreach $_(@dscptrf){


@_ = split (/,/,$_);

if ($_[0] eq "1"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "46"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "46"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "2"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "24"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "24"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "3"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "16"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "16"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "4"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "16"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "16"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "5"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "32"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "32"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($pkg =~ m/^3/) {  
if ($_[0] eq "6"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "16"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "16"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}
                  }
				  
if ($pkg =~ m/^4/) {  
if ($_[0] eq "6"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}
                  }				  

if ($_[0] eq "7"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "16"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "16"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "8"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

if ($_[0] eq "9"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "8"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "8"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$dscptrfgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
}

}
print (HTMLFILE "</table>\n");






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=12 bgcolor=#EEEEEE><b>ROHC-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>QCI</th><th align=center>ROHC_SUPPORT</th><th align=center>MAX_CONTEXT_SESSION</th><th align=center>PROFILE0001</th><th align=center>PROFILE0002</th><th align=center>PROFILE0003</th><th align=center>PROFILE0004</th><th align=center>PROFILE0006</th><th align=center>PROFILE0101</th><th align=center>PROFILE0102</th><th align=center>PROFILE0103</th><th align=center>PROFILE0104</th></tr>\n");			      


foreach $_(@rochinf){


@_ = split (/,/,$_);


if ($_[0] eq "9"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
	
if ($_[1] eq "False"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$rochinfgp = "true";	
}

if ($_[2] eq "Max_16"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "Max_16"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$rochinfgp = "true";	
}


if ($_[3] eq "True"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$rochinfgp = "true";	
}


if ($_[4] eq "True"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$rochinfgp = "true";	
}

if ($_[5] eq "False"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$rochinfgp = "true";	
}

if ($_[6] eq "True"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$rochinfgp = "true";	
}

if ($_[7] eq "False"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$rochinfgp = "true";	
}

if ($_[8] eq "False"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$rochinfgp = "true";	
}

if ($_[9] eq "False"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$rochinfgp = "true";	
}

if ($_[10] eq "False"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$rochinfgp = "true";	
}

if ($_[11] eq "False"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$rochinfgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          

}
}

print (HTMLFILE "</table>\n");





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>SCTP-PARAM</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SCTP_ID</th><th align=center>SCTP_RTO_MIN[ms]</th><th align=center>SCTP_RTO_MAX[ms]</th><th align=center>SCTP_RTO_INITIAL[ms]</th><th align=center>SCTP_VALID_COOKIE_LIFE[ms]</th><th align=center>SCTP_MAX_BURST</th><th align=center>SCTP_ASSOC_MAX_RETRY</th><th align=center>SCTP_PATH_MAX_RETRANS</th><th align=center>SCTP_MAX_INIT_RETRANS</th><th align=center>SCTP_ASSOC_HEART_BEAT_INTERVAL[ms]</th><th align=center>SCTP_SACK_PERIOD[ms]</th></tr>\n");			      


foreach $_(@sctpparam){


@_ = split (/,/,$_);


if ($_[0] eq "0"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
	
if ($_[1] eq "1000"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "1000"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$sctpparam = "true";	
}

if ($_[2] eq "1400"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "1400"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$sctpparam = "true";	
}


if ($_[3] eq "1000"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "1000"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$sctpparam = "true";	
}


if ($_[4] eq "60000"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "60000"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$sctpparam = "true";	
}

if ($_[5] eq "4"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$sctpparam = "true";	
}

if ($_[6] eq "10"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "10"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$sctpparam = "true";	
}

if ($_[7] eq "5"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "5"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$sctpparam = "true";	
}

if ($_[8] eq "1"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$sctpparam = "true";	
}

if ($_[9] eq "1500"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "1500"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$sctpparam = "true";	
}

if ($_[10] eq "200"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "200"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$sctpparam = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          

}
}

print (HTMLFILE "</table>\n");





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>ENBCONN-PARA</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_FAILOVER_TIMER</th><th align=center>CONNECT_INTERVAL</th><th align=center>S1_SCTP_PROFILE_ID</th><th align=center>X2_SCTP_PROFILE_ID</th></tr>\n");			      


foreach $_(@enbconnpara){


@_ = split (/,/,$_);


if ($_[0] eq "0"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
}		
if ($_[0] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");	
$enbconnparagp = "true";	
}
	
if ($_[1] eq "4"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "4"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$enbconnparagp = "true";	
}

if ($_[2] eq "0"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$enbconnparagp = "true";	
}


if ($_[3] eq "0"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$enbconnparagp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}

print (HTMLFILE "</table>\n");





print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>SECU-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>INTEGRITY_EA_PRIOR</th><th align=center>CIPHER_EA_PRIOR</th></tr>\n");			      


foreach $_(@secuinf){


@_ = split (/,/,$_);


if ($_[0] eq "EIA2"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
}		
if ($_[0] ne "EIA2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");	
$secuinfgp = "true";	
}
	
if ($_[1] eq "EEA2"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "EEA2"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$secuinfgp = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}

print (HTMLFILE "</table>\n");


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=16 bgcolor=#EEEEEE><b>SIB-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>SIB2_PERIOD</th><th align=center>SIB3_PERIOD</th><th align=center>SIB4_PERIOD</th><th align=center>SIB5_PERIOD</th><th align=center>SIB6_PERIOD</th><th align=center>SIB7_PERIOD</th><th align=center>SIB8_PERIOD</th><th align=center>SIB9_PERIOD</th><th align=center>SIB10_PERIOD</th><th align=center>SIB11_PERIOD</th><th align=center>SIB12_PERIOD</th><th align=center>SIB13_PERIOD</th><th align=center>SIB15_PERIOD</th><th align=center>SI_WINDOW</th><th align=center>WAR_SEGMENT_SIZE</th></tr>\n");			      


foreach $_(@sibinf){


@_ = split (/,/,$_);

print (HTMLFILE "<td align=center>$_[0]</td>\n");

if ($_[1] eq "160ms"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "160ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$sibinf = "true";	
}
	
if ($_[2] eq "320ms"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "320ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$sibinf = "true";	
}
if ($_[3] eq "320ms"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "320ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$sibinf = "true";	
}
if ($_[4] eq "320ms"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "320ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$sibinf = "true";	
}
if ($_[5] eq "not_used"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "not_used"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$sibinf = "true";	
}

if ($_[6] eq "not_used"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "not_used"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$sibinf = "true";	
}

if ($_[7] eq "640ms"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "640ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$sibinf = "true";	
}
if ($_[8] eq "320ms"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "320ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$sibinf = "true";	
}


if ($_[9] eq "160ms"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "160ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$sibinf = "true";	
}


if ($_[10] eq "320ms"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "320ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$sibinf = "true";	
}
if ($pkg =~ m/^3/) {  
if ($_[11] eq "5120ms"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "5120ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$sibinf = "true";	
}
                   }
				   
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[11] eq "2560ms"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "2560ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$sibinf = "true";	
}
                   }				   
if ($_[12] eq "not_used"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
	
}		
if ($_[12] ne "not_used"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$sibinf = "true";	
}

if ($_[13] eq "not_used"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}		
if ($_[13] ne "not_used"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$sibinf = "true";	
}

if ($pkg =~ m/^3/) {  
if ($_[14] eq "20ms"){
print (HTMLFILE "<td align=center>$_[14]</td>\n");	
	
}		
if ($_[14] ne "20ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");	
$sibinf = "true";	
}
                  }
				  
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[14] eq "10ms"){
print (HTMLFILE "<td align=center>$_[14]</td>\n");	
	
}		
if ($_[14] ne "10ms"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");	
$sibinf = "true";	
}
                  }				  

if ($_[15] eq "97"){
print (HTMLFILE "<td align=center>$_[15]</td>\n");	
	
}		
if ($_[15] ne "97"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");	
$sibinf = "true";	
}

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}

print (HTMLFILE "</table>\n");




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>DSCP-SIG</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>VR_ID</th><th align=center>CLASS_ID</th><th align=center>DSCP</th></tr>\n");			      


foreach $_(@dscpsig){


@_ = split (/,/,$_);


if ($_[0] eq "0"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
print (HTMLFILE "<td align=center>$_[1]</td>\n");
if (($_[1] eq "S1") && ($_[2] eq "34")){

      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      
      }
if (($_[1] eq "S1") && ($_[2] ne "34")){

      print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
      $dscpsiggp = "true";
      }
      
if (($_[1] eq "X2") && ($_[2] eq "34")){

      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      
      }
if (($_[1] eq "X2") && ($_[2] ne "34")){

      print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
      $dscpsiggp = "true";
      }
      
if (($_[1] eq "S1_X2U") && ($_[2] eq "34")){

      print (HTMLFILE "<td align=center>$_[2]</td>\n");
      
      }
if (($_[1] eq "S1_X2U") && ($_[2] ne "34")){

      print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
      $dscpsiggp = "true";
      }      
            
      
      
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          

}
}

print (HTMLFILE "</table>\n");






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=14 bgcolor=#EEEEEE><b>SON-ANR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MAX_NRTSIZE</th><th align=center>LSM_USAGE_FLAG</th><th align=center>RANK_PERIOD</th><th align=center>FILTERING_COEFF</th><th align=center>NR_DEL_FLAG</th><th align=center>TH_TIME_NR_DEL</th><th align=center>TH_NUM_MR_NR_DEL</th><th align=center>WRONG_NR_DEL_FLAG</th><th align=center>TH_HO_ATT_NR_DEL</th><th align=center>TH_HO_SUCC_NR_DEL</th><th align=center>IRAT_RANK_PERIOD</th><th align=center>IRAT_FILTERING_COEFF</th><th align=center>MAX_X2_NRTSIZE</th><th align=center>DEFAULT_VALUE_X2</th></tr>\n");			      


foreach $_(@sonanr){


@_ = split (/,/,$_);

if ($_[0] eq "256"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	
	
}		
if ($_[0] ne "256"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");	
$sonanrgp = "true";	
}

if ($_[1] eq "False"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$sonanrgp = "true";	
}
	
if ($_[2] eq "1day"){
print (HTMLFILE "<td align=center>$_[2]</td>\n");	
	
}		
if ($_[2] ne "1day"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");	
$sonanrgp = "true";	
}
if ($_[3] eq "0.5"){
print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	
}		
if ($_[3] ne "0.5"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
$sonanrgp = "true";	
}
if ($pkg =~ m/^3/) {  
if ($_[4] eq "False"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$sonanrgp = "true";	
}
                   }
				   
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[4] eq "True"){
print (HTMLFILE "<td align=center>$_[4]</td>\n");	
	
}		
if ($_[4] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");	
$sonanrgp = "true";	
}
                   }				   
if ($_[5] eq "1"){
print (HTMLFILE "<td align=center>$_[5]</td>\n");	
	
}		
if ($_[5] ne "1"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");	
$sonanrgp = "true";	
}

if ($_[6] eq "0"){
print (HTMLFILE "<td align=center>$_[6]</td>\n");	
	
}		
if ($_[6] ne "0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");	
$sonanrgp = "true";	
}
if ($pkg =~ m/^3/) {  
if ($_[7] eq "False"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "False"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$sonanrgp = "true";	
}
                   }
				   
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
if ($_[7] eq "True"){
print (HTMLFILE "<td align=center>$_[7]</td>\n");	
	
}		
if ($_[7] ne "True"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");	
$sonanrgp = "true";	
}
                   }
				   
if ($_[8] eq "100"){
print (HTMLFILE "<td align=center>$_[8]</td>\n");	
	
}		
if ($_[8] ne "100"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");	
$sonanrgp = "true";	
}


if ($_[9] eq "95"){
print (HTMLFILE "<td align=center>$_[9]</td>\n");	
	
}		
if ($_[9] ne "95"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");	
$sonanrgp = "true";	
}


if ($_[10] eq "1day"){
print (HTMLFILE "<td align=center>$_[10]</td>\n");	
	
}		
if ($_[10] ne "1day"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");	
$sonanrgp = "true";	
}

if ($_[11] eq "0.5"){
print (HTMLFILE "<td align=center>$_[11]</td>\n");	
	
}		
if ($_[11] ne "0.5"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");	
$sonanrgp = "true";	
}

if ($_[12] eq "252"){
print (HTMLFILE "<td align=center>$_[12]</td>\n");	
	
}		
if ($_[12] ne "252"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");	
$sonanrgp = "true";	
}

if ($_[13] eq "2.0"){
print (HTMLFILE "<td align=center>$_[13]</td>\n");	
	
}		
if ($_[13] ne "2.0"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");	
$sonanrgp = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}

print (HTMLFILE "</table>\n");






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>SON-DLICIC</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>DL_ICIC_TYPE</th></tr>\n");			      


foreach $_(@sondlic){


@_ = split (/,/,$_);

if ($_[0] <= "11"){
print (HTMLFILE "<td align=center>$_[0]</td>\n");	


if ($_[1] eq "Release"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "Release"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$sondlic = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          

}
}

print (HTMLFILE "</table>\n");



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>SON-SO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>TX_TBMAX[nano-second]</th><th align=center>RX_TBMAX[nano-second]</th></tr>\n");			      


foreach $_(@sonso){


@_ = split (/,/,$_);


if ($_[0] eq "121000"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[0] ne "121000"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$sonso = "true";	
}
if ($_[1] eq "121000"){
print (HTMLFILE "<td align=center>$_[1]</td>\n");	
	
}		
if ($_[1] ne "121000"){
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");	
$sonso = "true";	
}
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          


}

print (HTMLFILE "</table>\n");




if ($pkg =~ m/^3/) {
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=17 bgcolor=#EEEEEE><b>RTRV-SONFN-CELL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PRE OAR ANR_ENABLE</th><th align=center>POST OAR ANR_ENABLE</th><th align=center>INTER_RAT_ANR_ENABLE1_X_RTT</th><th align=center>INTER_RAT_ANR_ENABLE_HRPD</th><th align=center>MOBILITY_ROBUSTNESS_ENABLE</th><th align=center>RACH_OPT_ENABLE</th><th align=center>PERIODIC_ANR_FLAG</th><th align=center>ANR_UE_SEARCH_RATE_TOTAL[%]</th><th align=center>ANR_UE_SEARCH_RATE_INTRA_FREQ[%]</th><th align=center>ANR_UE_SEARCH_RATE_INTER_FREQ[%]</th><th align=center>ANR_UE_SEARCH_RATE_C1_XRTT[%]</th><th align=center>ANR_MEAS_DURATION_INTER_FREQ[sec]</th><th align=center>ANR_MEAS_DURATION_C1_XRTT[sec]</th><th align=center>ANR_MEAS_DURATION_HRPD[sec]</th><th align=center>PCI_DRC_FLAG</th><th align=center>RSI_CONFLICT_ENABLE</th></tr>\n");  
  
foreach $_(@sonfn){

@_ = split (/,/,$_);
if ($_[0] <= 11){
      
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "Off"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "Off"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $sonfngp = "true";
    } 
    if ($_[1] eq "Auto"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "Auto"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $sonfngp = "true";
    } 
    if ($_[2] eq "Off"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "Off"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $sonfngp = "true";
    }      

    if ($_[3] eq "Off"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "Off"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $sonfngp = "true";
    }    
    
    if ($_[4] eq "Off"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "Off"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    $sonfngp = "true";
    }            


    if ($_[5] eq "Off"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "Off"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $sonfngp = "true";
    }    

    if ($_[6] eq "False"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "False"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $sonfngp = "true";
    }  
       
    if ($_[7] eq "5"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $sonfngp = "true";
    }     
    
    if ($_[8] eq "0"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $sonfngp = "true";
    }       
    
    if ($_[9] eq "0"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $sonfngp = "true";
    }       
    
    if ($_[10] eq "100"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "100"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $sonfngp = "true";
    }   
    
    if ($_[11] eq "100"){
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    }    
    if ($_[11] ne "100"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    $sonfngp = "true";
    }     

    if ($_[12] eq "10"){
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    }    
    if ($_[12] ne "10"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    $sonfngp = "true";
    }     

    if ($_[13] eq "10"){
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    }    
    if ($_[13] ne "10"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    $sonfngp = "true";
    }   

    if ($_[14] eq "10"){
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    }    
    if ($_[14] ne "10"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    $sonfngp = "true";
    } 

    if ($_[15] eq "True"){
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    }    
    if ($_[15] ne "True"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    $sonfngp = "true";
    } 
                                    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 
                   }
if ($pkg =~ m/^4/) {
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=22 bgcolor=#EEEEEE><b>RTRV-SONFN-CELL</b></td></tr>\n");
print (HTMLFILE "<tr>
<th align=center>CELL_NUM</th>
<th align=center>ANR_ENABLE</th>
<th align=center>INTER_RAT_ANR_ENABLE1_X_RTT</th>
<th align=center>INTER_RAT_ANR_ENABLE_HRPD</th>
<th align=center>ENERGY_SAVINGS_ENABLE</th>
<th align=center>MOBILITY_ROBUSTNESS_ENABLE</th>
<th align=center>RACH_OPT_ENABLE</th>
<th align=center>PERIODIC_ANR_FLAG</th>
<th align=center>ANR_UE_SEARCH_RATE_TOTAL</th>
<th align=center>ANR_UE_SEARCH_RATE_INTRA_FREQ</th>
<th align=center>ANR_UE_SEARCH_RATE_INTER_FREQ</th>
<th align=center>ANR_UE_SEARCH_RATE_C1_XRTT</th>
<th align=center>ANR_UE_SEARCH_RATE_HRPD</th>
<th align=center>ANR_MEAS_DURATION_INTER_FREQ</th>
<th align=center>ANR_MEAS_DURATION_C1_XRTT</th>
<th align=center>ANR_MEAS_DURATION_HRPD</th>
<th align=center>PCI_DRC_FLAG</th>
<th align=center>ES_SCAILING_FACTOR_LB</th>
<th align=center>ES_SCALING_FACTOR_CAC</th>
<th align=center>RSI_CONFLICT_ENABLE</th>
<th align=center>SON_CCO_PWR_CTRL_ENABLE</th>
<th align=center>SON_COC_PWR_CTRL_ENABLE</th>
</tr>\n");

foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_SONFN_CELL) { 
my $ANR_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{ANR_ENABLE};
my $INTER_RAT_ANR_ENABLE1_X_RTT = $hash_SONFN_CELL{$CELL_NUM}{INTER_RAT_ANR_ENABLE1_X_RTT};
my $INTER_RAT_ANR_ENABLE_HRPD = $hash_SONFN_CELL{$CELL_NUM}{INTER_RAT_ANR_ENABLE_HRPD};
my $ENERGY_SAVINGS_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{ENERGY_SAVINGS_ENABLE};
my $MOBILITY_ROBUSTNESS_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{MOBILITY_ROBUSTNESS_ENABLE};
my $RACH_OPT_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{RACH_OPT_ENABLE};
my $PERIODIC_ANR_FLAG = $hash_SONFN_CELL{$CELL_NUM}{PERIODIC_ANR_FLAG};
my $ANR_UE_SEARCH_RATE_TOTAL = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_TOTAL};
my $ANR_UE_SEARCH_RATE_INTRA_FREQ = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_INTRA_FREQ};
my $ANR_UE_SEARCH_RATE_INTER_FREQ = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_INTER_FREQ};
my $ANR_UE_SEARCH_RATE_C1_XRTT = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_C1_XRTT};
my $ANR_UE_SEARCH_RATE_HRPD = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_HRPD};
my $ANR_MEAS_DURATION_INTER_FREQ = $hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_INTER_FREQ};
my $ANR_MEAS_DURATION_C1_XRTT = $hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_C1_XRTT};
my $ANR_MEAS_DURATION_HRPD = $hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_HRPD};
my $PCI_DRC_FLAG = $hash_SONFN_CELL{$CELL_NUM}{PCI_DRC_FLAG};
my $ES_SCAILING_FACTOR_LB = $hash_SONFN_CELL{$CELL_NUM}{ES_SCAILING_FACTOR_LB};
my $ES_SCALING_FACTOR_CAC = $hash_SONFN_CELL{$CELL_NUM}{ES_SCALING_FACTOR_CAC};
my $RSI_CONFLICT_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{RSI_CONFLICT_ENABLE};
my $SON_CCO_PWR_CTRL_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{SON_CCO_PWR_CTRL_ENABLE};
my $SON_COC_PWR_CTRL_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{SON_COC_PWR_CTRL_ENABLE};
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td align=center>$CELL_NUM</td>\n");

if ($ANR_ENABLE eq "$hash_sonfn_cell_values{ANR_ENABLE}") {
print (HTMLFILE "<td align=center>$ANR_ENABLE</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_ENABLE</td>\n");
}


if ($INTER_RAT_ANR_ENABLE1_X_RTT eq "$hash_sonfn_cell_values{INTER_RAT_ANR_ENABLE1_X_RTT}") {
print (HTMLFILE "<td align=center>$INTER_RAT_ANR_ENABLE1_X_RTT</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$INTER_RAT_ANR_ENABLE1_X_RTT</td>\n");
}


if ($INTER_RAT_ANR_ENABLE_HRPD eq "$hash_sonfn_cell_values{INTER_RAT_ANR_ENABLE_HRPD}") {
print (HTMLFILE "<td align=center>$INTER_RAT_ANR_ENABLE_HRPD</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$INTER_RAT_ANR_ENABLE_HRPD</td>\n");
}


if ($ENERGY_SAVINGS_ENABLE eq "$hash_sonfn_cell_values{ENERGY_SAVINGS_ENABLE}") {
print (HTMLFILE "<td align=center>$ENERGY_SAVINGS_ENABLE</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ENERGY_SAVINGS_ENABLE</td>\n");
}


if ($MOBILITY_ROBUSTNESS_ENABLE eq "$hash_sonfn_cell_values{MOBILITY_ROBUSTNESS_ENABLE}") {
print (HTMLFILE "<td align=center>$MOBILITY_ROBUSTNESS_ENABLE</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$MOBILITY_ROBUSTNESS_ENABLE</td>\n");
}


if ($RACH_OPT_ENABLE eq "$hash_sonfn_cell_values{RACH_OPT_ENABLE}") {
print (HTMLFILE "<td align=center>$RACH_OPT_ENABLE</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$RACH_OPT_ENABLE</td>\n");
}


if ($PERIODIC_ANR_FLAG eq "$hash_sonfn_cell_values{PERIODIC_ANR_FLAG}") {
print (HTMLFILE "<td align=center>$PERIODIC_ANR_FLAG</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$PERIODIC_ANR_FLAG</td>\n");
}


if ($ANR_UE_SEARCH_RATE_TOTAL eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_TOTAL}") {
print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_TOTAL</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_TOTAL</td>\n");
}


if ($ANR_UE_SEARCH_RATE_INTRA_FREQ eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_INTRA_FREQ}") {
print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_INTRA_FREQ</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_INTRA_FREQ</td>\n");
}


if ($ANR_UE_SEARCH_RATE_INTER_FREQ eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_INTER_FREQ}") {
print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_INTER_FREQ</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_INTER_FREQ</td>\n");
}


if ($ANR_UE_SEARCH_RATE_C1_XRTT eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_C1_XRTT}") {
print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_C1_XRTT</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_C1_XRTT</td>\n");
}


if ($ANR_UE_SEARCH_RATE_HRPD eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_HRPD}") {
print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_HRPD</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_HRPD</td>\n");
}


if ($ANR_MEAS_DURATION_INTER_FREQ eq "$hash_sonfn_cell_values{ANR_MEAS_DURATION_INTER_FREQ}") {
print (HTMLFILE "<td align=center>$ANR_MEAS_DURATION_INTER_FREQ</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_MEAS_DURATION_INTER_FREQ</td>\n");
}


if ($ANR_MEAS_DURATION_C1_XRTT eq "$hash_sonfn_cell_values{ANR_MEAS_DURATION_C1_XRTT}") {
print (HTMLFILE "<td align=center>$ANR_MEAS_DURATION_C1_XRTT</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_MEAS_DURATION_C1_XRTT</td>\n");
}


if ($ANR_MEAS_DURATION_HRPD eq "$hash_sonfn_cell_values{ANR_MEAS_DURATION_HRPD}") {
print (HTMLFILE "<td align=center>$ANR_MEAS_DURATION_HRPD</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_MEAS_DURATION_HRPD</td>\n");
}


if ($PCI_DRC_FLAG eq "$hash_sonfn_cell_values{PCI_DRC_FLAG}") {
print (HTMLFILE "<td align=center>$PCI_DRC_FLAG</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$PCI_DRC_FLAG</td>\n");
}


if ($ES_SCAILING_FACTOR_LB eq "$hash_sonfn_cell_values{ES_SCAILING_FACTOR_LB}") {
print (HTMLFILE "<td align=center>$ES_SCAILING_FACTOR_LB</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ES_SCAILING_FACTOR_LB</td>\n");
}


if ($ES_SCALING_FACTOR_CAC eq "$hash_sonfn_cell_values{ES_SCALING_FACTOR_CAC}") {
print (HTMLFILE "<td align=center>$ES_SCALING_FACTOR_CAC</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ES_SCALING_FACTOR_CAC</td>\n");
}


if ($RSI_CONFLICT_ENABLE eq "$hash_sonfn_cell_values{RSI_CONFLICT_ENABLE}") {
print (HTMLFILE "<td align=center>$RSI_CONFLICT_ENABLE</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$RSI_CONFLICT_ENABLE</td>\n");
}


if ($SON_CCO_PWR_CTRL_ENABLE eq "$hash_sonfn_cell_values{SON_CCO_PWR_CTRL_ENABLE}") {
print (HTMLFILE "<td align=center>$SON_CCO_PWR_CTRL_ENABLE</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$SON_CCO_PWR_CTRL_ENABLE</td>\n");
}


if ($SON_COC_PWR_CTRL_ENABLE eq "$hash_sonfn_cell_values{SON_COC_PWR_CTRL_ENABLE}") {
print (HTMLFILE "<td align=center>$SON_COC_PWR_CTRL_ENABLE</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$SON_COC_PWR_CTRL_ENABLE</td>\n");
}

print (HTMLFILE "</tr>\n");

                                                             }






print (HTMLFILE "</table>\n"); 

                   }


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>SRB-RLC</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SRB_ID</th><th align=center>TIMER_POLL_RETRANSMIT</th><th align=center>POLL_PDU</th><th align=center>POLL_BYTE</th><th align=center>MAX_RETRANSMISSION_THRESHOLD</th><th align=center>TIMER_REORDERING</th><th align=center>TIMER_STATUS_PROHIBIT</th></tr>\n");  
  
foreach $_(@srbrlc){

@_ = split (/,/,$_);
if ($_[0] <= 5){
      
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "45ms"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "45ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $srbrlc = "true";
    } 

    if ($_[2] eq "Infinity"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "Infinity"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $srbrlc = "true";
    }      

    if ($_[3] eq "Infinity"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "Infinity"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $srbrlc = "true";
    }    
    
    if ($_[4] eq "t32"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "t32"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    $srbrlc = "true";
    }            


    if ($_[5] eq "35ms"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "35ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $srbrlc = "true";
    }    

    if ($_[6] eq "45ms"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "45ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $srbrlc = "true";
    }  
       

                                    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 








print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>DSCP-SYS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CLASS_ID</th><th align=center>DSCP</th></tr>\n");  
  
foreach $_(@dscpsys){

@_ = split (/,/,$_);
if ($_[0] eq "0"){
    print (HTMLFILE "<td align=center>$_[0]</td>\n"); 
    if ($_[1] eq "32"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "32"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $dscpsysgp = "true";
    }  
         
    
}                                    

if (($_[0] eq "1") || ($_[0] eq "2") || ($_[0] eq "3")|| ($_[0] eq "4")){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    if ($_[1] eq "14"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "14"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $dscpsysgp = "true";
    }  
         
    
}                                    

if ($_[0] eq "5"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    if ($_[1] eq "48"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "48"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $dscpsysgp = "true";
    }  
         
    
}  
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    
                    
                    
print (HTMLFILE "</table>\n"); 






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>TIME-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>T300</th><th align=center>T301</th><th align=center>T302</th><th align=center>T304</th><th align=center>CCO_T304</th><th align=center>T310</th><th align=center>T311</th><th align=center>T320</th><th align=center>N310</th><th align=center>N311</th></tr>\n");  
  
foreach $_(@timeinf){

@_ = split (/,/,$_);
if ($_[0] <= 11){
      
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "400ms"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "400ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $timeinfgp = "true";
    } 

    if ($_[2] eq "400ms"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "400ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $timeinfgp = "true";
    }      

    if ($_[3] eq "4s"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "4s"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $timeinfgp = "true";
    }    

if ($pkg =~ m/^3/) {      
    if ($_[4] eq "500ms"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "500ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    $timeinfgp = "true";
    } 
                  }	
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {      
    if ($_[4] eq "1000ms"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "1000ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    $timeinfgp = "true";
    } 
                  }	

    if ($_[5] eq "1000ms"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "1000ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $timeinfgp = "true";
    }    
if ($pkg =~ m/^3/) {      
    if ($_[6] eq "1000ms"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "1000ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $timeinfgp = "true";
    }  
                   }

if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {      
    if ($_[6] eq "2000ms"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "2000ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $timeinfgp = "true";
    }  
                   }				   
    if ($_[7] eq "5000ms"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "5000ms"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $timeinfgp = "true";
    }  

    if ($_[8] eq "10min"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "10min"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $timeinfgp = "true";
    }  

	if ($pkg =~ m/^3/) {  
    if ($_[9] eq "n6"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "n6"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $timeinfgp = "true";
    }  
                      }
	if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
    if ($_[9] eq "n20"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "n20"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $timeinfgp = "true";
    }  
                      }					  
					  
    if ($_[10] eq "n1"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "n1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $timeinfgp = "true";
    } 
        
                                           
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>PLMNSIGTIMER-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>PLMN_IDX</th><th align=center>INTERNAL_SIGNALING_INACTIVITY_TIMER</th></tr>\n");  
  
foreach $_(@plmnsigtimer){

@_ = split (/,/,$_);
if ($_[0] eq "0"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "6"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "6"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $plmnsigtimergp = "true";
    } 
        
                                           
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>TRCH-BSR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>QCI</th><th align=center>PERIODIC_BSRTIMER</th><th align=center>RETX_BSRTIMER</th></tr>\n");  
  
foreach $_(@trchbsr){

@_ = split (/,/,$_);
if ($_[0] eq "0"){
      
     print (HTMLFILE "<td align=center>$_[0]</td>\n"); 
    if ($_[1] eq "sf10"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "sf10"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $trchbsrgp = "true";
    } 
        
    if ($_[2] eq "sf320"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "sf320"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $trchbsrgp = "true";
    } 
                                               
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>ULPWR-CTRL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>P0_UE_PUSCH</th><th align=center>DELTA_MCSENABLED</th><th align=center>ACCUMULATION_ENABLED</th><th align=center>P0_UE_PUCCH</th><th align=center>P_SRSOFFSET</th><th align=center>FILTER_COEFFICIENT</th></tr>\n");  
  
foreach $_(@ulpwrctrl){

@_ = split (/,/,$_);
if ($_[0] <= "11"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    if ($_[1] eq "0"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $ulpwrctrlgp = "true";
    } 
        
    if ($_[2] eq "ci_en0"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "ci_en0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $ulpwrctrlgp = "true";
    } 

    if ($_[3] eq "1"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $ulpwrctrlgp = "true";
    } 

    if ($_[4] eq "0"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    $ulpwrctrlgp = "true";
    } 

    if ($_[5] eq "7"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "7"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $ulpwrctrlgp = "true";
    } 

    if ($_[6] eq "fc4"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "fc4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $ulpwrctrlgp = "true";
    } 
                                                              
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 



if ($pkg =~ m/^3/) {  #start if $pkg match ^3
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=20 bgcolor=#EEEEEE><b>CELL-CAC</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_COUNT_CAC_USAGE</th><th align=center>MAX_CALL_COUNT</th><th align=center>CALL_CAC_THRESH_FOR_NORMAL</th><th align=center>CALL_CAC_THRESH_FOR_EMER_HO</th><th align=center>DRB_COUNT_CAC_USAGE</th><th align=center>MAX_DRB_COUNT</th><th align=center>DRB_CAC_THRESH_FOR_NORMAL</th><th align=center>DRB_CAC_THRESH_FOR_EMER_HO</th><th align=center>QOS_CAC_OPTION</th><th align=center>QOS_POLICY_OPTION</th><th align=center>PRB_REPORT_PERIOD</th><th align=center>ESTIMATION_OPT</th><th align=center>PREEMPTION_FLAG</th><th align=center>BH_BW_CAC_USAGE</th><th align=center>BH_BW_CAC_OPTION</th><th align=center>L_BREDIRECTION_USAGE</th><th align=center>ADAPTIVE_SHARING_USAGE</th><th align=center>RS_PREEMPTION_OPTION</th><th align=center>MAX_CA_CALL_COUNT</th></tr>\n");  
  
foreach $_(@cellcacgp){

@_ = split (/,/,$_);
if ($_[0] <= "11"){
###based on Renee 0309 remove all flag except CALL_CAC_THRESH_FOR_EMER_HO      

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");

    if ($_[4] eq "100"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[4] ne "100"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

    } 
	

    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
    if (($secondcar eq "true") || ($secondcar4T eq "true")){ 
     if ($_[19] eq "400") {
     print (HTMLFILE "<td align=center>$_[19]</td>\n");
    }    
    if ($_[19] ne "400"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");

    }      
    
    }
    
    if (($secondcar ne "true") && ($secondcar4T ne "true")){ 
       print (HTMLFILE "<td align=center>$_[19]</td>\n");       
              
    }          
                                                                 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 
                   }  #end if $pkg match ^3
				   
				   
if ($pkg =~ m/^4/) {  #start if $pkg match ^4
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=20 bgcolor=#EEEEEE><b>CELL-CAC</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_COUNT_CAC_USAGE</th><th align=center>MAX_CALL_COUNT</th><th align=center>CALL_CAC_THRESH_FOR_NORMAL[%]</th><th align=center>CALL_CAC_THRESH_FOR_EMER[%]</th><th align=center>CALL_CAC_THRESH_FOR_HO[%]</th><th align=center>CALL_CAC_THRESH_FOR_MO_SIG[%]</th><th align=center>CALL_CAC_THRESH_FOR_MT_ACCESS[%]</th><th align=center>DRB_COUNT_CAC_USAGE</th><th align=center>MAX_DRB_COUNT</th><th align=center>DRB_CAC_THRESH_FOR_NORMAL[%]</th><th align=center>DRB_CAC_THRESH_FOR_EMER_HO[%]</th><th align=center>QOS_CAC_OPTION</th><th align=center>QOS_POLICY_OPTION</th><th align=center>PRB_REPORT_PERIOD[s]</th><th align=center>ESTIMATION_OPT</th><th align=center>PREEMPTION_FLAG</th><th align=center>BH_BW_CAC_USAGE</th><th align=center>BH_BW_CAC_OPTION</th><th align=center>QCI_DRB_CAC_USAGE</th><th align=center>L_BREDIRECTION_USAGE</th><th align=center>ADAPTIVE_SHARING_USAGE</th><th align=center>RS_PREEMPTION_OPTION</th><th align=center>MAX_CA_CALL_COUNT</th><th align=center>LOW_CALL_REL_OPTION</th><th align=center>EMERGENCY_ARP_PRIORITY</th></tr>\n");  
  
foreach $_(@cellcacgp){

@_ = split (/,/,$_);
if ($_[0] <= "11"){
###based on Renee 0309 remove all flag except CALL_CAC_THRESH_FOR_EMER_HO      

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");

    if ($_[3] eq "90.0"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "90.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

    } 
	

    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
   # if (($secondcar eq "true") || ($secondcar4T eq "true")){ 
     #if ($_[19] eq "400") {
     #print (HTMLFILE "<td align=center>$_[19]</td>\n");
    #}    
    #if ($_[19] ne "400"){
    #print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");

    #}      
    
    #}
    
    #if (($secondcar ne "true") && ($secondcar4T ne "true")){ 
    #   print (HTMLFILE "<td align=center>$_[19]</td>\n");       
              
    #}          
    print (HTMLFILE "<td align=center>$_[19]</td>\n");
    print (HTMLFILE "<td align=center>$_[20]</td>\n");
    print (HTMLFILE "<td align=center>$_[21]</td>\n");
    print (HTMLFILE "<td align=center>$_[22]</td>\n");
 if (($secondcar eq "true") || ($secondcar4T eq "true")){ 
if ($_[23] eq "600") { 
    print (HTMLFILE "<td align=center>$_[23]</td>\n");
	} 
if ($_[23] ne "600") { 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");
	} 	
	
	                                                    }
														
	if (($secondcar ne "true") && ($secondcar4T ne "true")){
print (HTMLFILE "<td align=center>$_[23]</td>\n"); 
                                                           }	
    print (HTMLFILE "<td align=center>$_[24]</td>\n");
    print (HTMLFILE "<td align=center>$_[25]</td>\n");                                                                 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 
                   }  #end if $pkg match ^4				   
				   
				   
				   
				   

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>ENB-CAC</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CALL_COUNT_CAC_USAGE</th><th align=center>MAX_ENB_CALL_COUNT</th><th align=center>CALL_CAC_THRESH_FOR_NORMAL</th><th align=center>CALL_CAC_THRESH_FOR_EMER_HO</th><th align=center>CHECK_UE_ID_USAGE</th><th align=center>HIGH_PRIORITY_ACCESS_TYPE</th><th align=center>EMERGENCY_DURATION</th><th align=center>PLMN_ENB_CAC_USAGE</th></tr>\n");  
  
foreach $_(@encacgp){

@_ = split (/,/,$_);
if ($_[0] <= "8"){
      
    # if ($_[0] eq "use"){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # }    
    # if ($_[0] ne "use"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");

    # }  
    # if ($_[1] eq "7200"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # }    
    # if ($_[1] ne "7200"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");

    # } 
        
    # if ($_[2] eq "90"){
     print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # }    
    # if ($_[2] ne "90"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");

    # } 

    if (($_[3] eq "100") || ($_[3] eq "100.0")) {
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    else {
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

    } 
    # if ($_[4] eq "use"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # }    
    # if ($_[4] ne "use"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");

    # }  
    
    # if ($_[5] eq "normalType"){
     print (HTMLFILE "<td align=center>$_[5]</td>\n");
    # }    
    # if ($_[5] ne "normalType"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");

    # }           
    
    # if ($_[6] eq "10"){
     print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # }    
    # if ($_[6] ne "10"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");

    # }  
    # if ($_[7] eq "no_use"){
     print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # }    
    # if ($_[7] ne "no_use"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");

    # }       
    
                                                                    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 


if ($pkg =~ m/^3/) {  #start if $pkg match ^3
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>ULRESCONF-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>RESOURCE_TABLE_USAGE</th><th align=center>START_STATE_IDX</th><th align=center>UL_BANDWIDTH_LIMIT</th></tr>\n");  
  
foreach $_(@ULRESCONF){

@_ = split (/,/,$_);
if ($_[0] <= "8"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    if ($_[1] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $ULRESCONFgp = "true";
    } 
        
    if ($_[2] eq "0"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $ULRESCONFgp = "true";
    } 

    if ($_[3] eq "0"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $ULRESCONFgp = "true";
    } 
                                                              
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 
                   }	#end if $pkg match ^3
if ($pkg =~ m/^4/) {  #start if $pkg match ^4
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=5 align=center bgcolor=#EEEEEE><b>ULRESCONF-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>RESOURCE_TABLE_USAGE</th><th align=center>START_STATE_IDX</th><th align=center>END_STATE_IDX</th><th align=center>UL_BANDWIDTH_LIMIT</th></tr>\n");  
  
foreach $_(@ULRESCONF){

@_ = split (/,/,$_);
if ($_[0] <= "8"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    if ($_[1] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $ULRESCONFgp = "true";
    } 
        
    if ($_[2] eq "0"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $ULRESCONFgp = "true";
    } 

    if ($_[3] eq "3"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $ULRESCONFgp = "true";
    } 
                         
   if ($_[4] eq "0"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    $ULRESCONFgp = "true";
    } 
                        
						 
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 

                   }  #end if $pkg match ^4


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>TPC-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PUCCH_TPC_SETUP</th></tr>\n");  
  
foreach $_(@tpcconf){

@_ = split (/,/,$_);
if ($_[0] <= "11"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    if ($_[1] eq "Release"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    }    
    if ($_[1] ne "Release"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    $tpcconfgp = "true";
    } 
        
                                                             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 


if ($pkg =~ m/^3/) {  
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>EUTRA-FA</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>FA_INDEX</th><th align=center>STATUS</th><th align=center>EARFCN_UL</th><th align=center>EARFCN_DL</th><th align=center>PRIORITY</th><th align=center>Q_RX_LEV_MIN</th><th align=center>P_MAX_USAGE</th><th align=center>P_MAX[dBm]</th><th align=center>T_RESELECTION[s]</th><th align=center>SF_USAGE</th><th align=center>T_RESELECTION_SF_MEDIUM</th><th align=center>T_RESELECTION_SF_HIGH</th><th align=center>S_INTRA_SEARCH_USAGE</th><th align=center>S_INTRA_SEARCH[dB]</th><th align=center>S_NON_INTRA_SEARCH_USAGE</th><th align=center>S_NON_INTRA_SEARCH[dB]</th><th align=center>THRESH_SERVING_LOW[dB]</th><th align=center>THRESH_XHIGH[dB]</th><th align=center>THRESH_XLOW[dB]</th><th align=center>MESA_BANDWIDTH_USAGE</th><th align=center>MEASUREMENT_BANDWIDTH</th><th align=center>PRESENCE_ANT_PORT1</th><th align=center>NEIGH_CELL_CONFIG</th><th align=center>Q_OFFSET_FREQ[dB]</th><th align=center>OFFSET_FREQ[dB]</th><th align=center>S_INTRA_SEARCH_REL9_USAGE</th><th align=center>S_INTRA_SEARCH_P[dB]</th><th align=center>S_INTRA_SEARCH_Q[dB]</th><th align=center>S_NON_INTRA_SEARCH_REL9_USAGE</th><th align=center>S_NON_INTRA_SEARCH_P[dB]</th><th align=center>S_NON_INTRA_SEARCH_Q[dB]</th><th align=center>Q_QUAL_MIN_REL9_USAGE</th><th align=center>Q_QUAL_MIN_REL9</th><th align=center>THRESH_SERVING_LOW_QREL9_USAGE</th><th align=center>THRESH_SERVING_LOW_QREL9[dB]</th><th align=center>THRESH_XHIGH_QREL9[dB]</th><th align=center>THRESH_XLOW_QREL9[dB]</th><th align=center>MCC0[DIGIT]</th><th align=center>MNC0[DIGIT]</th><th align=center>PREFERENCE0</th><th align=center>PLMN0_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC1[DIGIT]</th><th align=center>MNC1[DIGIT]</th><th align=center>PREFERENCE1</th><th align=center>PLMN1_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC2[DIGIT]</th><th align=center>MNC2[DIGIT]</th><th align=center>PREFERENCE2</th><th align=center>PLMN2_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC3[DIGIT]</th><th align=center>MNC3[DIGIT]</th><th align=center>PREFERENCE3</th><th align=center>PLMN3_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC4[DIGIT]</th><th align=center>MNC4[DIGIT]</th><th align=center>PREFERENCE4</th><th align=center>PLMN4_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC5[DIGIT]</th><th align=center>MNC5[DIGIT]</th><th align=center>PREFERENCE5</th><th align=center>PLMN5_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>ANR_UE_SEARCH_RATE</th><th align=center>HANDOVER_TYPE</th><th align=center>MEAS_CYCLE_SCELL</th></tr>\n");  
  
foreach $_(@eutrafagp){

@_ = split (/,/,$_);
if ($_[1] eq "0"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    
    if ($_[2] eq "EQUIP"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "EQUIP"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $eutrafagp = "true";
    } 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");  
    if ($_[5] eq "7"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "7"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[6] eq "-62"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "-62"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[7] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[8] eq "23"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "23"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $eutrafagp = "true";
    } 
                      
    if ($_[9] eq "1"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[10] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[11] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    }    
    if ($_[11] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[12] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    }    
    if ($_[12] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[13] eq "use"){
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    }    
    if ($_[13] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    $eutrafagp = "true";
    } 
        
    if ($_[14] eq "29"){
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    }    
    if ($_[14] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[15] eq "use"){
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    }    
    if ($_[15] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    $eutrafagp = "true";
    }     

    if ($_[16] eq "5"){
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    }    
    if ($_[16] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[17] eq "3"){
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    }    
    if ($_[17] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[18] eq "0"){
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
    }    
    if ($_[18] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[19] eq "5"){
    print (HTMLFILE "<td align=center>$_[19]</td>\n");
    }         
    if ($_[19] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");
    $eutrafagp = "true";
    }  
    if ($_[20] eq "use"){
    print (HTMLFILE "<td align=center>$_[20]</td>\n");
    }    
    if ($_[20] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");
    $eutrafagp = "true";
    }  
 

    if ($_[21] eq "mbw100"){
    print (HTMLFILE "<td align=center>$_[21]</td>\n");
    }    
    if ($_[21] ne "mbw100"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");
    $eutrafagp = "true";
    }   
 
    if ($_[22] eq "True"){
    print (HTMLFILE "<td align=center>$_[22]</td>\n");
    }    
    if ($_[22] ne "True"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[23] eq "1"){
    print (HTMLFILE "<td align=center>$_[23]</td>\n");
    }    
    if ($_[23] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[24] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[24]</td>\n");
    }    
    if ($_[24] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[25] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[25]</td>\n");
    }    
    if ($_[25] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[26] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[26]</td>\n");
    }    
    if ($_[26] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[27] eq "29"){
    print (HTMLFILE "<td align=center>$_[27]</td>\n");
    }    
    if ($_[27] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[28] eq "5"){
    print (HTMLFILE "<td align=center>$_[28]</td>\n");
    }    
    if ($_[28] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[29] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[29]</td>\n");
    }    
    if ($_[29] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[30] eq "8"){
    print (HTMLFILE "<td align=center>$_[30]</td>\n");
    }    
    if ($_[30] ne "8"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[31] eq "0"){
    print (HTMLFILE "<td align=center>$_[31]</td>\n");
    }    
    if ($_[31] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[32] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[32]</td>\n");
    }    
    if ($_[32] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[33] eq "-18"){
    print (HTMLFILE "<td align=center>$_[33]</td>\n");
    }    
    if ($_[33] ne "-18"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[33]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[34] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[34]</td>\n");
    }    
    if ($_[34] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[34]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[35] eq "0"){
    print (HTMLFILE "<td align=center>$_[35]</td>\n");
    }    
    if ($_[35] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[35]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[36] eq "0"){
    print (HTMLFILE "<td align=center>$_[36]</td>\n");
    }    
    if ($_[36] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[36]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[37] eq "4"){
    print (HTMLFILE "<td align=center>$_[37]</td>\n");
    }    
    if ($_[37] ne "4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[37]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[38] eq "310"){
    print (HTMLFILE "<td align=center>$_[38]</td>\n");
    }    
    if ($_[38] ne "310"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[38]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[39] eq "120"){
    print (HTMLFILE "<td align=center>$_[39]</td>\n");
    }    
    if ($_[39] ne "120"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[39]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[40] eq "preferred_prefer"){
    print (HTMLFILE "<td align=center>$_[40]</td>\n");
    }    
    if ($_[40] ne "preferred_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[40]</td>\n");
    $eutrafagp = "true";
    }     
        
    
    if ($_[41] eq "0"){
    print (HTMLFILE "<td align=center>$_[41]</td>\n");
    }    
    if ($_[41] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[41]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[42] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[42]</td>\n");
    }    
    if ($_[42] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[42]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[43] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[43]</td>\n");
    }    
    if ($_[43] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[44] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[44]</td>\n");
    }    
    if ($_[44] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[44]</td>\n");
    $eutrafagp = "true";
    }       


    if ($_[45] eq "0"){
    print (HTMLFILE "<td align=center>$_[45]</td>\n");
    }    
    if ($_[45] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[45]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[46] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[46] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[47] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[47]</td>\n");
    }    
    if ($_[47] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[47]</td>\n");
    $eutrafagp = "true";
    }            
    if ($_[48] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[48]</td>\n");
    }    
    if ($_[48] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[48]</td>\n");
    $eutrafagp = "true";
    }   


    if ($_[49] eq "0"){
    print (HTMLFILE "<td align=center>$_[49]</td>\n");
    }    
    if ($_[49] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[49]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[50] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[50]</td>\n");
    }    
    if ($_[50] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[50]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[51] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[51]</td>\n");
    }    
    if ($_[51] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[51]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[52] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[52]</td>\n");
    }    
    if ($_[52] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[52]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[53] eq "0"){
    print (HTMLFILE "<td align=center>$_[53]</td>\n");
    }    
    if ($_[53] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[53]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[54] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[54]</td>\n");
    }    
    if ($_[54] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[54]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[55] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[55]</td>\n");
    }    
    if ($_[55] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[55]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[56] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[56]</td>\n");
    }    
    if ($_[56] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[56]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[57] eq "0"){
    print (HTMLFILE "<td align=center>$_[57]</td>\n");
    }    
    if ($_[57] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[57]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[58] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[58]</td>\n");
    }    
    if ($_[58] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[58]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[59] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[59]</td>\n");
    }    
    if ($_[59] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[59]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[60] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[60]</td>\n");
    }    
    if ($_[60] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[60]</td>\n");
    $eutrafagp = "true";
    }     
 
    if ($_[61] eq "0"){
    print (HTMLFILE "<td align=center>$_[61]</td>\n");
    }    
    if ($_[61] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[61]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[62] eq "100.0"){
    print (HTMLFILE "<td align=center>$_[62]</td>\n");
    }    
    if ($_[62] ne "100.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[62]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[63] eq "A3"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[63] ne "A3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    $eutrafagp = "true";
    }

    if ($_[64] eq "sf1280"){
    print (HTMLFILE "<td align=center>$_[64]</td>\n");
    }    
    if ($_[64] ne "sf1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[64]</td>\n");
    $eutrafagp = "true";
    }
                                                                                                                                                         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }



if ($_[1] eq "1"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");

    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");  
    if ($_[5] eq "7"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "7"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[6] eq "-62"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "-62"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[7] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[8] eq "23"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "23"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $eutrafagp = "true";
    } 
                      
    if ($_[9] eq "1"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[10] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[11] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    }    
    if ($_[11] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[12] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    }    
    if ($_[12] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[13] eq "use"){
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    }    
    if ($_[13] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    $eutrafagp = "true";
    } 
        
    if ($_[14] eq "29"){
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    }    
    if ($_[14] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[15] eq "use"){
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    }    
    if ($_[15] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    $eutrafagp = "true";
    }     

    if ($_[16] eq "5"){
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    }    
    if ($_[16] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[17] eq "3"){
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    }    
    if ($_[17] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[18] eq "0"){
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
    }    
    if ($_[18] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[19] eq "5"){
    print (HTMLFILE "<td align=center>$_[19]</td>\n");
    }    
    if ($_[19] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[20] eq "use"){
    print (HTMLFILE "<td align=center>$_[20]</td>\n");
    }    
    if ($_[20] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");
    $eutrafagp = "true";
    }  
 

    if ($_[21] eq "mbw100"){
    print (HTMLFILE "<td align=center>$_[21]</td>\n");
    }    
    if ($_[21] ne "mbw100"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");
    $eutrafagp = "true";
    }   
 
    if ($_[22] eq "True"){
    print (HTMLFILE "<td align=center>$_[22]</td>\n");
    }    
    if ($_[22] ne "True"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[23] eq "1"){
    print (HTMLFILE "<td align=center>$_[23]</td>\n");
    }    
    if ($_[23] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[24] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[24]</td>\n");
    }    
    if ($_[24] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[25] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[25]</td>\n");
    }    
    if ($_[25] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[26] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[26]</td>\n");
    }    
    if ($_[26] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[27] eq "29"){
    print (HTMLFILE "<td align=center>$_[27]</td>\n");
    }    
    if ($_[27] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[28] eq "5"){
    print (HTMLFILE "<td align=center>$_[28]</td>\n");
    }    
    if ($_[28] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[29] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[29]</td>\n");
    }    
    if ($_[29] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[30] eq "8"){
    print (HTMLFILE "<td align=center>$_[30]</td>\n");
    }    
    if ($_[30] ne "8"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[31] eq "0"){
    print (HTMLFILE "<td align=center>$_[31]</td>\n");
    }    
    if ($_[31] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[32] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[32]</td>\n");
    }    
    if ($_[32] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[33] eq "-18"){
    print (HTMLFILE "<td align=center>$_[33]</td>\n");
    }    
    if ($_[33] ne "-18"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[33]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[34] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[34]</td>\n");
    }    
    if ($_[34] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[34]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[35] eq "0"){
    print (HTMLFILE "<td align=center>$_[35]</td>\n");
    }    
    if ($_[35] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[35]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[36] eq "0"){
    print (HTMLFILE "<td align=center>$_[36]</td>\n");
    }    
    if ($_[36] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[36]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[37] eq "4"){
    print (HTMLFILE "<td align=center>$_[37]</td>\n");
    }    
    if ($_[37] ne "4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[37]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[38] eq "310"){
    print (HTMLFILE "<td align=center>$_[38]</td>\n");
    }    
    if ($_[38] ne "310"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[38]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[39] eq "120"){
    print (HTMLFILE "<td align=center>$_[39]</td>\n");
    }    
    if ($_[39] ne "120"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[39]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[40] eq "preferred_prefer"){
    print (HTMLFILE "<td align=center>$_[40]</td>\n");
    }    
    if ($_[40] ne "preferred_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[40]</td>\n");
    $eutrafagp = "true";
    }     
        
    
    if ($_[41] eq "0"){
    print (HTMLFILE "<td align=center>$_[41]</td>\n");
    }    
    if ($_[41] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[41]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[42] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[42]</td>\n");
    }    
    if ($_[42] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[42]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[43] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[43]</td>\n");
    }    
    if ($_[43] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[44] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[44]</td>\n");
    }    
    if ($_[44] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[44]</td>\n");
    $eutrafagp = "true";
    }       


    if ($_[45] eq "0"){
    print (HTMLFILE "<td align=center>$_[45]</td>\n");
    }    
    if ($_[45] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[45]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[46] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[46] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[47] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[47]</td>\n");
    }    
    if ($_[47] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[47]</td>\n");
    $eutrafagp = "true";
    }            
    if ($_[48] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[48]</td>\n");
    }    
    if ($_[48] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[48]</td>\n");
    $eutrafagp = "true";
    }   


    if ($_[49] eq "0"){
    print (HTMLFILE "<td align=center>$_[49]</td>\n");
    }    
    if ($_[49] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[49]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[50] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[50]</td>\n");
    }    
    if ($_[50] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[50]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[51] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[51]</td>\n");
    }    
    if ($_[51] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[51]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[52] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[52]</td>\n");
    }    
    if ($_[52] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[52]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[53] eq "0"){
    print (HTMLFILE "<td align=center>$_[53]</td>\n");
    }    
    if ($_[53] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[53]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[54] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[54]</td>\n");
    }    
    if ($_[54] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[54]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[55] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[55]</td>\n");
    }    
    if ($_[55] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[55]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[56] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[56]</td>\n");
    }    
    if ($_[56] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[56]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[57] eq "0"){
    print (HTMLFILE "<td align=center>$_[57]</td>\n");
    }    
    if ($_[57] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[57]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[58] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[58]</td>\n");
    }    
    if ($_[58] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[58]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[59] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[59]</td>\n");
    }    
    if ($_[59] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[59]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[60] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[60]</td>\n");
    }    
    if ($_[60] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[60]</td>\n");
    $eutrafagp = "true";
    }     
 
    if ($_[61] eq "0"){
    print (HTMLFILE "<td align=center>$_[61]</td>\n");
    }    
    if ($_[61] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[61]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[62] eq "100.0"){
    print (HTMLFILE "<td align=center>$_[62]</td>\n");
    }    
    if ($_[62] ne "100.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[62]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[63] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[63] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    $eutrafagp = "true";
    }

    if ($_[64] eq "sf1280"){
    print (HTMLFILE "<td align=center>$_[64]</td>\n");
    }    
    if ($_[64] ne "sf1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[64]</td>\n");
    $eutrafagp = "true";
    }
                                                                                                                                                         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


if ($_[1] eq "2"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    
    if ($_[2] eq "N_EQUIP"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "N_EQUIP"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $eutrafagp = "true";
    } 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");  
    if ($_[5] eq "7"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "7"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[6] eq "-62"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "-62"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[7] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[8] eq "23"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "23"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $eutrafagp = "true";
    } 
                      
    if ($_[9] eq "1"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[10] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[11] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    }    
    if ($_[11] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[12] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    }    
    if ($_[12] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[13] eq "use"){
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    }    
    if ($_[13] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    $eutrafagp = "true";
    } 
        
    if ($_[14] eq "29"){
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    }    
    if ($_[14] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[15] eq "use"){
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    }    
    if ($_[15] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    $eutrafagp = "true";
    }     

    if ($_[16] eq "5"){
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    }    
    if ($_[16] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[17] eq "3"){
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    }    
    if ($_[17] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[18] eq "0"){
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
    }    
    if ($_[18] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[19] eq "5"){
    print (HTMLFILE "<td align=center>$_[19]</td>\n");
    }    
    if ($_[19] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[20] eq "use"){
    print (HTMLFILE "<td align=center>$_[20]</td>\n");
    }    
    if ($_[20] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");
    $eutrafagp = "true";
    }  
 

    if ($_[21] eq "mbw100"){
    print (HTMLFILE "<td align=center>$_[21]</td>\n");
    }    
    if ($_[21] ne "mbw100"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");
    $eutrafagp = "true";
    }   
 
    if ($_[22] eq "True"){
    print (HTMLFILE "<td align=center>$_[22]</td>\n");
    }    
    if ($_[22] ne "True"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[23] eq "1"){
    print (HTMLFILE "<td align=center>$_[23]</td>\n");
    }    
    if ($_[23] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[24] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[24]</td>\n");
    }    
    if ($_[24] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[25] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[25]</td>\n");
    }    
    if ($_[25] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[26] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[26]</td>\n");
    }    
    if ($_[26] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[27] eq "29"){
    print (HTMLFILE "<td align=center>$_[27]</td>\n");
    }    
    if ($_[27] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[28] eq "5"){
    print (HTMLFILE "<td align=center>$_[28]</td>\n");
    }    
    if ($_[28] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[29] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[29]</td>\n");
    }    
    if ($_[29] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[30] eq "8"){
    print (HTMLFILE "<td align=center>$_[30]</td>\n");
    }    
    if ($_[30] ne "8"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[31] eq "0"){
    print (HTMLFILE "<td align=center>$_[31]</td>\n");
    }    
    if ($_[31] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[32] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[32]</td>\n");
    }    
    if ($_[32] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[33] eq "-18"){
    print (HTMLFILE "<td align=center>$_[33]</td>\n");
    }    
    if ($_[33] ne "-18"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[33]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[34] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[34]</td>\n");
    }    
    if ($_[34] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[34]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[35] eq "0"){
    print (HTMLFILE "<td align=center>$_[35]</td>\n");
    }    
    if ($_[35] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[35]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[36] eq "0"){
    print (HTMLFILE "<td align=center>$_[36]</td>\n");
    }    
    if ($_[36] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[36]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[37] eq "4"){
    print (HTMLFILE "<td align=center>$_[37]</td>\n");
    }    
    if ($_[37] ne "4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[37]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[38] eq "310"){
    print (HTMLFILE "<td align=center>$_[38]</td>\n");
    }    
    if ($_[38] ne "310"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[38]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[39] eq "120"){
    print (HTMLFILE "<td align=center>$_[39]</td>\n");
    }    
    if ($_[39] ne "120"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[39]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[40] eq "preferred_prefer"){
    print (HTMLFILE "<td align=center>$_[40]</td>\n");
    }    
    if ($_[40] ne "preferred_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[40]</td>\n");
    $eutrafagp = "true";
    }     
        
    
    if ($_[41] eq "0"){
    print (HTMLFILE "<td align=center>$_[41]</td>\n");
    }    
    if ($_[41] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[41]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[42] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[42]</td>\n");
    }    
    if ($_[42] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[42]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[43] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[43]</td>\n");
    }    
    if ($_[43] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[44] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[44]</td>\n");
    }    
    if ($_[44] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[44]</td>\n");
    $eutrafagp = "true";
    }       


    if ($_[45] eq "0"){
    print (HTMLFILE "<td align=center>$_[45]</td>\n");
    }    
    if ($_[45] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[45]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[46] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[46] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[47] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[47]</td>\n");
    }    
    if ($_[47] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[47]</td>\n");
    $eutrafagp = "true";
    }            
    if ($_[48] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[48]</td>\n");
    }    
    if ($_[48] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[48]</td>\n");
    $eutrafagp = "true";
    }   


    if ($_[49] eq "0"){
    print (HTMLFILE "<td align=center>$_[49]</td>\n");
    }    
    if ($_[49] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[49]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[50] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[50]</td>\n");
    }    
    if ($_[50] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[50]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[51] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[51]</td>\n");
    }    
    if ($_[51] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[51]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[52] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[52]</td>\n");
    }    
    if ($_[52] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[52]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[53] eq "0"){
    print (HTMLFILE "<td align=center>$_[53]</td>\n");
    }    
    if ($_[53] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[53]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[54] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[54]</td>\n");
    }    
    if ($_[54] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[54]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[55] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[55]</td>\n");
    }    
    if ($_[55] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[55]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[56] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[56]</td>\n");
    }    
    if ($_[56] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[56]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[57] eq "0"){
    print (HTMLFILE "<td align=center>$_[57]</td>\n");
    }    
    if ($_[57] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[57]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[58] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[58]</td>\n");
    }    
    if ($_[58] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[58]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[59] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[59]</td>\n");
    }    
    if ($_[59] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[59]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[60] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[60]</td>\n");
    }    
    if ($_[60] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[60]</td>\n");
    $eutrafagp = "true";
    }     
 
    if ($_[61] eq "0"){
    print (HTMLFILE "<td align=center>$_[61]</td>\n");
    }    
    if ($_[61] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[61]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[62] eq "100.0"){
    print (HTMLFILE "<td align=center>$_[62]</td>\n");
    }    
    if ($_[62] ne "100.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[62]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[63] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[63] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    $eutrafagp = "true";
    }

    if ($_[64] eq "sf1280"){
    print (HTMLFILE "<td align=center>$_[64]</td>\n");
    }    
    if ($_[64] ne "sf1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[64]</td>\n");
    $eutrafagp = "true";
    }
                                                                                                                                                         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }
    
if ($_[1] eq "3"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    
    if ($_[2] eq "EQUIP"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "EQUIP"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[3] eq "26665"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "26665"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $eutrafagp = "true";
    }     
    if ($_[4] eq "8665"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "8665"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    $eutrafagp = "true";
    }       
    
    if ($_[5] eq "5"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[6] eq "-60"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "-60"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[7] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[8] eq "23"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "23"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $eutrafagp = "true";
    } 
                      
    if ($_[9] eq "1"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[10] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[11] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    }    
    if ($_[11] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[12] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    }    
    if ($_[12] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[13] eq "use"){
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    }    
    if ($_[13] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    $eutrafagp = "true";
    } 
        
    if ($_[14] eq "29"){
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    }    
    if ($_[14] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[15] eq "use"){
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    }    
    if ($_[15] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    $eutrafagp = "true";
    }     

    if ($_[16] eq "5"){
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    }    
    if ($_[16] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[17] eq "3"){
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    }    
    if ($_[17] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[18] eq "0"){
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
    }    
    if ($_[18] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[19] eq "5"){
    print (HTMLFILE "<td align=center>$_[19]</td>\n");
    }    
    if ($_[19] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[20] eq "use"){
    print (HTMLFILE "<td align=center>$_[20]</td>\n");
    }    
    if ($_[20] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");
    $eutrafagp = "true";
    }  
 

    if ($_[21] eq "mbw25"){
    print (HTMLFILE "<td align=center>$_[21]</td>\n");
    }    
    if ($_[21] ne "mbw25"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");
    $eutrafagp = "true";
    }   
 
    if ($_[22] eq "True"){
    print (HTMLFILE "<td align=center>$_[22]</td>\n");
    }    
    if ($_[22] ne "True"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[23] eq "1"){
    print (HTMLFILE "<td align=center>$_[23]</td>\n");
    }    
    if ($_[23] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[24] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[24]</td>\n");
    }    
    if ($_[24] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[25] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[25]</td>\n");
    }    
    if ($_[25] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[26] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[26]</td>\n");
    }    
    if ($_[26] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[27] eq "29"){
    print (HTMLFILE "<td align=center>$_[27]</td>\n");
    }    
    if ($_[27] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[28] eq "5"){
    print (HTMLFILE "<td align=center>$_[28]</td>\n");
    }    
    if ($_[28] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[29] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[29]</td>\n");
    }    
    if ($_[29] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[30] eq "8"){
    print (HTMLFILE "<td align=center>$_[30]</td>\n");
    }    
    if ($_[30] ne "8"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[31] eq "0"){
    print (HTMLFILE "<td align=center>$_[31]</td>\n");
    }    
    if ($_[31] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[32] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[32]</td>\n");
    }    
    if ($_[32] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[33] eq "-18"){
    print (HTMLFILE "<td align=center>$_[33]</td>\n");
    }    
    if ($_[33] ne "-18"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[33]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[34] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[34]</td>\n");
    }    
    if ($_[34] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[34]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[35] eq "0"){
    print (HTMLFILE "<td align=center>$_[35]</td>\n");
    }    
    if ($_[35] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[35]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[36] eq "0"){
    print (HTMLFILE "<td align=center>$_[36]</td>\n");
    }    
    if ($_[36] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[36]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[37] eq "4"){
    print (HTMLFILE "<td align=center>$_[37]</td>\n");
    }    
    if ($_[37] ne "4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[37]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[38] eq "310"){
    print (HTMLFILE "<td align=center>$_[38]</td>\n");
    }    
    if ($_[38] ne "310"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[38]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[39] eq "120"){
    print (HTMLFILE "<td align=center>$_[39]</td>\n");
    }    
    if ($_[39] ne "120"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[39]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[40] eq "preferred_prefer"){
    print (HTMLFILE "<td align=center>$_[40]</td>\n");
    }    
    if ($_[40] ne "preferred_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[40]</td>\n");
    $eutrafagp = "true";
    }     
        
    
    if ($_[41] eq "0"){
    print (HTMLFILE "<td align=center>$_[41]</td>\n");
    }    
    if ($_[41] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[41]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[42] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[42]</td>\n");
    }    
    if ($_[42] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[42]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[43] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[43]</td>\n");
    }    
    if ($_[43] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[44] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[44]</td>\n");
    }    
    if ($_[44] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[44]</td>\n");
    $eutrafagp = "true";
    }       


    if ($_[45] eq "0"){
    print (HTMLFILE "<td align=center>$_[45]</td>\n");
    }    
    if ($_[45] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[45]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[46] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[46] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[47] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[47]</td>\n");
    }    
    if ($_[47] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[47]</td>\n");
    $eutrafagp = "true";
    }            
    if ($_[48] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[48]</td>\n");
    }    
    if ($_[48] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[48]</td>\n");
    $eutrafagp = "true";
    }   


    if ($_[49] eq "0"){
    print (HTMLFILE "<td align=center>$_[49]</td>\n");
    }    
    if ($_[49] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[49]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[50] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[50]</td>\n");
    }    
    if ($_[50] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[50]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[51] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[51]</td>\n");
    }    
    if ($_[51] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[51]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[52] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[52]</td>\n");
    }    
    if ($_[52] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[52]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[53] eq "0"){
    print (HTMLFILE "<td align=center>$_[53]</td>\n");
    }    
    if ($_[53] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[53]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[54] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[54]</td>\n");
    }    
    if ($_[54] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[54]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[55] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[55]</td>\n");
    }    
    if ($_[55] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[55]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[56] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[56]</td>\n");
    }    
    if ($_[56] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[56]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[57] eq "0"){
    print (HTMLFILE "<td align=center>$_[57]</td>\n");
    }    
    if ($_[57] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[57]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[58] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[58]</td>\n");
    }    
    if ($_[58] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[58]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[59] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[59]</td>\n");
    }    
    if ($_[59] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[59]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[60] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[60]</td>\n");
    }    
    if ($_[60] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[60]</td>\n");
    $eutrafagp = "true";
    }     
 
    if ($_[61] eq "0"){
    print (HTMLFILE "<td align=center>$_[61]</td>\n");
    }    
    if ($_[61] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[61]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[62] eq "100.0"){
    print (HTMLFILE "<td align=center>$_[62]</td>\n");
    }    
    if ($_[62] ne "100.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[62]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[63] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[63] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    $eutrafagp = "true";
    }

    if ($_[64] eq "sf1280"){
    print (HTMLFILE "<td align=center>$_[64]</td>\n");
    }    
    if ($_[64] ne "sf1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[64]</td>\n");
    $eutrafagp = "true";
    }
                                                                                                                                                         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }



if ($_[1] eq "4"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    
    if ($_[2] eq "N_EQUIP"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "N_EQUIP"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $eutrafagp = "true";
    } 
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");     
    
    if ($_[5] eq "5"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[6] eq "-60"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "-60"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[7] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[8] eq "23"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "23"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $eutrafagp = "true";
    } 
                      
    if ($_[9] eq "1"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[10] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[11] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    }    
    if ($_[11] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[12] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    }    
    if ($_[12] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[13] eq "use"){
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    }    
    if ($_[13] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    $eutrafagp = "true";
    } 
        
    if ($_[14] eq "29"){
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    }    
    if ($_[14] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[15] eq "use"){
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    }    
    if ($_[15] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    $eutrafagp = "true";
    }     

    if ($_[16] eq "5"){
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    }    
    if ($_[16] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[17] eq "3"){
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    }    
    if ($_[17] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[18] eq "0"){
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
    }    
    if ($_[18] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[19] eq "5"){
    print (HTMLFILE "<td align=center>$_[19]</td>\n");
    }    
    if ($_[19] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[20] eq "use"){
    print (HTMLFILE "<td align=center>$_[20]</td>\n");
    }    
    if ($_[20] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");
    $eutrafagp = "true";
    }  
 

    if ($_[21] eq "mbw25"){
    print (HTMLFILE "<td align=center>$_[21]</td>\n");
    }    
    if ($_[21] ne "mbw25"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");
    $eutrafagp = "true";
    }   
 
    if ($_[22] eq "True"){
    print (HTMLFILE "<td align=center>$_[22]</td>\n");
    }    
    if ($_[22] ne "True"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[23] eq "1"){
    print (HTMLFILE "<td align=center>$_[23]</td>\n");
    }    
    if ($_[23] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[24] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[24]</td>\n");
    }    
    if ($_[24] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[25] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[25]</td>\n");
    }    
    if ($_[25] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[26] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[26]</td>\n");
    }    
    if ($_[26] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[27] eq "29"){
    print (HTMLFILE "<td align=center>$_[27]</td>\n");
    }    
    if ($_[27] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[28] eq "5"){
    print (HTMLFILE "<td align=center>$_[28]</td>\n");
    }    
    if ($_[28] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[29] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[29]</td>\n");
    }    
    if ($_[29] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[30] eq "8"){
    print (HTMLFILE "<td align=center>$_[30]</td>\n");
    }    
    if ($_[30] ne "8"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[31] eq "0"){
    print (HTMLFILE "<td align=center>$_[31]</td>\n");
    }    
    if ($_[31] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[32] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[32]</td>\n");
    }    
    if ($_[32] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[33] eq "-18"){
    print (HTMLFILE "<td align=center>$_[33]</td>\n");
    }    
    if ($_[33] ne "-18"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[33]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[34] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[34]</td>\n");
    }    
    if ($_[34] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[34]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[35] eq "0"){
    print (HTMLFILE "<td align=center>$_[35]</td>\n");
    }    
    if ($_[35] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[35]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[36] eq "0"){
    print (HTMLFILE "<td align=center>$_[36]</td>\n");
    }    
    if ($_[36] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[36]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[37] eq "4"){
    print (HTMLFILE "<td align=center>$_[37]</td>\n");
    }    
    if ($_[37] ne "4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[37]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[38] eq "310"){
    print (HTMLFILE "<td align=center>$_[38]</td>\n");
    }    
    if ($_[38] ne "310"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[38]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[39] eq "120"){
    print (HTMLFILE "<td align=center>$_[39]</td>\n");
    }    
    if ($_[39] ne "120"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[39]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[40] eq "preferred_prefer"){
    print (HTMLFILE "<td align=center>$_[40]</td>\n");
    }    
    if ($_[40] ne "preferred_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[40]</td>\n");
    $eutrafagp = "true";
    }     
        
    
    if ($_[41] eq "0"){
    print (HTMLFILE "<td align=center>$_[41]</td>\n");
    }    
    if ($_[41] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[41]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[42] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[42]</td>\n");
    }    
    if ($_[42] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[42]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[43] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[43]</td>\n");
    }    
    if ($_[43] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[44] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[44]</td>\n");
    }    
    if ($_[44] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[44]</td>\n");
    $eutrafagp = "true";
    }       


    if ($_[45] eq "0"){
    print (HTMLFILE "<td align=center>$_[45]</td>\n");
    }    
    if ($_[45] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[45]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[46] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[46] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[47] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[47]</td>\n");
    }    
    if ($_[47] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[47]</td>\n");
    $eutrafagp = "true";
    }            
    if ($_[48] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[48]</td>\n");
    }    
    if ($_[48] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[48]</td>\n");
    $eutrafagp = "true";
    }   


    if ($_[49] eq "0"){
    print (HTMLFILE "<td align=center>$_[49]</td>\n");
    }    
    if ($_[49] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[49]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[50] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[50]</td>\n");
    }    
    if ($_[50] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[50]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[51] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[51]</td>\n");
    }    
    if ($_[51] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[51]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[52] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[52]</td>\n");
    }    
    if ($_[52] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[52]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[53] eq "0"){
    print (HTMLFILE "<td align=center>$_[53]</td>\n");
    }    
    if ($_[53] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[53]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[54] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[54]</td>\n");
    }    
    if ($_[54] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[54]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[55] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[55]</td>\n");
    }    
    if ($_[55] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[55]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[56] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[56]</td>\n");
    }    
    if ($_[56] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[56]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[57] eq "0"){
    print (HTMLFILE "<td align=center>$_[57]</td>\n");
    }    
    if ($_[57] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[57]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[58] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[58]</td>\n");
    }    
    if ($_[58] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[58]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[59] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[59]</td>\n");
    }    
    if ($_[59] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[59]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[60] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[60]</td>\n");
    }    
    if ($_[60] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[60]</td>\n");
    $eutrafagp = "true";
    }     
 
    if ($_[61] eq "0"){
    print (HTMLFILE "<td align=center>$_[61]</td>\n");
    }    
    if ($_[61] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[61]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[62] eq "100.0"){
    print (HTMLFILE "<td align=center>$_[62]</td>\n");
    }    
    if ($_[62] ne "100.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[62]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[63] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }       
    if ($_[63] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    $eutrafagp = "true";
    }

    if ($_[64] eq "sf1280"){
    print (HTMLFILE "<td align=center>$_[64]</td>\n");
    }    
    if ($_[64] ne "sf1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[64]</td>\n");
    $eutrafagp = "true";
    }
                                                                                                                                                         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }    



if ($_[1] eq "5"){
      
    print (HTMLFILE "<td align=center>$_[0]</td>\n");  
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    
    if ($_[2] eq "EQUIP"){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }    
    if ($_[2] ne "EQUIP"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[3] eq "26763"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "26763"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    $eutrafagp = "true";
    }     
    if ($_[4] eq "8763"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "8763"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $eutrafagp = "true";
    }      
    
    if ($_[5] eq "4"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[6] eq "-60"){
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    }    
    if ($_[6] ne "-60"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[7] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[8] eq "23"){
    print (HTMLFILE "<td align=center>$_[8]</td>\n");
    }    
    if ($_[8] ne "23"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    $eutrafagp = "true";
    } 
                      
    if ($_[9] eq "1"){
    print (HTMLFILE "<td align=center>$_[9]</td>\n");
    }    
    if ($_[9] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[10] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    }    
    if ($_[10] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[11] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    }    
    if ($_[11] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[12] eq "oneDot0"){
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    }    
    if ($_[12] ne "oneDot0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[13] eq "use"){
    print (HTMLFILE "<td align=center>$_[13]</td>\n");
    }    
    if ($_[13] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    $eutrafagp = "true";
    } 
        
    if ($_[14] eq "29"){
    print (HTMLFILE "<td align=center>$_[14]</td>\n");
    }    
    if ($_[14] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    $eutrafagp = "true";
    } 
    
    if ($_[15] eq "use"){
    print (HTMLFILE "<td align=center>$_[15]</td>\n");
    }    
    if ($_[15] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    $eutrafagp = "true";
    }     

    if ($_[16] eq "5"){
    print (HTMLFILE "<td align=center>$_[16]</td>\n");
    }    
    if ($_[16] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[16]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[17] eq "3"){
    print (HTMLFILE "<td align=center>$_[17]</td>\n");
    }    
    if ($_[17] ne "3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[17]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[18] eq "0"){
    print (HTMLFILE "<td align=center>$_[18]</td>\n");
    }    
    if ($_[18] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[18]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[19] eq "0"){
    print (HTMLFILE "<td align=center>$_[19]</td>\n");
    }    
    if ($_[19] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[19]</td>\n");
    $eutrafagp = "true";
    }  

    if ($_[20] eq "use"){
    print (HTMLFILE "<td align=center>$_[20]</td>\n");
    }    
    if ($_[20] ne "use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[20]</td>\n");
    $eutrafagp = "true";
    }  
 

    if ($_[21] eq "mbw25"){
    print (HTMLFILE "<td align=center>$_[21]</td>\n");
    }    
    if ($_[21] ne "mbw25"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[21]</td>\n");
    $eutrafagp = "true";
    }   
 
    if ($_[22] eq "True"){
    print (HTMLFILE "<td align=center>$_[22]</td>\n");
    }    
    if ($_[22] ne "True"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[22]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[23] eq "1"){
    print (HTMLFILE "<td align=center>$_[23]</td>\n");
    }    
    if ($_[23] ne "1"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[23]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[24] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[24]</td>\n");
    }    
    if ($_[24] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[24]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[25] eq "0dB"){
    print (HTMLFILE "<td align=center>$_[25]</td>\n");
    }    
    if ($_[25] ne "0dB"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[25]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[26] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[26]</td>\n");
    }    
    if ($_[26] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[26]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[27] eq "29"){
    print (HTMLFILE "<td align=center>$_[27]</td>\n");
    }    
    if ($_[27] ne "29"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[27]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[28] eq "5"){
    print (HTMLFILE "<td align=center>$_[28]</td>\n");
    }    
    if ($_[28] ne "5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[28]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[29] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[29]</td>\n");
    }    
    if ($_[29] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[29]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[30] eq "8"){
    print (HTMLFILE "<td align=center>$_[30]</td>\n");
    }    
    if ($_[30] ne "8"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[30]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[31] eq "0"){
    print (HTMLFILE "<td align=center>$_[31]</td>\n");
    }    
    if ($_[31] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[31]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[32] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[32]</td>\n");
    }    
    if ($_[32] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[33] eq "-18"){
    print (HTMLFILE "<td align=center>$_[33]</td>\n");
    }    
    if ($_[33] ne "-18"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[33]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[34] eq "no_use"){
    print (HTMLFILE "<td align=center>$_[34]</td>\n");
    }    
    if ($_[34] ne "no_use"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[34]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[35] eq "0"){
    print (HTMLFILE "<td align=center>$_[35]</td>\n");
    }    
    if ($_[35] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[35]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[36] eq "0"){
    print (HTMLFILE "<td align=center>$_[36]</td>\n");
    }    
    if ($_[36] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[36]</td>\n");
    $eutrafagp = "true";
    } 

    if ($_[37] eq "4"){
    print (HTMLFILE "<td align=center>$_[37]</td>\n");
    }    
    if ($_[37] ne "4"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[37]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[38] eq "310"){
    print (HTMLFILE "<td align=center>$_[38]</td>\n");
    }    
    if ($_[38] ne "310"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[38]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[39] eq "120"){
    print (HTMLFILE "<td align=center>$_[39]</td>\n");
    }    
    if ($_[39] ne "120"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[39]</td>\n");
    $eutrafagp = "true";
    } 
    if ($_[40] eq "preferred_prefer"){
    print (HTMLFILE "<td align=center>$_[40]</td>\n");
    }    
    if ($_[40] ne "preferred_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[40]</td>\n");
    $eutrafagp = "true";
    }     
        
    
    if ($_[41] eq "0"){
    print (HTMLFILE "<td align=center>$_[41]</td>\n");
    }    
    if ($_[41] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[41]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[42] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[42]</td>\n");
    }    
    if ($_[42] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[42]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[43] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[43]</td>\n");
    }    
    if ($_[43] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[44] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[44]</td>\n");
    }    
    if ($_[44] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[44]</td>\n");
    $eutrafagp = "true";
    }       


    if ($_[45] eq "0"){
    print (HTMLFILE "<td align=center>$_[45]</td>\n");
    }    
    if ($_[45] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[45]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[46] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[46] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[47] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[47]</td>\n");
    }    
    if ($_[47] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[47]</td>\n");
    $eutrafagp = "true";
    }            
    if ($_[48] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[48]</td>\n");
    }    
    if ($_[48] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[48]</td>\n");
    $eutrafagp = "true";
    }   


    if ($_[49] eq "0"){
    print (HTMLFILE "<td align=center>$_[49]</td>\n");
    }    
    if ($_[49] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[49]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[50] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[50]</td>\n");
    }    
    if ($_[50] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[50]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[51] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[51]</td>\n");
    }    
    if ($_[51] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[51]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[52] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[52]</td>\n");
    }    
    if ($_[52] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[52]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[53] eq "0"){
    print (HTMLFILE "<td align=center>$_[53]</td>\n");
    }    
    if ($_[53] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[53]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[54] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[54]</td>\n");
    }    
    if ($_[54] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[54]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[55] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[55]</td>\n");
    }    
    if ($_[55] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[55]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[56] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[56]</td>\n");
    }    
    if ($_[56] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[56]</td>\n");
    $eutrafagp = "true";
    } 


    if ($_[57] eq "0"){
    print (HTMLFILE "<td align=center>$_[57]</td>\n");
    }    
    if ($_[57] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[57]</td>\n");
    $eutrafagp = "true";
    }
    if ($_[58] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[58]</td>\n");
    }    
    if ($_[58] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[58]</td>\n");
    $eutrafagp = "true";
    }        
    if ($_[59] eq "FFF"){
    print (HTMLFILE "<td align=center>$_[59]</td>\n");
    }    
    if ($_[59] ne "FFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[59]</td>\n");
    $eutrafagp = "true";
    }    
    if ($_[60] eq "not_allowed_prefer"){
    print (HTMLFILE "<td align=center>$_[60]</td>\n");
    }    
    if ($_[60] ne "not_allowed_prefer"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[60]</td>\n");
    $eutrafagp = "true";
    }     
 
    if ($_[61] eq "0"){
    print (HTMLFILE "<td align=center>$_[61]</td>\n");
    }    
    if ($_[61] ne "0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[61]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[62] eq "100.0"){
    print (HTMLFILE "<td align=center>$_[62]</td>\n");
    }    
    if ($_[62] ne "100.0"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[62]</td>\n");
    $eutrafagp = "true";
    }   

    if ($_[63] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[63] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    $eutrafagp = "true";
    }

    if ($_[64] eq "sf1280"){
    print (HTMLFILE "<td align=center>$_[64]</td>\n");
    }    
    if ($_[64] ne "sf1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[64]</td>\n");
    $eutrafagp = "true";
    }
                                                                                                                                                         
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }    

                    } 
                    
                    
print (HTMLFILE "</table>\n");
                   }
				   
				   
if ($pkg =~ m/^4/) {  
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=88 bgcolor=#EEEEEE><b>EUTRA-FA</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>FA_INDEX</th><th align=center>STATUS</th><th align=center>EARFCN_UL</th><th align=center>EARFCN_DL</th><th align=center>PRIORITY</th><th align=center>Q_RX_LEV_MIN</th><th align=center>P_MAX_USAGE</th><th align=center>P_MAX[dBm]</th><th align=center>T_RESELECTION[s]</th><th align=center>SF_USAGE</th><th align=center>T_RESELECTION_SF_MEDIUM</th><th align=center>T_RESELECTION_SF_HIGH</th><th align=center>S_INTRA_SEARCH_USAGE</th><th align=center>S_INTRA_SEARCH[dB]</th><th align=center>S_NON_INTRA_SEARCH_USAGE</th><th align=center>S_NON_INTRA_SEARCH[dB]</th><th align=center>THRESH_SERVING_LOW[dB]</th><th align=center>THRESH_XHIGH[dB]</th><th align=center>THRESH_XLOW[dB]</th><th align=center>MESA_BANDWIDTH_USAGE</th><th align=center>MEASUREMENT_BANDWIDTH</th><th align=center>PRESENCE_ANT_PORT1</th><th align=center>NEIGH_CELL_CONFIG</th><th align=center>Q_OFFSET_FREQ[dB]</th><th align=center>OFFSET_FREQ[dB]</th><th align=center>S_INTRA_SEARCH_REL9_USAGE</th><th align=center>S_INTRA_SEARCH_P[dB]</th><th align=center>S_INTRA_SEARCH_Q[dB]</th><th align=center>S_NON_INTRA_SEARCH_REL9_USAGE</th><th align=center>S_NON_INTRA_SEARCH_P[dB]</th><th align=center>S_NON_INTRA_SEARCH_Q[dB]</th><th align=center>Q_QUAL_MIN_REL9_USAGE</th><th align=center>Q_QUAL_MIN_REL9</th><th align=center>THRESH_SERVING_LOW_QREL9_USAGE</th><th align=center>THRESH_SERVING_LOW_QREL9[dB]</th><th align=center>THRESH_XHIGH_QREL9[dB]</th><th align=center>THRESH_XLOW_QREL9[dB]</th><th align=center>MCC0[DIGIT]</th><th align=center>MNC0[DIGIT]</th><th align=center>PREFERENCE0</th><th align=center>VOICE_SUPPORT0</th><th align=center>PLMN0_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC1[DIGIT]</th><th align=center>MNC1[DIGIT]</th><th align=center>PREFERENCE1</th><th align=center>VOICE_SUPPORT1</th><th align=center>PLMN1_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC2[DIGIT]</th><th align=center>MNC2[DIGIT]</th><th align=center>PREFERENCE2</th><th align=center>VOICE_SUPPORT2</th><th align=center>PLMN2_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC3[DIGIT]</th><th align=center>MNC3[DIGIT]</th><th align=center>PREFERENCE3</th><th align=center>VOICE_SUPPORT3</th><th align=center>PLMN3_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC4[DIGIT]</th><th align=center>MNC4[DIGIT]</th><th align=center>PREFERENCE4</th><th align=center>VOICE_SUPPORT4</th><th align=center>PLMN4_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MCC5[DIGIT]</th><th align=center>MNC5[DIGIT]</th><th align=center>PREFERENCE5</th><th align=center>VOICE_SUPPORT5</th><th align=center>PLMN5_SEARCH_RATE_FOR_IDLE_LB</th><th align=center>ANR_UE_SEARCH_RATE</th><th align=center>HANDOVER_TYPE</th><th align=center>MEAS_CYCLE_SCELL</th><th align=center>ANR_ALLOW</th><th align=center>SEARCH_RATE_FOR_IDLE_LB</th><th align=center>MIN_NRTSIZE_CARRIER</th><th align=center>SEARCH_RATE_FOR_IDLE_LB_CA[%]</th><th align=center>MOBILITY_PREFERENCE</th><th align=center>OVERLAPPING_BAND_ENABLE_FLAG</th><th align=center>OVERLAPPING_EARFCN_UL</th><th align=center>OVERLAPPING_EARFCN_DL</th><th align=center>ADDITIONAL_SPECTRUM_EMISSION</th><th align=center>CELL_CAPACITY_CLASS_VALUE_DL_PER_FA</th><th align=center>CELL_CAPACITY_CLASS_VALUE_UL_PER_FA</th><th align=center>PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA</th><th align=center>PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA</th><th align=center>PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA</th><th align=center>PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA</th><th align=center>PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA</th><th align=center>PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA</th></tr>\n");
foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_EUTRA_FA) {
foreach my $FA_INDEX (sort {$a<=>$b} keys %{$hash_EUTRA_FA{$CELL_NUM}}) {
print (HTMLFILE "<tr>\n");
print (HTMLFILE "<td align=center>$CELL_NUM</td>\n");
print (HTMLFILE "<td align=center>$FA_INDEX</td>\n");
if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{STATUS} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{STATUS}") {
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{STATUS}</td>\n");
                                            }
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{STATUS}</td>\n");
}
if (($FA_INDEX eq "3") || ($FA_INDEX eq "5")) {
if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_UL} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{EARFCN_UL}") {
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_UL}</td>\n");
             }
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_UL}</td>\n");
}
                                              }
											  
else {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_UL}</td>\n");
     }										  
										  
if (($FA_INDEX eq "3") || ($FA_INDEX eq "5")) {
if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_DL} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{EARFCN_DL}") {
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_DL}</td>\n");
             }
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_DL}</td>\n");
}
                                              }
											  
else {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{EARFCN_DL}</td>\n");
     }		

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PRIORITY} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PRIORITY}") {											  
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PRIORITY}</td>\n");
                                                                                                  }
																								  
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PRIORITY}</td>\n");
     }

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_RX_LEV_MIN} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{Q_RX_LEV_MIN}") {		 
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_RX_LEV_MIN}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_RX_LEV_MIN}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{P_MAX_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{P_MAX_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{P_MAX_USAGE}</td>\n");
}

else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{P_MAX_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{P_MAX} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{P_MAX}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{P_MAX}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{P_MAX}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{T_RESELECTION}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SF_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{SF_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SF_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SF_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION_SF_MEDIUM} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{T_RESELECTION_SF_MEDIUM}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION_SF_MEDIUM}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION_SF_MEDIUM}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION_SF_HIGH} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{T_RESELECTION_SF_HIGH}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION_SF_HIGH}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{T_RESELECTION_SF_HIGH}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_INTRA_SEARCH_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_INTRA_SEARCH}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_NON_INTRA_SEARCH_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_NON_INTRA_SEARCH}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{THRESH_SERVING_LOW}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XHIGH} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{THRESH_XHIGH}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XHIGH}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XHIGH}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XLOW} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{THRESH_XLOW}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XLOW}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XLOW}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MESA_BANDWIDTH_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MESA_BANDWIDTH_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MESA_BANDWIDTH_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MESA_BANDWIDTH_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MEASUREMENT_BANDWIDTH} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MEASUREMENT_BANDWIDTH}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MEASUREMENT_BANDWIDTH}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MEASUREMENT_BANDWIDTH}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PRESENCE_ANT_PORT1} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PRESENCE_ANT_PORT1}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PRESENCE_ANT_PORT1}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PRESENCE_ANT_PORT1}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{NEIGH_CELL_CONFIG} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{NEIGH_CELL_CONFIG}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{NEIGH_CELL_CONFIG}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{NEIGH_CELL_CONFIG}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_OFFSET_FREQ} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{Q_OFFSET_FREQ}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_OFFSET_FREQ}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_OFFSET_FREQ}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OFFSET_FREQ} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{OFFSET_FREQ}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OFFSET_FREQ}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OFFSET_FREQ}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_REL9_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_INTRA_SEARCH_REL9_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_REL9_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_REL9_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_P} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_INTRA_SEARCH_P}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_P}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_P}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_Q} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_INTRA_SEARCH_Q}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_Q}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_INTRA_SEARCH_Q}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_REL9_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_NON_INTRA_SEARCH_REL9_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_REL9_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_REL9_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_P} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_NON_INTRA_SEARCH_P}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_P}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_P}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_Q} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{S_NON_INTRA_SEARCH_Q}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_Q}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{S_NON_INTRA_SEARCH_Q}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_QUAL_MIN_REL9_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{Q_QUAL_MIN_REL9_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_QUAL_MIN_REL9_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_QUAL_MIN_REL9_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_QUAL_MIN_REL9} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{Q_QUAL_MIN_REL9}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_QUAL_MIN_REL9}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{Q_QUAL_MIN_REL9}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW_QREL9_USAGE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{THRESH_SERVING_LOW_QREL9_USAGE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW_QREL9_USAGE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW_QREL9_USAGE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW_QREL9} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{THRESH_SERVING_LOW_QREL9}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW_QREL9}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_SERVING_LOW_QREL9}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XHIGH_QREL9} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{THRESH_XHIGH_QREL9}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XHIGH_QREL9}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XHIGH_QREL9}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XLOW_QREL9} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{THRESH_XLOW_QREL9}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XLOW_QREL9}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{THRESH_XLOW_QREL9}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC0} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MCC0}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC0}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC0}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC0} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MNC0}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC0}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC0}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE0} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PREFERENCE0}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE0}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE0}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT0} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{VOICE_SUPPORT0}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT0}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT0}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC1} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MCC1}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC1}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC1}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC1} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MNC1}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC1}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC1}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE1} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PREFERENCE1}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE1}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE1}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT1} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{VOICE_SUPPORT1}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT1}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT1}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC2} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MCC2}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC2}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC2}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC2} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MNC2}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC2}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC2}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE2} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PREFERENCE2}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE2}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE2}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT2} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{VOICE_SUPPORT2}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT2}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT2}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC3} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MCC3}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC3}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC3}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC3} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MNC3}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC3}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC3}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE3} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PREFERENCE3}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE3}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE3}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT3} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{VOICE_SUPPORT3}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT3}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT3}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC4} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MCC4}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC4}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC4}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC4} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MNC4}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC4}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC4}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE4} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PREFERENCE4}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE4}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE4}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT4} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{VOICE_SUPPORT4}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT4}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT4}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC5} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MCC5}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC5}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MCC5}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC5} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MNC5}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC5}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MNC5}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE5} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PREFERENCE5}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE5}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PREFERENCE5}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT5} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{VOICE_SUPPORT5}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT5}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{VOICE_SUPPORT5}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ANR_UE_SEARCH_RATE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{ANR_UE_SEARCH_RATE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ANR_UE_SEARCH_RATE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ANR_UE_SEARCH_RATE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{HANDOVER_TYPE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{HANDOVER_TYPE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{HANDOVER_TYPE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{HANDOVER_TYPE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MEAS_CYCLE_SCELL} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MEAS_CYCLE_SCELL}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MEAS_CYCLE_SCELL}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MEAS_CYCLE_SCELL}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ANR_ALLOW} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{ANR_ALLOW}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ANR_ALLOW}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ANR_ALLOW}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MIN_NRTSIZE_CARRIER} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MIN_NRTSIZE_CARRIER}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MIN_NRTSIZE_CARRIER}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MIN_NRTSIZE_CARRIER}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB_CA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB_CA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MOBILITY_PREFERENCE} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{MOBILITY_PREFERENCE}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MOBILITY_PREFERENCE}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{MOBILITY_PREFERENCE}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_BAND_ENABLE_FLAG} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{OVERLAPPING_BAND_ENABLE_FLAG}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_BAND_ENABLE_FLAG}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_BAND_ENABLE_FLAG}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_EARFCN_UL} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{OVERLAPPING_EARFCN_UL}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_EARFCN_UL}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_EARFCN_UL}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_EARFCN_DL} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{OVERLAPPING_EARFCN_DL}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_EARFCN_DL}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{OVERLAPPING_EARFCN_DL}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ADDITIONAL_SPECTRUM_EMISSION} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{ADDITIONAL_SPECTRUM_EMISSION}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ADDITIONAL_SPECTRUM_EMISSION}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{ADDITIONAL_SPECTRUM_EMISSION}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_DL_PER_FA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{CELL_CAPACITY_CLASS_VALUE_UL_PER_FA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN0_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN1_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN2_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN3_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN4_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}

if ($hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA} eq "$hash_EUTRA_FA_INFO{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA}") {	
print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}
else {
print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$CELL_NUM}{$FA_INDEX}{PLMN5_SEARCH_RATE_FOR_IDLE_LB_CA}</td>\n");
}

print (HTMLFILE "</tr>\n"); 


                                                                        }
 												          }
print (HTMLFILE "</table>\n");

                   }				   
	
 

###### 2nd carrier add gp check




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CA-COLOC</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>RELATION_INDEX</th><th align=center>STATUS</th><th align=center>COLOCATED_CELL_NUM</th></tr>\n");  
  
foreach $_(@encacoloc){

@_ = split (/,/,$_);
if (($_[0] <= "5") && ($_[1] eq "0") && ($secondcar eq "true")){


    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    
    if (($_[2] eq "EQUIP") && ($secondcar eq "true")){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }         
    if (($_[2] ne "EQUIP") && ($secondcar eq "true")){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }           
    if (($_[2] ne "EQUIP") && ($secondcar ne "true")){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }     
    if (($_[2] eq "EQUIP") && ($secondcar ne "true")){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }       
	
	if (($_[0] eq "0") && ($_[3] eq "3")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "0") && ($_[3] ne "3")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}	
	if (($_[0] eq "1") && ($_[3] eq "4")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "1") && ($_[3] ne "4")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}	
	if (($_[0] eq "2") && ($_[3] eq "5")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "2") && ($_[3] ne "5")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}	

	if (($_[0] eq "3") && ($_[3] eq "0")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "3") && ($_[3] ne "0")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "4") && ($_[3] eq "1")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "4") && ($_[3] ne "1")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "5") && ($_[3] eq "2")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "5") && ($_[3] ne "2")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}
	
    #print (HTMLFILE "<td align=center>$_[3]</td>\n");                                                             
    #print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }
if ((($_[0] <= "2") || (($_[0] >= "9") && ($_[0] <= "11"))) && ($_[1] eq "0") && ($secondcar4T eq "true")){


    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    
    if (($_[2] eq "EQUIP") && ($secondcar4T eq "true")){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }         
    if (($_[2] ne "EQUIP") && ($secondcar4T eq "true")){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    }           
    if (($_[2] ne "EQUIP") && ($secondcar4T ne "true")){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }     
    if (($_[2] eq "EQUIP") && ($secondcar4T ne "true")){
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    }       
	
	if (($_[0] eq "0") && ($_[3] eq "9")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "0") && ($_[3] ne "9")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}	
	if (($_[0] eq "1") && ($_[3] eq "10")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "1") && ($_[3] ne "10")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}	
	if (($_[0] eq "2") && ($_[3] eq "11")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "2") && ($_[3] ne "11")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}



	if (($_[0] eq "9") && ($_[3] eq "0")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "9") && ($_[3] ne "0")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "10") && ($_[3] eq "1")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "10") && ($_[3] ne "1")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "11") && ($_[3] eq "2")){
		print (HTMLFILE "<td align=center>$_[3]</td>\n");	
	}
	if (($_[0] eq "11") && ($_[3] ne "2")){
		print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");	
	}

	
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }

                    } 
                    
                    
print (HTMLFILE "</table>\n"); 






print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CACELL-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CA_AVAILABLE_TYPE</th><th align=center>P_CELL_ONLY_FLAG</th><th align=center>MAX_DL_CA_CC_NUM</th><th align=center>MAX_UL_CA_CC_NUM</th><th align=center>CA_OPERATION_MODE</th></tr>\n");  
  
foreach $_(@encacellinfo){

@_ = split (/,/,$_);
if ($_[0] <= "11"){
      
    if (($secondcar eq "true") && ($_[0] <= "5")){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       if ($_[1] eq "DL_Only"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "DL_Only"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[2]</td>\n");
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
       print (HTMLFILE "<td align=center>$_[4]</td>\n");
       print (HTMLFILE "<td align=center>$_[5]</td>\n");

    }  
    if (($thirdcar eq "true") && ($_[0] <= "8")){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       if ($_[1] eq "DL_Only"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "DL_Only"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[2]</td>\n");
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
       print (HTMLFILE "<td align=center>$_[4]</td>\n");
       print (HTMLFILE "<td align=center>$_[5]</td>\n");

    } 	
    if ((($_[0] <= "2") || (($_[0] >= "9") && ($_[0] <= "11"))) && ($secondcar4T eq "true")){    
             
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       if ($_[1] eq "DL_Only"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "DL_Only"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[2]</td>\n");
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
       print (HTMLFILE "<td align=center>$_[4]</td>\n");
       print (HTMLFILE "<td align=center>$_[5]</td>\n");

    }     
          
    if (($secondcar ne "true") && ($secondcar4T ne "true")){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       if ($_[1] eq "CA_OFF"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "CA_OFF"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[2]</td>\n");
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
       print (HTMLFILE "<td align=center>$_[4]</td>\n");
       print (HTMLFILE "<td align=center>$_[5]</td>\n");
          
          
          
    }        
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
    }

                    } 
                    
                    
print (HTMLFILE "</table>\n"); 


if ($secondcar eq "true"){


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CA INTER FREQ</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>FA_INDEX</th><th align=center>ACTIVE_STATE</th><th align=center>A5_THRESHOLD1_RSRP</th><th align=center>A5_THRESHOLD2_RSRP</th></tr>\n");  
  
foreach $_(@CaInterFreq){

@_ = split (/,/,$_);
if ($_[0] <= "5"){


    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    if ($_[3] eq "Inactive"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "Inactive"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    }      
    if ($_[4] eq "35"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "35"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    } 
    if ($_[5] eq "40"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "40"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    }         
                                                                 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>HANDOVER TYPE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>FA_INDEX</th><th align=center>HANDOVER_TYPE</th></tr>\n");  
  
foreach $_(@eutrafagp){

@_ = split (/,/,$_);
if ($_[0] <= "5"){

    if ($_[1] eq "1"){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
if ($pkg =~ m/^3/) {  
    if ($_[63] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[63] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    }  

                   }   

if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
    if ($hash_EUTRA_FA{$_[0]}{$_[1]}{HANDOVER_TYPE} eq "A5"){
    print (HTMLFILE "<td align=center>$hash_EUTRA_FA{$_[0]}{$_[1]}{HANDOVER_TYPE}</td>\n");
    }    
    if ($hash_EUTRA_FA{$_[0]}{$_[1]}{HANDOVER_TYPE} ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$hash_EUTRA_FA{$_[0]}{$_[1]}{HANDOVER_TYPE}</td>\n");
    }  

                   }    				   

    }                                                             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 

}








if ($secondcar4T eq "true"){


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CA INTER FREQ</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PURPOSE</th><th align=center>FA_INDEX</th><th align=center>ACTIVE_STATE</th><th align=center>A5_THRESHOLD1_RSRP</th><th align=center>A5_THRESHOLD2_RSRP</th></tr>\n");  
  
foreach $_(@CaInterFreq){

@_ = split (/,/,$_);
if (($_[0] <= "2") || ($_[0] >= "9") || ($_[0] <= "11")){


    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    if ($_[3] eq "Inactive"){
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    }    
    if ($_[3] ne "Inactive"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    }      
    if ($_[4] eq "35"){
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    }    
    if ($_[4] ne "35"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    } 
    if ($_[5] eq "40"){
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    }    
    if ($_[5] ne "40"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    }         
                                                                 
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>HANDOVER TYPE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>FA_INDEX</th><th align=center>HANDOVER_TYPE</th></tr>\n");  
  
foreach $_(@eutrafagp){

@_ = split (/,/,$_);
if (($_[0] <= "2") || ($_[0] >= "9") || ($_[0] <= "11")){

    if ($_[1] eq "1"){
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
if ($pkg =~ m/^3/) {  
    if ($_[63] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[63] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    }      
                   }
				   
if ($pkg =~ m/^4/) {  
    if ($_[69] eq "A5"){
    print (HTMLFILE "<td align=center>$_[63]</td>\n");
    }    
    if ($_[69] ne "A5"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[63]</td>\n");
    }      
                   }				   
				   
				   
    }                                                             
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 

}

if ($pkg =~ m/^3/) {  
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>PUCCHCONF-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CA_CSI_ACK_USAGE</th><th align=center>FORCED_MODE</th><th align=center>PUCCH_BLANKING_PRBS</th></tr>\n");  
  
foreach $_(@pucchconf){

@_ = split (/,/,$_);
if ($_[0] <= "11"){
      
      
      
    if (($secondcar eq "true") && ($_[0] <= "5")){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       if ($_[1] eq "use"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[2]</td>\n");
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
          
          
          
    } 
    if (($secondcar4T eq "true") && (($_[0] <= "2") || ($_[0] >= "9") || ($_[0] <= "11"))){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       if ($_[1] eq "use"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[2]</td>\n");
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
          
          
          
    }             
    if (($secondcar ne "true") && ($secondcar4T ne "true") && ($_[0] <= "2")){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       if ($_[1] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[2]</td>\n");
       print (HTMLFILE "<td align=center>$_[3]</td>\n");

          
          
          
    }        

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                              
                              
    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 
 
                    }
					
if ($pkg =~ m/^4/) { 

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>PUCCHCONF-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>SPS_ACK_USAGE</th><th align=center>CA_CSI_ACK_USAGE</th><th align=center>FORCED_MODE</th><th align=center>PUCCH_BLANKING_PRBS</th><th align=center>PUCCH_CONF_IDLE_PARA1</th></tr>\n");  
  
foreach $_(@pucchconf){

@_ = split (/,/,$_);
if ($_[0] <= "11"){
      
      
      
    if (($secondcar eq "true") && ($_[0] <= "5")){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
	   print (HTMLFILE "<td align=center>$_[1]</td>\n");
       if ($_[2] eq "use"){
             print (HTMLFILE "<td align=center>$_[2]</td>\n");
             }   
       if ($_[2] ne "use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
       print (HTMLFILE "<td align=center>$_[4]</td>\n");
       print (HTMLFILE "<td align=center>$_[5]</td>\n");
      
          
          
    } 
    if (($secondcar4T eq "true") && (($_[0] <= "2") || ($_[0] >= "9") || ($_[0] <= "11"))){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
      print (HTMLFILE "<td align=center>$_[1]</td>\n");	   
       if ($_[2] eq "use"){
             print (HTMLFILE "<td align=center>$_[2]</td>\n");
             }   
       if ($_[2] ne "use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
       print (HTMLFILE "<td align=center>$_[4]</td>\n");
       print (HTMLFILE "<td align=center>$_[5]</td>\n");         
          
          
    }             
    if (($secondcar ne "true") && ($secondcar4T ne "true") && ($_[0] <= "2")){
          
       print (HTMLFILE "<td align=center>$_[0]</td>\n");
       print (HTMLFILE "<td align=center>$_[1]</td>\n");	   
       if ($_[2] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[2]</td>\n");
             }   
       if ($_[2] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
             }           
       print (HTMLFILE "<td align=center>$_[3]</td>\n");
       print (HTMLFILE "<td align=center>$_[4]</td>\n");
       print (HTMLFILE "<td align=center>$_[5]</td>\n");
          
          
          
    }        

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
                              
                              
    }


                    } 
                    
                    
print (HTMLFILE "</table>\n"); 
                   }

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CASCHED-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SCHEDULABILITY_UNIT</th></tr>\n");  
if ($pkg =~ m/^3/) {    
foreach $_(@encasched){

@_ = split (/,/,$_);
     
      
      
    if (($secondcar eq "true") || ($secondcar4T eq "true")){
          
       if ($_[0] eq "ColocatedCell"){
             print (HTMLFILE "<td align=center>$_[0]</td>\n");
             }   
       if ($_[0] ne "ColocatedCell"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
             }            
    }        
    if (($secondcar ne "true") && ($secondcar4T ne "true")){
          
       if ($_[0] eq "IntraEnb"){
             print (HTMLFILE "<td align=center>$_[0]</td>\n");
             }   
       if ($_[0] ne "IntraEnb"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
     
    }        

    }

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    } 
                    
                  } 

if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {    
foreach $_(@encasched){

@_ = split (/,/,$_);
     
          
       if ($_[0] eq "IntraEnb"){
             print (HTMLFILE "<td align=center>$_[0]</td>\n");
             }   
       if ($_[0] ne "IntraEnb"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");
     
    }        



    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    } 
                    
                  } 


				  
print (HTMLFILE "</table>\n"); 




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CABAND-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>BAND_COMBINATION_LIST_INDEX</th><th align=center>STATUS</th><th align=center>BAND0_USAGE</th><th align=center>BAND_INDICATOR0</th><th align=center>CA_BANDWIDTH_CLASS_DL0</th><th align=center>BAND1_USAGE</th><th align=center>BAND_INDICATOR1</th><th align=center>CA_BANDWIDTH_CLASS_DL1</th></tr>\n");  
  
foreach $_(@cabandinfo){

@_ = split (/,/,$_);
     
      
      
    if ((($secondcar eq "true") && ($_[0] eq "0")) || (($secondcar4T eq "true") && ($_[0] eq "0"))){
       print (HTMLFILE "<td align=center>$_[0]</td>\n");   
       if ($_[1] eq "use"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }     
       if ($_[2] eq "use"){
             print (HTMLFILE "<td align=center>$_[2]</td>\n");
             }   
       if ($_[2] ne "use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
             }               
       if ($_[3] eq "41"){
             print (HTMLFILE "<td align=center>$_[3]</td>\n");
             }   
       if ($_[3] ne "41"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
             }               
       if ($_[4] eq "BwClass_c"){
             print (HTMLFILE "<td align=center>$_[4]</td>\n");
             }   
       if ($_[4] ne "BwClass_c"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
             }               
       if ($_[5] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[5]</td>\n");
             }   
       if ($_[5] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
             }               
       if ($_[6] eq "5"){
             print (HTMLFILE "<td align=center>$_[6]</td>\n");
             }   
       if ($_[6] ne "5"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
             }               
       if ($_[7] eq "BwClass_c"){
             print (HTMLFILE "<td align=center>$_[7]</td>\n");
             }   
       if ($_[7] ne "BwClass_c"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
             }                      
    }        

    if ((($secondcar eq "true") && ($_[0] eq "1")) || (($secondcar4T eq "true") && ($_[0] eq "1"))){
       print (HTMLFILE "<td align=center>$_[0]</td>\n");   
       if ($_[1] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }     
       if ($_[2] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[2]</td>\n");
             }   
       if ($_[2] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
             }               
       if ($_[3] eq "41"){
             print (HTMLFILE "<td align=center>$_[3]</td>\n");
             }   
       if ($_[3] ne "41"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
             }               
       if ($_[4] eq "BwClass_a"){
             print (HTMLFILE "<td align=center>$_[4]</td>\n");
             }   
       if ($_[4] ne "BwClass_a"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
             }               
       if ($_[5] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[5]</td>\n");
             }   
       if ($_[5] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
             }               
       if ($_[6] eq "41"){
             print (HTMLFILE "<td align=center>$_[6]</td>\n");
             }   
       if ($_[6] ne "41"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
             }               
       if ($_[7] eq "BwClass_a"){
             print (HTMLFILE "<td align=center>$_[7]</td>\n");
             }   
       if ($_[7] ne "BwClass_a"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
             }                      
    }        

    if ((($secondcar eq "true") && ($_[0] eq "2")) || (($secondcar4T eq "true") && ($_[0] eq "2"))){
       print (HTMLFILE "<td align=center>$_[0]</td>\n");   
       if ($_[1] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }     
       if ($_[2] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[2]</td>\n");
             }   
       if ($_[2] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
             }               
       if ($_[3] eq "41"){
             print (HTMLFILE "<td align=center>$_[3]</td>\n");
             }   
       if ($_[3] ne "41"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
             }               
       if ($_[4] eq "BwClass_c"){
             print (HTMLFILE "<td align=center>$_[4]</td>\n");
             }   
       if ($_[4] ne "BwClass_c"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
             }               
       if ($_[5] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[5]</td>\n");
             }   
       if ($_[5] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
             }               
       if ($_[6] eq "5"){
             print (HTMLFILE "<td align=center>$_[6]</td>\n");
             }   
       if ($_[6] ne "5"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
             }               
       if ($_[7] eq "BwClass_c"){
             print (HTMLFILE "<td align=center>$_[7]</td>\n");
             }   
       if ($_[7] ne "BwClass_c"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
             }                      
    } 
    
####1st carrier

    if ((($secondcar ne "true") && (($_[0] eq "0") || ($_[0] eq "1") || ($_[2] eq "2"))) && (($secondcar4T ne "true") && (($_[0] eq "0") || ($_[0] eq "1") || ($_[2] eq "2")))){
       print (HTMLFILE "<td align=center>$_[0]</td>\n");   
       if ($_[1] eq "use"){
             print (HTMLFILE "<td align=center>$_[1]</td>\n");
             }   
       if ($_[1] ne "use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
             }     
       if ($_[2] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[2]</td>\n");
             }   
       if ($_[2] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
             }               
       if ($_[3] eq "1"){
             print (HTMLFILE "<td align=center>$_[3]</td>\n");
             }   
       if ($_[3] ne "1"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
             }               
       if ($_[4] eq "BwClass_a"){
             print (HTMLFILE "<td align=center>$_[4]</td>\n");
             }   
       if ($_[4] ne "BwClass_a"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
             }               
       if ($_[5] eq "no_use"){
             print (HTMLFILE "<td align=center>$_[5]</td>\n");
             }   
       if ($_[5] ne "no_use"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
             }               
       if ($_[6] eq "5"){
             print (HTMLFILE "<td align=center>$_[6]</td>\n");
             }   
       if ($_[6] ne "5"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
             }               
       if ($_[7] eq "BwClass_a"){
             print (HTMLFILE "<td align=center>$_[7]</td>\n");
             }   
       if ($_[7] ne "BwClass_a"){
             print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
             }                      
    }        

     print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");   
                    } 
                    
                    
print (HTMLFILE "</table>\n"); 




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>Cell DEACTIVATION TIMER</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>S_CELL_DEACTIVATION_TIMER</th></tr>\n");  
  

@_ = split (/,/,$timer_data);

if ($pkg =~ m/^3/) {  
    if ($_[46] eq "1280"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[46] ne "1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    }      

                   }

if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {  
    if ($_[48] eq "1280"){
    print (HTMLFILE "<td align=center>$_[46]</td>\n");
    }    
    if ($_[48] ne "1280"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[46]</td>\n");
    }      

                   }
				   

    print (HTMLFILE "</tr>\n");

                    
                    
print (HTMLFILE "</table>\n"); 

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>UE CANDIDATE FLAG</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CA_UE_CANDIDATE_FLAG</th></tr>\n");  
  
foreach $_(@actlb){

@_ = split (/,/,$_);
     
if ($pkg =~ m/^3/) {       

    if ($_[43] eq "OFF"){
    print (HTMLFILE "<td align=center>$_[43]</td>\n");
    }    
    if ($_[43] ne "OFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[43]</td>\n");
    }      
                   }
if (($pkg =~ m/^4/)||($pkg =~ m/^5/)) {       

    if ($_[32] eq "OFF"){
    print (HTMLFILE "<td align=center>$_[32]</td>\n");
    }    
    if ($_[32] ne "OFF"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[32]</td>\n");
    }      
                   }                                                                 
    
    print (HTMLFILE "</tr>\n");

                    
   }                 
                    
print (HTMLFILE "</table>\n"); 



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>ALD INVT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONN_BD_ID</th><th align=center>CONN_PORT_ID</th><th align=center>ALD_ID</th><th align=center>UNIT_ID</th><th align=center>FAMILY_TYPE</th><th align=center>TYPE_NUM</th><th align=center>VERSION</th><th align=center>FW_VERSION</th><th align=center>SERIAL</th><th align=center>ANT_NUM/SUBUNIT_NUM</th><th align=center>POSITION</th></tr>\n");  
  
foreach $_(@aldinvt){

@_ = split (/,/,$_);
     

if ($_[5] eq "AS-RCU100"){     
    
    
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
          
    if ($_[7] eq "1.1.3"){
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    }    
    if ($_[7] ne "1.1.3"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    }      
    print (HTMLFILE "<td align=center>$_[8]</td>\n");      
    print (HTMLFILE "<td align=center>$_[9]</td>\n");      
    print (HTMLFILE "<td align=center>$_[10]</td>\n");      
}   
if ($_[5] ne "AS-RCU100"){     
    
    
    
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");    
    print (HTMLFILE "<td align=center>$_[8]</td>\n");      
    print (HTMLFILE "<td align=center>$_[9]</td>\n");      
    print (HTMLFILE "<td align=center>$_[10]</td>\n");      
}  
                                                              
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    
   }                 
                    
print (HTMLFILE "</table>\n"); 

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CELL-UECNT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>ACTIVE_UECOUNT</th><th align=center>EMER_AC_UECOUNT</th><th align=center>H_PRIORITY_AC_UECOUNT</th><th align=center>M_TERM_AC_UECOUNT</th><th align=center>M_ORG_SIGNAL_AC_UECOUNT</th><th align=center>M_ORG_DATA_AC_UECOUNT</th><th align=center>RELOCATE_HOCOUNT</th><th align=center>DTA_UECOUNT</th></tr>\n");  
  
foreach $_(@celluecnt){

@_ = split (/,/,$_);
        
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    print (HTMLFILE "<td align=center>$_[6]</td>\n");
    print (HTMLFILE "<td align=center>$_[7]</td>\n");    
    print (HTMLFILE "<td align=center>$_[8]</td>\n");      
    

                                                              
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    
   }                 
                    
print (HTMLFILE "</table>\n"); 

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CELL-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>OPERATIONAL_STATE</th><th align=center>USAGE_STATE</th></tr>\n");  
  
foreach $_(@cellstsman){

@_ = split (/,/,$_);
        
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "enabled"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    } 
    if ($_[1] ne "enabled"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    } 
    print (HTMLFILE "<td align=center>$_[2]</td>\n");                                                                  
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    
   }                 
                    
print (HTMLFILE "</table>\n"); 




print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CELL-DATA</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_TXPATH_TYPE</th></tr>\n");  
  
foreach $_(@celldata){

@_ = split (/,/,$_);

if ($DL_ANT_COUNT eq "8T8R"){        
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "SELECT_ABCDEFGH"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    } 
    if ($_[1] ne "SELECT_ABCDEFGH"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    }                                                                
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
}
if ($DL_ANT_COUNT eq "4T4R"){        
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    if ($_[1] eq "SELECT_ABCD"){
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    } 
    if ($_[1] ne "SELECT_ABCD"){
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    }                                                                
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");
}

                    
   }                 
                    
print (HTMLFILE "</table>\n"); 


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CARD INSTALLED</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>Address</th><th align=center>HWtype</th><th align=center>HWaddress</th><th align=center>Flags_Mask</th><th align=center>Iface</th></tr>\n");  
  
foreach $_(@slot1){

@_ = split (/,/,$_);
        
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    

                                                              
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    
   }                 
foreach $_(@slot2){

@_ = split (/,/,$_);
        
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    

                                                              
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    
   }
foreach $_(@slot3){

@_ = split (/,/,$_);
        
    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n");
    print (HTMLFILE "<td align=center>$_[4]</td>\n");    
    

                                                              
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");

                    
   }    
   
                        
print (HTMLFILE "</table>\n"); 


############
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-ALM-LIST</b></td></tr>\n");



if ($alarm_data[0] eq "THERE ARE NO 4G ALARMS"){
          
print (HTMLFILE "<tr><th align=center>NO ALARMS</th></tr>\n");  

    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
          
                                   }                      
else {
          
print (HTMLFILE "<tr><th align=center>UNIT_TYPE</th><th align=center>ALARM_TYPE</th><th align=center>LOCATION</th><th align=center>RAISED_Date</th><th align=center>RAISED_TIME</th><th align=center>ALARM_GROUP</th><th align=center>PROBABLE_CAUSE</th><th align=center>SEVERITY</th><th align=center>ALARM_CODE</th><th align=center>INFO</th><th align=center>SEQUENCE_ID</th></tr>\n");       



foreach $_(@alarm_data){
          
@_ = split (/,/,$_); 
 
    
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");  
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");     
    print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n");          
          
                       }
                       
                      
                       
     }     
          
                     
                     
print (HTMLFILE "</table>\n"); 





                    
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-ALM-LOG</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>LOG_NO</th><th align=center>UNIT_TYPE</th><th align=center>ALARM_TYPE</th><th align=center>LOCATION</th><th align=center>raised_date</th><th align=center>raised_time</th><th align=center>clear_date</th><th align=center>clear_time</th><th align=center>ALARM_GROUP</th><th align=center>PROBABLE_CAUSE</th><th align=center>SEVERITY</th><th align=center>ALARM_CODE</th><th align=center>INFO</th></tr>\n");       

foreach $_(@alarm_log){
          
@_ = split (/,/,$_); 

    print (HTMLFILE "<td align=center>$_[0]</td>\n");
    print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    print (HTMLFILE "<td align=center>$_[2]</td>\n");
    print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[5]</td>\n");
    print (HTMLFILE "<td align=center>$_[6]</td>\n");  
    print (HTMLFILE "<td align=center>$_[7]</td>\n");
    print (HTMLFILE "<td align=center>$_[8]</td>\n"); 
    print (HTMLFILE "<td align=center>$_[9]</td>\n");    
    print (HTMLFILE "<td align=center>$_[10]</td>\n");
    print (HTMLFILE "<td align=center>$_[11]</td>\n");
    print (HTMLFILE "<td align=center>$_[12]</td>\n");
    print (HTMLFILE "</td>\n");
    print (HTMLFILE "</tr>\n"); 
                                
                       }
                       
                       
print (HTMLFILE "</table>\n"); 



}
  
# }}