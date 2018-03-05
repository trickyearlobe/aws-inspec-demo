# encoding: utf-8
#------------------------------------------------------------------------------
control 'aws-users-mfa' do
  impact 0.7
  title 'All console users must use Multi Factor Authentication (MFA)'
  desc  'Multifactor in AWS terms means a token generator and a password. its
         quite possible to steal an object or a password, but its harder to
         steal both at once without it being noticed'
  describe aws_iam_users
    .where(has_mfa_enabled?: false)
    .where(has_console_password?: true) do
      its('username') { should eq [] }
    end
end

#------------------------------------------------------------------------------
control 'aws-users-count' do
  impact 0.7
  title 'The number of users should not have changed'
  desc 'If number of users changed, and we did not do it, someone is misbehaving'

  describe aws_iam_users do
    its('entries.length') { should eq 37 }
  end
end
