class gitlab::repos::runner {

  case $::osfamily {
    'RedHat': {
      include gitlab::repos::runner::yum
    }
    'Debian': {
      include gitlab::repos::runner::apt
    }

  }

}

class gitlab::repos::runner::yum {

  yumrepo { 'runner_gitlab-runner':
    descr               => 'GitLab - Runner for Enterprise Linux $releasever ($basearch)',
    target              => '/etc/yum.repo.d/runner_gitlab-runner.repo',
    baseurl             => 'https://packages.gitlab.com/runner/gitlab-runner/el/$releasever/$basearch',
    enabled             => 1,
    repo_gpgcheck       => 1,
    gpgkey              => 'https://packages.gitlab.com/runner/gitlab-runner/gpgkey',
    gpgcheck            => 1,
    sslverify           => 1,
    sslcacert           => '/etc/pki/tls/certs/ca-bundle.crt',
    skip_if_unavailable => 1,
    metadata_expire     => 300,
    before              => Package['gitlab-runner'],
  }
  yumrepo { 'runner_gitlab-runner-source':
    descr               => 'GitLab - Runner for Enterprise Linux $releasever ($basearch) SRC',
    target              => '/etc/yum.repo.d/runner_gitlab-runner.repo',
    baseurl             => 'https://packages.gitlab.com/runner/gitlab-runner/el/$releasever/SRPMS',
    enabled             => 1,
    repo_gpgcheck       => 1,
    gpgkey              => 'https://packages.gitlab.com/runner/gitlab-runner/gpgkey',
    gpgcheck            => 1,
    sslverify           => 1,
    sslcacert           => '/etc/pki/tls/certs/ca-bundle.crt',
    skip_if_unavailable => 1,
    metadata_expire     => 300,
    before              => Package['gitlab-runner'],
  }

}

class gitlab::repos::runner::apt {

  # Need to add
  notify {'gitlab_apt_notice':
    message => 'Apts repos are missing, if you know how then please PR.',
    before  => Package['gitlab-runner'],
  }
}



class gitlab::repos::ce {

  case $::osfamily {
    'RedHat': {
      include gitlab::repos::ce::yum
    }
    'Debian': {
      include gitlab::repos::ce::apt
    }
  }

}

class gitlab::repos::ce::yum {

  yumrepo { 'gitlab_gitlab-ce':
    descr               => 'GitLab - Gitlab CE for Enterprise Linux $releasever ($basearch)',
    target              => '/etc/yum.repo.d/runner_gitlab-runner.repo',
    baseurl             => 'https://packages.gitlab.com/gitlab/gitlab-ce/el/$releasever/$basearch',
    enabled             => 1,
    repo_gpgcheck       => 1,
    gpgkey              => 'https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey',
    gpgcheck            => 1,
    sslverify           => 1,
    sslcacert           => '/etc/pki/tls/certs/ca-bundle.crt',
    skip_if_unavailable => 1,
    metadata_expire     => 300,
    before              => Package['gitlab-ce'],
  }
  yumrepo { 'gitlab_gitlab-ce-source':
    descr               => 'GitLab - Gitlab CE for Enterprise Linux $releasever ($basearch)',
    target              => '/etc/yum.repo.d/runner_gitlab-runner.repo',
    baseurl             => 'https://packages.gitlab.com/gitlab/gitlab-ce/el/$releasever/SRPMS',
    enabled             => 1,
    repo_gpgcheck       => 1,
    gpgkey              => 'https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey',
    gpgcheck            => 1,
    sslverify           => 1,
    sslcacert           => '/etc/pki/tls/certs/ca-bundle.crt',
    skip_if_unavailable => 1,
    metadata_expire     => 300,
    before              => Package['gitlab-ce'],
  }

}


class gitlab::repos::ce::apt {

  # Need to add
  notify {'gitlab_apt_notice':
    message => 'Apts repos are missing, if you know how then please PR.',
    before  => Package['gitlab-ce'],
  }

}
