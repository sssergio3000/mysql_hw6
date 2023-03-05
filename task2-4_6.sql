drop DATABASE if EXISTS  MyJoinsDB;
create DATABASE MyJoinsDB;

USE myjoinsdb;

CREATE TABLE personnel (
id SMALLINT AUTO_INCREMENT PRIMARY KEY, -- clustered index
lastname VARCHAR(20) NOT NULL,
firstname VARCHAR(20) NOT NULL,
phonenumber VARCHAR(20) NOT NULL
);

CREATE INDEX lname_idx ON personnel(lastname); -- unclustered index for speeding up search by lastname

SELECT * from personnel where lastname = 'Maroon';

explain SELECT * from personnel where lastname = 'Maroon';

CREATE TABLE company_info (
person_id SMALLINT NOT NULL,
position_name VARCHAR(50) not NULL,
salary int UNSIGNED NOT NULL,
FOREIGN KEY(person_id) REFERENCES personnel(id) -- unclustered index
);

SELECT * from company_info where person_id = 2;
EXPLAIN SELECT * from company_info where person_id = 2;


CREATE TABLE personal_info (
person_id SMALLINT NOT NULL,
familystate VARCHAR(30) not NULL,
birthdate date NOT NULL,
address VARCHAR(100) NOT NULL,
FOREIGN KEY(person_id) REFERENCES personnel(id)  -- unclustered index
);

SELECT * from personal_info where familystate = 'married';
explain SELECT * from personal_info where familystate = 'married';

CREATE INDEX  fam_stat on personal_info(familystate);  -- unclustered index for speeding up search 
														-- by family status
ALTER TABLE personal_info							
DROP INDEX fam_stat;




INSERT INTO `myjoinsdb`.`personnel`
(`lastname`,
`firstname`,
`phonenumber`)
VALUES
('Travolta', 'John', '0987654321'),
('Jackson', 'Samuel', '0987655432'),
('Maroon', 'Frieda', '0977654321'),
('Parker', 'Skott', '0509998887');


INSERT INTO `myjoinsdb`.`personal_info`
(`person_id`,
`familystate`,
`birthdate`,
`address`)
VALUES
(2, 'single', '1987-2-15', 'London, 75 beach street'),
(1, 'married', '2000-12-14', 'Paris, 33 slut street'),
(3, 'married', '1995-08-30', 'Berlin, 12 obst strasse'),
(4, 'divorced', '1990-12-12', 'Praha, 14 beer street');



INSERT INTO `myjoinsdb`.`company_info`
(`person_id`,
`position_name`,
`salary`)
VALUES
(2, 'ceo', 12000),
(1, 'manager', 7000),
(3, 'worker', 3000),
(4, 'worker', 3500);


/*1) Получите контактные данные сотрудников (номера телефонов, место жительства)*/

select personnel.lastname, personnel.firstname, personnel.phonenumber,
(SELECT address from personal_info where personnel.id = personal_info.person_id) as address
from personnel;

/* 2) Получите информацию о дате рождения всех холостых сотрудников и их номера. */

select personnel.lastname, personnel.firstname, personnel.phonenumber,
(select birthdate from personal_info where person_id = personnel.id) as birthdate,
(select familystate from personal_info where person_id = personnel.id) as familystate
from personnel
where id in (SELECT person_id from personal_info where familystate in ('single', 'divorced'));


/*3) Получите информацию обо всех менеджерах компании: дату рождения и номер телефона. */

select personnel.lastname, personnel.firstname, personnel.phonenumber,
(select birthdate from personal_info where person_id = personnel.id) as birthdate
from personnel
where personnel.id in (select person_id from company_info where position_name = 'manager');


-- Task4 - 6 lesson
/*1. Необходимо узнать контактные данные сотрудников (номера телефонов, место жительства)*/

CREATE VIEW Phone_Address AS
    SELECT 
        lastname,
        firstname,
        phonenumber,
        (SELECT 
                address
            FROM
                personal_info
            WHERE
                id = person_id)
    FROM
        personnel;

select * from Phone_Address;

/*2. Необходимо узнать информацию о дате рождения всех не 
женатых сотрудников и номера телефонов этих сотрудников.*/

drop view single_info;

-- option 1
create view single_info as
select familystate, birthdate, (select lastname 
from personnel where id = person_id) as lastname, (select firstname 
from personnel where id = person_id) as firstname, (select phonenumber 
from personnel where id = person_id) as phonenumber
from personal_info 
where familystate in ('divorced', 'single');



-- option 2
create view single_info as
select personnel.lastname, personal_info.familystate, personnel.phonenumber, birthdate
from personnel
join
personal_info
on personnel.id = personal_info.person_id
where personal_info.familystate in ('single', 'divorced');

select * from single_info;
explain select * from single_info;


/*3. Необходимо узнать информацию о дате рождения всех сотрудников
 с должностью менеджер и номера телефонов этих сотрудников.*/
 
 CREATE VIEW managers as
 SELECT lastname, firstname, phonenumber, birthdate, position_name as position
 from personnel
 join
 personal_info
 on id = person_id
 join
 company_info
 on company_info.person_id = personal_info.person_id
 where company_info.position_name = 'manager';
 
select * from managers;

drop view managers;






















