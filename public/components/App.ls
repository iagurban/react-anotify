require! \fs
{concat-map, drop, filter, find, fold, group-by, id, keys, last, map, Obj, obj-to-pairs, pairs-to-obj,
reject, reverse, Str, sort-by, take, unique,  unique-by, values, zip-with} = require \prelude-ls
{partition-string} = require \prelude-extension
{create-factory, DOM:{a, button, div, form, h1, h2, img, input, li, ol, option, span, ul}}:React = require \react
{render:dom-render} = require \react-dom
require! \react-tools
Immutable = require \immutable
{Anilist, sodom} = require \react-anilist
{Component:Anotify, Service:Aservice, BasicNotification} = require \index.ls
_ = require \lodash

App = React.createClass do
  displayName: 'App'

  component-will-mount: !->
    @service = new Aservice!

    @_id = 1

    do testing = !~>
      <~! setTimeout _, 800
      cls = <[error info warning]>[_.random 0, *-1]
      @service.push do
        message: "Message ##{@_id++} (#{cls})"
        class-name: cls
        3500
      testing!

  render: ->
    React.createElement Anotify, component:BasicNotification, service:@service

window.onload = ->
  dom-render do
    React.createElement App, null
    document.getElementById 'app'
