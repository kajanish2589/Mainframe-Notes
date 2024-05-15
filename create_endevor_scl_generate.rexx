/*REXX*/                                                            
ADDRESS TSO                                                         
INPUT_FILE = "'CNOALN.PRINT5'"                                      
OUTPUT_FILE = "'CNOALN.TEST.SCL'"                                   
ADDRESS TSO "DEL 'CNOALN.TEST.SCL'"                                 
"ALLOC F(INFILE) DSN("INPUT_FILE") SHR REUSE"                       
"EXECIO * DISKR INFILE( FINIS STEM MYFILE."                         
"FREE F(INFILE)"                                                    
I = 1                                                               
DO WHILE I <= MYFILE.0                                              
MF.1 = "GENERATE ELEMENT '"STRIP(SUBSTR(MYFILE.I,01,10))"'"         
MF.2 = "  FROM ENVIRONMENT 'INTG' SYSTEM 'VANTU' SUBSYSTEM 'LVU' "  
MF.3 = "    TYPE 'LINKCNTL' STAGE I "                               
MF.4 = "  OPTIONS CCID '55964' COMMENTS '55964-DSS INTO PPLUS' "    
MF.5 = "    OVERRIDE SIGNOUT"                                       
MF.6 = " ."                                                         
SAY I                                                               
"ALLOC DA("OUTPUT_FILE") FI(OUTPUT) MOD REUSE"                      
"EXECIO * DISKW OUTPUT (FINIS STEM MF."  
"FREE FI(OUTPUT)"                        
I = I + 1                                
END                                      
EXIT 0                                   
