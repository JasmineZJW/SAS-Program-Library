data ahuige;
  input x y ;
  n=_n_;
  z=1/(1/x+1/y)*.88;
  winamt=z*106/120;
  max=max(x,y);
  min=min(x,y);
  winmax=max/2;
  winmin=min/2;
  rx=z/x;
  xx=x/2;
  yy=y/2;
  put xx= yy= z= winamt;
  cards;
1.56 4.5

run;

%AHGprintToLog(_last_,n=20);

proc means;
var winamt winmax winmin;
run;
/* 
??  -1  ??? (2:0) 3:0   ? 2.20    ? 1.34    3 3.60    ??  2.05
??? -1  ??? (0:1) 0:4   ? 1.65    ? 3.20    4 6.00    ??  4.80
??? -1  ??? (0:1) 0:1   ? 2.20    ? 5.10    1 3.55    ??  7.80
??? +1  ??? (0:2) 0:3   ? 4.80    ? 2.08    3 4.10    ??  3.45
??? -1  ??? (0:2) 0:2   ? 1.89    ? 4.40    2 3.10    ??  7.00
??? +1  ??? (2:1) 2:1   ? 1.60    ? 3.25    3 3.75    ??  5.00
????  -1  ????  (2:1) 2:2   ? 1.38    ? 3.15    4 6.50    ??  15.00
??? -1  ????  (1:0) 1:0   ? 3.20    ? 1.54    1 3.70    ??  2.30
??? -1  ??? (0:0) 1:0   ? 3.40    ? 1.91    1 3.50    ??  4.30
??? -1  ??? (2:0) 2:1   ? 3.15    ? 1.44    3 3.70    ??  2.00
??? -1  ??? (0:0) 1:0   ? 3.45    ? 1.72    1 3.95    ??  4.35
??? -1  ??? (1:0) 1:0   ? 3.45    ? 1.92    1 3.40    ??  3.00
????  -1  ??? (1:0) 2:2   ? 2.04    ? 3.60    4 5.80    ??  16.00
??? -1  ? ? (0:0) 1:0   ? 3.55    ? 1.40    1 4.70    ??  3.80
? ? -1  ??? (1:0) 3:0   ? 1.46    ? 1.10    3 3.50    ??  1.40
? ? -2  ??? (2:0) 6:0   ? 1.80      --    6 8.50    ??  1.26
??? -1  ??? (1:0) 2:1   ? 3.30    ? 1.45    3 3.60    ??  2.02
??? -1  ??? (1:0) 4:0   ? 1.51    ? 1.12    4 4.40    ??  1.41
??? -1  ??? (1:2) 2:3   ? 1.57    ? 3.15    5 13.00   ??  5.70
? ? -1  ??? (3:0) 7:0   ? 1.56    ? 1.14    7+  13.00   ??  1.50
??? -1  ??? (1:0) 1:0   ? 3.30    ? 1.28    1 4.10    ??  1.73
??? -1  ??? (2:0) 3:1   ? 2.53    ? 1.49    4 5.00    ??  2.00
? ? -1  ??? (1:0) 1:0   ? 3.65    ? 1.23    1 4.10    ??  1.65
??? +1  ??? (0:0) 0:0   ? 1.68    ? 3.40    0 11.00   ??  4.90
??? -1  ??? (2:0) 4:3   ? 3.40    ? 1.43    7+  23.00   ??  1.98
??? -1  ??? (0:0) 1:2   ? 1.46    ? 2.56    3 3.55    ??  5.80
??? -1  ??? (1:0) 1:1   ? 2.40    ? 3.90    2 3.30    ??  17.00
??? -1  ??? (0:0) 0:0   ? 1.47    ? 3.20    0 9.00    ??  4.40
??? +1  ??? (0:0) 0:0   ? 1.74    ? 3.45    0 10.00   ??  4.80
??? +1  ??? (0:0) 0:2   ? 2.38    ? 1.42    2 3.35    ??  4.00
??? +1  ? ? (0:1) 0:1   ? 4.10    ? 2.33    1 4.00    ??  3.85
??? -1  ? ? (0:0) 3:0   ? 4.80    ? 2.28    3 3.55    ??  5.65
??? +1  ??? (1:1) 1:2   ? 3.50    ? 1.65    3 3.60    ??  4.50
??? -1  ??? (0:1) 1:4   ? 3.03    ? 8.20    5 9.00    ??  14.00



data allscores;
  input  host guest;
  cards;
1 4 
1 2
3 0
0 1
0 2
0 0 
0 0
1 1 
1 2 
4 3 
0 0 
1 0
3 1
1 0
7 0
2 3
4 0
2 1
6 0
3 0
1 0
2 2
1 0
2 1
1 0  
1 0
2 2 
2 1 
0 2
0 3

1 0
0 0 
2 1
1 0
3 1
4 0
1 0
3 0
0 1
0 3
1 0
3 0
2 1
2 3
0 1
1 1
2 2 
3 0
3 0
3 0 
3 0
1 1 
3 1
0 2
1 2
1 0
3 0
0 1
0 0 
1 0
3 7
4 1

0 0
3 0
3 0
1 3
1 4
1 3
1 2
1 0
2 1
1 0
0 1
4 0
3 0
0 1
2 0
3 0
0 1
0 1
2 2
1 0
0 1
0 2
0 1
3 1
0 2
3 1
2 3
0 1
1 0
1 1
0 3
1 2
1 1
1 2
4 0
4 1
1 0
2 1
1 2
1 1
4 0
2 3
0 0
1 2
1 1
2 1 
1 1
2 0
1 0
1 0
0 1
 1 1

1 1 
1 2
2 1
0 4 
2 0
3 2
1 1 
2 1 
2 2
2 3
3 0
0 1
1 2
0 0
1 1
3 1 
0 0 
0 0


1 0
2 1
2 2
0 2
0 0
0 0
2 1
1 1 
1 0
1 1
2 1
2 1
2 0
2 0
0 1
1 1
4 0
1 2
3 0
1 1
1 2
2 2
4 1
1 3
1 1
0 0
3 1
1 1 
1 1
1 0
2 0
1 5
1 2
2 0
0 1
0 1
1 0
5 0
0 2
2 1 
0 1
5 1
3 1
3 0
0 1
2 1
0 2 
4 0
2 1
0 1
1 1
0 2
2 4
0 3
0 0
0 1
0 0
4 2
0 4
1 3
4 4
 3 3
1 1
1 2
1 3
 0 0
2 1
2 0
0 1
0 2
 0 1
1 0
 0 0
1 0
0 0
 1 0
 2 1
2 2
2 0
2 3
2 0
1 3
0 0
1 0
3 2
1 1
2 1
5 1
 1 1
2 3
0 1
 4 0
4 1
1 0
1 0
4 1
0 1
0 1
0 0
0 0 
0 0 
0 2
1 0
1 1
1 0
2 0
1 1
2 1   
1 0  
2 0   
1 2  
0 1
3 0   
0 1
2 1
3 3
2 2
0 2
3 0
1 0
 0 1
2 0
2 0
 1 3
2 0
1 0
0 2
1 2
0 3
0 0
2 0
1 1
2 1
1 0
3 3
1 1
1 0
1 0
 4 2
2 2
0 4
3 0
1 0
0 3
2 0





;

run;
*/



data allscores;
  input  host guest;
  abs=abs(host-guest);
  hostwin=host-guest;
  cards;
1 4 
1 2
3 0
0 1
0 2
0 0 
0 0
1 1 
1 2 
4 3 
0 0 
1 0
3 1
1 0
7 0
2 3
4 0
2 1
6 0
3 0
1 0
2 2
1 0
2 1
1 0  
1 0
2 2 
2 1 
0 2
0 3

1 0
0 0 
2 1
1 0
3 1
4 0
1 0
3 0
0 1
0 3
1 0
3 0
2 1
2 3
0 1
1 1
2 2 
3 0
3 0
3 0 
3 0
1 1 
3 1
0 2
1 2
1 0
3 0
0 1
0 0 
1 0
3 7
4 1

0 0
3 0
3 0
1 3
1 4
1 3
1 2
1 0
2 1
1 0
0 1
4 0
3 0
0 1
2 0
3 0
0 1
0 1
2 2
1 0
0 1
0 2
0 1
3 1
0 2
3 1
2 3
0 1
1 0
1 1
0 3
1 2
1 1
1 2
4 0
4 1
1 0
2 1
1 2
1 1
4 0
2 3
0 0
1 2
1 1
2 1 
1 1
2 0
1 0
1 0
0 1
 1 1

1 1 
1 2
2 1
0 4 
2 0
3 2
1 1 
2 1 
2 2
2 3
3 0
0 1
1 2
0 0
1 1
3 1 
0 0 
0 0


1 0
2 1
2 2
0 2
0 0
0 0
2 1
1 1 
1 0
1 1
2 1
2 1
2 0
2 0
0 1
1 1
4 0
1 2
3 0
1 1
1 2
2 2
4 1
1 3
1 1
0 0
3 1
1 1 
1 1
1 0
2 0
1 5
1 2
2 0
0 1
0 1
1 0
5 0
0 2
2 1 
0 1
5 1
3 1
3 0
0 1
2 1
0 2 
4 0
2 1
0 1
1 1
0 2
2 4
0 3
0 0
0 1
0 0
4 2
0 4
1 3
4 4
 3 3
1 1
1 2
1 3
 0 0
2 1
2 0
0 1
0 2
 0 1
1 0
 0 0
1 0
0 0
 1 0
 2 1
2 2
2 0
2 3
2 0
1 3
0 0
1 0
3 2
1 1
2 1
5 1
 1 1
2 3
0 1
 4 0
4 1
1 0
1 0
4 1
0 1
0 1
0 0
0 0 
0 0 
0 2
1 0
1 1
1 0
2 0
1 1
2 1   
1 0  
2 0   
1 2  
0 1
3 0   
0 1
2 1
3 3
2 2
0 2
3 0
1 0
 0 1
2 0
2 0
 1 3
2 0
1 0
0 2
1 2
0 3
0 0
2 0
1 1
2 1
1 0
3 3
1 1
1 0
1 0
 4 2
2 2
0 4
3 0
1 0
0 3
2 0





;

run;