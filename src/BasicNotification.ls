{create-factory, create-element, DOM:{a, button, div, form, h1, h2, img, input, li, ol, option, span, ul}}:React = require \react
{Map, Set, List, fromJS:immutable} = require \immutable
{Service} = require \./Service
{Anilist, sodom} = require \react-anilist
{classes} = require \./reactex
Velocity = require \velocity-animate
_ = require \lodash

const test-anim-duration = 550

scale =
  to01: (v, min, max) -> (v - min) / (max - min)
  from01: (v, min, max) -> v * (max - min) + min
  scale: (v, in-min, in-max, out-min, out-max) -> @from01 (@to01 v, in-min, in-max), out-min, out-max

rect-center = ({left:x, top:y, width:w, height:h}) -> [x + w / 2, y + h / 2]
rects-objs-equals = (r1, r2) ->
  for k in <[left top width height]> => return false if r1[k] != r2[k]
  true
distance = ([x1, y1], [x2, y2]) -> Math.sqrt ((x2 - x1) ^ 2 + (y2 - y1) ^ 2)

duration-mult = (r1, r2) ->
  scale.from01 do
    Math.min 1.0, Math.max 0.0, scale.to01 do
      distance.apply null, [r1, r2].map rect-center
      (dia = distance [window.screen.width, 0], [0, window.screen.height]) * 0.1
      dia * 0.8
    0.6, 1.0

duration-mult2 = ({left ? 0, top ? 0}) ->
  scale.from01 do
    Math.min 1.0, Math.max 0.0, scale.to01 do
      Math.sqrt (left ^ 2 + top ^ 2)
      (dia = distance [window.screen.width, 0], [0, window.screen.height]) * 0.3
      dia * 0.6
    0.8, 1.1

module.exports = React.create-class do
  display-name: \BasicNotification

  should-component-update: (np) ->
    r = @props.item != np.item
    if r
      console.log \returning-true
    r

  make-move-animation: (from, to) ->
    return unless _.size from

    @root-dom.update-style do
      _.map-values from{left ? 0, top ? 0}, -> "#{it}px"
      position: \relative
      z-index: 100

    Velocity do
      @root-dom.node
      * to
      * queue: false
        easing: [200, 10 + _.random 0, 10]
        delay: _.random 50, 150
        duration: test-anim-duration * (duration-mult2 from) * _.random 0.9, 1.1
    .then !~>
      @root-dom.update-style z-index: null, left: null, opacity: null

  make-add-animation: ->
    @root-dom.update-style do
      left: @root-dom.width! + 30
      position: \relative
      opacity: 0
      z-index: 100

    Velocity do
      @root-dom.node
      * opacity: 1
        left: 0
      * queue: false
        easing: [200, 30]
        delay: _.random 0, 200
        duration: test-anim-duration * _.random 0.7, 1.0
    .then !~>
      @root-dom.update-style z-index: null, left: null, opacity: null

  make-remove-animation: (from, to) ->
    @root-dom.update-style do
      _.map-values from{left ? 0, top ? 0}, -> "#{it}px"
      position: \relative
      opacity: 1
      z-index: 80

    Velocity do
      @root-dom.node
      * opacity: 0
        top: (from.top ? 0) - @root-dom.top! - 30
      * queue: false
        easing: [300, 20]
        duration: test-anim-duration * _.random 0.7, 1.0
    .then !~>
      @root-dom.update-style z-index: null, left: null, opacity: 0

  get-frame: -> @root-dom.get-relative-rect!

  render: ->
    {item} = @props
    div do
      ref: !~> @root-dom = sodom it
      class-name: classes 'basic-notification', item.get \className
      item.get \message
