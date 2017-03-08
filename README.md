Tensokukan Network
==================
**Q: Wait a second... What does "Ultraman edition" mean?**

A: Oh, nothing. I've just added thousands of Ultraman to it.

**Q: Then what exactly is Ultraman?**

A: ...A bit of this... A bit of that...

Introduction
------------
This repository is a part of Tensokukan 2017.

TskNet added some useful feature to tsk_report 0.04. The entire Tensokukan 2017 got too many of incompatible changes, so we renamed it and published as new software.

Feature
-------
- UTF-8 suppoort.
- "Encrypted" non-http protocol. (1)
- Built-in proxy support. (2)
- CDN friendly, able to use custom tenco server address.

(1): Not HTTPS, it's just a method to prevent HTTP plain text modified by unwanted third-party devices. It's not true to encrypt. It's not safer than HTTP.

(2): Still not support system proxy or socks5. It's called obfs4proxy.
