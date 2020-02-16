SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE BODY features IS
             
			 PROCEDURE localTransparency_read( id IN INT) IS
			      sup_name VARCHAR(20);
			      sup_name1 VARCHAR(20);
			      flag INT;
			
                              BEGIN
			      flag :=1;
				IF (flag = 1) THEN
				     SELECT name INTO sup_name FROM EX_ORDERS@site_link2 ex WHERE ex.part_id = id;
				     DBMS_OUTPUT.PUT_LINE('Name of the Supplier ' || sup_name || ' Whose Component id is ' || id ); 
				END IF;
	            
				
				
			     EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                  flag :=0; 
			          IF (flag = 0) THEN
                                               SELECT name INTO sup_name1 FROM FN_ORDERS@site_link2 ex WHERE ex.part_id = id;
                                               DBMS_OUTPUT.PUT_LINE('Name of the Supplier ' || sup_name1 || ' Whose Component id is ' || id ); 						   
			           END IF;	
			     
          		     END localTransparency_read;
			 
			 PROCEDURE localTransparency_update( id IN INT ,update_id IN INT) IS
			      sup_name VARCHAR(20);
			      a INT;
			      b VARCHAR(20);
                              BEGIN
				
			 	IF(id=1 OR id =3 OR id=5 OR id=7 OR id =9) THEN
                                     SELECT name,quantity,buyer INTO sup_name,a,b FROM EX_ORDERS@site_link2 ex WHERE ex.part_id = id;
                                      IF( update_id=1 OR update_id=3 OR update_id=5 OR update_id = 7 OR update_id=9) THEN
					    DELETE FROM EX_ORDERS@site_link2 WHERE part_id = id;
                                            DELETE FROM Supplier WHERE cid = id;						
  					    INSERT INTO EX_ORDERS@site_link2 VALUES(sup_name,update_id,a,b);
					    INSERT INTO Supplier VALUES(update_id,b,sup_name,1,a);
				      ELSE
                                            DELETE FROM EX_ORDERS@site_link2 WHERE part_id = id;
                                            DELETE FROM Supplier WHERE cid = id;						
		        	            INSERT INTO FN_ORDERS@site_link2 VALUES(sup_name,update_id,a,b);
				            INSERT INTO Supplier VALUES(update_id,b,sup_name,2,a);	
                                       END IF;

 				ELSE 
                   	           SELECT name,quantity,buyer INTO sup_name,a,b FROM FN_ORDERS ex WHERE ex.part_id = id;
                                   IF( update_id=2 OR update_id=4 OR update_id=6 OR update_id = 8 OR update_id=10) THEN
					    DELETE FROM FN_ORDERS@site_link2 WHERE part_id = id;
                                            DELETE FROM Supplier WHERE cid = id;						
					    INSERT INTO FN_ORDERS@site_link2 VALUES(sup_name,update_id,a,b);
				            INSERT INTO Supplier VALUES(update_id,b,sup_name,2,a);
			            ELSE
                                        DELETE FROM FN_ORDERS@site_link2 WHERE part_id = id;
                                        DELETE FROM Supplier WHERE cid = id;						
				        INSERT INTO EX_ORDERS@site_link2 VALUES(sup_name,update_id,a,b);
				 	INSERT INTO Supplier VALUES(update_id,b,sup_name,1,a);	
                                    END IF;
					
				END IF;	
			     
			 END localTransparency_update;
			 
			
END features;