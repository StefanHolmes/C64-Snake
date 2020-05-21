!- Open this in CMB prg Studio!

0 POKE53265,PEEK(53265)AND239:POKE53281,.:POKE53280,.
1 DIMX(255):DIMY(255):S=54276
2 GOSUB980

!- C  = Address of top left corner of playfield in colour RAM
!- W  = Player snake body colour
!- H  = Player snake head colour
!- T  = Player snake end of tail colour
!- F  = Food colour
!- L  = Initial snake length -1
!- N  = (1 = Need to place a random food. 0 = Do not need)
!- G  = Game state: 1 = Playing, 2 = Game over
!- S  = SID base address + 4
!- P  = Points (score)
!- A  = 600 (Y limit) - just for a minor speedup
3 C=55548:W=13:H=7:T=9:F=4:L=4:N=1:G=1:P=.:A=600

!- DX = X direction
!- DY = Y direction (*40)
!- X, Y = Snake head position (0,0 = top left)
!- HP = Index into X/Y array for previous snake head position
!- TP = Index into X/Y array for snake tail position
!- E = Has eaten (needs to grow)?
!- (Reenable screen after)
4 DX=1:DY=.:X=3:Y=.:HP=L:TP=.:FORI=.TOL:X(I)=I:NEXT:E=.:POKE53265,PEEK(53265)OR16

!- Input handling. Prevent doubling back, because that is an unfair way to lose
!- THENIF is faster than AND
5 GETk$:IFk$="w"THENIFDX<>.THENDY=-40:DX=.
6 IFk$="s"THENIFDX<>.THENDY=40:DX=.
7 IFk$="a"THENIFDY<>.THENDY=.:DX=-1
8 IFk$="d"THENIFDY<>.THENDY=.:DX=1

!- Try to find unoccupied space to place food. Careful of random upper bits being set in colour RAM.
10 IFNTHENFP=C+INT(RND(.)*16)+(INT(RND(.)*16)*40):IF(PEEK(FP)AND15)=.THENN=.:POKEFP,F

!- Update snake head position pointer, wrap around at snake length.
20 X(HP)=X:Y(HP)=Y:HP=HP+1:IFHP>LTHENHP=.

!- Blank the character where the end of the tail is.
25 POKEC+X(TP)+Y(TP),.:TP=TP+1

!- If tail end pointer is greater than the length, wrap around.
!- If has eaten, decrement Eat and extend length.
!- Update the position history array to account for growth.
27 IFTP>LTHENTP=.:IFE>.THENL=L+1:E=E-1:X(L)=X(TP):Y(L)=Y(TP):TP=L

!- Replace head with body segment. Update new head position. Wrap at border. 
30 POKEC+X+Y,W:POKEC+X(TP)+Y(TP),T:X=X+DX:IFX>15THENX=.
35 IFX<.THENX=15
40 Y=Y+DY:IFY>ATHENY=.
45 IFY<.THENY=A

!- Did we hit something? Was it our own body? Whoopsie.
50 Z=PEEK(C+X+Y)AND15:IFZ<>.THENIFZ<>FTHENG=2

!- Draw the head at the new position. Did we land on food? Update our score.
55 POKEC+X+Y,H:IFINT(FP)=INT(C+X+Y)THENN=1:E=E+1:P=P+1:?"{home}{down}{down}{down}{down}{down}{down}{down}{right}{right}{right}";P
65 POKES,48:POKES,49
99 ONGGOTO5,100

!- Game over. Turn the snake red starting from the tail end.
100 FORI=1TOL:POKEC+X(TP)+Y(TP),2:TP=TP+1:IFTP>LTHENTP=0
101 FORD=0TO9:NEXT:NEXT
199 STOP

!- Blank screen, draw, set up sound, return.
980 ?"{clear}{down}","{right}{right}{right}{reverse on}{pink}{169}{reverse off}{yellow}{169}{right}{reverse on}{127}{right}{right}{cyan}{169}{light gray}{127}{right}{pink} {reverse off}{169}{right}{reverse on}{yellow} F":?,"{right}{right}{right}{reverse on}{cyan}{169}{reverse off}{purple}{169}{right}{reverse on}{yellow} {light green}{127}{right}{cyan} {light gray} {right}{purple} {127}{right}{light green} {cyan}E"
981 ?"{right}{white}UC{light green}F{yellow}F{cyan}R{green}FF{light blue}CI":?"{right}{light green}B{right}{right}{right}{right}{right}{right}{right}{light blue}B"
982 ?"{right}{yellow}H {light green}s{yellow}c{cyan}W{yellow}r{light green}e {blue}G {white}U{light green}C{yellow}F{cyan}F{pink}F{orange}R{red}RRRRRRRFF{orange}F{pink}C{yellow}I"
983 ?"{right}{cyan}H{right}{right}{right}{right}{right}{right}{right}{blue}G{right}{light green}B",,"{left}{left}{yellow}B":?"{right}{green}H{right}{right}{right}{right}{right}{right}{right}{blue}G{right}{yellow}H",,"{left}{left}{pink}G"
984 ?"{right}{green}B{right}{right}{right}{right}{right}{right}{right}{light blue}B{right}{cyan}H",,"{left}{left}{orange}G":?"{right}{light blue}JCD{blue}DED{light blue}DC{green}K{right}{pink}H",,"{left}{left}{red}G"
985 ?,"{right}{orange}Y",,"{left}{left}{red}T":FORI=.TO5:?,"{right}Y",,"{left}{left}T":NEXT
986 ?,"{right}Y",,"{left}{left}{orange}T":?,"{right}{red}H",,"{left}{left}{pink}G":?,"{right}{orange}H",,"{left}{left}{cyan}G"
987 ?,"{right}{pink}H",,"{left}{left}{yellow}G":?,"{right}B",,"{left}{left}{light green}B":?,"{right}{yellow}J{pink}C{orange}D{red}DDEEEEEEE{orange}E{pink}D{cyan}D{yellow}D{light green}C{white}K"
988 ?"{home}{down}{down}{down}{down}{down}{black}":FORI=.TO15:?,"{right}{right}QQQQQQQQQQQQQQQQ":NEXT:?"{white}"
989 POKES+20,15:POKES-4,.:POKES-3,2:POKES+1,18:POKES+2,.
999 RETURN
