# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#create').click ->
    $('#create-modal').modal('show')
  $('.hook').click ->
    $(this).select()
    return false
  $('#createForm').submit ->
    $form = $(this)
    $button = $form.find('.btn')
    $.ajax (
      url: $form.attr('action')
      type: $form.attr('method')
      data: $form.serialize()
      beforeSend: ->
        $button.button('loading')
      complete: ->
        $button.button('reset')
      success: ->
        location.reload()
      error: ->
        location.reload()
    )
    return false
  $('.cloneForm').submit ->
    $form = $(this)
    $button = $form.find('.btn')
    $.ajax (
      url: $form.attr('action')
      type: $form.attr('method')
      data: $form.serialize()
      beforeSend: ->
        $button.button('loading')
      complete: ->
        $button.button('reset')
      success: ->
        location.reload()
      error: ->
        location.reload()
    )
    return false
