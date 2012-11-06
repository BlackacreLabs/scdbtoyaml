require 'thor'

module SCDBtoYAML 
  class CLI < Thor
    default_task :convert
    desc "convert", "Convert a Supreme Court Database CSV file to YAML"
    option :in, :aliases => '-i', :required => true, :banner => 'input file'
    option :out, :aliases => '-o', :required => true, :banner => 'output'
    def convert()
      hashes = Converter.convert_file(options[:in])
      File.open(options[:out], 'wb') {|f| f.write(hashes.to_yaml) }
    end
  end
end
