!- Open this in CMB prg Studio!

0 POKE53265,PEEK(53265)AND239:POKE53281,.:POKE53280,.
1 DIMX(255):DIMY(255):S=54276
2 GOSUB1000

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
!- TP = Index into X/Y array for  snake tail position
!- E = Has eaten (needs to grow)?
!- (Reenable screen after)
4 DX=1:DY=.:X=3:Y=.:HP=L:TP=.:FORI=.TOL:X(I)=I:NEXT:E=.:POKE53265,PEEK(53265)OR16

!- Input handling. Prevent doubling back, because that is an unfair way to lose
!- THENIF is faster than AND
30 GETk$:IFk$="w"THENIFDX<>.THENDY=-40:DX=.
31 IFk$="s"THENIFDX<>.THENDY=40:DX=.
32 IFk$="a"THENIFDY<>.THENDY=.:DX=-1
33 IFk$="d"THENIFDY<>.THENDY=.:DX=1

!- Try to find unoccupied space to place food.
!- Only look for one space per loop, to avoid lengthy pauses later on.
!- Careful of random upper bits being set in colour RAM.
35 IFNTHENFP=C+INT(RND(.)*16)+(INT(RND(.)*16)*40):IF(PEEK(FP)AND15)=.THENN=.:POKEFP,F

!- Update snake head position pointer, wrap around at snake length.
40 X(HP)=X:Y(HP)=Y:HP=HP+1:IFHP>LTHENHP=.

!- Blank the character where the end of the tail is.
45 POKEC+X(TP)+Y(TP),.:TP=TP+1

!- If tail end pointer is greater than the length, wrap around.
!- If has eaten, decrement Eat and extend length.
!- Update the position history array to account for growth.
50 IFTP>LTHENTP=.:IFE>.THENL=L+1:E=E-1:X(L)=X(TP):Y(L)=Y(TP):TP=L

!- Replace head with body segment. Update new head position. Wrap at border. 
55 POKEC+X+Y,W:POKEC+X(TP)+Y(TP),T:X=X+DX:IFX>15THENX=.
60 IFX<.THENX=15
65 Y=Y+DY:IFY>ATHENY=.
70 IFY<.THENY=A

!- Did we hit something? Was it our own body? Whoopsie.
75 Z=PEEK(C+X+Y)AND15:IFZ<>.THENIFZ<>FTHENG=2

!- Draw the head at the new position. Did we land on food? Update our score.
80 POKEC+X+Y,H:IFINT(FP)=INT(C+X+Y)THENN=1:E=E+1:P=P+1:?"{home}{down}{down}{down}{down}{down}{down}{down}{right}{right}{right}";P
85 POKES,48:POKES,49
90 ONGGOTO30,100

!- Game over. Turn the snake red starting from the tail end.
100 FORI=1TOL:POKEC+X(TP)+Y(TP),2:TP=TP+1:IFTP>LTHENTP=0
101 FORD=0TO9:NEXT:NEXT
199 STOP

!- Draw, set up sound, return.
1000 PRINT "{clear}{down}             {reverse on}{pink}{169}{reverse off}{yellow}{169} {reverse on}{127}{reverse off}  {reverse on}{cyan}{169}{light gray}{127}{reverse off} {reverse on}{pink} {reverse off}{169} {reverse on}{yellow} F"
1002 PRINT ,"   {reverse on}{cyan}{169}{reverse off}{purple}{169} {reverse on}{yellow} {light green}{127}{reverse off} {reverse on}{cyan} {light gray} {reverse off} {reverse on}{purple} {127}{reverse off} {reverse on}{light green} {cyan}E"
1004 PRINT " {white}UC{light green}F{yellow}F{cyan}R{green}FF{light blue}CI                    {white}UC{light green}F{yellow}F{cyan}R{green}FF{light blue}CI"
1006 PRINT " {light green}B       {light blue}B                    {light green}B       {light blue}B"
1008 PRINT " {yellow}H {cyan}sc{green}W{cyan}re {blue}G {white}U{light green}C{yellow}F{cyan}F{pink}F{orange}R{red}RRRRRRRFF{orange}F{pink}C{yellow}I H   {light green}w   {blue}G"
1010 PRINT " {cyan}H       {blue}G {light green}B{black}QQQQQQQQQQQQQQQQ{yellow}B {cyan}H       {blue}G"
1012 PRINT " {green}H       {blue}G {yellow}H{black}QQQQQQQQQQQQQQQQ{pink}G {light blue}Y {light green}a s d {blue}T"
1014 PRINT " {green}B       {light blue}B {cyan}H{black}QQQQQQQQQQQQQQQQ{orange}G {light blue}Y       {blue}T"
1016 PRINT " {light blue}JCD{blue}DED{light blue}DC{green}K {pink}H{black}QQQQQQQQQQQQQQQQ{red}G {green}H       {blue}G"
1018 PRINT ," {orange}Y{black}QQQQQQQQQQQQQQQQ{red}T {green}H {yellow}eat {purple}Q {blue}G"
1020 PRINT ," {red}Y{black}QQQQQQQQQQQQQQQQ{red}T {green}B       {blue}G"
1022 PRINT ," {red}Y{black}QQQQQQQQQQQQQQQQ{red}T {light blue}JCD{blue}DEED{light blue}D{green}K"
1024 PRINT ," {red}Y{black}QQQQQQQQQQQQQQQQ{red}T"
1026 PRINT ," Y{black}QQQQQQQQQQQQQQQQ{red}T"
1028 PRINT ," Y{black}QQQQQQQQQQQQQQQQ{red}T"
1030 PRINT ," Y{black}QQQQQQQQQQQQQQQQ{red}T"
1032 PRINT ," Y{black}QQQQQQQQQQQQQQQQ{orange}T"
1034 PRINT ," {red}H{black}QQQQQQQQQQQQQQQQ{pink}G"
1036 PRINT ," {orange}H{black}QQQQQQQQQQQQQQQQ{cyan}G"
1038 PRINT ," {pink}H{black}QQQQQQQQQQQQQQQQ{yellow}G"
1040 PRINT ," B{black}QQQQQQQQQQQQQQQQ{light green}B"
1042 PRINT ," {yellow}J{pink}C{orange}D{red}DDEEEEEEE{orange}E{pink}D{cyan}D{yellow}D{light green}C{white}K"
1044 POKES+20,15:POKES-4,.:POKES-3,2:POKES+1,18:POKES+2,.
1046 RETURN
