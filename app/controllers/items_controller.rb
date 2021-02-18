class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_item, only: [:show, :destroy]

  def index
    @items=Item.includes(:item_image).order("created_at DESC").limit(10)
  end

  def new
    @item = Item.new
    @item.build_item_image
    @categories = Category.roots
  end

  def get_category
    selected_category = Category.find(params[:category_id])
    @categories = selected_category.children
  end

  def create
    @item = Item.new(item_params)
    if @item.valid? 
      @item.save
      redirect_to root_path
    else
      @categories = Category.roots
      render :new
    end
  end

  def edit
    @item=Item.includes(:item_image).find(params[:id])
  end

  def update
    @item=Item.includes(:item_image).find(params[:id])
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      @categories = Category.roots
      redirect_to edit_item_path(@item.id)
    end
  end
  
  def destroy
    if current_user.id == @item.user_id
      @item.destroy
      redirect_to root_path
    else
      redirect_to item_path(@item)
    end
  end

  def show
  end

  def search
    @items = Item.search(params[:keyword])
  end

  def purchase
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:trading_status, :name, :category_id, :introduction, :condition_id, :shipping_fee_payer_id, :prefecture_id, :preparation_day_id, :price, item_image_attributes: [:id, :image_url]).merge(user_id: current_user.id)
  end 

end