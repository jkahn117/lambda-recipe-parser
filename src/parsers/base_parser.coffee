#
#
#

'use strict'

cheerio = require('cheerio')
ing     = require('ingredientparser')

class BaseParser
  constructor: (html, recipe) ->
    @html   = html
    @recipe = recipe

    @doc = cheerio.load(@html)

  parse: () ->
    @_parseBasics()
    @_parseIngredients()
    @_parseDirections()

    return @recipe

  parseBasics: () ->
    console.log 'To be implemented by subclass'

  parseDirections: () ->
    console.log 'To be implemented by subclass'

  parseIngredients: () ->
    console.log 'To be implemented by subclass'