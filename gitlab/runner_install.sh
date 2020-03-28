#/bin/bash

# https://docs.gitlab.com/runner/install/linux-repository.html
# install gitlab runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# https://docs.gitlab.com/runner/register/index.html
# register runner
sudo gitlab-runner register

# add to sudoers
# echo "gitlab-runner ALL=(ALL) NOPASSWD: /bin/ln, /bin/chmod, /usr/bin/crontab, /etc/init.d/oac-api" | sudo tee -a /etc/sudoers
echo "gitlab-runner ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

service gitlab-runner start

echo "for issue with \"No such file or directory\" error when running runner on remote box read here https://gitlab.com/gitlab-org/gitlab-runner/issues/1379"