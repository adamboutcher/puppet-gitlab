class gitlab::runner (
  $svc_rstate    = $gitlab::params::svc_rstate,
  $svc_rname     = $gitlab::params::svc_rname,
  $pkg_rversion  = $gitlab::params::pkg_rversion,
  $pkg_rname     = $gitlab::params::pkg_rname,
  $docker_runner = $gitlab::params::docker_runner,
  $config_runner = $gitlab::params::config_runner,
  $runner_url    = $gitlab::params::runner_url,
  $runner_tkn    = $gitlab::params::runner_tkn,
  $runner_home   = $gitlab::params::runner_home,
) inherits ::gitlab::params {

  include gitlab::repos::runner

  # We're only using CentOS/RedHat systems
  if ( $::osfamily != 'RedHat' ) {
    notify {'gitlab_notice':
      message => 'This module is only tested on RedHat based machines, some config might be missing.',
      before  => Package['gitlab-runner'],
    }
  }

  $enable = $svc_rstate ? {
    'running' => true,
    'stopped' => false,
  }

  if $runner_home {
    group { 'gitlab-runner':
      ensure => present,
      system => true,
    }
    user { 'gitlab-runner':
      home    => $runner_home,
      gid     => 'gitlab-runner',
      system  => true,
      require => Group['gitlab-runner'],
      before  => Package['gitlab-runner'],
    }
  }

  package { 'gitlab-runner':
    name   => $pkg_rname,
    ensure => $pkg_rversion,
  }

  service { 'gitlab-runner':
    name       => $svc_rname,
    ensure     => $svc_rstate,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
    require    => Packages['gitlab-runner'],
  }

  if $docker_runner {
    include gitlab::runner::docker
  } else {
    include gitlab::runner::shell
  }

  if $config_runner {
    if $docker_runner {
      $runner_config_line = "gitlab-runner register -n --url $runner_url --registration-token $runner_tkn --executor docker"
    } else {
      $runner_config_line = "gitlab-runner register -n --url $runner_url --registration-token $runner_tkn --executor shell"
    }
    exec { 'gitlab_configure':
      command  => "$runner_config_line",
      provider => 'shell',
      path     => '/usr/bin/',
      unless   => "cat /etc/gitlab-runner/config.toml | grep -i $runner_url",
      require  => Service['gitlab-runner'],
      notify   => Service['gitlab-runner'],
    }
  }


}

class gitlab::runner::shell {
  include gitlab::runner::common
}

class gitlab::runner::docker {
  include gitlab::runner::common

  notify {'gitlab_docker_notice':
    message => 'Please install docker.',
    before  => Package['gitlab-runner'],
  }

}
