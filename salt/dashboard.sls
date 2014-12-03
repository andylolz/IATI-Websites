Europe/London:
    timezone.system

/root/.ssh/authorized_keys:
  file.append:
    - text: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt/aeDYnB9X83BV3d30ntgLqXRApEZ+7vvKdC84B9nxO30ZZ+TNThUjFkW3x+1I04/p4rmkYx2e5LdpZLMpqLzIvixel318BzMf5K4E8qBkgChk3BVD65PmhTIWyv+BdYiMLdJsv9N699yFqfLhxgU7rxnCbmjIFhOzBDcsaa2h88SFvTRYxC0rITjt4jZyFgUHj+5Sw2i/HnwaojyvooHQ+aZrXRY9hazWsFunijZ/SgOsvHgUl4MiSj2Lv4zD36vLvmJJ1CJhpe6Vzqpc6ymCmjm5IU7XfHs4AvqIFoIJdbXJMgaJO4uhBDUINrBON8WhfEpmKgN2LFohVdbH5AN bjwebb@webbpad 
    - makedirs: True

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

curl http://dashboard.iatistandard.org/stats/ckan.json > /home/dashboard/IATI-Stats/helpers/ckan.json:
    cmd.run

/home/dashboard/IATI-Dashboard/stats-calculated:
    file.symlink:
        - target: /home/dashboard/IATI-Stats/gitout

