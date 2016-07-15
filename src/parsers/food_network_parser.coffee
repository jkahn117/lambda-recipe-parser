#
# Recipe parser tuned to foodnetwork.com.
#

'use strict'

class FoodNetworkParser extends BaseParser
  _parseBasics: () ->
    @recipe.prepTime = @doc('dt:contains("Prep:")+dd').first().text()
    @recipe.cookTime = @doc('dt:contains("Cook:")+dd').first().text()
    @recipe.servings = @doc('dt:contains("Yield:")+dd').first().text()

    return

  _parseIngredients: () ->
    list = @doc('h6:contains("Ingredients")+ul>li')
    @recipe.ingredients = for ingredient in list
      ing.parse @doc(ingredient).text()
    return

  _parseDirections: () ->
    list = @doc('h6:contains("Directions")+ul>li>p')
    @recipe.directions = for step in list
      @doc(step).text()
    return