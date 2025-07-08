#!/bin/bash
# Forwards the delayed_job logs to the Docker logs.
set -e
if [[ ! -e /home/app/log/delayed_job.log ]]; then
    touch /home/app/log/delayed_job.log
fi

exec tail -F /home/app/log/delayed_job.log
