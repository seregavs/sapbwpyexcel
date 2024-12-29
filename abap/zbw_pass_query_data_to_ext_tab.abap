FUNCTION ZBW_PASS_QUERY_DATA_TO_EXTTAB2 .
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     REFERENCE(IT_AXIS_INFO) TYPE  RRWS_THX_AXIS_INFO
*"     REFERENCE(IT_CELL_DATA) TYPE  RRWS_T_CELL
*"     REFERENCE(IT_AXIS_DATA) TYPE  RRWS_THX_AXIS_DATA
*"     REFERENCE(IT_TXT_SYMBOLS) TYPE  RRWS_T_TEXT_SYMBOLS
*"     VALUE(IV_MAT_FRMT) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     REFERENCE(ET_XLS_CONTENT) TYPE  ZTT_BW_UXREPSTR
* ZTT_BW_UXREPSTR->ZTS_BW_UXREPSTR->WA: TEXT8192
*"----------------------------------------------------------------------
  DATA:
    ls_data_tmp      TYPE string, "строка показтелей
    ls_data_sign     TYPE string, "строка признаков
    ls_string_tmp    TYPE string, "для проверки на число
    lv_count_column1 TYPE i, "количество колонок признаков
    lv_count_column2 TYPE i, "количество колонок показателей
    lv_count_row2    TYPE i, "количество строк названий показателей (и признаков)
    lv_column_tmp    TYPE i, "текущий номер колонки
    lv_tuple_ordinal TYPE rrws_sx_tuple-tuple_ordinal, "текущее значение TUPLE_ORDINAL
    lt_data_sign     TYPE TABLE OF rstxtlg.

  "формируем название колонок показателей
  TRY.
      "считывание названий колонок
      DATA(lt_info2) = it_axis_info[ axis = '000' ]-chars.
      DATA(lt_axis0) = it_axis_data[ axis = '000' ]-set.
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.

  LOOP AT lt_axis0 ASSIGNING FIELD-SYMBOL(<ls_axis0>).
    ADD 1 TO lv_count_row2.

    "подсчитываем количество колонок показателей
    IF <ls_axis0>-tuple_ordinal <> lv_tuple_ordinal OR sy-tabix = 1.
      ADD 1 TO lv_count_column2.
    ENDIF.
    lv_tuple_ordinal = <ls_axis0>-tuple_ordinal.

    "текст не переносить на следующую строку
    <ls_axis0>-caption = replace(
          val = <ls_axis0>-caption sub = cl_abap_char_utilities=>cr_lf
          with = ` ` occ = 0 ).

    "определяем тип, чтобы в дальнейшем определить колонку считывания данных
    READ TABLE lt_info2 ASSIGNING FIELD-SYMBOL(<ls_info2>)
           WITH TABLE KEY chanm = <ls_axis0>-chanm.
    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    CASE <ls_info2>-chaprsnt. "представление признаков
      WHEN '0' OR '2'. "ключ и текст или ключ
        IF <ls_axis0>-chavl_ext = 'SUMME'.
          ls_string_tmp = <ls_axis0>-caption.
        ELSE.

          "для удобства чтения из CSV в EXCEL,
          "числовые целые значения переводим в символьные
          IF ( strlen( <ls_axis0>-chanm ) > 7 AND <ls_axis0>-chanm CO '0123456789' )
             OR <ls_axis0>-chanm  = '0CALWEEK'.
            IF NOT ( <ls_axis0>-chanm = '0MATERIAL' AND iv_mat_frmt IS NOT INITIAL ).
              ls_string_tmp = |'{ <ls_axis0>-chavl_ext }|.
            ENDIF.
          ELSE.
            ls_string_tmp = <ls_axis0>-chavl_ext.
          ENDIF.
        ENDIF.
      WHEN '1' OR 'F'. "текст
        ls_string_tmp = <ls_axis0>-caption.
      WHEN OTHERS.
        ls_string_tmp = <ls_axis0>-caption.
    ENDCASE.

    ls_string_tmp = ls_string_tmp && ';'.
    APPEND ls_string_tmp TO lt_data_sign.
    CLEAR ls_data_sign.
  ENDLOOP.

  "формируем название колонок признакв
  TRY.
      "считывание названий колонок
      DATA(lt_info1) = it_axis_info[ axis = '001' ]-chars.
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.

  LOOP AT lt_info1 ASSIGNING FIELD-SYMBOL(<ls_info1>).
    ls_data_tmp = ls_data_tmp && <ls_info1>-caption && ';'.
    ADD 1 TO lv_count_column1.

    "добавляем дополнительную колонку текст
    CASE <ls_info1>-chaprsnt.
      WHEN 'B' OR 'C' OR 'D' OR 'E' OR 'F' OR 'G' OR '3' OR '0'.
        ls_data_tmp = ls_data_tmp && <ls_info1>-caption
                                             && '.текст' && ';'.
    ENDCASE.

    "добавляем дополнительные колонки атрибутов
    IF <ls_info1>-attrinm IS NOT INITIAL.
      LOOP AT <ls_info1>-attrinm ASSIGNING FIELD-SYMBOL(<ls_attrinm>).
        ls_data_tmp = ls_data_tmp && <ls_attrinm>-caption && ';'.

        "добавляем дополнительную колонку текст
        CASE <ls_attrinm>-chaprsnt.
          WHEN 'B' OR 'C' OR 'D' OR 'E' OR 'F' OR 'G' OR '3' OR '0'.
            ls_data_tmp = ls_data_tmp && <ls_attrinm>-caption
                                                 && '.текст' && ';'.
        ENDCASE.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

  "определяем количество строк названий показателей
  IF lv_count_column2 IS NOT INITIAL.
    lv_count_row2 = lv_count_row2 DIV lv_count_column2.
  ELSEIF ls_data_tmp IS NOT INITIAL.
    lv_count_row2 = 1.
  ENDIF.

  " Склеиваем название колонок признаков и показателей
  DO lv_count_row2 TIMES. "цикл по строкам названий
    "формируем строку названий показателей
    CLEAR: ls_data_sign.
    DATA(lv_row_tmp) = sy-index.
    DO lv_count_column2 TIMES. "цикл по столбцам
      DATA(lv_tab_index) = lv_row_tmp + ( sy-index - 1 ) * lv_count_row2.
      READ TABLE lt_data_sign INDEX lv_tab_index
          ASSIGNING FIELD-SYMBOL(<ls_data_sign>).
      CHECK sy-subrc = 0.
      ls_data_sign = ls_data_sign && <ls_data_sign>.
    ENDDO.

    "склеиваем строку названий признаков со строкой названий показателей
    APPEND INITIAL LINE TO et_xls_content
              ASSIGNING FIELD-SYMBOL(<ls_xls_content>).
    ls_data_sign = ls_data_tmp && ls_data_sign.
    <ls_xls_content> = ls_data_sign.
    ADD 1 TO lv_column_tmp.
  ENDDO.

  "формируем RANGE для проверки "левых" символов
  CALL FUNCTION 'ZBW_GET_LIMIT'.

  TRY.
      DATA(lt_axis1) = it_axis_data[ axis = '001' ]-set.
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.

  "формируем значения показателей
  CLEAR: ls_data_tmp, ls_string_tmp, lv_column_tmp.
  LOOP AT it_cell_data ASSIGNING FIELD-SYMBOL(<ls_cell_data>).
    DATA(lv_tabix) = sy-tabix.

    IF ls_data_tmp IS INITIAL. "начало новой строки
      DO lv_count_column1 TIMES. "записываем значение признаков в стоках
        ADD 1 TO lv_column_tmp.

        READ TABLE lt_axis1 ASSIGNING FIELD-SYMBOL(<ls_axis1>)
                  INDEX lv_column_tmp.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        "определяем тип признака, чтобы в дальнейшем
        "определить колонку считывания данных
        READ TABLE lt_info1 ASSIGNING <ls_info1>
              WITH TABLE KEY chanm = <ls_axis1>-chanm.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        CLEAR ls_string_tmp.
        CALL FUNCTION 'ZBW_PREPARE_MARK'
          EXPORTING
            iv_caption   = <ls_axis1>-caption
            iv_chavl_ext = <ls_axis1>-chavl_ext
            iv_chanm     = <ls_axis1>-chanm
            iv_chaprsnt  = <ls_info1>-chaprsnt
            iv_mat_frmt  = iv_mat_frmt
          IMPORTING
            es_data_mark = ls_string_tmp.

        ls_data_tmp = ls_data_tmp && ls_string_tmp.

        "добавляем дополнительные колонки атрибутов
        IF <ls_axis1>-attributes IS NOT INITIAL.
          LOOP AT <ls_axis1>-attributes ASSIGNING FIELD-SYMBOL(<ls_attributes>).
            "определяем тип признака, чтобы в дальнейшем
            "определить колонку считывания данных
            READ TABLE <ls_info1>-attrinm ASSIGNING <ls_attrinm>
                  WITH KEY attrinm = <ls_attributes>-attrinm.
            IF sy-subrc <> 0.
              CONTINUE.
            ENDIF.

            CLEAR ls_string_tmp.
            CALL FUNCTION 'ZBW_PREPARE_MARK'
              EXPORTING
                iv_caption   = <ls_attributes>-caption
                iv_chavl_ext = <ls_attributes>-attrivl
                iv_chaprsnt  = <ls_attrinm>-chaprsnt
                iv_mat_frmt  = iv_mat_frmt
              IMPORTING
                es_data_mark = ls_string_tmp.

            ls_data_tmp = ls_data_tmp && ls_string_tmp.
          ENDLOOP.
        ELSE.
          READ TABLE lt_info1 ASSIGNING <ls_info1>
                WITH TABLE KEY chanm = <ls_axis1>-chanm.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
          LOOP AT <ls_info1>-attrinm ASSIGNING <ls_attrinm>.

            CLEAR ls_string_tmp.
            CALL FUNCTION 'ZBW_PREPARE_MARK'
              EXPORTING
                iv_caption   = <ls_axis1>-caption
                iv_chavl_ext = 'SUMME'
                iv_chaprsnt  = <ls_attrinm>-chaprsnt
                iv_mat_frmt  = iv_mat_frmt
              IMPORTING
                es_data_mark = ls_string_tmp.
            ls_data_tmp = ls_data_tmp && ls_string_tmp.
          ENDLOOP.
        ENDIF.
      ENDDO.
    ENDIF.

    DATA(lv_value) = replace( val = <ls_cell_data>-value sub = '.' with = ',' ).

    ls_data_tmp = ls_data_tmp && lv_value && ';'.

    "если конец строки по показателям
    IF lv_count_column2 = 0 OR lv_tabix MOD lv_count_column2 = 0.
      APPEND INITIAL LINE TO et_xls_content ASSIGNING <ls_xls_content>.
      <ls_xls_content> = ls_data_tmp.

      "проверка "левых" символов
      DATA(lv_strlen) = strlen( <ls_xls_content> ).
      DO lv_strlen TIMES.
        DATA(lv_i) = sy-index - 1.
        IF <ls_xls_content>+lv_i(1) NOT IN gr_limit.
          <ls_xls_content>+lv_i(1) = `·`.
        ENDIF.
      ENDDO.
      CLEAR ls_data_tmp.
    ENDIF.
  ENDLOOP.
ENDFUNCTION.