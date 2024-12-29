FUNCTION zfm_rfc_bw_ux_getallprm.
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
  DATA: lt_qparam TYPE ztt_bw_uxqparam1,
        ls_qparam TYPE zts_bw_uxqparam1.

  IF i_uname IS NOT INITIAL.
    AUTHORITY-CHECK OBJECT 'ZUXGRP' FOR USER i_uname
          ID 'GRPID' FIELD i_grpid
          ID 'ACTVT' FIELD '03'.
    IF sy-subrc NE 0.
*      e_status = '3'.
*      RETURN.
    ENDIF.
  ENDIF.

  SELECT SINGLE techname INTO @DATA(lv_query) FROM ztbw_ux_query
   WHERE id = @i_qid AND grpid = @i_grpid.

*  CONDENSE i_techname NO-GAPS.
*  IF i_techname IS INITIAL.
*    SELECT SINGLE techname INTO @DATA(lv_query) FROM ztbw_ux_query
*     WHERE id = @i_qid AND grpid = @i_grpid.
*    IF sy-subrc NE 0.
*      e_status = '9'.
*      RETURN.
*    ENDIF.
*    CONDENSE lv_query NO-GAPS.
*  ELSE.
*    SELECT SINGLE techname INTO @lv_query FROM ztbw_ux_query
*     WHERE id = @i_qid AND grpid = @i_grpid.
*    IF lv_query NE i_techname.
*      e_status = '6'. " техническое имя запроса не равно тому, что указано в настройке
*      RETURN.
*    ELSE.
*      lv_query = i_techname.
*    ENDIF.
*  ENDIF.

  SELECT @i_grpid AS grpid, @i_qid AS qid, t3~mapname AS paramname
       , 1 AS cnt, 'I' AS sign, 'EQ' AS opti, ' ' AS low, ' ' AS high
       , t5~txtlg AS paramdescr, t4~vartyp, t4~vproctp, t4~iobjnm
       , t4~vparsel, t4~varinput, t4~entrytp
    INTO TABLE @e_qparam "@DATA(lt_qvars)
    FROM
    rszeltdir AS t1 INNER JOIN rszeltxref AS t2 ON t1~eltuid = t2~seltuid
                    INNER JOIN rszeltdir AS t3 ON t2~teltuid = t3~eltuid
                    INNER JOIN rszglobv AS t4 ON t3~mapname = t4~vnam
                    INNER JOIN rszelttxt AS t5 ON t4~varuniid = t5~eltuid BYPASSING BUFFER
    WHERE t1~objvers = 'A'
      AND t1~deftp = 'REP'
      AND t2~objvers = 'A'
      AND t2~laytp IN ( 'VAR', 'QVR' )
      AND t3~objvers = 'A'
      AND t3~deftp = 'VAR'
      AND t4~objvers = 'A'
      AND t5~objvers = 'A'
      AND t5~langu = 'R'
      AND t1~mapname = @lv_query
    ORDER BY t2~posn.

*  SELECT v1~grpid, v1~qid, v1~paramname, v1~cnt, v1~sign, v1~opti, v1~low, v1~high
*        , t2~txtlg AS paramdescr, t1~vartyp, t1~vproctp, t1~iobjnm, t1~vparsel, t1~varinput, t1~entrytp
*    INTO TABLE @DATA(lt_qparam)
*    FROM ztbw_ux_qparam AS v1 INNER JOIN rszglobv AS t1 ON v1~paramname = t1~vnam
*                              INNER JOIN rszelttxt AS t2 ON t1~varuniid = t2~eltuid BYPASSING BUFFER
*   WHERE v1~grpid = @i_grpid
*     AND v1~qid = @i_qid
*     AND t1~objvers = 'A'
*     AND t2~objvers = 'A'
*     AND t2~langu = 'R'
*   ORDER BY v1~paramname, cnt.

  IF lines( e_qparam ) = 0.
    e_status = '8'.
    RETURN.
  ENDIF.

  ls_qparam-grpid = i_grpid.
  ls_qparam-qid = i_qid.
  ls_qparam-cnt = 1.
  ls_qparam-sign = 'I'.
  LOOP AT e_qparam ASSIGNING FIELD-SYMBOL(<fs>).
    IF <fs>-vparsel = 'I'.
      <fs>-opti = 'BT'.
    ELSE.
      <fs>-opti = 'EQ'.
    ENDIF.
    <fs>-low = ''.
    <fs>-high = ''.
  ENDLOOP.
  e_status = '0'.

ENDFUNCTION.