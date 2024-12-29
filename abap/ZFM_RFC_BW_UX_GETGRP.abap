FUNCTION zfm_rfc_bw_ux_getgrp.##RFC_PERFORMANCE_OK
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_GRP) TYPE  ZE_BW_UXGRPID OPTIONAL
*"     VALUE(I_UNAME) TYPE  XUBNAME OPTIONAL
*"     VALUE(I_QID) TYPE  ZE_BW_UXQRID OPTIONAL
*"  EXPORTING
*"     VALUE(E_RESULT) TYPE  ZTT_BW_UXV0001
*"     VALUE(E_STATUS) TYPE  CHAR1
*"----------------------------------------------------------------------
  DATA: lr_grpid TYPE RANGE OF ztbw_ux_qgrp-id,
        lr_qid   TYPE RANGE OF ztbw_ux_query-id.

  IF i_grp IS NOT INITIAL.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = i_grp ) TO lr_grpid.
    IF i_qid IS NOT INITIAL.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = i_qid ) TO lr_qid.
    ENDIF.
  ENDIF.

  SELECT v1~grpid, v1~name, v1~folder, v1~filesuffix, v1~qid,
    v1~techname, v1~wspyclass, v1~grppyclass, v1~fname, v1~frmt, v1~wsname, t2~txtlg AS qtxtlg, v1~description
    INTO CORRESPONDING FIELDS OF TABLE @e_result
    FROM zv_bw_ux_v0001 AS v1 INNER JOIN rszeltdir AS t1 ON v1~techname = t1~mapname
                              INNER JOIN rszelttxt AS t2 ON t1~eltuid = t2~eltuid
   WHERE v1~grpid IN @lr_grpid
     AND v1~qid IN @lr_qid
     AND t1~objvers = 'A'
     AND t1~deftp = 'REP'
     AND t2~langu = 'R'
     AND t2~objvers = 'A'
   ORDER BY v1~grpid, v1~qid.

  IF i_uname IS NOT INITIAL.
    LOOP AT e_result ASSIGNING FIELD-SYMBOL(<fs>).
      AUTHORITY-CHECK OBJECT 'ZUXGRP' FOR USER i_uname
            ID 'UXGRPID' FIELD <fs>-grpid
            ID 'ACTVT' FIELD '03'.
      IF sy-subrc NE 0.
*        DELETE e_result INDEX sy-tabix.
      ENDIF.
    ENDLOOP.
  ENDIF.

  SELECT grpid, qid, paramname, low FROM ztbw_ux_qparam
    INTO TABLE @DATA(lt_cron)
    WHERE cnt = 1
      AND paramname IN ('_WBCRON','_WSCRON').
  LOOP AT e_result ASSIGNING FIELD-SYMBOL(<fs2>).
    READ TABLE lt_cron ASSIGNING FIELD-SYMBOL(<fs3>)
     WITH KEY grpid = <fs2>-grpid qid = <fs2>-qid.
    IF sy-subrc = 0.
      <fs2>-cron = <fs3>-low.
    ELSE.
      READ TABLE lt_cron ASSIGNING <fs3>
      WITH KEY grpid = <fs2>-grpid qid = '0000000000'.
      IF sy-subrc = 0.
        <fs2>-cron = <fs3>-low.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF lines( e_result ) > 0.
    e_status = '0'.
  ELSE.
    e_status = '1'.
  ENDIF.

ENDFUNCTION.