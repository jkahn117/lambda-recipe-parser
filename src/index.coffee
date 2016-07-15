#
# Recipe parser that runs in Lambda for a little mobile app I am building...
#

'use strict'

#
# event.json:
# {
#   "url": "http://www.simplyrecipes.com/recipes/baked_ziti/"
# }
#
# response:
# {
#   "success": "true",
#   "error": "",
#   "recipe": {
#     "title": "Baked Ziti",
#     "description": "...",
#     "sourceUrl": "http://www.simplyrecipes.com/recipes/baked_ziti/",
#     "thumbnailUrl": "http://www.simplyrecipes.com/wp-content/uploads/2015/04/baked-ziti-vertical-a2-1400.jpg",
#     "prepTime": "10",
#     "cookTime": "55",
#     "servings": "8",
#     "ingredients": [ ... ],
#     "directions": [ ... ]
#   }
# }

exports.handler = (event, context, callback) ->

  if !event.url
    respondWithError context, 'Missing URL, required for parsing'
  
  parser = new Instaparser()
  parser.parse event.url, (result) ->
    if !result.error
      recipe = new Recipe(result.data)

      fnParser = new FoodNetworkParser(result.data.html, recipe)
      recipe = fnParser.parse()


      respondWithSuccess context, recipe
    else
      respondWithError context, result.error

  return

# Helper function to respond with the current error message.
respondWithError = (context, error) ->
  response = new Response(false, error, null)
  context.fail(response)
  return

respondWithSuccess = (context, recipe) ->
  response = new Response(true, null, recipe)
  context.succeed(response)
  return

#
# Wrapper for returning responses to the client.
#
class Response
  constructor: (@success, @error, @recipe) ->
    return

#
# Wrapper for recipes that are parsed from web.
#
class Recipe
  constructor: (data) ->
    @siteName     = data.site_name
    @title        = data.title
    @sourceUrl    = data.url
    @thumbnailUrl = data.thumbnail
    @description  = data.description
    return


