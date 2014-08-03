#!/bin/sh

adb pull /sdcard/btsnoop_hci.log
wireshark btsnoop_hci.log
