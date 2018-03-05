class InspecAwsIamPolicy < Inspec.resource(1)
  name 'inspec_aws_iam_policy'
  desc 'Verifies settings for AWS IAM policies'
  example "
    describe aws_iam_policy(arn:'some arn') do
      (...)
    end
  "

  def expand_statement(statement)
    results=[]
    statement.each do |key,values|
      intermediates=Array(values).map {|value| {key.downcase.to_sym => value}}
      if results.empty?
        results=intermediates
      else
        results=results.product(intermediates).map{|result| result.first.merge(result.last)}
      end
    end
    results
  end

  def rights
    @rights = []
    Array(document['Statement']).each do |statement|
      @rights += expand_statement(statement)
    end
    @rights
  end

  # Retrieve and decode the policy document
  def document
    @document ||= JSON.parse(URI.decode(policy.document))
    @document
  end

  # Retrieve a full (versioned) policy
  def policy
    @version ||= policy_base['default_version_id']
    @policy ||= @client.get_policy_version(policy_arn:@arn,version_id:@version).policy_version
  end

  # Get the base policy. Its not a full policy and it's mainly useful for its
  # "default_version_id" if the user didn't ask for a specific policy version
  def policy_base
    @policy_base ||= @client.get_policy(policy_arn:@arn).policy
  end

  def to_s
    "AWS Policy #{@arn || 'no arn: specified'}"
  end


  def initialize(opts={}, conn = InspecAWSConnection.new)
    @client = conn.iam_client
    @arn = opts[:arn]
    @version = opts[:version]
    @id = opts[:id]
    @name = opts[:name]
  end

end
