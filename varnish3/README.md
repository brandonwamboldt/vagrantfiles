Varnish 3 Dev
=============

This is a Vagrant setup for developing Varnish 3 extensions & configuration. The following items are setup/installed:

* [Varnish 3](https://www.varnish-cache.org/)
* [Varnish Agent 2](https://www.varnish-cache.org/utility/varnish-agent-2)
* Tools required to compile & install most vmods

Project Structure
-----------------

The `/varnish` folder is mounted to `/etc/varnish` using shared folders. You will manually need to restart Varnish when you change VCL config files however.

The `/html` folder is mounted to `/var/www/html` and is used by Nginx to serve files.

The `/dashboard` folder is mounted to `/var/www/dashboard` and is used by the Varnish Agent dashboard.

The backend is powered by Nginx + PHP to allow you to easily mess around with outputting cache control headers from your application as well as dynamic content. You could also change Varnish to use one of the other Vagrant environments as a backend.

Setup
-----

### 1. Installing Vagrant & VirtualBox

Before getting started, you must have the Vagrant software as well as VirtualBox installed. Both of these products are compatible with Windows, Mac OS X, and Linux. They are both free software as well.

1. Install [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your platform
2. Download the extension pack (Oracle VM VirtualBox Extension Pack) for all supported platforms, and install it by double clicking on the downloaded file once VirtualBox has been installed.
3. Navigate to the [Vagrant website](http://www.vagrantup.com/downloads.html) downloads page, and download the appropriate package for your OS
4. Install Vagrant using the installer you downloaded

Vagrant is a command line tool and has no GUI. You should now have access to the `vagrant` command from the command line.

### 2. Start Your Local Development Environment

Now that you have Vagrant and VirtualBox installed, you should create the Vagrant virtual machine. Once created initially, you will be able to keep the virtual machine, starting or stopping it, reloading it, etc. Unless manually destroyed, virtual machines are persistent.

1. Clone the `vagrantfiles` repository to your local computer using your Git client of choice
2. Open the command prompt/terminal
3. Navigate to the `vagrantfiles` repository you checked out (e.g. `cd ~/Downloads/vagrantfiles/ubuntu1404`)
4. Run the command `vagrant up`, and wait for Vagrant to provision the virtual machine. This should take ~5 minutes, longer if you have never used Vagrant before, as it has to download the Ubuntu box.
5. Navigate to http://localhost:18000 to confirm Varnish is working, http://localhost:18001 goes directly to Nginx, http://localhost:18002 goes to the Varnish Agent dashboard (user: vagent, password: vagent)

Getting Started With Vagrant
----------------------------

### SSH Access

If you require SSH access to your virtual machine, it's as simple as running `vagrant ssh`. You can switch to the root user via `sudo su`. No password is required.

You can access files from this folder (via shared folders) using `/vagrant`.

### Updating The VM

If you've updated your puppet provisioning scripts, you can re-apply them by running `vagrant provision`. This will do a delta, and will not re-execute commands that have already run (e.g. installing packages).

If the `Vagrantfile` was changed, you will need to restart your VM to apply the changes. Simply run `vagrant reload` to power cycle the VM.

### Suspending/Resuming Your VM

If you wish to suspend your VM, simply run `vagrant suspend`.

You may later resume your VM using `vagrant resume`.

### Shutdown Your VM

If you simply want to turn off your VM temporarily, run `vagrant halt`.

If your VM is not responsive for some reason, use the force option with `vagrant halt -f`.

To bring your VM back up, use `vagrant up`. Running `vagrant up` on a VM that has already been provisioned will **not** reprovision the VM.

### Destroying Your VM

If you wish to destroy your VM to free up disk space, simply run `vagrant destroy`. This will not delete any files in your repository folder.

You can later run `vagrant up` to create a new virtual machine.
