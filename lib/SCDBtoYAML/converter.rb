require 'csv'

module SCDBtoYAML
  class Converter
    # convert a UTF-8 CSV string into yaml
    # applying the SCDB codebook
    def self.convert(text)
      hashes = CSV.parse(
        text,
        :headers => true, # first row is header
        :converters => :all # detect numbers and dates
      ).map{|x| post_process(x.to_hash) }
    end

    # deal with the encoding of SCDB CSV files
    def self.convert_file(file)
      # There are \xA7 ISO-8859 section symbols
      c = File.open(file, 'r:iso-8859-1').read.encode('utf-8')
      Converter.convert(c)
    end

    # TODO: apply the codebook
    def self.post_process(hashes)
      hashes
    end
  end
end
