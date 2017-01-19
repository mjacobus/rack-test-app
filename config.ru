require 'rack'
require 'json'
require 'nurse'

use Rack::Static, urls:  {"/" => 'foo.html'}, root: 'public'

dependencies = Nurse::DependencyContainer.new

dependencies.define(:app) do
  Proc.new { |env| [200, {}, [ env.to_json ]] }
end

run dependencies.get(:app)
