# encoding: utf-8
#------------------------------------------------------------------------------
# inspec_aws_iam_policies.arns.each do |arn|
#   puts "ARN: #{arn}"
# end
#------------------------------------------------------------------------------
control 'aws-policies-rights' do
  impact 0.7
  title 'The inspec-test-policy should have the correct rights'
  desc  'Simple example of rights testing for policies'

  describe inspec_aws_iam_policy(arn:'arn:aws:iam::496323866215:policy/inspec-test-policy') do

    its('rights') { should include(
      notaction: "kms:DescribeKey",
      resource:  "arn:aws:kms:eu-west-1:028045785640:key/9a081150-b755-4a53-8230-c0f94ff0f769",
      effect:    "Deny"
      )}

    its('rights') {should include(
      effect:   "Allow",
      action:   "kms:DescribeKey",
      resource: "arn:aws:kms:eu-west-1:028045785640:key/9197d8fb-3ab4-4ec8-a8c7-1110ba124d9b"
      )}

    its('rights') {should_not include effect:/.*/, action:/s3:.*/, resource:/.*/}
    its('rights') {should_not include effect:/.*/, notaction:/s3:.*/, resource:/.*/}
    its('rights') {should_not include effect:/.*/, action:/s3:.*/, notresource:/.*/}
    its('rights') {should_not include effect:/.*/, notaction:/s3:.*/, notresource:/.*/}
  end
end
