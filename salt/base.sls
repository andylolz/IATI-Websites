Europe/London:
    timezone.system

/root/.ssh/authorized_keys:
  file.append:
    - text: 
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMi9klh9K4SEnxectpdwuvXkaThjI+uJNBAV92W21A0Jwk/albQc1c8gZ+k4GN6DqJA2wV9xLw/DcPmXTiIY1can+JYg/wwK/gn3WzKyhDCHRcATefz4bnDY3e1Bq/JHz5T5+ExNXCKEO6rz0sj/4OD7vvlXjYhWYc6rG017WXATcxuBJUAK57dup9UcBy4KRJt2OfX4/EmZCvs7ZxrQPbgnVsDqkAyg7q8Mm52u5MrrFZYX/kS4h2GTekkQ+esVBAHBwqz60yaxzQ7rlSf3Mq5OIkw44+tOKNp/PRO4Cpg9Q09J5IC8qe8aGdnzJPdo2rbbKGBx9z61z1dtSxnewx dale.potter@devinit.org
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5ycH8hrpuZqSuCpU28D36hG7DclDOO40W4Cj6wA6a4oIzBLUEHDDK2Yk5wMBsRQLSYl8WaZKsudfy4+00a9MeM9oTQMin0Fw+nC5ruthgFX9aQuvJhMchLAG+PrC01CiLLXOAefFAmCDw9HbT/6Bz/GqMOmVA0YZYLm+qWWHjmihbCjM9aJ6JELbTMMxP2vedlzZqsaU9Tky0OGsOsSfh8QtPzAyb7pnU+QyLI22Xkdtnd0OaLKwKLGMrWi/XJSyEdgolSig0gJ0B81acj5tNC/DTCttQ9LnSEs+1+kU3YBQo1pwbcWFdTLyISqvN+iwZVAKbFvkdWlVHDrFlKoWr roryscott@Rorys-MacBook-Pro-2.local
    - makedirs: True

basic-server-deps:
    pkg.installed:
        - pkgs:
            - unattended-upgrades

/etc/apt/apt.conf.d/50unattended-upgrades:
  file.managed:
    - source: salt://50unattended-upgrades

/etc/apt/apt.conf.d/10periodic:
  file.managed:
    - source: salt://10periodic
