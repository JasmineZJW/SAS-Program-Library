/******************************************************************
This macro 

Before start, make sure you have difined below information in SETUP.sas.
  %os_fvars(mvar=_path,     projpath=&type.);
  %os_fvars(mvar=_utility,  projpath=macros:utility);
  LIBNAME UTILITY     "&_utility"  COMPRESS=yes;

Author: Catlin Wei
*******************************************************************/
    
%MACRO Utility( TYPE    = all
                ,OUT     = TF
                ,AUTHOR  = all
                ,DTAPATH = C:\projects\218184
                ,TFFILE  = 218184_titlefootnote.xls
                ,TRACKER = 218184 csr statistical programming status tracker.xls
                ,WHERE   = %str(E='1st DBL' & F=' ')
                ,CHECKNM = 
				,DEBUG   = N
                );
 %******************************************************************************;
 %* AUTHOR: Catlin Wei ;
 %* ;
 %* PURPOSE: Load title/footnote, create DTA_DATA, and create MULTIRUN file ;
 %* ;
 %* VERSION: 0.1
 %******************************************************************************;
 %* ;
 %* PROGRAM NAME: utility.sas ;
 %* ;
 %* PROGRAM LOCATION: \\cn-sha-hfp001\VOL5\Groups\STATISTICAL PROGRAMMING\DeptShare\21_Janssen\03_Macros for Janssen Standard TLFs ;
 %* ;
 %******************************************************************************;
 %* ;
 %* USER REQUIREMENTS: 
 %*  1. Make sure you have a UTILITY.TF generated by %utility;
 %* ;
 %* OUT (Required);
 %*  identify the output;
 %* ;
 %* ;
 %* PROGRAMS CALLED: ;
 %* ;
 %******************************************************************************;
 %* ;
 %* MODIFICATION HISTORY ;
 %*-----------------------------------------------------------------------------;
 %* VERSION: 0.1 ;
 %* AUTHOR: Catlin Wei;
 %* ;
 %*-----------------------------------------------------------------------------;
 %******************************************************************************;

    %LOCAL MPRINT MLOGIC ;
    %LET MPRINT=%sysfunc(getoption(MPRINT));
    %LET MLOGIC=%sysfunc(getoption(MLOGIC));

    %IF %upcase(&DEBUG)=Y %THEN OPTIONS MPRINT MLOGIC;
                          %ELSE OPTIONS NOMPRINT NOMLOGIC;;

    %GLOBAL _ERR%str(OR);
    %LOCAL SIDE B__ C__ G__ J__ K__ M__ AUTHOR__;

    %IF %upcase(&OUT)=TF %THEN %DO;

        PROC IMPORT OUT= TF
                    DATAFILE= "&_UTILITY.&TFFILE"
                    DBMS=XLS REPLACE
                    ;
            SHEET="TitleFootnote";
            GETNAMES=YES;
        RUN;

        DATA UTILITY.TF;
            LENGTH TYPE TABLE_ $50;
            RETAIN TABLE_ ' ';
            SET TF;

            TABLE=strip(TABLE);
            TitleTxT=compbl(TitleTxT);
            IF missing(TitleTXT) then delete;

            IF HDFT='T' & TABLE^=' ' THEN TABLE_=TABLE;
            TABLE=TABLE_;

                 IF upcase(substr(TABLE,1,1))='T' THEN TYPE='Table';
            ELSE IF upcase(substr(TABLE,1,1))='L' THEN TYPE='Listing';
            ELSE IF upcase(substr(TABLE,1,1)) in ('G' 'F') THEN TYPE='Figure';

            DROP TABLE_;
        RUN;

        DATA UTILITY.TF;
            SET UTILITY.TF;
            RETAIN ORDER;
            BY TABLE NOTSORTED;
            IF FIRST.TABLE THEN ORDER+1;
            KEEP TYPE TABLE HDFT TITLETXT POPULATION ORDER;
        RUN;

    %END;
    %ELSE %IF %upcase(&OUT)=DTA %THEN %DO;

        PROC IMPORT DATAFILE="&_UTILITY.&TRACKER"
                    OUT=INMUL_
                    DBMS=XLS
                    REPLACE;
                    DATAROW=6;
                    DBSASLABEL=COMPAT;
                    GETNAMES=NO;
                    MIXED=YES;
        RUN;

        PROC TRANSPOSE DATA=INMUL_(OBS=1) OUT=INMUL__;
            VAR _ALL_;
        RUN;

        DATA _NULL_;
            SET INMUL__;

                 IF compbl(COL1)="Output Identifier" THEN CALL SYMPUT("B__",strip(_LABEL_));
            ELSE IF compbl(COL1)="Title" THEN CALL SYMPUT("C__",strip(_LABEL_));

        RUN;
    
        DATA DTA;
            LENGTH COL1-COL7 $600 ID $20;
            ORDER=_N_;
            SET INMUL_;
            WHERE first(upcase(strip(&B__))) in ("T" "L" "F" "G") %IF %length(&where) %THEN & &WHERE;;
            ID=upcase(strip(&B__));
            COL1=strip(&B__)||'.rtf';
            COL2="&DTAPATH";

                 IF upcase(first(strip(&B__)))="T" THEN COL3="Tables";
            ELSE IF upcase(first(strip(&B__)))="L" THEN COL3="Listings"; 
            ELSE IF upcase(first(strip(&B__))) in ("F" "G") THEN COL3="Figures"; 

            COL4=strip(&B__);
            COL5=' ';
            COL6=strip(&C__);
            COL7=' ';
            COL8=' ';
            COL9=' ';
            COL10=' ';
            COL11=' ';
            COL12=' ';
            COL13=' ';
            COL14=' ';
            COL15=' ';

            KEEP ORDER ID COL:;
        RUN;

        PROC TRANSPOSE DATA=DTA OUT=UTILITY.DTA(DROP=_NAME_);
            VAR COL:;
            BY ORDER ID;
        RUN;

        DATA _NULL_;
            SET UTILITY.DTA;

                  %IF %upcase(&TYPE)=TLF | %upcase(&TYPE)=ALL %THEN WHERE FIRST(ID) in ('T' 'L' 'G' 'F');
            %ELSE %IF %upcase(&TYPE)=TABLE | %upcase(&TYPE)=T %THEN WHERE FIRST(ID)='T'; 
            %ELSE %IF %upcase(&TYPE)=LISITNG | %upcase(&TYPE)=L %THEN WHERE FIRST(ID)='L'; 
            %ELSE %IF %upcase(&TYPE)=FIGURE | %upcase(&TYPE)=F %THEN WHERE FIRST(ID) in ('G' 'F');; 

            FILE "&_path.dta_%lowcase(&TYPE).txt" NOPAD FLOWOVER OLD;
            PUT COL1;
        RUN;

    %END;
    %ELSE %IF %upcase(&OUT)=MULTIRUN %THEN %DO;

        PROC IMPORT DATAFILE="&_UTILITY.&TRACKER"
                    OUT=INMUL_
                    DBMS=XLS
                    REPLACE;
                    DATAROW=6;
                    DBSASLABEL=COMPAT;
                    GETNAMES=NO;
                    MIXED=YES;
        RUN;

        PROC TRANSPOSE DATA=INMUL_(OBS=1) OUT=INMUL__;
            VAR _ALL_;
        RUN;

        DATA _NULL_;
            SET INMUL__;

                 IF compbl(COL1)="Output Identifier" THEN CALL SYMPUT("B__",strip(_LABEL_));
            ELSE IF index(COL1,"Main Program Name") THEN CALL SYMPUT("G__",strip(_LABEL_));
            ELSE IF compbl(COL1)="Statistical Main Programmer(s)" THEN CALL SYMPUT("J__",strip(_LABEL_)); 
            ELSE IF index(COL1,"QC Program Name") THEN CALL SYMPUT("K__",strip(_LABEL_));
            ELSE IF index(COL1,"QC Statistical Programmer(s)") THEN CALL SYMPUT("M__",strip(_LABEL_)); 

        RUN;

        DATA MULTIRUN(KEEP=ID PAUTHOR QCAUTHOR PROGNAME QCNAME PROGPH QCPH)
             UTILITY.TRACKER;
            LENGTH ID PAUTHOR QCAUTHOR PROGNAME QCNAME $20 PROGPH QCPH $200;
            SET INMUL_;
            WHERE &B__^=' ' %IF %length(&where) %THEN & &WHERE;;
            ID=UPCASE(STRIP(&B__));
            PROGNAME=LOWCASE(STRIP(SCAN(&G__,1,'.')));
            PAUTHOR=STRIP(&J__);
            QCNAME=LOWCASE(STRIP(SCAN(&K__,1,'.')));
            QCAUTHOR=STRIP(&M__);

            IF FIRST(ID)='A' THEN DO;
                PROGPH=CATS("&_panal",PROGNAME,".sas");
                QCPH=CATS("&_qanal",QCNAME,".sas");
            END;
            ELSE IF FIRST(ID)='T' THEN DO;
                PROGPH=CATS("&_ptab",PROGNAME,".sas");
                QCPH=CATS("&_qtab",QCNAME,".sas");
            END;
            ELSE IF FIRST(ID)='L' THEN DO;
                PROGPH=CATS("&_plis",PROGNAME,".sas");
                QCPH=CATS("&_qlis",QCNAME,".sas");
            END;
            ELSE IF FIRST(ID)='G' THEN DO;
                PROGPH=CATS("&_pfig",PROGNAME,".sas");
                QCPH=CATS("&_qfig",QCNAME,".sas");
            END;
        RUN;
    
        DATA UTILITY.MULTIRUN;
            LENGTH SIDE $20;
            SET MULTIRUN(KEEP=ID PAUTHOR PROGPH PROGNAME RENAME=(PAUTHOR=AUTHOR PROGPH=PROGPATH PROGNAME=PROGRAM) IN=A FIRSTOBS=2)
                MULTIRUN(KEEP=ID QCAUTHOR QCPH QCNAME RENAME=(QCAUTHOR=AUTHOR QCPH=PROGPATH QCNAME=PROGRAM) IN=B FIRSTOBS=2);

            ORDER=_N_;
            IF A THEN SIDE="PRODUCTION";ELSE SIDE="QC";
        RUN;

        PROC SORT DATA=UTILITY.MULTIRUN OUT=MULTIRUN NODUPKEY;BY AUTHOR PROGPATH;RUN;
        PROC SORT DATA=MULTIRUN;BY ORDER;RUN;

        DATA _NULL_;
            SET MULTIRUN;
            WHERE PROGRAM^=' ';

                  %IF %upcase(&TYPE)=AD %THEN IF FIRST(ID)='A';
            %ELSE %IF %upcase(&TYPE)=TLF %THEN IF FIRST(ID) in ('T' 'L' 'F' 'G');; 

            %IF %upcase(&AUTHOR)^=ALL & %upcase(&AUTHOR)^=%str( ) %THEN %DO;
                IF INDEX(UPCASE(AUTHOR),"%upcase(&AUTHOR)");
                %LET AUTHOR__=_%lowcase(&AUTHOR);
            %END;
            %ELSE %LET AUTHOR__=;

            FILE "&_path.multirun_%lowcase(&TYPE)&AUTHOR__..txt" NOPAD FLOWOVER OLD;
            PUT PROGPATH;
        RUN;

    %END;

    %IF %LENGTH(&CHECKNM) & %SYSFUNC(EXIST(UTILITY.TRACKER)) %THEN %DO;

        PROC SQL;
            CREATE TABLE ADTLF AS
                SELECT index(LIBNAME,'QC') as ORDER,LIBNAME,MEMNAME FROM DICTIONARY.TABLES
                    WHERE LIBNAME in ('ANALYSIS' 'FIGURES' 'LISTINGS' 'TABLES' 'QCANAL' 'QCFIG' 'QCLIS' 'QCTAB')
                        ORDER BY ORDER,MEMNAME;
        QUIT;

        DATA TRACKER;
            LENGTH MEMNAME $32;
            SET UTILITY.TRACKER;
            MEMNAME=upcase(ID);
            ORDER=0;OUTPUT;
            ORDER=1;OUTPUT;
        RUN;
        PROC SORT;BY ORDER MEMNAME;RUN;

        DATA CKADTLF;
            LENGTH CHECK1 CHECK2 $100;
            MERGE ADTLF(IN=A1) TRACKER(IN=B1);
            BY ORDER MEMNAME;

            IF A1 AND not B1 THEN CHECK1=cats(LIBNAME,'.','ID');
            IF B1 AND not A1 THEN CHECK2=cats(LIBNAME,'.','ID');

        RUN;

        PROC SQL;
            SELECT strip(CHECK1),strip(CHECK2) into :CHECK1 SEPARATED BY ' ',:CHECK2 SEPARATED BY ' '
                 FROM CKADTLF;
        QUIT;

        %PUT &CHECK1 &CHECK2;


    %END;

    PROC DATASETS LIBRARY=WORK NOWARN NOLIST;
        DELETE DTA TF;
    QUIT;

    %IF %LENGTH(&_ERROR) %THEN %PUT &_ERROR;
    OPTIONS &MPRINT &MLOGIC;
%MEND;
