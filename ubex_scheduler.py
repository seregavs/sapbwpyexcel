import os
import sys
from logging import Logger, Formatter
from typing import List, Dict
from ubexreciever import UbexReciever
from croniter import croniter
from datetime import datetime
from threading import Thread
import __version__ as vr
import ubex
import time

# https://pypi.org/project/croniter/#introduction
# https://docs-python.ru/standart-library/modul-threading-python/klass-thread-modulja-threading/

class UbexScheduler(UbexReciever):

    def __init__(self, logger: Logger, **params):
        super().__init__(logger, batch_ts='', **params )
        logger.info('Batch {0} запускается...'.format(self.batch_ts))


    def getGrpCron(self, connname: str) -> List:
        conn = self._getOrCreateConn(connname)
        res = conn.call('ZFM_RFC_BW_UX_CRONGET', I_LEVEL = 'G')
        if res['E_STATUS'] == '0':
            e_result = res['E_RESULT']
        else:
            e_result = []
        return e_result
    

    def CronUpd(self, connname: str, grpid: str, qid: str, runtime: str) -> str:
        conn = self._getOrCreateConn(connname)
        res = conn.call('ZFM_RFC_BW_UX_CRONUPD', I_GRPID = grpid, I_QID = qid, I_RUNTIME = runtime)
        return res['E_STATUS']       


def main():
    args = sys.argv[1:]
    if not args:
        connname = 'BWP'
    else:
        connname = args[0]
    
    threadcnt = 1
    (logger := ubex.initLogger()).info('Uber Excel scheduler. v{0}'.format(vr.__version__))
    us = UbexScheduler(logger)
    for a in us.getGrpCron(connname):
        logger.info('Batch {0}, item {1}'.format(us.batch_ts, str(a)))
        try:
            base = datetime.now().replace(microsecond=0) 
            iter = croniter(str(a['CRON']), base)  
            if a['RUNTIME']:
                prev_run = datetime.strptime(str(a['RUNTIME']), "%Y-%m-%d %H:%M:%S")
            else:
                # установить дату = дате следующего запуска get_next в ZFM_RFC_BW_UX_CRONUPD и вернуться назад (get_prev_)
                us.CronUpd(connname,a['GRPID'], a['QID'], str(iter.get_next(datetime)))
                iter.get_prev(datetime)
                prev_run = base
            cron = iter.get_prev(datetime)
            bo = ( prev_run >= cron )
            if not bo:
                logger.info('Batch {0}-{1}. Run {2}.{3}'.format(us.batch_ts, threadcnt, a['GRPID'],a['QID']))
                # ubex.runGrp( connname, a['GRPID'], a['QID'], '', '{0}-{1}'.format(us.batch_ts,threadcnt), logger )
                (t := Thread(target = ubex.runGrp_agent_thread, args=(connname,a['GRPID'], a['QID'], '', '{0}-{1}'.format(us.batch_ts,threadcnt), logger,) )).start()
                us.CronUpd(connname,a['GRPID'], a['QID'],str(base) ) # base содержит текущую дату/время
                time.sleep(2)
                threadcnt += 1
                pass
        except ValueError:
            logger.error('Batch {0}. GRPID.QID {1}.{2}. Ошибка конвертации: {3}'.format(us.batch_ts, a['GRPID'],a['QID'], ValueError.__doc__))
    logger.info('Batch {0} завершен...'.format(us.batch_ts))


if __name__ == "__main__":
    os.system('cls' if os.name == 'nt' else 'clear')
    main()