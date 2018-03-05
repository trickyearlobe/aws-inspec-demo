class InspecAWSConnection
  def initialize

    require 'aws-sdk'
    opts = {
      region: ENV['AWS_DEFAULT_REGION'],
      credentials: Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY'],
        ENV['AWS_SESSION_TOKEN'],
      ),
    }

    Aws.config.update(opts)
  end

  def ec2_resource
    @ec2_resource ||= Aws::EC2::Resource.new(http_proxy: ENV['http_proxy'])
  end

  def ec2_client
    @ec2_client ||= Aws::EC2::Client.new(http_proxy: ENV['http_proxy'])
  end

  def ec2_vpc
    @ec2_vpc ||= Aws::EC2::Vpc.new(http_proxy: ENV['http_proxy'])
  end

  def iam_resource
    @iam_resource ||= Aws::IAM::Resource.new(http_proxy: ENV['http_proxy'])
  end

  def iam_client
    @iam_client ||= Aws::IAM::Client.new(http_proxy: ENV['http_proxy'])
  end

  def cf_client
    @cf_client ||= Aws::CloudFormation::Client.new(http_proxy: ENV['http_proxy'])
  end

  def cloudwatch_events_client
    @cloudwatch_events_client ||= Aws::CloudWatchEvents::Client.new(http_proxy: ENV['http_proxy'])
  end

  def lambda_client
   @lambda_client ||= Aws::Lambda::Client.new(http_proxy: ENV['http_proxy'])
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(http_proxy: ENV['http_proxy'])
  end

end
