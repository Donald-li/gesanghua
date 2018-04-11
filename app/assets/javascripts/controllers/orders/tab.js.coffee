$ ->
  #tab选择
  $('.panel-tabs li').click ->
    action = $(this).attr('url')
    if action
      $(this).parent().parent().parent().parent().find('.tab-pane.active').load action, ->

#  # 自动加载默认tab
#  $('.panel-tabs').each ->
#    action = $(this).attr('url')
#    if action
#      $(this).parent().parent().find('.tab-pane.active').load action, ->
#
#  $('#more-tab-wrap').mouseleave ->
#    $(this).find('.tab-more-options').hide()
#    $(this).find('.select-down').attr('is-open', false)
#
#  $('.select-down').click ->
#    if $(this).attr('is-open') == 'false'
#      $(this).next().show()
#      $(this).attr('is-open', true)
#    else
#      $(this).next().hide()
#      $(this).attr('is-open', false)
#
#  $('.tab-more-options li').click ->
#    $(this).parent().hide()
#    $(this).parent().prev().attr('is-open', false)
#    action = $(this).attr('url')
#    if action
#      $(this).parent().parent().parent().parent().parent().find('.tab-pane.active').load action, ->
