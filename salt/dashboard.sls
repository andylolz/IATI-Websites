include:
  - base

dashboard:
  user.present:
    - home: /home/dashboard

/home/dashboard/.ssh/authorized_keys:
  file.append:
    - text: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7n9MjUge04UZm9qYJj9Us0W4aOg8mddkpcXT2RmPzoJwT7zmIvxbVT9+uX61Q/W/PNp8YMDyIZB1WNYHfdjs/72ePCY4bIWNueedDT/W8I255WEuvEDnus1HsaocUgLNEA17ZFn7QOhyPX2jpBIac0wSv+3Zm/Rpa5n+uMpdyrTZcQK2fq8PqM/GyUv6nB7YzLYGjEv4yiYfgNCo1tzh3/jhMncfHCkHrWKqQbuKhbNzyrflrOIqUUjvoXOvRuQXsiNvV0DL1g3MbBnNFBUU6vNhHwCDOG9aqitFPpDouOEe6k4cxRqEwzPUZKGEMUIIji5/2OEsYu4fjYq6+M7Az backups@webserver10
    - makedirs: True

registry-refresher-deps:
  pkg.installed:
    - pkgs:
      - git-core
      - php5-cli
      - php5-curl
      - libxml2-utils
      - gist
      - zip

git config --global user.name "Dashboard":
  cmd.run:
    - user: dashboard

git config --global user.email "code@iatistandard.org":
  cmd.run:
    - user: dashboard

/usr/bin/gist:
  file.symlink:
    - target: /usr/bin/gist-paste

https://github.com/IATI/IATI-Registry-Refresher.git:
  git.latest:
{% if saltenv == 'dev' %}
    - rev: master
{% else %}
    - rev: live 
{% endif %}
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

/home/dashboard/IATI-Registry-Refresher/zips:
  file.directory:
    - makedirs: True
    - user: dashboard
    - group: dashboard

stats-deps:
    pkg.installed:
        - pkgs:
            - python-pip
            - python-virtualenv
            - python-dev
            - libxml2-dev
            - libxslt1-dev
            - zlib1g-dev

# Branch name should probably be controlled by a grain
https://github.com/IATI/IATI-Stats.git:
  git.latest:
{% if saltenv == 'dev' %}
    - rev: master
{% else %}
    - rev: live 
{% endif %}
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
{% if saltenv == 'dev' %}
    - rev: master
{% else %}
    - rev: live 
{% endif %}
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

/home/dashboard/IATI-Dashboard/stats-blacklist:
    file.symlink:
        - target: /home/dashboard/IATI-Stats/stats-blacklist

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

/home/dashboard/full-dashboard-run.sh:
  file.managed:
    - source: salt://full-dashboard-run.sh
    - user: dashboard
    - mode: 755

/home/dashboard/logs:
  file.directory:
    - makedirs: True
    - user: dashboard
    - group: dashboard

/home/dashboard/full-dashboard-run.sh > /home/dashboard/logs/$(date +\%Y\%m\%d).log 2>&1:
  cron.present:
    - user: dashboard
    - minute: 1
{% if saltenv == 'dev' %}
    - hour: 6
{% else %}
    - hour: 0
{% endif %}

{% if saltenv != 'dev' %}
curl "http://iatiregistry.org/api/1/search/dataset?isopen=false&limit=200" | grep -o '"[^"]*"' | sed -e 's/"//g' -e 's/-.*//' | sort | uniq -c | gist -u 24beac7d23282f9b15f4 -f license_not_open:
  cron.present:
    - identifier: license-not-open-gist
    - user: dashboard
    - minute: 0
    - hour: 0
{% endif %}
