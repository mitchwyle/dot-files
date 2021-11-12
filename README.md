# README.md

Set up a new Linux virtual machine & my account:

## Bootstrap: sudo and set environment variables for my editor

Manually add to ~/.profile and /root/.profile

```bash
export EDITOR=vi
export VISUAL=vi
```

```bash
sudo su - root
visudo
```
mitch ALL=(ALL:ALL) ALL
mitch ALL NOPASSWD: ALL

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
