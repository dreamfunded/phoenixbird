$.fn.followBtn = function() {
  function FollowButton(following) {
    let _this = this;
    _this.following = following || false;

    _this.click = function() {
      _this.following = !_this.following;
      $.ajax({
        url: '/api/companies/'+ _this.company_id +'/follow',
        method: {true: "POST", false: "DELETE"}[_this.following],
        dataType: "json",
        error: function() {
          _this.following = !_this.following;
          _toggleClass(_this.$el);
        }
      })
    }

    function _toggleClass($el) {
      let className = {true: 'fa fa-heart', false: 'fa fa-heart-o'}[_this.following];
      $el.attr('class', className);
    }

    _this.render = function() {
      _this.$el = $('<div>');
      _toggleClass(_this.$el)
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