     h DFTACTGRP(*NO)
      *
      * Display file declaration
     fstuacinf  cf   e             workstn indds(dspf)

      * Database file declaration
     fstuinfo   uf a e             disk
     fstuclsinfouf a e             disk    prefix(cls)

      * Indicator Communication Area data structure.
     d dSPF            ds                  qualified
     d exit                    3      3N
     d refresh                 5      5N
     d add                     6      6N
     d cancel                 12     12N
     d valfld1                31     31N
     d valfld2                32     32N
     d valfld3                33     33N
     d valfld4                34     34N

      * File Information data structure
     d fIDS            ds
     d CurSflRec             378    379I 0

      * Program status data structure
     d pSDS           sds                  qualified
     d pgmName           *proc

      * Constant declaration
     dmaxsfl           c                   9999
      *==========================================================================
      * Procedure Declaration
      *==========================================================================
      * Add Student Record
     d addStuRec       pr

      * Clear display records
     d clearDspf       pr

      * Set Indicator to *OFF
     d setInd          pr

      * Validate student Record
     d valStuRec       pr
      *==========================================================================
      * Main routine
      *==========================================================================
      /free

       // Initialize Indicator
          d_PGM = %trim(pSDS.pgmName);

          Dow dspf.exit = *Off and dspf.cancel = *off;

             // Set Indicator to *Off
             setInd();

             // Display Add information screen
             exfmt stuadd;

             // Validate a record
             valStuRec();

             // Refresh screen
             if dspf.refresh = *On;
                cleardspf();
             endif;

             // Call to add student record
             if dspf.add = *on;

              // Confimation Window Promt
                 dow dspf.cancel = *off;

                    exfmt CnfPromt;

                    if D_CNFFLG = 'Y';
                      addStuRec();
                      leave;
                    endif;

                    if dspf.cancel = *On or D_CNFFLG = 'N';
                       dspf.cancel = *off;
                       leave;
                    endif;

                 enddo;

              endif;

          Enddo;

       *Inlr = *on;
       //***************************************************************
       // Procedure definition Add Student Record
       //***************************************************************
       dcl-proc addStuRec;

          // Wrire record in STUINFO.
          STUID   = D_STUID;
          STUNM   = D_STUNM;
          STUGEN  = D_STUGEN;
          STUDOB  = D_STUDOB;
          STUCITY = D_STUCITY;
          write stuinforf;

          // Write record in STUCLSINFO.
          clsSTUID  = D_STUID;
          clsSTUNM  = D_STUNM;
          clsSTUCLS = D_STUCLS;
          write stuclsrf;

          // Clear Display file fields
          clearDspf();

       end-proc;
       //***************************************************************
       // Procedure definition to set indicator *Off.
       //***************************************************************
       dcl-proc setInd;

          // Clear indicator
             dspf.add = *off;
             dspf.refresh = *off;
       end-proc;

       //***************************************************************
       // Procedure definition Clear DSPF fields
       //***************************************************************
       dcl-proc clearDspf;

          // Clear record format
             clear stuadd;
       end-proc;

       //***************************************************************
       // Procedure definition Validate Student Record
       //***************************************************************
       dcl-proc valStuRec;

          dspf.valfld1  = *Off;
          dspf.valfld2  = *Off;
          dspf.valfld3  = *Off;
          dspf.valfld4  = *Off;

            if D_Stuid = *Zero;
               dspf.valfld1 =  *On;
             endif;

            if D_StuNm = *Blanks;
               dspf.valfld2 =  *On;
             endif;


            if D_StuDOB = *Zero;
               dspf.valfld3 =  *On;
             endif;

            if D_StuCity = *Blanks;
               dspf.valfld4 =  *On;
             endif;


       end-proc;
