require 'rack'
require 'json'
require 'nurse'

class Debugger
  def initialize(env)
    @env = env
    @data = {
      application_user: `whoami`.gsub("\n", '').to_s,
      ruby: "#{RUBY_VERSION}p#{RUBY_PATCHLEVEL} - #{RUBY_PLATFORM} - RUBY_RELEASE_DATE",
      paths: $:,
      env: env,
    }
  end

  def to_json
    @data.to_json
  end
end

use Rack::Static, urls:  {"/" => 'foo.html'}, root: 'public'

dependencies = Nurse::DependencyContainer.new

dependencies.define(:app) do
  Proc.new { |env| [200, {}, [ Debugger.new(env).to_json ]] }
end

run dependencies.get(:app)
