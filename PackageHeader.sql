CREATE OR REPLACE PACKAGE features IS 
         
         PROCEDURE localTransparency_read( id IN INT);  -- read a Supplier id and show his name; 
         PROCEDURE localTransparency_update( id IN INT, update_id IN INT ); --read a Supplier id and update his part_id id;  	
             		 

END features; 
/