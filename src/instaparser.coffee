#
# Wrapper around Instaparser service.
#

validUrl    = require('valid-url')
https       = require('https')
querystring = require('querystring')

class Instaparser
  @statusCodes =
    200: 'Success',
    400: 'Parameter missing or malformed',
    401: 'API key is invalid',
    403: 'Account suspended (payment error)',
    409: 'Exceeded monthly calls',
    412: 'Unable to fetch content from source',
    429: 'Rate limit exceeded'

  constructor: () ->
    @apiKey = Config.INSTAPARSER_API_KEY

  parse: (url, callback) =>
    if !validUrl.isUri(url)
      callback({ data: null, error: 'Invalid URL' })

    params =
      api_key: @apiKey,
      url: url

    https.get(
      host:    'www.instaparser.com',
      path:    "/api/1/article?#{querystring.stringify params}",
      # we always deal with JSON response here
      headers: { 'Content-Type': 'application/json' }
      (response) ->
        if response.statusCode >= 400
          callback({ data: null, error: @statusCodes[response.statusCode] })
          return
        else
          body = ''
          response.on 'data', (d) ->
            body += d
          response.on 'end', ->
            callback({ data: JSON.parse(body), error: null })
    ).on('error', (error) ->
      callback({ data: null, error: error })
      return
    )
