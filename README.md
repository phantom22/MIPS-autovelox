gestione di un sistema Autovelox per il rilevamento della velocità di autovetture. Il sistema utilizza due sensori a distanza di un metro uno dall’altro in grado di rilevare la presenza di una autovettura.

Il programma di gestione per il microprocessore deve essere in grado di rivelare quando un’auto passa a velocità più elevata rispetto ai 90 km/h previsti dal codice della strada in un tratto extraurbano. Quando questo accade, dopo che sono trascorsi 0,5 s, il programma di gestione deve comandare lo scatto dell’otturatore di una macchina fotografica con un impulso di durata pari a 100 ms e poi ricominciare il controllo sulla prossima autovettura, etc. In particolare, le linee 13 e 12 della cella a 16 bit denominata IN_OUT leggono i sensori che segnalano l’attraversamento quando dal livello logico basso ciascuna linea si porta al livello logico alto. La linea 12 è collegata al primo sensore che un’autovettura incontra nel senso di marcia.

La linea 1 della cella di memoria denominata IN_OUT è utilizzata invece per comandare lo scatto della macchina fotografica.

Infine sulle linee 9 e 8 di IN_OUT bisogna inviare un numero che rappresenta la velocità misurata secondo la seguente convenzione:
 00: velocità < 90 km/h;
 01: velocità compresa fra 90 e 95 km/h;
 10: velocità compresa fra 95 e 100 km/h;
 11: velocità > 100 km/h.

Tale informazione serve per far comparire sul fotogramma un’indicazione che permette di quantificare l’entità dell’infrazione.

Per semplicità si ipotizzi che una sola autovettura alla volta sia nella zona di misura-fotografia.