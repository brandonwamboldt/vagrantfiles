Getting Started With Vagrant
============================

[Vagrant](http://www.vagrantup.com/) is a brilliant piece of software that allows you to create a new virtual machine based on a config file, called the `Vagrantfile`, written in Ruby. It can then provision the VM using the provisioning system of your choice.

We use Vagrant + Puppet to create disposable, identical development environments.

Installing Vagrant
------------------

1. Install [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your platform
2. Download the extension pack (Oracle VM VirtualBox Extension Pack) for all supported platforms, and install it by double clicking on the downloaded file once VirtualBox has been installed.
3. Navigate to the [Vagrant website](http://www.vagrantup.com/), and click Download. Download the newest version for your operating system.
4. Install Vagrant using the installer you downloaded

Spinning Up Your VM
-------------------

1. Clone this repository to your local computer using your Git client of choice
2. Open up the folder you put the repository in with the command prompt or Cygwin.
3. Type `vagrant up`, and wait for Vagrant to provision the virtual machine. This may take a while.
4. Navigate to `http://localhost:5000` in your web browser

phpMyAdmin
----------

phpMyAdmin is installed at port 5001, and can be accessed via `http://localhost:11001`.

SSH Access
----------

If you require SSH access to your virtual machine, it's as simple as running `vagrant ssh`. You can switch to the root user via `sudo su`. No password is required.

The project source code will be mounted at `/var/www/html/wordpress`.

Apache Log Files
----------------

If you want to look at the Apache/PHP log files, simply SSH into your VM, and run the following command:

```
tail -f /var/log/apache2/error.log
```

Suspending/Resuming Your VM
---------------------------

If you wish to suspend your VM, simply run `vagrant suspend`.

You may later resume your VM using `vagrant resume`.

Cleaning Up Your VM
-------------------

If you wish to destroy your VM to free up disk space, simply run `vagrant destroy`. This will **not** delete any files in your repository folder.

You can later run `vagrant up` to create a new virtual machine.