{Map} = require \immutable

classes = ->
  clss = []
  for c in &
    continue unless c?
    switch typeof c
    | \string => clss.push c
    | \object =>
      clss.splice 0, 0, r if (r =
        switch
        | Array.isArray c => reactex.classes.apply null, c
        | _ => [k for k, v of c when v]
      ).length
  clss.join ' '

Observable = class
  ->
    @_subscribers = Map!as-mutable! # for internal use, allows to use number as key, don't bind it in react
    @_sid = 0

  sub: (o) ->
    while (@_subscribers.get (id = @_sid))? then ++@_sid
    @_subscribers.set id, o
    (.bind @, id) (id) -> @_subscribers.remove id

  notifyAll: (data) !-> @_subscribers.forEach (data|>)

LinkableModel = class extends Observable
  (dflt) !->
    super!
    @model = @_dflt = Map dflt

  link: (key, {inKey, outKey, pipe}?) ->
    {[k, v] for [k, v] in [
      * inKey ? 'value'
        @model.get key
      * outKey ? 'onChange'
        bound @, key, (pipe ? (.target.value)), (key, pipe, it) !->
          @notifyAll (@model = @model.set key, pipe it)
      ]}

  linkDatepicker: (key) -> @link key, inKey:\selected, pipe: -> it

  reset: ->
    @notifyAll (@model = @_dflt)

module.exports =
  classes: classes
  Observable: Observable
  LinkableModel: LinkableModel

  AutoreleaseMixin:
    getInitialState: ->
      @__am_autoreleases = []
      null

    autoreleasing: (fn) ->
      @__am_autoreleases.push fn
      fn

    componentWillUnmount: !->
      for fn in @__am_autoreleases => fn!
      @__am_autoreleases = []
