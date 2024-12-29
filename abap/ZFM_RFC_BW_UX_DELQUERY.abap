FUNCTION zfm_rfc_bw_ux_delquery.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_GRPID) TYPE  ZE_BW_UXGRPID
*"     VALUE(I_QID) TYPE  ZE_BW_UXQRID
*"     VALUE(I_UNAME) TYPE  XUBNAME OPTIONAL
*"  EXPORTING
*"     VALUE(E_STATUS) TYPE  CHAR1
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
  DELETE FROM ztbw_ux_qparam WHERE grpid = i_grpid AND qid =  i_qid.
  DELETE FROM ztbw_ux_query WHERE grpid = i_grpid AND id = i_qid.
  SELECT id FROM ztbw_ux_query INTO TABLE @DATA(lt_query)
    WHERE grpid = @i_grpid.
  IF lines( lt_query ) = 0. " удаляем группу, т.к. последний отчет группы удален
    DELETE FROM ztbw_ux_qgrp WHERE id = @i_grpid.
  ENDIF.

  e_status = '0'.

ENDFUNCTION.