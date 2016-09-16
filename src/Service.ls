{List, Map, fromJS} = require \immutable

module.exports = class
  @_id = 0

  ->
    @observers = Map!as-mutable!
    @_items = Map!
    @shown-items = null
    @_nid = 0

    Object.define-property @, 'items', do
      get: -> @_items
      set: (@_items) -> @_rebuild!

  _rebuild: ->
    @shown-items = @_items
    .map (v, k) -> [k, v]
    .to-list!sort (-> &0.0 - &1.0) .map (.1)

    @observers.for-each (@shown-items|>)
    @shown-items

  sub: (f) ->
    id = @@_id++
    @observers.set id, f
    (.bind @, id) (id) !-> @observers.remove id

  push: (n, autodestroy-time=5000) ->
    id = ++@_nid
    n = fromJS n .set \id, id

    @items .= set id, n

    if autodestroy-time?
      f = (.bind @, id) (id) !-> @items .= remove id
      set-timeout f, Math.max autodestroy-time ? 300, 300
    n
