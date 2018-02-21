#!/usr/bin/env python3

'''
Program:      deploy_centos7.py
Author:       Jeff VanSickle
Created:      20171221

Program defines variables for and runs packer image creator

'''

import datetime
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-a', '--vars',
                    required=False,
                    type=str,
                    help='Vars file to feed to Packer'
                    )
parser.add_argument('-t', '--templ',
                    required=True,
                    type=str,
                    help='Packer template to run'
                    )
packer_args = parser.parse_args()

today = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
packer_op = os.getlogin()     # Entity running code
packer_exec = '/usr/local/bin/packer'     # Packer binary

# Construct command
if packer_args.vars:
    packer_cmd = '{} build -var-file={} -var \'creator={}\''
    '-var \'create_time={}\' {}'.format(
                                    packer_exec,
                                    packer_args.vars,
                                    packer_op,
                                    today,
                                    packer_args.templ
                                    )
else:
    # Maybe variables are defined within the template.
    packer_cmd = '{} build -var \'creator={}\''
    '-var \'create_time={}\' {}'.format(
                                    packer_exec,
                                    packer_op,
                                    today,
                                    packer_args.templ
                                    )

# Output and execute
print(packer_cmd)
os.system(packer_cmd)
