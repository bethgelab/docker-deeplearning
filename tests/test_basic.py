import envoy
import executor
import requests

import pytest

from .utils import assert_equal, wait_for_it, wait_for_value


@pytest.fixture
def docker_container():
    name = 'test'
    print("deleting previous")
    executor.execute('docker rm {}'.format(name), check=False)
    yield name
    print("stopping")
    executor.execute('docker stop {}'.format(name), check=False)
    print("done")


def wait_for_container_up(container):
    def check_up():
        if container.is_finished:
            raise Exception('Container failed')

        return '?token' in container.decoded_stdout

    wait_for_value(check_up)


def test_command_as_root():
    r = envoy.run('docker run -t bethgelab/deeplearning-test echo "hello as root"')
    assert r.status_code == 0
    assert r.std_out.endswith("Running as default container user\nhello as root\n")


def test_command_as_local_user_manual():
    r = envoy.run('docker run -t -eUSER=testuser bethgelab/deeplearning-test whoami')
    assert r.status_code == 0
    assert r.std_out.endswith("Running as user testuser\ntestuser\n")


def test_command_as_root_failing():
    r = envoy.run('docker run -t bethgelab/deeplearning false')
    assert r.status_code != 0


def test_run_notebook(docker_container):
    container = executor.execute(
        'docker run -t -p8888:8888 --name={} bethgelab/deeplearning-test'.format(docker_container),
        async=True,
        capture=True)

    wait_for_container_up(container)

    response = requests.get('http://localhost:8888/')
    assert response.status_code == 200

    container.kill()


def _test_ssh(docker_container):
    container = executor.execute(
        'docker run -t -p8888:22 --name={} bethgelab/deeplearning-test'.format(docker_container),
        async=True,
        capture=True)

    wait_for_container_up(container)

    ssh = executor.execute('ssh -p 8888 localhost echo "foobar"')

    container.kill()
