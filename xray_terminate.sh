#!/bin/sh /etc/rc.common
START=99
start() {
    echo -1 > /proc/$(pgrep xray)/oom_score_adj
}
