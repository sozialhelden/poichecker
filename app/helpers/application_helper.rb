module ApplicationHelper
  def arbre(assigns = {}, &block)
    Arbre::Context.new(assigns, &block).to_s
  end
end
