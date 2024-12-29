FUNCTION ZFM_RFC_BW_UX_CRONGET.##RFC_PERFORMANCE_OK
*"--------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_LEVEL) TYPE  CHAR1 DEFAULT 'G'
*"  EXPORTING
*"     VALUE(E_RESULT) TYPE  ZTT_BW_UXV0002
*"     VALUE(E_STATUS) TYPE  CHAR1
*"--------------------------------------------------------------------
*  DATA: lr_grpid TYPE RANGE OF ztbw_ux_qgrp-id,
*        lr_qid   TYPE RANGE OF ztbw_ux_query-id.
*
*  IF i_grp IS NOT INITIAL.
*    APPEND VALUE #( sign = 'I' option = 'EQ' low = i_grp ) TO lr_grpid.
*    IF i_qid IS NOT INITIAL.
*      APPEND VALUE #( sign = 'I' option = 'EQ' low = i_qid ) TO lr_qid.
*    ENDIF.
*  ENDIF.
*
*  SELECT v1~grpid, v1~name, v1~folder, v1~filesuffix, v1~qid,
*    v1~techname, v1~wspyclass, v1~grppyclass, v1~fname, v1~frmt, v1~wsname, t2~txtlg AS qtxtlg, v1~description
*    INTO CORRESPONDING FIELDS OF TABLE @e_result
*    FROM zv_bw_ux_v0001 AS v1 INNER JOIN rszeltdir AS t1 ON v1~techname = t1~mapname
*                              INNER JOIN rszelttxt AS t2 ON t1~eltuid = t2~eltuid
*   WHERE v1~grpid IN @lr_grpid
*     AND v1~qid IN @lr_qid
*     AND t1~objvers = 'A'
*     AND t1~deftp = 'REP'
*     AND t2~langu = 'R'
*     AND t2~objvers = 'A'
*   ORDER BY v1~grpid, v1~qid.
*
*  IF i_uname IS NOT INITIAL.
*    LOOP AT e_result ASSIGNING FIELD-SYMBOL(<fs>).
*      AUTHORITY-CHECK OBJECT 'ZUXGRP' FOR USER i_uname
*            ID 'UXGRPID' FIELD <fs>-grpid
*            ID 'ACTVT' FIELD '03'.
*      IF sy-subrc NE 0.
**        DELETE e_result INDEX sy-tabix.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*
*  IF lines( e_result ) > 0.
*    e_status = '0'.
*  ELSE.
*    e_status = '1'.
*  ENDIF.

  IF i_level = 'G'.
    SELECT t1~id AS grpid, t2~qid AS qid, t2~low AS cron, t2~high as runtime
      INTO CORRESPONDING FIELDS OF TABLE @e_result
      FROM ztbw_ux_qgrp AS t1 INNER JOIN ztbw_ux_qparam AS t2 ON t1~id = t2~grpid
     WHERE t2~paramname = '_WBCRON'
       AND t2~cnt = 1
       AND t2~qid = '0000000000'.
    e_status = '0'.
  ELSEIF i_level = 'Q'.
    SELECT t1~grpid AS grpid, t1~id AS qid, t2~low AS cron, t2~high as runtime
      INTO CORRESPONDING FIELDS OF TABLE @e_result
      FROM ztbw_ux_query AS t1 INNER JOIN ztbw_ux_qparam AS t2 ON t1~grpid = t2~grpid AND t1~id = t2~qid
     WHERE t2~paramname = '_WSCRON'
       AND t2~cnt = 1.
    e_status = '0'.
  ELSE.
    e_status = '1'.
  ENDIF.
ENDFUNCTION.