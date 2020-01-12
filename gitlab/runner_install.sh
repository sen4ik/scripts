#/bin/bash

# https://docs.gitlab.com/runner/install/linux-repository.html
# install gitlab runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# https://docs.gitlab.com/runner/register/index.html
# register runner
sudo gitlab-runner register

# add to sudoers
echo "gitlab-runner ALL=(ALL) NOPASSWD: /bin/ln, /bin/chmod, /etc/init.d/oac-api" | sudo tee -a /etc/sudoers

# service gitlab-runner start
