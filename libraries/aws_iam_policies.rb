class InspecAwsIamPolicies < Inspec.resource(1)
  name 'inspec_aws_iam_policies'
  desc 'Verifies settings for AWS IAM policies'
  example "
    describe aws_iam_policies do
      its('length') { should_not eq 0 }
      it { should contain ['biscuits']}
    end
  "
  def policies
    @cached_policies ||= @client.list_policies.policies
  end

  # Define access methods for the policy fields
  { names:'policy_name', ids:'policy_id', descriptions:'description', arns:'arn',
    create_dates:'create_date', update_dates:'update_date' }.each do |method,field|
    define_method(method) do
      policies.map {|policy| policy["#{field}"]}
    end
  end

  def length
    policies.length
  end
  alias_method :count, :length

  def to_s
    'AWS Policies'
  end

  # private

  def initialize(conn = InspecAWSConnection.new)
    @client = conn.iam_client
  end


end
