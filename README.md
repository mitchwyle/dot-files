# README.md

Set up a new Linux virtual machine & my account:

## Bootstrap: sudo and set environment variables for my editor

Manually add to ~/.profile and /root/.profile

```bash
export EDITOR=vi
export VISUAL=vi
```

### No password sudo: add to the *bottom* of /etc/sudoers

```bash
$ sudo su - root
$ visudo

mitch ALL=(ALL:ALL) ALL
mitch ALL NOPASSWD: ALL
```

## Install git

```bash
$ apt-get install git-all
$ git config --global user.name "mitch"
$ git config --global user.email "mitch@mydomain.com"
$ git config --global color.ui true
$ git config --global core.editor vi
$ ssh-keygen -t rsa -C "mitch@mydomain.com"
$ cat ~/.ssh/id_rsa.pub
```

Copy the public key text into your clipboard and web in to github.com to add the key to your github account.

## Keep this distro up-to-date daily

```bash
$ sudo su - root
# cat > .crontab
1 1 * * * ( apt-get update -y >& /dev/null && apt-get upgrade -y >& /dev/null )
^D
# crontab .crontab
