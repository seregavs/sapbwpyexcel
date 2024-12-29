@EndUserText.label : 'UberExcel BW query Group'
@AbapCatalog.enhancement.category : #NOT_CLASSIFIED
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #C
@AbapCatalog.dataMaintenance : #ALLOWED
define table ztbw_ux_qgrp {
  key id     : ze_bw_uxgrpid not null;
  name       : ze_bw_uxgrpname;
  active     : ze_bw_uxgrpact;
  folder     : ze_bw_uxfldp;
  filesuffix : ze_bw_uxfsuff;
  fname      : ze_bw_uxfname;
  frmt       : ze_bw_uxfrmt;
  pyclass    : ze_bw_uxpycls;

}

@EndUserText.label : 'Uber Excel BW-query'
@AbapCatalog.enhancement.category : #NOT_CLASSIFIED
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #C
@AbapCatalog.dataMaintenance : #ALLOWED
define table ztbw_ux_query {
  key id      : ze_bw_uxqrid not null;
  key grpid   : ze_bw_uxgrpid not null;
  techname    : ze_bw_uxtname;
  active      : ze_bw_uxgrpact;
  pyclass     : ze_bw_uxpycls;
  wsname      : ze_bw_uxwsname;
  description : ze_bw_uxdescr;

}


@EndUserText.label : 'Uber Excel. Параметры запуска BW-query'
@AbapCatalog.enhancement.category : #NOT_CLASSIFIED
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #C
@AbapCatalog.dataMaintenance : #ALLOWED
define table ztbw_ux_qparam {
  key grpid     : ze_bw_uxgrpid not null;
  key qid       : ze_bw_uxqrid not null;
  key paramname : ze_bw_uxqparam not null;
  key cnt       : ze_bw_uxcnt not null;
  sign          : tvarv_sign;
  opti          : tvarv_opti;
  low           : rvari_val_255;
  high          : rvari_val_255;

}

