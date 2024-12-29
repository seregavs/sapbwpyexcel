FUNCTION zfm_rfc_bw_ux_initqparam.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_GRPID) TYPE  ZE_BW_UXGRPID
*"     VALUE(I_QID) TYPE  ZE_BW_UXQRID
*"     VALUE(I_TECHNAME) TYPE  RSZCOMPID OPTIONAL
*"     VALUE(I_MODE) TYPE  CHAR1
*"  EXPORTING
*"     VALUE(E_STATUS) TYPE  CHAR1
*"     VALUE(E_ROWUPD) TYPE  INT2
*"----------------------------------------------------------------------
  DATA: lt_qparam TYPE ztt_bw_uxqparam1,
        ls_qparam TYPE zts_bw_uxqparam1.

  CONDENSE i_techname NO-GAPS.
  IF i_techname IS INITIAL.
    SELECT SINGLE techname INTO @DATA(lv_query) FROM ztbw_ux_query
     WHERE id = @i_qid AND grpid = @i_grpid.
    IF sy-subrc NE 0.
      e_status = '9'.
      RETURN.
    ENDIF.
    CONDENSE lv_query NO-GAPS.
  ELSE.
    SELECT SINGLE techname INTO @lv_query FROM ztbw_ux_query
     WHERE id = @i_qid AND grpid = @i_grpid.
    IF lv_query NE i_techname.
      e_status = '6'. " техническое имя запроса не равно тому, что указано в настройке
      RETURN.
    ELSE.
      lv_query = i_techname.
    ENDIF.
  ENDIF.

  SELECT t3~mapname, t4~vparsel INTO TABLE @DATA(lt_qvars)
    FROM
    rszeltdir AS t1 INNER JOIN rszeltxref AS t2 ON t1~eltuid = t2~seltuid
                    INNER JOIN rszeltdir AS t3 ON t2~teltuid = t3~eltuid
                    INNER JOIN rszglobv AS t4 ON t3~mapname = t4~vnam
    WHERE t1~objvers = 'A'
      AND t1~deftp = 'REP'
      AND t2~objvers = 'A'
      AND t2~laytp IN ( 'VAR', 'QVR' )
      AND t3~objvers = 'A'
      AND t3~deftp = 'VAR'
      AND t4~objvers = 'A'
      AND t1~mapname = @lv_query
    ORDER BY t2~posn.

  IF lines( lt_qvars ) = 0.
    e_status = '8'.
    RETURN.
  ENDIF.

  ls_qparam-grpid = i_grpid.
  ls_qparam-qid = i_qid.
  ls_qparam-cnt = 1.
  ls_qparam-sign = 'I'.
  LOOP AT lt_qvars ASSIGNING FIELD-SYMBOL(<fs>).
    IF <fs>-vparsel = 'I'.
      ls_qparam-opti = 'BT'.
    ELSE.
      ls_qparam-opti = 'EQ'.
    ENDIF.
    ls_qparam-paramname = <fs>-mapname.
    APPEND ls_qparam TO lt_qparam.
  ENDLOOP.

  IF i_mode = 'R'.
    CALL FUNCTION 'ZFM_RFC_BW_UX_SETQPARAM'
      EXPORTING
        i_grpid  = i_grpid
        i_qid    = i_qid
        i_qparam = lt_qparam
      IMPORTING
        e_rowupd = e_rowupd
        e_status = e_status.

  ELSEIF i_mode = 'U'.
    SELECT * FROM ztbw_ux_qparam INTO TABLE @DATA(lt_qparam_src)
     WHERE grpid = @i_grpid AND qid = @i_qid.
    LOOP AT lt_qparam ASSIGNING FIELD-SYMBOL(<fs_qparam>).
      READ TABLE lt_qparam_src WITH KEY grpid = <fs_qparam>-grpid qid = <fs_qparam>-qid paramname = <fs_qparam>-paramname TRANSPORTING NO FIELDS.
      IF sy-subrc NE 0. " если не нашли такого параметра в ранее созданных - создаем с пустым значением
        MOVE-CORRESPONDING <fs_qparam> TO ls_qparam.
        INSERT ztbw_ux_qparam FROM ls_qparam.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_qparam_src ASSIGNING FIELD-SYMBOL(<fs_src>)
      WHERE paramname+0(1) NE '_'.
      READ TABLE lt_qparam WITH KEY grpid = <fs_src>-grpid qid = <fs_src>-qid paramname = <fs_src>-paramname TRANSPORTING NO FIELDS.
      IF sy-subrc NE 0. " В старом списке параметров есть параметр, которого нет в новом списке
        " Это бывает потому, что из BW-Отчета параметр удалили.
        DELETE FROM ztbw_ux_qparam " Тогда удаляем его и из текущих параметров
         WHERE grpid = <fs_src>-grpid
           AND qid = <fs_src>-qid
           AND paramname = <fs_src>-paramname.
      ENDIF.
    ENDLOOP.
    e_status = '0'.
  ELSE.
    e_status = '7'. " неверный i_mode
  ENDIF.

ENDFUNCTION.