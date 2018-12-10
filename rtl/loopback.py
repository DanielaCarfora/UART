#!/usr/bin/env python3
# Copyright (c) 2017 Angel Terrones <aterrones@usb.ve>

import myhdl as hdl
from rtl.uart.uart import UART
from rtl.fifo.fifo import FIFO
from rtl.driver7seg import driver7seg
from coregen.utils import createSignal
from coregen.utils import log2up


@hdl.block
def Loopback(clk_i, rst_i, rx_i, tx_o, anodos_o, segmentos_o, FIFO_DEPTH=1024, CLK_BUS=50_000_000, BAUD_RATE=115200):

    tx_dat = createSignal(0,8) # entrada tx_dat_i del UART
    tx_start = createSignal(0,1) # entrada tx_start_i del UART
    tx_ready = createSignal(0,1) # salida tx_ready_o del UART
  	rx_ready = createSignal(0,1) # salida rx_ready_o del UART
  	rx_dat = createSignal(0,8) # salida rx_dat_o del UART y entrada dat_i del FIFO
  	enqueue = createSignal(0,1) # entrada enqueue_i del FIFO
  	dequeue = createSignal(0,1) # entrada dequeue_i del FIFO
  	empty = createSignal(0,1) #salida empty_o del FIFO
  	full = createSignal(0,1) # salida full_o del FIFO
  	dat = createSignal(0,1) # entrada dat_i del tx
  	value = createSignal(0,1) # salida count_o del FIFO y entrada value_i del Driver7Seg 
  	l_state = hdl.enum('IDLE','DATA')
  	state = hdl.Signal(l_state.IDLE)

    uart = UART(clk_i =clk_i , rst_i=rst_i,
         tx_dat_i = tx_dat, tx_start_i=tx_start, tx_ready_o = tx_ready, tx_o = tx_o,
         rx_dat_o =rx_dat, rx_ready_o=rx_ready, rx_i = rx_i,
         CLK_BUS=50_000_000,
         BAUD_RATE=115200)

    fifo = FIFO(clk_i=clk_i, rst_i=rst_i, 
    	enqueue_i=enqueue, dequeue_i=dequeue, dat_i=rx_dat, dat_o=dat, count_o=value, empty_o=empty, full_o=full, 
    	A_WIDTH=8, 
    	D_WIDTH=8)

    driver = driver7seg(clk_i=clk_i, rst_i=rst_i, 
    	value_i=value, anodos_o=anodos_o, segmentos_o=segmentos_o,
    	CLK_BUS=50_000_000)
    
    @hdl.always_seq(clk_i.posedge, reset=rst_i) 
    	def l_state_m():
    		if state == l_state.DATA:
    			if full or rx_dat == 0x0A:
    				tx_start.next = 0
    				state.next = l_state.DATA
    				enqueue = 0
    		elif state == l_state.DATA:
    			if tx_ready:
	    			dequeue.next = 1
	    			tx_start.next = 1
	    		if rx_ready:
	    			enqueue = 1
	    		if empty:
	    			dequeue = 0
    		else:
    			state.next = l_state.IDLE
    
    return hdl.instances()

# Local Variables:
# flycheck-flake8-maximum-line-length: 200
# flycheck-flake8rc: ".flake8rc"
# End:
