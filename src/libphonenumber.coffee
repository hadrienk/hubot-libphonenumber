# Description
#   A hubot script that uses libphonenumber to analyse a phone number
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   phone info <phone number> <country code> - shows information about a phone number
#   phone update - update the phone numbers
#
# Author:
#   Hadrien Kohl <hadrien.kohl@gmail.com>

ap = require('awesome-phonenumber')
cn = require('countrynames')

defaultCountryCode = 'NO'

module.exports = (robot) ->
  robot.respond /phone info (.*) ?(.*)?/, (msg) ->
    [number, countryCode] = msg.match[1..]

    countryCode ?= defaultCountryCode
    info = ap(number, countryCode).toJSON()

    answer = "the number #{ number }" +
    switch info.possibility
      when 'invalid-country-code' then "is invalid, the country code is invalid."
      when 'too-long' then "is invalid, it is too long."
      when 'too-short' then "is invalid, it is too short."
      when 'unknown' then "is invalid, but I am not sure why."
      else
        switch info.type
          when 'fixed-line' then " is a fixed line"
          when 'fixed-line-or-mobile' then " is a fixed line or mobile"
          when 'mobile' then " is a mobile"
          when 'pager' then " is a pager"
          when 'personal-number' then " is a personal number"
          when 'premium-rate' then " is a premium rate"
          when 'shared-cost' then " is a shared cost"
          when 'toll-free' then " is a toll free"
          when 'uan' then " is a UAN (Universal Access Number)"
          when 'voip' then " is a VOIP"
          when 'unknown' then " is a unknown valid"

    country += " phone number"
    country = cn.getName(info.regionCode)
    country ?= " from a country I don't know about: #{ info.regionCode }"
    answer += " from #{ country } (#{ info.regionCode })"

    msg.reply answer
