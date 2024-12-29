FUNCTION ZFM_RFC_BW_UX_GETQPARAM.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_GRPID) TYPE  ZE_BW_UXGRPID
*"     VALUE(I_QID) TYPE  ZE_BW_UXQRID
*"     VALUE(I_UNAME) TYPE  XUBNAME OPTIONAL
*"  EXPORTING
*"     VALUE(E_STATUS) TYPE  CHAR1
*"     VALUE(E_QPARAM) TYPE  ZTT_BW_UXQPARAM
*"----------------------------------------------------------------------
  " проверка полномочий на запуск
  "  tbd (если есть право на группу у текущего пользователя), то ОК)
  IF i_uname IS NOT INITIAL.
    AUTHORITY-CHECK OBJECT 'ZUXGRP' FOR USER i_uname
          ID 'GRPID' FIELD i_grpid
          ID 'ACTVT' FIELD '03'.
    IF sy-subrc NE 0.
*      e_status = '3'.
*      RETURN.
    ENDIF.
  ENDIF.

  SELECT v1~grpid, v1~qid, v1~paramname, v1~cnt, v1~sign, v1~opti, v1~low, v1~high
        , t2~txtlg AS paramdescr, t1~vartyp, t1~vproctp, t1~iobjnm, t1~vparsel, t1~varinput, t1~entrytp
    INTO TABLE @DATA(lt_qparam)
    FROM ztbw_ux_qparam AS v1 INNER JOIN rszglobv AS t1 ON v1~paramname = t1~vnam
                              INNER JOIN rszelttxt AS t2 ON t1~varuniid = t2~eltuid BYPASSING BUFFER
   WHERE v1~grpid = @i_grpid
     AND v1~qid = @i_qid
     AND t1~objvers = 'A'
     AND t2~objvers = 'A'
     AND t2~langu = 'R'
   ORDER BY v1~paramname, cnt.

  SELECT v1~grpid, v1~qid, v1~paramname, v1~cnt, v1~sign, v1~opti, v1~low, v1~high
    APPENDING CORRESPONDING FIELDS OF TABLE @lt_qparam
    FROM ztbw_ux_qparam AS v1 BYPASSING BUFFER
   WHERE v1~grpid = @i_grpid
     AND v1~qid = @i_qid
     AND v1~paramname LIKE '/_%' ESCAPE '/'
   ORDER BY v1~paramname, cnt.

  e_qparam[] =  lt_qparam[].
  e_status = '0'.

ENDFUNCTION.