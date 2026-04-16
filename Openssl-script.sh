#!/bin/bash

read -p "Country Name: " Country
read -p "State or Province Name: " ST
read -p "Locality: " locality
read -p "Organization Name: " OName
read -p "Organization Unit Name: " OUName
read -p "My Name: " Myname
read -p "Common Name: " CName

openssl genrsa -out server.key 4096

openssl req -new -key server.key -out server.csr -subj "/C=$Country/ST=$ST/L=$locality/O=$OName/OU=$OUName/CN=$CName"

openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
