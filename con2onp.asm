; con2onp  
; program wykonuje translacje z postaci infiksowej do postfiksowej (ONP)
; autor Piotr Najman

; dla zainteresowanych pozostawilem komentarze
; moze komus sie przyda ew zakreci sie na tym
; punkcie chwile jak ja kiedys


MASM
jumps
assume CS:CODE, DS:DATA
CODE SEGMENT
org 100h

start:
	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0

	mov ah,00h			;ustaw tryb tekstowy
	mov al,03h
	int 10h
	
	
	mov ax,177			;ax zaladuj kod znaku
	call ekran			;wypelnij ekran znakiem z ax
	
	call ryspomoc		;wyswietl wierz pomocy

	call rysokno		;rysuj okno programu
	
	call polaxy			;ustal poczatkowe sporzedne dla pol tekstowych
	
						;ustaw kursor na polu ONP
	mov dl,xokna		;przeslij x do dl
	add dl,3
	mov dh,yokna		;przeslij y do dh
	add dh,3
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h

rozpocznij:				;rozpoczecie programu po narysowaniu okna
	mov ax,0			;zerowanie akumulatora
	mov bh,0			;bh wskaznik stosu - ustawienie na 0
	mov bl,0			;zerowanie bl - to bedzie bufor dla al
	mov cx,0			;zerowanie pozostalych rejestrow
	mov dx,0
		
	jmp petla_glowna	;skok do glownej petli programu

nakonsole:				;wypisanie znakow na konsole i skok do pobrania kolejnego
						;wypisz znak w polu inf i ustaw wskaznik polozenia
	mov dl,xinf			;przeslij x do dl
	mov dh,yinf			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xinf			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xinf,dl			;zapisz nowa pozycje x dla lini infix
	
						;wypisz znak w polu onp i ustaw wskaznik polozenia
	mov dl,xonp			;przeslij x do dl
	mov dh,yonp			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xonp			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xonp,dl			;zapisz nowa pozycje x dla lini postfix	
	
	jmp petla_glowna	;skok do glownej petli programu
	
cyfra:
	cmp al,58			;spardzenie czy jest cyfra -9
	jb nakonsole		;wypisz na konsole jeœli tak

	jmp petla_glowna	;skok do glownej petli programu

duza:
	cmp al,91			;spardzenie czy jest duza litera -Z
	jb nakonsole		;wypisz na konsole jeœli tak

	jmp petla_glowna	;skok do glownej petli programu

mala:
	cmp al,123			;spardzenie czy jest mala litera -z
	jb nakonsole		;wypisz na konsole jeœli tak

	jmp petla_glowna	;skok do glownej petli programu

nastosipetla:			;odklada znak z al na stos
	
	push ax				;odloz na stos
	inc bh				;zwieksz licznik stosu
	
	jmp petla_glowna	;skocz do petli glownej

znakbhnastos:			;odklada znak z al i z bufora bl na stos

	push ax				;odloz nawias/dzialanie zdjete ze stosu spowrotem
	inc bh				;zwieksz licznik stosu
	mov al,bl			;przeslij znak z bufora bl do al
	push ax				;odloz znak na stosie
	inc bh				;zwieksz licznik stosu
	jmp petla_glowna	;skocz do petli glownej programu
	
plusminus:				;obsluga dodawania/odejmowania, priorytet stosowy 1

						;wypisz znak w polu inf i ustaw wskaznik polozenia
	mov dl,xinf			;przeslij x do dl
	mov dh,yinf			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xinf			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xinf,dl			;zapisz nowa pozycje x dla lini infix

plusminus_petla:
	cmp bh,0			;sprawdz czy jest cos na stosie
	jz	nastosipetla	;jesli nie odloz na stos +|- i skocz do petli glownej
	
	mov bl,al			;przeslij +|- do bufora bl
	pop ax				;zdejmij znak ze stosu
	dec bh				;zmniejsz licznik stosu
	cmp al,40			;spradz czy to (
	jz	znakbhnastos	;jesli tak odloz spowrotem nawias a potem +|- na stos 

						;wypisz znak w polu onp i ustaw wskaznik polozenia
	mov dl,xonp			;przeslij x do dl
	mov dh,yonp			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xonp			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xonp,dl			;zapisz nowa pozycje x dla lini postfix	
		
	mov al,bl			;przywroc znak +|- z bufora 
	jmp plusminus_petla	;skok do dalszego oprozniania stosu

mnozdziel:				;obsluga nozenia/dzielenia, priorytet stosowy 2

						;wypisz znak w polu inf i ustaw wskaznik polozenia
	mov dl,xinf			;przeslij x do dl
	mov dh,yinf			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xinf			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xinf,dl			;zapisz nowa pozycje x dla lini infix

mnozdziel_petla:
	cmp bh,0			;sprawdz czy jest cos na stosie
	jz	nastosipetla	;jesli nie odloz na stos *|/ i skocz do petli glownej
	
	mov bl,al			;przeslij *|/ do bufora bl
	pop ax				;zdejmij znak ze stosu
	dec bh				;zmniejsz licznik stosu
	cmp al,45			;spradz czy to -
	jz	znakbhnastos	;jesli tak odloz spowrotem - a potem *|/ na stos 
	cmp al,43			;spradz czy to +
	jz	znakbhnastos	;jesli tak odloz spowrotem + a potem *|/ na stos 
	cmp al,40			;spradz czy to (
	jz	znakbhnastos	;jesli tak odloz spowrotem nawias a potem *|/ na stos 

						;wypisz znak w polu onp i ustaw wskaznik polozenia
	mov dl,xonp			;przeslij x do dl
	mov dh,yonp			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xonp			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xonp,dl			;zapisz nowa pozycje x dla lini postfix	
	
	mov al,bl			;przywroc znak *|/ z bufora 
	jmp mnozdziel_petla	;skok do dalszego oprozniania stosu

	
potpierw:				;obsluga potegowania ^ i pierwiastkowania #

						;wypisz znak w polu inf i ustaw wskaznik polozenia
	mov dl,xinf			;przeslij x do dl
	mov dh,yinf			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xinf			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xinf,dl			;zapisz nowa pozycje x dla lini infix
	
potpierw_petla:
	cmp bh,0			;sprawdz czy jest cos na stosie
	jz	nastosipetla	;jesli nie odloz na stos *|/ i skocz do petli glownej
	
	mov bl,al			;przeslij ^|# do bufora bl
	pop ax				;zdejmij znak ze stosu
	dec bh				;zmniejsz licznik stosu
	cmp al,45			;spradz czy to -
	jz	znakbhnastos	;jesli tak odloz spowrotem - a potem ^|# na stos 
	cmp al,43			;spradz czy to +
	jz	znakbhnastos	;jesli tak odloz spowrotem + a potem ^|# na stos 
	cmp al,42			;spradz czy to *
	jz	znakbhnastos	;jesli tak odloz spowrotem - a potem ^|# na stos 
	cmp al,47			;spradz czy to /
	jz	znakbhnastos	;jesli tak odloz spowrotem + a potem ^|# na stos 
	cmp al,40			;spradz czy to (
	jz	znakbhnastos	;jesli tak odloz spowrotem nawias a potem ^|# na stos 
	
						;wypisz znak w polu onp i ustaw wskaznik polozenia
	mov dl,xonp			;przeslij x do dl
	mov dh,yonp			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xonp			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xonp,dl			;zapisz nowa pozycje x dla lini postfix	
	
	mov al,bl			;przywroc znak ^|# z bufora 
	jmp mnozdziel_petla	;skok do dalszego oprozniania stosu

	
nawiasotw:				;"przyduszenie" zawartoœci stosu nawiasem, priorytet stosowy 0

						;wypisz znak w polu inf i ustaw wskaznik polozenia
	mov dl,xinf			;przeslij x do dl
	mov dh,yinf			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xinf			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xinf,dl			;zapisz nowa pozycje x dla lini infix
	
	jmp nastosipetla	;odloz na stos (przydus) i tyle

	
nawiaszam:				;wyzwalacz oproznienia stosu az do nawiasu otwierajacego

						;wypisz znak w polu inf i ustaw wskaznik polozenia
	mov dl,xinf			;przeslij x do dl
	mov dh,yinf			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xinf			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xinf,dl			;zapisz nowa pozycje x dla lini infix

nawiaszam_petla:
	cmp bh,0			;sprawdz czy jest cos na stosie
	jz	petla_glowna	;jesli nie skocz do petli glownej
	pop ax				;zdejmij element ze stosu
	dec bh				;zmniejsz licznik stosu
	cmp al,40			;sprawdz czy to (
	jz petla_glowna		;jesli tak skocz do petli glownej
	
						;wypisz znak w polu onp i ustaw wskaznik polozenia
	mov dl,xonp			;przeslij x do dl
	mov dh,yonp			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xonp			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xonp,dl			;zapisz nowa pozycje x dla lini postfix	

	jmp nawiaszam_petla	;oprozniaj dalej stos

dzialania:				;rozpoznaje znaki dzialan i podejmuje odpowiednie akcje

	cmp al,47			;sprawdzenie czy jest to dzialanie  ()*+,-./
	ja petla_glowna		;skok do pobrania kolejnego znaku jezeli nie
	cmp al,46			;sprawdzenie czy wcisnieto .
	jz petla_glowna
	cmp al,44			;sprawdzenie czy wcisnieto ,
	jz petla_glowna

						;rozpoznawanie dzialan i skoki do podprogramow
	cmp al,43			;znak +
	jz plusminus
	cmp al,45			;znak -
	jz plusminus
	cmp al,42			;znak *
	jz mnozdziel
	cmp al,47			;znak /
	jz mnozdziel
	cmp al,40			;znak (
	jz nawiasotw
	cmp al,41			;znak )
	jz nawiaszam

	jmp petla_glowna	;skok do glownej petli programu


petla_glowna:			;petla glowna programu
	
	mov ah,08h			;pobranie znaku z klawiatury bez echa
	int 21h

	cmp al,27			;sprawdzenie czy wcinieto Esc
	jz koniec			;jesli tak skok do zakonczenia pragramu

	cmp al,13			;sprawdzenie czy wcinieto Enter
	jz zakwyr			;jesli tak skok do zakonczenia wyrazenia

	cmp al,94			;sprawdzenie czy wcinieto znaku potegowania ^
	jz potpierw			;skok gdy kod znaku rowny

	cmp al,96			;spardzenie czy wprowadzony znak mo¿e byæ z zakresu a-
	ja mala				;skok gdy kod znaku wiekszy

	cmp al,64			;spardzenie czy wprowadzony znak mo¿e byæ z zakresu A-
	ja duza				;skok gdy kod znaku wiekszy
	
	cmp al,47			;spardzenie czy wprowadzony znak mo¿e byæ z zakresu 0->
	ja cyfra			;skok gdy kod znaku wiekszy
	
	cmp al,39			;spardzenie czy wprowadzono znak ()*+,-./
	ja dzialania		;skok gdy kod znaku wiekszy

	jmp petla_glowna

oprstos:				;oproznianie stosu po zakonczeniu wprowadzania lini (nacisnieto Enter)
	pop ax				;zdejmij ze stosu
						;wypisz znak w polu onp i ustaw wskaznik polozenia
	mov dl,xonp			;przeslij x do dl
	mov dh,yonp			;przeslij y do dh
	mov cx,bx			;przeslij bx do cx (licznik stosu)
	xor bx,bx			;wyzeroj bx
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov bx,cx			;przywroc bx z cx (licznik stosu)
	mov dl,al			;wypisz znak na ekran
	mov ah,02h
	int 21h	
	mov dl,xonp			;przeslij x do dl
	add dl,1			;zwieksz dl o 1 - przesun x o jeden w prawo
	mov xonp,dl			;zapisz nowa pozycje x dla lini postfix	
	
	dec bh				;zmniejsz licznik stosu
	
zakwyr:					;konczenie onp
	cmp bh,0			;sprawdz czy zostalo cos na stosie
	ja oprstos;			;jesli tak skocz do zdjecia ze stosu
czekaj:
	mov ah,08h			;pobranie znaku z klawiatury bez echa
	int 21h
	cmp al,13			;sprawdzenie czy wcinieto Enter
	jnz czekaj
	
	jmp start			;po oproznieniu stosu rozpocznij na nowo
	
koniec:					; zakonczenie programu

	mov ax,32			;wyczysc ekran
	call ekran
	
	mov ax,4c00h		;zakoncz progem
	int 21h

ekran PROC				;procedura wypenia ekran znakiem którego kod umieszczono
						;w rejestrze ax przed jej wywo³aniem
	mov cx,0			;cx jako licznik znakow ustaw na 0 
	mov dx,0			;ustaw x,y na 0,0
	mov ah,02h			;ustaw kursor w x,y ekranu
	int 10h
	mov dl,al			;przeslij kod znaku do dl
ekran_petla:
	mov ah,02h			;wypisz znak na ekran
	int 21h
	inc cx
	cmp cx,4000			;4000 = 50 linii po 80 znakow - przewin caly ekran
	jb ekran_petla		;powtarzaj a wypelnisz caly ekran 
	ret

ekran ENDP

ryspomoc PROC			;wyswietl linie pomocy

	mov dl,0			;przeslij x do dl
	mov dh,24			;przeslij y do dh
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov al,' '			;ustaw kod znaku
	mov bh,0			;ustaw storne ekranu
	mov bl,31			;ustaw kolor (bia³e znaki na niebieskim tle)
	mov cx,80			;ustaw ilosc powtorzen znaku
	mov ah,9h
	int 10h
	
	mov dl,0			;przeslij x do dl
	mov dh,24			;przeslij y do dh
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	lea dx,pomoc		;zaladuj linie z opisem programu
	mov ah,09h 			;wyswietl linie
	int 21h
	
ryspomoc ENDP

rysokno	PROC			;procedura rysuje okno na ekranie w pozycji xokna,yokna
						;
	mov ax,0			;zeruj ax
	mov bh,0			;ustaw storne ekranu
	mov bl,31			;ustaw kolor (bia³e znaki na niebieskim tle)
	mov dl,xokna		;przeslij x poczatku okna do dl
	mov dh,yokna		;przeslij y pocztatku okna do dh
	add dh,wokna
	inc dh
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
rysokno_p1:				;rusuje wiersze okna wraz z cieniem
	dec dh				;linia w gore
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,' '			;ustaw kod znaku 
	mov cx,sokna		;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj 
	int 10h	
	add dl,sokna		;ustaw kursor na koncu narysowanej powyzej lini
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov bl,7			;ustaw kolor (bia³e znaki na czarnym tle)
	mov al,'°'			;ustaw kod znaku (cien)
	mov cx,2			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj
	int 10h	
	mov bl,31			;ustaw kolor (bia³e znaki na niebieskim tle)
	dec dl				;zmien pozycje kursora x-1
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'º'			;ustaw kod znaku (ramka pionowa)
	mov cx,1			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj ramke z prawej
	int 10h	
	sub dl,sokna		;zmien pozycje kursora na poczatek rysowanej linii
	inc dl
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'º'			;ustaw kod znaku (ramka pionowa)
	mov cx,1			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj ramke z lewej
	int 10h	
	cmp dh,yokna		;sprawdz czy narysowano juz wszystkie linie okna
	ja rysokno_p1		;jesli nie skocz do rysowania kolejnej linii

						;rysuj gorna ramke
	mov dl,xokna		;przeslij x poczatku okna do dl
	mov dh,yokna		;przeslij y pocztatku okna do dh
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'Í'			;ustaw kod znaku (ramka pozioma)
	mov cx,sokna		;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj ramke pozioma u gory okna
	int 10h	
						;rysuj dolna ramke
	add dh,wokna		;przeslij y konca okna do dh
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'Í'			;ustaw kod znaku (ramka pozioma)
	mov cx,sokna		;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj ramke pozioma u dolu okna
	int 10h	
	inc dh				;kursor y+1 (nastepna linia)
	add dl,2			;kursor x+2
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
						;dorysuj cien
	mov bl,7			;ustaw kolor (bia³e znaki na czarnym tle)
	mov al,'°'			;ustaw kod znaku (cien)
	mov cx,sokna		;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj cien dolny
	int 10h	
	mov dl,xokna		;przeslij x poczatku okna do dl
	mov dh,yokna		;przeslij y pocztatku okna do dh
	add dl,sokna		;przesun kursor na koniec okna
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'±'			;ustaw kod znaku (tlo)
	mov cx,2			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj tlo (dopracowanie cienia prawy gorny rog)
	int 10h	
	mov bl,31			;ustaw kolor (bia³e znaki na niebieskim tle)
						
						;rysuj wierzcholki ramki
	dec dl				;przesun kursor  x-1
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'»'			;ustaw kod znaku (prawy,gorny wierzcholek)
	mov cx,1			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj wierzcholek
	int 10h	
	add dh,wokna		;przesun kursor do ostatniego wiersza
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'¼'			;ustaw kod znaku (prawy,dolny wierzcholek)
	mov cx,1			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj wierzcholek
	int 10h	
	sub dl,sokna		;przesun kursor na poczatek wiersza
	inc dl
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'È'			;ustaw kod znaku (lewy,dolny wierzcholek)
	mov cx,1			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj wierzcholek
	int 10h		
	sub dh,wokna		;przesun kursor do pierwszego wiersza
	mov ah,02h			;ustaw kursor w pozycji x,y okna na ekranie
	int 10h
	mov al,'É'			;ustaw kod znaku (lewy,gorny wierzcholek)
	mov cx,1			;ustaw ilosc powtorzen znaku
	mov ah,9h			;rysuj wierzcholek
	int 10h		
	
						;rysuj nazwe okna
	mov dl,xokna		;przeslij xokna do dl
	mov dh,yokna		;przeslij yokna do dh
	add dl,3			;przesun x o trzy
	push dx				;odloz wspolrzedne xy na stos
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	lea dx,nazwaokna	;zaladuj linie z tytulem programu
	mov ah,09h 			;wyswietl linie
	int 21h
	pop dx				;zdejmij wspolrzedne xy ze stosu
						;rysuj etykiete pola infiksowego
	add dh,2			;przesun y o dwa
	push dx				;odloz wspolrzedne xy na stos
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	lea dx,poleinf		;zaladuj linie z tytulem programu
	mov ah,09h 			;wyswietl linie
	int 21h
	pop dx				;zdejmij wspolrzedne xy ze stosu
						;rysuj etykiete pola onp
	add dh,3			;przesun y o trzy
	push dx				;odloz wspolrzedne xy na stos
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	lea dx,poleonp		;zaladuj linie z tytulem programu
	mov ah,09h 			;wyswietl linie
	int 21h
	pop dx				;zdejmij wspolrzedne xy ze stosu
	
	mov cx,sokna		;przeslij do cx szerokosc okna
	sub cx,6d			;i oblicz dlugosc pola (o 6 mniejsze niz okno)
	mov bl,7			;ustaw kolor (bia³e znaki na czarnym tle)
	mov al,' '			;ustaw kod znaku (puste pole)
	inc dh				;ustaw y na nastepny wiersz
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov ah,9h			;rysuj pole
	int 10h
	sub dh,3			;ustaw y 3 wiersze wyzej
	mov ah,02h			;ustaw kursor w pozycji x,y na ekranie
	int 10h
	mov ah,9h			;rysuj pole
	int 10h

	ret					
	
rysokno	ENDP

polaxy PROC
	
	mov ah,yokna		;zaladuj do ah y
	mov al,xokna		;zaladuj do al x
	add al,3			
	mov xinf,al			;ustaw poczatkowa wartosc xinf
	mov xonp,al			;ustaw poczatkowa wartosc xonp
	add ah,3			
	mov yinf,ah			;ustaw poczatkowa wartosc yinf
	add ah,3			
	mov yonp,ah			;ustaw poczatkowa wartosc yinf
	ret
	
polaxy ENDP

;wspolrzedne i wielkosc okna programu
xokna 	equ	10d	
yokna	equ	5d
sokna 	equ	60d			
wokna	equ	8d

;tresc linii pomocy
pomoc	db 	' Esc-koniec; Enter-dalej; Symbole a-z A-Z 0-9 (); Dzialania +-/*^#$'

;etykiety
nazwaokna 	db 	'¹ con2onp Ì$'
poleinf		db	'Infix:$'
poleonp		db	'ONP:$'
CODE ENDS

DATA SEGMENT
;wpsolrzedne wskaznikow polorzenia kolejnych znakow modyfikowane w trakcie dzia³ania programu
xonp	db 0
yonp	db 0
xinf	db 0
yinf	db 0
DATA ENDS

end start