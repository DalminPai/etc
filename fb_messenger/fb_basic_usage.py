#!/usr/bin/python

#------------------------------------------------------------
#
#   Description: The messenger from machine using facebook chat
#
#
#   Author: Woochun Park
#           Dalmin Pai
#
#
#   Note:
#         1. If fbchat is not installed in your machine,
#              then you should install it by following below commands.
#
#            $ pip install fbchat
#
#            OR
#
#            $ git clone https://github.com/carpedm20/fbchat.git
#            $ cd fbchat
#            $ python setup.py install
#
#         2. You need two facebook accounts. (The main and assistant)
#            The assistant account will send a message to the main one.
#
#
#   Reference: https://github.com/carpedm20/fbchat/tree/master/examples
#
#------------------------------------------------------------

import os,sys

from fbchat import Client
from fbchat.models import *

## -- client = Client('<email>', '<password>') -- ##
main_client = Client('dalminpai93@gmail.com', 'dal.min.pai.93')
assistant_client = Client('john.316.galatians.220@gmail.com', 'house.m.d')

## -- message -- ##
'''
message="""
=======
From {0}

Hi me!
This log message is test.
Facebook message.

To {1}
=======
""".format(assistant_client.email, main_client.email)
'''

f = open( "%s" % sys.argv[1], 'r' )
message = f.read()
f.close()

## -- send message to the main client from the assistant client -- ##
assistant_client.send(Message(text=message), thread_id=main_client.uid, thread_type=ThreadType.USER)

## -- logout -- ##
main_client.logout()
assistant_client.logout()
