// if window < 480
function metaContent(){
    var mvp = document.getElementById('myViewport');
    if(window.innerWidth <= 480) {
        mvp.setAttribute('content','width=480, user-scalable=no');
    } else {
        mvp.setAttribute('content','width=device-width, initial-scale=1');
    };
};
window.onload = function () {
	setTimeout(function() {
	    metaContent();
		$(window).trigger('resize');
	}, 150);
};
$(window).resize(function() {
    metaContent();
});

window.addEventListener("orientationchange", function() {
    metaContent();
});

// header on scroll
var headerScroll = function() {
	var st = $(window).scrollTop();
	if (st > 80) {
		if (!$('header').hasClass('scrolled')) {
			$('header').addClass('scrolled');
			$('.header__user').removeClass('active');
			setTimeout(function() {
				$('header').addClass('showed');
			}, 50);
		}
	} else {
		$('header').removeClass('scrolled showed');
	}
}

$(window).on('scroll', function() {
	headerScroll();
});

$(window).on('resize', function() {
	headerScroll();
});

headerScroll();

// footer on bottom
var footerOnBottom = function () {
  var wh = $(window).innerHeight();
  var fh = $('footer').outerHeight();
  $('.content-without-footer').css('min-height', wh-fh);
}
$(window).on('load', function () {
  footerOnBottom();
})
$(document).ready(function () {
  footerOnBottom();
})
$(window).on('resize', function () {
  footerOnBottom();
})


// mob menu
//// mob menu open
$('.header__mob-trig').on('click', function(e) {
	$('body').addClass('mob-menu-open');
	e.preventDefault();
});
//// mob menu close
$('.header__mob-close').on('click', function(e) {
	$('body').removeClass('mob-menu-open');
	e.preventDefault();
});



//profile mob menu
$('.profile__sidebar__mob').on('click', function(e) {
	$('.profile__sidebar').toggleClass('active');
	e.preventDefault();
});
$(document).click(function(event) {
	if ($(event.target).closest(".profile__sidebar").length) return;
	$('.profile__sidebar').removeClass('active');
});

// file input
$('.file-input input[type="file"]').on('change', function () {
	var th = $(this),
		par = th.closest('.file-input'),
		txt = par.find('.file-input__txt'),
		title = par.attr('data-title'),
		file =th.val().replace("C:\\fakepath\\", "");
	if (file.length > 0) {
		txt.text(file);
	} else {
		txt.text(title);
	}
})

// bootstrap select
$('select.selectpicker').selectpicker();

// video
$('.investTop__video__play').on('click', function(e) {
	var th = $(this),
		par = th.closest('.investTop__video'),
		video = par.attr('data-video'),
		framepar = par.find('.investTop__video__video');
	par.addClass('active');
	framepar.html('<iframe src="' + video + '?autoplay=1&showinfo=0&modestbranding=1"></iframe>');
	e.preventDefault();
});

$('.investTop__video__close').on('click', function(e) {
	var th = $(this),
		par = th.closest('.investTop__video'),
		framepar = par.find('.investTop__video__video');
	par.removeClass('active');
	framepar.empty();
	e.preventDefault();
});

// project team slider
if ($('.project__team__slider').length > 0) {
	var projectTeamSliderInit = function() {
		var slider = $('.project__team__slider');
		if (!slider.hasClass('slick-initialized')) {
			slider.slick({
				dots: true,
				infinite: true,
				speed: 300,
				slidesToShow: 2,
				slidesToScroll: 1,
				prevArrow: '',
				nextArrow: '',
				edgeFriction: 0,
				adaptiveHeight: true,
				responsive: [
					{
						breakpoint: 768,
						settings: {
							slidesToShow: 1
						}
					}
				]
			})
		}
	}

	var projectTeamSliderDestroy = function() {
		var slider = $('.project__team__slider');
		if (slider.hasClass('slick-initialized')) {
			slider.slick('unslick');
		}
	}

	var projectTeamSliderCheck = function() {
		var ww = $(window).innerWidth();
		if (ww < 992) {
			projectTeamSliderInit();
		} else {
			projectTeamSliderDestroy();
		}
	}

	projectTeamSliderCheck();

	$(window).on('resize', function() {
		projectTeamSliderCheck();
	})
}

// header user drop
$('.header__user > a').on('click', function(e) {
	$(this).closest('.header__user').toggleClass('active');
	e.preventDefault();
});
$(document).click(function(event) {
	if ($(event.target).closest(".header__user").length) return;
	$('.header__user').removeClass('active');
});
