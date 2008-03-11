require_dependency 'model_extensions'
require_dependency 'controller_extensions'

# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class PageGroupPermissionsExtension < Radiant::Extension
  version "0.1"
  description "Allows you to organize your users into groups and apply group based edit permissions to the page heirarchy."
  url "http://matt.freels.name"
  
  define_routes do |map|
    map.connect 'admin/groups/:action', :controller => 'admin/group'
  end
  
  def activate
    User.module_eval &UserModelExtensions
    Page.module_eval &PageModelExtensions
    Admin::PageController.module_eval &PageControllerExtensions
    
    admin.tabs.add "Groups", "/admin/groups", :after => "Layouts", :visibility => [:admin]
    admin.page.index.add :node, "page_group_td", :before => "status_column"
    admin.page.index.add :sitemap_head, "page_group_th", :before => "status_column_header"
    admin.page.edit.add :parts_bottom, "page_group_form_part", :after => "edit_timestamp"
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end