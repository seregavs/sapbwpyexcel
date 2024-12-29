FUNCTION zfm_rfc_bw_ux_getqdata.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_GRPID) TYPE  ZE_BW_UXGRPID
*"     VALUE(I_QID) TYPE  ZE_BW_UXQRID
*"     VALUE(I_UNAME) TYPE  XUBNAME OPTIONAL
*"  EXPORTING
*"     VALUE(E_RESULT) TYPE  ZTT_BW_UXQDATA
*"     VALUE(E_STATUS) TYPE  CHAR1
*"     VALUE(E_QPARAM) TYPE  ZTT_BW_UXQPARAM
*"----------------------------------------------------------------------

  DATA: lv_repstr      TYPE  zts_bw_uxqdata,
        i_infoprovider TYPE  rsinfoprov,
        i_query        TYPE  rszcompid,
        i_view_id      TYPE  rszviewid,
        ls_w3query     TYPE  w3query,
        i_t_parameters TYPE  rrxw3tquery.

  DATA: et_axis_info   TYPE  rrws_thx_axis_info,
        et_cell_data   TYPE  rrws_t_cell,
        et_axis_data   TYPE  rrws_thx_axis_data,
        et_txt_symbols TYPE  rrws_t_text_symbols.

  DATA:
    lt_xls_content TYPE ZTT_BW_UXREPSTR, "law_tab512,
    lv_vparsel     TYPE rszglobv-vparsel,
    lv_iobjnm      TYPE rszglobv-iobjnm.

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

  " получение технического имени BW-query
  SELECT SINGLE * INTO @DATA(ls_query) FROM ztbw_ux_query BYPASSING BUFFER
    WHERE id = @i_qid AND grpid = @i_grpid AND active = 'X'.

  IF sy-subrc = 0.
    " получение инфопровайдера по техническому имени
    SELECT SINGLE t4~infocube AS infoprovider, t1~mapname AS bw_query, t2~txtlg AS bw_query_name
      INTO @DATA(ls_query_det)
      FROM rszeltdir AS t1 INNER JOIN rszelttxt AS t2 ON t1~eltuid = t2~eltuid
      INNER JOIN rszcompdir AS t3 ON t2~eltuid = t3~compuid
      INNER JOIN rszeltxref AS t4 ON t2~eltuid = t4~seltuid BYPASSING BUFFER
      WHERE t1~objvers = 'A'
        AND t2~objvers = 'A'
        AND t2~langu = 'R'
        AND t1~deftp = 'REP'
        AND t1~mapname = @ls_query-techname
        AND t3~objvers = 'A'
        AND t4~objvers = 'A'.
    IF sy-subrc = 0.
      i_query = ls_query-techname.
      i_infoprovider = ls_query_det-infoprovider.
      " получение отсортированного списка значений переменных для BW-query

      DATA: lt_qparam TYPE ztt_bw_uxqparam.
      CALL FUNCTION 'ZFM_RFC_BW_UX_GETQPARAM'
        EXPORTING
          i_grpid  = i_grpid
          i_qid    = i_qid
          i_uname  = i_uname
        IMPORTING
          e_status = e_status
          e_qparam = lt_qparam.
      IF e_status NE '0'.
        RETURN.
      ENDIF.

*      SELECT v1~grpid, v1~qid, v1~paramname, v1~cnt, v1~sign, v1~opti, v1~low, v1~high
*            , t2~txtlg AS paramdescr, t1~vartyp, t1~vproctp, t1~iobjnm, t1~vparsel, t1~varinput, t1~entrytp
*        INTO TABLE @DATA(lt_qparam)
*        FROM ztbw_ux_qparam AS v1 INNER JOIN rszglobv AS t1 ON v1~paramname = t1~vnam
*                                  INNER JOIN rszelttxt AS t2 ON t1~varuniid = t2~eltuid BYPASSING BUFFER
*       WHERE v1~grpid = @i_grpid
*         AND v1~qid = @i_qid
*         AND t1~objvers = 'A'
*         AND t2~objvers = 'A'
*         AND t2~langu = 'R'
*       ORDER BY v1~paramname, cnt.
*
*      SELECT v1~grpid, v1~qid, v1~paramname, v1~cnt, v1~sign, v1~opti, v1~low, v1~high
*        APPENDING CORRESPONDING FIELDS OF TABLE @lt_qparam
*        FROM ztbw_ux_qparam AS v1 BYPASSING BUFFER
*       WHERE v1~grpid = @i_grpid
*         AND v1~qid = @i_qid
*         AND v1~paramname LIKE '/_%' ESCAPE '/'
*       ORDER BY v1~paramname, cnt.

      IF ( sy-subrc = 0 ) OR ( sy-subrc = 4 ). " 4 - no data. It's OK
        "example is in zcl_distribution_bex_quer -> _GET_BEX_QUERY_PARAM
        " Если передан пользователь, то проверять полномочия под ним!
        IF i_uname <> ''.
          CALL FUNCTION 'RSEC_SET_USERNAME'
            EXPORTING
              i_username = i_uname.
        ENDIF.

        LOOP AT lt_qparam ASSIGNING FIELD-SYMBOL(<fs_qparam>)
          WHERE NOT ( paramname = '_WSPARAM' )
            AND low <> ''.
          " Если пользователь указан в параметрах, то это имеет бОльший приоритет
          IF <fs_qparam>-paramname = '_WSUSER'.
            DATA: lv_uname TYPE xubname.
            lv_uname = <fs_qparam>-low.
            CALL FUNCTION 'RSEC_SET_USERNAME'
              EXPORTING
                i_username = lv_uname.
            CONTINUE.
          ENDIF.
          IF <fs_qparam>-paramname+0(1) = '_'.
            CONTINUE.
          ENDIF.

          "определяем тип параметра
          CLEAR lv_vparsel.
          SELECT SINGLE vparsel, iobjnm
            INTO (@lv_vparsel, @lv_iobjnm)
            FROM  rszglobv
            WHERE objvers = 'A'
              AND vnam = @<fs_qparam>-paramname.
          IF sy-subrc <> 0.
            MESSAGE s007(zbw) WITH <fs_qparam>-paramname <fs_qparam>-paramname DISPLAY LIKE 'E'.
            RAISE EXCEPTION TYPE zcx_alv_t100_msg.
          ENDIF.

          DATA(lv_idx) = sy-tabix.
          ls_w3query-name = |VAR_SIGN_{ lv_idx }|.
          ls_w3query-value = <fs_qparam>-sign.
          APPEND ls_w3query TO i_t_parameters.
          ls_w3query-name = |VAR_NAME_{ lv_idx }|.
          ls_w3query-value = <fs_qparam>-paramname.
          APPEND ls_w3query TO i_t_parameters.
          ls_w3query-name = |VAR_OPERATOR_{ lv_idx }|.
          ls_w3query-value = <fs_qparam>-opti.
          APPEND ls_w3query TO i_t_parameters.

          IF lv_vparsel = 'S' OR lv_vparsel = 'I'.
            ls_w3query-name = |VAR_VALUE_LOW_EXT_{ lv_idx }|.
          ELSE.
            ls_w3query-name = |VAR_VALUE_EXT_{ lv_idx }|.
          ENDIF.

*          ls_w3query-name = |VAR_VALUE_LOW_EXT_{ lv_idx }|.
          DATA: lv_low  TYPE rvari_val_255,
                lv_high TYPE rvari_val_255.

          CALL FUNCTION 'ZFM_RFC_BW_UX_PARSEPAR'
            EXPORTING
              i_value  = <fs_qparam>-low
            IMPORTING
              e_result = lv_low.
          IF <fs_qparam>-low <> lv_low.
            <fs_qparam>-low = |{ <fs_qparam>-low } ({ lv_low }|.
          ENDIF.
          ls_w3query-value = lv_low.
          APPEND ls_w3query TO i_t_parameters.

          IF <fs_qparam>-high <> '' AND ( lv_vparsel = 'S' OR lv_vparsel = 'I' ).
            ls_w3query-name = |VAR_VALUE_HIGH_EXT_{ lv_idx }|.
            CALL FUNCTION 'ZFM_RFC_BW_UX_PARSEPAR'
              EXPORTING
                i_value  = <fs_qparam>-high
              IMPORTING
                e_result = lv_high.
            IF <fs_qparam>-high <> lv_high.
              <fs_qparam>-high = |{ <fs_qparam>-high } ({ lv_high }|.
            ENDIF.
            ls_w3query-value = lv_high.
            APPEND ls_w3query TO i_t_parameters.
          ENDIF.
        ENDLOOP.

        e_qparam[] =  lt_qparam[].

        CALL FUNCTION 'RRW3_GET_QUERY_VIEW_DATA'
          EXPORTING
            i_infoprovider          = i_infoprovider
            i_query                 = i_query
            i_t_parameter           = i_t_parameters
          IMPORTING
            e_axis_info             = et_axis_info
            e_cell_data             = et_cell_data
            e_axis_data             = et_axis_data
            e_txt_symbols           = et_txt_symbols
          EXCEPTIONS
            no_applicable_data      = 1
            invalid_variable_values = 2
            no_authority            = 3
            abort                   = 4
            invalid_input           = 5
            invalid_view            = 6
            OTHERS                  = 7.

        CALL FUNCTION 'RSEC_SET_USERNAME'
          EXPORTING
            i_username = sy-uname.

        IF sy-subrc <> 0 OR et_cell_data IS INITIAL.
          e_status = sy-subrc.
        ELSE.
          CALL FUNCTION 'ZBW_PASS_QUERY_DATA_TO_EXTTAB2'
            EXPORTING
              it_axis_info   = et_axis_info
              it_cell_data   = et_cell_data
              it_axis_data   = et_axis_data
              it_txt_symbols = et_txt_symbols
              iv_mat_frmt    = ''
            IMPORTING
              et_xls_content = lt_xls_content.
          LOOP AT lt_xls_content ASSIGNING FIELD-SYMBOL(<fs>).
            lv_repstr-reprow = <fs>-wa.
            APPEND lv_repstr TO e_result.
          ENDLOOP.
*      WAIT UP TO 120 SECONDS.
          CLEAR: lt_xls_content.
          e_status = '0'.
        ENDIF.
      ELSE.
        e_status = '13'.
      ENDIF.
    ELSE.
      e_status = '12'.
    ENDIF.
  ELSE.
    e_status = '11'.
  ENDIF.

ENDFUNCTION.