IATI-Websites
=============

This directory is for templates, configuration and issues that relate to IATI websites generally, and don't fit into any of the more specific repositories. e.g:

* The GitHub issues on this repository are used to report for any issue that relates to a website operated by the IATI Tech Team, but which doesn't fit into a more specific repository

* Themeing of IATI websites (part of the reason this is not in the SSOT repository is so that if someone else builds a copy of the Standard documentation it won't have the IATI branding)

* Apache redirect configs

* Salt states, and a salt config appropriate for using salt-ssh to deploy to our servers


Using salt-ssh
--------------

The ``salt`` directory in repository contains salt states, whereas ``salt-config`` contains our config for using these with salt-ssh.

Because the number of IATI servers is relatively small, we use the slower but easier method of salt provisioning, salt-ssh. Unlike some of the other approaches to salt provisioning where you need a publicly accessible server as the "master", salt-ssh can be run from your local machine.

In the IATI-Websites directory you can run:

.. code-block::

    salt-ssh --priv ~/.ssh/id_rsa -c salt-config <servername> <salt command>

(This may need to run as root, or the permissions on the salt cache directory changing. You will also need to have set up your public key for passwordless login on the server, see next section)

<servername> is defined in the roster (https://github.com/IATI/IATI-Websites/blob/master/salt-config/roster)

<salt command> may be:

state.highstate
    this deploys the states as defined in the top.sls file, e.g.

    .. code-block::

        salt-ssh --priv ~/.ssh/id_rsa -c salt-config <servername> state.highstate

state.sls
    this can be used to specify a single state explicitly, e.g.

    .. code-block::

        salt-ssh --priv ~/.ssh/id_rsa -c salt-config <servername> state.sls <statename> [<environment name>]``

pkg.upgrade
    to update the packages on the server. This is equivalent to ssh’ing in and running apt-get/aptitude update/upgrade manually.

We have two salt environments defined, base and dev. These currently point to the same state files, but these state files may behave differently if the environment is dev. (ie. using ``{% if saltenv == 'dev' %}``).

The top file (salt/top.sls) assigns each server to base or dev, and lists the states that should be set up when highstate is run.

Therefore, to set up the live dashboard server, we can do:

.. code-block:: bash

    salt-ssh --priv ~/.ssh/id_rsa -c salt-config 'iati-dashboard-live' state.highstate

This is current equivalent to:

.. code-block:: bash

    salt-ssh --priv ~/.ssh/id_rsa -c salt-config 'iati-dashboard-live' state.sls dashboard

(no environment name is specified as this is defined as dev)

Similarly to set up the dev dashboard server, we can do:

.. code-block:: bash

    salt-ssh --priv ~/.ssh/id_rsa -c salt-config 'iati-dashboard-dev' state.highstate

Which is currently equivalent to:

.. code-block:: bash

    salt-ssh --priv ~/.ssh/id_rsa -c salt-config 'iati-dashboard-dev' state.sls dashboard dev

(which needs to explicitly specify the dev environment!)

The nice thing about salt, and about using top.sls and state.highstate instead of state.sls directly is that we can update multiple differently configured servers at once, e.g.:

.. code-block:: bash

    salt-ssh --priv ~/.ssh/id_rsa -c salt-config '*' state.highstate

(although currently we aren’t using this much in practice because we have so few servers).

