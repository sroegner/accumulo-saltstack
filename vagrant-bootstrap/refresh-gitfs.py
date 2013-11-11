import os.path

try:
    import salt
    import salt.fileserver

    cfg = salt.config.apply_master_config()
    if 'cachedir' in cfg:
        gitfs_cachedir = os.path.join(cfg['cachedir'], 'gitfs')
        if not os.path.exists(gitfs_cachedir):
            os.makedirs(gitfs_cachedir)
    fileserver = salt.fileserver.Fileserver(cfg)
    refs_dir = os.path.join(gitfs_cachedir, 'refs')
    if not os.path.exists(refs_dir):
        fileserver.init()
        fileserver.update()
except ImportError:
    print "Something went wrong"

