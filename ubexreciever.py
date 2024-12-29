import os, re
from pyrfc import Connection
from logging import Logger
from typing import List, Dict
from configparser import ConfigParser, Error
from datetime import datetime


# __author__ = "Sergei Shablykin"
# __version__ = "0.0.1"

class UbexReciever:

    params = {}
    logger : Logger
    conn : Connection
    config : ConfigParser
    isPrint : bool
    batch_ts : str
    _bwuser: str

    def __init__(self, logger: Logger, batch_ts:str, **params):
        self.logger = logger
        self.params = params
        self.conn = None
        self.isPrint = True
        if batch_ts:
            self.batch_ts = batch_ts
        else:
            self.batch_ts = re.sub('[^0-9]','', str(datetime.now().replace(microsecond=0)))

        dir_path = os.path.dirname(os.path.realpath(__file__))
        file_path = dir_path + "\\ubex.ini"
        self.config = ConfigParser()
        self.config.read(file_path, encoding='UTF8')


    @property
    def bwuser(self):
        return self._bwuser


    @bwuser.setter
    def bwuser(self, value):
        self._bwuser = value


    @bwuser.deleter
    def bwuser(self):
        del self._bwuser


    def _log_info(self, mess: str):
        self.logger.info(mess)
        if self.isPrint: print(mess)


    def _log_error(self, mess: str):
        self.logger.error(mess)
        if self.isPrint: print(mess) 


    def _getOrCreateConn(self, connname: str) -> Connection:
        try:
            if self.conn:
                return self.conn
            else:
                conngrp = 'connection.sapbw.{0}'.format(connname).lower()
                conninfo = {k:v for k, v in self.config[conngrp].items()}
                conninfo['passwd'] = os.environ.get('UBEXPASS{0}'.format(connname.upper()))
                conninfo['user']   = os.environ.get('UBEXUSER{0}'.format(connname.upper()))
                self.bwuser = conninfo['user']
                self.conn =  Connection(**conninfo)
                self._log_info('Batch {2} Подключено к {0}. Пользователь {1}'.format(connname, conninfo['user'], self.batch_ts))               

        except Error:
            self._log_error(' Ошибка чтения ubex.ini файла')
            return None
        except:
            self._log_error(' Ошибка подключения к {0}'.format(connname))
            return None
        finally:
            return self.conn
            

    def getGrpDetail(self, connname: str, grpid: str, qid: str, uname: str) -> List:
        conn = self._getOrCreateConn(connname)
        if qid != '':
           res = conn.call('ZFM_RFC_BW_UX_GETGRP', I_GRP=grpid, I_QID = qid, I_UNAME = uname)
        else:
           res = conn.call('ZFM_RFC_BW_UX_GETGRP', I_GRP=grpid, I_UNAME = uname )
        if res['E_STATUS'] == '0':
            e_result = res['E_RESULT']
        else:
            e_result = []
        return e_result
    
    
    def getEmails(self, connname: str, grpid: str, qid: str, uname: str) -> List:
        conn = self._getOrCreateConn(connname)
        if qid != '':
           res = conn.call('ZFM_RFC_BW_UX_GET_EMAIL', I_GRPID=grpid, I_QID = qid, I_UNAME = uname)
        else:
           res = conn.call('ZFM_RFC_BW_UX_GET_EMAIL', I_GRPID=grpid, I_UNAME = uname )
        if res['E_STATUS'] == '0':
            e_result = res['E_QPARAM']
        else:
            e_result = []
        rlist = []
        if e_result:
        # Показываем параметры, передаваемые в отчет            
            white_list  = set(("LOW", "HIGH"))
            qp = [ { k:v for k, v in li.items() if k in white_list } for li in e_result ]
            s = ''
            for a in qp:
                s = s + a['LOW'] + ';'
                rlist.append(a['LOW'])
            s = s[:-1]        
        return rlist
    
    
    def getQueryData(self, connname: str, grpid: str, qid: str) -> Dict:
        conn = self._getOrCreateConn(connname)
        self._log_info('Batch {2} Запрос отчета {0}/{1} начат...'.format(grpid, qid, self.batch_ts ))
        res = conn.call('ZFM_RFC_BW_UX_GETQDATA', I_GRPID=grpid, I_QID=qid )
        self._log_info('Batch {2} Запрос отчета {0}/{1} завершен...'.format(grpid, qid, self.batch_ts ))
        return res        