# This is a sample Python script for background traffic generation.

# pip3 install iperf3
# pip3 install pyyaml
# pip3 install netifaces

import iperf3
import yaml
import time, sys
from multiprocessing import Process
import multiprocessing
from yaml.loader import SafeLoader
import subprocess
import socket
# only needed for multihome machines.
# from netifaces import interfaces, ifaddresses, AF_INET

config_file = ('config.yml')
def startclient():
    dummycount = 0
    while dummycount < 1:
        dummycount = dummycount + 1

        with open(r'config.yml') as file:
            configdata = yaml.load(file, Loader=SafeLoader)
            common = configdata['common']
            ports = common['ports']
            loop = common['loop']
            sleep = common['sleep']
            count = 0
            client = configdata['client']
            clntiplist = client['ip']


            while count < loop:
                count = count + 1
                time.sleep(sleep)
                print("Run Number:", count)

                for clntip in clntiplist:
                    for value in ports:
                        # print(value)
                        print("connecting:", clntip, "->", value)

                        p = Process(target=clientconnecting, args=(clntip, value))
                        p.start()

    time.sleep(sleep)
    print("Run Complete")
    # exit()
    # quit()
    for p in multiprocessing.active_children():
       p.terminate()

def startserver():
    # Single Interfaced hosts
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    localsvrip = (s.getsockname()[0])
    print(localsvrip)
    dummycount = 0
    while dummycount < 1:
        dummycount = dummycount + 1


    # # Multihomed  Interfaced hosts
    # for ifaceName in interfaces():
    #     addresses = [i['addr'] for i in ifaddresses(ifaceName).setdefault(AF_INET, [{'addr': 'No IP addr'}])]
    #     # print(''.join(addresses))
    #     localsvrip = (''.join(addresses))
    #     print(localsvrip)

        with open(r'config.yml') as file:
            configdata = yaml.load(file, Loader=SafeLoader)
            server = configdata['server']
            svriplist = server['ip']
            common = configdata['common']
            ports = common['ports']

            for svrip in svriplist:

                if svrip == localsvrip:
                    for value in ports:
                        # print(value)
                        print("Listening on:", svrip, "->", value)

                        p = Process(target=serverlistening, args=(svrip, value))
                        p.start()

    print("Listeners started")

def stop():
    listeners_running = subprocess.check_output("ps -aef |grep 'main.py server'| grep -v grep  | wc -l",shell=True , universal_newlines=True)
    shutdown = int(listeners_running)
    dummycount = 0
    while dummycount < shutdown:
        dummycount = dummycount + 1
        subprocess.run("kill -9 `ps -aef |grep 'main.py server' | grep -v grep  |awk '{print $2}' |head -1`", shell=True)

    print("Listeners stopped")


def serverlistening(ipaddr,port):
    server = iperf3.Server()
    server.bind_address = ipaddr
    server.port = port
    server.verbose = True
    server.run()
    while True:
        server.run()


def clientconnecting(ipaddr,port):
    with open(r'config.yml') as file:
        configdata = yaml.load(file, Loader=SafeLoader)

        common = configdata['common']
        duration = common['duration']

        client = iperf3.Client()
        client.duration = duration
        client.server_hostname = ipaddr
        client.port = port
        client.protocol = 'tcp'

        result = client.run()

        if result.error:
            print(result.error)
        else:
            print('')
            print('Test completed:')



if __name__ == '__main__':
    if len(sys.argv) > 1:
        job = sys.argv[1]
        if job == "client":
           startclient()
        elif job == "server":
            startserver()
        elif job == "stop":
            stop()
        else:
            print("\n"
                  "Option to run the program are \n"
                  "As a server   \"python3 main.py server &\" \n"
                  "As a clinet   \"python3 main.py client &\" \n"
                  "Or to shutdown all the listeners    \"python3 main.py stop\" \n"
                  "\n"
                  "config.yml file controls the listening ports and server IP\n"
                  "as well as the servers you want this host to connect to\n"
                  "\n"

                  )

    else:
        print("\n"
              "Option to run the program are \n"
              "As a server   \"python3 main.py server &\" \n"
              "As a clinet   \"python3 main.py client &\" \n"
              "Or to shutdown all the listeners    \"python3 main.py stop\" \n"
              "\n"
              "config.yml file controls the listening ports and server IP\n"
              "as well as the servers you want this host to connect to\n"
              "\n"

              )
