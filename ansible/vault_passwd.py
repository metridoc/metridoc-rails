#!/usr/bin/env python
import os

if __name__ == '__main__':
    print(os.environ.get('ANSIBLE_VAULT_PASSWORD'))
