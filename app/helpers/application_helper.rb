module ApplicationHelper
  def arbre(assigns = {}, &block)
    Arbre::Context.new(assigns, &block).to_s
  end

  def scope
    params[:scope] || :to_do
  end

  def next_path(current_user, current_place)
    url = url_for(
      controller: 'places',
      action: 'next',
      data_set_id: params[:data_set_id],
      q: {
        dist_greater_than: current_place.distance_to(current_user),
        id_not_eq: current_place.id
      },
      order: :distance_asc,
      scope: scope
    )
    Rails.logger.warn(url)
    url
  end

  def first_path
    url_for(
      controller: 'places',
      action: :next,
      data_set_id: params[:data_set_id],
      q: {
        dist_greater_than: 0.0
      },
      order: :distance_asc
    )
  end
end
