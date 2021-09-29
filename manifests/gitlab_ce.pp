class gitlab::gitlab_ce (
  $svc_gstate    = $gitlab::params::svc_gstate,
  $gitlabctl     = $gitlab::params::gitlabctl,
  $pkg_gversion  = $gitlab::params::pkg_gversion,
  $pkg_gname     = $gitlab::params::pkg_gname,
) inherits ::gitlab::params {

  include gitlab::repos::ce

  # We're only using CentOS/RedHat systems
  if ( $::osfamily != 'RedHat' ) {
    notify {'gitlab_notice':
      message => 'This module is only tested on RedHat based machines, some config might be missing.',
      before  => Package['gitlab-ce'],
    }
  }

  $enable = $svc_gstate ? {
    'running' => true,
    'stopped' => false,
  }

  package { 'gitlab-ce':
    name   => $pkg_gname,
    ensure => $pkg_gversion,
  }

  service { 'gitlab-ce':
    ensure     => $svc_gstate,
    enable     => $enable,
    start      => "$gitlabctl start",
    stop       => "$gitlabctl stop",
    restart    => "$gitlabctl restart",
    status     => "$gitlabctl status",
    hasstatus  => true,
    hasrestart => true,
    require    => Packages['gitlab-ce'],
  }


}
