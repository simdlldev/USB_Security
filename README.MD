# USB Security
[ITALIAN] Rende le porte USB del tuo PC Linux sicure

English version avaidable now: [click here!](https://github.com/simdlldev/USB_Security/tree/main-english)

---
<Version: 1.5>

---

### Panoramica

USB Security è un set di script e altri componenti che si occupano di disabilitare le porte USB sul computer per impostazione predefinita e di chiedere all'utente se desidera autorizzare un dispositivo quando viene connesso.

---

##### Perché dovrei volerlo sul mio PC?

A causa del modo in cui funziona il protocollo USB, tutti i dispositivi connessi sono "trusted" per impostazione predefinita. Ciò significa che se si collega un dispositivo che finge di essere una tastiera, può iniziare a digitare qualsiasi cosa molto rapidamente. Questo può quindi installare malware, spyware, ecc. USB Security vuole provare a risolvere questo problema.

---

### Sviluppo

**Cosa è già stato implementato:**

- Pop-up con informazioni dettagliate sul dispositivo collegato

- Installazione e configurazione di base con interfaccia grafica

- Flessibilità per adattarsi a dispositivi diversi (1)

- Possibilità di scegliere differenti livelli di sicurezza

**NOVITÀ**

- Blocco dei dispositivi collegati prima dell'avvio

**In fase di sviluppo:**

- Per il livello 2: inserire nella whitelist solo i dispositivi autorizzati e selezionati dall'utente. + Possibilità di visualizzare e gestire i dispositivi autorizzati

- Miglioramenti per la sicurezza

**In programma:**

- Migliore personalizzazione dei livelli di sicurezza

- Nuove funzioni

- Supporto multi-lingua

(1) In alcune circostanze può capitare che non tutte le informazioni del dispositivo collegato sono visualizzate.

---

## Installazione

Prima di installare USB Security è necessario controllare che i seguenti pacchetti siano installati e funzionanti:

- zenity

- notify-send (libnotify)

- systemd (systemctl)

- udev (udevadm)

[Scaricare l'ultima release da GitHub](https://github.com/simdlldev/USB_Security/releases). Eseguire il file *install.sh* con `./install.sh` nella cartella locale o *Esegui come programma* dal menù contestuale.

---

## Utilizzo

**Dopo l'installazione le porte USB vengono disabilitate automaticamente.** 

**Per impostazione predefinita la protezione delle porte USB è impostata sul livello 3**

Una volta installato USB Security è necessario disconnettersi ed effettuare nuovamente il login affinché venga caricato correttamente.  Se dopo aver effettuato l'accesso non viene visualizzato alcun pop-up provare a riavviare il sistema. Per controllare se i vari moduli sono caricati correttamente cercare tra i processi in esecuzione *root-op.sh* e *user-run.sh*. Devono essere presenti entrambi i processi, se no USB Security non può funzionare.

Attraverso l'icona "<u>USB Security</u>" presente nell'App Drawer è possibile cambiare il livello di sicurezza di USB Security. È possibile scegliere tra:

1. **Protezione disattivata**: questa opzione abilita tutti i dispositivi USB che vengono collegati. Di default questa opzione ritorna sul livello 3 dopo 10 minuti (<u>livello 1</u>), ma è possibile scegliere se renderla permanente (fino ad una nuova modifica delle impostazioni, <u>livello 0</u>).

2. **I dispositivi precedentemente autorizzati non richiedono una nuova autorizzazione**: quando un dispositivo viene collegato e viene autorizzato vengono salvate alcune informazioni. Se lo stesso dispositivo viene ricollegato e le informazioni coincidono viene abilitato senza chiedere conferma all'utente. Solo i nuovi dispositivi richiedono l'autorizzazione. (<u>livello 2</u>) *NOTA: i dispositivi autorizzati vengono aggiunti alla whitelist sono quando il livello selezionato è il <u>2</u>.*

3. **Ogni volta che un dispositivo viene connesso viene richiesta l'autorizzazione**: questa è l'opzione di default. Una formattazione o modifiche a basso livello su dispositivi di archiviazione USB possono essere considerate come ri-collegamento, quindi sono da re-autorizzare. (<u>livello 3</u>) *NOTA: per "flashare" delle immagini disco è consigliato impostare il livello 1 per evitare problemi dovuti alla formattazione delle unità*

4. **Ogni volta che un dispositivo viene connesso viene richiesta l'autorizzazione con password**: questa opzione garantisce la massima sicurezza. Ha gli stessi criteri del livello 3, ma richiede la password di root per completare l'autorizzazione. (<u>livello 4</u>) *NOTA: leggere la sezione "Importante nota di sicurezza" prima di utilizzare questa opzione*

---

### Come funziona?

**Spiegazione generale** *(se vuoi conoscere i dettagli consulta la sezione dedicata)*.

Tutte le porte USB vengono automaticamente disabilitate all'avvio.
Quando si collega un dispositivo USB, una regola udev esegue uno script bash che chiede all'utente, con un pop-up zenity, se desidera autorizzare il dispositivo collegato. Se l'utente approva la richiesta, lo script comunica ad un altro script, eseguito con i privilegi di root, di autorizzare il dispositivo.

Tutto questo viene fatto in modo invisibile all'utente che vede solo apparire il pop-up di autorizzazione.

---

### Importante nota di sicurezza

USB Security non fornisce alcuna garanzia in merito all'efficacia e al blocco dei dispositivi USB. Eventuali richieste di autenticazione con password dell'utente servono solo a verificare l'identità dell'utente tramite script, ma non sono richieste effettive di esecuzione di comandi. Inoltre, USB Security salva i file utilizzati per gestire il processo di autorizzazione nella home dell'utente, quindi potenzialmente modificabili da programmi terzi o dall'utente.

#### Al momento i dispositivi USB connessi prima dell'avvio del sistema non vengono disabilitati, poiché connessi prima del caricamento di USB Security. È in fase di sviluppo una correzione per questo problema

---

### Come funziona? Dettagli

`run.sh`: Componente eseguito dalla regola udev. Avvia il processo ri-autorizzazione creando una richiesta per `user-run.sh`.

`root-op.sh`: Componente eseguita con privilegi root all'avvio tramite il servizio systemd *usb-security.service*. All'avvio si occupa di disabilitare le porte USB. Quando `usb.sh` crea una richiesta di sblocco viene eseguita da `root-op.sh`.

`user-run.sh`: Componente eseguita in user space, avviato tramite un file .desktop in autorun. Si occupa di controllare se ci sono nuove richieste di autorizzazione, in caso affermativo richiama `ush.sh` , indicando il nome (*/sys/bus/usb/devices/* **DEVICE**) del dispositivo collegato.

`usb.sh`: Componente in user space, viene richiamato da `user-run.sh`. Si occupa di visualizzare il pop-up per richiedere l'autorizzazione dell'utente. In caso di risposta affermativa crea una richiesta di sblocco per `root-op`.

`manager.sh`: Componente per modificare il livello di sicurezza di USB Security. È possibile eseguirlo con l'apposita icona nell'App Drawer, chiamato "<u>USB Security</u>"



Per maggiori dettagli sul funzionamento e sugli script secondari è possibile consultare il codice sorgente

---
