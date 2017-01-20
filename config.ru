require 'rack'
require 'json'
require 'nurse'


class Debugger
  def initialize(env)
    @env = env
    @data = {
      application_user: application_user,
      ruby: "#{RUBY_VERSION}p#{RUBY_PATCHLEVEL} - #{RUBY_PLATFORM} - RUBY_RELEASE_DATE",
      paths: $:,
      env: env,
    }
  end

  def application_user
    application_user = system('whoami')
    application_user ||= `whoami` rescue nil
    application_user.gsub("\n", '').to_s
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
