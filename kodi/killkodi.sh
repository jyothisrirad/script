#!/bin/sh

kill -9 $(ps aux | grep [k]odi | awk '{print $2}')
