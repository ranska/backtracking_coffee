class Periodic2Srv extends @RangService
  @register window.Franccest

  #TODO @inject 'PeriodicDataSrv'
  _add_to_periodic_table: (data) ->
    if data is 'table'
      for sub_data in window.big_data[data]
        @_sub_add_to_periodic_table sub_data.elements
    else
      @_sub_add_to_periodic_table window.big_data[data]

  _sub_add_to_periodic_table: (data) ->
      for el in data
        unless el.small is '57-71' or el.small is '89-103'
          @periodic_table.push el

  initialize: ->
    @periodic_table = []
    @_add_to_periodic_table 'table'
    @_add_to_periodic_table 'lanthanoids'
    @_add_to_periodic_table 'actinoids'
    @word_in_element = []
  
  algo_simple: (pattern) ->
    @algo(pattern)
    @simplify()

  simplify: ->
    res = []
    for e in @word_in_element
      res.push e.small.toLowerCase()
    res

  algo: (pattern) ->
    @root()
    @status = 'working'
    while @status is 'working'
      @_next()
    @solutions[0]

  _check_over: ->
    if @track.length is 1 and @track[0][1] is @periodic_table.length - 1
      @status = 'finish'

  _next: ->
    @_increment()
    if @_is_partial_solution()
      @_forward()
    else
      @_backtrack()

  track_to_s: ->
    (e[0] for e in @track).join ''

  ## surcharger cette foction pour d'autre cas
  #
  _is_partial_solution: ->
    partial_word = @track_to_s()
    @target_words.slice(0, partial_word.length) is partial_word

  _increment: ->
    next = @track[-1..][0][1] + 1
    if next is @periodic_table.length
      @_backtrack()
    else
      @track[@track.length - 1] =
        [@periodic_table[next],next]

  _backtrack: ->
    unless @track.length is 1
      @track.pop()
      @_increment()

  _solution_complete: ->
    @track_to_s().length is @target_words.length

  _forward: ->
    if @_solution_complete()
      @solutions.push @track
      @_backtrack()
      return false
    true
    


