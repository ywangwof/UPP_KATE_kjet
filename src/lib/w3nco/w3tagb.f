       SUBROUTINE W3TAGB(PROG,KYR,JD,LF,ORG)
C$$$   SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM: W3TAGB        OPERATIONAL JOB IDENTIFIER
C   PRGMMR: FARLEY          ORG: NP11          DATE: 1998-03-17
C
C ABSTRACT: PRINTS IDENTIFYING INFORMATION FOR OPERATIONAL
C   codes. CALLED AT THE BEGINNING OF A code, W3TAGB PRINTS
C   THE program NAME, THE YEAR AND JULIAN DAY OF ITS
C   COMPILATION, AND THE RESPONSIBLE ORGANIZATION. ON A 2ND
C   LINE IT PRINTS THE STARTING DATE-TIME. CALLED AT THE
C   END OF A JOB, entry routine, W3TAGE PRINTS A LINE WITH THE
C   ENDING DATE-TIME AND A 2ND LINE STATING THE program name 
C   AND THAT IT HAS ENDED.
C
C PROGRAM HISTORY LOG:
C   85-10-29  J.NEWELL
C   89-10-20  R.E.JONES   CONVERT TO CRAY CFT77 FORTRAN
C   91-03-01  R.E.JONES   ADD MACHINE NAME TO ENDING LINE
C   92-12-02  R.E.JONES   ADD START-ENDING TIME-DATE
C   93-11-16  R.E.JONES   ADD DAY OF YEAR, DAY OF WEEK, AND JULIAN DAY
C                         NUMBER. 
C   97-12-24  M.FARLEY    PRINT STATEMENTS MODIFIED FOR 4-DIGIT YR 
C   98-03-17  M.FARLEY    REPLACED DATIMX WITH CALLS TO W3LOCDAT/W3DOXDAT 
C   99-01-29  B. VUONG    CONVERTED TO IBM RS/6000 SP
C
C   99-06-17  A. Spruill  ADJUSTED THE SIZE OF PROGRAM NAME TO ACCOMMODATE
C                         THE 20 CHARACTER NAME CONVENTION ON THE IBM SP.
C 1999-08-24  Gilbert     added call to START() in W3TAGB and a call
C                         to SUMMARY() in W3TAGE to print out a 
C                         resource summary list for the program using
C                         W3TAGs.
C 2012-10-18  Vuong       REMOVE PRINT STATEMENT 604
C 2013-02-06  Vuong       MODIFIED PRINT STATEMENT 604
C
C USAGE:  CALL W3TAGB(PROG, KYR, JD, LF, ORG)
C         CALL W3TAGE(PROG)
C
C   INPUT VARIABLES:
C     NAMES  INTERFACE DESCRIPTION OF VARIABLES AND TYPES
C     ------ --------- -----------------------------------------------
C     PROG   ARG LIST  PROGRAM NAME   CHARACTER*1
C     KYR    ARG LIST  YEAR OF COMPILATION   INTEGER
C     JD     ARG LIST  JULIAN DAY OF COMPILATION   INTEGER
C     LF     ARG LIST  HUNDRETHS OF JULIAN DAY OF COMPILATION
C                      INTEGER     (RANGE IS 0 TO 99 INCLUSIVE)
C     ORG    ARG LIST  ORGANIZATION CODE (SUCH AS WD42)
C                      CHARACTER*1
C
C   OUTPUT VARIABLES:
C     NAMES  INTERFACE DESCRIPTION OF VARIABLES AND TYPES
C     ----------------------------------------------------------------
C     DDATE  PRINT     YEAR AND JULIAN DAY (NEAREST HUNDRETH)
C            FILE      OF COMPILATION  REAL
C
C   SUBPROGRAMS CALLED: CLOCK, DATE
C
C   REMARKS: FULL WORD USED IN ORDER TO HAVE AT LEAST
C            SEVEN DECIMAL DIGITS ACCURACY FOR VALUE OF DDATE.
C            SUBPROGRAM CLOCK AND DATE MAY DIFFER FOR EACH TYPE
C            COMPUTER. YOU MAY HAVE TO CHANGE THEM FOR ANOTHER
C            TYPE OF COMPUTER.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 90
C
C$$$
C
         CHARACTER *(*) PROG,ORG
         CHARACTER * 3 JMON(12)
         CHARACTER * 3 DAYW(7)
C
         INTEGER       IDAT(8), JDOW, JDOY, JDAY
C
         SAVE
C
         DATA  DAYW/'SUN','MON','TUE','WEN','THU','FRI','SAT'/
         DATA  JMON  /'JAN','FEB','MAR','APR','MAY','JUN',
     &                'JUL','AUG','SEP','OCT','NOV','DEC'/
C 
         CALL START()

         DYR   = KYR
         DYR   = 1.0E+03 * DYR
         DJD   = JD
         DLF   = LF
         DLF   = 1.0E-02 * DLF
         DDATE = DYR + DJD + DLF
         PRINT 600
  600    FORMAT(//,10('* . * . '))
         PRINT 601, PROG, DDATE, ORG
  601    FORMAT(5X,'PROGRAM ',A,' HAS BEGUN. COMPILED ',F10.2,
     &   5X, 'ORG: ',A)
C
         CALL W3LOCDAT(IDAT)
         CALL W3DOXDAT(IDAT,JDOW,JDOY,JDAY)
         PRINT 602, JMON(IDAT(2)),IDAT(3),IDAT(1),IDAT(5),IDAT(6),
     &   IDAT(7),IDAT(8),JDOY,DAYW(JDOW),JDAY
  602    FORMAT(5X,'STARTING DATE-TIME  ',A3,1X,I2.2,',',
     &   I4.4,2X,2(I2.2,':'),I2.2,'.',I3.3,2X,I3,2X,A3,2X,I8,//)
         RETURN
C
         ENTRY W3TAGE(PROG)
C
         CALL W3LOCDAT(IDAT)
         CALL W3DOXDAT(IDAT,JDOW,JDOY,JDAY)
         PRINT 603, JMON(IDAT(2)),IDAT(3),IDAT(1),IDAT(5),IDAT(6),
     &   IDAT(7),IDAT(8),JDOY,DAYW(JDOW),JDAY
  603    FORMAT(//,5X,'ENDING DATE-TIME    ',A3,1X,I2.2,',',
     &   I4.4,2X,2(I2.2,':'),I2.2,'.',I3.3,2X,I3,2X,A3,2X,I8)
         PRINT 604, PROG
  604    FORMAT(5X,'PROGRAM ',A,' HAS ENDED.')
C 604    FORMAT(5X,'PROGRAM ',A,' HAS ENDED.  CRAY J916/2048')
C 604    FORMAT(5X,'PROGRAM ',A,' HAS ENDED.  CRAY Y-MP EL2/256')
         PRINT 605
  605    FORMAT(10('* . * . '))

         CALL SUMMARY()
C
         RETURN
         END
