class CategoryPresenter
  include ActiveModel::Translation

  attr_accessor :params, :category

  delegate :id, :brands, :products, :product_attributes, :name, :seo_name,
           :"attribute_filter_enabled?", :"filters_enabled?", :"brand_filter_enabled?",
           to: :category

  def initialize(category, options)
    @category = category

    # options hash for filtering by attribute values
    @params = options[:params]
    @product_attributes_query = params[:q]
    @brand_ids = params[:brands]
  end

  def products
    products = Product.by_attributes(@product_attributes_query)
                      .where(category_id: @category.id)
                      .includes(:images)
                      .paginate(page: @params[:page])
    products = products.where(brand_id: @brand_ids) if @brand_ids
    products
  end

  def product_attributes
    ProductAttribute
      .where(category_id: @category.id, filterable: true)
      .includes(:product_attribute_values)
  end

  def brands
    Brand.joins(:products)
         .where('products.category_id = ?', @category.id)
  end
end
