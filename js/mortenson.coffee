$(document).ready () ->

  if (!window.make_id)
    make_id = 'mortenson';
    console.log('No container_bucket variable found or it is false')
  else
    make_id = window.make_id

  endpoint = 'http://'+make_id+'.cape.io/_view/client_data/_output'
  endpoint = '/projects-full.json'
  index = 0
  data = false

  sec_per_slide = 5

  anime_by_size = (size) ->
    switch size
      when 1 then 'imageAnimationOne'
      when 3 then 'imageAnimationThree'
      when 4 then 'imageAnimationFour'
      when 5 then 'imageAnimationFive'
      when 6 then 'imageAnimationSix'
      when 7 or 8 then 'imageAnimationEight'
      when 9 or 10 then 'imageAnimationTen'
      when 11 or 12 then 'imageAnimationTwelve'
      else 'imageAnimationFifteen'

  update = () ->
    $.getJSON endpoint, (new_data) ->
      if (new_data)
        console.log 'Got json data.'
        data = new_data;
        new_slide(index)
      else
        console.log 'NO DATA'

  next_item = () ->
    item = data[index]
    unless item
      console.log 'Could not find item based on this index.'
      if 0 == index
        return false
      else
        index = 0
        item = next_item()
    unless item.testimonial
      console.log 'skiping ' + item.name
      index = index + 1
      item = next_item()
    unless item.images
      console.log 'skipping ' + item.name
      index = index + 1
      item = next_item()
    images_count = item.images.length
    item.images_duration = sec_per_slide * images_count
    default_animation_name = anime_by_size(images_count)
    item.images = _.map item.images, (image_source, i) ->
      unless _.isString image_source
        return image_source
      img_obj =
        source: image_source
        i: i
        delay: i * sec_per_slide
        animation_name: default_animation_name
      if i == 0
        img_obj.animation_name = 'imageAnimationFirst'
        img_obj.first = true
      else if i == (images_count-1)
        img_obj.animation_name = 'imageAnimationLast'
        img_obj.last = true
      return img_obj
    index = index + 1
    return item

  new_slide = () ->
    console.log 'Generate slide ' + index
    item = next_item()
    console.log item
    $('div#slideshow div.active').html(template.render(item))
    #$('div#slideshow div.next').html(template.render(next_item()))

    setTimeout new_slide, item.images_duration * 1000
    # console.log item
    return

  template = Hogan.compile($('#slideshow-template').html())

  # START THE PROCESS
  update();
