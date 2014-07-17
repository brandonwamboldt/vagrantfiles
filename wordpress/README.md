WordPress Starter Template
==========================

This is a Vagrant starter template for WordPress websites. The following items are setup/installed:

* PHP 5.4
* Apache web server
* phpMyAdmin
* WordPress 3.6
* TwentyThirteen
* WP-CLI
* Composer

Setup
-----

Git clone this repository to your local machine, navigate to the directory you cloned it to, and run `vagrant up`. Initial configuration will probably take 10 minutes. Once this is complete, you can go to [localhost:5000](http://localhost:5000/) to see your WordPress install, and [localhost:5001](http://localhost:5001) to use phpMyAdmin.

Project Structure
-----------------

The majority of your code including WordPress is in the `app/` folder. The top level folder is reserved for tools and configs, like your `Vagrantfile`, `composer.json`, `Gruntfile.js`, `package.json` files, etc.

All WordPress files are excluded from Git using a `.gitignore` file (files that are part of WordPress core).

How Do I Use Vagrant
--------------------

See our [guide on using Vagrant](docs/Vagrant.md).