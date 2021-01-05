#!/bin/bash

echo "*** CONFIGURAZIONE INIZIALE ***"
echo "Verrà generato il file config.txt contenente i parametri cifrati per l'autenticazione sul Sistema Tessera Sanitaria"
echo ""
echo "Inserisci il tuo codice fiscale (username):"
read cf
echo "Inserisci la password di accesso al sistema TS:"
read pass
echo "Inserisci il tuo PIN code:"
read pin
echo "Inserisci la tua Partita IVA:"
read piva

echo "$cf" > data.tmp
openssl rsautl -encrypt -in data.tmp -out data.tmp.enc -inkey SanitelCF.cer -certin -pkcs
cfEnc=`base64 data.tmp.enc | tr -d '\n'`

#echo "$pass" > data.tmp
#openssl rsautl -encrypt -in data.tmp -out data.tmp.enc -inkey SanitelCF.cer -certin -pkcs
#passEnc=`base64 data.tmp.enc | tr -d '\n'`

echo "$pin" > data.tmp
openssl rsautl -encrypt -in data.tmp -out data.tmp.enc -inkey SanitelCF.cer -certin -pkcs
pinEnc=`base64 data.tmp.enc | tr -d '\n'`

auth=`echo -n "$cf"":""$pass" | base64`

rm data.tmp data.tmp.enc

echo "$cfEnc" > config.txt
echo "$pinEnc" >> config.txt
echo "$auth" >> config.txt
echo "$piva" >> config.txt

echo "Configurazione salvata nel file config.txt"

