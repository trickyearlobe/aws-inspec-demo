# encoding: utf-8
#------------------------------------------------------------------------------
control 'aws-instances-count' do
  impact 0.7
  title 'We should have the right number of instances'
  desc  'Simple example of AWS instances'

  describe aws_ec2_instances do
    its('entries.length') { should eq 9 }
  end
end

#------------------------------------------------------------------------------
control 'aws-instances-state' do
  impact 0.7
  title 'All the instances should be running'
  desc  'Simple example of AWS instances'

  describe aws_ec2_instances.where{ state.name != 'running' } do
    its('instance_id') { should eq [] }
  end
end

#------------------------------------------------------------------------------
control 'aws-instances-with-public-ip' do
  impact 0.7
  title 'No machines should have public IPs'
  desc  'Simple example of AWS instances'

  describe aws_ec2_instances.where{ public_ip_address != nil } do
    its('instance_id') {should eq []}
    its('public_ip_address') {should eq []}
  end
end
