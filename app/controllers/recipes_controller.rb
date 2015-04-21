class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :show, :like]
  before_action :require_user, except:  [:show, :index]
  before_action :require_same_user, only: [:edit, :update]

  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
    #Recipe.all.sort_by { |likes| likes.thumbs_up_total}.reverse
  end

  def show

  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_user

    if @recipe.save
      flash[:success] = "Your Recipe was saved successfully!"
      redirect_to recipes_path
    else
      render :new
    end

  end

  def edit

  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Your Recipe was edited successfully!"
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

  def like
    @chef = current_user

    like = Like.create(like: params[:like], recipe: @recipe, chef: @chef)
    if like.valid?
      flash[:success] = "Your selection was successful!"
    else
      flash[:warning] = "You can only vote a recipe once!"
    end

    redirect_to :back
  end

  private
  def recipe_params
    params.require(:recipe).permit(:name, :summary, :description, :picture)
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def require_same_user
    if @recipe.chef != current_user
      flash[:danger] = "You can only edit your own recipes!"
      redirect_to recipes_path
    end
  end

end
