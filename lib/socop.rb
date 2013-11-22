require 'nokogiri'

module Socop

  def self.import
    WORKSPACE.mkpath
    Dir.chdir WORKSPACE do
      # init git repository if missing
      system 'git', 'init' unless WORKSPACE.join('.git').exist?

      Ontology.parse(DATADIR.join "ontologies.xml").each do |ontology|
        ontology.versions.each do |version|
          env = {
            'GIT_AUTHOR_DATE'     => Time.parse(version['dateCreated']).iso8601,
            'GIT_AUTHOR_NAME'     => version['contactName'],
            'GIT_AUTHOR_EMAIL'    => version['contactEmail'],
            'GIT_COMMITTER_NAME'  => version['contactName'],
            'GIT_COMMITTER_EMAIL' => version['contactEmail'],
          }
          filename = ontology.filename

          puts "------------"
          puts ontology.ontology_id
          puts version.path
          FileUtils.copy version.path, WORKSPACE.join(filename)

          if `git status -s` != ''
            system 'git', 'add', filename
            system env, 'git', 'commit', '-m', (version['versionNumber'] || "-"), filename
            raise "commit failed" if $?.to_i != 0
          end
        end
      end
    end
  end

  class Base
    def self.parse(filepath)
      Nokogiri::XML(File.open(filepath)).search("ontologyBean").map{|node| new node }
    end

    attr_reader :attributes
    delegate :[], to: :attributes

    def initialize(node)
      @attributes = Hash[node.elements.map{|e| [e.name, e.text.strip] }]
    end

    def ontology_id
      @attributes['ontologyId']
    end

    def filename
      @attributes['abbreviation'] + "." + @attributes['format'].downcase
    end
  end

  class Ontology < Base
    def versions
      Version.parse DATADIR.join("versions/#{ontology_id}.xml")
    end
  end

  class Version < Base
    def path
      DATADIR.join("version_files").join(@attributes['id'])
    end
  end

end