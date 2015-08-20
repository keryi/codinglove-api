$(document).on 'ready page:load', ->
  $('.posts').infinitePages

  $(document).keyup (e) ->
    current_post = sessionStorage.getItem('current_post')
    if current_post
      current_post = parseInt(current_post)

      if (e.which is 84)
        # t - top
        current_post = 1
      else if (e.which is 66)
        # b - bottom
        current_post = $('.post').length

      return if current_post < 1 || current_post > $('.post').length
      if (e.which is 74)
        # j - down
        current_post += 1
      else if (e.which is 75)
        # k - up
        current_post -= 1
      else
        # don't care
    else
      current_post = 1
    sessionStorage.setItem('current_post', current_post)
    to_post = $('.post')[parseInt(current_post) - 1]
    $('html, body').animate
      scrollTop: to_post.offsetTop - 50, 600
    $('.post.active').removeClass('active')
    $(to_post).addClass('active')
