$(function(){
	var userId = getQueryString("userId")
	var languageCode = getQueryString("languageCode");
	var str = getQueryString("model");
	var url = window.location.href;
	console.log(userId)
function stepLine(stepNum, stepGoal) {
	var num = stepNum / stepGoal * 100;
	num = (num > 100) ? 100 : num;
	$('.showDiv').css('width', num + '%')
}
function getAllData(id, path) {
	$.ajax({
		type: "post",
		url: "http://apitest.dongha.cn:9999/sport/" + path + "?userId=" + id,
		async: true,
		success: function(data) {
			console.log(data)
			var data = data.data;			
			var str = '';
			for(var i = 0; i < data.items.length; i++) {
				if(data.items[i].liked) {
					str += '<div class="rank_list">' +
						'<div class="rank_list_l clearfix">' +
						'<div class="rankNum fl"><span>' + (i + 1) + '</span></div>' +
						'<div class="headIcon fl"><span><img src="' + data.items[i].image + '"/></span></div>' +
						'</div>' +
						'<div class="rank_list_r">' +
						'<div class="middle-content clearfix">' +
						'<div class="rank_name fl">' +
						'<p>' + data.items[i].nickname + '</p>' +
						'<span style="color: #fff;">' + data.items[i].country + '</span>' +
						'</div>' +
						'<div class="rank_list_num fr">' +
						'<span>' + data.items[i].step + '</span>' +
						'</div>' +
						'</div>' +
						'<div class="list_heartWrap" data-id="'+data.items[i].userId+'">' +
						'<p class="list_heartNum">' + data.items[i].likes+ '</p>' +
						'<div class="likesImg active"></div>' +
						'</div>' +
						'</div>' +
						'</div>'						
				} 
				else {
					str += '<div class="rank_list">' +
						'<div class="rank_list_l clearfix">' +
						'<div class="rankNum fl"><span>' + (i + 1) + '</span></div>' +
						'<div class="headIcon fl"><span><img src="' + data.items[i].image + '"/></span></div>' +
						'</div>' +
						'<div class="rank_list_r">' +
						'<div class="middle-content clearfix">' +
						'<div class="rank_name fl">' +
						'<p>' + data.items[i].nickname + '</p>' +
						'<span style="color: #fff;">' + data.items[i].country + '</span>' +
						'</div>' +
						'<div class="rank_list_num fr">' +
						'<span>' + data.items[i].step + '</span>' +
						'</div>' +
						'</div>' +
						'<div class="list_heartWrap" data-id="'+data.items[i].userId+'">' +
						'<p class="list_heartNum">' + data.items[i].likes + '</p>' +
						'<div class="likesImg"></div>' +
						'</div>' +
						'</div>' +
						'</div>'
				}
		}						
			if(data.background == '' || data.background == null){
				$('.covers').find('.bgImg').attr("src", 'images/res/bg_pic@2x.png')
				}else{
					$('.covers').find('.bgImg').attr("src", data.background)
				}			
				$('.covers').find('.userImage').attr("src", data.userImage)
				$('.covers').find('.userName').html(data.nickname)
				$('.covers').find('.userStepGoal').html(data.stepGoal)
				$('.covers').find('.personNum').html(data.personNum)
				stepLine(data.step, data.stepGoal);
			if(path == 'globalStepRank') {
				console.log('globalStepRank')
				
				$('#page').find('.rank_list_global').html(str);
				$('#page .global_rank').find('.userImg').attr('src', data.userImage);
				$('#page .global_rank').find('.userStepRank').html(data.rank)
				$('#page .global_rank').find('.userStepNum').html(data.step)
				$('#page .global_rank').find('.heartNum').html(data.likes)
				$('.global_rank .list_heartWrap').each(function(item, el) {
					$(this).on('tap', function(e) {
						e.stopPropagation();
						var id = userId;
						var _this = $(this);
						var _val = parseInt(_this.find('.list_heartNum').text());
						var friendId =_this.attr('data-id');						
						$.ajax({
							type: "post",
							url: "http://apitest.dongha.cn:9999/rankLikes/likes?userId=" + id +'&'+'friendId='+friendId,
							async: true,
							success: function(res) {
								console.log(res)
								_this.find('.likesImg').toggleClass('active');
								if(_this.find('.likesImg').hasClass('active')) {
									_this.find('.list_heartNum').text(Number(_val + 1))
								} else {
									_this.find('.list_heartNum').text(Number(_val - 1))
								};
								
							}
						});						
					})
				})
			} else if(path == 'nationalStepRank') {
				console.log('nationalStepRank')
				$('#page').find('.rank_list_country').html(str);
				$('#page .country_rank').find('.userImg').attr('src', data.userImage);
				$('#page .country_rank').find('.userStepRank').html(data.rank)
				$('#page .country_rank').find('.userStepNum').html(data.step)
				$('#page .country_rank').find('.heartNum').html(data.likes)
				$('.country_rank .list_heartWrap').each(function(item, el) {
					$(this).on('tap', function(e) {
						e.stopPropagation();
						console.log(item)
						var id = userId;
						var _this = $(this);
						var _val = parseInt(_this.find('.list_heartNum').text());
						var friendId =_this.attr('data-id');						
						$.ajax({
							type: "post",
							url: "http://apitest.dongha.cn:9999/rankLikes/likes?userId=" + id +'&'+'friendId='+friendId,
							async: true,
							success: function(res) {
								console.log(res)
								_this.find('.likesImg').toggleClass('active');
								if(_this.find('.likesImg').hasClass('active')) {
									_this.find('.list_heartNum').text(Number(_val + 1))
								} else {
									_this.find('.list_heartNum').text(Number(_val - 1))
								};
								
							}
						});						
					})
				})
			} else if(path == 'followStepRank') {
				$('#page').find('.rank_list_concern').html(str);
				$('#page .concern_rank').find('.userImg').attr('src', data.userImage);
				$('#page .concern_rank').find('.userStepRank').html(data.rank)
				$('#page .concern_rank').find('.userStepNum').html(data.step)
				$('#page .concern_rank').find('.heartNum').html(data.likes)
				if($('#page').find('.rank_list_concern').html() == '') {
					console.log('show')
					$('#page').find('.addConcern').show()
				} else {
					$('#page').find('.addConcern').hide()
					console.log('hide')
				}
				$('.concern_rank .list_heartWrap').each(function(item, el) {
					console.log(el)
					$(this).on('tap', function(e) {
						e.stopPropagation();
						var id = userId;
						var _this = $(this);
						var _val = parseInt(_this.find('.list_heartNum').text());
						var friendId =_this.attr('data-id');						
						$.ajax({
							type: "post",
							url: "http://apitest.dongha.cn:9999/rankLikes/likes?userId=" + id +'&'+'friendId='+friendId,
							async: true,
							success: function(res) {
								console.log(res)
								_this.find('.likesImg').toggleClass('active');
								if(_this.find('.likesImg').hasClass('active')) {
									_this.find('.list_heartNum').text(Number(_val + 1))
								} else {
									_this.find('.list_heartNum').text(Number(_val - 1))
								};
								
							}
						});						
					})
				})
			}
		}
	});
}
getAllData(userId, 'globalStepRank');
//点赞
$('.heartWrap').on('tap', function(e) {
	e.stopPropagation();
	var id = userId;
	var _this = $(this);
	var _val = parseInt(_this.find('.heartNum').text())
	
	$.ajax({
		type: "post",
		url: "http://apitest.dongha.cn:9999/rankLikes/likes?userId=" + id +'&'+'friendId='+id,
		async: true,
		success: function(res) {
			console.log(res)
			_this.find('.likesImg').toggleClass('active');

			if(_this.find('.likesImg').hasClass('active')) {
				_this.find('.heartNum').text(Number(_val + 1))
			} else {
				_this.find('.heartNum').text(Number(_val - 1))
			}
		}
	});
})


//dianzan End
tSpeed = 300 //切换速度300ms
//var topHeight = $('#top').height(); // ios:287
//var navMarginTop = $('.navMarginTop').height(); // ios:247
//var navOffsettop = $('#nav').height(); // ios:40

var navOffsettop = $('#nav').offset().top; // 160
var navHeight = $('#nav').height(); // 40
var topHeight = navOffsettop + navHeight; // 200
var navSwiper = new Swiper('#nav', {
	slidesPerView: 3,
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
			for(i = 0; i < this.slides.length; i++) {
				navWidth += parseInt(this.slides.eq(i).css('width'))
			}
			topBar = this.$el.parents('body').find('#top') //页头
		},
		touchStart: function() {
			if(scrollSwiper) {
				console.log('transitionStart-if2')
				for(sc = 0; sc < scrollSwiper.length; sc++) {
					if(scrollSwiper[sc].translate < 72 && scrollSwiper[sc].translate > 0) {
						scrollSwiper[sc].setTransition(tSpeed);
						scrollSwiper[sc].setTranslate(topHeight)
					}
				}
			}
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
		},

		transitionStart: function() {
			activeIndex = this.activeIndex
			console.log(activeIndex)
			activeSlidePosition = navSwiper.slides[activeIndex].offsetLeft
			//
			if(pageSwiper.activeIndex == 0) {
				getAllData(userId, 'globalStepRank')
			} else if(pageSwiper.activeIndex == 1) {
				getAllData(userId, 'nationalStepRank')
			} else if(pageSwiper.activeIndex == 2) {
				getAllData(userId, 'followStepRank')
			}
			//
			//释放时导航粉色条移动过渡
			//			bar.transition(tSpeed)
			//			bar.transform('translateX(' + activeSlidePosition + 'px)')
			//释放时文字变色过渡
			navSwiper.slides.eq(activeIndex).find('span').transition(tSpeed)
			navSwiper.slides.eq(activeIndex).find('span').css('color', 'rgba(255, 19, 83,1)')
			if(activeIndex > 0) {
				navSwiper.slides.eq(activeIndex - 1).find('span').transition(tSpeed)
				navSwiper.slides.eq(activeIndex - 1).find('span').css('color', 'rgba(153, 153, 153,1)')
			}
			if(activeIndex < this.slides.length) {
				navSwiper.slides.eq(activeIndex + 1).find('span').transition(tSpeed)
				navSwiper.slides.eq(activeIndex + 1).find('span').css('color', 'rgba(153, 153, 153,1)')
			}
			//导航居中
			navActiveSlideLeft = navSwiper.slides[activeIndex].offsetLeft //activeSlide距左边的距离

			navSwiper.setTransition(tSpeed)
			if(navActiveSlideLeft < (clientWidth - parseInt(navSlideWidth)) / 2) {
				navSwiper.setTranslate(0)
			} else if(navActiveSlideLeft > navWidth - (parseInt(navSlideWidth) + clientWidth) / 2) {
				navSwiper.setTranslate(clientWidth - navWidth)
			} else {
				navSwiper.setTranslate((clientWidth - parseInt(navSlideWidth)) / 2 - navActiveSlideLeft)
			}
		}
	}
});
navSwiper.$el.on('touchstart', function(e) {
	e.preventDefault() //去掉按压阴影
})
//点击切换  
navSwiper.on('tap', function(e) {
	clickIndex = this.clickedIndex
	clickSlide = this.slides.eq(clickIndex)
	pageSwiper.slideTo(clickIndex, 0);
	this.slides.find('span').css('color', 'rgba(153, 153, 153, 1)');
	clickSlide.find('span').css('color', 'rgba(255, 19, 83,1)');
	//
})
//内容滚动			
var scrollSwiper = new Swiper('.scroll', {
	slidesOffsetBefore: topHeight,
	direction: 'vertical',
	freeMode: true,
	slidesPerView: 'auto',
	mousewheel: {
		releaseOnEdges: true,
	},
	on: {
		touchMove: function() {
			if(this.translate > navHeight && this.translate < topHeight) {
				topBar.transform('translateY(' + this.translate - topHeight + 'rem)');
			}
		},
		touchStart: function() {
			startPosition = this.translate
		},
		touchEnd: function() {

			topBar.transition(tSpeed)
			if(this.translate > navHeight && this.translate < topHeight && this.translate < startPosition) {
				topBar.transform('translateY(-' + navOffsettop + 'px)');
				console.log('touchEnd-if1')
				for(sc = 0; sc < scrollSwiper.length; sc++) {
					//					console.log(this.translate)
					if(scrollSwiper[sc].translate > navHeight) {
						console.log('scrollSwiper[sc].translate > 40')
						scrollSwiper[sc].setTransition(tSpeed);
						scrollSwiper[sc].setTranslate(navHeight)

					}
				}
			}
			if(this.translate > navHeight && this.translate < topHeight && this.translate > startPosition) {
				topBar.transform('translateY(0px)');
				console.log('touchEnd-if2')
				for(sc = 0; sc < scrollSwiper.length; sc++) {
					//					console.log(scrollSwiper[sc].translate)
					if(scrollSwiper[sc].translate < topHeight && scrollSwiper[sc].translate > 0) {
						scrollSwiper[sc].setTransition(tSpeed);
						scrollSwiper[sc].setTranslate(navHeight)
					}
				}
			}
		},

		transitionStart: function() {

			topBar.transition(tSpeed);

			if(this.translate < navHeight) {
				console.log('transitionStart-if1')
				topBar.transform('translateY(-'+navOffsettop+'px)');
				$('#page .slidepage .swiper-wrapper').css('transform', 'translate3d(0px, '+navHeight+'px, 0px)')
				if(scrollSwiper) {
					if(pageSwiper.activeIndex == 0) {
						getAllData(userId, 'globalStepRank')
					} else if(pageSwiper.activeIndex == 1) {
						getAllData(userId, 'nationalStepRank')
					} else if(pageSwiper.activeIndex == 2) {
						getAllData(userId, 'followStepRank')
					}
					for(sc = 0; sc < scrollSwiper.length; sc++) {
						//						console.log(scrollSwiper[sc].translate)
						if(scrollSwiper[sc].translate > 36) {
							scrollSwiper[sc].setTransition(tSpeed);
							scrollSwiper[sc].setTranslate(navHeight)
						}
					}
				}

			} else {

				topBar.transition(tSpeed);
				topBar.transform('translateY(0px)');
				$('#page .slidepage .swiper-wrapper').css('transform', 'translate3d(0px, '+topHeight+'px, 0px)')
				if(scrollSwiper) {
					console.log('transitionStart-if2')
					//
					if(pageSwiper.activeIndex == 0) {
						getAllData(userId, 'globalStepRank')
					} else if(pageSwiper.activeIndex == 1) {
						getAllData(userId, 'nationalStepRank')
					} else if(pageSwiper.activeIndex == 2) {
						getAllData(userId, 'followStepRank')
					}
					//
					console.log(pageSwiper.activeIndex)
					for(sc = 0; sc < scrollSwiper.length; sc++) {
						if(scrollSwiper[sc].translate < 72 && scrollSwiper[sc].translate > 0) {
							scrollSwiper[sc].setTransition(tSpeed);
							scrollSwiper[sc].setTranslate(topHeight)
						}
					}
				}
			}
		},
	}

})
})