
create table pacienti(
pacient_ID number(8,0) PRIMARY KEY,
nume varchar2(15) NOT NULL,
prenume varchar2(15) NOT NULL,
adresa varchar2(250),
telefon varchar2(15) NOT NULL,
nr_asigurare number(8,0) UNIQUE
);

create table departamente(
denumire varchar2(50) PRIMARY KEY,
posturi_ocupate number(8,0) NOT NULL, 
posturi_total number(8,0) NOT NULL , 
zile_concediu number(8,0) NOT NULL,
CONSTRAINT ck_posturi CHECK(posturi_ocupate<=posturi_total)

);
alter table departamente
modify posturi_ocupate default 0;

alter table departamente
modify posturi_total default 0;

alter table departamente
modify zile_concediu default 0;

create table doctori(
doctor_ID number(8,0) PRIMARY KEY,
nume varchar2(15) NOT NULL,
prenume varchar2(15) NOT NULL,
adresa varchar2(250),
telefon varchar2(15) NOT NULL,
salariu number(8,0) NOT NULL,
specializare varchar2(30) NOT NULL ,
data_angajare date ,
tip_doctor varchar2(30) NOT NULL,
CONSTRAINT ck_sal CHECK(SALARIU>=2400),
CONSTRAINT fk_specializ FOREIGN KEY (specializare) REFERENCES departamente(denumire) ON DELETE CASCADE

);

create table retete(
reteta_ID number(8,0) PRIMARY KEY,
medicamente varchar2(300),
observatii varchar2(400),
pret_reteta number(8,0) DEFAULT 0

);

create table camere(
camera_ID number(8,0) PRIMARY KEY, 
tip varchar2(100) NOT NULL,
capacitate number(8,0) DEFAULT 0, 
etaj number(2,0) NOT NULL,
observatii_camera varchar2(400)
);

create table aparate_medicale(

aparat_ID number(8,0) PRIMARY KEY, 
camera_ID number(8,0) NOT NULL, 
denumire varchar2(150) NOT NULL, 
brand varchar2(50),  
nr_service varchar2(15) NOT NULL,
data_primire date,
pret_cumparare number(8,0) DEFAULT 0,
CONSTRAINT fk_cam_ID FOREIGN KEY (camera_ID) REFERENCES camere(camera_ID) ON DELETE CASCADE
);

create table istoric_doctori(
doctor_ID number (8,0), 
specializare varchar2(30) NOT NULL, 
data_inceput date, 
data_sfarsit date NOT NULL, 
tip_doctor varchar2(30) NOT NULL, 
PRIMARY KEY(doctor_ID, data_inceput),
CONSTRAINT fk_specializare FOREIGN KEY(specializare) REFERENCES departamente(denumire) ON DELETE CASCADE,
CONSTRAINT fk_dct_ID FOREIGN KEY (doctor_ID) REFERENCES doctori(doctor_ID) ON DELETE CASCADE
);

create table personal(

personal_ID number(8,0) PRIMARY KEY, 
nume varchar2(15) NOT NULL,
prenume varchar2(15) NOT NULL,
departament varchar2(50) NOT NULL,  
telefon varchar2(15) NOT NULL,
data_angajare date,  
salariu number (8,0) NOT NULL CHECK(salariu>2400),
CONSTRAINT fk_dep  FOREIGN KEY (departament) REFERENCES departamente(denumire) ON DELETE CASCADE
);

create table programari(

doctor_ID number (8,0), 
pacient_ID number (8,0) NOT NULL, 
data_prog date,
PRIMARY KEY(doctor_ID, data_prog),
CONSTRAINT fk_pacient_ID FOREIGN KEY (pacient_ID) REFERENCES pacienti(pacient_ID) ON DELETE CASCADE,
CONSTRAINT fk_doctorID FOREIGN KEY (doctor_ID) REFERENCES doctori(doctor_ID) ON DELETE CASCADE
);

create table internari(
internare_ID number(8,0) PRIMARY KEY,
pacient_ID number (8,0) NOT NULL, 
doctor_ID number (8,0) NOT NULL, 
camera_ID number (8,0) NOT NULL, 
observatii varchar2(400), 
data date NOT NULL, 
zile_spitalizare number(8,0) NOT NULL, 
CONSTRAINT fk_dct1_ID FOREIGN KEY(doctor_ID) REFERENCES doctori(doctor_ID) ON DELETE CASCADE,
CONSTRAINT fk_cam1_ID FOREIGN KEY (camera_ID) REFERENCES camere(camera_ID) ON DELETE CASCADE,
CONSTRAINT fk_pac1_ID FOREIGN KEY (pacient_ID) REFERENCES pacienti(pacient_ID) ON DELETE CASCADE,
CONSTRAINT check_zile CHECK(zile_spitalizare>0)
);

alter table internari
modify zile_spitalizare default 1;

create table externari(
externare_ID number(8,0) PRIMARY KEY, 
observatii varchar2(400), 
data date NOT NULL,
internare_ID number(8,0) NOT NULL,
CONSTRAINT fk_int_ID FOREIGN KEY (internare_ID) REFERENCES internari(internare_ID) ON DELETE CASCADE
);

create table operatii(
pacient_ID number(8,0), 
camera_ID number(8,0) NOT NULL,  
data_op date, 
doctor_ID number(8,0) NOT NULL, 
denumire varchar2(100) NOT NULL, 
durata number(8,0) NOT NULL, 
cost number(8,0) DEFAULT 0,
PRIMARY KEY(pacient_ID, data_op),
CONSTRAINT fk_camera  FOREIGN KEY (camera_ID) REFERENCES camere(camera_ID) ON DELETE CASCADE,
CONSTRAINT fk_pac3_ID FOREIGN KEY (pacient_ID) REFERENCES pacienti(pacient_ID) ON DELETE CASCADE,
CONSTRAINT fk_docid1 FOREIGN KEY (doctor_ID) REFERENCES doctori(doctor_ID) ON DELETE CASCADE
);

create table consultatii(
doctor_ID number(8,0), 
pacient_ID number(8,0), 
reteta_ID number(8,0),
data_consultatie date NOT NULL, 
afectiune varchar2(200) NOT NULL,
PRIMARY KEY(doctor_ID, pacient_ID, reteta_ID),
CONSTRAINT fk_pacient11_ID FOREIGN KEY (pacient_ID) REFERENCES pacienti(pacient_ID) ON DELETE CASCADE,
CONSTRAINT fk_doc22_ID FOREIGN KEY (doctor_ID) REFERENCES doctori(doctor_ID) ON DELETE CASCADE,
CONSTRAINT fk_reteta11_ID FOREIGN KEY (reteta_ID) REFERENCES retete(reteta_ID) ON DELETE CASCADE
);

commit;

--INSERARI

 alter SESSION set NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
 
--camere
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (1, 'operatii', 5, 1, null);
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (2, 'internari', 10, 2, 'Cardiologie. Fara grup sanitar.');
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (3, 'depozitare', null, 4, null);
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (4, 'internari', 12, 3, 'Neurologie.');
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (5, 'internari', 6, 2, 'Gastroenterologie.');
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (6, 'operatii', null, 1, 'Fara tuburi oxigen.');
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (7, 'cabinet', 4, 0, 'Cardiologie.');
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (8, 'cabinet', 3, 0, 'Neurologie.');
INSERT INTO camere(CAMERA_ID, TIP, CAPACITATE, ETAJ, OBSERVATII_CAMERA) VALUES (9, 'cabinet', 5, 0, 'Dermatologie.');

--departamente
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('receptie', 2, 5, 20);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('generala', 2, 10, 25);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('cardiologie', 2, 8, 25);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('gastroenterologie', 2, 5, 30);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('neurologie', 1, 7, 30);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('dermatologie', 2, 6, 18);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('ginecologie', 1, 4, 15);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('pneumologie', 1, 5, 18);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('asistente', 3, 10, 15);
INSERT INTO departamente(DENUMIRE, POSTURI_OCUPATE, POSTURI_TOTAL, ZILE_CONCEDIU) VALUES ('infirmiere', 1, 10, 13);

--doctori
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (100, 'Ionescu', 'George', 'Strada Lalelelor,  Bucuresti', '0786649201', 2600, 'cardiologie', to_date('19-01-2021'), 'consultatii');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (101, 'Popescu', 'Ioana', 'Strada Libertatii, Bucuresti', '0765619573', 3500, 'dermatologie', to_date('20-03-2013'), 'consultatii');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (102, 'Iliache', 'Ramona', null, '0747759274', 5000, 'gastroenterologie', to_date('13-01-2010'), 'consultatii');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (103, 'Rolidun', 'Flavius', null, '0747417503', 3900, 'neurologie', to_date('20-08-2013'), 'consultatii');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (104, 'Enache', 'Diana', 'Strada Morii, Bucuresti', '0738106720', 4000, 'ginecologie', to_date('14-12-2019'), 'chirurg');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (105, 'Badea', 'Rares', 'Strada Caragiale, Bucuresti', '0759372849', 5400, 'generala', to_date('29-09-2018'), 'consultatii');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (106, 'Tache', 'Robert', null, '0759306710', 4300, 'pneumologie', to_date('13-11-2016'), 'consultatii');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (107, 'Tache', 'Ionut', 'Strada Campulung, Bucuresti', '0783983029', 3900, 'dermatologie', to_date('10-03-2020'), 'chirurg');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (108, 'Dinu', 'Jasmine', null, '0789362295', 4500, 'generala', to_date('12-04-2016'), 'consultatii');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (109, 'Anghel','Elena', 'Strada Mare, Ploiesti', '0756894639', 5300, 'gastroenterologie', to_date('02-09-2017'), 'chirurg');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (110, 'Florea', 'Denisa', 'Strada Castanilor, Ploiesti', '0767491000', 5600, 'cardiologie', to_date('03-04-2014'), 'chirurg');
INSERT INTO doctori(DOCTOR_ID, NUME, PRENUME, ADRESA, TELEFON, SALARIU, SPECIALIZARE, DATA_ANGAJARE, TIP_DOCTOR) VALUES (111, 'Andronache', 'Denis', 'Strada Cailor, Ploiesti', '0767495003', 5200, 'neurologie', to_date('03-03-2010'), 'chirurg');

--personal
INSERT INTO personal(PERSONAL_ID, NUME, PRENUME, DEPARTAMENT, TELEFON, DATA_ANGAJARE, SALARIU) VALUES (10, 'Grigorescu', 'Ion', 'receptie', '0578573422', null, 2600);
INSERT INTO personal(PERSONAL_ID, NUME, PRENUME, DEPARTAMENT, TELEFON, DATA_ANGAJARE, SALARIU) VALUES (11, 'Ilode', 'Georgiana', 'asistente', '0767937193', to_date('09-11-2020'), 2500);
INSERT INTO personal(PERSONAL_ID, NUME, PRENUME, DEPARTAMENT, TELEFON, DATA_ANGAJARE, SALARIU) VALUES (12, 'Florea', 'Ana', 'asistente', '0759593018',to_date('11-10-2021') , 2800);
INSERT INTO personal(PERSONAL_ID, NUME, PRENUME, DEPARTAMENT, TELEFON, DATA_ANGAJARE, SALARIU) VALUES (13, 'Popescu', 'Florentina', 'infirmiere', '0679491977', to_date('30-03-2017'), 2600);
INSERT INTO personal(PERSONAL_ID, NUME, PRENUME, DEPARTAMENT, TELEFON, DATA_ANGAJARE, SALARIU) VALUES (14, 'Ionescu', 'Claudia', 'asistente', '0797591711', to_date('13-05-2018'), 2700);
INSERT INTO personal(PERSONAL_ID, NUME, PRENUME, DEPARTAMENT, TELEFON, DATA_ANGAJARE, SALARIU) VALUES (15, 'Florescu', 'Alexandru', 'receptie', '0797006955', to_date('17-11-2020'), 2500);

--pacienti
INSERT INTO pacienti(PACIENT_ID, NUME, PRENUME, ADRESA, TELEFON, NR_ASIGURARE) VALUES (1, 'Manea', 'Razvan', 'Str. Noua, Iasi', '0572911192', 10);
INSERT INTO pacienti(PACIENT_ID, NUME, PRENUME, ADRESA, TELEFON, NR_ASIGURARE) VALUES (2, 'Robu', 'Florina', 'Str. Florilor, Iasi', '0768401233', null);
INSERT INTO pacienti(PACIENT_ID, NUME, PRENUME, ADRESA, TELEFON, NR_ASIGURARE) VALUES (3, 'Enescu', 'Darius', 'Str. Atelierului, Craiova', '0796940277', null);
INSERT INTO pacienti(PACIENT_ID, NUME, PRENUME, ADRESA, TELEFON, NR_ASIGURARE) VALUES (4, 'Alexandrescu', 'Oana', null, '0757391822', 11);
INSERT INTO pacienti(PACIENT_ID, NUME, PRENUME, ADRESA, TELEFON, NR_ASIGURARE) VALUES (5, 'Ionescu', 'Giulia', 'Str. Stefan, Craiova', '0799098954', 12);
INSERT INTO pacienti(PACIENT_ID, NUME, PRENUME, ADRESA, TELEFON, NR_ASIGURARE) VALUES (6, 'Olaru', 'Francisc', 'Strada Garii, Craiova', '0747264016', null);

--istoric-doctori
INSERT INTO istoric_doctori(DOCTOR_ID, SPECIALIZARE, DATA_INCEPUT, DATA_SFARSIT, TIP_DOCTOR) VALUES (100, 'generala', to_date('30-08-2010'), to_date('15-11-2013'), 'consultatii');
INSERT INTO istoric_doctori(DOCTOR_ID, SPECIALIZARE, DATA_INCEPUT, DATA_SFARSIT, TIP_DOCTOR) VALUES (104, 'ginecologie', to_date('12-09-2016'), to_date('13-08-2017'), 'consultatii');
INSERT INTO istoric_doctori(DOCTOR_ID, SPECIALIZARE, DATA_INCEPUT, DATA_SFARSIT, TIP_DOCTOR) VALUES (104, 'ginecologie', to_date('10-01-2013'), to_date('18-12-2015'), 'chirurg');
INSERT INTO istoric_doctori(DOCTOR_ID, SPECIALIZARE, DATA_INCEPUT, DATA_SFARSIT, TIP_DOCTOR) VALUES (109, 'gastroenterologie', to_date('13-08-2014'), to_date('10-08-2016'), 'consultatii');
INSERT INTO istoric_doctori(DOCTOR_ID, SPECIALIZARE, DATA_INCEPUT, DATA_SFARSIT, TIP_DOCTOR) VALUES (107, 'ginecologie', to_date('04-12-2012'), to_date('28-04-2016'), 'consultatii');
INSERT INTO istoric_doctori(DOCTOR_ID, SPECIALIZARE, DATA_INCEPUT, DATA_SFARSIT, TIP_DOCTOR) VALUES (103, 'neurologie', to_date('19-04-2007'), to_date('07-02-2013'), 'chirurg');

--programari
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (101, 1, '10-03-2021 15:30:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (105, 4, '15-09-2020 9:00:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (105, 5, '01-08-2019 11:30:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (103, 2, '17-03-2014 12:00:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (103, 4, '10-01-2016 11:30:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (103, 2, '18-08-2015 10:45:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (108, 6, '09-04-2019 8:45:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (102, 3, '26-12-2012 9:30:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (106, 1, '19-10-2018 11:00:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (101, 6, '25-11-2014 10:00:00');
INSERT INTO programari(DOCTOR_ID, PACIENT_ID, DATA_PROG) VALUES (108, 1, '23-06-2018 12:30:00');

--retete
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (111, 'med1 med2', 'de 2 ori pe zi', 300);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (222, 'med3 med2', null, default);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (333, null, 'internare+operatii', default);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (444, 'med3', 'dupa masa, timp de 3 zile', 300);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (555, 'med5 med6', 'internare, medicamente in fiecare zi, dupa masa', default);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (666, null, 'internare+operatie', default);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (777, null, 'internare', default);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (888, 'med5', 'o data pe zi', 500);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (999, 'med1', 'internare+operatii', 500);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (1111, 'med3', 'internare+operatie', 700);
INSERT INTO retete(RETETA_ID, MEDICAMENTE, OBSERVATII, PRET_RETETA) VALUES (2222, null, 'consult de rutina, nicio afectiune', default);

--consultatii
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (102, 3, 111, '26-12-2012', 'af1');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (101, 1, 222, '10-03-2021', 'af2');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (105, 4, 333, '15-09-2020', 'af3');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (103, 2, 444, '18-08-2015', 'af2');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (106, 1, 555, '19-10-2018', 'af1');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (105, 5, 666, '01-08-2019', 'af4');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (103, 4, 777, '10-01-2016', 'af5');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (101, 6, 888, '25-11-2014', 'af6');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (108, 6, 999, '09-04-2019', 'af7');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (103, 2, 1111, '17-03-2014', 'af8');
INSERT INTO consultatii(DOCTOR_ID, PACIENT_ID, RETETA_ID, DATA_CONSULTATIE, AFECTIUNE) VALUES (108, 1, 2222, '23-06-2018', 'niciuna');

--aparate_medicale
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (1, 1, 'tub oxigen', 'BestMedicals', '0759201183', null, default);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (2, 4, 'Healthcare Connect', 'JiveX', '0749104922', '06-09-2015', 5000);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (3, 2, 'PACS', 'JiveX', '0749104922', '06-09-2012', 7000);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (4, 6, 'Sigilant microbian', 'Medica', '0789573900', null, default);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (5, 8, 'stetoscop', 'Medica', '0789573900', null, default);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (6, 7, 'stetoscop', 'MedX', '0789854431', '05-05-2019', 200);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (7, 9, 'tensiometru', 'SuperMedical', '0789336822', null, 700);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (8, 6, 'monitor functii vitale', 'MedX', '0789684933', null, 3000);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (9, 5, 'monitor functii vitale PRO', 'MedX', '0789684933', '03-09-2020', 5000);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (10, 1, 'aparat electrosocuri', 'SuperMedical', '0789336822', null, default);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (11, 2, 'aparat electrosocuri', 'MedX', '0789184933', '05-09-2020', 4000);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (12, 1, 'PACS', 'JiveX', '0749104922', null, default);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (13, 3, 'aparat electrosocuri', 'Medica', '0789184933', null, 4000);
INSERT INTO aparate_medicale(APARAT_ID, CAMERA_ID, DENUMIRE, BRAND, NR_SERVICE, DATA_PRIMIRE, PRET_CUMPARARE) VALUES (14, 3, 'PACS', 'Medica', '0749114922', null, default);

--internari
INSERT INTO internari(INTERNARE_ID, PACIENT_ID, DOCTOR_ID, CAMERA_ID, OBSERVATII, DATA, ZILE_SPITALIZARE) VALUES (1, 2, 103, 2, null, '17-03-2014 13:00:00', 5);
INSERT INTO internari(INTERNARE_ID, PACIENT_ID, DOCTOR_ID, CAMERA_ID, OBSERVATII, DATA, ZILE_SPITALIZARE) VALUES (2, 6, 108, 4, 'pacientul trebuie supravegheat mereu', '09-04-2019 09:00:00', 15);
INSERT INTO internari(INTERNARE_ID, PACIENT_ID, DOCTOR_ID, CAMERA_ID, OBSERVATII, DATA, ZILE_SPITALIZARE) VALUES (3, 4, 103, 5, null, '10-01-2016 12:30:00', 5);
INSERT INTO internari(INTERNARE_ID, PACIENT_ID, DOCTOR_ID, CAMERA_ID, OBSERVATII, DATA, ZILE_SPITALIZARE) VALUES (4, 4, 105, 2, 'pacientul trebuie scos la plimbare', '15-09-2020 11:00:00', 20);
INSERT INTO internari(INTERNARE_ID, PACIENT_ID, DOCTOR_ID, CAMERA_ID, OBSERVATII, DATA, ZILE_SPITALIZARE) VALUES (5, 1, 106, 5, null, '19-10-2018 11:00:00', 5);
INSERT INTO internari(INTERNARE_ID, PACIENT_ID, DOCTOR_ID, CAMERA_ID, OBSERVATII, DATA, ZILE_SPITALIZARE) VALUES (6, 5, 105, 4, null, '01-08-2019 12:30:00', 7);

--externari
--cerinta 13-- sequence
CREATE SEQUENCE pk_externare_ID
INCREMENT BY 1  --default 1
START WITH 1
ORDER; -- default 1

INSERT INTO externari(EXTERNARE_ID, OBSERVATII, DATA, INTERNARE_ID) VALUES (pk_externare_ID.NEXTVAL, 'pacientul trebuie sa revina pentru control', '24-03-2014 13:00:00', 1);
INSERT INTO externari(EXTERNARE_ID, OBSERVATII, DATA, INTERNARE_ID) VALUES (pk_externare_ID.NEXTVAL, null, '14-01-2016 13:30:00', 3);
INSERT INTO externari(EXTERNARE_ID, OBSERVATII, DATA, INTERNARE_ID) VALUES (pk_externare_ID.NEXTVAL, 'pacientul trebuie sa revina pentru control', '24-10-2018 12:46:00', 5);
INSERT INTO externari(EXTERNARE_ID, OBSERVATII, DATA, INTERNARE_ID) VALUES (pk_externare_ID.NEXTVAL, 'pacientul trebuie sa revina la scos firele', '10-08-2019 11:33:00', 6);
INSERT INTO externari(EXTERNARE_ID, OBSERVATII, DATA, INTERNARE_ID) VALUES (pk_externare_ID.NEXTVAL, null, '25-04-2019 10:24:00', 2);

commit;

--operatii
INSERT INTO operatii(PACIENT_ID, CAMERA_ID, DATA_OP, DOCTOR_ID, DENUMIRE, DURATA, COST) VALUES (4, 1, '16-09-2020 8:00:00', 104, 'operatie1', 160, default);
INSERT INTO operatii(PACIENT_ID, CAMERA_ID, DATA_OP, DOCTOR_ID, DENUMIRE, DURATA, COST) VALUES (5, 6, '03-08-2019 08:30:00', 109, 'operatie2', 200, default);
INSERT INTO operatii(PACIENT_ID, CAMERA_ID, DATA_OP, DOCTOR_ID, DENUMIRE, DURATA, COST) VALUES (2, 1, '18-03-2014 9:00:00', 111, 'operatie3', 30, 500);
INSERT INTO operatii(PACIENT_ID, CAMERA_ID, DATA_OP, DOCTOR_ID, DENUMIRE, DURATA, COST) VALUES (6, 6, '10-04-2019 09:15:00', 109, 'operatie4', 160, 2000);
INSERT INTO operatii(PACIENT_ID, CAMERA_ID, DATA_OP, DOCTOR_ID, DENUMIRE, DURATA, COST) VALUES (6, 1, '15-04-2019 08:00:00', 109, 'operatie5', 45, 500);

commit;

