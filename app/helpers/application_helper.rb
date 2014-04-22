module ApplicationHelper
  def arbre(assigns = {}, &block)
    Arbre::Context.new(assigns, &block).to_s
  end

  def next_path(current_user, current_place)
    next_admin_places_path(q: { dist_greater_than: current_place.distance_to(current_user), id_not_eq: current_place.id }, order: :distance_asc)
  end
end
