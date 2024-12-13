require 'yaml'

path = "/home/tariq/inception_of_things/part_1/config/configuration.yaml"
begin
  yaml_data = YAML.load_file(path)
  puts "YAML loaded successfully:\n"
  puts yaml_data
rescue Psych::SyntaxError => e
  puts "YAML syntax error: #{e.message}"
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end

