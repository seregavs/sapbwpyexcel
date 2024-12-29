FUNCTION zbw_get_limit.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"----------------------------------------------------------------------
  CHECK gr_limit IS INITIAL.
  APPEND VALUE #( sign = 'I' option = 'BT' low = ' ' high = '~') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'BT' low = 'А' high = 'я') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ё') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = 'Ё') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '№') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '™') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '“') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '”') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '–') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '—') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '©') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '«') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '»') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '®') TO gr_limit.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '…') TO gr_limit.
ENDFUNCTION.
