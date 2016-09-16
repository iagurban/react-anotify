{create-factory, create-element, DOM:{a, button, div, form, h1, h2, img, input, li, ol, option, span, ul}}:React = require \react
{Map, Set, List, fromJS:immutable} = require \immutable
{Service} = require \./Service
{Anilist, sodom} = require \react-anilist
Velocity = require \velocity-animate
BasicNotification = require \./BasicNotification
_ = require \lodash

module.exports = React.create-class do
  display-name: \Anotify

  get-initial-state: ->
    items: null

  component-did-mount: !->
    {service} = @props
    throw 'You must pass service instabce in props' unless service?
    @unsub = service.sub !~> @set-state items:it

  component-will-unmount: !-> @unsub?!

  render: ->
    {items} = @state
    return div null unless items?
    create-element Anilist, class-name:'anotify', component:(@props.component ? BasicNotification), items:items

