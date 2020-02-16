drop database link site_link2;

create database link site_link2
 connect to system identified by "123"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.2.108)
		 (PORT = 1522))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
;  