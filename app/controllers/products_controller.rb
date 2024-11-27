class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = filter_products(params)
    @top_categories = Product.top_categories
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.categories.build
  end

  # GET /products/1/edit
  def edit
    @product.categories.build
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    handle_categories

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    handle_categories
    respond_to do |format|
      if @product.update(product_params.except(:categories_attributes))
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      # params.expect(product: [ :name, :description, :price, category_ids: [],  categories_attributes: [:name] ])
      params.require(:product).permit(:name, :description, :price, category_ids: [], categories_attributes: [:id, :name, :_destroy])
    end

  private

  def filter_products(params)
    if params[:start_date].present? && params[:end_date].present?
      Product.created_between(params[:start_date], params[:end_date])
    elsif params[:query].present?
      Product.by_keyword(params[:query])
    else
      Product.all
    end
  end

  def handle_categories
    category_attributes = product_params[:categories_attributes]
    return unless category_attributes

    category_attributes.each do |_, category_attr|
      next if category_attr[:id].present?

      category = Category.find_or_create_by(name: category_attr[:name])
      pp category.to_json
      @product.categories << category unless @product.categories.any? { |c| c.name == category_attr[:name] }
      @product.categories.each { |i, c| pp "#{i} #{pp c.to_json}\n"}
    end
  end
end
