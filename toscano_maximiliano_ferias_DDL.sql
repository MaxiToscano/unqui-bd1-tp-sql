
----------------------------------------EJERCICIO 1: DDL----------------------------------------

--Este archivo contiene la inserción de datos que es DML, lo dejo acá ya que formaba parte del ejercicio 1: DDL.

--PUNTO A) CREACIÓN DE LA BASE DE DATOS  

--Yo utilicé para el trabajo un editor de texto y la interfaz de DBeaver;
--Asi que ingresé a la base de datos de postgres en DBaver;
--Creé la base de datos con el comando "CREATE DATABASE nombre_bd;"
--Refresqué postgres en el menu de base de datos para que aparezca la nueva base de datos creada,
--y la establecí como objeto activo para trabajar en ella con el editor SQL.

CREATE DATABASE tp_toscano;

--Para crear la base de datos en postgres desde la terminal SHELL los pasos serían:
--Presionar Enter hasta que te pida la contraseña del usuario;
--Ingresar contraseña del usuario si lo requiere;
--Ya dentro de la bd de postgres ingreso el comando "CREATE DATABASE nombre_bd;" para crear la base de datos.
--Una vez creada la nueva base de datos, ingreso a ella con "\c nombre_bd;" para la creación de tablas y insercion de datos en la misma  

 
--PUNTOS B, C Y D) CREACIÓN DE LAS TABLAS CON CLAVES FORANEAS IDENTIFICADAS

--Una vez identifacadas las claves foraneas ordené la creación de las tablas para que no haya errores al ejecutar.


CREATE TABLE feria (
id int PRIMARY KEY,
nombre varchar(255) NOT NULL,
cuit varchar(13) NOT NULL,
cantidad_puestos int DEFAULT NULL,
localidad varchar(255) DEFAULT NULL, 
domicilio varchar(255) DEFAULT NULL,
zona varchar(255) DEFAULT NULL
);


CREATE TABLE producto_tipo (
id int PRIMARY KEY,
nombre varchar(255) NOT NULL,
descripcion varchar(255) DEFAULT NULL
); 


CREATE TABLE producto (
id int PRIMARY KEY,
tipo_id int NOT NULL,
especie varchar(255) NOT NULL,
variedad varchar(255) DEFAULT NULL,
activo bool NOT NULL, 
FOREIGN KEY (tipo_id) REFERENCES producto_tipo (id)
);


CREATE TABLE "user" ( 
id int PRIMARY KEY,
email varchar(180) NOT NULL,
password varchar(25) NOT NULL, 
nombre varchar(255) DEFAULT NULL,
apellido varchar(255) DEFAULT NULL  
);

/* En la estructura especificada la tabla de los usuarios se nombra user y al ser una palabra reservada del lenguaje, no permite la creación de la tabla con ese nombre.
La solucíon que encontre es poner el nombre entre comillas dobles "user" para que me permita la creación.*/



CREATE TABLE user_feria (
user_id int NOT NULL,
feria_id int NOT NULL,
PRIMARY KEY (user_id, feria_id),
FOREIGN KEY (user_id) REFERENCES "user" (id),
FOREIGN KEY (feria_id) REFERENCES feria (id)
); 


CREATE TABLE declaracion (
id int PRIMARY KEY,
fecha_generacion date NOT NULL, --Cambio de tipo de dato 'datetime' por 'date' ya se que se requiere solo la fecha y no fecha y hora. Aparte, 'datetime' no es valido en postgres, si se requiere fecha y hora el tipo de dato tiene que ser 'timestamp'.*/
feria_id int NOT NULL,          
user_autor_id int DEFAULT NULL,
FOREIGN KEY (feria_id) REFERENCES feria (id),
FOREIGN KEY (user_autor_id) REFERENCES "user" (id) 
);


CREATE TABLE declaracion_individual (
id int PRIMARY KEY,
producto_declarado_id int NOT NULL,
declaracion_id int NOT NULL,
fecha date NOT NULL,
precio_por_bulto decimal(12,2),
comercializado bool NOT NULL DEFAULT '1', -- '1' = true
peso_por_bulto decimal(5,2) DEFAULT NULL,
FOREIGN KEY (producto_declarado_id) REFERENCES producto (id),
FOREIGN KEY (declaracion_id) REFERENCES declaracion (id),
CHECK (precio_por_bulto > 0 AND peso_por_bulto > 0) --Restricción para evitar el ingreso de datos negativos para precio y peso.
);


--PUNTO E) INSERCIÓN DE DATOS DEL ARCHIVO: datos_ferias.sql

--LA INSERCIÓN DE DATOS EN LAS TABLAS ES DML.

--Metodo utilizado: Fuí insertando los registros por partes en el mismo orden en el que creé las tablas. 
--Pero antes hice las siguintes modificaciones/correcciones al archivo para la inserción de datos:

--Sacar las comillas en los nombres de las tablas en el INSERT INTO;
--Agregar los atributos a los cuales voy a insertar valores en el INSERT INTO, aunque no hacia falta ya que se insertan en la totalidad de los campos;
--Ordenar los valores insertados, un renglon por cada tupla (con excepción en las tablas usuario_feria y declarion_invidaual);
--Poner entre comillas los valores '1' (= true) y '0' (= false) a los valores de tipo bool para que los inserte correctamente, ya que sin las comillas los tiraba error por ser de tipo int.
--Modificar valores de la tabla producto donde se repetia en especie y variedad 'papa' 'negra' para poder implementar el punto 13 del ejercicio 2.

--*Al final de todo está el Punto F

-------------------------incersión de datos de las ferias-------------------------

INSERT INTO feria (id, nombre, cuit, cantidad_puestos, localidad, domicilio, zona)
VALUES (3,'Market ABASTO','66-70507557-9',175,'AVELLANEDA, SARANDÍ','Autopista La Plata Km 9,5','AMBA SUR'),
(4,'FERIA MAYORISTA AGROECOLÓGICO','111222666555',NULL,'AVELLANEDA','Lamadrid 768','AMBA SUR'),
(5,'COOPERATIVA DE TRABAJO Frutilin LIMITADA','60-71161490-6',70,'LANÚS','Camino Gral. Belgrano 4431','AMBA SUR'),
(6,'FERIA MAYORISTA ','111222666444',NULL,'LANÚS, VALENTIN ALSINA','Patxot 945','AMBA SUR'),
(7,'RESIDENTES DE Trelew ASOCIACIÓN CIVIL','60-70777669-9',NULL,'MORÓN','PUEYRREDON 1015','AMBA NORTE'),
(8,'FERIA Ezpeleta S.R.L','60-68705684-8',NULL,'ALMIRANTE BROWN','BUENOS AIRES 1466','AMBA SUR'),
(9,'FERIA Asuncion','20-92960615-7',NULL,'ALMIRANTE BROWN, BURZACO','AV. MONTEVERDE N° 2975','AMBA SUR'),
(10,'FERIA MODELO DEL SURESTE ','60-65867621-6',NULL,'ALMIRANTE BROWN','Avda. República Argentina 2220','AMBA SUR'),
(11,'FERIA Potosi','111111111',NULL,'ALMIRANTE BROWN','HIPOLITO YRIGOYEN 15333','AMBA SUR'),
(12,'FERIA FRUTIHORTÍCOLA PRODUCTORES DEL SUD \"EL Perrito\"','60-62652176-8',NULL,'BERAZATEGUI','Av. Dardo Rocha 149','AMBA SUR'),
(13,'FERIA ESCOBAR','60-66157456-5',NULL,'ESCOBAR','Las Rosas 3051','AMBA NORTE'),
(14,'Paniagua','20-92250667-6',NULL,'ESCOBAR','LAS ROSAS E INMIGRANTES','AMBA NORTE'),
(15,'FERIA CENTRAL Esteban','27-92962624-5',NULL,'EZEIZA','Moscoso de Herrera 954','AMBA SUR'),
(16,'FERIA FRUTIHORTÍCOLA 26 DE JUNIO','711111117',NULL,'FLORENCIO VARELA','Av. Florencio Varela 2997','AMBA SUR'),
(17,'Cabellosa','60-68941659-0',NULL,'FLORENCIO VARELA','AV SENZABELLO N° 2215','AMBA SUR'),
(18,'PEREZ','111222666555',NULL,'GENERAL BELGRANO',NULL,NULL),
(19,'FERIA DE MAR DEL PLATA','111222666555',NULL,'GENERAL PUEYRREDON, Mar del Plata','Ruta 88 km. 3,3','RESTO PBA'),
(20,'Cooperativa fruticolas amazonas','60-61658268-9',NULL,'GENERAL PUEYRREDON, Mar del Plata','Ruta 226 Km. 7½','RESTO PBA'),
(21,'COOPERATIVA DE MAR AZUL','66-56527758-9',NULL,'GENERAL PUEYRREDON, Mar del Plata','Chile 1485','RESTO PBA'),
(22,'FERIA CENTRAL Belgrano','60-55246689-6',NULL,'GENERAL SAN MARTÍN','PERDRIEL N° 3553','AMBA NORTE'),
(23,'LOMAS SUR','60-66671041-5',NULL,'LA MATANZA, LOMAS DEL MIRADOR','Roque Saenz Peña 3351','AMBA NORTE'),
(24,'FERIALA PLATA','60-69205749-6',NULL,'LA PLATA','AV. 520 E 115 Y 116','AMBA SUR'),
(25,'COOPERATIVA FRUTIHORTÍCOLA IPANEMA','60-70816656-2',NULL,'LUJAN','Colectora Acc. Oeste 2488 –Alfonsina Storni 3535','AMBA NORTE'),
(26,'FERIA MALVINAS ARGENTINAS','20-66561864-9',NULL,'MALVINAS ARGENTINAS',NULL,'AMBA NORTE'),
(27,'FERIA DE MERLO','60-70861110-6',NULL,'MERLO','Tarija 36 y Catamarca','AMBA NORTE'),
(28,'FERIA SALCHIPAPAS','111222666444',NULL,'MORENO','Avda. del Trabajo 50','AMBA NORTE'),
(29,'COOPERATIVA 23 DE ENERO LTDA','60-70842156-6',NULL,'PILAR','RUTA PROV. N° 25 KM 1,5','AMBA NORTE'),
(30,'EMPRESA LUCIFER','60-71641461-9',NULL,'PILAR',NULL,'AMBA NORTE'),
(31,'FERIA DE ABASTO DE WILDE','60-64674657-1',NULL,'WILDE','Islas Malvinas 1860','AMBA SUR'),
(32,'FERIA 16 DE FEBRERO','60-68966768-7',NULL,'QUILMES, EZPELETA','Av. Florencio Varela 2995','AMBA SUR'),
(33,'Usuarios y productos','60-68720759-5',NULL,'QUILMES','CAMINO GRAL BELGRANO KM 14.','AMBA SUR'),
(34,'FERIA Mastwitewij','60-5699601-5',NULL,'SAN ISIDRO','Avenida Andres Rolón 2560','AMBA NORTE'),
(35,'CONSORCIO CATRIEL','111222666555',NULL,'SAN MARTIN',NULL,'AMBA NORTE'),
(36,'FERIA DE SEIS DE FEBRERO','60-587118-1',NULL,'TRES DE FEBRERO, Caseros','CARLOS TEJEDOR 06/ Avda. Alvear 4100','AMBA NORTE'),
(37,'FERIA DE ZÁRATE','60-71595964-4',NULL,'ZÁRATE','Av. Antártida Argentina 3105','AMBA NORTE'),
(38,'FERIA DE ABASTO DE BAHÍA BLANCA','66-56764228-9',NULL,'BAHIA BLANCA','Thompson y 1810 N° 450','RESTO PBA'),
(39,'FERIA SECCOTTE','60-69586516-9',NULL,'BAHÍA BLANCA','Ruta 33 Km 5','RESTO PBA');


-------------------------incersión de datos de los tipos de productos-------------------------

INSERT INTO producto_tipo (id, nombre, descripcion) 
VALUES (1,'Hortaliza','Otro tipo de vegetal'),
(2,'Fruta','Dulce ideal para el postre'),
(3,'Carne','Blanca, roja etc');


-------------------------incersión de datos de los productos-------------------------

INSERT INTO producto (id, tipo_id, especie, variedad, activo)
VALUES (1,2,'Pera','Willis','1'),
(2,2,'Papa','Negra','1'),
(3,2,'Papa','Blanca','1'),
(4,1,'Bananas','Ecuatoriana','0'),
(5,1,'qwe','wqe','0'),
(6,1,'Pomelo','Amarillo','1'),
(7,2,'Papa','Negra lavada','0'),
(8,3,'Pollo','Carne blanca','1'),
(9,3,'Vaca','Asados','1'),
(20,1,'ACELGA',NULL,'1'),
(21,1,'BATATA',NULL,'1'),
(22,1,'BERENJENA',NULL,'1'),
(23,1,'LECHUGA','CRIOLLA','1'),
(24,1,'LECHUGA','MANTECOSA','0'),
(25,1,'PAPA','SPUNTA','1'),
(26,1,'PAPA','BLANCA LAVADA','0'),
(27,1,'PAPA','CRIOLLA','1'),
(28,1,'PIMIENTO','ROJO','1'),
(29,1,'PIMIENTO','VERDE','0'),
(30,1,'REPOLLO','COLORADO','1'),
(31,1,'TOMATE','REDONDO','1'),
(32,1,'TOMATE','PERITA','0'),
(33,1,'ZAPALLITO','REDONDO MEDIANO','1'),
(34,1,'ZAPALLO','ANCO/ANQUITO','1'),
(35,1,'ZANAHORIA',NULL,'1'),
(36,1,'ZANAHORIA','CHANTENAY','0'),
(37,2,'BANANA',NULL,'1'),
(38,2,'BANANA','ECUADOR','0'),
(39,2,'BANANA','COMERCIAL','0'),
(40,2,'LIMON',NULL,'1'),
(41,2,'MANDARINA',NULL,'1'),
(42,2,'MANZANA',NULL,'1'),
(43,2,'MANZANA','GRANNY SMITH','0'),
(44,2,'MANZANA','ROYAL GALA','0'),
(45,2,'NARANJA',NULL,'1'),
(46,2,'NARANJA','OMBLIGO','0'),
(47,2,'NARANJA','JUGO','0'),
(49,3,'HUEVOS','HUEVOS','0'),
(50,1,'CEBOLLA',NULL,'1');




-------------------------incersión de datos de los usuarios-------------------------

INSERT INTO "user" (id, email, password, nombre, apellido) 
VALUES (1,'Nam.porttitor@pharetraNamac.net','PKE19FGB3JD','Caldwell','Knapp'),
(2,'non@tellusjusto.ca','YHF33YPS9QY','Colt','Bonner'),
(3,'adipiscing.enim@loremutaliquam.edu','JKI82QVU6ZQ','Xantha','Mayer'),
(4,'metus.Aliquam.erat@arcu.ca','SJW59UAC5ZL','Ezekiel','Decker'),
(5,'eu.sem.Pellentesque@velarcu.net','INW81BZG1WV','Ishmael','Chambers'),
(6,'Proin.non.massa@urnaet.ca','IOM96RMN7AB','Yardley','Curtis'),
(7,'risus@mauris.ca','DWB27EYK8PO','Jasper','Chapman'),
(8,'Sed.id@sed.ca','USL62IDC5IX','Rahim','Hoover'),
(9,'non.arcu@lobortismauris.edu','UTQ08QSX1MT','Amaya','Martin'),
(10,'quam.elementum.at@enim.com','TOQ73MHN1WX','Alden','Ingram'),
(11,'dictum.cursus.Nunc@hendrerit.org','RXR94URW1FZ','Alexa','Lowery'),
(12,'metus@quisurna.org','WNX67AFP6DA','Quynn','Armstrong'),
(13,'lacinia@aliquetodio.net','WAE16JDO8HD','Kerry','Edwards'),
(14,'Nunc.commodo.auctor@felisDonec.ca','QSD36EHM7RB','Shannon','Prescott'),
(15,'enim.non.nisi@eumetus.ca','EYF91NUQ9ZN','William','Meyers'),
(16,'lobortis.mauris.Suspendisse@malesuada.net','NLN31IUY1GM','Clare','Wells'),
(17,'tincidunt@amifringilla.edu','DCL32CSO4RY','Demetria','Ellis'),
(18,'erat.Etiam@Maecenasliberoest.com','JHW05HIW7CS','Rogan','Soto'),
(19,'eu@Sedidrisus.edu','MRN47DCX7YX','Quinlan','Berger'),
(20,'vulputate@gravidamauris.edu','NPO56IOE8ZY','Amethyst','Golden'),
(21,'dictum@ipsum.net','PIE64XLL3RX','Nichole','Allison'),
(22,'luctus@hendrerita.co.uk','MWA66KRR4HG','Alexandra','Mullen'),
(23,'tincidunt.aliquam@ullamcorpereu.edu','RTY40CLH9EL','Jerry','Mitchell'),
(24,'aliquet.Proin@a.co.uk','PRD24VMW1AK','Melissa','Mayer'),
(25,'In.scelerisque@ullamcorpereueuismod.ca','GAJ99THK0UM','Ashton','Stark'),
(26,'Donec.nibh@auctorvelit.com','OOQ40AMT1FS','Lucas','Knox'),
(27,'lobortis.quam@interdum.net','QRI18CWA2ZC','Alisa','Odom'),
(28,'dapibus@CraspellentesqueSed.net','QRK96FON1PW','Gavin','Pace'),
(29,'convallis.convallis.dolor@enim.net','PSG51SKF1DK','Raven','Pena'),
(30,'nulla.vulputate.dui@augueutlacus.org','RAY12NLB3OF','Timon','Henson'),
(31,'Integer.id@elit.edu','GRI05JCA5JS','Dacey','Bowen'),
(32,'nonummy@Cras.edu','FGT99PBM5QN','Ivana','Sosa'),
(33,'erat@massarutrummagna.ca','KJW54VDK0TU','Bevis','Sandoval'),
(34,'commodo.tincidunt.nibh@nuncIn.org','WLQ83OUH7LW','George','Hodge'),
(35,'dictum@consectetuerrhoncusNullam.net','WYP01ETV1ZP','Kimberley','Tillman'),
(36,'cursus.Nunc.mauris@Nullam.net','IAH56DMQ3ZC','Jack','Payne'),
(37,'volutpat@malesuada.co.uk','IDK03IYH0RH','Henry','Fitzgerald'),
(38,'lectus@facilisiSed.com','UWF68EES9VC','Kennan','England'),
(39,'sem.elit.pharetra@penatibuset.co.uk','UKL75KKL7KV','Amethyst','Mcintyre'),
(40,'consequat@sem.edu','BIH23PAN9VX','Sophia','Combs'),
(41,'est@Utnec.net','XVE31ZFH4SK','Hayfa','Gardner'),
(42,'arcu@scelerisqueduiSuspendisse.org','DZI36CKZ4HR','Donna','Boyle'),
(43,'sem.egestas.blandit@sem.co.uk','TYT21EWS5PZ','Leo','Short'),
(44,'in.faucibus.orci@eu.com','UMF61TNR4XX','Joel','Wiley'),
(45,'ante@Sed.com','RNN48YGP9UP','Quail','Lara'),
(46,'tellus@sitamet.org','OCK92HMA3KP','Kim','Wilson'),
(47,'sociis.natoque.penatibus@sedestNunc.org','OGW65WWP1VE','Kennedy','Cortez'),
(48,'sapien.cursus.in@ultriciesadipiscingenim.org','ERM65BUH9FT','Deacon','Hinton'),
(49,'molestie@dictumcursusNunc.net','ONT21GEM4QQ','Lunea','Mcclure'),
(50,'neque.non.quam@accumsan.net','PNB15DYM8SQ','Nevada','Rios'),
(51,'sollicitudin@auctornuncnulla.com','DMB71WIH6OH','Mufutau','Gonzales'),
(52,'augue@PraesentluctusCurabitur.co.uk','NPG76IQC6MK','Yvette','George'),
(53,'tempor.diam@dignissimmagnaa.org','YNZ92LDS3DW','Fleur','Baxter'),
(54,'vitae.sodales@sapien.co.uk','PQN21UGR4JL','Acton','Parker'),
(55,'lorem.fringilla.ornare@ac.net','MEY22TST1HH','Cassady','Clark'),
(56,'ridiculus.mus.Donec@Quisqueac.net','QKI71TFN2PL','India','Becker'),
(57,'at@porttitorvulputate.co.uk','AFU85UQK8PZ','Trevor','Mercer'),
(58,'orci.Ut@enimcommodohendrerit.edu','RYD14ISD4FI','Rosalyn','Norton'),
(59,'est.ac.facilisis@Duismienim.edu','ZJI52AJA1UD','Wallace','Marsh'),
(60,'est.Nunc.laoreet@ut.org','ZEW29KSB4WD','Geoffrey','Lopez'),
(61,'amet@semper.edu','PKP58RCB3PY','Louis','Talley'),
(62,'dictum@ipsumdolor.ca','HZS50QLU6PZ','Chester','Meadows'),
(63,'faucibus.lectus.a@Sedneque.co.uk','XVZ07DFA1UL','Leila','Holcomb'),
(64,'nec@quis.ca','UND60FDQ9JV','Zenaida','Ray'),
(65,'elementum.dui.quis@anteVivamusnon.edu','UMV00VNX3VK','Katelyn','Fulton'),
(66,'libero.nec.ligula@aarcu.net','ORB47ZDU9VG','Lacey','Cline'),
(67,'Sed.eu@odiosempercursus.co.uk','FJA43GGZ2MH','Stewart','Stafford'),
(68,'augue.ut@luctuset.org','SMG34AKO9CL','Tanner','Guerrero'),
(69,'congue@dis.org','SLP88YEM7NP','Jason','Miles'),
(70,'et@Etiamvestibulum.edu','LDF15RGO8KB','Brock','Webster'),
(71,'Nulla.tempor.augue@Mauriseuturpis.net','XGL01HHG5IO','Cailin','Bernard'),
(72,'Nullam.nisl@pretium.org','BXB61BHC4PI','Henry','Johns'),
(73,'laoreet.ipsum.Curabitur@orci.co.uk','APQ24MPN7TO','Germaine','Gregory'),
(74,'a.purus@malesuada.edu','VAP22XKJ4SR','Lana','Solomon'),
(75,'Nunc@cursus.org','WGK77SQE5SP','Lucas','Shaffer'),
(76,'Nullam@lacusNulla.ca','JVD09YRJ0MA','Scarlet','Calhoun'),
(77,'eleifend@diam.co.uk','TMH36LCL8LT','Devin','Stone'),
(78,'Cum.sociis.natoque@quislectus.ca','JVY59BED0MT','Adrian','Maddox'),
(79,'eu.neque.pellentesque@mi.net','ADM98PJR1CB','Noel','Lee'),
(80,'non@luctusetultrices.net','WQD73RGL6TI','Xanthus','Hurley'),
(81,'magna.Suspendisse.tristique@nonsollicitudina.edu','CYG56DSU0RC','Hanna','Chen'),
(82,'semper.auctor@sit.ca','NOZ44SEN9EE','Cassady','Duffy'),
(83,'Quisque.ac.libero@purus.ca','FIT30USH4VD','Genevieve','Hurst'),
(84,'mauris.aliquam.eu@loremegetmollis.ca','VWG81JXM2IA','Felicia','Horne'),
(85,'libero@Donec.com','WXW76GBE5MT','August','Craig'),
(86,'Donec.luctus.aliquet@mauris.org','JCN32OWJ9PI','Lysandra','Terrell'),
(87,'mattis.semper.dui@massa.org','GMX56LPQ1DD','Dale','Griffin'),
(88,'elit.fermentum@eunibh.org','RRH33DOU2VU','Yasir','Briggs'),
(89,'Integer.in.magna@odio.co.uk','TRD86BST4YT','Aphrodite','Britt'),
(90,'lectus.quis.massa@Pellentesquehabitant.net','CPR17PGZ7TG','Emi','Vega'),
(91,'Aliquam@Donectemporest.com','OTH84UMS6HV','Evelyn','Grimes'),
(92,'tempus@temporaugueac.org','VDL67IEE1PI','Idola','Jacobson'),
(93,'lacus.Aliquam@liberoet.net','UTJ27OKC2MI','Baker','Williams'),
(94,'egestas.a.dui@massaVestibulum.com','ZMD84LKH9XJ','Calvin','Morton'),
(95,'eget@erat.com','LBY72AZR4HI','Yardley','George'),
(96,'sapien.Cras.dolor@sodalesat.ca','PCF88SGB6ZK','Quyn','Molina'),
(97,'Sed@estmauris.co.uk','KFJ09MLR5SX','Natalie','Farmer'),
(98,'semper.egestas.urna@laoreetipsum.com','BKR19FSP9UM','Hall','Bishop'),
(99,'lobortis.quis@parturientmontes.net','MPA92AOH8HU','Maxwell','Clemons'),
(100,'Quisque.imperdiet.erat@felisullamcorper.com','ZUV27TBQ7EX','Xanthus','Brock');


--------------------incersión de datos de la relación entre usuarios y ferias--------------------


INSERT INTO user_feria (user_id, feria_id) 
VALUES (23,22),(23,24),(23,25),(23,26),(23,27),
(23,28),(23,29),(23,30),(23,31),(23,32),
(23,33),(23,34),(23,35),(23,36),(23,37),
(23,38),(23,39),(24,23),(24,25),(24,26),
(24,27),(24,28),(24,29),(24,30),(24,31),
(24,32),(24,33),(24,34),(24,35),(24,36),
(24,37),(24,38),(24,39),(25,24),(25,26),
(25,27),(25,28),(25,29),(25,30),(25,31),
(25,32),(25,33),(25,34),(25,35),(25,36),
(25,37),(25,38),(25,39),(26,25),(26,27),
(26,28),(26,29),(26,30),(26,31),(26,32),
(26,33),(26,34),(26,35),(26,36),(26,37),
(26,38),(26,39),(27,26),(27,28),(27,29),
(27,30),(27,31),(27,32),(27,33),(27,34),
(27,35),(27,36),(27,37),(27,38),(27,39),
(28,27),(28,29),(28,30),(28,31),(28,32),
(28,33),(28,34),(28,35),(28,36),(28,37),
(28,38),(28,39),(29,28),(29,30),(29,31),
(29,32),(29,33),(29,34),(29,35),(29,36),
(29,37),(29,38),(29,39),(30,29),(30,31),
(30,32),(30,33),(30,34),(30,35),(30,36),
(30,37),(30,38),(30,39),(31,30),(31,32),
(31,33),(31,34),(31,35),(31,36),(31,37),
(31,38),(31,39),(32,31),(32,33),(32,34),
(32,35),(32,36),(32,37),(32,38),(32,39),
(33,32),(33,34),(33,35),(33,36),(33,37),
(33,38),(33,39),(34,33),(34,35),(34,36),
(34,37),(34,38),(34,39),(35,34),(35,36),
(35,37),(35,38),(35,39),(36,35),(36,37),
(36,38),(36,39),(37,36),(37,38),(37,39),
(38,37),(38,39),(39,38),(40,39),(41,39),
(42,39),(43,39),(44,39),(45,39),(46,39),
(47,39),(48,39),(49,39),(50,39),(51,39),
(52,39),(53,39),(54,39),(55,39),(56,39),
(57,39),(58,39),(59,39),(60,39),(61,39),
(62,39),(63,39),(64,39),(65,39),(66,39),
(67,39),(68,39),(69,39),(70,39),(71,39),
(72,39),(73,39),(74,39),(75,39),(76,39),
(77,21),(77,39),(78,21),(79,21),(80,21),
(81,21),(82,21),(83,21),(84,21),(85,21),
(86,21),(87,21),(88,21),(89,21),(90,21),
(91,21),(92,21),(93,21),(94,21),(95,21),
(96,21),(97,21),(98,21),(99,21);


-------------------------incersión de datos de las declaraciones-------------------------

INSERT INTO declaracion (id, fecha_generacion, feria_id, user_autor_id) 
VALUES (9,'2020-05-22',38,42),
(10,'2020-05-22',7,37),
(11,'2020-05-27',36,56),
(12,'2020-05-27',15,56),
(13,'2020-05-29',38,42),
(14,'2020-05-29',3,56),
(15,'2020-05-29',12,56),
(16,'2020-05-29',24,56),
(17,'2020-05-29',5,56),
(18,'2020-05-30',7,37),
(19,'2020-06-04',31,55),
(20,'2020-06-04',5,32),
(21,'2020-06-05',38,42),
(22,'2020-06-05',36,56),
(23,'2020-06-06',24,56),
(24,'2020-06-06',15,56),
(25,'2020-06-06',12,56),
(26,'2020-06-08',7,37),
(27,'2020-06-11',5,32),
(28,'2020-06-11',31,55),
(29,'2020-06-12',38,42),
(30,'2020-06-12',36,56),
(31,'2020-06-12',12,56),
(32,'2020-06-12',15,56),
(33,'2020-06-12',24,56),
(34,'2020-06-17',7,37),
(35,'2020-06-18',5,32),
(36,'2020-06-19',31,55),
(37,'2020-06-19',38,42),
(38,'2020-06-19',12,56),
(39,'2020-06-19',15,56),
(40,'2020-06-19',24,56),
(41,'2020-06-19',36,56),
(42,'2020-06-25',7,37),
(43,'2020-06-26',38,42),
(44,'2020-06-26',31,55),
(45,'2020-06-26',36,56),
(46,'2020-06-26',15,56),
(47,'2020-06-26',3,56),
(48,'2020-06-29',5,32);


-------------------------incersión de datos de las declaraciones individuales-------------------------


INSERT INTO declaracion_individual (id, producto_declarado_id, declaracion_id, fecha, precio_por_bulto, comercializado, peso_por_bulto)
VALUES (97,20,9,'2020-05-22',300.00,'1',12.00),(98,21,9,'2020-05-22',400.00,'1',18.00),(99,22,9,'2020-05-22',550.00,'1',10.00),
(100,23,9,'2020-05-22',300.00,'1',12.00),(101,25,9,'2020-05-22',400.00,'1',20.00),(102,27,9,'2020-05-22',350.00,'1',20.00),
(103,28,9,'2020-05-22',600.00,'1',10.00),(104,30,9,'2020-05-22',400.00,'1',17.00),(105,31,9,'2020-05-22',700.00,'1',18.00),
(106,33,9,'2020-05-22',600.00,'1',16.00),(107,34,9,'2020-05-22',200.00,'1',20.00),(108,35,9,'2020-05-22',850.00,'1',20.00),
(109,37,9,'2020-05-22',1100.00,'1',20.00),(110,40,9,'2020-05-22',400.00,'1',18.00),(111,41,9,'2020-05-22',500.00,'1',19.00),
(112,42,9,'2020-05-22',700.00,'1',20.00),(113,45,9,'2020-05-22',600.00,'1',19.00),(114,20,10,'2020-05-22',200.00,'1',6.00),
(115,21,10,'2020-05-22',300.00,'1',13.00),(116,22,10,'2020-05-22',500.00,'1',6.00),(117,23,10,'2020-05-22',350.00,'1',5.00),
(118,25,10,'2020-05-22',NULL,'1',NULL),(119,27,10,'2020-05-22',300.00,'1',20.00),(120,28,10,'2020-05-22',1000.00,'1',6.00),
(121,30,10,'2020-05-22',600.00,'1',18.00),(122,31,10,'2020-05-22',800.00,'1',18.00),(123,33,10,'2020-05-22',1000.00,'1',18.00),
(124,34,10,'2020-05-22',250.00,'1',16.00),(125,35,10,'2020-05-22',1000.00,'1',20.00),(126,37,10,'2020-05-22',900.00,'1',20.00),
(127,40,10,'2020-05-22',400.00,'1',18.00),(128,41,10,'2020-05-22',650.00,'1',20.00),(129,42,10,'2020-05-22',1000.00,'1',20.00),
(130,45,10,'2020-05-22',600.00,'1',20.00),(131,20,11,'2020-05-27',300.00,'1',10.00),(132,21,11,'2020-05-27',350.00,'1',12.00),
(133,22,11,'2020-05-27',250.00,'1',10.00),(134,23,11,'2020-05-27',150.00,'1',5.00),(135,25,11,'2020-05-27',350.00,'1',17.50),
(136,27,11,'2020-05-27',250.00,'1',18.00),(137,28,11,'2020-05-27',800.00,'1',10.00),(138,30,11,'2020-05-27',400.00,'1',18.00),
(139,31,11,'2020-05-27',800.00,'1',18.00),(140,33,11,'2020-05-27',350.00,'1',15.00),(141,34,11,'2020-05-27',200.00,'1',12.50),
(142,35,11,'2020-05-27',750.00,'1',10.00),(143,37,11,'2020-05-27',1200.00,'1',20.00),(144,40,11,'2020-05-27',NULL,'0',NULL),
(145,41,11,'2020-05-27',450.00,'1',17.00),(146,42,11,'2020-05-27',700.00,'1',17.00),(147,45,11,'2020-05-27',600.00,'1',17.00),
(148,50,11,'2020-05-27',320.00,'1',18.00),(149,20,12,'2020-05-27',275.00,'1',10.00),(150,21,12,'2020-05-27',235.00,'1',10.00),
(151,22,12,'2020-05-27',NULL,'0',NULL),(152,23,12,'2020-05-27',375.00,'1',10.00),(153,25,12,'2020-05-27',NULL,'0',NULL),
(154,27,12,'2020-05-27',200.00,'1',10.00),(155,28,12,'2020-05-27',NULL,'0',NULL),(156,30,12,'2020-05-27',NULL,'0',NULL),
(157,31,12,'2020-05-27',775.00,'1',10.00),(158,33,12,'2020-05-27',580.00,'1',10.00),(159,34,12,'2020-05-27',205.00,'1',10.00),
(160,35,12,'2020-05-27',NULL,'0',NULL),(161,37,12,'2020-05-27',475.00,'1',10.00),(162,40,12,'2020-05-27',230.00,'1',10.00),
(163,41,12,'2020-05-27',375.00,'1',10.00),(164,42,12,'2020-05-27',475.00,'1',10.00),(165,45,12,'2020-05-27',340.00,'1',10.00),
(166,50,12,'2020-05-27',240.00,'1',10.00),(167,20,13,'2020-05-29',300.00,'1',12.00),(168,21,13,'2020-05-29',400.00,'1',18.00),
(169,22,13,'2020-05-29',600.00,'1',12.00),(170,23,13,'2020-05-29',300.00,'1',12.00),(171,25,13,'2020-05-29',350.00,'1',20.00),
(172,27,13,'2020-05-29',300.00,'1',20.00),(173,28,13,'2020-05-29',600.00,'1',10.00),(174,30,13,'2020-05-29',400.00,'1',17.00),
(175,31,13,'2020-05-29',900.00,'1',18.00),(176,33,13,'2020-05-29',600.00,'1',16.00),(177,34,13,'2020-05-29',200.00,'1',20.00),
(178,35,13,'2020-05-29',1000.00,'1',20.00),(179,37,13,'2020-05-29',1100.00,'1',20.00),(180,40,13,'2020-05-29',400.00,'1',18.00),
(181,41,13,'2020-05-29',500.00,'1',19.00),(182,42,13,'2020-05-29',700.00,'1',20.00),(183,45,13,'2020-05-29',600.00,'1',19.00),
(184,50,13,'2020-05-29',300.00,'1',20.00),(185,20,14,'2020-05-29',350.00,'1',12.00),(186,21,14,'2020-05-29',NULL,'0',NULL),
(187,22,14,'2020-05-29',NULL,'0',NULL),(188,23,14,'2020-05-29',250.00,'1',8.00),(189,25,14,'2020-05-29',NULL,'0',NULL),
(190,27,14,'2020-05-29',330.00,'1',20.00),(191,28,14,'2020-05-29',NULL,'0',NULL),(192,30,14,'2020-05-29',NULL,'0',NULL),
(193,31,14,'2020-05-29',1300.00,'1',20.00),(194,33,14,'2020-05-29',800.00,'1',20.00),(195,34,14,'2020-05-29',270.00,'1',18.00),
(196,35,14,'2020-05-29',NULL,'0',NULL),(197,37,14,'2020-05-29',1300.00,'1',20.00),(198,40,14,'2020-05-29',270.00,'1',18.00),
(199,41,14,'2020-05-29',680.00,'1',18.00),(200,42,14,'2020-05-29',960.00,'1',20.00),(201,45,14,'2020-05-29',540.00,'1',18.00),
(202,50,14,'2020-05-29',420.00,'1',20.00),(203,20,15,'2020-05-29',NULL,'0',NULL),(204,21,15,'2020-05-29',200.00,'1',10.00),
(205,22,15,'2020-05-29',NULL,'0',NULL),(206,23,15,'2020-05-29',250.00,'1',10.00),(207,25,15,'2020-05-29',NULL,'0',NULL),
(208,27,15,'2020-05-29',150.00,'1',10.00),(209,28,15,'2020-05-29',NULL,'0',NULL),(210,30,15,'2020-05-29',NULL,'0',NULL),
(211,31,15,'2020-05-29',700.00,'1',10.00),(212,33,15,'2020-05-29',400.00,'1',10.00),(213,34,15,'2020-05-29',150.00,'1',10.00),
(214,35,15,'2020-05-29',NULL,'0',NULL),(215,37,15,'2020-05-29',600.00,'1',10.00),(216,40,15,'2020-05-29',200.00,'1',10.00),
(217,41,15,'2020-05-29',400.00,'1',10.00),(218,42,15,'2020-05-29',520.00,'1',10.00),(219,45,15,'2020-05-29',350.00,'1',10.00),
(220,50,15,'2020-05-29',210.00,'1',10.00),(221,20,16,'2020-05-29',225.00,'1',10.00),(222,21,16,'2020-05-29',290.00,'1',12.00),
(223,22,16,'2020-05-29',450.00,'1',10.00),(224,23,16,'2020-05-29',250.00,'1',10.00),(225,25,16,'2020-05-29',325.00,'1',10.00),
(226,27,16,'2020-05-29',450.00,'1',15.00),(227,28,16,'2020-05-29',800.00,'1',18.00),(228,30,16,'2020-05-29',275.00,'1',18.00),
(229,31,16,'2020-05-29',750.00,'1',20.00),(230,33,16,'2020-05-29',525.00,'1',20.00),(231,34,16,'2020-05-29',285.00,'1',20.00),
(232,35,16,'2020-05-29',1275.00,'1',18.00),(233,37,16,'2020-05-29',1000.00,'1',20.00),(234,40,16,'2020-05-29',NULL,'0',NULL),
(235,41,16,'2020-05-29',650.00,'1',20.00),(236,42,16,'2020-05-29',1050.00,'1',20.00),(237,45,16,'2020-05-29',600.00,'1',20.00),
(238,50,16,'2020-05-29',375.00,'1',18.00),(239,20,17,'2020-05-29',300.00,'1',12.00),(240,21,17,'2020-05-29',200.00,'1',10.00),
(241,22,17,'2020-05-29',500.00,'1',12.00),(242,23,17,'2020-05-29',220.00,'1',5.00),(243,25,17,'2020-05-29',NULL,'0',NULL),
(244,27,17,'2020-05-29',300.00,'1',18.00),(245,28,17,'2020-05-29',750.00,'1',10.00),(246,30,17,'2020-05-29',400.00,'1',18.00),
(247,31,17,'2020-05-29',1200.00,'1',18.00),(248,33,17,'2020-05-29',NULL,'0',NULL),(249,34,17,'2020-05-29',250.00,'1',15.00),
(250,35,17,'2020-05-29',650.00,'1',10.00),(251,37,17,'2020-05-29',1200.00,'1',20.00),(252,40,17,'2020-05-29',NULL,'0',NULL),
(253,41,17,'2020-05-29',500.00,'1',18.00),(254,42,17,'2020-05-29',700.00,'1',18.00),(255,45,17,'2020-05-29',450.00,'1',18.00),
(256,50,17,'2020-05-29',450.00,'1',18.00),(257,20,18,'2020-05-30',200.00,'1',12.00),(258,21,18,'2020-05-30',300.00,'1',13.00),
(259,22,18,'2020-05-30',250.00,'1',6.00),(260,23,18,'2020-05-30',250.00,'1',5.00),(261,25,18,'2020-05-30',NULL,'0',NULL),
(262,27,18,'2020-05-30',300.00,'1',20.00),(263,28,18,'2020-05-30',400.00,'1',6.00),(264,30,18,'2020-05-30',400.00,'1',18.00),
(265,31,18,'2020-05-30',800.00,'1',18.00),(266,33,18,'2020-05-30',300.00,'1',18.00),(267,34,18,'2020-05-30',260.00,'1',16.00),
(268,35,18,'2020-05-30',1300.00,'1',20.00),(269,37,18,'2020-05-30',750.00,'1',20.00),(270,40,18,'2020-05-30',300.00,'1',18.00),
(271,41,18,'2020-05-30',600.00,'1',20.00),(272,42,18,'2020-05-30',800.00,'1',20.00),(273,45,18,'2020-05-30',500.00,'1',20.00),
(274,50,18,'2020-05-30',NULL,'0',NULL),(275,20,19,'2020-06-04',250.00,'1',12.00),(276,21,19,'2020-06-04',250.00,'1',15.00),
(277,22,19,'2020-06-04',400.00,'1',8.00),(278,23,19,'2020-06-04',150.00,'1',5.00),(279,25,19,'2020-06-04',300.00,'1',20.00),
(280,27,19,'2020-06-04',280.00,'1',20.00),(281,28,19,'2020-06-04',800.00,'1',8.00),(282,30,19,'2020-06-04',NULL,'0',NULL),
(283,31,19,'2020-06-04',1200.00,'1',18.00),(284,33,19,'2020-06-04',700.00,'1',18.00),(285,34,19,'2020-06-04',250.00,'1',15.00),
(286,35,19,'2020-06-04',700.00,'1',18.00),(287,37,19,'2020-06-04',700.00,'1',20.00),(288,40,19,'2020-06-04',380.00,'1',17.00),
(289,41,19,'2020-06-04',600.00,'1',16.00),(290,42,19,'2020-06-04',800.00,'1',20.00),(291,45,19,'2020-06-04',400.00,'1',16.00),
(292,50,19,'2020-06-04',400.00,'1',17.00),(293,20,20,'2020-06-04',300.00,'1',12.00),(294,21,20,'2020-06-04',300.00,'1',15.00),
(295,22,20,'2020-06-04',600.00,'1',10.00),(296,23,20,'2020-06-04',300.00,'1',5.00),(297,25,20,'2020-06-04',350.00,'1',18.00),
(298,27,20,'2020-06-04',300.00,'1',18.00),(299,28,20,'2020-06-04',1000.00,'1',8.00),(300,30,20,'2020-06-04',NULL,'0',NULL),
(301,31,20,'2020-06-04',1000.00,'1',20.00),(302,33,20,'2020-06-04',900.00,'1',17.00),(303,34,20,'2020-06-04',230.00,'1',15.00),
(304,35,20,'2020-06-04',1200.00,'1',20.00),(305,37,20,'2020-06-04',1200.00,'1',20.00),(306,40,20,'2020-06-04',300.00,'1',17.00),
(307,41,20,'2020-06-04',500.00,'1',18.00),(308,42,20,'2020-06-04',700.00,'1',18.00),(309,45,20,'2020-06-04',400.00,'1',18.00),
(310,50,20,'2020-06-04',450.00,'1',18.00),(311,20,21,'2020-06-05',300.00,'1',12.00),(312,21,21,'2020-06-05',400.00,'1',18.00),
(313,22,21,'2020-06-05',500.00,'1',12.00),(314,23,21,'2020-06-05',300.00,'1',12.00),(315,25,21,'2020-06-05',350.00,'1',20.00),
(316,27,21,'2020-06-05',300.00,'1',20.00),(317,28,21,'2020-06-05',600.00,'1',10.00),(318,30,21,'2020-06-05',400.00,'1',17.00),
(319,31,21,'2020-06-05',1000.00,'1',18.00),(320,33,21,'2020-06-05',500.00,'1',16.00),(321,34,21,'2020-06-05',200.00,'1',20.00),
(322,35,21,'2020-06-05',850.00,'1',20.00),(323,37,21,'2020-06-05',1100.00,'1',20.00),(324,40,21,'2020-06-05',300.00,'1',18.00),
(325,41,21,'2020-06-05',500.00,'1',19.00),(326,42,21,'2020-06-05',700.00,'1',20.00),(327,45,21,'2020-06-05',600.00,'1',19.00),
(328,50,21,'2020-06-05',300.00,'1',20.00),(329,20,22,'2020-06-05',200.00,'1',10.00),(330,21,22,'2020-06-05',200.00,'1',13.00),
(331,22,22,'2020-06-05',250.00,'1',13.00),(332,23,22,'2020-06-05',100.00,'1',5.00),(333,25,22,'2020-06-05',300.00,'1',19.00),
(334,27,22,'2020-06-05',250.00,'1',19.00),(335,28,22,'2020-06-05',450.00,'1',9.00),(336,30,22,'2020-06-05',400.00,'1',18.00),
(337,31,22,'2020-06-05',800.00,'1',17.00),(338,33,22,'2020-06-05',500.00,'1',15.00),(339,34,22,'2020-06-05',150.00,'1',15.00),
(340,35,22,'2020-06-05',700.00,'1',10.00),(341,37,22,'2020-06-05',1200.00,'1',20.00),(342,40,22,'2020-06-05',NULL,'0',NULL),
(343,41,22,'2020-06-05',400.00,'1',17.00),(344,42,22,'2020-06-05',600.00,'1',18.00),(345,45,22,'2020-06-05',300.00,'1',18.00),
(346,50,22,'2020-06-05',450.00,'1',18.00),(347,20,23,'2020-06-06',300.00,'1',10.00),(348,21,23,'2020-06-06',340.00,'1',12.00),
(349,22,23,'2020-06-06',350.00,'1',10.00),(350,23,23,'2020-06-06',200.00,'1',10.00),(351,25,23,'2020-06-06',275.00,'1',10.00),
(352,27,23,'2020-06-06',400.00,'1',15.00),(353,28,23,'2020-06-06',700.00,'1',18.00),(354,30,23,'2020-06-06',375.00,'1',18.00),
(355,31,23,'2020-06-06',1000.00,'1',20.00),(356,33,23,'2020-06-06',550.00,'1',20.00),(357,34,23,'2020-06-06',250.00,'1',20.00),
(358,35,23,'2020-06-06',950.00,'1',18.00),(359,37,23,'2020-06-06',300.00,'1',10.00),(360,40,23,'2020-06-06',NULL,'0',NULL),
(361,41,23,'2020-06-06',625.00,'1',20.00),(362,42,23,'2020-06-06',1200.00,'1',20.00),(363,45,23,'2020-06-06',500.00,'1',20.00),
(364,50,23,'2020-06-06',475.00,'1',18.00),(365,20,24,'2020-06-06',NULL,'0',NULL),(366,21,24,'2020-06-06',235.00,'1',10.00),
(367,22,24,'2020-06-06',NULL,'0',NULL),(368,23,24,'2020-06-06',375.00,'1',10.00),(369,25,24,'2020-06-06',200.00,'1',10.00),
(370,27,24,'2020-06-06',200.00,'1',10.00),(371,28,24,'2020-06-06',NULL,'0',NULL),(372,30,24,'2020-06-06',NULL,'0',NULL),
(373,31,24,'2020-06-06',875.00,'1',10.00),(374,33,24,'2020-06-06',580.00,'1',10.00),(375,34,24,'2020-06-06',205.00,'1',10.00),
(376,35,24,'2020-06-06',NULL,'0',NULL),(377,37,24,'2020-06-06',810.00,'1',10.00),(378,40,24,'2020-06-06',230.00,'1',10.00),
(379,41,24,'2020-06-06',375.00,'1',10.00),(380,42,24,'2020-06-06',475.00,'1',10.00),(381,45,24,'2020-06-06',340.00,'1',10.00),
(382,50,24,'2020-06-06',240.00,'1',10.00),(383,20,25,'2020-06-06',NULL,'0',NULL),(384,21,25,'2020-06-06',200.00,'1',10.00),
(385,22,25,'2020-06-06',NULL,'0',NULL),(386,23,25,'2020-06-06',250.00,'1',10.00),(387,25,25,'2020-06-06',150.00,'1',10.00),
(388,27,25,'2020-06-06',150.00,'1',10.00),(389,28,25,'2020-06-06',NULL,'0',NULL),(390,30,25,'2020-06-06',NULL,'0',NULL),
(391,31,25,'2020-06-06',750.00,'1',10.00),(392,33,25,'2020-06-06',400.00,'1',10.00),(393,34,25,'2020-06-06',150.00,'1',10.00),
(394,35,25,'2020-06-06',NULL,'0',NULL),(395,37,25,'2020-06-06',580.00,'1',10.00),(396,40,25,'2020-06-06',200.00,'1',10.00),
(397,41,25,'2020-06-06',400.00,'1',10.00),(398,42,25,'2020-06-06',520.00,'1',10.00),(399,45,25,'2020-06-06',350.00,'1',10.00),
(400,50,25,'2020-06-06',210.00,'1',10.00),(401,20,26,'2020-06-08',250.00,'1',12.00),(402,21,26,'2020-06-08',320.00,'1',13.00),
(403,22,26,'2020-06-08',300.00,'1',6.00),(404,23,26,'2020-06-08',200.00,'1',5.00),(405,25,26,'2020-06-08',NULL,'1',NULL),
(406,27,26,'2020-06-08',330.00,'1',20.00),(407,28,26,'2020-06-08',850.00,'1',6.00),(408,30,26,'2020-06-08',NULL,'0',NULL),
(409,31,26,'2020-06-08',1300.00,'1',18.00),(410,33,26,'2020-06-08',700.00,'1',18.00),(411,34,26,'2020-06-08',200.00,'1',16.00),
(412,35,26,'2020-06-08',1200.00,'1',20.00),(413,37,26,'2020-06-08',650.00,'1',20.00),(414,40,26,'2020-06-08',250.00,'1',18.00),
(415,41,26,'2020-06-08',350.00,'1',20.00),(416,42,26,'2020-06-08',550.00,'1',20.00),(417,45,26,'2020-06-08',350.00,'1',20.00),
(418,50,26,'2020-06-08',NULL,'0',NULL),(419,20,27,'2020-06-11',350.00,'1',12.00),(420,21,27,'2020-06-11',300.00,'1',15.00),
(421,22,27,'2020-06-11',550.00,'1',10.00),(422,23,27,'2020-06-11',300.00,'1',5.00),(423,25,27,'2020-06-11',350.00,'1',18.00),
(424,27,27,'2020-06-11',280.00,'1',18.00),(425,28,27,'2020-06-11',1000.00,'1',8.00),(426,30,27,'2020-06-11',400.00,'1',8.00),
(427,31,27,'2020-06-11',1600.00,'1',20.00),(428,33,27,'2020-06-11',900.00,'1',17.00),(429,34,27,'2020-06-11',250.00,'1',NULL),
(430,35,27,'2020-06-11',1200.00,'1',20.00),(431,37,27,'2020-06-11',1200.00,'1',20.00),(432,40,27,'2020-06-11',300.00,'1',17.00),
(433,41,27,'2020-06-11',500.00,'1',18.00),(434,42,27,'2020-06-11',700.00,'1',18.00),(435,45,27,'2020-06-11',400.00,'1',18.00),
(436,50,27,'2020-06-11',450.00,'1',18.00),(437,20,28,'2020-06-11',280.00,'1',12.00),(438,21,28,'2020-06-11',250.00,'1',15.00),
(439,22,28,'2020-06-11',400.00,'1',8.00),(440,23,28,'2020-06-11',150.00,'1',5.00),(441,25,28,'2020-06-11',300.00,'1',20.00),
(442,27,28,'2020-06-11',280.00,'1',20.00),(443,28,28,'2020-06-11',900.00,'1',8.00),(444,30,28,'2020-06-11',NULL,'0',NULL),
(445,31,28,'2020-06-11',1200.00,'1',18.00),(446,33,28,'2020-06-11',600.00,'1',18.00),(447,34,28,'2020-06-11',250.00,'1',15.00),
(448,35,28,'2020-06-11',700.00,'1',18.00),(449,37,28,'2020-06-11',700.00,'1',20.00),(450,40,28,'2020-06-11',400.00,'1',17.00),
(451,41,28,'2020-06-11',650.00,'1',16.00),(452,42,28,'2020-06-11',800.00,'1',20.00),(453,45,28,'2020-06-11',400.00,'1',16.00),
(454,50,28,'2020-06-11',450.00,'1',17.00),(455,20,29,'2020-06-12',300.00,'1',12.00),(456,21,29,'2020-06-12',400.00,'1',18.00),
(457,22,29,'2020-06-12',500.00,'1',12.00),(458,23,29,'2020-06-12',300.00,'1',12.00),(459,25,29,'2020-06-12',350.00,'1',20.00),
(460,27,29,'2020-06-12',300.00,'1',20.00),(461,28,29,'2020-06-12',600.00,'1',10.00),(462,30,29,'2020-06-12',400.00,'1',17.00),
(463,31,29,'2020-06-12',1200.00,'1',18.00),(464,33,29,'2020-06-12',700.00,'1',16.00),(465,34,29,'2020-06-12',200.00,'1',20.00),
(466,35,29,'2020-06-12',850.00,'1',20.00),(467,37,29,'2020-06-12',1100.00,'1',20.00),(468,40,29,'2020-06-12',300.00,'1',18.00),
(469,41,29,'2020-06-12',500.00,'1',19.00),(470,42,29,'2020-06-12',700.00,'1',20.00),(471,45,29,'2020-06-12',600.00,'1',19.00),
(472,50,29,'2020-06-12',300.00,'1',20.00),(473,20,30,'2020-06-12',250.00,'1',10.00),(474,21,30,'2020-06-12',200.00,'1',14.00),
(475,22,30,'2020-06-12',250.00,'1',12.50),(476,23,30,'2020-06-12',200.00,'1',5.00),(477,25,30,'2020-06-12',300.00,'1',19.00),
(478,27,30,'2020-06-12',240.00,'1',18.00),(479,28,30,'2020-06-12',700.00,'1',10.00),(480,30,30,'2020-06-12',400.00,'1',18.00),
(481,31,30,'2020-06-12',1000.00,'1',20.00),(482,33,30,'2020-06-12',400.00,'1',15.00),(483,34,30,'2020-06-12',250.00,'1',12.50),
(484,35,30,'2020-06-12',700.00,'1',10.00),(485,37,30,'2020-06-12',1000.00,'1',20.00),(486,40,30,'2020-06-12',NULL,'0',NULL),
(487,41,30,'2020-06-12',400.00,'1',17.00),(488,42,30,'2020-06-12',700.00,'1',18.00),(489,45,30,'2020-06-12',500.00,'1',17.00),
(490,50,30,'2020-06-12',400.00,'1',18.00),(491,20,31,'2020-06-12',NULL,'0',NULL),(492,21,31,'2020-06-12',200.00,'1',10.00),
(493,22,31,'2020-06-12',NULL,'0',NULL),(494,23,31,'2020-06-12',250.00,'1',10.00),(495,25,31,'2020-06-12',140.00,'1',10.00),
(496,27,31,'2020-06-12',140.00,'1',10.00),(497,28,31,'2020-06-12',NULL,'0',NULL),(498,30,31,'2020-06-12',NULL,'0',NULL),
(499,31,31,'2020-06-12',750.00,'1',10.00),(500,33,31,'2020-06-12',430.00,'1',10.00),(501,34,31,'2020-06-12',150.00,'1',10.00),
(502,35,31,'2020-06-12',NULL,'0',NULL),(503,37,31,'2020-06-12',510.00,'1',10.00),(504,40,31,'2020-06-12',200.00,'1',10.00),
(505,41,31,'2020-06-12',400.00,'1',10.00),(506,42,31,'2020-06-12',520.00,'1',10.00),(507,45,31,'2020-06-12',320.00,'1',10.00),
(508,50,31,'2020-06-12',210.00,'1',10.00),(509,20,32,'2020-06-12',NULL,'0',NULL),(510,21,32,'2020-06-12',235.00,'1',10.00),
(511,22,32,'2020-06-12',NULL,'0',NULL),(512,23,32,'2020-06-12',400.00,'1',10.00),(513,25,32,'2020-06-12',205.00,'1',10.00),
(514,27,32,'2020-06-12',205.00,'1',10.00),(515,28,32,'2020-06-12',NULL,'0',NULL),(516,30,32,'2020-06-12',NULL,'0',NULL),
(517,31,32,'2020-06-12',960.00,'1',10.00),(518,33,32,'2020-06-12',580.00,'1',10.00),(519,34,32,'2020-06-12',205.00,'1',10.00),
(520,35,32,'2020-06-12',NULL,'0',NULL),(521,37,32,'2020-06-12',850.00,'1',10.00),(522,40,32,'2020-06-12',230.00,'1',10.00),
(523,41,32,'2020-06-12',375.00,'1',10.00),(524,42,32,'2020-06-12',475.00,'1',10.00),(525,45,32,'2020-06-12',410.00,'1',10.00),
(526,50,32,'2020-06-12',260.00,'1',10.00),(527,20,33,'2020-06-12',275.00,'1',10.00),(528,21,33,'2020-06-12',303.00,'1',12.00),
(529,22,33,'2020-06-12',450.00,'1',10.00),(530,23,33,'2020-06-12',200.00,'1',10.00),(531,25,33,'2020-06-12',335.00,'1',10.00),
(532,27,33,'2020-06-12',450.00,'1',15.00),(533,28,33,'2020-06-12',950.00,'1',18.00),(534,30,33,'2020-06-12',525.00,'1',18.00),
(535,31,33,'2020-06-12',1250.00,'1',20.00),(536,33,33,'2020-06-12',625.00,'1',20.00),(537,34,33,'2020-06-12',300.00,'1',20.00),
(538,35,33,'2020-06-12',1275.00,'1',18.00),(539,37,33,'2020-06-12',875.00,'1',20.00),(540,40,33,'2020-06-12',NULL,'0',NULL),
(541,41,33,'2020-06-12',750.00,'1',20.00),(542,42,33,'2020-06-12',950.00,'1',20.00),(543,45,33,'2020-06-12',500.00,'1',20.00),
(544,50,33,'2020-06-12',500.00,'1',18.00),(545,20,34,'2020-06-17',300.00,'1',12.00),(546,21,34,'2020-06-17',350.00,'1',13.00),
(547,22,34,'2020-06-17',400.00,'1',6.00),(548,23,34,'2020-06-17',150.00,'1',5.00),(549,25,34,'2020-06-17',NULL,'0',NULL),
(550,27,34,'2020-06-17',300.00,'1',20.00),(551,28,34,'2020-06-17',900.00,'1',6.00),(552,30,34,'2020-06-17',700.00,'1',18.00),
(553,31,34,'2020-06-17',1300.00,'1',18.00),(554,33,34,'2020-06-17',800.00,'1',18.00),(555,34,34,'2020-06-17',250.00,'1',16.00),
(556,35,34,'2020-06-17',1200.00,'1',20.00),(557,37,34,'2020-06-17',650.00,'1',20.00),(558,40,34,'2020-06-17',250.00,'1',18.00),
(559,41,34,'2020-06-17',400.00,'1',20.00),(560,42,34,'2020-06-17',600.00,'1',20.00),(561,45,34,'2020-06-17',350.00,'1',20.00),
(562,50,34,'2020-06-17',NULL,'0',NULL),(563,20,35,'2020-06-18',300.00,'1',12.00),(564,21,35,'2020-06-18',300.00,'1',15.00),
(565,22,35,'2020-06-18',600.00,'1',10.00),(566,23,35,'2020-06-18',300.00,'1',5.00),(567,25,35,'2020-06-18',350.00,'1',18.00),
(568,27,35,'2020-06-18',300.00,'1',18.00),(569,28,35,'2020-06-18',1100.00,'1',8.00),(570,30,35,'2020-06-18',400.00,'1',8.00),
(571,31,35,'2020-06-18',1600.00,'1',20.00),(572,33,35,'2020-06-18',700.00,'1',17.00),(573,34,35,'2020-06-18',250.00,'1',15.00),
(574,35,35,'2020-06-18',1200.00,'1',20.00),(575,37,35,'2020-06-18',1000.00,'1',20.00),(576,40,35,'2020-06-18',350.00,'1',17.00),
(577,41,35,'2020-06-18',500.00,'1',18.00),(578,42,35,'2020-06-18',700.00,'1',18.00),(579,45,35,'2020-06-18',400.00,'1',18.00),
(580,50,35,'2020-06-18',450.00,'1',18.00),(581,20,36,'2020-06-19',300.00,'1',12.00),(582,21,36,'2020-06-19',350.00,'1',15.00),
(583,22,36,'2020-06-19',350.00,'1',8.00),(584,23,36,'2020-06-19',170.00,'1',5.00),(585,25,36,'2020-06-19',280.00,'1',20.00),
(586,27,36,'2020-06-19',250.00,'1',20.00),(587,28,36,'2020-06-19',900.00,'1',8.00),(588,30,36,'2020-06-19',NULL,'0',NULL),
(589,31,36,'2020-06-19',700.00,'1',18.00),(590,33,36,'2020-06-19',400.00,'1',18.00),(591,34,36,'2020-06-19',250.00,'1',15.00),
(592,35,36,'2020-06-19',700.00,'1',18.00),(593,37,36,'2020-06-19',750.00,'1',20.00),(594,40,36,'2020-06-19',350.00,'1',17.00),
(595,41,36,'2020-06-19',450.00,'1',16.00),(596,42,36,'2020-06-19',800.00,'1',20.00),(597,45,36,'2020-06-19',350.00,'1',16.00),
(598,50,36,'2020-06-19',400.00,'1',17.00),(599,20,37,'2020-06-19',300.00,'1',12.00),(600,21,37,'2020-06-19',400.00,'1',18.00),
(601,22,37,'2020-06-19',500.00,'1',12.00),(602,23,37,'2020-06-19',300.00,'1',12.00),(603,25,37,'2020-06-19',350.00,'1',20.00),
(604,27,37,'2020-06-19',300.00,'1',20.00),(605,28,37,'2020-06-19',1200.00,'1',10.00),(606,30,37,'2020-06-19',400.00,'1',17.00),
(607,31,37,'2020-06-19',1000.00,'1',18.00),(608,33,37,'2020-06-19',700.00,'1',16.00),(609,34,37,'2020-06-19',200.00,'1',20.00),
(610,35,37,'2020-06-19',850.00,'1',20.00),(611,37,37,'2020-06-19',1100.00,'1',20.00),(612,40,37,'2020-06-19',300.00,'1',18.00),
(613,41,37,'2020-06-19',500.00,'1',19.00),(614,42,37,'2020-06-19',700.00,'1',20.00),(615,45,37,'2020-06-19',600.00,'1',19.00),
(616,50,37,'2020-06-19',300.00,'1',20.00),(617,20,38,'2020-06-19',NULL,'0',NULL),(618,21,38,'2020-06-19',200.00,'1',10.00),
(619,22,38,'2020-06-19',NULL,'0',NULL),(620,23,38,'2020-06-19',250.00,'1',10.00),(621,25,38,'2020-06-19',140.00,'1',10.00),
(622,27,38,'2020-06-19',140.00,'1',10.00),(623,28,38,'2020-06-19',NULL,'0',NULL),(624,30,38,'2020-06-19',NULL,'0',NULL),
(625,31,38,'2020-06-19',750.00,'1',10.00),(626,33,38,'2020-06-19',430.00,'1',10.00),(627,34,38,'2020-06-19',150.00,'1',10.00),
(628,35,38,'2020-06-19',NULL,'0',NULL),(629,37,38,'2020-06-19',510.00,'1',10.00),(630,40,38,'2020-06-19',200.00,'1',10.00),
(631,41,38,'2020-06-19',400.00,'1',10.00),(632,42,38,'2020-06-19',520.00,'1',10.00),(633,45,38,'2020-06-19',320.00,'1',10.00),
(634,50,38,'2020-06-19',210.00,'1',10.00),(635,20,39,'2020-06-19',NULL,'0',NULL),(636,21,39,'2020-06-19',200.00,'1',10.00),
(637,22,39,'2020-06-19',NULL,'0',NULL),(638,23,39,'2020-06-19',250.00,'1',10.00),(639,25,39,'2020-06-19',150.00,'1',10.00),
(640,27,39,'2020-06-19',150.00,'1',10.00),(641,28,39,'2020-06-19',NULL,'0',NULL),(642,30,39,'2020-06-19',NULL,'0',NULL),
(643,31,39,'2020-06-19',550.00,'1',10.00),(644,33,39,'2020-06-19',450.00,'1',10.00),(645,34,39,'2020-06-19',150.00,'1',10.00),
(646,35,39,'2020-06-19',NULL,'0',NULL),(647,37,39,'2020-06-19',520.00,'1',10.00),(648,40,39,'2020-06-19',200.00,'1',10.00),
(649,41,39,'2020-06-19',400.00,'1',10.00),(650,42,39,'2020-06-19',450.00,'1',10.00),(651,45,39,'2020-06-19',320.00,'1',10.00),
(652,50,39,'2020-06-19',220.00,'1',10.00),(653,20,40,'2020-06-19',300.00,'1',10.00),(654,21,40,'2020-06-19',365.00,'1',12.00),
(655,22,40,'2020-06-19',435.00,'1',10.00),(656,23,40,'2020-06-19',200.00,'1',10.00),(657,25,40,'2020-06-19',290.00,'1',10.00),
(658,27,40,'2020-06-19',475.00,'1',15.00),(659,28,40,'2020-06-19',975.00,'1',18.00),(660,30,40,'2020-06-19',550.00,'1',18.00),
(661,31,40,'2020-06-19',900.00,'1',20.00),(662,33,40,'2020-06-19',500.00,'1',20.00),(663,34,40,'2020-06-19',250.00,'1',20.00),
(664,35,40,'2020-06-19',1100.00,'1',18.00),(665,37,40,'2020-06-19',925.00,'1',20.00),(666,40,40,'2020-06-19',NULL,'0',NULL),
(667,41,40,'2020-06-19',575.00,'1',20.00),(668,42,40,'2020-06-19',1125.00,'1',20.00),(669,45,40,'2020-06-19',500.00,'1',20.00),
(670,50,40,'2020-06-19',465.00,'1',18.00),(671,20,41,'2020-06-19',300.00,'1',10.00),(672,21,41,'2020-06-19',250.00,'1',12.50),
(673,22,41,'2020-06-19',400.00,'1',12.00),(674,23,41,'2020-06-19',100.00,'1',5.00),(675,25,41,'2020-06-19',280.00,'1',19.00),
(676,27,41,'2020-06-19',250.00,'1',19.00),(677,28,41,'2020-06-19',1200.00,'1',12.00),(678,30,41,'2020-06-19',400.00,'1',18.00),
(679,31,41,'2020-06-19',800.00,'1',17.00),(680,33,41,'2020-06-19',450.00,'1',15.00),(681,34,41,'2020-06-19',250.00,'1',15.00),
(682,35,41,'2020-06-19',650.00,'1',10.00),(683,37,41,'2020-06-19',1000.00,'1',20.00),(684,40,41,'2020-06-19',NULL,'0',NULL),
(685,41,41,'2020-06-19',400.00,'1',17.00),(686,42,41,'2020-06-19',700.00,'1',18.00),(687,45,41,'2020-06-19',400.00,'1',17.00),
(688,50,41,'2020-06-19',350.00,'1',18.00),(689,20,42,'2020-06-25',300.00,'1',12.00),(690,21,42,'2020-06-25',300.00,'1',13.00),
(691,22,42,'2020-06-25',500.00,'1',6.00),(692,23,42,'2020-06-25',200.00,'1',5.00),(693,25,42,'2020-06-25',NULL,'1',NULL),
(694,27,42,'2020-06-25',330.00,'1',20.00),(695,28,42,'2020-06-25',900.00,'1',6.00),(696,30,42,'2020-06-25',500.00,'1',18.00),
(697,31,42,'2020-06-25',500.00,'1',18.00),(698,33,42,'2020-06-25',400.00,'1',18.00),(699,34,42,'2020-06-25',300.00,'1',16.00),
(700,35,42,'2020-06-25',1050.00,'1',20.00),(701,37,42,'2020-06-25',800.00,'1',20.00),(702,40,42,'2020-06-25',500.00,'1',18.00),
(703,41,42,'2020-06-25',600.00,'1',20.00),(704,42,42,'2020-06-25',800.00,'1',20.00),(705,45,42,'2020-06-25',600.00,'1',20.00),
(706,50,42,'2020-06-25',480.00,'1',20.00),(707,20,43,'2020-06-26',300.00,'1',12.00),(708,21,43,'2020-06-26',400.00,'1',18.00),
(709,22,43,'2020-06-26',500.00,'1',12.00),(710,23,43,'2020-06-26',300.00,'1',12.00),(711,25,43,'2020-06-26',350.00,'1',20.00),
(712,27,43,'2020-06-26',300.00,'1',20.00),(713,28,43,'2020-06-26',800.00,'1',10.00),(714,30,43,'2020-06-26',400.00,'1',17.00),
(715,31,43,'2020-06-26',600.00,'1',18.00),(716,33,43,'2020-06-26',700.00,'1',16.00),(717,34,43,'2020-06-26',200.00,'1',20.00),
(718,35,43,'2020-06-26',850.00,'1',20.00),(719,37,43,'2020-06-26',1100.00,'1',20.00),(720,40,43,'2020-06-26',300.00,'1',18.00),
(721,41,43,'2020-06-26',500.00,'1',19.00),(722,42,43,'2020-06-26',700.00,'1',20.00),(723,45,43,'2020-06-26',600.00,'1',19.00),
(724,50,43,'2020-06-26',300.00,'1',20.00),(725,20,44,'2020-06-26',200.00,'1',12.00),(726,21,44,'2020-06-26',350.00,'1',15.00),
(727,22,44,'2020-06-26',400.00,'1',8.00),(728,23,44,'2020-06-26',150.00,'1',5.00),(729,25,44,'2020-06-26',300.00,'1',20.00),
(730,27,44,'2020-06-26',250.00,'1',20.00),(731,28,44,'2020-06-26',600.00,'1',8.00),(732,30,44,'2020-06-26',NULL,'0',NULL),
(733,31,44,'2020-06-26',950.00,'1',18.00),(734,33,44,'2020-06-26',200.00,'1',18.00),(735,34,44,'2020-06-26',250.00,'1',15.00),
(736,35,44,'2020-06-26',700.00,'1',20.00),(737,37,44,'2020-06-26',700.00,'1',20.00),(738,40,44,'2020-06-26',350.00,'1',17.00),
(739,41,44,'2020-06-26',350.00,'1',16.00),(740,42,44,'2020-06-26',800.00,'1',20.00),(741,45,44,'2020-06-26',400.00,'1',16.00),
(742,50,44,'2020-06-26',450.00,'1',17.00),(743,20,45,'2020-06-26',400.00,'1',10.00),(744,21,45,'2020-06-26',250.00,'1',12.50),
(745,22,45,'2020-06-26',400.00,'1',12.00),(746,23,45,'2020-06-26',150.00,'1',5.00),(747,25,45,'2020-06-26',330.00,'1',20.50),
(748,27,45,'2020-06-26',300.00,'1',20.00),(749,28,45,'2020-06-26',800.00,'1',10.00),(750,30,45,'2020-06-26',500.00,'1',19.00),
(751,31,45,'2020-06-26',600.00,'1',17.00),(752,33,45,'2020-06-26',400.00,'1',15.00),(753,34,45,'2020-06-26',250.00,'1',15.00),
(754,35,45,'2020-06-26',600.00,'1',10.00),(755,37,45,'2020-06-26',1000.00,'1',20.00),(756,40,45,'2020-06-26',NULL,'0',NULL),
(757,41,45,'2020-06-26',400.00,'1',17.00),(758,42,45,'2020-06-26',700.00,'1',18.00),(759,45,45,'2020-06-26',400.00,'1',17.00),
(760,50,45,'2020-06-26',400.00,'1',18.00),(761,20,46,'2020-06-26',NULL,'0',NULL),(762,21,46,'2020-06-26',230.00,'1',10.00),
(763,22,46,'2020-06-26',NULL,'0',NULL),(764,23,46,'2020-06-26',260.00,'1',10.00),(765,25,46,'2020-06-26',160.00,'1',10.00),
(766,27,46,'2020-06-26',160.00,'1',10.00),(767,28,46,'2020-06-26',870.00,'1',10.00),(768,30,46,'2020-06-26',NULL,'0',NULL),
(769,31,46,'2020-06-26',720.00,'1',10.00),(770,33,46,'2020-06-26',320.00,'1',10.00),(771,34,46,'2020-06-26',150.00,'1',10.00),
(772,35,46,'2020-06-26',350.00,'1',10.00),(773,37,46,'2020-06-26',600.00,'1',10.00),(774,40,46,'2020-06-26',NULL,'0',NULL),
(775,41,46,'2020-06-26',380.00,'1',10.00),(776,42,46,'2020-06-26',500.00,'1',10.00),(777,45,46,'2020-06-26',280.00,'1',10.00),
(778,50,46,'2020-06-26',230.00,'1',10.00),(779,20,47,'2020-06-26',300.00,'1',12.00),(780,21,47,'2020-06-26',NULL,'0',NULL),
(781,22,47,'2020-06-26',NULL,'0',NULL),(782,23,47,'2020-06-26',250.00,'1',8.00),(783,25,47,'2020-06-26',320.00,'1',20.00),
(784,27,47,'2020-06-26',320.00,'1',20.00),(785,28,47,'2020-06-26',800.00,'1',8.00),(786,30,47,'2020-06-26',NULL,'0',NULL),
(787,31,47,'2020-06-26',700.00,'1',20.00),(788,33,47,'2020-06-26',700.00,'1',20.00),(789,34,47,'2020-06-26',270.00,'1',18.00),
(790,35,47,'2020-06-26',NULL,'0',NULL),(791,37,47,'2020-06-26',1250.00,'1',20.00),(792,40,47,'2020-06-26',400.00,'1',18.00),
(793,41,47,'2020-06-26',700.00,'1',18.00),(794,42,47,'2020-06-26',1000.00,'1',20.00),(795,45,47,'2020-06-26',450.00,'1',18.00),
(796,50,47,'2020-06-26',480.00,'1',20.00),(797,20,48,'2020-06-29',300.00,'1',12.00),(798,21,48,'2020-06-29',300.00,'1',15.00),
(799,22,48,'2020-06-29',550.00,'1',10.00),(800,23,48,'2020-06-29',250.00,'1',5.00),(801,25,48,'2020-06-29',350.00,'1',18.00),
(802,27,48,'2020-06-29',300.00,'1',18.00),(803,28,48,'2020-06-29',900.00,'1',8.00),(804,30,48,'2020-06-29',400.00,'1',8.00),
(805,31,48,'2020-06-29',700.00,'1',18.00),(806,33,48,'2020-06-29',700.00,'1',17.00),(807,34,48,'2020-06-29',300.00,'1',15.00),
(808,35,48,'2020-06-29',1200.00,'1',20.00),(809,37,48,'2020-06-29',1000.00,'1',20.00),(810,40,48,'2020-06-29',300.00,'1',17.00),
(811,41,48,'2020-06-29',500.00,'1',18.00),(812,42,48,'2020-06-29',700.00,'1',18.00),(813,45,48,'2020-06-29',400.00,'1',18.00),
(814,50,48,'2020-06-29',450.00,'1',18.00);


--PUNTO F) Agregar el usuario Ines Cosa, username niñita, mail ines(at)cosa(dot)com, suerte como palabra clave.

INSERT INTO "user" (id, email, password, nombre, apellido)
VALUES (101,'ines@cosa.com','suerte','Ines','Cosa');

