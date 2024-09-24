describe AlphavantageAsDataframe::Configuration do
  after(:each) do
    described_class.instance_variable_set('@configuration', nil)
  end

  it 'should set the configuration with a config block' do
    AlphavantageAsDataframe.configure do |config|
      config.api_key = 'someKey'
    end

    expect(AlphavantageAsDataframe.configuration.api_key).to eq('someKey')
  end

  # Why is this important? Because some API keys are rate limited.  Having
  # a proc as an api_key allows the user to inject an API Key Manager
  # or rate limiter process.
  #
  it "should support a Proc as an api_key" do
    AlphavantageAsDataframe.configure do |config|
      config.api_key = -> { Time.now }
    end

    key1 = AlphavantageAsDataframe.configuration.api_key
    sleep(1)
    key2 = AlphavantageAsDataframe.configuration.api_key

    expect(key1.class).to   eq(Time)
    expect(key2.class).to   eq(Time)
    expect(key1 < Key2).to  be(true)
  end
end
