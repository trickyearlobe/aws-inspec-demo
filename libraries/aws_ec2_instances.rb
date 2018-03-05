# author: Christoph Hartmann
class AwsEc2Instances < Inspec.resource(1)
  name 'aws_ec2_instances'
  desc 'Verifies settings for an EC2 instance'
  example 'To be added soon'
  supports platform: 'aws'

  def initialize(opts={}, conn=nil)
    @opts = opts
    @ec2_client = conn ? conn.ec2_client : inspec_runner.backend.aws_client(Aws::EC2::Client)
  end

  # Set up some accessors and the filter table
  filter = FilterTable.create
  filter.add_accessor(:where).add_accessor(:entries)
  Aws::EC2::Types::Instance.members.each do |field|
    # Add a filter table field for each AWS instance property
    filter.add(field, field: field)
    # Add an accessors to access properties without the filter table
    define_method(field) do
      list.map(&:field)
    end
  end
  filter.connect(self, :list)

  # Give uses of `inspec shell` a few hints about what they can test
  def possible_properties
    Aws::EC2::Types::Instance.members
  end

  def inspec_runner
    inspec if respond_to?(:inspec)
  end

  def to_s
    "EC2 Instances"
  end

  def list
    @@aws_ec2_instances_cache ||= depaginate_api
    # require 'pry'; binding.pry
  end

  private

  # Dont let people call this directly as it has high network cost
  def depaginate_api
    # Cache in class variables rather than instance variables to improve
    # performance when several aws_ec2_instances controls are defined. Revisit
    # this if it causes memory consumption problems in large accounts
    @@aws_ec2_instances_cache ||= []
    next_token = nil
    loop do
      api_result=@ec2_client.describe_instances(
        next_token: next_token,
        max_results: 1000)
      api_result.reservations.map(&:instances).each do |instance|
        @@aws_ec2_instances_cache << instance.first
      end
      next_token = api_result.next_token
      break unless api_result.next_token
    end
    @@aws_ec2_instances_cache
  end

end
