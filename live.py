#!/usr/bin/env python

sourcedir = 'source/'
builddir = 'build/'

def livehtml():

    from livereload import Server, shell

    server = Server()

    server.watch(sourcedir, 'make html')

    server.serve(root=builddir+'html',open_url=True)

def livepdf():

    import inotifyx, sys, os, time, subprocess
    sys.path.insert(0,sourcedir)
    from conf import basic_filename
    subprocess.call(['xdg-open',builddir+'latex/'+basic_filename+'.pdf'])

    fd = inotifyx.init()

    try:
        wd = inotifyx.add_watch(fd, sourcedir, inotifyx.IN_CLOSE_WRITE)
        try:
            while True:

                events = []
                events += inotifyx.get_events(fd,0)
                time.sleep(1)
                events += inotifyx.get_events(fd,0)

                names = set()
                for event in events:
                    if event.name and event.name[-3:-1] != 'sw' and event.name[-1] != '!':
                        names.add(sourcedir + event.name)
                if len(names) > 0:
                    print '%s modified' % ','.join(names)
                    env = dict(os.environ)
                    subprocess.call(['make','latexpdf'], env=env)

        except KeyboardInterrupt:
            pass

    finally:
        os.close(fd)
