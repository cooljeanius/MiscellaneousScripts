#!/bin/sh

launchctl list | colrm 1 16 | buthead 1 | sort | uniq
