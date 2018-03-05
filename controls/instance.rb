test_instance = 'i-0984f12dd403fc551'

#------------------------------------------------------------------------------
control 'aws-instance-up' do
  impact 0.7
  title 'Instances should be up and running always'
  desc  'Simple example of AWS instances'

  describe aws_ec2_instance(test_instance) do
    it { should exist }
    it { should be_running }
  end
end

#------------------------------------------------------------------------------
control 'aws-instance-tagged' do
  impact 0.7
  title 'Instances should be tagged'
  desc  'Instances should at least have a Name tag that shows up in the WebUI'

  describe aws_ec2_instance(test_instance) do
    its('tags') { should include key:"Name", value:/.*/ }
  end
end

#------------------------------------------------------------------------------
control 'aws-instance-type' do
  impact 0.7
  title 'Instances should use approved AMIs'
  desc  'We have draconian rules about which base images may be used'

  describe aws_ec2_instance(test_instance) do
    its('image_id') { should be_in ['ami-27a58d5c','ami-d7aab2b3','ami-ee6a718a'] }
  end
end
#------------------------------------------------------------------------------
control 'aws-instance-public-ip' do
  impact 0.7
  title 'Instances should not have public IPs'
  desc  'We dont allow access from the internets because were a bank/hospital/government'

  describe aws_ec2_instance(test_instance) do
    its('public_ip_address') { should be nil }
  end
end
#------------------------------------------------------------------------------
