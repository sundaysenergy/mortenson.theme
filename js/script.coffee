$(document).ready () ->

  if (!window.make_id)
    make_id = 'mortenson';
    console.log('No make_id variable found or it is false')
  else
    make_id = window.make_id

  endpoint = 'http://'+make_id+'.cape.io/_view/client_data/_output'
  endpoint = '/projects-full.json'

  update = () ->
    $.getJSON endpoint, (new_data) ->
      if (new_data)
        $('div#slideshow div.active').html(template.render({projects: new_data}))
        plugins = [ListFuzzySearch()]
        options =
          valueNames: ['name']
          page: 300
          plugins: plugins
        memberList = new List('list', options)
      else
        console.log 'NO DATA'

  template = Hogan.compile($('#slideshow-template').html())

  # START THE PROCESS
  update();
