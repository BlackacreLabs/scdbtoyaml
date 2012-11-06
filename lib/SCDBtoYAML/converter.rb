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
    TRANSFORMS = {
      'id' => lambda { |x| x['caseId'] },
      'decided' => 'dateDecision',
      'argued' => 'dateArgument',
      'reargued' => 'dateReargument',
      'style' => 'caseName',
      'chief justice' => 'chief',
      'voting' => lambda {|x|
        {
          'majority' => x['majVotes'],
          'minority' => x['minVotes'],
          'split' => x['splitVote'] == 1,
          'unclear' => x['voteUnclear'] == 1,
        }
      },
      'relief' => lambda {|x|
        case x['partyWinning']
        when 0
          'none'
        when 1
          'granted'
        when 2
          'unclear'
        end
      },
      'law' => lambda {|x|
        {
          'area' => Coding::LEGAL_AREA[x['lawType']],
          'provision' => Coding::LEGAL_PROVISIONS[x['lawSupp']]
        }
      },
      'effect' => lambda {|x|
        { 'precedent altered' => x['precedentAlteration'] == 1 }
      },
      'parties' => lambda {|x|
        {
          'petitioner' => {
            'description' => Coding::PARTIES[x['petitioner']],
            'state' => Coding::STATES[x['petitionerState']]
          },
          'repsondent' => {
            'description' => Coding::PARTIES[x['respondent']],
            'state' => Coding::STATES[x['respondentState']]
          }
        }
      },
      'term' => lambda {|x| x['docketId'][0,4].to_i},
      'docket number' => 'docket',
      'posture' => lambda {|x|
        {'administrative' => Coding::ADMIN_ACTION[x['adminAction']]}
      },
      'majority opinion' => lambda {|x|
        {
          'writer' => Coding::JUSTICES[x['majOpinWriter']].last,
          'assigner' => Coding::JUSTICES[x['majOpinAssigner']].last
        }
      }
    }
    def self.post_process(hash)
      out = { }
      TRANSFORMS.each do |key, action|
        case action
        when Proc
          out[key] = action.call(hash)
        when String
          out[key] = hash[action]
        end
      end
      out['citataions'] = {
        'United State Reports' => hash['usCite'],
        'Supreme Court Reporter' => hash['sctCite'],
        'Lawyers Edition' => hash['ledCite'],
        'Lexis Nexis' => hash['lexisCite']
      }
      out
    end
  end
end
