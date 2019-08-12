import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def test_creates_config_directory(host):
    f = host.file('/root/deployments/metridoc/metridoc')

    assert f.is_directory


def test_copies_docker_compose_file(host):
    f = host.file('/root/deployments/metridoc/metridoc/docker-compose.yml')

    assert f.is_file
