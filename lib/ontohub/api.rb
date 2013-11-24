module Ontohub

  class Base < ActiveResource::Base
  end

  class Ontology < Base
  end

  class Repository < Base
  end

  class API
    include Singleton
    class_attribute :repository_path

    def repository
      @repository ||= Repository.where(path: repository_path).try(:first) || (raise "Repository path='#{repository_path}' not found at Ontohub")
    end
    
    # Update metadata at ontohub
    def update_metadata
      Socop::Ontology.parse(DATADIR.join "ontologies.xml").each do |ontology|
        if onto_ontology = Ontology.where(repository_id: repository.id, basepath: ontology['abbreviation']).first
          onto_ontology.update_attributes \
            name:        ontology['displayLabel'],
            description: ontology['description']
        end
      end
    end
  end

end