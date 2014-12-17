Europe/London:
    timezone.system

/root/.ssh/authorized_keys:
  file.append:
    - text: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt/aeDYnB9X83BV3d30ntgLqXRApEZ+7vvKdC84B9nxO30ZZ+TNThUjFkW3x+1I04/p4rmkYx2e5LdpZLMpqLzIvixel318BzMf5K4E8qBkgChk3BVD65PmhTIWyv+BdYiMLdJsv9N699yFqfLhxgU7rxnCbmjIFhOzBDcsaa2h88SFvTRYxC0rITjt4jZyFgUHj+5Sw2i/HnwaojyvooHQ+aZrXRY9hazWsFunijZ/SgOsvHgUl4MiSj2Lv4zD36vLvmJJ1CJhpe6Vzqpc6ymCmjm5IU7XfHs4AvqIFoIJdbXJMgaJO4uhBDUINrBON8WhfEpmKgN2LFohVdbH5AN bjwebb@webbpad 
    - makedirs: True

dashboard:
  user.present:
    - home: /home/dashboard

git config --global user.name "Dashboard":
  cmd.run

git config --global user.email "code@iatistandard.org":
  cmd.run

registry-refresher-deps:
  pkg.installed:
    - pkgs:
      - php5-cli
      - php5-curl
      - libxml2-utils
      - gist

/usr/bin/gist:
  file.symlink:
    - target: /usr/bin/gist-paste

https://github.com/IATI/IATI-Registry-Refresher.git:
  git.latest:
    - rev: master
    - target: /home/dashboard/IATI-Registry-Refresher
    - user: dashboard

/home/dashboard/.netrc:
  file.managed:
    - source: salt://dashboard-netrc
    - user: dashboard
    - template: jinja

https://github.com/idsdata/IATI-Urls-Snapshot.git:
  git.latest:
    - rev: master
    - target: /home/dashboard/IATI-Registry-Refresher/urls
    - user: dashboard

/home/dashboard/IATI-Registry-Refresher/ckan:
  file.directory:
    - makedirs: True
    - user: dashboard
    - group: dashboard

stats-deps:
    pkg.installed:
        - pkgs:
            - git-core
            - python-pip
            - python-virtualenv
            - python-dev
            - libxml2-dev
            - libxslt1-dev
            - zlib1g-dev

#superscript > /tmp/crontest:
#  cron.present:
#    - identifier: STATS
#    - user: dashboard
#    - minute: 1
#    - hour: 0

# Branch name should probably be controlled by a grain
https://github.com/IATI/IATI-Stats.git:
  git.latest:
    - rev: master
    - target: /home/dashboard/IATI-Stats
    - user: dashboard

/home/dashboard/IATI-Stats/pyenv/:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: /home/dashboard/IATI-Stats/requirements.txt
        - require:
            - pkg: stats-deps
            

https://github.com/IATI/IATI-Dashboard.git:
  git.latest:
    - rev: master
    - target: /home/dashboard/IATI-Dashboard
    - user: dashboard

dashboard-deps:
    pkg.installed:
        - pkgs:
            - libfreetype6-dev
            - libpng12-dev
            - pkg-config

/home/dashboard/IATI-Dashboard/pyenv/:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: /home/dashboard/IATI-Dashboard/requirements.txt
        - require:
            - pkg: stats-deps
            - pkg: dashboard-deps

/home/dashboard/IATI-Dashboard/config.py:
    file.managed:
        - source: salt://dashboard-config.py
        - user: dashboard
        - template: jinja

/home/dashboard/IATI-Stats/data:
  file.symlink:
    - target: /home/dashboard/IATI-Registry-Refresher/data
    - user: dashboard

/home/dashboard/IATI-Stats/helpers/ckan:
  file.symlink:
    - target: /home/dashboard/IATI-Registry-Refresher/ckan
    - user: dashboard

/home/dashboard/IATI-Stats/helpers/get_schemas.sh:
    cmd.run:
        - cwd: /home/dashboard/IATI-Stats/helpers/

/home/dashboard/IATI-Stats/helpers/get_codelist_mapping.sh:
    cmd.run:
        - cwd: /home/dashboard/IATI-Stats/helpers/

/home/dashboard/IATI-Stats/helpers/get_codelists.sh:
    cmd.run:
        - cwd: /home/dashboard/IATI-Stats/helpers/

https://github.com/IATI/IATI-Rulesets.git:
    git.latest:
        - rev: version-1.05
        - target: /home/dashboard/IATI-Stats/IATI-Rulesets/
        - user: dashboard

/home/dashboard/IATI-Stats/helpers/rulesets:
    file.symlink:
        - target: /home/dashboard/IATI-Stats/IATI-Rulesets/rulesets

/home/dashboard/IATI-Dashboard/stats-calculated:
    file.symlink:
        - target: /home/dashboard/IATI-Stats/gitout

webserver-deps:
    pkg.installed:
        - pkgs:
            - apache2

/etc/apache2/sites-available/new.dashboard.conf:
  file.managed:
    - source: salt://dashboard-apache

/etc/apache2/sites-enabled/new.dashboard.conf:
    file.symlink:
        - target: /etc/apache2/sites-available/new.dashboard.conf

apache2:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/sites-available/new.dashboard.conf

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

