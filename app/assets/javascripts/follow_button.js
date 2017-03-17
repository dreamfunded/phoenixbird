$.fn.followBtn = function() {
  function FollowButton(following) {
    let that = this;
    that.following = following || false;

    that.click = function() {
      that.following = !that.following;
      $.ajax({
        url: '/api/companies/'+ that.company_id +'/follow',
        method: {true: "POST", false: "DELETE"}[that.following],
        dataType: "json",
        error: function() {
          that.following = !that.following;
          _toggleClass(that.$el);
        }
      })
    }

    function _toggleClass($el) {
      let className = {true: 'fa fa-heart', false: 'fa fa-heart-o'}[that.following];
      $el.attr('class', className);
    }

    that.render = function() {
      that.$el = $('<div>');
      _toggleClass(that.$el)
      return this;
    }
  }

  this.each(function() {
    var $this = $(this);
    var following = $this.data('following');
    var followBtn = new FollowButton(following);
    followBtn.company_id = $this.data('company-id');
    $this.html(followBtn.render().$el);
    $this.click(function(e) {
      e.preventDefault();
      followBtn.click();
      $this.html(followBtn.render().$el);
    })
  })
}
