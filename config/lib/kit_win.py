from typing import List
from kitty.boss import Boss
from kittens.tui.loop import debug

import logging
logging.basicConfig(
    level=logging.INFO,
    filename='/home/f1/logs/kitty.log',
    filemode='a',
    format='%(asctime)s %(message)s',
    datefmt='%H:%M:%S'
)

# logging.info("ASDASD")
def p(s):
    logging.info(s)
    
def x(self):
    p(self)
    p('it ran this')

def main(args: List[str]) -> str:
    p('kitten launched')
    from kitty.main import run_app, main as real_main

    from kitty import kitty
    p(kitty)
    run_app.first_window_callback = x
    #run_app.initial_window_size_func = initial_window_size_func
    real_main()
    

    #return answer

def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    # get the kitty window into which to paste answer
    #w = boss.window_id_map.get(target_window_id)
    #if w is not None:
    #    w.paste(answer)

    from kittens.tui.loop import debug
    debug('whatever')




