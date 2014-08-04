module PageHelper

  def link_to_add_panels(pic, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, panel_id: id)
    end
    link_to(image_tag(pic), "#", class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_option(name, f, association, panel_id)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, panel_id: panel_id)
    end
    link_to(name, "#", class: "add_option", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def add_tags(f, association, option_name, page_id)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    new_object.name = option_name
    new_object.page_id = page_id
    f.fields_for(association, new_object, child_index: id) do |builder|
      render("tag_fields", f: builder, option_name: option_name)
    end
  end
end
