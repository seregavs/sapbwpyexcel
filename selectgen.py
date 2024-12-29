import random

table_list = []
table_item = {}
table_join_list = []
table_join_item = {}
table_field_list = []
table_field_item = {}
query_list = []
query_item = {}

# table
table_item['name'] = 'Hive.bw.bic_base_mov_aggr_cv01'
table_item['alias'] = 't0'
table_item['ttype'] = 'F'
table_list.append(table_item)

table_item = {}
table_item['name'] = 'Hive.stg.nova_calendar'
table_item['alias'] = 't1'
table_item['ttype'] = 'D'
table_list.append(table_item)

table_item = {}
table_item['name'] = 'Hive.stg.nova_bic_material'
table_item['alias'] = 't2'
table_item['ttype'] = 'D'
table_list.append(table_item)

table_item = {}
table_item['name'] = 'Hive.stg.nova_bic_plant'
table_item['alias'] = 't3'
table_item['ttype'] = 'D'
table_list.append(table_item)

table_item = {}
table_item['name'] = 'Hive.stg.nova_bic_mat_plant'
table_item['alias'] = 't4'
table_item['ttype'] = 'D'
table_list.append(table_item)


# table_join
table_join_item = {}
table_join_item['id'] = 1
table_join_item['tf'] = 't0'
table_join_item['td'] = 't1'
table_join_item['ff'] = 'calday'
table_join_item['fd'] = 'calday'
table_join_list.append(table_join_item)

table_join_item = {}
table_join_item['id'] = 1
table_join_item['tf'] = 't0'
table_join_item['td'] = 't2'
table_join_item['ff'] = 'material'
table_join_item['fd'] = 'material'
table_join_list.append(table_join_item)

table_join_item = {}
table_join_item['id'] = 1
table_join_item['tf'] = 't0'
table_join_item['td'] = 't3'
table_join_item['ff'] = 'plant'
table_join_item['fd'] = 'plant'
table_join_list.append(table_join_item)

table_join_item = {}
table_join_item['id'] = 1
table_join_item['tf'] = 't0'
table_join_item['td'] = 't4'
table_join_item['ff'] = 'plant'
table_join_item['fd'] = 'plant'
table_join_list.append(table_join_item)

table_join_item = {}
table_join_item['id'] = 2
table_join_item['tf'] = 't0'
table_join_item['td'] = 't4'
table_join_item['ff'] = 'material'
table_join_item['fd'] = 'mat_plant'
table_join_list.append(table_join_item)

# table_field
# t0
# table_field_item = {}
# table_field_item ['id'] = 1
# table_field_item ['talias'] = 't0'
# table_field_item['field'] = 'material'
# table_field_item['ftype'] = 'CH'
# table_field_list.append(table_field_item)

# table_field_item = {}
# table_field_item ['id'] = 2
# table_field_item ['talias'] = 't0'
# table_field_item['field'] = 'plant'
# table_field_item['ftype'] = 'CH'
# table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 3
table_field_item ['talias'] = 't0'
table_field_item['field'] = 'move_type'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 4
table_field_item ['talias'] = 't0'
table_field_item['field'] = 'quant_b'
table_field_item['ftype'] = 'KF'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 5
table_field_item ['talias'] = 't0'
table_field_item['field'] = 'value_lc'
table_field_item['ftype'] = 'KF'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 6
table_field_item ['talias'] = 't0'
table_field_item['field'] = 'stor_loc'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

# t1
table_field_item = {}
table_field_item ['id'] = 1
table_field_item ['talias'] = 't1'
table_field_item['field'] = 'calday'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 2
table_field_item ['talias'] = 't1'
table_field_item['field'] = 'calmonth'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 3
table_field_item ['talias'] = 't1'
table_field_item['field'] = 'calyear'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 4
table_field_item ['talias'] = 't1'
table_field_item['field'] = 'calquarter'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 5
table_field_item ['talias'] = 't1'
table_field_item['field'] = 'calweek'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 6
table_field_item ['talias'] = 't1'
table_field_item['field'] = 'calmonth2'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 7
table_field_item ['talias'] = 't1'
table_field_item['field'] = 'weekday1'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

# t2
table_field_item = {}
table_field_item ['id'] = 1
table_field_item ['talias'] = 't2'
table_field_item['field'] = 'material'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'material_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 2
table_field_item ['talias'] = 't2'
table_field_item['field'] = 'matl_cat'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'matl_cat_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 3
table_field_item ['talias'] = 't2'
table_field_item['field'] = 'matl_group'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'matl_group_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 4
table_field_item ['talias'] = 't2'
table_field_item['field'] = 'matl_type'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'matl_type_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 5
table_field_item ['talias'] = 't2'
table_field_item['field'] = 'pur_group'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'pur_group_txt'
table_field_list.append(table_field_item)

# t3
table_field_item = {}
table_field_item ['id'] = 1
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'plant'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'plant_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 2
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'company'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'company_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 3
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'comp_code'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'comp_code_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 4
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'purch_org'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'purch_org_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 5
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'region'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'region_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 6
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'zcitycode'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'zcitycode_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 7
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'zcomdir'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'zcomdir_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 8
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'zdivdir'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'zdivdir_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 9
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'zregdir'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'zregdir_txt'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 10
table_field_item ['talias'] = 't3'
table_field_item['field'] = 'zpltfrmt'
table_field_item['ftype'] = 'CH'
table_field_item['text'] = 'zpltfrmt_txt'
table_field_list.append(table_field_item)

# t4
table_field_item = {}
table_field_item ['id'] = 11
table_field_item ['talias'] = 't4'
table_field_item['field'] = 'rt_departm'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 11
table_field_item ['talias'] = 't4'
table_field_item['field'] = 'ctypematr'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 12
table_field_item ['talias'] = 't4'
table_field_item['field'] = 'ctypmatr2'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

table_field_item = {}
table_field_item ['id'] = 13
table_field_item ['talias'] = 't4'
table_field_item['field'] = 'vendor'
table_field_item['ftype'] = 'CH'
table_field_list.append(table_field_item)

# where item
where_group_list = []
where_group_list.append(dict(talias='t1',group=['calday','calweek','calmonth','calquarter', 'calyear', 'halfyear' ])) #$$
where_group_list.append(dict(talias='t1',group=['halfyear1','calquart1','calmonth2','calweek1', 'calyear', 'halfyear' ]))
where_group_list.append(dict(talias='t1',group=['weekday1' ]))
where_group_list.append(dict(talias='t1',group=['calday1'])) #$$
where_group_list.append(dict(talias='t0',group=['move_type'])) #$$
where_group_list.append(dict(talias='t0',group=['stor_loc'])) #$$
where_group_list.append(dict(talias='t2',group=['matl_type'])) #$$
# where_group_list.append(dict(talias='t2',group=['matl_cat']))#$$
where_group_list.append(dict(talias='t2',group=['oi_oland1'])) #$$
# where_group_list.append(dict(talias='t2',group=['val_class'])) #$$
where_group_list.append(dict(talias='t2',group=['pur_group','rpa_wgh1','rpa_wgh2','rpa_wgh3']))
where_group_list.append(dict(talias='t3',group=['plant','zpltfrmt'])) 
where_group_list.append(dict(talias='t3',group=['zregdir','zdivdir','zcitycode','zcomdir']))
where_group_list.append(dict(talias='t4',group=['rt_departm'])) #$$
where_group_list.append(dict(talias='t4',group=['ctypematr'])) #$$


where_clause_list = []
# where_clause_list.append(dict(field='val_class', clause=" = '4203'"))
# where_clause_list.append(dict(field='val_class', clause=" = ''"))
# where_clause_list.append(dict(field='val_class', clause=" <> '4300'"))
# where_clause_list.append(dict(field='val_class', clause=" BETWEEN '2030' AND '4200'"))
# where_clause_list.append(dict(field='val_class', clause=" BETWEEN '0010' AND '5100'"))
where_clause_list.append(dict(field='move_type', clause=" = '101'"))
where_clause_list.append(dict(field='move_type', clause=" <> '101'"))
where_clause_list.append(dict(field='move_type', clause=" IN ('101','251')"))
where_clause_list.append(dict(field='stor_loc', clause=" = '0001'"))
where_clause_list.append(dict(field='stor_loc', clause="<> '0001'"))
where_clause_list.append(dict(field='calday1', clause="BETWEEN '01' AND '10'"))
where_clause_list.append(dict(field='calday1', clause="= '22'"))
where_clause_list.append(dict(field='calday1', clause="<> '23'"))
where_clause_list.append(dict(field='weekday1', clause="BETWEEN '1' AND '5'"))
where_clause_list.append(dict(field='weekday1', clause="= '6'"))
where_clause_list.append(dict(field='weekday1', clause="<> '6'"))
where_clause_list.append(dict(field='calday', clause="BETWEEN '20220101' AND '20220115'"))
where_clause_list.append(dict(field='calday', clause="BETWEEN '20220501' AND '20220615'"))
where_clause_list.append(dict(field='calmonth', clause="BETWEEN '202205' AND '202206'"))
where_clause_list.append(dict(field='calmonth', clause="BETWEEN '202305' AND '202310'"))
where_clause_list.append(dict(field='calmonth', clause="IN ('202205','202206','202207')"))
where_clause_list.append(dict(field='calquarter', clause="IN ('20233')"))
where_clause_list.append(dict(field='calquarter', clause="IN ('20233','20224')"))
where_clause_list.append(dict(field='oi_oland1', clause="IN ('RU','ES')"))
where_clause_list.append(dict(field='oi_oland1', clause="= 'RU'"))
where_clause_list.append(dict(field='oi_oland1', clause="<> 'RU'"))
where_clause_list.append(dict(field='pur_group', clause="IN ('P36','P04','P01')"))
where_clause_list.append(dict(field='pur_group', clause="IN ('P05','P04','P01')"))
where_clause_list.append(dict(field='pur_group', clause="= 'P01'"))
where_clause_list.append(dict(field='pur_group', clause="= 'P04'"))
where_clause_list.append(dict(field='pur_group', clause="<> 'P04'"))
where_clause_list.append(dict(field='rpa_wgh1', clause="IN ('RU','ES')"))
where_clause_list.append(dict(field='rpa_wgh1', clause="= 'FOOD'"))
where_clause_list.append(dict(field='rpa_wgh1', clause="<> 'NONSALES'"))
where_clause_list.append(dict(field='rpa_wgh2', clause="IN ('18','35','61','27','48')"))
where_clause_list.append(dict(field='rpa_wgh2', clause="= '18'"))
where_clause_list.append(dict(field='rpa_wgh2', clause="<> '61'"))
where_clause_list.append(dict(field='rpa_wgh3', clause="IN ('1706','1611','1808','1008','1509','1601','1808','2401','2807','3303')"))
where_clause_list.append(dict(field='rpa_wgh3', clause="= '3403'"))
where_clause_list.append(dict(field='rpa_wgh3', clause="<> '3504'"))
where_clause_list.append(dict(field='rpa_wgh4', clause="IN ('RU','ES'"))
where_clause_list.append(dict(field='rpa_wgh4', clause="= 'RU'"))
where_clause_list.append(dict(field='rpa_wgh4', clause="<> 'RU'"))
# where_clause_list.append(dict(field='matl_cat', clause="IN ('00','10'"))
# where_clause_list.append(dict(field='matl_cat', clause="= '00'"))
where_clause_list.append(dict(field='matl_type', clause="IN ('1HAW','HAWA')"))
where_clause_list.append(dict(field='matl_type', clause="= '2FER'"))
where_clause_list.append(dict(field='matl_type', clause="= 'Z_AM'"))
where_clause_list.append(dict(field='matl_type', clause="<> 'HAWA'"))
# ['zregdir','zdivdir','zcitycode','zcomdir'])
where_clause_list.append(dict(field='zregdir', clause="IN ('03','05','01','02')"))
where_clause_list.append(dict(field='zregdir', clause="= '06'"))
where_clause_list.append(dict(field='zregdir', clause="= '14'"))
where_clause_list.append(dict(field='zregdir', clause="<> '31'"))
where_clause_list.append(dict(field='zdivdir', clause="IN ('OD04','OD01','OD06')"))
where_clause_list.append(dict(field='zdivdir', clause="= 'OD04'"))
where_clause_list.append(dict(field='zdivdir', clause="= 'OD06'"))
where_clause_list.append(dict(field='zdivdir', clause="<> 'OD03'"))
where_clause_list.append(dict(field='zcitycode', clause="NOT IN ('000000003001','000000001008','000000001002')"))
where_clause_list.append(dict(field='zcitycode', clause="= '000000003001'"))
where_clause_list.append(dict(field='zcitycode', clause="= '000000003004'"))
where_clause_list.append(dict(field='zcitycode', clause="<> '000000001002'"))
where_clause_list.append(dict(field='zcomdir', clause="IN ('CD06','CD04')"))
where_clause_list.append(dict(field='zcomdir', clause="= 'CD01'"))
where_clause_list.append(dict(field='zcomdir', clause="= 'CD05'"))
where_clause_list.append(dict(field='zcomdir', clause="<> 'CD06'"))
where_clause_list.append(dict(field='zpltfrmt', clause="LIKE 'HB%'"))
where_clause_list.append(dict(field='zpltfrmt', clause="= 'HB_STD'"))
where_clause_list.append(dict(field='zpltfrmt', clause="= 'HB_COMT_L'"))
where_clause_list.append(dict(field='zpltfrmt', clause="LIKE 'SE%'"))
where_clause_list.append(dict(field='plant', clause="LIKE '001%'"))
where_clause_list.append(dict(field='plant', clause="= '0002'"))
where_clause_list.append(dict(field='plant', clause="= '0010'"))
where_clause_list.append(dict(field='plant', clause="BETWEEN '0001' AND '0010'"))
where_clause_list.append(dict(field='rt_departm', clause="= '01'"))
where_clause_list.append(dict(field='rt_departm', clause="= '09'"))
where_clause_list.append(dict(field='rt_departm', clause="BETWEEN '01' AND '08'"))
where_clause_list.append(dict(field='ctypematr', clause="= 'A'"))
where_clause_list.append(dict(field='ctypematr', clause="<> 'A'"))

# query item
query_item = {}
query_item['ftable'] = 't0'
# without MAT_PLANT
# query_item['dtables'] = ['t1','t2','t3'] # dimension table aliases list
# query_item['kflist'] = ['4','5'] # key figures number list
# query_item['chlist'] = [dict(tn = 't1', nf = 1), dict(tn = 't0', nf = 1), dict(tn = 't2', nf = 3), dict(tn = 't3', nf = 1)] # number of characteristic fields (nf) from each table (tn) to be included in the SELECT (and GROUP BY) clause
# query_item['whlist'] = [dict(tn = 't1', nf = 2), dict(tn = 't0', nf = 1), dict(tn = 't2', nf = 2), dict(tn = 't3', nf = 2)] # number of characteristic fields (nf) from each table (tn) to be included in the WHERE clause
# WITH MAT_PLANT
query_item['dtables'] = ['t1','t2','t3','t4'] # dimension table aliases list
query_item['kflist'] = ['4','5'] # key figures number list
query_item['chlist'] = [dict(tn = 't1', nf = 1), dict(tn = 't0', nf = 1), \
                        dict(tn = 't2', nf = 3), dict(tn = 't3', nf = 1), \
                        dict(tn = 't4', nf = 2)    ] # number of characteristic fields (nf) from each table (tn) to be included in the SELECT (and GROUP BY) clause
query_item['whlist'] = [dict(tn = 't1', nf = 2), dict(tn = 't0', nf = 1), \
                        dict(tn = 't2', nf = 2), dict(tn = 't3', nf = 2), \
                        dict(tn = 't4', nf = 1)    ] # number of characteristic fields (nf) from each table (tn) to be included in the WHERE clause
query_list.append(query_item)

print('-------------------')
with_txt: bool
with_txt = True
for query in query_list:
    select_stmt = "SELECT 'Q{0}' as qid ".format(random.randint(100,999))
    field_str = ''
    for chgroup in query['chlist']:
        print(chgroup['tn'])
        table_sel_column_list = ['{0}.{1}'.format(chgroup['tn'], item['field']) for item in table_field_list if ( item['talias'] == chgroup['tn']) & (item['ftype'] == 'CH' )]
        print('table_sel_column_list = ', table_sel_column_list)
        table_chosen_column_list = random.sample(table_sel_column_list, chgroup['nf'])
        for a in table_chosen_column_list:
            r = next(item for item in table_field_list if (item['talias'] == chgroup['tn']) and  (item['field'] == a.split('.')[1] ))
            if ( with_txt ) and ( r.get('text') != None):
                field_str += ', {0}.{1}, {0}.{2}'.format(r['talias'], r['field'], r.get('text'))
            else:
                field_str += ', {0}.{1}'.format(r['talias'], r['field'])
            print('--', r)
        print('table_chosen_column_list = ',table_chosen_column_list)
    select_stmt += field_str
    kf_list = [ next(item for item in table_field_list if (item['talias'] == query['ftable'] ) and (item['id'] == int(kf)))['field']  for kf in query['kflist'] ]
    print(kf_list)
    kf_str = ''
    for kf in kf_list:
        kf_str += ', sum({1}.{0}) as s_{0}'.format(kf,query['ftable'] )
    select_stmt += '\n     {0}'.format(kf_str)
    select_stmt += ' \n  FROM '
    select_stmt += '{0} as {1} '.format( \
                next(item for item in table_list if (item['alias'] == query['ftable']))['name'], query['ftable'])
    dt = [next(d for d in table_list if (d['alias'] == item) and d['ttype'] == 'D') for item in query['dtables']]
    for item in dt:
        select_stmt += ', {0} as {1}'.format(item['name'], item['alias'])
    select_stmt += ' \n WHERE 1 = 1\n'
    for dt in query['dtables']:
        wh_list = [ item for item in table_join_list if (item['td'] == dt) ]
        for whi in wh_list:
            select_stmt += '   AND {0}.{1} = {2}.{3}\n'.format(whi['tf'],whi['ff'],whi['td'],whi['fd'])

    where_str = ''
    for whg in query['whlist']:
        tn = whg['tn']
        wgl = random.sample([ item for item in where_group_list if (item['talias'] == whg['tn'])], whg['nf'])
        print('  wgl=', wgl)
        for wgi in wgl:
            wcl = [item for item in where_clause_list if item['field'] in wgi['group']]
            if wcl:
                wclr = random.sample(wcl,1)[0]
                print('   wclr=',wclr, ' talias', wgi['talias'])
                where_str += '   AND {0}.{1} {2}\n'.format(wgi['talias'], wclr['field'], wclr['clause'])
    select_stmt +=where_str
    select_stmt += ' GROUP BY {0};'.format(field_str[1:])


    print('\n',select_stmt)


