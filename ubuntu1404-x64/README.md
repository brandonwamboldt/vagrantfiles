Ubuntu 14.04 x64 Sandbox
========================

This is a simple Vagrant environment running Ubuntu 14.04 which a few useful packages pre-installed. Useful if you just need a generic Linux environment or if you want to test something specifically on Ubuntu 14.04.

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
4. Run the command `vagrant up`, and wait for Vagrant to provision the virtual machine. This should take ~5 minutes, longer if you have never used Vagrant before, as it has to download the Ubuntu 14.04 box.

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
