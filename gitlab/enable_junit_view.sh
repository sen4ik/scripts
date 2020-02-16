#/bin/bash
# https://docs.gitlab.com/ee/ci/junit_test_reports.html
# https://docs.gitlab.com/ee/administration/troubleshooting/gitlab_rails_cheat_sheet.html
sudo gitlab-rails runner "Feature.enable(:junit_pipeline_view)"
