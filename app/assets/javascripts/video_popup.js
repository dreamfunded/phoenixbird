$.fn.videoPopup = function() {
  var Overlay = function(video) {
    var _this = this;
    _this.video = video;
    _this.$container = $('body');
    _this.id = 'video-popup-overlay';
    _this.style = {
      position: 'fixed',
      top: 0,
      left: 0,
      width: '100%',
      height: '100%',
      'background-color': 'rgba(0,0,0, 0.8)',
      'z-index': 9000,
      'text-align': 'center'
    }

    _this.template = function() {
      return $('<div>', {
        id: _this.id,
        class: 'video-popup-overlay'
      });
    }

    _this.on_close = function() {}
    _this.on_open = function() {}

    _this.close_button = function() {
      _this.closeBtn = $('<div>');
      _this.closeBtn.css({
        position: 'absolute',
        top: '0',
        right: '0',
        color: 'white',
        'font-size': '2rem',
        padding: '80px',
        cursor: 'pointer'
      })
      _this.closeBtn.html('&times;');
      _this.closeBtn.click(function() {
        _this.$overlay.hide();
        _this.on_close();
      })
      return _this.closeBtn;
    }

    _this.render = function() {
      if (_this.$overlay) {
        _this.$overlay.show();
        return
      } else {
        let content_container = $('<div>', {id: 'video-content-container'});
        content_container.css({
          width: '100%',
          position: 'relative',
          display: 'inline-block',
          'vertical-align': 'middle',
          margin: '0 auto',
          'max-width': '900px',
          height: '500px'
        })
        _this.$overlay = _this.template();
        _this.$overlay.css(_this.style);
        _this.$overlay.append(_this.close_button());
        _this.$overlay.append(content_container);
        _this.$container.append(_this.$overlay);
        _this.video.render();
      }
      _this.on_open();
    }
  }
  var Video = function(link) {
    var _this = this;
    _this.$container = function(){return $('#video-content-container')};

    _this.template = function() {
      _this.video = $('<iframe>', {
        frameborder: '0',
        allowfullscreen: 'allowfullscreen',
        src: link
      });
      return _this.video;
    }

    _this.render = function() {
      var scaler = $('<div>', {class: 'video-fluid'});
      scaler.html(_this.template());
      _this.$container().html(scaler);
    }

    _this.play = function() {
    }

    _this.pause = function() {
    }
  }
  let _this = this;
  var video = new Video(_this.data('video-src'));
  var overlay = new Overlay(video);

  overlay.on_open = function() {
    video.play();
  }

  overlay.on_close = function() {
    video.pause();
  }

  this.click(function() {
    overlay.render();
  });
}