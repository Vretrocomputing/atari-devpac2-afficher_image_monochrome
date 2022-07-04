; Afficher une image monochrome en assembleur sur Atari ST
; Par Vretrocomputing, 2022.

	move.w	#4,-(sp)	;Getrez
	trap	#14		;XBIOS
	addq.l	#2,sp

	cmp.w	#2,d0		;Haute résolution ?
	beq	rezok		;Oui

; La résolution est incorrecte
	move.l	#message,-(sp)	;Message d'erreur
	move.w	#9,-(sp)	;Cconws
	trap	#1		;GEMDOS
	addq.l	#6,sp

	bra	waitkey		;Attendre une touche et quitter

rezok:
	DC.W	$a00a		;Line A 10 : Cacher la souris

	move.l	#pi3+2,-(sp)	;Nouvelle palette
	move.w	#6,-(sp)	;Setpalette
	trap	#14		;XBIOS
	addq.l	#6,sp

	move.w	#3,-(sp)	;Logbase
	trap	#14		;XBIOS
	addq.l	#2,sp

	move.l	d0,a3		;Adresse du framebuffer

	move.l	#pi3+34,a0	;Source
	move.l	a3,a1		;Destination

	move.w	#32000/4-1,d0	;Nombre de longs - 1
copie:
	move.l	(a0)+,(a1)+	;Copier un long
	dbf	d0,copie

waitkey:
	move.w	#8,-(sp)	;Cnecin
	trap	#1		;GEMDOS
	addq.l	#2,sp

	clr.w	-(sp)		;Pterm0
	trap	#1		;GEMDOS

pi3:
	INCBIN	tramiel.pi3

message:
	DC.B	"Ce programme ne fonctionne",13,10
	DC.B	"qu'en haute résolution.",13,10,0
