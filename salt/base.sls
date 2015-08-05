Europe/London:
    timezone.system

/root/.ssh/authorized_keys:
  file.append:
    - text: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMi9klh9K4SEnxectpdwuvXkaThjI+uJNBAV92W21A0Jwk/albQc1c8gZ+k4GN6DqJA2wV9xLw/DcPmXTiIY1can+JYg/wwK/gn3WzKyhDCHRcATefz4bnDY3e1Bq/JHz5T5+ExNXCKEO6rz0sj/4OD7vvlXjYhWYc6rG017WXATcxuBJUAK57dup9UcBy4KRJt2OfX4/EmZCvs7ZxrQPbgnVsDqkAyg7q8Mm52u5MrrFZYX/kS4h2GTekkQ+esVBAHBwqz60yaxzQ7rlSf3Mq5OIkw44+tOKNp/PRO4Cpg9Q09J5IC8qe8aGdnzJPdo2rbbKGBx9z61z1dtSxnewx dale.potter@devinit.org
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
