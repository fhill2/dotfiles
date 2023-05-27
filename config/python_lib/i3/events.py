from i3ipc import Connection, Event
from f.util import dump_out, dump, log
import json, time
i3 = Connection()

# https://i3wm.org/docs/ipc.html#_available_events

def subscribe_until(*args, **kwargs):
    return subscribe(*args, **kwargs, until=True)

def subscribe(event_name, cb=None, cli=None, until=None):
    """waits / blocks until an i3 ipc event happens"""
    """note this quits once it has received 1 event from the given event"""
    """use subscribe to continually listen"""
    """until=True --> on the first event received - quit"""
    def event_handler(self, data):
        if until:
            i3.main_quit()
        global response
        response = data
        if cli:
            # if cli - this function is being called from a shell script
            # just echo the new window i3 ipc data
            # warning: adjusting this will break scripts i3_preview_startup.sh
            print(json.dumps(response.ipc_data["container"]))

    i3.on(getattr(Event, event_name), event_handler)
    if "cb" in locals():
        cb()

    i3.main() 
    return response.container



def subscribe_log():
    """subscribes to all i3 ipc events and logs them to log location"""
    """this will not quit by itself"""
    log(f"========== i3_subscribe_debug startup ==========")

    def log_handler(_, data):
        log("=============================")
        log(dump_out(data))

    for event in Event._subscribable_events:
        i3.on(event, log_handler)
    i3.main()
