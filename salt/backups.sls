include:
  - base

backups:
  user.present:
    - home: /home/backups/

git-core:
  pkg.installed

git clone -n dashboard@webserver9.iatistandard.org:/home/dashboard/IATI-Registry-Refresher/data/.git dashboard-snapshot-data:
  cmd.run:
    - user: backups
    - cwd: /home/backups
    
cd /home/backups; git fetch:
  cron.present:
    - identifier: backup-dashboard
    - user: backups
    - minute: 0
    - hour: 12
