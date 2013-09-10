ExpressJS Starter Template
==========================

This is a Vagrant starter template for Node.js/Express websites. The following items are setup/installed:

* Node.js 0.10.18
* Express 3.3
* Async.js, Lodash, Request.js
* Grunt
* Nodemon

Setup
-----

Git clone this repository to your local machine, navigate to the directory you cloned it to, and run `vagrant up`. Initial configuration will probably take 10 minutes. Once this is complete, you can go to [localhost:5000](http://localhost:4000/) to access the Express application. You should see "Hello, World!".

Project Structure
-----------------

The majority of your code is in the `app/` folder. The top level folder is reserved for tools and configs, like your `Vagrantfile`, `package.json`, `Gruntfile.js` files, etc.

Node modules are excluded from Git by default.