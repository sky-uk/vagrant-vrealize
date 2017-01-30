# Vagrant VRealize Provider

This is a [Vagrant](http://www.vagrantup.com) 1.2+ plugin that adds a VMware vRealize Automation 
provider to Vagrant, allowing Vagrant to control and provision machines in
VRealize.

**NOTE:** This plugin requires Vagrant 1.2+,

**NOTE MORE:** This plugin is a work in progress.  The basics work, but it's
not as fully-featured as the `vagrant-aws` plugin it's largely based on.

## What works

* Boot VRealize instances.
* SSH into the instances.
* Provision the instances with any built-in Vagrant provisioner.
* Minimal synced folder support via `rsync`.

## Usage

Install using standard Vagrant 1.1+ plugin installation methods. After
installing, `vagrant up` and specify the `vrealize` provider. An
example is shown below.

```
$ vagrant plugin install vagrant-vrealize
...
$ vagrant up --provider=vrealize
...
```

Of course, prior to doing this, you'll need to obtain a
VRealize-compatible box file for Vagrant.

## Quick Start

After installing the plugin (instructions above), the quickest way to get
started is to actually use the dummy VRealize box and specify all the details
manually within a `config.vm.provider` block. So first, build the box:

```
$ rake box
$ vagrant box add --provider vrealize example_box/vrealize.box
```

And then make a Vagrantfile that looks like the following, filling in
your information where necessary.

```
Vagrant.configure("2") do |config|
  config.vm.box = "vrealize"

  config.vm.provider :vrealize do |vrealize, override|
    # Note: you'll need to make sure your environment variables
    # are set up correctly for this bit...
    vrealize.vra_username = ENV['USER']
    vrealize.vra_password = ENV['PASSWORD']
    vrealize.vra_tenant   = ENV['VRA_TENANT']
    vrealize.vra_base_url = ENV['VRA_BASE_URL']

    # From here on are configuration settings for the specific VM
    # we're creating

    vrealize.requested_for = ENV['VRA_AD_USER']

    vrealize.subtenant_id = SOME_GUID
    vrealize.catalog_item_id = SOME_CATALOG_ID

    vrealize.add_entries do |extras|
      # This isn't actually needed, it's just here to show how to set custom
      # request data
      extras.string('provider-Vrm.DataCenter.Location', '')
    end


    override.ssh.username = "root"
    override.ssh.password = SOMETHING_SENSIBLE_HERE
  end
end
```

And then run `vagrant up --provider=vrealize`.

## Networks

Networking features in the form of `config.vm.network` are not
supported with `vagrant-vrealize`, currently. If any of these are
specified, Vagrant will emit a warning, but will otherwise boot
the VRealize machine.

## Synced Folders

There is minimal support for synced folders. Upon `vagrant up`,
`vagrant reload`, and `vagrant provision`, the Vrealize provider will
use `rsync` (if available) to uni-directionally sync the folder to the
remote machine over SSH.

See [Vagrant Synced folders: rsync](https://docs.vagrantup.com/v2/synced-folders/rsync.html)


## Development

To work on the `vagrant-vrealize` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

```
$ bundle
```

If those install, you're ready to start developing the plugin. You can test
the plugin without installing it into your Vagrant environment by just
creating a `Vagrantfile` in the top level of this directory (it is gitignored)
and add the following line to your `Vagrantfile`

```ruby
Vagrant.require_plugin "vagrant-vrealize"
```
Use bundler to execute Vagrant:
```
$ bundle exec vagrant up --provider=vrealize
```

[![Dependency Status](https://dependencyci.com/github/sky-uk/vagrant-vrealize/badge)](https://dependencyci.com/github/sky-uk/vagrant-vrealize)

## And Finally

This plugin is an unfinished work-in-progress. It (and large parts of
this document) are based on Mitchell Hashimoto's `vagrant-aws` plugin,
which can be found here: https://github.com/mitchellh/vagrant-aws.

## Author

Alex Young <Alexander.Young@sky.uk>
Please get in touch, raise issues, make pull requests, if you're trying to use this and running into problems.
