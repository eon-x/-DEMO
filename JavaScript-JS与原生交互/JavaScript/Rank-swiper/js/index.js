  
  //暂时设计每个slide大小需要一致
  barwidth = 36 //导航粉色条的长度px
  tSpeed = 300 //切换速度300ms
  var navSwiper = new Swiper('#nav', {
  	slidesPerView: 6,
  	freeMode: true,
  	on: {
  		init: function() {
  			navSlideWidth = this.slides.eq(0).css('width'); //导航字数需要统一,每个导航宽度一致
  			bar = this.$el.find('.bar')
  			bar.css('width', navSlideWidth)
  			bar.transition(tSpeed)
  			navSum = this.slides[this.slides.length - 1].offsetLeft //最后一个slide的位置

  			clientWidth = parseInt(this.$wrapperEl.css('width')) //Nav的可视宽度
  			navWidth = 0
  			for (i = 0; i < this.slides.length; i++) {
  				navWidth += parseInt(this.slides.eq(i).css('width'))
  			}

  			topBar = this.$el.parents('body').find('#top') //页头

  		},

  	},
  });

  var pageSwiper = new Swiper('#page', {
  	watchSlidesProgress: true,
  	resistanceRatio: 0,
  	on: {
  		touchMove: function() {
  			progress = this.progress
  			bar.transition(0)
  			bar.transform('translateX(' + navSum * progress + 'px)')
  			//粉色255,72,145灰色51,51,51
  			for (i = 0; i < this.slides.length; i++) {
  				slideProgress = this.slides[i].progress
  				if (Math.abs(slideProgress) < 1) {
  					r = Math.floor((255 - 51) * (1 - Math.pow(Math.abs(slideProgress), 2)) + 51)
  					g = Math.floor((72 - 51) * (1 - Math.pow(Math.abs(slideProgress), 2)) + 51)
  					b = Math.floor((145 - 51) * (1 - Math.pow(Math.abs(slideProgress), 2)) + 51)
  					navSwiper.slides.eq(i).find('span').css('color', 'rgba(' + r + ',' + g + ',' + b + ',1)')
  				}
  			}
  		},
  		transitionStart: function() {
  			activeIndex = this.activeIndex
  			activeSlidePosition = navSwiper.slides[activeIndex].offsetLeft
  			//释放时导航粉色条移动过渡
  			bar.transition(tSpeed)
  			bar.transform('translateX(' + activeSlidePosition + 'px)')
  			//释放时文字变色过渡
  			navSwiper.slides.eq(activeIndex).find('span').transition(tSpeed)
  			navSwiper.slides.eq(activeIndex).find('span').css('color', 'rgba(255,72,145,1)')
  			if (activeIndex > 0) {
  				navSwiper.slides.eq(activeIndex - 1).find('span').transition(tSpeed)
  				navSwiper.slides.eq(activeIndex - 1).find('span').css('color', 'rgba(51,51,51,1)')
  			}
  			if (activeIndex < this.slides.length) {
  				navSwiper.slides.eq(activeIndex + 1).find('span').transition(tSpeed)
  				navSwiper.slides.eq(activeIndex + 1).find('span').css('color', 'rgba(51,51,51,1)')
  			}
  			//导航居中
  			navActiveSlideLeft = navSwiper.slides[activeIndex].offsetLeft //activeSlide距左边的距离

  			navSwiper.setTransition(tSpeed)
  			if (navActiveSlideLeft < (clientWidth - parseInt(navSlideWidth)) / 2) {
  				navSwiper.setTranslate(0)
  			} else if (navActiveSlideLeft > navWidth - (parseInt(navSlideWidth) + clientWidth) / 2) {
  				navSwiper.setTranslate(clientWidth - navWidth)
  			} else {
  				navSwiper.setTranslate((clientWidth - parseInt(navSlideWidth)) / 2 - navActiveSlideLeft)
  			}

  		},
  	}
  });

  navSwiper.$el.on('touchstart', function(e) {
  	e.preventDefault() //去掉按压阴影
  })
   navSwiper.on('tap', function(e) {

  	clickIndex = this.clickedIndex
  	clickSlide = this.slides.eq(clickIndex)
  	pageSwiper.slideTo(clickIndex, 0);
  	this.slides.find('span').css('color', 'rgba(51,51,51,1)');
  	clickSlide.find('span').css('color', 'rgba(255,72,145,1)');
  })

  //内容滚动			
  var scrollSwiper = new Swiper('.scroll', {
  	//65是头部的高
  	//36是top地址和搜索的高

  	slidesOffsetBefore: 72,
  	direction: 'vertical',
  	freeMode: true,
  	slidesPerView: 'auto',

  	mousewheel: {
  		releaseOnEdges: true,
  	},
  	on: {
  		touchMove: function() {

  			if (this.translate > 72 - 36 && this.translate < 72) {
  				topBar.transform('translateY(' + (this.translate - 72) + 'px)');
  			}

  		},
  		touchStart: function() {
  			startPosition = this.translate
  		},
  		touchEnd: function() {
  			topBar.transition(tSpeed)
  			if (this.translate > 36 && this.translate < 72 && this.translate < startPosition) {
  				topBar.transform('translateY(-36px)');
  				for (sc = 0; sc < scrollSwiper.length; sc++) {
  					if (scrollSwiper[sc].translate > 36) {
  						scrollSwiper[sc].setTransition(tSpeed);
  						scrollSwiper[sc].setTranslate(36)
  					}
  				}
  			}
  			if (this.translate > 36 && this.translate < 72 && this.translate > startPosition) {
  				topBar.transform('translateY(0px)');
  				for (sc = 0; sc < scrollSwiper.length; sc++) {
  					if (scrollSwiper[sc].translate < 72 && scrollSwiper[sc].translate > 0) {
  						scrollSwiper[sc].setTransition(tSpeed);
  						scrollSwiper[sc].setTranslate(72)
  					}
  				}
  			}
  		},

  		transitionStart: function() {

  			topBar.transition(tSpeed)
  			if (this.translate < 72 - 36) {
  				topBar.transform('translateY(-36px)');
  				if (scrollSwiper) {
  					for (sc = 0; sc < scrollSwiper.length; sc++) {
  						console.log(scrollSwiper[sc].translate)
  						if (scrollSwiper[sc].translate > 36) {
  							scrollSwiper[sc].setTransition(tSpeed);
  							scrollSwiper[sc].setTranslate(36)
  						}
  					}
  				}

  			} else {
  				topBar.transform('translateY(0px)');

  				if (scrollSwiper) {
  					for (sc = 0; sc < scrollSwiper.length; sc++) {
  						if (scrollSwiper[sc].translate < 72 && scrollSwiper[sc].translate > 0) {
  							scrollSwiper[sc].setTransition(tSpeed);
  							scrollSwiper[sc].setTranslate(72)
  						}
  					}
  				}
  			}
  		},
  	}

  })
  //热卖		
  var bannerSwiper = new Swiper('.banner', {
  	loop: true,
  	pagination: {
  		el: '.swiper-pagination',
  		type: 'fraction',
  		renderFraction: function(currentClass, totalClass) {
  			return '<span class="' + currentClass + '"></span>' + '/' + '<span class="' + totalClass + '"></span>';
  		},
  	},
  });
  //
