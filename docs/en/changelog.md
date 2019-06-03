---
layout: default
title: Change Log/History
pagename: changelog
lang: en
---

Change Log/History
------------------

See also the [GitHub Releases page][releases]

[releases]: https://github.com/wwfxuk/tk-doc-generator/releases

# v1.0.0+wwfx.0.2.0

- Changed all/most docs links to WWFX UK versions.
- Altered shield badges to use `docs` label:
    [![Doc Generator](https://img.shields.io/badge/docs-WWFX%20SG%20Doc%20Generator-blue.svg)](http://github.com/wwfxuk/tk-doc-generator)

    ```
    [![Doc Generator](https://img.shields.io/badge/docs-WWFX%20SG%20Doc%20Generator-blue.svg)](http://github.com/wwfxuk/tk-doc-generator)
    ```

# v1.0.0+wwfx.0.1.0

Added this change log as well as minor fixes:

- `.travis.yml`: Changed to WWFX UK `DOC_URL`
- `Dockerfile`: Fixed `yum clean all` from being part of the `yum install` arguments
- `build_docs.sh`: Fixed permissions of generated docs from just `root` only
- `travis-generate-docs.py`: Fallback to `DOC_*` before using dummy URL.

# v1.0.0

Initial release from Shotgun, nothing mentioned by Shotgun.