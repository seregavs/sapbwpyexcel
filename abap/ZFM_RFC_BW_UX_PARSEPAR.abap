FUNCTION zfm_rfc_bw_ux_parsepar.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     VALUE(I_VALUE) TYPE  RVARI_VAL_255
*"  EXPORTING
*"     VALUE(E_RESULT) TYPE  RVARI_VAL_255
*"----------------------------------------------------------------------
  CONDENSE i_value NO-GAPS.
  DATA: lv_d TYPE d,
        lv_i TYPE i.
  lv_d = sy-datum.
  DATA(lv) = i_value.
  e_result = i_value.
  TRY.
      IF ( i_value = 'CURRDAY' ) OR ( i_value = 'CURRDATE' ).
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = lv_d
          IMPORTING
            output = e_result.
"       e_result = lv_d.
      ELSEIF ( i_value CS 'CURRDAY-' ) OR ( i_value CS 'CURRDATE-' ).
        SHIFT lv UP TO '-'.
        SHIFT lv LEFT BY 1 PLACES.
        lv_i = CONV int2( lv ).
        lv_d = lv_d - lv_i.
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = lv_d
          IMPORTING
            output = e_result.
      ELSEIF ( i_value CS 'CURRDAY+' ) OR ( i_value CS 'CURRDATE+' ).
        SHIFT lv UP TO '+'.
        SHIFT lv LEFT BY 1 PLACES.
        lv_i = CONV int2( lv ).
        lv_d = lv_d + lv_i.
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = lv_d
          IMPORTING
            output = e_result.
      ELSEIF i_value CS 'CURRYEAR'.
        e_result = lv_d+0(4).
      ELSEIF i_value CS 'CURRMONTH'.
        e_result = |{ lv_d+4(2) }.{ lv_d+0(4) }|.
      ELSE.
        e_result = i_value.
      ENDIF.
    CATCH cx_root.
  ENDTRY.

ENDFUNCTION.