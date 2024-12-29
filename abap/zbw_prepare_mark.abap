FUNCTION zbw_prepare_mark.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(IV_CAPTION) TYPE  RRWS_SX_TUPLE-CAPTION
*"     VALUE(IV_CHAVL_EXT) TYPE  RRWS_SX_TUPLE-CHAVL_EXT
*"     VALUE(IV_CHAPRSNT) TYPE  RSCHAPRSNT
*"     VALUE(IV_CHANM) TYPE  RRWS_SX_TUPLE-CHANM OPTIONAL
*"     VALUE(IV_MAT_FRMT) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     REFERENCE(ES_DATA_MARK) TYPE  STRING
*"----------------------------------------------------------------------
  DATA ls_string_tmp TYPE string. "для проверки

  CASE iv_chaprsnt.
    WHEN 'B' OR 'C' OR 'D' OR 'E' OR 'F' OR 'G' OR '3' OR '0' OR '2'. "представление
      IF iv_chavl_ext = 'SUMME'.
        ls_string_tmp = iv_caption.
      ELSE.
        ls_string_tmp = iv_chavl_ext.
      ENDIF.
    WHEN OTHERS.
      ls_string_tmp = iv_caption.
  ENDCASE.

  "текст не переносить на следующую строку
  ls_string_tmp = replace(
        val = ls_string_tmp sub = cl_abap_char_utilities=>cr_lf
        with = ` ` occ = 0 ).

  "для удобства чтения из CSV в EXCEL,
  "числовые целые значения переводим в символьные
  IF ( strlen( ls_string_tmp ) > 7 AND ls_string_tmp CO '0123456789' )
    OR iv_chanm  = '0CALWEEK'.
    IF NOT ( iv_chanm = '0MATERIAL' AND iv_mat_frmt IS NOT INITIAL ).
      ls_string_tmp = |'{ ls_string_tmp }|.
    ENDIF.
  ENDIF.
  REPLACE ALL OCCURRENCES OF ';' IN ls_string_tmp WITH ','.
  ls_string_tmp = ls_string_tmp && ';'.

  "добавляем дополнителную колонку .текст
  CASE iv_chaprsnt.
    WHEN 'B' OR 'C' OR 'D' OR 'E' OR 'F' OR 'G' OR '3' OR '0'.
      ls_string_tmp = ls_string_tmp && iv_caption && ';'.
  ENDCASE.

  es_data_mark = ls_string_tmp.
ENDFUNCTION.
