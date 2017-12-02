#!/usr/bin/perl
use POSIX;
use Data::Dumper;

my ($version_cq,$bucket,$LSMOAM,$LSM, $IP, $user, $pass, $eNBName,$cascade,$mmbsoamip,$mmbssbip,$alphapci,$betapci,$gammapci,$alpharsi,$betarsi,$gammarsi,$tac,$cabinet,$alphaid,$betaid,$gammaid,$alphatilt,$betatilt,$gammatilt,$earfcn,$startear,$enbid,$ltm,$zero_cq,$pkg);
my ($secondcar,$divciq,$convert_long,$convert_lat,$tddsecondcar,$tdd3rdcar,$thirdcar);
my($now);
print "starting \n";

#open (HTMLFILE, ">C:\\3G_4G_TOOL_Scripts\\2.5\\Audit_2.5\\REPORT\\$cascade\_$eNBName\_AUDIT_$now\.html");
open  (HTMLFILE, ">C:\\Users\\Krishna\\Desktop\\$cascade\_$eNBName\_AUDIT_$now\.html");
print (HTMLFILE "<table width=100% cellspacing=0 cellpadding=5 border=0>\n");
print (HTMLFILE "<tr><td align=center><font size=+3>$cascade $eNBName AUDIT REPORT $now </font></td></tr>\n");
print (HTMLFILE "</table>\n");

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=11 bgcolor=#EEEEEE><b>$cascade</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CASCADE ID</th><th align=center>eNB ID</th><th align=center>eNB NAME</th><th align=center>LSM</th><th align=center>SW</th><th align=center>BUCKET</th><th align=center>DIVERSITY</th><th align=center>ANTENNA</th><th align=center>ADID</th><th align=center>GP VER</th><th align=center>CIQ VER</th></tr>\n");

##############RTRV-MME-CONF

#if ($mme_assignment eq "San_Jose_Tacoma"){
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-MME-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_IPV4</th></tr>\n");

# foreach $_(@mme_ips){

# @_ = split (/,/,$_);

# if ($_[0] eq 0){

# if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                }


# if ($_[0] eq 1){

# if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                }

# if ($_[0] eq 2){

# if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                }

# if ($_[0] eq 3){

# if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                }

# if ($_[0] eq 4){

# if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                }                                             

# if ($_[0] eq 5){

# if (($_[1] eq "10.156.11.12") || ($_[1] eq "10.156.3.12") || ($_[1] eq "10.156.11.172") || ($_[1] eq "10.156.3.172") || ($_[1] eq "10.156.11.188") || ($_[1] eq "10.156.3.188")){	     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                } 


# print (HTMLFILE "</td>\n");
# print (HTMLFILE "</tr>\n");


          
#                            }  


# print (HTMLFILE "</table>\n");
# } 

# if ($mme_assignment eq "Bayamon"){
# print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-MME-CONF</b></td></tr>\n");
# print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_IPV4</th></tr>\n");

# foreach $_(@mme_ips){

# @_ = split (/,/,$_);

# if ($_[0] eq 0){

# if (($_[1] eq "10.156.75.12") || ($_[1] eq "10.156.43.12")){	     
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                }


# if ($_[0] eq 1){

# if (($_[1] eq "10.156.75.12") || ($_[1] eq "10.156.43.12")){	     
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");      
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");      
#      }     

#                }


#  print (HTMLFILE "</td>\n");
#  print (HTMLFILE "</tr>\n");


          
#                            }  

# print (HTMLFILE "</table>\n");
# } 
###################################

############### SYS CONF

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>SYS-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SYS_ID</th><th align=center>STATUS</th><th align=center>ADMINISTRATIVE_STATE</th><th align=center>TYPE</th><th align=center>SYS_TYPE</th></tr>\n");  
  
# foreach $_(@sys_conf){

# @_ = split (/,/,$_);


#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");
    
#     if ($_[4] eq $cabinet){
#         print (HTMLFILE "<td align=center>$_[4]</td>\n");   
#     }
#     if ($_[4] ne $cabinet){
#         print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");   
#     }

        
    
# print (HTMLFILE "</td>\n");
# print (HTMLFILE "</tr>\n");
#                     } 
                    
                    
print (HTMLFILE "</table>\n"); 

########################

#################vlan-conf



print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-VLAN-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>DB_INDEX</th><th align=center>VR_ID</th><th align=center>IF_NAME</th><th align=center>VLAN_ID</th><th align=center>ADMINISTRATIVE_STATE</th><th align=center>DESCRIPTION</th></tr>\n");  
  
# foreach $_(@vlan_conf){

# @_ = split (/,/,$_);


# if ($_[0] eq 0){

# if ($_[3] eq "34"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");    
    
        
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
    
    
          
#      }  
     
     
#      }   
# if ($_[0] eq 1){

# if ($_[3] eq "42"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");    
    
        
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
    
    
          
#      }    
#                } 
                              
               
# print (HTMLFILE "</td>\n");
# print (HTMLFILE "</tr>\n");
#}
                    
                    
print (HTMLFILE "</table>\n");     

##################  RTRV-IP-ADDR             
                      
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-IP-ADDR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>DB_INDEX</th><th align=center>IF_NAME</th><th align=center>IP_ADDR</th><th align=center>IP_PFX_LEN</th><th align=center>OAM</th><th align=center>LTE_SIGNAL_S1</th><th align=center>LTE_SIGNAL_X2</th><th align=center>LTE_BEARER_S1</th><th align=center>LTE_BEARER_X2</th></tr>\n");  
  
# foreach $_(@ip_addr){

# @_ = split (/,/,$_);


# if ($_[0] eq 0){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[8]</td>\n");         
    
     
#      }   
# if ($_[0] eq 1){

# if (($_[4] eq "True") && ($_[5] eq "False") && ($_[6] eq "False") && ($_[7] eq "False") && ($_[8] eq "False") && ($_[2] eq $mmbsoamip)){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[8]</td>\n");     
    
        
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");           
#      }    
#                } 
                              
# if ($_[0] eq 2){

# if (($_[4] eq "False") && ($_[5] eq "True") && ($_[6] eq "True") && ($_[7] eq "True") && ($_[8] eq "True") && ($_[2] eq $mmbssbip)){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[8]</td>\n");     
    
        
#                              }
# else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");     
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");     
    
    
          
#      }    
#                }                
# print (HTMLFILE "</td>\n");
# print (HTMLFILE "</tr>\n");




#                     } 
                    
                    
print (HTMLFILE "</table>\n");    

#################################RTRV-IP-ROUTE
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-IP-ROUTE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>VR_ID</th><th align=center>DB_INDEX</th><th align=center>IP_PREFIX</th><th align=center>IP_PFX_LEN</th><th align=center>IP_GW</th><th align=center>DISTANCE</th></tr>\n");  
  
# foreach $_(@ip_route){

# @_ = split (/,/,$_);



    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");           
    
# print (HTMLFILE "</td>\n");
# print (HTMLFILE "</tr>\n");




#                     } 
                    
                    
# print (HTMLFILE "</table>\n");     


# print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-IP-ROUTE</b></td></tr>\n");
# print (HTMLFILE "<tr><th align=center>VR_ID</th><th align=center>DB_INDEX</th><th align=center>IP_PREFIX</th><th align=center>IP_PFX_LEN</th><th align=center>IP_GW</th><th align=center>DISTANCE</th></tr>\n");  
  
# foreach $_(@ip_route){

# @_ = split (/,/,$_);



    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");     
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");           
    
# print (HTMLFILE "</td>\n");
# print (HTMLFILE "</tr>\n");




#                     } 
                    
                    
print (HTMLFILE "</table>\n"); 

##################################RTRV-NTP-CONF 
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-NTP-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SVR_TYPE</th><th align=center>NTP_IPV4</th></tr>\n");  
  
# foreach $_(@ntp){

# @_ = split (/,/,$_);


# if ($_[0] eq "PRIMARY_NTP_SERVER"){ 
# if ($_[1] eq "112.255.255.252"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
          
    
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
              
#          } 
         
#        }      

# if ($_[0] eq "SECONDARY_NTP_SERVER"){ 
# if ($_[1] eq "112.255.255.253"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
          
    
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
              
#          } 
         
#        }      
    
#     print (HTMLFILE "</td>\n");
#     print (HTMLFILE "</tr>\n");




#                     } 
                    
                    
print (HTMLFILE "</table>\n");      

####################################################      

###################CELL-INFO
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>CELL-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_SIZE</th><th align=center>HNB_NAME</th><th align=center>ADD_SPECTRUM_EMISSION</th><th align=center>TRACKING_AREA_CODE</th><th align=center>IMS_EMERGENCY_SUPPORT</th></tr>\n");                  


# foreach $_(@cellinfogp){

# @_ = split (/,/,$_);


# if ($_[0] <= "11") {


# print (HTMLFILE "<td align=center>$_[0]</td>\n");   
# print (HTMLFILE "<td align=center>$_[1]</td>\n");

# if ($_[2] eq "SAMSUNG_LTE"){
# print (HTMLFILE "<td align=center>$_[2]</td>\n");   
    
# }       
# if ($_[2] ne "SAMSUNG_LTE"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");   
# $cellinfogp = "true";   
# }
# if ($_[3] eq "1"){
# print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    
# }       
# if ($_[3] ne "1"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");   
# $cellinfogp = "true";   
# }
# if ($_[4] eq "H'$tac") {
# print (HTMLFILE "<td align=center>$_[4]</td>\n");
# }
# if ($_[4] ne "H'$tac") {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
# $cellinfogp = "true";   
# }
# if ($_[5] eq "False"){
# print (HTMLFILE "<td align=center>$_[5]</td>\n");   
    
# }       
# if ($_[5] ne "False"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");   
# $cellinfogp = "true";   
# }
#     print (HTMLFILE "</td>\n");
#     print (HTMLFILE "</tr>\n");          
# }

# }

print (HTMLFILE "</table>\n");  
 ##################################################  

 ######################## cell acs
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CELL-ACS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CELL_BARRED</th><th align=center>INTRA_FREQ_CELL_RESELECT</th><th align=center>BARRING_CTR_USAGE</th><th align=center>HANDOVER_BARRING_STATUS</th></tr>\n");  

# foreach $_(@cell_bar){

# @_ = split (/,/,$_);

#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     if ($_[1] eq "notBarred"){
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");
#     }
#     if ($_[1] ne "notBarred"){
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
#     }
#     if ($_[2] eq "NotAllowed"){
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");   
#     }
#     if ($_[2] ne "NotAllowed"){
#     print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[2]</td>\n");    
#     }
#     if ($_[3] eq "cpuStatusCtrl"){
#     print (HTMLFILE "<td align=center>$_[3]</td>\n");   
#     }
#     if ($_[3] ne "cpuStatusCtrl"){
#     print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[3]</td>\n");    
#     }
#     if ($_[4] eq "barringOff"){
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");   
#     }
#     if ($_[4] ne "barringOff"){
#     print (HTMLFILE "<td bgcolor=#FF0000 td align=center>$_[4]</td>\n");    
#     }
      
#     print (HTMLFILE "</td>\n");
#     print (HTMLFILE "</tr>\n");  
#     }                   
                       
                       
print (HTMLFILE "</table>\n");

######################## cell acs

###################################cellplmn-info




##############################cellplmn-info

##############################enbplmn-info


##############################enbplmn-info

#############################gps-invt


print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-GPS-INVT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>UNIT_ID</th><th align=center>VERSION</th><th align=center>FW_VERSION</th><th align=center>SERIAL</th><th align=center>VENDOR</th></tr>\n");  
  
# foreach $_(@gps){

# @_ = split (/,/,$_);
# print (HTMLFILE "<td align=center>$_[0]</td>\n");   
      
# if ($_[4] eq "SAMSUNG"){
#      if ($_[1] eq "1.0.0.2"){
#            print (HTMLFILE "<td align=center>$_[1]</td>\n");                   
#                }     
#      if ($_[1] ne "1.0.0.2"){
#            print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                   
#                }
#      if ($_[2] eq "1.0.0.5"){
#            print (HTMLFILE "<td align=center>$_[2]</td>\n");                   
#                }     
#      if ($_[2] ne "1.0.0.5"){
#            print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                   
#                }                 
                          
#           }
          
# if ($_[4] eq "Trimble-D"){
#      if ($_[1] eq "1.0.0.0"){
#            print (HTMLFILE "<td align=center>$_[1]</td>\n");                   
#                }     
#      if ($_[1] ne "1.0.0.0"){
#            print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                   
#                }
#      if ($_[2] eq "1.0.0.1"){
#            print (HTMLFILE "<td align=center>$_[2]</td>\n");                   
#                }     
#      if ($_[2] ne "1.0.0.1"){
#            print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                   
#                }                 
                          
#           }          
          
# print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
# print (HTMLFILE "<td align=center>$_[4]</td>\n"); 

         
#     print (HTMLFILE "</td>\n");
#     print (HTMLFILE "</tr>\n");




#                     } 
                    
                    
print (HTMLFILE "</table>\n");    
#################################
###############################RRH-INVT

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-INVT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONN_BD_ID</th><th align=center>CONN_PORT_ID</th><th align=center>UNIT_ID</th><th align=center>FAMILY_TYPE</th><th align=center>FW_VERSION</th><th align=center>SERIAL</th></tr>\n");  
  
# foreach $_(@rrh_invt){

# @_ = split (/,/,$_);

# if ($pkg =~ m/^3/) {
# if ($_[1] eq 6){ 
# if ($_[4] eq "1.0.6.1"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        }      

# if ($_[1] eq 8){ 
# if ($_[4] eq "1.0.6.1"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        } 
       
# if ($_[1] eq 10){ 
# if ($_[4] eq "1.0.6.1"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        }             
#                     }
# if ($pkg =~ m/^4/) {
# if ($_[1] eq 6){ 
# if ($_[4] eq "1.1.0.5"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        }      

# if ($_[1] eq 8){ 
# if ($_[4] eq "1.1.0.5"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        } 
       
# if ($_[1] eq 10){ 
# if ($_[4] eq "1.1.0.5"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        }         
#                    }
# if ($pkg =~ m/^5/) {
# if ($_[1] eq 6){ 
# if ($_[4] eq "1.2.0.1"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        }      

# if ($_[1] eq 8){ 
# if ($_[4] eq "1.2.0.1"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        } 
       
# if ($_[1] eq 10){ 
# if ($_[4] eq "1.2.0.1"){
    
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");    
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     }
#     else {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#          } 
         
#        }         
#                    }  
#     print (HTMLFILE "</td>\n");
#     print (HTMLFILE "</tr>\n");




#                     } 
                    
                    
print (HTMLFILE "</table>\n");    

##############################################################################                              

##########################################RRH-CONF:0,6

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-CONF:0,6</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>POWER_BOOST</th><th align=center>NUM_OF_ALD</th><th align=center>DIGITAL_INPUT_LOW_ALARM_TH</th><th align=center>START_EARFCN1</th><th align=center>ANTENNA_PROFILE_ID</th><th align=center>CELL_NUM</th></tr>\n");  

# my ($boolEAR);

# $boolEAR = "false";
  
# @_ = split (/~/,$port6);
# if ($pkg eq "3.5.2"){
# if ($divciq eq "8T8R"){
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
#     if ($_[6] eq $alphaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           }
#     if ($_[6] ne $alphaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }     
                                                                 
#     if (($secondcar ne "true") && ($_[7] eq "0,-,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }        
#     if (($secondcar eq "true") && ($_[7] eq "0,3,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }
   
#     if (($secondcar ne "true") && ($_[7] ne "0,-,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           } 
#     if (($secondcar eq "true") && ($_[7] ne "0,3,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           }
                                                                                                 
#     $boolEAR = "true"; 
            
#     }
# }
# if ($divciq eq "4T4R"){
# if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
#     if ($_[6] eq $alphaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           }
#     if ($_[6] ne $alphaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                                         
#     if (($secondcar4T ne "true") && ($_[7] eq "0,-,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }        
#     if (($secondcar4T eq "true") && ($_[7] eq "0,9,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }
   
#     if (($secondcar4T ne "true") && ($_[7] ne "0,-,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           } 
#     if (($secondcar4T eq "true") && ($_[7] ne "0,9,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           }                                                                                        
#     $boolEAR = "true"; 
            
#     }
# }      
# # if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     # print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     # print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     # if ($_[6] eq $alphaid){
#        # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           # }
#     # $boolEAR = "true";    
#     # }    
    
    
#     if ($boolEAR eq "false") {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
#          } 
# }                   


# if (($pkg eq "4.0.2")||($pkg eq "5.0.2")){
# if ($divciq eq "8T8R"){
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36,36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
#     if ($_[6] eq $alphaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           }
#     if ($_[6] ne $alphaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                                            
                                                                                        
#     $boolEAR = "true"; 
            
#     }
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");
# }
# if ($divciq eq "4T4R"){
# if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
#     if ($_[6] eq $alphaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           }
#     if ($_[6] ne $alphaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                                         


                                                                                        
#     $boolEAR = "true"; 
            
#     }
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");
# }      
# # if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     # print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     # print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[5]</td>\n");     
#     # if ($_[6] eq $alphaid){
#        # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           # }
#     # $boolEAR = "true";    
#     # }    
    
    
#     if ($boolEAR eq "false") {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
#          } 
# }                               
print (HTMLFILE "</table>\n");   

#########################################RRH-CONF:0,8
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-CONF:0,8</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>POWER_BOOST</th><th align=center>NUM_OF_ALD</th><th align=center>DIGITAL_INPUT_LOW_ALARM_TH</th><th align=center>START_EARFCN1</th><th align=center>ANTENNA_PROFILE_ID</th><th align=center>CELL_NUM</th></tr>\n");  
  
# @_ = split (/~/,$port8);

# if ($pkg eq "3.5.2"){
# if ($divciq eq "8T8R"){
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $betaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $betaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                                
#     if (($secondcar ne "true") && ($_[7] eq "1,-,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }        
#     if (($secondcar eq "true") && ($_[7] eq "1,4,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }
   
#     if (($secondcar ne "true") && ($_[7] ne "1,-,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           } 
#     if (($secondcar eq "true") && ($_[7] ne "1,4,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           }
#     $boolEAR = "true";        
#     }
#  }

# if ($divciq eq "4T4R"){
# if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $betaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $betaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                                

#     if (($secondcar4T ne "true") && ($_[7] eq "1,-,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }        
#     if (($secondcar4T eq "true") && ($_[7] eq "1,10,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }
   
#     if (($secondcar4T ne "true") && ($_[7] ne "1,-,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           } 
#     if (($secondcar4T eq "true") && ($_[7] ne "1,10,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           }

#     $boolEAR = "true";        
#     }
#  }     
# # if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     # print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     # print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
#     # if ($_[6] eq $betaid){
#        # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           # }      
#     # $boolEAR = "true";    
#     # }    
    
#     if ($boolEAR eq "false") {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
#          } 
# }                    
# if (($pkg eq "4.0.2")||($pkg eq "5.0.2")){
# if ($divciq eq "8T8R"){
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36,36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $betaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $betaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                                
#     $boolEAR = "true";        
#     }
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");
#  }

# if ($divciq eq "4T4R"){
# if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $betaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $betaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                                
#     $boolEAR = "true";        
#     }
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");
#  }     
# # if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     # print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     # print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
#     # if ($_[6] eq $betaid){
#        # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           # }      
#     # $boolEAR = "true";    
#     # }    
    
#     if ($boolEAR eq "false") {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
#          } 
# }                      
print (HTMLFILE "</table>\n");   


 #################RRH-CONF:0,10
print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RRH-CONF:0,10</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>POWER_BOOST</th><th align=center>NUM_OF_ALD</th><th align=center>DIGITAL_INPUT_LOW_ALARM_TH</th><th align=center>START_EARFCN1</th><th align=center>ANTENNA_PROFILE_ID</th><th align=center>CELL_NUM</th></tr>\n");  
  
# @_ = split (/~/,$port10);
# if ($pkg eq "3.5.2"){
# if ($divciq eq "8T8R"){
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $gammaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $gammaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                               
#     if (($secondcar ne "true") && ($_[7] eq "2,-,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }        
#     if (($secondcar eq "true") && ($_[7] eq "2,5,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }
   
#     if (($secondcar ne "true") && ($_[7] ne "2,-,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           } 
#     if (($secondcar eq "true") && ($_[7] ne "2,5,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           }
#     $boolEAR = "true";          
#     }
#  }
# if ($divciq eq "4T4R"){
# if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $gammaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $gammaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                               
#     if (($secondcar4T ne "true") && ($_[7] eq "2,-,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }        
#     if (($secondcar4T eq "true") && ($_[7] eq "2,11,-,-,-,-")){
#           print (HTMLFILE "<td align=center>$_[7]</td>\n");           
#           }
   
#     if (($secondcar4T ne "true") && ($_[7] ne "2,-,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           } 
#     if (($secondcar4T eq "true") && ($_[7] ne "2,11,-,-,-,-")){
#           print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");           
#           }
#     $boolEAR = "true";          
#     }
#  }
# # if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     # print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     # print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     # if ($_[6] eq $gammaid){
#        # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           # }    
#     # $boolEAR = "true";        
#     # }       
    
#     if ($boolEAR eq "false") {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
#          } 
# }                    
# if (($pkg eq "4.0.2")||($pkg eq "5.0.2")){
# if ($divciq eq "8T8R"){
# if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36,36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $gammaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $gammaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                               
#     $boolEAR = "true";          
#     }
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");
#  }
# if ($divciq eq "4T4R"){
# if (($_[2] eq "3dB,3dB,3dB,3dB,3dB,3dB") && ($_[3] eq "0") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     print (HTMLFILE "<td align=center>$_[4]</td>\n");
#     print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     if ($_[6] eq $gammaid){
#        print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           } 
#     if ($_[6] ne $gammaid){
#        print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
#                           }                               
#     $boolEAR = "true";          
#     }
#     print (HTMLFILE "<td align=center>$_[7]</td>\n");
#  }
# # if (($_[2] eq "1.2dB,1.2dB,1.2dB,1.2dB,1.2dB,1.2dB") && ($_[3] eq "1") && ($_[4] eq "36,36,36,36,36,36") && ($_[5] eq $startear)){
          
#     # print (HTMLFILE "<td align=center>$_[0]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
#     # print (HTMLFILE "<td align=center>$_[2]</td>\n");
#     # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
#     # print (HTMLFILE "<td align=center>$_[5]</td>\n");
#     # if ($_[6] eq $gammaid){
#        # print (HTMLFILE "<td align=center>$_[6]</td>\n"); 
#                           # }    
#     # $boolEAR = "true";        
#     # }       
    
#     if ($boolEAR eq "false") {
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n"); 
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
#     print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
#          } 
# }                     
print (HTMLFILE "</table>\n");                       
                                      

########################RTRV-CELL-IDLE;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CELL-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PHY_CELL_ID</th><th align=center>DL_ANT_COUNT</th><th align=center>UL_ANT_COUNT</th><th align=center>EARFCN_DL</th><th align=center>EARFCN_UL</th><th align=center>CELL_TYPE</th><th align=center>DUPLEX_TYPE</th><th align=center>FREQUENCY_BAND_INDICATOR</th><th align=center>SUBFRAME_ASSIGNMENT</th><th align=center>SPECIAL_SUBFRAME_PATTERNS</th><th align=center>FORCED_MODE</th><th align=center>DL_CRS_PORT_COUNT</th></tr>\n");  
  
#foreach $_(@cell_idle){

#@_ = split (/,/,$_);


# if (($_[0] eq 0) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $alphapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
	
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # }      

# if (($_[0] eq 1) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $betapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

# if (($_[0] eq 2) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $gammapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

##2nd

# if (($_[0] eq 3) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $alphapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # }      

# if (($_[0] eq 4) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $betapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

# if (($_[0] eq 5) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $gammapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 


# if (($_[0] eq 0) && ($divciq eq "4T4R")){ 
# if (($_[1] eq $alphapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # }      

# if (($_[0] eq 1) && ($divciq eq "4T4R")){ 
# if (($_[1] eq $betapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

## 3rd


# if (($_[0] eq 6) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $alphapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tdd3rdcar) && ($_[5] eq $tdd3rdcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # }      

# if (($_[0] eq 7) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $betapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tdd3rdcar) && ($_[5] eq $tdd3rdcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

# if (($_[0] eq 8) && ($divciq eq "8T8R")){ 
# if (($_[1] eq $gammapci) && ($_[2] eq "n8TxAntCnt") && ($_[3] eq "n8RxAntCnt") && ($_[4] eq $tdd3rdcar) && ($_[5] eq $tdd3rdcar ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 


# if (($_[0] eq 2) && ($divciq eq "4T4R")){  
# if (($_[1] eq $gammapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $earfcn) && ($_[5] eq $earfcn ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

##2nd

# if (($_[0] eq 9) && ($divciq eq "4T4R")){ 
# if (($_[1] eq $alphapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # }      

# if (($_[0] eq 10) && ($divciq eq "4T4R")){ 
# if (($_[1] eq $betapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

# if (($_[0] eq 11) && ($divciq eq "4T4R")){  
# if (($_[1] eq $gammapci) && ($_[2] eq "n4TxAntCnt") && ($_[3] eq "n4RxAntCnt") && ($_[4] eq $tddsecondcar) && ($_[5] eq $tddsecondcar ) && ($_[6] eq "macroCell") && ($_[7] eq "TDD") && ($_[8] eq "41") && ($_[9] eq "subframeAssignment_1") && ($_[10] eq "specialSubframePattern_7") && ($_[11] eq "False") && ($_[12] eq "Two")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");            
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td align=center>$_[9]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n"); 
	# print (HTMLFILE "<td align=center>$_[12]</td>\n"); 
	
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");              
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");                   
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
	
         # } 
         
       # } 

                 
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                    # } 
                    
                    
print (HTMLFILE "</table>\n");    

#######################RTRV-PRACH-CONF;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-PRACH-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>ROOT_SEQUENCE_INDEX</th><th align=center>ZERO_CORREL_ZONE_CONFIG</th></tr>\n");  
  
# foreach $_(@prach_conf){

# @_ = split (/,/,$_);


# if ($_[0] eq 0){ 
# if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         # } 
         
       # }      

# if ($_[0] eq 1){ 
# if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         # } 
         
       # } 
        

# if ($_[0] eq 2){ 
# if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         # } 
         
       # }  

#2nd

# if ($_[0] eq 3){ 
# if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         # } 
         
       # }      

# if ($_[0] eq 4){ 
# if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         # } 
         
       # } 
        

# if ($_[0] eq 5){ 
# if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         # } 
         
       # }  


### 3rd

# if ($_[0] eq 6){ 
# if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         # } 
         
       # }      

# if ($_[0] eq 7){ 
# if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         # } 
         
       # } 
        

# if ($_[0] eq 8){ 
# if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         # } 
         
       # }  


# if ($_[0] eq 9){ 
# if (($_[1] eq $alpharsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");     
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                                  
         # } 
         
       # }      

# if ($_[0] eq 10){ 
# if (($_[1] eq $betarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                              
         # } 
         
       # } 
        

# if ($_[0] eq 11){ 
# if (($_[1] eq $gammarsi) && ($_[2] eq $zero_cq)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    
     
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");                               
         # } 
         
       # } 
          
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                    # } 
                    
                    
print (HTMLFILE "</table>\n");  

##########################
#RTRV-ENBPLMN-INFO;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-ENBPLMN-INFO PRE OAR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>PLMN_IDX</th><th align=center>MCC</th><th align=center>MNC</th><th align=center>OP_ID</th></tr>\n"); 

# foreach $_(@enbplmn35x){

# @_ = split (/,/,$_);

# print (HTMLFILE "<td align=center>$_[0]</td>\n");

# if (($_[0] eq "0") && ($_[1] eq "777")){
 # print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      # }
# if (($_[0] eq "0") && ($_[1] ne "777")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      # }
      
# if (($_[0] eq "1") && ($_[1] eq "310")){
 # print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      # }
# if (($_[0] eq "1") && ($_[1] ne "310")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      # }      


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


      
# if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] eq "FFF")){
 # print (HTMLFILE "<td align=center>$_[1]</td>\n");           
      # }
# if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[1] ne "FFF")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");           
      # }       


#    

      
# if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[2] eq "FFF")){
 # print (HTMLFILE "<td align=center>$_[2]</td>\n");           
      # }
# if ((($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[2] ne "FFF")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");           
      # } 

# if ((($_[0] eq "0") ||($_[0] eq "1") ||($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8")) && ($_[3] eq "0")){
 # print (HTMLFILE "<td align=center>$_[3]</td>\n");           
      # }
# if ((($_[0] eq "0") ||($_[0] eq "1") ||($_[0] eq "2") || ($_[0] eq "3") || ($_[0] eq "4") || ($_[0] eq "5") || ($_[0] eq "6") || ($_[0] eq "7") || ($_[0] eq "8") ) && ($_[3] ne "0")){
 # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");           
      # }

      

    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

# }

print (HTMLFILE "</table>\n");  

########################
#RTRV-CELLPLMN-INFO;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-CELLPLMN-INFO PRE OAR</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PLMN_IDX</th><th align=center>PLMN_USAGE</th><th align=center>CELL_RESERVED_OP_USE</th></tr>\n");  

# foreach $_(@cellplmn35x){

# @_ = split (/,/,$_);

# print (HTMLFILE "<td align=center>$_[0]</td>\n");
# print (HTMLFILE "<td align=center>$_[1]</td>\n"); 

# if ($_[2] eq "use"){
# print (HTMLFILE "<td align=center>$_[2]</td>\n");       
      
      # }
# if ($_[2] ne "use"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");       
      
      # }
      
# if ($_[3] eq "reserved"){
# print (HTMLFILE "<td align=center>$_[3]</td>\n");       
      
      # }
# if ($_[3] ne "reserved"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");       
      
      # }
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

# }

print (HTMLFILE "</table>\n");   

###########################
#RTRV-GPS-STS; 
################

##################
#RTRV-EAIU-INVT; 

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-EAIU-INVT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>UNIT_ID</th><th align=center>FAMILY_TYPE</th><th align=center>FW_VERSION</th><th align=center>SERIAL</th><th align=center>VERSION</th><th align=center>HW_NAME</th></tr>\n");  
  
# foreach $_(@eaiu_invt){

# @_ = split (/,/,$_);

# my ($bool_find);

# $bool_find = "false";
# $bool_find_first = "false";

#if (($cabinet eq "OUTDOOR")  && ($_[0] eq "EAIU[0]")){ 
# if ($_[0] eq "EAIU[0]"){
# if ($pkg ne "5.0.2"){ 
#if ($_[2] eq "0.1.12.26"){
    
    # if (($_[5] eq "EAIU4-U") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.26")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");
    # $bool_find = "true";    
    # }
	# if (($_[5] eq "EAIU4-U") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.27")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");
    # $bool_find = "true";    
    # }
	
    # if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.21")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");   
    # $bool_find = "true";
    
    # }
    # if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.23")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");   
    # $bool_find = "true";
    
    # }      
    
    # if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.24")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");   
    # $bool_find = "true";
    
    # }      
        
    # if (($_[5] eq "EAIU4-U_I") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.5")){ # add 9
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # $bool_find = "true";  
    # } 
    
    # if (($_[5] eq "EAIU4-U_I") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.9")){ # add 9
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # $bool_find = "true";  
    # }     
    
    # if (($_[5] eq "EAIU4-UA") && ($_[4] eq "1.0.0.0") && ($_[2] eq "1.2.0.7")){ # add 9
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # $bool_find = "true";  
    # }     
    
   # if ($bool_find eq "false") {
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
   # }        

                    # }
# if ($pkg eq "5.0.2"){
    # if (($_[5] eq "EAIU4-U") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.27")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # $bool_find = "true";  
                                                                                # }
    # if (($_[5] eq "EAIU4-UT") && ($_[4] eq "1.0.1.0") && ($_[2] eq "1.0.0.24")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # $bool_find = "true";  
                                                                                # }     
    # if (($_[5] eq "EAIU4-U_I") && ($_[4] eq "0.1.12.0") && ($_[2] eq "0.1.12.11")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # $bool_find = "true";  
                                                                                  # }
    # if (($_[5] eq "EAIU4-UA") && ($_[4] eq "1.0.0.0") && ($_[2] eq "1.2.0.9")){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");   
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td align=center>$_[5]</td>\n"); 
    # $bool_find = "true";  
                                                                              # }
   # if ($bool_find eq "false") {
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
   # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");  
                              # }        
					# }
# }
                    
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");
 # }
 
print (HTMLFILE "</table>\n");    

#########################
#RTRV-EAIU-STS;
#################

#########################
#RTRV-S1-STS;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-S1-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_ID</th><th align=center>SCTP_STATE</th><th align=center>S1AP_STATE</th><th align=center>MME_NAME</th><th align=center>IP_VER</th><th align=center>MME_IP_V4</th></tr>\n");  
  
# foreach $_(@s1){
# my ($s1_boolean);
# @_ = split (/,/,$_);

# print (HTMLFILE "<td align=center>$_[0]</td>\n");
# print (HTMLFILE "<td align=center>$_[1]</td>\n");
# if ($_[2] eq "enabled"){
# print (HTMLFILE "<td align=center>$_[2]</td>\n");      
# }      
# if ($_[2] ne "enabled"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");      
# } 
# if ($_[3] eq "enabled"){
# print (HTMLFILE "<td align=center>$_[3]</td>\n");      
# }      
# if ($_[3] ne "enabled"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");      
# } 
# if (($_[4] eq "CHCGILFF-MME-01") || ($_[4] eq "AKRNOHIJ-MME-11") || ($_[4] eq "CHCGILFF-MME-02") || ($_[4] eq "AKRNOHIJ-MME-12") || ($_[4] eq "CHCGILFF-MME-03") || ($_[4] eq "AKRNOHIJ-MME-13") || ($_[4] eq "CHCGILFF-MME-04") || ($_[4] eq "AKRNOHIJ-MME-14") || ($_[4] eq "CHCGILFF-MME-05") || ($_[4] eq "AKRNOHIJ-MME-15") || ($_[4] eq "CHCGILFF-MME-06") || ($_[4] eq "AKRNOHIJ-MME-16") || ($_[4] eq "CHCGILFF-MME-07") || ($_[4] eq "AKRNOHIJ-MME-17") ){
# print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
# $s1_boolean = "true";
# }
# if ($s1_boolean ne "true"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");        
      
# }      
# if ($_[5] eq "IPV4"){
# print (HTMLFILE "<td align=center>$_[5]</td>\n");      
# }      
# if ($_[5] ne "IPV4"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");      
# }       
# print (HTMLFILE "<td align=center>$_[6]</td>\n");       
       

    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                    # } 
                    
                    
# print (HTMLFILE "</table>\n");    
# }


# if ($mme_assignment eq "San_Jose_Tacoma"){
# print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-S1-STS</b></td></tr>\n");
# print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_ID</th><th align=center>SCTP_STATE</th><th align=center>S1AP_STATE</th><th align=center>MME_NAME</th><th align=center>IP_VER</th><th align=center>MME_IP_V4</th></tr>\n");  
  
# foreach $_(@s1){
# my ($s1_boolean);
# @_ = split (/,/,$_);

# print (HTMLFILE "<td align=center>$_[0]</td>\n");
# print (HTMLFILE "<td align=center>$_[1]</td>\n");
# if ($_[2] eq "enabled"){
# print (HTMLFILE "<td align=center>$_[2]</td>\n");      
# }      
# if ($_[2] ne "enabled"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");      
# } 
# if ($_[3] eq "enabled"){
# print (HTMLFILE "<td align=center>$_[3]</td>\n");      
# }      
# if ($_[3] ne "enabled"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");      
# } 
# if (($_[4] eq "SNJSCASP-MME-01") || ($_[4] eq "TACMWA44-MME-11") || ($_[4] eq "SNJSCASP-MME-02") || ($_[4] eq "TACMWA44-MME-12") || ($_[4] eq "SNJSCASP-MME-03") || ($_[4] eq "TACMWA44-MME-13")){
# print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
# $s1_boolean = "true";
# }
# if ($s1_boolean ne "true"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");        
      
# }      
# if ($_[5] eq "IPV4"){
# print (HTMLFILE "<td align=center>$_[5]</td>\n");      
# }      
# if ($_[5] ne "IPV4"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");      
# }       
# print (HTMLFILE "<td align=center>$_[6]</td>\n");       
       

    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                    # } 
                    
                    
# print (HTMLFILE "</table>\n");    
# }
# if ($mme_assignment eq "Bayamon"){
# print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-S1-STS</b></td></tr>\n");
# print (HTMLFILE "<tr><th align=center>MME_INDEX</th><th align=center>MME_ID</th><th align=center>SCTP_STATE</th><th align=center>S1AP_STATE</th><th align=center>MME_NAME</th><th align=center>IP_VER</th><th align=center>MME_IP_V4</th></tr>\n");  
  
# foreach $_(@s1){
# my ($s1_boolean);
# @_ = split (/,/,$_);

# print (HTMLFILE "<td align=center>$_[0]</td>\n");
# print (HTMLFILE "<td align=center>$_[1]</td>\n");
# if ($_[2] eq "enabled"){
# print (HTMLFILE "<td align=center>$_[2]</td>\n");      
# }      
# if ($_[2] ne "enabled"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");      
# } 
# if ($_[3] eq "enabled"){
# print (HTMLFILE "<td align=center>$_[3]</td>\n");      
# }      
# if ($_[3] ne "enabled"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");      
# } 
# if (($_[4] eq "bymnprag-mme-01") || ($_[4] eq "miauflws-mme-11")){
# print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
# $s1_boolean = "true";
# }
# if ($s1_boolean ne "true"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");        
      
# }      
# if ($_[5] eq "IPV4"){
# print (HTMLFILE "<td align=center>$_[5]</td>\n");      
# }      
# if ($_[5] ne "IPV4"){
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");      
# }       
# print (HTMLFILE "<td align=center>$_[6]</td>\n");       
       

    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                    # } 
                    
                    
print (HTMLFILE "</table>\n");    

####################
#RTRV-X2-STS;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-X2-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>NBR_ENB_INDEX</th><th align=center>NBR_ENB_ID</th><th align=center>SCTP_STATE</th><th align=center>X2AP_STATE</th></tr>\n");  
  
# foreach $_(@x2){

# @_ = split (/,/,$_);


# if (($_[2] eq "enable_INS")  && ($_[3] eq "enabled")){ 
   # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");
   
    
          
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
         # } 
         
       

    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                    # } 
                    
                    
print (HTMLFILE "</table>\n");    

###################
#RTRV-BF-STS;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-BF-STS</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>BF_STATE</th><th align=center>CAL_REASON</th><th align=center>CAL_TYPE</th></tr>\n");  
  
# foreach $_(@bf){

# @_ = split (/,/,$_);
# if ($_[0] <= 11){
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");      
    
             
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

# }


                    # } 
                    
                    
print (HTMLFILE "</table>\n"); 

###########################
#RTRV-BF-CONF;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-BF-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>BEAM_FORMING_ENABLE</th><th align=center>CALIBRATION_PERIOD</th><th align=center>SUBFRAME</th></tr>\n");  

# foreach $_(@bfconf){

# @_ = split (/,/,$_);

    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
	
# if ($pkg =~ m/^3/) {	
    # if (($divciq eq "8T8R") && ($_[0] <= "8")){
    # if (($_[1] eq "True") &&  ($_[2] eq "30") &&  ($_[3] eq "0")) {
          
          # print (HTMLFILE "<td align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          # } 
    # if (($_[1] ne "True") ||  ($_[2] ne "30") ||  ($_[3] ne "0")){
          
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           # $bfconfgp="true"; 
          
          # }
    # }    
    # if ($divciq eq "4T4R"){
    # if (($_[1] eq "False") &&  ($_[2] eq "30") &&  ($_[3] eq "0")) {
          
          # print (HTMLFILE "<td align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          # } 
    # if (($_[1] ne "False") ||  ($_[2] ne "30") ||  ($_[3] ne "0")){
          
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           # $bfconfgp="true"; 
          
          # }
    # } 
                   # }
# if ($pkg =~ m/^4/) {
    # if (($divciq eq "8T8R") && ($_[0] <= "8")){
    # if (($_[1] eq "True") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          # print (HTMLFILE "<td align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          # } 
    # if (($_[1] ne "True") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           # $bfconfgp="true"; 
          
          # }
    # }    
    # if ($divciq eq "4T4R"){
    # if (($_[1] eq "False") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          # print (HTMLFILE "<td align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          # } 
    # if (($_[1] ne "False") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           # $bfconfgp="true"; 
          
          # }
    # } 
                    # }		  
# if ($pkg =~ m/^5/) {
    # if (($divciq eq "8T8R") && ($_[0] <= "8")){
    # if (($_[1] eq "True") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          # print (HTMLFILE "<td align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          # } 
    # if (($_[1] ne "True") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           # $bfconfgp="true"; 
          
          # }
    # }    
    # if ($divciq eq "4T4R"){
    # if (($_[1] eq "False") &&  ($_[2] eq "30") &&  ($_[3] eq "2")) {
          
          # print (HTMLFILE "<td align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");
        
          

          
          # } 
    # if (($_[1] ne "False") ||  ($_[2] ne "30") ||  ($_[3] ne "2")){
          
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");

           # $bfconfgp="true"; 
          
          # }
    # } 
                    # }    

	# print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");  
    # }                   
                       
                       
print (HTMLFILE "</table>\n");

#####################
#RTRV-POS-CONF;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-POS-CONF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>LAT</th><th align=center>LATITUDE</th><th align=center>LONG</th><th align=center>LONGITUDE</th></tr>\n");  
  
# foreach $_(@pos){

# @_ = split (/,/,$_);

# if (($_[0] <= 5) && ($secondcar eq "true")){
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # if ($_[2] eq $convert_lat){
    # print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    # }
    # if ($_[2] ne $convert_lat){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # }    
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    # if ($_[4] eq $convert_long){
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # }
    # if ($_[4] ne $convert_long){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    # }     
    
             
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

# }
# if (($_[0] <= 8) && ($thirdcar eq "true")){
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # if ($_[2] eq $convert_lat){
    # print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    # }
    # if ($_[2] ne $convert_lat){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # }    
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    # if ($_[4] eq $convert_long){
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # }
    # if ($_[4] ne $convert_long){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    # }     
    
             
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

# }

# if ((($_[0] <= "2") || (($_[0] >= "9") && ($_[0] <= "11"))) && ($secondcar4T eq "true")){
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # if ($_[2] eq $convert_lat){
    # print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    # }
    # if ($_[2] ne $convert_lat){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # }    
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    # if ($_[4] eq $convert_long){
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # }
    # if ($_[4] ne $convert_long){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    # }     
    
             
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

# }
# if (($_[0] <= "2") && ($secondcar ne "true") && ($secondcar4T ne "true")){
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # if ($_[2] eq $convert_lat){
    # print (HTMLFILE "<td align=center>$_[2]</td>\n"); 
    # }
    # if ($_[2] ne $convert_lat){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # }    
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");     
    # if ($_[4] eq $convert_long){
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # }
    # if ($_[4] ne $convert_long){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    # }     
    
             
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

# }


                    # } 
                    
                    
print (HTMLFILE "</table>\n"); 

#######################
#RTRV-CELL-STS;
#####################

##########################
#RTRV-RRH-CONF:;
############

###################
#RTRV-RET-INF;  

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-RET-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CONNECT_BOARD_ID</th><th align=center>CONNECT_PORT_ID</th><th align=center>ALD_ID</th><th align=center>ANT_ID</th><th align=center>TILT</th></tr>\n");  
  
# foreach $_(@ret){

# @_ = split (/,/,$_);


# if ($_[1] eq 6){ 
# if (($_[3] eq "1") && ($_[4] eq $alphatilt)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");    
         
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");     
      
         # } 
         
       # }      

# if ($_[1] eq 8){ 
# if (($_[3] eq "1") && ($_[4] eq $betatilt)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");    
         
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");     
      
         # } 
         
       # }    

# if ($_[1] eq 10){ 
# if (($_[3] eq "1") && ($_[4] eq $gammatilt)){
    
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");    
         
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[0]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");                               
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");     
      
         # } 
         
       # }            
       
         
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                    # } 
                    
                    
print (HTMLFILE "</table>\n"); 

################################
#RTRV-ALM-LIST:; (In the CDU 30 comand explanation there is colon after comand and in the Audit log file there is no colon for the comand.)

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-ALM-LIST</b></td></tr>\n");



# if ($alarm_data[0] eq "THERE ARE NO 4G ALARMS"){
          
# print (HTMLFILE "<tr><th align=center>NO ALARMS</th></tr>\n");  

    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");          
          
                                   # }                      
# else {
          
# print (HTMLFILE "<tr><th align=center>UNIT_TYPE</th><th align=center>ALARM_TYPE</th><th align=center>LOCATION</th><th align=center>RAISED_Date</th><th align=center>RAISED_TIME</th><th align=center>ALARM_GROUP</th><th align=center>PROBABLE_CAUSE</th><th align=center>SEVERITY</th><th align=center>ALARM_CODE</th><th align=center>INFO</th><th align=center>SEQUENCE_ID</th></tr>\n");       



# foreach $_(@alarm_data){
          
# @_ = split (/,/,$_); 
 
    
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");  
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");  
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");     
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");          
          
                       # }
                       
                      
                       
     # }     
          
                     
                     
print (HTMLFILE "</table>\n"); 

######################
#RTRV-ALM-LOG;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-ALM-LOG</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>LOG_NO</th><th align=center>UNIT_TYPE</th><th align=center>ALARM_TYPE</th><th align=center>LOCATION</th><th align=center>raised_date</th><th align=center>raised_time</th><th align=center>clear_date</th><th align=center>clear_time</th><th align=center>ALARM_GROUP</th><th align=center>PROBABLE_CAUSE</th><th align=center>SEVERITY</th><th align=center>ALARM_CODE</th><th align=center>INFO</th></tr>\n");       

# foreach $_(@alarm_log){
          
# @_ = split (/,/,$_); 

    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # print (HTMLFILE "<td align=center>$_[3]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[4]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");  
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # print (HTMLFILE "<td align=center>$_[8]</td>\n"); 
    # print (HTMLFILE "<td align=center>$_[9]</td>\n");    
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # print (HTMLFILE "<td align=center>$_[11]</td>\n");
    # print (HTMLFILE "<td align=center>$_[12]</td>\n");
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n"); 
                                
                       # }
                       
                       
print (HTMLFILE "</table>\n"); 

###########################
#RTRV-PUNCTMODE-IDLE;  

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-PUNCTMODE-IDLE</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>USER_SPECIFIC_TIMING</th></tr>\n");  
  

# if ($punc_data =~ m/^WiMAX29_18_LTE1_7_WITH_TDLTE_PUNCTURING_10650/){ 
   # print (HTMLFILE "<td align=center>$punc_data</td>\n");
  
    # }
    # else {
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$punc_data</td>\n");      
         # } 
         
       

    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");




                     
                    
                    
print (HTMLFILE "</table>\n");    

##################################
#"RTRV-NBR-EUTRAN:CELL_NUM=0;"

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=12 align=center bgcolor=#EEEEEE><b>RTRV-NBR-EUTRAN</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>RELATION_IDX</th><th align=center>STATUS</th><th align=center>ENB_ID</th><th align=center>TARGET_CELL_ID</th><th align=center>ENB_TYPE</th><th align=center>ENB_MCC[DIGIT]</th><th align=center>ENB_MNC[DIGIT]</th><th align=center>PHY_CELL_ID</th><th align=center>TAC</th><th align=center>MCC0[DIGIT]</th><th align=center>MNC0[DIGIT]</th><th align=center>MCC1[DIGIT]</th><th align=center>MNC1[DIGIT]</th><th align=center>MCC2[DIGIT]</th><th align=center>MNC2[DIGIT]</th><th align=center>MCC3[DIGIT]</th><th align=center>MNC3[DIGIT]</th><th align=center>MCC4[DIGIT]</th><th align=center>MNC4[DIGIT]</th><th align=center>MCC5[DIGIT]</th><th align=center>MNC5[DIGIT]</th><th align=center>EARFCN_UL</th><th align=center>EARFCN_DL</th><th align=center>BANDWIDTH_UL</th><th align=center>BANDWIDTH_DL</th><th align=center>IND_OFFSET[dB]</th><th align=center>QOFFSET_CELL[dB]</th><th align=center>IS_REMOVE_ALLOWED</th><th align=center>IS_HOALLOWED</th><th align=center>OWNER_TYPE</th><th align=center>CURRENT_RANK</th><th align=center>PREVIOUS_RANK</th><th align=center>IS_COLOCATED</th>/tr>\n");


# if ((!@alphaeutranlog) && (!@betaeutranlog) && (!@gammaeutranlog) && (!@alphaeutranlog) && (!@betaeutranlog2) && (!@gammaeutranlog2)){
      
      # print (HTMLFILE "<td bgcolor=#FF0000 align=center>NO EUTRAN NBR</td>\n"); 
      
      # }
# if ((@alphaeutranlog) || (@betaeutranlog) || (@gammaeutranlog) || (@alphaeutranlog) || (@betaeutranlog2) || (@gammaeutranlog2)){
# print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>RELATION_IDX</th><th align=center>STATUS</th><th align=center>ENB_ID</th><th align=center>TARGET_CELL_NUM</th><th align=center>IS_REMOVE_ALLOWED</th><th align=center>ENB_MCC</th><th align=center>ENB_MNC</th><th align=center>MCC0</th><th align=center>MNC0</th><th align=center>MCC1</th><th align=center>MNC1</th></tr>\n");  

# if ($alphapci ne ""){  
# foreach $_(@alphaeutranlog){

# @_ = split (/,/,$_);


      
      # print (HTMLFILE "<td align=center>$_[0]</td>\n");
      # print (HTMLFILE "<td align=center>$_[1]</td>\n");
      # print (HTMLFILE "<td align=center>$_[2]</td>\n");
      # if ($_[3] eq $enbid){
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            # }
      # if ($_[3] ne $enbid){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            # }      
      # print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      # if ($_[5] eq "False"){
          # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            # }
      # if ($_[5] ne "False"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            # }      
      # if ($_[6] eq "310"){
          # print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            # }
      # if ($_[6] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            # }   
      # if ($_[7] eq "120"){
          # print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            # }
      # if ($_[7] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            # }             
      # if ($_[8] eq "310"){
          # print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            # }
      # if ($_[8] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            # }             
      # if ($_[9] eq "120"){
          # print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            # }
      # if ($_[9] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            # } 
      # if ($_[10] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            # }
      # if ($_[10] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            # }             
      # if ($_[11] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            # }
      # if ($_[11] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            # }             
            
                                 
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");
                
                  # }      

                    # } 

# if ($betapci ne ""){  
# foreach $_(@betaeutranlog){

# @_ = split (/,/,$_);


      
      # print (HTMLFILE "<td align=center>$_[0]</td>\n");
      # print (HTMLFILE "<td align=center>$_[1]</td>\n");
      # print (HTMLFILE "<td align=center>$_[2]</td>\n");
      # if ($_[3] eq $enbid){
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            # }
      # if ($_[3] ne $enbid){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            # }      
      # print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      # if ($_[5] eq "False"){
          # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            # }
      # if ($_[5] ne "False"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            # }      
      # if ($_[6] eq "310"){
          # print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            # }
      # if ($_[6] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            # }   
      # if ($_[7] eq "120"){
          # print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            # }
      # if ($_[7] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            # }             
      # if ($_[8] eq "310"){
          # print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            # }
      # if ($_[8] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            # }             
      # if ($_[9] eq "120"){
          # print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            # }
      # if ($_[9] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            # } 
      # if ($_[10] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            # }
      # if ($_[10] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            # }             
      # if ($_[11] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            # }
      # if ($_[11] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            # }             
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");
                
                  # }      

                    # } 

# if ($gammapci ne ""){  
# foreach $_(@gammaeutranlog){

# @_ = split (/,/,$_);


      
      # print (HTMLFILE "<td align=center>$_[0]</td>\n");
      # print (HTMLFILE "<td align=center>$_[1]</td>\n");
      # print (HTMLFILE "<td align=center>$_[2]</td>\n");
      # if ($_[3] eq $enbid){
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            # }
      # if ($_[3] ne $enbid){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            # }      
      # print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      # if ($_[5] eq "False"){
          # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            # }
      # if ($_[5] ne "False"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            # }      
      # if ($_[6] eq "310"){
          # print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            # }
      # if ($_[6] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            # }   
      # if ($_[7] eq "120"){
          # print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            # }
      # if ($_[7] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            # }             
      # if ($_[8] eq "310"){
          # print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            # }
      # if ($_[8] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            # }             
      # if ($_[9] eq "120"){
          # print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            # }
      # if ($_[9] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            # } 
      # if ($_[10] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            # }
      # if ($_[10] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            # }             
      # if ($_[11] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            # }
      # if ($_[11] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            # }               
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");
                
                  # }      

                    # } 
# if ($alphapci ne ""){  
# foreach $_(@alphaeutranlog2){

# @_ = split (/,/,$_);


      
      # print (HTMLFILE "<td align=center>$_[0]</td>\n");
      # print (HTMLFILE "<td align=center>$_[1]</td>\n");
      # print (HTMLFILE "<td align=center>$_[2]</td>\n");
      # if ($_[3] eq $enbid){
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            # }
      # if ($_[3] ne $enbid){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            # }      
      # print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      # if ($_[5] eq "False"){
          # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            # }
      # if ($_[5] ne "False"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            # }      
      # if ($_[6] eq "310"){
          # print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            # }
      # if ($_[6] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            # }   
      # if ($_[7] eq "120"){
          # print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            # }
      # if ($_[7] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            # }             
      # if ($_[8] eq "310"){
          # print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            # }
      # if ($_[8] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            # }             
      # if ($_[9] eq "120"){
          # print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            # }
      # if ($_[9] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            # } 
      # if ($_[10] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            # }
      # if ($_[10] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            # }             
      # if ($_[11] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            # }
      # if ($_[11] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            # }             
            
                                 
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");
                
                  # }      

                    # } 

# if ($betapci ne ""){  
# foreach $_(@betaeutranlog2){

# @_ = split (/,/,$_);


      
      # print (HTMLFILE "<td align=center>$_[0]</td>\n");
      # print (HTMLFILE "<td align=center>$_[1]</td>\n");
      # print (HTMLFILE "<td align=center>$_[2]</td>\n");
      # if ($_[3] eq $enbid){
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            # }
      # if ($_[3] ne $enbid){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            # }      
      # print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      # if ($_[5] eq "False"){
          # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            # }
      # if ($_[5] ne "False"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            # }      
      # if ($_[6] eq "310"){
          # print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            # }
      # if ($_[6] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            # }   
      # if ($_[7] eq "120"){
          # print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            # }
      # if ($_[7] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            # }             
      # if ($_[8] eq "310"){
          # print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            # }
      # if ($_[8] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            # }             
      # if ($_[9] eq "120"){
          # print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            # }
      # if ($_[9] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            # } 
      # if ($_[10] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            # }
      # if ($_[10] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            # }             
      # if ($_[11] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            # }
      # if ($_[11] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            # }             
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");
                
                  # }      

                    # } 

# if ($gammapci ne ""){  
# foreach $_(@gammaeutranlog2){

# @_ = split (/,/,$_);


      
      # print (HTMLFILE "<td align=center>$_[0]</td>\n");
      # print (HTMLFILE "<td align=center>$_[1]</td>\n");
      # print (HTMLFILE "<td align=center>$_[2]</td>\n");
      # if ($_[3] eq $enbid){
          # print (HTMLFILE "<td align=center>$_[3]</td>\n");              
            # }
      # if ($_[3] ne $enbid){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");               
            # }      
      # print (HTMLFILE "<td align=center>$_[4]</td>\n");
      
      # if ($_[5] eq "False"){
          # print (HTMLFILE "<td align=center>$_[5]</td>\n");  
            # }
      # if ($_[5] ne "False"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n"); 
            # }      
      # if ($_[6] eq "310"){
          # print (HTMLFILE "<td align=center>$_[6]</td>\n");  
            # }
      # if ($_[6] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n"); 
            # }   
      # if ($_[7] eq "120"){
          # print (HTMLFILE "<td align=center>$_[7]</td>\n");  
            # }
      # if ($_[7] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n"); 
            # }             
      # if ($_[8] eq "310"){
          # print (HTMLFILE "<td align=center>$_[8]</td>\n");  
            # }
      # if ($_[8] ne "310"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n"); 
            # }             
      # if ($_[9] eq "120"){
          # print (HTMLFILE "<td align=center>$_[9]</td>\n");  
            # }
      # if ($_[9] ne "120"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n"); 
            # } 
      # if ($_[10] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[10]</td>\n");  
            # }
      # if ($_[10] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n"); 
            # }             
      # if ($_[11] eq "FFF"){
          # print (HTMLFILE "<td align=center>$_[11]</td>\n");  
            # }
      # if ($_[11] ne "FFF"){
          # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n"); 
            # }               
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");
                
                  # }      

                    # }                                                                 
# }                    
print (HTMLFILE "</table>\n"); 

####################################
#RTRV-C1XRTT-PREG;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-C1XRTT-PREG</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CSFB_PRE_REG_USAGE</th><th align=center>SID</th><th align=center>NID</th><th align=center>MULTIPLE_SID</th><th align=center>MULTIPLE_NID</th><th align=center>HOME_REG</th><th align=center>FOREIGN_SID_REG</th><th align=center>FOREIGN_NID_REG</th><th align=center>PARAMETER_REG</th><th align=center>POWER_UP_REG</th><th align=center>REGISTRATION_PERIOD</th><th align=center>REGISTRATION_ZONE</th><th align=center>TOTAL_ZONE</th><th align=center>ZONE_TIMER</th><th align=center>POWER_DOWN_REG_IND</th></tr>\n"); 
 

# if (!@c1xrttpreg){
      # print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#FF0000><b>C1XRTT-PREG NOT CONFIGURED</b></td></tr>\n");  

      # print (HTMLFILE "</td>\n");
      # print (HTMLFILE "</tr>\n");  
      
      # }
# if (@c1xrttpreg){
# print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CSFB_PRE_REG_USAGE</th><th align=center>SID</th><th align=center>NID</th></tr>\n");       
# foreach $_(@c1xrttpreg){

# @_ = split (/,/,$_);

    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    
    # if ($_[1] eq "use"){
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # }
    # if ($_[1] ne "use"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # }   
    
    # if ($_[2] ne "0"){
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # }
    # if ($_[2] eq "0"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # }     

    # if ($_[3] ne "0"){
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");
    # }
    # if ($_[3] eq "0"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    # }
         
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

   # }
                     
# }                       
                       
print (HTMLFILE "</table>\n"); 

####################
#RTRV-C1XRTT-MOBIL;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-C1XRTT-MOBIL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>LTM_OFF_TDD</th><th align=center>DAYLT_TDD</th></tr>\n");  

# foreach $_(@ltm){

# @_ = split (/,/,$_);

    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    
    # if ($_[1] eq $ltm){
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # }
    # if ($_[1] ne $ltm){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # }   
    
    # if ($_[2] eq "0"){
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # }
    # if ($_[2] ne "0"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # }     
    
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

    # }



print (HTMLFILE "</table>\n"); 

##############################
#RTRV-SONFN-CELL:; 

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=17 align=center bgcolor=#EEEEEE><b>RTRV-SONFN-CELL</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>PRE OAR ANR_ENABLE</th><th align=center>POST OAR ANR_ENABLE</th><th align=center>INTER_RAT_ANR_ENABLE1_X_RTT</th><th align=center>INTER_RAT_ANR_ENABLE_HRPD</th><th align=center>MOBILITY_ROBUSTNESS_ENABLE</th><th align=center>RACH_OPT_ENABLE</th><th align=center>PERIODIC_ANR_FLAG</th><th align=center>ANR_UE_SEARCH_RATE_TOTAL[%]</th><th align=center>ANR_UE_SEARCH_RATE_INTRA_FREQ[%]</th><th align=center>ANR_UE_SEARCH_RATE_INTER_FREQ[%]</th><th align=center>ANR_UE_SEARCH_RATE_C1_XRTT[%]</th><th align=center>ANR_MEAS_DURATION_INTER_FREQ[sec]</th><th align=center>ANR_MEAS_DURATION_C1_XRTT[sec]</th><th align=center>ANR_MEAS_DURATION_HRPD[sec]</th><th align=center>PCI_DRC_FLAG</th><th align=center>RSI_CONFLICT_ENABLE</th></tr>\n");  
  
# foreach $_(@sonfn){

# @_ = split (/,/,$_);
# if ($_[0] <= 11){
      
      
    # print (HTMLFILE "<td align=center>$_[0]</td>\n");
    # if ($_[1] eq "Off"){
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # }    
    # if ($_[1] ne "Off"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # $sonfngp = "true";
    # } 
    # if ($_[1] eq "Auto"){
    # print (HTMLFILE "<td align=center>$_[1]</td>\n");
    # }    
    # if ($_[1] ne "Auto"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[1]</td>\n");
    # $sonfngp = "true";
    # } 
    # if ($_[2] eq "Off"){
    # print (HTMLFILE "<td align=center>$_[2]</td>\n");
    # }    
    # if ($_[2] ne "Off"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[2]</td>\n");
    # $sonfngp = "true";
    # }      

    # if ($_[3] eq "Off"){
    # print (HTMLFILE "<td align=center>$_[3]</td>\n");
    # }    
    # if ($_[3] ne "Off"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[3]</td>\n");
    # $sonfngp = "true";
    # }    
    
    # if ($_[4] eq "Off"){
    # print (HTMLFILE "<td align=center>$_[4]</td>\n");
    # }    
    # if ($_[4] ne "Off"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[4]</td>\n");
    # $sonfngp = "true";
    # }            


    # if ($_[5] eq "Off"){
    # print (HTMLFILE "<td align=center>$_[5]</td>\n");
    # }    
    # if ($_[5] ne "Off"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[5]</td>\n");
    # $sonfngp = "true";
    # }    

    # if ($_[6] eq "False"){
    # print (HTMLFILE "<td align=center>$_[6]</td>\n");
    # }    
    # if ($_[6] ne "False"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[6]</td>\n");
    # $sonfngp = "true";
    # }  
       
    # if ($_[7] eq "5"){
    # print (HTMLFILE "<td align=center>$_[7]</td>\n");
    # }    
    # if ($_[7] ne "5"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[7]</td>\n");
    # $sonfngp = "true";
    # }     
    
    # if ($_[8] eq "0"){
    # print (HTMLFILE "<td align=center>$_[8]</td>\n");
    # }    
    # if ($_[8] ne "0"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[8]</td>\n");
    # $sonfngp = "true";
    # }       
    
    # if ($_[9] eq "0"){
    # print (HTMLFILE "<td align=center>$_[9]</td>\n");
    # }    
    # if ($_[9] ne "0"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[9]</td>\n");
    # $sonfngp = "true";
    # }       
    
    # if ($_[10] eq "100"){
    # print (HTMLFILE "<td align=center>$_[10]</td>\n");
    # }    
    # if ($_[10] ne "100"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[10]</td>\n");
    # $sonfngp = "true";
    # }   
    
    # if ($_[11] eq "100"){
    # print (HTMLFILE "<td align=center>$_[11]</td>\n");
    # }    
    # if ($_[11] ne "100"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[11]</td>\n");
    # $sonfngp = "true";
    # }     

    # if ($_[12] eq "10"){
    # print (HTMLFILE "<td align=center>$_[12]</td>\n");
    # }    
    # if ($_[12] ne "10"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[12]</td>\n");
    # $sonfngp = "true";
    # }     

    # if ($_[13] eq "10"){
    # print (HTMLFILE "<td align=center>$_[13]</td>\n");
    # }    
    # if ($_[13] ne "10"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[13]</td>\n");
    # $sonfngp = "true";
    # }   

    # if ($_[14] eq "10"){
    # print (HTMLFILE "<td align=center>$_[14]</td>\n");
    # }    
    # if ($_[14] ne "10"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[14]</td>\n");
    # $sonfngp = "true";
    # } 

    # if ($_[15] eq "True"){
    # print (HTMLFILE "<td align=center>$_[15]</td>\n");
    # }    
    # if ($_[15] ne "True"){
    # print (HTMLFILE "<td bgcolor=#FF0000 align=center>$_[15]</td>\n");
    # $sonfngp = "true";
    # } 
                                    
    # print (HTMLFILE "</td>\n");
    # print (HTMLFILE "</tr>\n");

    # }


                    # } 
                    
                    
# print (HTMLFILE "</table>\n"); 
                   # }
# if ($pkg =~ m/^4/) {
# print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
# print (HTMLFILE "<tr><td colspan=22 bgcolor=#EEEEEE><b>RTRV-SONFN-CELL</b></td></tr>\n");
# print (HTMLFILE "<tr>
# <th align=center>CELL_NUM</th>
# <th align=center>ANR_ENABLE</th>
# <th align=center>INTER_RAT_ANR_ENABLE1_X_RTT</th>
# <th align=center>INTER_RAT_ANR_ENABLE_HRPD</th>
# <th align=center>ENERGY_SAVINGS_ENABLE</th>
# <th align=center>MOBILITY_ROBUSTNESS_ENABLE</th>
# <th align=center>RACH_OPT_ENABLE</th>
# <th align=center>PERIODIC_ANR_FLAG</th>
# <th align=center>ANR_UE_SEARCH_RATE_TOTAL</th>
# <th align=center>ANR_UE_SEARCH_RATE_INTRA_FREQ</th>
# <th align=center>ANR_UE_SEARCH_RATE_INTER_FREQ</th>
# <th align=center>ANR_UE_SEARCH_RATE_C1_XRTT</th>
# <th align=center>ANR_UE_SEARCH_RATE_HRPD</th>
# <th align=center>ANR_MEAS_DURATION_INTER_FREQ</th>
# <th align=center>ANR_MEAS_DURATION_C1_XRTT</th>
# <th align=center>ANR_MEAS_DURATION_HRPD</th>
# <th align=center>PCI_DRC_FLAG</th>
# <th align=center>ES_SCAILING_FACTOR_LB</th>
# <th align=center>ES_SCALING_FACTOR_CAC</th>
# <th align=center>RSI_CONFLICT_ENABLE</th>
# <th align=center>SON_CCO_PWR_CTRL_ENABLE</th>
# <th align=center>SON_COC_PWR_CTRL_ENABLE</th>
# </tr>\n");

# foreach my $CELL_NUM (sort {$a<=>$b} keys %hash_SONFN_CELL) { 
# my $ANR_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{ANR_ENABLE};
# my $INTER_RAT_ANR_ENABLE1_X_RTT = $hash_SONFN_CELL{$CELL_NUM}{INTER_RAT_ANR_ENABLE1_X_RTT};
# my $INTER_RAT_ANR_ENABLE_HRPD = $hash_SONFN_CELL{$CELL_NUM}{INTER_RAT_ANR_ENABLE_HRPD};
# my $ENERGY_SAVINGS_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{ENERGY_SAVINGS_ENABLE};
# my $MOBILITY_ROBUSTNESS_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{MOBILITY_ROBUSTNESS_ENABLE};
# my $RACH_OPT_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{RACH_OPT_ENABLE};
# my $PERIODIC_ANR_FLAG = $hash_SONFN_CELL{$CELL_NUM}{PERIODIC_ANR_FLAG};
# my $ANR_UE_SEARCH_RATE_TOTAL = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_TOTAL};
# my $ANR_UE_SEARCH_RATE_INTRA_FREQ = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_INTRA_FREQ};
# my $ANR_UE_SEARCH_RATE_INTER_FREQ = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_INTER_FREQ};
# my $ANR_UE_SEARCH_RATE_C1_XRTT = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_C1_XRTT};
# my $ANR_UE_SEARCH_RATE_HRPD = $hash_SONFN_CELL{$CELL_NUM}{ANR_UE_SEARCH_RATE_HRPD};
# my $ANR_MEAS_DURATION_INTER_FREQ = $hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_INTER_FREQ};
# my $ANR_MEAS_DURATION_C1_XRTT = $hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_C1_XRTT};
# my $ANR_MEAS_DURATION_HRPD = $hash_SONFN_CELL{$CELL_NUM}{ANR_MEAS_DURATION_HRPD};
# my $PCI_DRC_FLAG = $hash_SONFN_CELL{$CELL_NUM}{PCI_DRC_FLAG};
# my $ES_SCAILING_FACTOR_LB = $hash_SONFN_CELL{$CELL_NUM}{ES_SCAILING_FACTOR_LB};
# my $ES_SCALING_FACTOR_CAC = $hash_SONFN_CELL{$CELL_NUM}{ES_SCALING_FACTOR_CAC};
# my $RSI_CONFLICT_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{RSI_CONFLICT_ENABLE};
# my $SON_CCO_PWR_CTRL_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{SON_CCO_PWR_CTRL_ENABLE};
# my $SON_COC_PWR_CTRL_ENABLE = $hash_SONFN_CELL{$CELL_NUM}{SON_COC_PWR_CTRL_ENABLE};
# print (HTMLFILE "<tr>\n");
# print (HTMLFILE "<td align=center>$CELL_NUM</td>\n");

# if ($ANR_ENABLE eq "$hash_sonfn_cell_values{ANR_ENABLE}") {
# print (HTMLFILE "<td align=center>$ANR_ENABLE</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_ENABLE</td>\n");
# }


# if ($INTER_RAT_ANR_ENABLE1_X_RTT eq "$hash_sonfn_cell_values{INTER_RAT_ANR_ENABLE1_X_RTT}") {
# print (HTMLFILE "<td align=center>$INTER_RAT_ANR_ENABLE1_X_RTT</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$INTER_RAT_ANR_ENABLE1_X_RTT</td>\n");
# }


# if ($INTER_RAT_ANR_ENABLE_HRPD eq "$hash_sonfn_cell_values{INTER_RAT_ANR_ENABLE_HRPD}") {
# print (HTMLFILE "<td align=center>$INTER_RAT_ANR_ENABLE_HRPD</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$INTER_RAT_ANR_ENABLE_HRPD</td>\n");
# }


# if ($ENERGY_SAVINGS_ENABLE eq "$hash_sonfn_cell_values{ENERGY_SAVINGS_ENABLE}") {
# print (HTMLFILE "<td align=center>$ENERGY_SAVINGS_ENABLE</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ENERGY_SAVINGS_ENABLE</td>\n");
# }


# if ($MOBILITY_ROBUSTNESS_ENABLE eq "$hash_sonfn_cell_values{MOBILITY_ROBUSTNESS_ENABLE}") {
# print (HTMLFILE "<td align=center>$MOBILITY_ROBUSTNESS_ENABLE</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$MOBILITY_ROBUSTNESS_ENABLE</td>\n");
# }


# if ($RACH_OPT_ENABLE eq "$hash_sonfn_cell_values{RACH_OPT_ENABLE}") {
# print (HTMLFILE "<td align=center>$RACH_OPT_ENABLE</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$RACH_OPT_ENABLE</td>\n");
# }


# if ($PERIODIC_ANR_FLAG eq "$hash_sonfn_cell_values{PERIODIC_ANR_FLAG}") {
# print (HTMLFILE "<td align=center>$PERIODIC_ANR_FLAG</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$PERIODIC_ANR_FLAG</td>\n");
# }


# if ($ANR_UE_SEARCH_RATE_TOTAL eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_TOTAL}") {
# print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_TOTAL</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_TOTAL</td>\n");
# }


# if ($ANR_UE_SEARCH_RATE_INTRA_FREQ eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_INTRA_FREQ}") {
# print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_INTRA_FREQ</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_INTRA_FREQ</td>\n");
# }


# if ($ANR_UE_SEARCH_RATE_INTER_FREQ eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_INTER_FREQ}") {
# print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_INTER_FREQ</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_INTER_FREQ</td>\n");
# }


# if ($ANR_UE_SEARCH_RATE_C1_XRTT eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_C1_XRTT}") {
# print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_C1_XRTT</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_C1_XRTT</td>\n");
# }


# if ($ANR_UE_SEARCH_RATE_HRPD eq "$hash_sonfn_cell_values{ANR_UE_SEARCH_RATE_HRPD}") {
# print (HTMLFILE "<td align=center>$ANR_UE_SEARCH_RATE_HRPD</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_UE_SEARCH_RATE_HRPD</td>\n");
# }


# if ($ANR_MEAS_DURATION_INTER_FREQ eq "$hash_sonfn_cell_values{ANR_MEAS_DURATION_INTER_FREQ}") {
# print (HTMLFILE "<td align=center>$ANR_MEAS_DURATION_INTER_FREQ</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_MEAS_DURATION_INTER_FREQ</td>\n");
# }


# if ($ANR_MEAS_DURATION_C1_XRTT eq "$hash_sonfn_cell_values{ANR_MEAS_DURATION_C_XRTT}") {
# print (HTMLFILE "<td align=center>$ANR_MEAS_DURATION_C1_XRTT</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_MEAS_DURATION_C1_XRTT</td>\n");
# }


# if ($ANR_MEAS_DURATION_HRPD eq "$hash_sonfn_cell_values{ANR_MEAS_DURATION_HRPD}") {
# print (HTMLFILE "<td align=center>$ANR_MEAS_DURATION_HRPD</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ANR_MEAS_DURATION_HRPD</td>\n");
# }


# if ($PCI_DRC_FLAG eq "$hash_sonfn_cell_values{PCI_DRC_FLAG}") {
# print (HTMLFILE "<td align=center>$PCI_DRC_FLAG</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$PCI_DRC_FLAG</td>\n");
# }


# if ($ES_SCAILING_FACTOR_LB eq "$hash_sonfn_cell_values{ES_SCAILING_FACTOR_LB}") {
# print (HTMLFILE "<td align=center>$ES_SCAILING_FACTOR_LB</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ES_SCAILING_FACTOR_LB</td>\n");
# }


# if ($ES_SCALING_FACTOR_CAC eq "$hash_sonfn_cell_values{ES_SCALING_FACTOR_CAC}") {
# print (HTMLFILE "<td align=center>$ES_SCALING_FACTOR_CAC</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$ES_SCALING_FACTOR_CAC</td>\n");
# }


# if ($RSI_CONFLICT_ENABLE eq "$hash_sonfn_cell_values{RSI_CONFLICT_ENABLE}") {
# print (HTMLFILE "<td align=center>$RSI_CONFLICT_ENABLE</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$RSI_CONFLICT_ENABLE</td>\n");
# }


# if ($SON_CCO_PWR_CTRL_ENABLE eq "$hash_sonfn_cell_values{SON_CCO_PWR_CTRL_ENABLE}") {
# print (HTMLFILE "<td align=center>$SON_CCO_PWR_CTRL_ENABLE</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$SON_CCO_PWR_CTRL_ENABLE</td>\n");
# }


# if ($SON_COC_PWR_CTRL_ENABLE eq "$hash_sonfn_cell_values{SON_COC_PWR_CTRL_ENABLE}") {
# print (HTMLFILE "<td align=center>$SON_COC_PWR_CTRL_ENABLE</td>\n");
# }
# else {
# print (HTMLFILE "<td bgcolor=#FF0000 align=center>$SON_COC_PWR_CTRL_ENABLE</td>\n");
# }

# print (HTMLFILE "</tr>\n");

                                                             # }






print (HTMLFILE "</table>\n"); 

##################################
#RTRV-CELL-CAC;
##################

######################
#RTRV-CA-COLOC; 
##############

##################
#RTRV-CACELL-INFO;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CACELL-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>CA_AVAILABLE_TYPE</th><th align=center>P_CELL_ONLY_FLAG</th><th align=center>MAX_DL_CA_CC_NUM</th><th align=center>MAX_UL_CA_CC_NUM</th><th align=center>CA_OPERATION_MODE</th><th align=center>SMART_CA_FLAG</th><th align=center>PFS_FLAG</th><th align=center>A6_OFFSET_DELTA</th><th align=center>INTER_FREQ_HO_FOR_CA_ENABLE</th><th align=center>DATA_TRAFFIC_THRESHOLD</th><th align=center>CONTROL_FACTOR_FOR_4LAYER_MIMO[%]</th></tr>\n");																																																																						

print (HTMLFILE "</table>\n"); 


#######################
#RTRV-CASCHED-INF;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CASCHED-INF</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>SCHEDULABILITY_UNIT</th></tr>\n");

print (HTMLFILE "</table>\n"); 

#################
#RTRV-CABAND-INFO;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=13 align=center bgcolor=#EEEEEE><b>RTRV-CABAND-INFO</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>BAND_COMBINATION_LIST_INDEX</th><th align=center>STATUS</th><th align=center>BAND0_USAGE</th><th align=center>BAND_INDICATOR0</th><th align=center>CA_BANDWIDTH_CLASS_DL0</th><th align=center>BAND1_USAGE</th><th align=center>BAND_INDICATOR1</th><th align=center>CA_BANDWIDTH_CLASS_DL1</th><th align=center>BAND2_USAGE</th><th align=center>BAND_INDICATOR2</th><th align=center>CA_BANDWIDTH_CLASS_DL2</th><th align=center>BAND3_USAGE</th><th align=center>BAND_INDICATOR3</th><th align=center>CA_BANDWIDTH_CLASS_DL3</th><th align=center>BAND4_USAGE</th><th align=center>BAND_INDICATOR4</th><th align=center>CA_BANDWIDTH_CLASS_DL4</th><th align=center>CA_BANDWIDTH_CLASS_UL0</th><th align=center>CA_BANDWIDTH_CLASS_UL1</th><th align=center>CA_BANDWIDTH_CLASS_UL2</th><th align=center>CA_BANDWIDTH_CLASS_UL3</th><th align=center>CA_BANDWIDTH_CLASS_UL4</th></tr>\n"); 								

print (HTMLFILE "</table>\n"); 

###############
#RTRV-ALD-INVT:CONN_BD_ID=1,CONN_PORT_ID=0,ALD_ID=0;
############

#################
#RTRV-CELL-UECNT;

print (HTMLFILE "<br><br><table width=100% cellspacing=0 cellpadding=5 border=1 bordercolor=#000000>\n");
print (HTMLFILE "<tr><td colspan=11 align=center bgcolor=#EEEEEE><b>RTRV-CELL-UECNT</b></td></tr>\n");
print (HTMLFILE "<tr><th align=center>CELL_NUM</th><th align=center>ACTIVE_UECOUNT</th><th align=center>EMER_AC_UECOUNT</th><th align=center>H_PRIORITY_AC_UECOUNT</th><th align=center>M_TERM_AC_UECOUNT</th><th align=center>M_ORG_SIGNAL_AC_UECOUNT</th><th align=center>M_ORG_DATA_AC_UECOUNT</th><th align=center>RELOCATE_HOCOUNT</th><th align=center>DTA_UECOUNT</th><th align=center>S_CELL_UE_COUNT</th></tr>\n");


print (HTMLFILE "</table>\n"); 

############
#MON-TEST:;




print "ending \n";