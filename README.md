# STS_fatture

Script per l'importazione automatica delle fatture nel Sistema Tessera Sanitaria (STS).

**Solo per i professionisti sanitari e per fatture emesse nel 2020!!**

### Requisiti

Per poter utilizzare lo script sono necessari:
* **Username** e **Password** per accedere al STS: sono quelli che si usano per accedere all'applicazione web https://sistemats4.sanita.finanze.it/simossHome/login.jsp
* **PIN code**: è il PIN assegnato dal STS e necessario per l'accesso ai Web Services. Si recupera dall'[applicazione web](https://sistemats4.sanita.finanze.it/simossHome/login.jsp), andando su **Profilo** (menu a sinistra) e poi su **Stampa pincode** (menu in alto a destra).
* Numero di **Partita IVA**

### Funzionamento

Lo script importa i dati presenti nel file di **FATTURE.ods** (file di LibreOffice Calc) nel sistema STS. Il file delle fatture contiene una fattura per ogni riga; per ogni fattura devono essere valorizzati i seguenti campi:
* Numero fattura
* Data di emissione
* Codice Fiscale del Paziente
* Importo
* Pagamento tracciato (sì o no)
* Data del pagamento
* Inserita: quest'ultimo campo serve per marcare le fatture che sono già state inserite nel sistema STS

### Vantaggi

Lo script consente di gestire tutte insieme le fatture emesse dentro un foglio di calcolo, anziché inserirle una a una nell'applicazione web. Il processo è molto più pratico:
* NON è necessario fare il login su nessun sito;
* NON è necessario essere online per aggiungere altre fatture al foglio;
* NON ci sono menu a tendina, né salti di pagina, ma tutti i dati sono raggruppati in un unico foglio;
* si può fare copia-incolla dalle fatture già inserite;
* si hanno i suggerimenti automatici di LibreOffice Calc quando si inizia a scrivere un valore già inserito (ad esempio un codice fiscale).

### Prima configurazione

Al primo utilizzo è necessario eseguire lo script di configurazione **config.sh**, così da impostare i vostri dati (Pin code, codice fiscale, ecc.). Lo script genera il file **config.txt** contentente i vostri dati in forma cifrata.

### Inserimento automatico delle fatture

Prima di inserire le fatture controllare: 
* che il file **FATTURE.ods** sia presente nella stessa cartella e contenga almeno una fattura;
* che il file **config.txt** sia presente nella stessa cartella.

Per inserire le fatture si esegue lo script **invio_fatture.sh**. Vengono automaticamente importate nel STS tutte le righe presenti nel file FATTURE.ods, ad eccezione della prima (header) e di quelle con l'ultima colonna (Inserita) con valore non nullo.

Una volta eseguito lo script è importante valorizzare la colonna **Inserita**, inserendo un valore qualsiasi (ad es. "INS", "1", "OK",...) su tutte le righe e salvare il file. Questo consentirà di non re-inserire le fatture già inserite la prossima volta che si esegue lo script.

## In breve

0. \[SOLO LA PRIMA VOLTA\] Si esegue il file **config.sh** e si risponde alle domande.
1. Si scrivono le fatture del giorno/mese/anno nel foglio **FATTURE.ods**
2. Si esegue lo script **invio_fatture.sh**
3. Si controlla l'esito andando su https://sistemats4.sanita.finanze.it/simossHome/login.jsp **Gestione dati spesa**->**Gestione spese sanitarie**
4. Si marca l'avvenuto inserimento inserento un valore su tutte le righe della colonna **Inserita**

<p align="center">
  <b>Ti è stato utile? Se vuoi puoi offrirmi un caffè:</b>
  <br>
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=CCAVZ54RU5EJL&currency_code=EUR)
</p>
