Europe/London:
    timezone.system

dashboard:
  user.present:
    - home: /home/dashboard

stats-deps:
    pkg.installed:
        - pkgs:
            - git-core
            - python-pip
            - python-virtualenv
            - python-dev
            - libxml2-dev
            - libxslt-dev
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
            - libpng-dev
            - pkg-config

/home/dashboard/IATI-Dashboard/pyenv/:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: /home/dashboard/IATI-Dashboard/requirements.txt
        - require:
            - pkg: stats-deps
            - pkg: dashboard-deps

# Get some data
#git://vagranthost/:
#  git.latest:
#    - target: /home/dashboard/IATI-Stats/data
#    - user: dashboard

/home/dashboard/IATI-Stats/helpers/get_schemas.sh:
    cmd.run:
        - cwd: /home/dashboard/IATI-Stats/helpers/

/home/dashboard/IATI-Stats/helpers/get_codelist_mapping.sh:
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

curl http://dashboard.iatistandard.org/stats/ckan.json > /home/dashboard/IATI-Stats/helpers/ckan.json:
    cmd.run
