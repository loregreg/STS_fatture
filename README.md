# STS_fatture

Script per l'importazione automatica delle fatture nel Sistema Tessera Sanitaria (STS)

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

### Prima configurazione

Al primo utilizzo è necessario eseguire lo script di configurazione **config.sh**, così da impostare i vostri dati (Pin code, codice fiscale, ecc.). Lo script genera il file **config.txt** contentente i vostri dati in forma cifrata.

### Inserimento automatico delle fatture

Prima di inserire le fatture controllare: 
* che il file **FATTURE.ods** sia presente nella stessa cartella e contenga almeno una fattura;
* che il file **config.txt** sia presente nella stessa cartella.

Per inserire le fatture si esegue lo script **invio_fatture.sh**. Vengono automaticamente importate nel STS tutte le righe presenti nel file FATTURE.ods, ad eccezione della prima (header) e di quelle con l'ultima colonna (Inserita) con valore non nullo.

Una volta eseguito lo script è importante valorizzare la colonna **Inserita**, inserendo un valore qualsiasi (ad es. "INS", "1", "OK",...) su tutte le righe e salvare il file. Questo consentirà di non re-inserire le fatture già inserite la prossima volta che si esegue lo script.
