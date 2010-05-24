class Irwi::Config
  
  attr_accessor_with_default :controller_name, 'wiki_pages'
  
  attr_accessor_with_default :user_class_name, 'User'
  
  attr_accessor_with_default :page_class_name, 'WikiPage'
  attr_accessor_with_default :page_version_class_name, 'WikiPageVersion'
  
  attr_accessor_with_default :page_version_foreign_key, 'page_id'
  
  # Object using to format content
  attr_accessor_with_default :formatter do
    require 'irwi/formatters/red_cloth'

    Irwi::Formatters::RedCloth.new
  end
  
  # Object using to compare pages
  attr_accessor_with_default :comparator do
    require 'irwi/comparators/diff_lcs'

    Irwi::Comparators::DiffLcs.new
  end
  
  # Object using to paginate collections
  attr_accessor_with_default :paginator do
    require 'irwi/paginators/none'

    Irwi::Paginators::None.new
  end
  
  def page_class
    page_class_name.constantize
  end
  
  def page_version_class
    page_version_class_name.constantize
  end
  
  def user_class
    user_class_name.constantize
  end
  
  def system_pages
    @system_pages ||= {
      'all' => 'all'
    }
  end
  
  # Add system page
  # @param action [String,Symbol] controller action
  # @param path [String] path in routes
  def add_system_page( action, path )
    system_pages[ action.to_s ] = path.to_s
  end
  
end