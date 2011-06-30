module PhavuContentsHelper

  #
  # Italicize species name.
  #
  def format_species_name(name)
    name = name.insert(0, '<em>')
    name.sub!('(', '</em>(')
    raw(name)
  end
  
  #
  # Helper to add additional pathogens.
  #
  def add_pathogen_link(name)
    button_to_function name, :id => "add_pathogen" do |page|
      page.insert_html :bottom, :pathogens, :partial => "pathogens", 
            :object => Pathogen.new
    end
  end
  
  #
  # Helper to add additional reference datasets.
  #
  def add_reference_dataset_link(name)
    button_to_function name, :id => "add_reference_dataset" do |page|
      page.insert_html :bottom, :reference_datasets, :partial => "reference_datasets", 
            :object => ReferenceDataset.new
    end
  end
  
  #
  # Helper to add additional resources.
  #
  def add_resource_link(name)
    button_to_function name, :id => "add_resource" do |page|
      page.insert_html :bottom, :resources, :partial => "resources", 
            :object => Resource.new
    end
  end
  
  #
  # Fields for helper.
  #
  def fields_for_form(name, object, &block)
    new_or_existing = object.new_record? ? 'new' : 'existing'
    model = controller.class.to_s.sub('Controller','').singularize.underscore
    prefix = model + "[#{new_or_existing}_#{name}_attributes][]"
    fields_for(prefix, object, &block)
  end
    
  #
  # Parse object attributes into a three column table.
  #
  def parse_model_attributes(object, attributes = [])
    return "" unless attributes.length > 0
    
    i = 1
    data = "<table class='data-table'>"
    attributes.each do |a|
      unless object[a.to_sym].blank?
        i.modulo(2) == 0 ? style = "even" : style = "odd"
        data << "<tr class='#{style}'>"
        
        descriptor = a.humanize
        
        # Custom descriptor substitutions
        descriptor.gsub!(/(G|g)(C|c)/, 'GC')
        descriptor.gsub!(/accession/, 'NCBI accession')
        descriptor.gsub!(/(T|t)axon/, 'NCBI taxon ID')
        descriptor.gsub!(/(S|s)elf incompatibility/, 'Mating system')
        
        ## Column One ##
        data << "<td>#{descriptor}</td>"
        
        # Custom values
        ## Column Two ##
        case a.to_sym
          when :gc_content_genome
            data << "<td>#{object[a.to_sym]}%</td>"
          when :gc_content_transcriptome
            data << "<td>#{object[a.to_sym]}%</td>"
          when :genome_size
            data << "<td>#{object[a.to_sym]} (Mbp)</td>"
          when :chloroplast_genome_size
            data << "<td>#{object[a.to_sym]} (kbp)</td>"
          when :mitochondria_genome_size
            data << "<td>#{object[a.to_sym]} (kbp)</td>"
          else
            data << "<td>#{object[a.to_sym]}</td>"
        end
        
        information = "#{a}_information".to_sym
        # If the attribute has additional information, add the dialog box.
        ## Column Three ##
        unless object[information].blank?
          data << "<td>"
          details = object[information]
          title = information.to_s.humanize.gsub(/(G|g)(C|c)/, 'GC')
          # Text container
          data << "<div id='#{a}_information_dialog' title='#{title}'>#{details}</div>"
          data << " <a id='#{a}_information_opener' href='#'>Read More &raquo;</a>"
          # jQuery dialog box
          data << "<script>$j(function($){$('##{a}_information_dialog').dialog(" + 
            "{autoOpen:false,show:'blind',hide:'blind',width:450});" + 
            "$('##{a}_information_opener').click(function(){" + 
            "$('##{a}_information_dialog').dialog('open');return false;});});" + 
            "</script>"
          data << "</td>"
        else
          data << "<td></td>"
        end
        data << "</tr>"
        i += 1
      end
    end
    data << "</table>"
    
    # Send the table
    raw(data)
  end
  
  #
  # Parse major pathogens into table.
  #
  def parse_major_pathogens(pathogens)
    i = 1
    data = "<table  class='data-table'>"
    
    data << "<tr>"
    data << "<th>Pathogen</th>"
    data << "<th>NCBI Taxon ID</th>"
    data << "</tr>"
    
    pathogens.each do |p|
      i.modulo(2) == 0 ? style = "even" : style = "odd"
      data << "<tr class='#{style}'>"
      data << "<td>#{p.name unless p.name.blank?}</td>"
      data << "<td>#{p.ncbi_taxon_id unless p.ncbi_taxon_id.blank?}</td>"
      data << "</tr>"
      i += 1
    end
    data << "</table>"
    
    # Send the table
    raw(data)
  end
  
  #
  # Parse reference datasets into table.
  #
  def parse_reference_datasets(datasets)
    i = 1
    data = "<table  class='data-table'>"
    
    data << "<tr>"
    data << "<th>Type</th>"
    data << "<th>Description</th>"
    data << "<th>Source</th>"
    data << "<th>URL</th>"
    data << "</tr>"
    
    datasets.each do |d|
      i.modulo(2) == 0 ? style = "even" : style = "odd"
      data << "<tr class='#{style}'>"
      data << "<td>#{d.reference_dataset_type unless d.reference_dataset_type.blank?}</td>"
      data << "<td>#{d.description unless d.description.blank?}</td>"
      data << "<td>#{d.source unless d.source.blank?}</td>"
      data << "<td>#{link_to raw('Download &raquo;'), d.url unless d.url.blank?}</td>"
      data << "</tr>"
      i += 1
    end
    data << "</table>"
    
    # Send the table
    raw(data)
  end
  
  #
  # Parse resources into table.
  #
  def parse_resources(resources)
    i = 1
    data = "<table  class='data-table'>"
    
    resources.each do |r|
      i.modulo(2) == 0 ? style = "even" : style = "odd"
      data << "<tr class='#{style}'>"
      data << "<td>#{r.resource_type unless r.resource_type.blank?}</td>"
      data << "<td>#{r.description unless r.description.blank?}</td>"
      data << "<td>#{link_to raw('Linkout &raquo;'), r.url unless r.url.blank?}</td>"
      data << "</tr>"
      i += 1
    end
    data << "</table>"
    
    # Send the table
    raw(data)
  end
  

end
