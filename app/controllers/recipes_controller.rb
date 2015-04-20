class RecipesController < ApplicationController
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
    #Recipe.all.sort_by { |likes| likes.thumbs_up_total}.reverse
  end

  def show
    @recipe = Recipe.find_by id: params[:id]
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    #TODO: Nach User Authentication hier Dummy ID ersetzen!
    @recipe.chef = Chef.find(2)

    if @recipe.save
      flash[:success] = "Your Recipe was saved successfully!"
      redirect_to recipes_path
    else
      render :new
    end

  end

  def edit
    @recipe = Recipe.find(params[:id])

  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update(recipe_params)
      flash[:success] = "Your Recipe was edited successfully!"
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

  def like
    #TODO: Hier ist die ID noch hartkodiert! Bitte ändern!
    @chef = Chef.find(2)
    @recipe = Recipe.find(params[:id])

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
end
