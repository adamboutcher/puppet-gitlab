# Gitlab Puppet module
A very simple gitlab puppet module, to install gitlab-ce and gitlab-runner. It can do basic configuration for gitlab-runner.

## How to use
```
cd /etc/puppetlabs/code/environments/production/modules/
git clone https://github.com/adamboutcher/puppet-gitlab.git gitlab
rm -rf gitlab/.git
```
Ensure params.pp looks sane.
Add gitlab::gitlab_ce or gitlab::runner to your system.

## 
