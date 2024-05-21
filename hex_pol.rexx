/**REXX**/                                            
SAY "ENTER YOUR POLICY"                               
PULL POLICY                                           
OUT = ""                                              
DO I = 1 TO LENGTH(POLICY)                            
  STR = SUBSTR(POLICY, I, 1)                          
  IF DATATYPE(STR, 'N') THEN OUT = OUT || "3"STR      
END                                                   
SAY "F X'"OUT"'"                                      
