#!/bin/bash
# Forwards the delayed_job logs to the Docker logs.
set -e
if [[ ! -e /home/app/webapp/log/delayed_job.log ]]; then
    touch /home/app/webapp/log/delayed_job.log
fi

exec tail -F /home/app/webapp/log/delayed_job.log
