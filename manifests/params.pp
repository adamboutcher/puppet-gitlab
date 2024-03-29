class gitlab::params {

  # Runner Version and Docker Support
  $pkg_rversion = 'latest'
  $docker_runner = false

  $config_runner = false
  $runner_url    = ""
  $runner_tkn    = ""
  $runner_home   = undef

  # Gitlab version
  $pkg_gversion = 'latest'

  case $::os[family] {
    'RedHat': {
      # GitLab Runner
      $svc_rstate = 'running'
      $svc_rname  = 'gitlab-runner'
      $pkg_rname  = 'gitlab-runner'
      # GitLab
      $svc_gstate = 'running'
      $gitlabctl  = '/usr/bin/gitlab-ctl'
      $pkg_gname  = 'gitlab-ce'
    }
    'Debian': {
      # GitLab Runner
      $svc_rstate = 'running'
      $svc_rname  = 'gitlab-runner'
      $pkg_rname  = 'gitlab-runner'
      # GitLab
      $svc_gstate = 'running'
      $gitlabctl  = '/usr/bin/gitlab-ctl'
      $pkg_gname  = 'gitlab-ce'
    }
    default: {
      # GitLab Runner
      $svc_rstate = 'running'
      $svc_rname  = 'gitlab-runner'
      $pkg_rname  = 'gitlab-runner'
      # GitLab
      $svc_gstate = 'running'
      $gitlabctl  = '/usr/bin/gitlab-ctl'
      $pkg_gname  = 'gitlab-ce'
    }
  }

}
