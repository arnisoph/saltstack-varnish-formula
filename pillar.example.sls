apt:
  repos:
    varnish_upstream:
      url: https://repo.varnish-cache.org/debian/
      dist: {{ salt['grains.get']('oscodename') }}
      globalfile: True
      keyuri: https://repo.varnish-cache.org/debian/GPG-key.txt
      comps:
        - varnish-4.0

varnish:
  lookup:
    config:
      common:
        template_path: salt://varnish/files/profiles/repo/common.vcl
      backends:
        context:
          backends:
            aptly:
              host: repo.aptly.info
              probe:
                ensure: absent
            debsalt:
              host: debian.saltstack.com
            host:
              port: 8085
              host: host.domain.tld
              probe:
                ensure: absent
            elk:
              host: 107.22.222.16
              probe:
                request:
                  - 'GET / HTTP/1.1'
                  - 'Host: 107.22.222.16'
                  - 'Connection: close'
                expected_response: 302

      vcl_recv:
        template_path: salt://varnish/files/profiles/repo/vcl_recv.vcl
        context:
...
      vcl_backend_response:
        template_path: salt://varnish/files/profiles/repo/vcl_backend_response.vcl
