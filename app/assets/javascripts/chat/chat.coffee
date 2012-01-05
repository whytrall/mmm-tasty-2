Chat =
  current_uuid: null
  height: null
  cache:
    seq: {}
    ids: {}
  opts: {}
  spin_opts:
    lines: 10             # The number of lines to draw
    length: 3             # The length of each line
    width: 2              # The line thickness
    radius: 1             # The radius of the inner circle
    color: '#000'         # #rgb or #rrggbb
    speed: 1              # Rounds per second
    trail: 54             # Afterglow percentage
    shadow: false         # Whether to render a shadow
  tpl:
    channel: "<div class='channel' id='channel{{uuid}}' data-uuid='{{uuid}}' data-name='{{name}}'><span class='counter' data-value='0'></span>{{name}}</div>"
    chanmsg: "
      <div class='scrollbars' id='scrollbar{{uuid}}'>
        <div class='viewport' id='viewport{{uuid}}'>
          <div class='overview' id='chanmsg{{uuid}}' data-uuid='{{uuid}}'></div>
        </div>
      </div>"
    message: "
    <div class='message clearfix' id='message{{id}}' data-id='{{id}}'>
      {{#userpic}}
        <div class='userpic'>
          <a href='http://{{url}}.mmm-tasty.ru/' target='_blank'>
            <img src='{{userpic}}' alt='{{url}}' width='{{userpic_width}}' height='{{userpic_height}}' />
          </a>
        </div>
      {{/userpic}}
      {{^userpic}}
        <div class='userpic'>&nbsp;</div>
      {{/userpic}}
      <div class='rel'>
        <div class='info'>
          <div class='username'><a href='http://{{url}}.mmm-tasty.ru/' target='_blank'>{{url}}</a></div>
          <div class='timestamp' title='{{iso8601}}'>{{time}}</div>
        </div>
        <div class='text'>{{text}}</div>
      </div>
    </div>"
    
  
  ready: (opts = {}) ->
    Chat.opts = opts if opts?
    
    # resize chat window to fit
    Chat.height = jQuery(window).height() - jQuery('.top').height() - jQuery('#compose').height() - 100;
    Chat.height = 100 if Chat.height < 100  
    jQuery('#channels .content').css
      height: Chat.height + 'px'

    # bind all html hooks
    Chat.bind()

    # initialize in sequence of calls
    jQuery.when(Chat.ajax.recent()).done ->
      jQuery.when(Chat.autoJoin()).done ->
        Chat.scheduleRefresh()
  
  bind: ->    
    jQuery('.channel').live 'click', (_event) ->
      Chat.setActiveChannel jQuery(this).data('uuid')
      false

    jQuery('#compose form textarea').placeholder()

    jQuery('#compose form textarea').bind 'keydown', 'Ctrl+return', (_event) ->
      jQuery('#compose form').submit()
      false

    jQuery('#compose form').submit ->
      if chan = Chat.getActiveChannel()
        Chat.ajax.post chan, jQuery('#compose form textarea').val()
      false

  autoJoin: ->
    chans = (jQuery(chan).data('name') for chan in jQuery('.channel'))
    for chan in Chat.opts.autojoin
      Chat.ajax.join(chan) unless chan in chans

  getActiveChannel: ->
    result = null
    if Chat.current_uuid
      result =
        uuid: Chat.current_uuid
        name: jQuery("#channel#{Chat.current_uuid}").data('name')
    
    result

  setActiveChannel: (channel_uuid) ->
    if Chat.current_uuid
      jQuery("#scrollbar#{Chat.current_uuid}").hide();
      jQuery("#channel#{Chat.current_uuid}").removeClass('active');
  
    Chat.dom.resetCounter channel_uuid
    jQuery("#scrollbar#{channel_uuid}").show().tinyscrollbar_update('bottom')
    jQuery("#channel#{channel_uuid}").addClass('active')
    Chat.current_uuid = channel_uuid

  scheduleRefresh: ->
    setTimeout Chat.doRefresh, Chat.opts?.timeout? || 5000

  doRefresh: ->
    jQuery.when(Chat.ajax.recent()).done(Chat.scheduleRefresh)


  dom:
    resetCounter: (channel_uuid) ->
      jQuery("#channel#{channel_uuid} .counter").data('value', 0).hide()

      true

    updateCounter: (channel_uuid) ->
      return if channel_uuid == Chat.current_uuid

      obj   = jQuery("#channel#{channel_uuid} .counter")
      value = obj.data('value')
      if value > 0
        value += 1
        obj.data 'value', value
        obj.text "(#{value})"
      else
        obj.data 'value', 1
        obj.text '(1)'

      obj.show()

    renderMessage: (channel_uuid, message) ->
      if jQuery("#message#{message.id}").length == 0
        Chat.cache.seq[channel_uuid] = Math.max(Chat.cache.seq[channel_uuid] || 0, message.seq)

        jQuery("#chanmsg#{channel_uuid}").append Mustache.to_html(Chat.tpl.message, message)
        jQuery("#message#{message.id} .timestamp").timeago()

        Chat.dom.updateCounter channel_uuid

        jQuery("#scrollbar#{channel_uuid}").tinyscrollbar_update 'bottom'
        
        # trim queue if it exceeds 250 entries
        if Chat.cache.ids[channel_uuid].push(message.id) > 250
          jQuery("#message#{Chat.cache.ids[channel_uuid].shift()}").remove()
    
    closeChannel: (channel) ->
      # FIXME: not implemented
      delete Chat.cache.seq[channel.uuid]
      delete Chat.cache.ids[channel.uuid]
    
    createChannel: (channel) ->
      if jQuery("#scrollbar#{channel.uuid}").length == 0
        Chat.cache.seq[channel.uuid] = 0
        Chat.cache.ids[channel.uuid] = []

        jQuery('#channels .list').append Mustache.to_html(Chat.tpl.channel, channel)
        jQuery('#channels .content').append Mustache.to_html(Chat.tpl.chanmsg, channel)

        jQuery("#viewport#{channel.uuid}").css
          height: Chat.height + 'px'
        jQuery("#scrollbar#{channel.uuid}").tinyscrollbar()

        if Chat.current_uuid?
          jQuery("#scrollbar#{channel.uuid}").hide()
        else
          Chat.setActiveChannel channel.uuid

    renderChannel: (channel) ->
      Chat.dom.createChannel channel

      Chat.dom.renderMessage(channel.uuid, message) for message in channel.messages

    renderRecent: (data) ->
      Chat.dom.renderChannel(channel) for channel in data
    
    disableTextarea: ->
      jQuery('#compose form textarea').val('').attr 'disabled', 'disabled'
      jQuery('#submit').attr 'disabled', 'disabled'
      jQuery('#submit_spinner').spin Chat.spin_opts
    
    enableTextarea: ->
      jQuery('#compose form textarea').removeAttr 'disabled'
      jQuery('#submit').removeAttr 'disabled'
      jQuery('#submit_spinner').spin false
  
  ajax:
    error: ->
      jQuery('#chat_errors').show()
    
    recent: ->
      jQuery.ajax
        url: '/specials/newyear/recent'
        type: 'post'
        dataType: 'json'
        data:
          authenticity_token: window._token
          after: Chat.cache.seq
        error: Chat.ajax.error
        success: Chat.dom.renderRecent
      
    post: (channel, text) ->
      if text? && text.length > 0
        Chat.dom.disableTextarea()
      
        jQuery.ajax
          url: '/specials/newyear/post'
          type: 'post'
          dataType: 'json'
          data:
            authenticity_token: window._token
            name: channel.name
            after: Chat.cache.seq[channel.uuid]
            text: text
          error: Chat.ajax.error
          success: Chat.dom.renderRecent
          complete: Chat.dom.enableTextarea

    join: (name) ->
      jQuery.ajax
        url: '/specials/newyear/join'
        type: 'post'
        dataType: 'json'
        data:
          authenticity_token: window._token
          name: name
        error: Chat.ajax.error
        success: Chat.dom.renderRecent

    leave: (name) ->
      jQuery.ajax
        url: '/specials/newyear/leave'
        type: 'post'
        dataType: 'json'
        data:
          authenticity_token: window._token
          name: name
        error: Chat.ajax.error
        success: Chat.dom.closeChannel
