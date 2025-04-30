#!/bin/sh

#start TMUX sessions to run load.

tmux new -d -s load121 '/pensandotools/scripts/client_iperf.sh bg 10.88.50.121'
tmux new -d -s load122 '/pensandotools/scripts/client_iperf.sh bg 10.88.50.122'
tmux new -d -s load123 '/pensandotools/scripts/client_iperf.sh bg 10.88.50.123'
tmux new -d -s load124 '/pensandotools/scripts/client_iperf.sh bg 10.88.50.124'
