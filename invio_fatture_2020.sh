#!/bin/bash

# converti in CSV
soffice --headless --convert-to csv FATTURE.ods

# leggi config.txt
pro_cf=`cat config.txt | head -n 1`
pro_pin=`cat config.txt | tail -n +2 | head -n 1`
pro_auth=`cat config.txt | tail -n +3 | head -n 1`
pro_piva=`cat config.txt | tail -n +4 | head -n 1`

pro_cfEsc=$(printf '%s\n' "$pro_cf" | sed -e 's/[\/&]/\\&/g')
pro_pinEsc=$(printf '%s\n' "$pro_pin" | sed -e 's/[\/&]/\\&/g')

i=0
while IFS=, read -r numF dataE codF imp trac dataP skp
do
	if [ $i -eq 0 ]; then
		let "i+=1"
		continue
	fi
	if [ ! -z "$skp" ]; then
		let "i+=1"
		continue
	fi
    echo "$codF" > data.tmp
	openssl rsautl -encrypt -in data.tmp -out data.tmp.enc -inkey SanitelCF.cer -certin -pkcs
	codFenc=`base64 data.tmp.enc | tr -d '\n'`
	rm data.tmp data.tmp.enc
	codFencEsc=$(printf '%s\n' "$codFenc" | sed -e 's/[\/&]/\\&/g')
	numFesc=$(printf '%s\n' "$numF" | sed -e 's/[\/&]/\\&/g')
	dataEen=`echo $dataE | sed 's/\([0-9][0-9]\).\([0-9][0-9]\).\([0-9][0-9][0-9][0-9]\)/\3-\2-\1/g'`
	dataPen=`echo $dataP | sed 's/\([0-9][0-9]\).\([0-9][0-9]\).\([0-9][0-9][0-9][0-9]\)/\3-\2-\1/g'`
	outFile="inviate/""$dataEen""_"`echo "$numF" | sed 's/\//-/g'`".soap.xml"
	
	# crea la fattura SOAP e salva su fattura-temp.soap.xml
	cat templates/fattura.soap.xml | sed "s/\(<doc:cfCittadino>\).*\(<\/doc:cfCittadino>\)/\1""$codFencEsc""\2/g" | sed "s/\(<doc:dataEmissione>\).*\(<\/doc:dataEmissione>\)/\1""$dataEen""\2/g" | sed "s/\(<doc:dataPagamento>\).*\(<\/doc:dataPagamento>\)/\1""$dataPen""\2/g" | sed "s/\(<doc:importo>\).*\(<\/doc:importo>\)/\1""$imp""\2/g" | sed "s/\(<doc:numDocumento>\).*\(<\/doc:numDocumento>\)/\1""$numFesc""\2/g" | sed "s/\(<doc:pagamentoTracciato>\).*\(<\/doc:pagamentoTracciato>\)/\1""$trac""\2/g" | sed "s/\(<doc:cfProprietario>\).*\(<\/doc:cfProprietario>\)/\1""$pro_cfEsc""\2/g" | sed "s/\(<doc:pincode>\).*\(<\/doc:pincode>\)/\1""$pro_pinEsc""\2/g" | sed "s/\(<doc:pIva>\).*\(<\/doc:pIva>\)/\1""$pro_piva""\2/g" > fattura-temp.soap.xml

	# invia fattura
	curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:inserimento.documentospesap730.sanita.finanze.it" --header "Authorization: Basic $pro_auth" --data @fattura-temp.soap.xml https://invioss730p.sanita.finanze.it/DocumentoSpesa730pWeb/DocumentoSpesa730pPort
	# curl -k --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:inserimento.documentospesap730.sanita.finanze.it" --header "Authorization: Basic $pro_auth" --data @fattura-temp.soap.xml https://invioss730ptest.sanita.finanze.it/DocumentoSpesa730pWeb/DocumentoSpesa730pPort
	
	
	mv fattura-temp.soap.xml "$outFile"
    let "i+=1"
done < FATTURE.csv



