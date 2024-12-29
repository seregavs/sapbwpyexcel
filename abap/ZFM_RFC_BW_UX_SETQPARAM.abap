FUNCTION zfm_rfc_bw_ux_setqparam.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_GRPID) TYPE  ZE_BW_UXGRPID
*"     VALUE(I_QID) TYPE  ZE_BW_UXQRID
*"     VALUE(I_UNAME) TYPE  XUBNAME OPTIONAL
*"     VALUE(I_QPARAM) TYPE  ZTT_BW_UXQPARAM1
*"  EXPORTING
*"     VALUE(E_STATUS) TYPE  CHAR1
*"     VALUE(E_ROWUPD) TYPE  INT2
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

* временно закомментированоа потому что отладки
  IF i_qparam IS NOT INITIAL.
    DELETE FROM ztbw_ux_qparam
     WHERE grpid = i_grpid AND qid = i_qid
       AND NOT ( paramname LIKE '/_%' ESCAPE '/' ). " сохраняем параметры, которые не редактируются в web
*    LOOP AT i_qparam ASSIGNING FIELD-SYMBOL(<fs>).
*      <fs>-qid = 7.
*    ENDLOOP.
    INSERT ztbw_ux_qparam FROM TABLE i_qparam.
    IF sy-subrc = 0.
      e_status = '0'.
      e_rowupd = lines( i_qparam ).
    ELSE.
      e_status = '2'.
    ENDIF.
  ELSE.
    e_status = '1'.
  ENDIF.

ENDFUNCTION.