import re
import pytest
import py
from _pytest.monkeypatch import monkeypatch

class TempdirFactory:
    """Factory for temporary directories under the common base temp directory.

    The base directory can be configured using the ``--basetemp`` option.
    """

    def __init__(self, config):
        self.config = config
        self.trace = config.trace.get("tmpdir")

    def ensuretemp(self, string, dir=1):
        """ (deprecated) return temporary directory path with
            the given string as the trailing part.  It is usually
            better to use the 'tmpdir' function argument which
            provides an empty unique-per-test-invocation directory
            and is guaranteed to be empty.
        """
        #py.log._apiwarn(">1.1", "use tmpdir function argument")
        return self.getbasetemp().ensure(string, dir=dir)

    def mktemp(self, basename, numbered=True):
        """Create a subdirectory of the base temporary directory and return it.
        If ``numbered``, ensure the directory is unique by adding a number
        prefix greater than any existing one.
        """
        basetemp = self.getbasetemp()
        if not numbered:
            p = basetemp.mkdir(basename)
        else:
            p = py.path.local.make_numbered_dir(prefix=basename,
                keep=0, rootdir=basetemp, lock_timeout=None)
        self.trace("mktemp", p)
        return p

    def getbasetemp(self):
        """ return base temporary directory. """
        try:
            return self._basetemp
        except AttributeError:
            basetemp = self.config.option.basetemp
            if basetemp:
                basetemp = py.path.local(basetemp)
                if basetemp.check():
                    basetemp.remove()
                basetemp.mkdir()
            else:
                temproot = py.path.local.get_temproot()
                user = get_user()
                if user:
                    # use a sub-directory in the temproot to speed-up
                    # make_numbered_dir() call
                    rootdir = temproot.join('pytest-of-%s' % user)
                else:
                    rootdir = temproot
                rootdir.ensure(dir=1)
                basetemp = py.path.local.make_numbered_dir(prefix='pytest-',
                                                           rootdir=rootdir)
            self._basetemp = t = basetemp.realpath()
            self.trace("new basetemp", t)
            return t

    def finish(self):
        self.trace("finish")


def pytest_configure(config):
    """Create a TempdirFactory and attach it to the config object.
    This is to comply with existing plugins which expect the handler to be
    available at pytest_configure time, but ideally should be moved entirely
    to the tmpdir_factory session fixture.
    """
    mp = monkeypatch()
    t = TempdirFactory(config)
    config._cleanup.extend([mp.undo, t.finish])
    mp.setattr(config, '_tmpdirhandler', t, raising=False)
    mp.setattr(pytest, 'ensuretemp', t.ensuretemp, raising=False)


@pytest.fixture(scope='session')
def tmpdir_factory(request):
    """Return a TempdirFactory instance for the test session.
    """
    return request.config._tmpdirhandler

@pytest.fixture(scope='session')
def testdir(tmpdir_factory):
    return tmpdir_factory.mktemp('test')

def pytest_runtest_makereport(item, call):
    if "incremental" in item.keywords:
        if call.excinfo is not None:
            parent = item.parent
            parent._previousfailed = item

def pytest_runtest_setup(item):
    if "incremental" in item.keywords:
        previousfailed = getattr(item.parent, "_previousfailed", None)
        if previousfailed is not None:
            pytest.xfail("previous test failed (%s)" %previousfailed.name)

