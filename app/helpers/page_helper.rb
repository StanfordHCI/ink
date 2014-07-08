module PageHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

=begin
  def link_to_remove_panel(f)
    f.hidden_field(:_destroy) + link_to_function("Remove this panel", "remove_fields(this)")
  end
  
  def link_to_add_panel(f)
    #new_panel = f.object.class.reflect_on_association(:panels).klass.new
    new_panel = f.object.send(:panels).build #this and line above have same effect...
    fields = f.fields_for(:panels, new_panel, :child_index => "new_panels") do |builder|
      render "panel_fields", :p => builder
    end
    link_to_function("Add panel", "add_fields(this, \"#{escape_javascript(fields)}\")")
  end

  def add_existing_panel(f, existing_panel)
    fields = f.fields_for(:panels, existing_panel, :child_index => "new_panels") do |builder|
      render "panel_fields", :p => builder
    end
    #want to  call add_existing_fields here...
    return fields
  end
=end
end
