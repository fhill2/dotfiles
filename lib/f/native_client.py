# connects to the native messaging socket
# python client to firefox native messaging host - browser extension

import socket, time, json
import struct
HOST = "127.0.0.1"  # The server's hostname or IP address
PORT = 10000  # The port used by the server

# with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

# #
# def get_response():
#     global s
#     raw_length = s.recv(4)
#     print(raw_length)
#     message_length = struct.unpack('=I', raw_length)[0]
#     data = s.recv(message_length).decode("utf-8")
#     if data == "":
#         print("no data returned")
#     return json.loads(data)
#

def get_response():
    global s
    conn = s
    data_size = struct.unpack('>I', conn.recv(4))[0]
    received_payload = b""
    reamining_payload_size = data_size
    while reamining_payload_size != 0:
        received_payload += conn.recv(reamining_payload_size)
        reamining_payload_size = data_size - len(received_payload)
    res = json.loads(received_payload)
    return res

def send(type, command, message):
    """ returns the type and data keys"""
    global s
        # if a message is sent that is not valid JSON, it 
    message = json.dumps({"type": type, "data": {
        "command": command,
        "message": message
        }}).encode("utf-8")
    message = struct.pack('>I', len(message)) + message
    s.sendall(message)
    return get_response()

def send_message(command, message):
    """only returns the data key"""
    res = send("message", command, message)
    return res["data"]

def verify(s):
    data = send("message", "test", "hello world") 
    if data["type"] != "success" and data["message"] != "hello world":
        print("exiting - did not receive a response from browser extension")
        exit()
    else:
        print("successfully tested connection")

verify(s)












# types: message, success, error



# def get_response():
#     global s
#     res = recv_msg(s)
#     if res is not None:
#         return json.loads(res.decode("utf-8"))

#
#
# import sys
# def recv_msg(sock):
#     try:
#         header = sock.recv(2)#Magic, small number to begin with.
#         while ":" not in header:
#             header += sock.recv(2) #Keep looping, picking up two bytes each time
#
#         size_of_package, separator, message_fragment = header.partition(":")
#         message = sock.recv(int(size_of_package))
#         full_message = message_fragment + message
#         return full_message.decode("utf-8")
#
#
#     except OverflowError:
#         return "OverflowError."
#     except:
#         print("Unexpected error:", sys.exc_info()[0])
#         raise
# def send_msg(sock, msg):
#     # Prefix each message with a 4-byte length (network byte order)
#     msg = struct.pack('>I', len(msg)) + msg
#     sock.sendall(msg)
 

# def recvall(sock, n):
#     # Helper function to recv n bytes or return None if EOF is hit
#     data = bytearray()
#     while len(data) < n:
#         packet = sock.recv(n - len(data))
#         if not packet:
#             return None
#         data.extend(packet)
#     return data
#
# def get_message(sock):
#     # Read message length and unpack it into an integer
#     raw_msglen = recvall(sock, 4)
#     if not raw_msglen:
#         return None
#     msglen = struct.unpack('>I', raw_msglen)[0]
#     # Read the message data
#     # data = json.loads(get(s).decode("utf-8"))
#     return json.loads(recvall(sock, msglen).decode("utf-8"))
#  



# time.sleep(200)


# send_message("add_bookmark", {"asd": "asd3"})
