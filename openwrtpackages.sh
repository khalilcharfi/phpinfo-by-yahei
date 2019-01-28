#!/usr/bin/env python
#coding=utf-8
#
# Openwrt Package Grabber
#
# Copyright (C) 2016 sohobloo.me
#

import urllib2
import re
import os
import time

# the url of package list page, end with "/"
#baseurl = 'https://downloads.openwrt.org/snapshots/trunk/ramips/mt7620/packages/'
baseurl = 'http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/'

# which directory to save all the packages, end with "/"
time = time.strftime("%Y%m%d%H%M%S", time.localtime())
savedir = './' + time + '/'
pattern = r'<a href="([^\?].*?)">'

cnt = 0
def fetch(url, path = ''):
    if not os.path.exists(savedir + path):
        os.makedirs(savedir + path)
    print 'fetching package list from ' + url
    content = urllib2.urlopen(url + path, timeout=15).read()
    items = re.findall(pattern, content) for item in items:
        if item == '../':
            continue
        elif item.endswith('/'):
            fetch(url, path + item)
        else:
            cnt += 1
            print 'downloading item %d: '%(cnt) + path + item
            if os.path.isfile(savedir + path + item):
                print 'file exists, ignored.'
            else:
                rfile = urllib2.urlopen(baseurl + path + item)
                with open(savedir + path + item, "wb") as code:
                    code.write(rfile.read())

fetch(baseurl)

print 'done!'
