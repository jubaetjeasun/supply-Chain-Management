clear screen;
SET SERVEROUTPUT ON;
DROP TABLE Components CASCADE CONSTRAINTS;
DROP TABLE Supplier CASCADE CONSTRAINTS;
DROP TABLE Com_mod CASCADE CONSTRAINTS;
DROP TABLE Modules CASCADE CONSTRAINTS;
DROP TABLE Types CASCADE CONSTRAINTS;
DROP TABLE AppleiPad CASCADE CONSTRAINTS;
DROP TABLE Inventory CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;



SET sqlblanklines on;

CREATE TABLE Supplier(
           cid INT NOT NULL,
           buyer VARCHAR(20) NOT NULL,
	   supplier_name VARCHAR (20) NOT NULL,
           sup_id INT NOT NULL,
           qty INT NOT NULL
           --PRIMARY KEY(sup_id)
);

INSERT INTO Supplier VALUES(1,'Manufacture Team','SAKIB',1,25);
INSERT INTO Supplier VALUES(2,'Manufacture Team','ADNAN',2,13);
INSERT INTO Supplier VALUES(3,'Manufacture Team','JEASUN',1,18);
INSERT INTO Supplier VALUES(4,'Manufacture Team','RAKIB',2,26);
INSERT INTO Supplier VALUES(5,'Manufacture Team','FAISAL',1,13);
INSERT INTO Supplier VALUES(6,'Manufacture Team','SHISHIR',2,6);
INSERT INTO Supplier VALUES(7,'Manufacture Team','ADOR',1,9);
INSERT INTO Supplier VALUES(8,'Manufacture Team','PIAS',2,10);
INSERT INTO Supplier VALUES(9,'Manufacture Team','REDWAN',1,17);
INSERT INTO Supplier VALUES(10,'Manufacture Team','ARMAN',2,20);


CREATE TABLE Components(
   
           cid INT NOT NULL,
           cname VARCHAR(100) NOT NULL,
           qty INT NOT NULL,
           sup_id CHAR(5) NOT NULL,
           PRIMARY KEY(cid)
         --  CONSTRAINT fk_xx FOREIGN KEY(sup_id)
          -- REFERENCES Supplier(sup_id) ON DELETE SET NULL
);

INSERT INTO Components VALUES (1,'Battery',10,1);
INSERT INTO Components VALUES (2,'Camera',27,2);
INSERT INTO Components VALUES (3,'Adapter',14,1);
INSERT INTO Components VALUES (4,'LCDs',68,2);
INSERT INTO Components VALUES (5,'Case Components',45,1);
INSERT INTO Components VALUES (6,'Speakers',16,2);
INSERT INTO Components VALUES (7,'Charging cables',10,1);
INSERT INTO Components VALUES (8,'Front Glass',29,2);
INSERT INTO Components VALUES (9,'Switches',11,1);
INSERT INTO Components VALUES (10,'Logic Boards',25,2);



CREATE TABLE Modules(
            mid INT NOT NULL,
            mname VARCHAR(25) NOT NULL,
            mQty INT NOT NULL, 
            --CONSTRAINT mod_pk PRIMARY KEY(mid,mQty)
            PRIMARY KEY(mid)
);

INSERT INTO Modules VALUES(1,'Module A',7);
INSERT INTO Modules VALUES(2,'Module B',8);
INSERT INTO Modules VALUES(3,'Module C',2);
INSERT INTO Modules VALUES(4,'Module D',5);
INSERT INTO Modules VALUES(5,'Module E',3);

    

CREATE TABLE Com_mod(
             
              cid INT NOT NULL,
              mid INT NOT NULL,
              CONSTRAINT com_mod_pk PRIMARY KEY(cid,mid),
              CONSTRAINT fk_com FOREIGN KEY(cid) 
              REFERENCES Components(cid) ON DELETE SET NULL,
              CONSTRAINT fk_mod FOREIGN KEY(mid) 
              REFERENCES Modules(mid) ON DELETE SET NULL
);

INSERT INTO Com_mod Values(1,1);
INSERT INTO Com_mod Values(2,1);
INSERT INTO Com_mod Values(3,2);
INSERT INTO Com_mod Values(4,2);
INSERT INTO Com_mod Values(5,3);
INSERT INTO Com_mod Values(6,3);
INSERT INTO Com_mod Values(7,4);
INSERT INTO Com_mod Values(8,4);
INSERT INTO Com_mod Values(9,5);
INSERT INTO Com_mod Values(10,5); 



CREATE TABLE Types(

           type VARCHAR(15) NOT NULL,
           ram  VARCHAR(50) NOT NULL,
           color VARCHAR(50) NOT NULL,
           caseid INT NOT NULL,
           motherboardid INT NOT NULL,
           accessoryid INT NOT NULL,
           CONSTRAINT types_pk PRIMARY KEY(type), 
           CONSTRAINT fk_mod1 FOREIGN KEY (caseid)
           REFERENCES Modules(mid),
           CONSTRAINT fk_mod2 FOREIGN KEY (motherboardid)
           REFERENCES Modules(mid),
           CONSTRAINT fk_mod3 FOREIGN KEY (accessoryid)
           REFERENCES Modules(mid)
);         
 

INSERT INTO Types VALUES('A','Medium','BLACK',1,3,5);
INSERT INTO Types VALUES('B','Medium','WHITE',2,3,5);
INSERT INTO Types VALUES('C','Large','BLACK',1,4,5);
INSERT INTO Types VALUES('D','Large','WHITE',2,4,5);
 
 
 
 
CREATE TABLE AppleiPad(
           
           pid INT NOT NULL,
           type VARCHAR(15) NOT NULL,
           test_result VARCHAR(50) NOT NULL, 
           sale_status VARCHAR(50) NOT NULL,
           CONSTRAINT appleipad PRIMARY KEY(pid),
           CONSTRAINT fk_type FOREIGN KEY(type)
           REFERENCES Types(type)
);

INSERT INTO AppleiPad VALUES(1,'A','success','not_sold');
INSERT INTO AppleiPad VALUES(2,'B','success','not_sold');
INSERT INTO AppleiPad VALUES(3,'C','success','not_sold');
INSERT INTO AppleiPad VALUES(4,'D','success','not_sold');
INSERT INTO AppleiPad VALUES(5,'B','success','not_sold');
INSERT INTO AppleiPad VALUES(6,'C','success','not_sold');
INSERT INTO AppleiPad VALUES(7,'A','success','not_sold');
INSERT INTO AppleiPad VALUES(8,'D','success','not_sold');
INSERT INTO AppleiPad VALUES(9,'C','success','not_sold');
INSERT INTO AppleiPad VALUES(10,'A','success','not_sold');






CREATE TABLE Inventory(
         
           type VARCHAR(50) NOT NULL,
           inventQty INT NOT NULL,
           CONSTRAINT Inventory_pk PRIMARY KEY(type),
           CONSTRAINT fk_type2 FOREIGN KEY(type)
           REFERENCES Types(type)
);

INSERT INTO Inventory VALUES('A',10);
INSERT INTO Inventory VALUES('B',5);
INSERT INTO Inventory VALUES('C',12);
INSERT INTO Inventory VALUES('D',9);




CREATE TABLE Orders(
                
               order_no INT NOT NULL,
               type VARCHAR(50) NOT NULL,
               qty INT NOT NULL,
               to_be_filled INT NOT NULL,
               CONSTRAINT order_pk PRIMARY KEY(order_no),
               CONSTRAINT fk_inv FOREIGN KEY(type)
               REFERENCES Inventory(type) ON DELETE SET NULL
);


INSERT INTO Orders VALUES(1,'A',3,1);
INSERT INTO Orders VALUES(2,'C',6,0);
INSERT INTO Orders VALUES(3,'A',3,2);
INSERT INTO Orders VALUES(4,'D',2,1);
INSERT INTO Orders VALUES(5,'B',5,3);
INSERT INTO Orders VALUES(6,'C',1,0);
INSERT INTO Orders VALUES(7,'D',6,4);
INSERT INTO Orders VALUES(8,'B',7,2);




CREATE OR REPLACE PROCEDURE deliver (qtyy IN INT, typeInput IN VARCHAR, orderId IN INT)  IS

x INT;

BEGIN

	SELECT i.inventQty INTO x FROM Inventory i WHERE i.type=typeInput;
	IF (x>=qtyy) THEN 
	   DBMS_OUTPUT.PUT_LINE('we have enough AppleiPads in our inventory'); 
	   UPDATE Inventory SET inventQty = inventQty-qtyy WHERE type = typeInput;
	   UPDATE Orders SET to_be_filled = 0 WHERE type = typeInput;
	   DBMS_OUTPUT.PUT_LINE('delivering ' || qtyy ||' type '|| typeInput || ' ipads to Retailer');
	   DBMS_OUTPUT.PUT_LINE('setting status of delivered mipads to sold');
	   setSaleStatus (qtyy , typeInput);
	   INSERT INTO INVENTORY_CONSUMER@site_link2 VALUES (orderId,typeInput,qtyy);
	
	ELSE
	    DBMS_OUTPUT.PUT_LINE('we have not enough AppleiPads in our inventory');

     END IF;    	
	COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE addToInventory (qtyy IN INT, typeInput IN VARCHAR, orderID IN INT)  IS

x INT;

BEGIN
     
	UPDATE Inventory SET inventQty=inventQty+qtyy WHERE type=typeInput;
	SELECT o.qty INTO x FROM Orders o WHERE o.Order_no=orderId;
	DBMS_OUTPUT.PUT_LINE('Inventory Updated');
	deliver (x, typeInput , orderId);
END;

/

CREATE OR REPLACE PROCEDURE testMipad (appleipadNum IN INT) IS


BEGIN

    DBMS_OUTPUT.PUT_LINE('testing ipad with serial number ' || appleipadNum);
    --dbms_job.submit ( job => 1, what => 'myproc(:new.id);', next_date => sysdate+3/24/60/60 );
    DBMS_OUTPUT.PUT_LINE('test took 3 seconds');
    UPDATE AppleiPad SET test_result='success' WHERE pid=appleipadNum;
    UPDATE AppleiPad SET sale_status='for_sale' WHERE pid=appleipadNum;
END;
/




CREATE OR REPLACE PROCEDURE makeNewAppleipads (qtyy IN INT, typeInput IN VARCHAR, orderId IN INT) IS

a INT;
b INT;
x INT;

BEGIN
	
	SELECT MIN(m.pid) INTO a FROM AppleiPad m;
	DBMS_OUTPUT.PUT_LINE('last mipad has serial-no: ' ||a);
	FOR b IN 1..qtyy LOOP
		x:=a+b;
		INSERT INTO AppleiPad VALUES (x, typeInput, 'not_tested', 'not_available');
		DBMS_OUTPUT.PUT_LINE('A mipad with serial number of ' ||x|| ' has been made');
		testMipad (x);
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('All the tests were done successfully');
	COMMIT;
	
	addToInventory(qtyy, typeInput, orderId);
END;
/


CREATE OR REPLACE PROCEDURE assembleModules (qtyy IN INT, typeInput IN VARCHAR, orderId IN INT) IS


BEGIN
	IF (typeInput='A') THEN UPDATE Modules set mQty=mQty-qtyy WHERE mid=1 OR mid=3 OR mid=5;
	END IF;
	
	IF (typeInput='B') THEN UPDATE Modules SET mQty=mQty-qtyy WHERE mid=1 OR mid=4 OR mid=5;
	END IF;
	
	IF (typeInput='C') THEN UPDATE Modules SET mQty=mQty-qtyy WHERE mid=2 OR mid=3 OR mid=5;
	END IF;
	
	IF (typeInput='D') THEN UPDATE Modules SET mQty=mQty-qtyy WHERE mid=2 OR mid=4 OR mid=5;
	END IF;
	
	DBMS_OUTPUT.PUT_LINE(qtyy || ' new mipads of type ' || typeInput || ' has been made' );
	makeNewAppleipads (qtyy, typeInput, orderId);
	COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE assembleComponents (qtyy IN INT, orderId IN INT, moduleId IN INT) IS

BEGIN
	
	IF (moduleId=1) THEN
		UPDATE Components SET qty = qty-qtyy WHERE cid=1 OR cid=2;
		DBMS_OUTPUT.PUT_LINE('number of components 1 and 2 decreased by '|| qtyy);
		UPDATE Modules SET mQty = mQty+qtyy WHERE mid=1;
		--DBMS_OUTPUT.PUT_LINE(qtyy||’ module type 1 was made...total number: ’|| z);
		
		
	ELSIF (moduleId=2) THEN
		UPDATE Components SET qty=qty-qtyy WHERE cid=3 OR cid=4;
		DBMS_OUTPUT.PUT_LINE('number of components 3 and 4 decreased by '|| qtyy);
		UPDATE Modules SET mQty=mQty+qtyy WHERE mid=2;
		--DBMS_OUTPUT.PUT_LINE(qtyy||’ module type 2 was made...total number: ’|| z);
		
		
	ELSIF (moduleId=3) THEN
		UPDATE Components SET qty=qty-qtyy WHERE cid=5 OR cid=6;
		DBMS_OUTPUT.PUT_LINE('number of components 5 and 6 decreased by '|| qtyy);
		UPDATE Modules SET mQty=mQty+qtyy WHERE mid=3;
		--DBMS_OUTPUT.PUT_LINE(qtyy||’ module type 3 was made...total number: ’|| z);
		
		
	ELSIF (moduleId=4) THEN
		UPDATE Components SET qty=qty-qtyy WHERE cid=7 OR cid=8;
		DBMS_OUTPUT.PUT_LINE('number of components 7 and 8 decreased by '|| qtyy);
		UPDATE Modules SET mQty=mQty+qtyy WHERE mid=4;
		--DBMS_OUTPUT.PUT_LINE(qtyy||’ module type 4 was made...total number: ’|| z);
		
		
	ELSIF (moduleId=5) THEN
		UPDATE Components SET qty=qty-qtyy WHERE cid=9 OR cid=10;
		DBMS_OUTPUT.PUT_LINE('number of components 9 and 10 decreased by '|| qtyy);
		UPDATE Modules SET mQty=mQty+qtyy WHERE mid=5;
		--DBMS_OUTPUT.PUT_LINE(qtyy||’ module type 5 was made...total number: ’|| z);
	
	END IF;
END;
 /
 
 
CREATE OR REPLACE PROCEDURE setSaleStatus (qty IN INT , typeInput IN VARCHAR)  IS

i INT;
a INT;
BEGIN
	
	FOR i IN 1..qty LOOP
		SELECT MIN(m.pid) INTO a FROM AppleiPad m WHERE m.type=typeInput AND m.sale_status='not_sold' AND m.test_result='success';
		UPDATE AppleiPad SET sale_status = 'sold' WHERE pid=a;
		DBMS_OUTPUT.PUT_LINE('AppleiPad number ' || a || ' of type ' || typeInput || ' was sold');
	END LOOP;
	COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE orderFromGroupA (name IN VARCHAR, qtyy IN INT, compId IN INT, suppId IN INT) IS

BEGIN
	IF (compId=1 OR compId=3 OR compId=5 OR compId=7 OR compId=9 AND suppID=1) THEN 
	       INSERT INTO EX_ORDERS@site_link2 VALUES(name,compId, qtyy,'Manufacture Team');
	ELSE 
	    INSERT INTO FN_ORDERS@site_link2 VALUES(name,compId, qtyy, 'Manufacture Team');
		
	END IF;	
END;
/ 

CREATE OR REPLACE PROCEDURE searchComponentsTable ( qtyy IN INT, typeInput IN VARCHAR, orderId IN INT, moduleId IN INT) IS
a INT;
b INT;
c INT;
d INT;
e INT;
f INT;
g INT;
h INT;
i INT;
j INT;
x INT;
y INT;
z INT;
xyz INT;

BEGIN
	
	SELECT c.qty INTO a FROM Components c WHERE c.cid=1;
	SELECT c.qty INTO b FROM Components c WHERE c.cid=2;
	SELECT c.qty INTO c FROM Components c WHERE c.cid=3;
	SELECT c.qty INTO d FROM Components c WHERE c.cid=4;
	SELECT c.qty INTO e FROM Components c WHERE c.cid=5;
	SELECT c.qty INTO f FROM Components c WHERE c.cid=6;
	SELECT c.qty INTO g FROM Components c WHERE c.cid=7;
	SELECT c.qty INTO h FROM Components c WHERE c.cid=8;
	SELECT c.qty INTO i FROM Components c WHERE c.cid=9;
	SELECT c.qty INTO j FROM Components c WHERE c.cid=10;
	
    SELECT MIN(o.qty) INTO xyz FROM Orders o WHERE o.to_be_filled>0;
	IF (moduleId=1) THEN
		IF (a>=qtyy AND b>=qtyy) THEN 
		     assembleComponents (qtyy, orderId, 1);
		ELSE     
		    x:=qtyy-a;
			IF (x>0) THEN orderFromGroupA ('SAKIB' ,xyz, 1, 1);
			END IF;
             x:=qtyy-b;
			IF (x>0) THEN orderFromGroupA ('ADNAN',xyz,2,2);
			END IF;
		END IF;
		
	ELSIF (moduleId=2) THEN
		IF(c>=qtyy AND d>=qtyy) THEN 
		     assembleComponents (qtyy, orderId, 2);
		ELSE 
		   x:=qtyy-c;
		   IF (x>0) THEN orderFromGroupA ('JEASUN',xyz,3,1);
		   END IF;
           x:=qtyy-d;
		   IF (x>0) THEN orderFromGroupA ('RAKIB',xyz,4,2);
		   END IF;
		   
		END IF;   
		   
	ELSIF (moduleId=3) THEN
		IF(e>=qtyy AND f>=qtyy) THEN
  		   assembleComponents (qtyy, orderId, 3);
		ELSE 
		    x:=qtyy-e;
		    IF (x>0) THEN orderFromGroupA ('FAISAL',xyz,5,1);
		    END IF;
			x:=qtyy-f;
		    IF (x>0) THEN orderFromGroupA ('SHISHIR',xyz,6,2);
		    END IF;
		END IF;	
			
	ELSIF (moduleId=4) then
		IF(g>=qtyy AND h>=qtyy) THEN 
		    assembleComponents (qtyy, orderId, 4);
		ELSE 
		   x:=qtyy-g;
		   IF (x>0) THEN orderFromGroupA ('ADOR',xyz,7,1);
		   END IF;
           x:=qtyy-h;
		   IF (x>0) THEN orderFromGroupA ('PIAS',xyz,8,2);
		   END IF;
		   
		END IF;  
		   
	ELSIF (moduleId=5) THEN
		IF(i>=qtyy AND j>=qtyy) THEN 
		    assembleComponents (qtyy, orderId, 5);
	    ELSE  
		    x:=qtyy-i;
		    IF (x>0) THEN orderFromGroupA ('REDWAN',xyz,9,1);
		    END IF;
            x:=qtyy-j;
		    IF (x>0) THEN orderFromGroupA ('ARMAN',xyz,10,2);
		    END IF;
		END IF;	
    END IF;


END;
/
 
 
 
 CREATE OR REPLACE PROCEDURE searchModulesTable ( qty IN INT , typeInput IN VARCHAR , orderId IN INT) IS

a INT;
b INT;
c INT;
d INT;
e INT;
x INT;
y INT;

BEGIN

     SELECT m.mQty INTO a FROM Modules m WHERE m.mid = 1;
     SELECT m.mQty INTO b FROM Modules m WHERE m.mid = 2;
     SELECT m.mQty INTO c FROM Modules m WHERE m.mid = 3;
     SELECT m.mQty INTO d FROM Modules m WHERE m.mid = 4;
     SELECT m.mQty INTO e FROM Modules m WHERE m.mid = 5;

     IF (typeInput='A') THEN
            IF(a>=qty AND c>=qty AND e>= qty) THEN
                  assembleModules(qty,A,orderId);
            ELSE 
                 y:= qty - a;
                 IF (y>0) THEN searchComponentsTable(y,A,orderId,1);
                 END IF;
                 y:= qty - c;
                 IF (y>0) THEN searchComponentsTable(y,A,orderId,3);
                 END IF;
                 y:= qty - e;
                 IF (y>0) THEN searchComponentsTable(y,A,orderId,5);
                 END IF;
             END IF;
 
      ELSIF (typeInput='B') THEN
            IF(a>=qty AND d>=qty AND e>= qty) THEN
                  assembleModules(qty,B,orderId);
            ELSE 
                 y:= qty - a;
                 IF (y>0) THEN searchComponentsTable(y,B,orderId,1);
                 END IF;
                 y:= qty - d;
                 IF (y>0) THEN searchComponentsTable(y,B,orderId,4);
                 END IF;
                 y:= qty - e;
                 IF (y>0) THEN searchComponentsTable(y,B,orderId,5);
                 END IF;
             END IF;        
       
            
      ELSIF (typeInput='C') THEN
            IF(b>=qty AND c>=qty AND e>= qty) THEN
                  assembleModules(qty,C,orderId);
            ELSE 
                 y:= qty - b;
                 IF (y>0) THEN searchComponentsTable(y,C,orderId,2);
                 END IF;
                 y:= qty - c;
                 IF (y>0) THEN searchComponentsTable(y,C,orderId,3);
                 END IF;
                 y:= qty - e;
                 IF (y>0) THEN searchComponentsTable(y,C,orderId,5);
                 END IF;
             END IF;


    ELSIF (typeInput='D') THEN
            IF(b>=qty AND d>=qty AND e>= qty) THEN
                  assembleModules(qty,D,orderId);
            ELSE 
                 y:= qty - b;
                 IF (y>0) THEN searchComponentsTable(y,D,orderId,2);
                 END IF;
                 y:= qty - d;
                 IF (y>0) THEN searchComponentsTable(y,D,orderId,4);
                 END IF;
                 y:= qty - e;
                 IF (y>0) THEN searchComponentsTable(y,D,orderId,5);
                 END IF;
             END IF; 

    END IF;
    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE searchAppleiPadTable(qtyWeNeed IN INT, typeInput IN VARCHAR, orderId IN INT) IS

a INT;
b INT;
c INT;

BEGIN 
   
    SELECT COUNT(m.pid) INTO a FROM AppleiPad m WHERE m.type = typeInput AND m.test_result='success' AND m.sale_status='not_sold';
    IF (a>=qtyWeNeed) THEN
             addToInventory(qtyWeNeed, typeInput,orderId);
			 DBMS_OUTPUT.PUT_LINE('Add to Inventory Procedure Call');
    SELECT o.qty INTO c FROM Orders o WHERE o.order_no = orderId;
    --deliver(c,typeInput,orderId);
    ELSIF (a<qtyWeNeed) THEN
           b:= qtyWeNeed - a;
           searchModulesTable(b,typeInput,orderId);
		   DBMS_OUTPUT.PUT_LINE('Search Modules Table  Procedure Call');
    END IF;
    COMMIT;

END;   
/
 

CREATE OR REPLACE PROCEDURE procInventory(qty IN INT,typeInput IN Inventory.type%TYPE, orderId IN INT) IS
 
a INT;
b INT;

BEGIN  
    
    DBMS_OUTPUT.PUT_LINE('Start of ProcInventory Function');
    SELECT i.inventQty INTO a FROM Inventory i Where i.type = typeInput;
    IF (qty<=a) THEN 
           deliver(qty, typeInput , orderId);
		   DBMS_OUTPUT.PUT_LINE('Deliver Procedure Call'); 
    ELSIF (qty>a) THEN 
               b:=qty-a;
               searchAppleiPadTable(b,typeInput,orderId);
			   DBMS_OUTPUT.PUT_LINE('Search Apple Ipad Table Procedure Call');
    END IF;
    COMMIT;
END; 
/

CREATE OR REPLACE PROCEDURE checkModules ( qtyy IN INT, appleipadType IN VARCHAR ) IS

a INT;
b INT;
c INT;
d INT;
e INT;
x INT;
y INT;
xx INT;
yy INT;
z VARCHAR(50);

BEGIN	
	SELECT m.mQty INTO a FROM Modules m WHERE m.mid=1;
	SELECT m.mQty INTO b FROM Modules m WHERE m.mid=2;
	SELECT m.mQty INTO c FROM Modules m WHERE m.mid=3;
	SELECT m.mQty INTO d FROM Modules m WHERE m.mid=4;
	SELECT m.mQty INTO e FROM Modules m WHERE m.mid=5;
	SELECT MIN(o.order_no) INTO y FROM Orders o WHERE o.to_be_filled>0;
	SELECT o.qty INTO x FROM Orders o WHERE o.order_no=y;
	SELECT o.type INTO z FROM Orders o WHERE o.order_no=y;
	SELECT i.inventQty INTo xx FROM Inventory i WHERE i.type=z;
	z:=x-z;
	IF (appleipadType='A') THEN
		IF (a>=z AND c>=z AND e>=z) THEN 
		   assembleModules (z, A, y);
		END IF;
	ELSIF (appleipadType='B') THEN
		IF (a>=z AND d>=z AND e>=z) THEN 
		   assembleModules (z, B, y);
		END IF;
	ELSIF (appleipadType='C') THEN
		IF (b>=z AND c>=z AND e>=z) THEN 
		   assembleModules (z, C, y);
		END IF;
	ELSIF (appleipadType='D') THEN
		IF (b>=z AND d>=z AND e>=z) THEN 
		   assembleModules (z, D, y);
		END IF;
	END IF;
END;
/



CREATE OR REPLACE PROCEDURE checkComponents (compId IN INT)  IS
x INT;
y INT;
z VARCHAR(50);
a INT;
b INT;
c INT;
d INT;
e INT;
f INT;
g INT;
h INT;
i INT;
j INT;


BEGIN
	SELECT MIN(o.order_no) INTO y FROM Orders o WHERE o.to_be_filled>0;
	SELECT o.qty INTO x FROM Orders o WHERE o.order_no=y;
	SELECT o.type INTO z FROM Orders o WHERE o.order_no=y;
	SELECT c.qty INTO a FROM Components c WHERE c.cid=1;
	SELECT c.qty INTO b FROM Components c WHERE c.cid=2;
	SELECT c.qty INTO c FROM Components c WHERE c.cid=3;
	SELECT c.qty INTO d FROM Components c WHERE c.cid=4;
	SELECT c.qty INTO e FROM Components c WHERE c.cid=5;
	SELECT c.qty INTO f FROM Components c WHERE c.cid=6;
	SELECT c.qty INTO g FROM Components c WHERE c.cid=7;
	SELECT c.qty INTO h FROM Components c WHERE c.cid=8;
	SELECT c.qty INTO i FROM Components c WHERE c.cid=9;
	SELECT c.qty INTO j FROM Components c WHERE c.cid=10;
	
	IF (compId=1 OR compId=2) THEN
		IF (a>=x AND b>=x) THEN 
		    assembleComponents (x, y, 1);
		    checkModules (x, z);
		END IF;
	ELSIF (compid=3 OR compId=4) THEN
		IF (c>=x AND d>=x) THEN 
		    assembleComponents (x, y, 2);
		    checkModules (x, z);
		END IF; 
	ELSIF (compid=5 or compId=6) THEN
		IF (e>=x AND f>=x) THEN 
		    assembleComponents (x, y, 3);
		    checkModules (x, z);
		END IF;
	ELSIF (compid=7 OR compId=8) THEN
		IF (g>=x AND h>=x) THEN 
		    assembleComponents (x, y, 4);
		    checkModules (x, z);
		END IF;
	ELSIF (compid=9 OR compId=10) THEN
		IF (i>=x AND j>=x) THEN 
		    assembleComponents (x, y, 5);
		    checkModules (x, z);
		END IF;
	END IF;
END;
/




CREATE OR REPLACE TRIGGER deliveredComponents AFTER UPDATE ON Components FOR EACH ROW
DECLARE 
x INT;
y INT;


BEGIN
	SELECT c.qty INTO x FROM Components c WHERE c.cid=:new.cid;
	IF (:new.qty<x) THEN 
	   DBMS_OUTPUT.PUT_LINE('no need to do anything!');	   
	ELSIF (:new.qty>x) THEN 
	    y:=:new.qty-x;
	END IF;	
DBMS_OUTPUT.PUT_LINE(y||' type '|| :new.cid || ' components delivered to us');
checkComponents (:new.cid);
END;
/

CREATE OR REPLACE TRIGGER Orderss AFTER INSERT ON Orders
FOR EACH ROW

BEGIN

     DBMS_OUTPUT.put_line('Group C has ordered: ' || :New.qty || ' type' || :New.type || ' Appleipads');
	 procInventory (:new.qty, :new.type, :new.order_no);

END;
/

CREATE OR REPLACE PROCEDURE insert_supplier IS 

  x INT;
  y INT;
  z VARCHAR(50);
  a INT;
  b INT;
  k VARCHAR(50);
  CURSOR c IS SELECT cid,buyer,supplier_name,sup_id,qty FROM Supplier ;
 
 
BEGIN
    DELETE FROM EX_ORDERS@site_link2;
	DELETE FROM FN_ORDERS@site_link2;
    OPEN c;
	 LOOP 
	    FETCH c INTO x,z,k,y,a;
		IF(y=1) THEN
		   INSERT INTO EX_ORDERS@site_link2(name,part_id,quantity,buyer) VALUES (k,x,a,z);
		ELSE  
            INSERT INTO FN_ORDERS@site_link2(name,part_id,quantity,buyer) VALUES (k,x,a,z);		   
        END IF;   		 
		EXIT WHEN c%NOTFOUND;
	END LOOP;
	CLOSE c;
    
END;
/

EXECUTE insert_supplier;





CREATE OR REPLACE  VIEW CEO_VIEW1 as 
SELECT part_id,  SUM (quantity) as tot_quantity FROM EX_ORDERS@site_link2
GROUP BY  part_id;

CREATE OR REPLACE VIEW CEO_VIEW2 AS
SELECT part_id, SUM (quantity) as tot_quantity  FROM FN_ORDERS@site_link2 
GROUP BY part_id;

CREATE OR REPLACE VIEW  CEO_VIEW3 AS 
SELECT type,  SUM (qty) as tot_quantity FROM Orders  WHERE to_be_filled>0
GROUP BY type;


--ALTER USER scott IDENTIFIED BY anything
--CONNECT scott
--GRANT CREATE ANY VIEW TO SCOTT





commit;      