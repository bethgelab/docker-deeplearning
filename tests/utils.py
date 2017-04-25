import time


def assert_equal(a, b):
    """ Wrapper to enable assertions in lambdas
    """
    assert a == b
    return True


def assert_greater(a, b):
    """ Wrapper to enable assertions in lambdas
    """
    assert a > b
    return True


def wait_for_it(func, timeout=10, steps=0.1):
    """evaluate func repeatedly until it does not throw an assertion anymore
       or a timeout has been reached. Returns the function value of the first
       successful function evaluation
    """
    for i in range(int(timeout/steps)):
        try:
            return func()
        except AssertionError:
            pass
        time.sleep(steps)
    return func()


def wait_for_value(func, timeout=10, steps=0.1, wait_for_true=True, msg=None):
    """ Wait for function to evaluate to a true value or false value

       if wait_for_true==True, wait for a return value which evaluates to true.
          otherwise wait for a return value which evaluates to false.

       if msg is not None, it will be used as message for failed assertions
    """
    def _func():
        value = func()
        if msg:
            if wait_for_true:
                assert value, msg
            else:
                assert not value, msg
        else:
            if wait_for_true:
                assert value
            else:
                assert not value
        return value

    return wait_for_it(_func, timeout=timeout, steps=steps)
