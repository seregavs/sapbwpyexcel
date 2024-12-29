import os, re, sys
import logging
from ubexreciever import UbexReciever
from ubexoper import UbexOperBase
from logging.handlers import TimedRotatingFileHandler
from logging import Logger, Formatter
# from importlib.metadata import  version
import __version__ as vr
from threading import Thread
from datetime import datetime
import locale

def runGrp( bwsystem, grpid, qid, uname, batch_ts: str, logger: Logger):
    if not batch_ts:
        batch_ts = re.sub('[^0-9]','', str(datetime.now().replace(microsecond=0)))
    if not logger:
        (logger := initLogger()).info('Batch {1} Uber Excel запущен. v{0}'.format(vr.__version__, batch_ts))
    logger.info('Batch {1} BW system = {0}'.format(bwsystem, batch_ts))
    logger.info('Batch {1} Group = {0}'.format(grpid, batch_ts)) 
    if qid != '':
        logger.info('Batch {1} Query = {0}'.format(qid, batch_ts)) 
    
    e_result = (reciever := UbexReciever(logger = logger, batch_ts = batch_ts)).getGrpDetail(bwsystem, grpid, qid, uname)
    if e_result:
        (ubexoper := UbexOperBase(bwsystem, grpid, qid, uname, batch_ts, logger)).run()
        del ubexoper
    logger.info('Batch {0} Uber Excel завершен'.format(batch_ts))
    del reciever
    del logger


def initLogger() -> Logger:
    logger = logging.getLogger(__name__)
    handler = TimedRotatingFileHandler(filename='runtime.log',\
                                       when='D', interval=1,\
                                       backupCount=3, encoding='utf-8', delay=False)
    formatter = Formatter(fmt='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    # add the handler to named logger
    logger.addHandler(handler)
    # set the logging level
    logger.setLevel(logging.INFO)
    return logger


def runGrp_agent():
    args = sys.argv[1:]
    if not args:
        runGrp('BWD', '1', '1', 'USER','', None)
    else:
        runGrp(args[0], args[1], args[2], 'USER','', None)    


def runGrp_agent_thread(connname: str, grpid: str, qid: str, uname: str, batch_ts: str, logger: Logger):
    if not grpid:
        print('GRPID не должно быть пустым')
        return
    if not connname:
        print('Connection не должно быть пустым')
        return
    runGrp(connname, grpid, qid, uname, batch_ts, logger) 


def main():
    # (t := Thread(target = runGrp_agent)).start()
    # print('Thread run successfully')
    # locale.setlocale(locale.LC_ALL, "ru")
    locale.setlocale(locale.LC_ALL, 'ru_RU.UTF-8')
    args = sys.argv[1:]
    if not args:
        runGrp('BWD', '1000', '1', 'USER','', None)
    else:
        runGrp(args[0], args[1], args[2], '','', None)      
    

if __name__ == "__main__":
    os.system('cls' if os.name == 'nt' else 'clear')
    main()