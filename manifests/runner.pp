class gitlab::runner (
  $svc_rstate    = $gitlab::params::svc_rstate,
  $svc_rname     = $gitlab::params::svc_rname,
  $pkg_rversion  = $gitlab::params::pkg_rversion,
  $pkg_rname     = $gitlab::params::pkg_rname,
  $docker_runner = $gitlab::params::docker_runner,
) inherits ::gitlab::params {

  include gitlab::repos::runner

  # We're only using CentOS/RedHat systems
  if ( $::osfamily != 'RedHat' ) {
    notify {'gitlab_notice':
      message => 'This module is only tested on RedHat based machines, some config might be missing.',
      before  => Package ['gitlab-runner'],
    }
  }

  $enable = $svc_rstate ? {
    'running' => true,
    'stopped' => false,
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
    require    => Packages ['gitlab-runner'],
  }

  if $docker_runner {
    include gitlab::runner::docker
  } else {
    include gitlab::runner::shell
  }


}

class gitlab::runner::shell {
  include gitlab::runner::common
}

class gitlab::runner::docker {
  include gitlab::runner::common

  notify {'gitlab_docker_notice':
    message => 'Please install docker.',
    before  => Package ['gitlab-runner'],
  }

}
