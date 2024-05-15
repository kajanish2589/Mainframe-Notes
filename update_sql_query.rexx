/*REXX*/                                               
INPUT_FILE = "'USERID.TEST.SCL.INPUT'"                 
OUTPUT_FILE = "'USERID.TEST.SCL'"                      
/*DELETE OUTPUT FILE*/                                 
ADDRESS TSO "DEL 'USERID.TEST.SCL'"                    
/*ALLOCATE INPUT FILE AS READ*/                        
ADDRESS TSO                                            
"ALLOC F(INFILE) DSN("INPUT_FILE") SHR REUSE"          
"EXECIO * DISKR INFILE( FINIS STEM MYFILE."            
"FREE F(INFILE)"                                       
I = 1                                                  
DO WHILE I <= MYFILE.0                                 
 IF (I <> 1) THEN                                      
  DO                                                   
    CALL CONVERT_NUMERIC(SUBSTR(MYFILE.I,21,15))       
    IF (SUBSTR(MYFILE.I,37,08) <> " ")                 
               THEN;CALL UPDATE_SQL_QUERY_WITH_DOB     
               ELSE;CALL UPDATE_SQL_QUERY_WITHOUT_DOB  
 END                                                            
 I = I + 1                                                      
END                                                             
SAY "UPDATE SQL QUERY CREATION SUCCESSFULLY COMPLETED"          
EXIT 0    

/* FUNCTION FOR SQL UPDATE QUERY WITH DOB DATA*/                
UPDATE_SQL_QUERY_WITH_DOB:                                      
 MF.1 = " UPDATE UPDATE_TABLE_NAME"                                   
 MF.2 = " SET SS_TAX_NUMBER = '"SSN_NUMERIC"',"                 
 MF.3 = "     BIRTH_DATE = '"SUBSTR(MYFILE.I,37,08)"'"          
 MF.4 = " WHERE DIRECTORY_ID IN ( "                             
 MF.5 = "     SELECT DIRECTORY_ID "                             
 MF.6 = "     FROM TABLE_NAME "                                
 MF.7 = "     WHERE COMPANY_CODE = '"SUBSTR(MYFILE.I,01,03)"'"  
 MF.8 = "       AND MASTER_ID = '"SUBSTR(MYFILE.I,05,15)"'"     
 MF.9 = "       AND ROLE_CODE = 'OWN' ); "                      
 MF.10 = " COMMIT; "                                            
 "ALLOC DA("OUTPUT_FILE") FI(OUTPUT) MOD REUSE"                 
 "EXECIO * DISKW OUTPUT (FINIS STEM MF."                       
 "FREE FI(OUTPUT)"                                             
RETURN;                                                        
                                                               
/* FUNCTION FOR SQL UPDATE QUERY WITHOUT DOB DATA*/            
UPDATE_SQL_QUERY_WITHOUT_DOB:                                  
 WO.1 = " UPDATE UPDATE_TABLE_NAME"                                  
 WO.2 = " SET SS_TAX_NUMBER = '"SSN_NUMERIC"'"                 
 WO.3 = " WHERE DIRECTORY_ID IN ( "                            
 WO.4 = "     SELECT DIRECTORY_ID "                            
 WO.5 = "     FROM TABLE_NAME "                               
 WO.6 = "     WHERE COMPANY_CODE = '"SUBSTR(MYFILE.I,01,03)"'" 
 WO.7 = "       AND MASTER_ID = '"SUBSTR(MYFILE.I,05,15)"'"    
 WO.8 = "       AND ROLE_CODE = 'OWN' ); "                     
 WO.9 = " COMMIT; "                                            
 "ALLOC DA("OUTPUT_FILE") FI(OUTPUT) MOD REUSE"                
 "EXECIO * DISKW OUTPUT (FINIS STEM WO."                       
 "FREE FI(OUTPUT)"                                             
RETURN;                                                                
                                                                       
/* FUNCTION USED CONVERT THE HYPHENSTRING INTO NUMBERIC FORMAT*/       
CONVERT_NUMERIC:                                                       
   PARSE ARG SSN_STRING                                                
   SSN_NUMERIC = ''                                                    
   /* LOOP THROUGH EACH CHARACTER IN THE INPUT STRING */               
   DO K = 1 TO LENGTH(SSN_STRING)                                      
       CHAR = SUBSTR(SSN_STRING, K, 1)                                 
       /* IF THE CHARACTER IS NOT A HYPHEN, APPEND IT TO THE NUMERIC */
       IF CHAR \= '-' THEN;SSN_NUMERIC = SSN_NUMERIC || CHAR           
   END                                                                 
   /* PAD THE NUMERIC SSN WITH LEADING SPACES IF NEEDED */             
   SSN_NUMERIC = LEFT(STRIP(SSN_NUMERIC) || '               ',15)      
 /*SAY 'PLAIN NUMERIC FORM:' SSN_NUMERIC*/                             
RETURN SSN_NUMERIC;                                                    
