        .data
            IN_OUT:         .half 0x0

            NOVANTA:        .word 0x3d0900    # (90km/h, 25m/s, 0.04s)      => 4000000.
            NOVANTACINQUE:  .word 0x39d2a1    # (95km/h, 26.38m/s, 0.0378s) => 3789473.
            CENTO:          .word 0x36ee80    # (100km/h, 27.7m/s, 0.036s)  => 3600000.

            MEZZOSEC:       .word 0x2faf080   # 50M.
            CENTOMS:        .word 0x989680    # 10M.

            MASK_S1:        .half 0x1000      # sensore 1 (bit 12).
            MASK_S2:        .half 0x2000      # sensore 2 (bit 13).

        .text

# prima caricare in memoria tutti i valori che serviranno dopo.
            addi $s1, $zero, 1                # $s1=1 (per il controllo dei sensori e della velocità).
            lw   $s2, MEZZOSEC
            lw   $s3, CENTOMS
            lh   $s4, MASK_S1
            lh   $s5, MASK_S2

main:
            j    sensore1

# $s0 IN_OUT.
# $t0 sensore 1.
# $t3 contatore.
sensore1:
            lh   $s0, IN_OUT                  # carico IN_OUT per aggiornare i valori del sensore.

            and  $t0, $s0, $s4                # controllo bit primo sensore (bit 12).
            bne  $t0, $s4, sensore1           # sensore non attivo => torna a controllare lo stato dello sensore.

            addi $t3, $zero, 2                # aggiungere 2 al contatore, tenendo conto delle 3 istruz. finali di sensore1.
            j    sensore2

# $s0 IN_OUT.
# $t0 sensore 2.
# $t3 contatore.
# $t4, $t5, $t6 controllo velocita.
sensore2:
            lh   $s0, IN_OUT

            and  $t0, $s0, $s5                # controllo bit secondo sensore (bit 13).
            addi $t3, $t3, 4                  # aggiungere 4 al contatore, tenendo conto delle 4 istruz. iniziali di sensore2.
            bne  $t0, $s5, sensore2           # sensore non attivo => torna a controllare lo stato dello sensore.

            lw   $t0, NOVANTA                 # carico valori di controllo per la velocita.
            lw   $t1, NOVANTACINQUE
            lw   $t2, CENTO

            # calcolo della velocità, v = velocita
            slt  $t4, $t3, $t2                # $t4=1 => v>100km/h.
            slt  $t5, $t3, $t1                # $t5=1 => v>95km/h.
            slt  $t6, $t3, $t0                # $t6=1 => v>90km/h.

            bne  $t4, $zero, ii               # v > 100
            bne  $t5, $zero, io               # 100 < v < 95    
            bne  $t6, $zero, oi               # 95 < v < 90
            j    oo                           # v < 90
            
oo:
            j    reset                        # se la macchina non supera i 90 km, aspettare la prossima macchina che passa
oi:
            addi $s0, $s0, 0x200              # (bit 9, V2) = 1.
            j    savespeed
io:
            addi $s0, $s0, 0x100              # (bit 8, V1) = 1.
            j    savespeed
ii:
            addi $s0, $s0, 0x300              # (sia V1 che V2) = 1.
            j    savespeed
savespeed:
            sh   $s0, IN_OUT
            add  $t0, $zero, $s2              # numero di istruzioni in 0.5 secondi.

            j    apriotturatore

# $t0 conto alla rovescia
# $t7 se contatore è arrivato a 0
# $s0 IN_OUT
apriotturatore:
            addi $t0, $t0, -3                 # sotraggo 3 tenendo conto delle prime tre istruz. di apriotturatore.
            slt  $t7, $t0, $s1                # $t7=1 se il contatore è minore o uguale a 0.
            bne  $t7, $s1, apriotturatore     # se il contatore non è minore o uguale di 1 => continua a fare il conto alla rovescia

            lh   $s0, IN_OUT
            addi $s0, $s0, 0x2                # in caso contrario, apri otturatore.
            add  $t0, $zero, $s3              # numero di istruzioni in 0.1 secondo.
            j    chiudiotturatore
# $t0 conto alla rovescia
# $t7 se contatore è arrivato a 0
chiudiotturatore:
            addi $t0, $t0, -3
            slt  $t7, $t0, $s1
            bne  $t7, $s1, chiudiotturatore

            j    reset

reset:
            add  $s0, $zero, $zero
            sh   $s0, IN_OUT

            j    main                         # il programma è pronto a controllare la prossima auto.
