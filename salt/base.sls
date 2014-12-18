Europe/London:
    timezone.system

/root/.ssh/authorized_keys:
  file.append:
    - text: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt/aeDYnB9X83BV3d30ntgLqXRApEZ+7vvKdC84B9nxO30ZZ+TNThUjFkW3x+1I04/p4rmkYx2e5LdpZLMpqLzIvixel318BzMf5K4E8qBkgChk3BVD65PmhTIWyv+BdYiMLdJsv9N699yFqfLhxgU7rxnCbmjIFhOzBDcsaa2h88SFvTRYxC0rITjt4jZyFgUHj+5Sw2i/HnwaojyvooHQ+aZrXRY9hazWsFunijZ/SgOsvHgUl4MiSj2Lv4zD36vLvmJJ1CJhpe6Vzqpc6ymCmjm5IU7XfHs4AvqIFoIJdbXJMgaJO4uhBDUINrBON8WhfEpmKgN2LFohVdbH5AN bjwebb@webbpad 
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
