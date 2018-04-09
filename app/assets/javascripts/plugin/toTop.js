jQuery(document).ready(function($) {	
			if($("meta[name=toTop]").attr("content")=="true"){
				$("<div id='toTop'><span class='iconfont icon-arrow-right toTop'></span></div>").appendTo('body');
				$("#toTop").css({
					width: '40px',
					height: '40px',
					bottom:'90px',
					right:'15px',
					position:'fixed',
					cursor:'pointer',
					zIndex:'222',
                    background:'#fff',
                    border:'1px solid #e6e6e6',
                    textAlign:'center',
                    lineHeight:'40px',
                    borderTop: 'none'

				});
                $(".toTop").css({
                    fontSize:'22px',
                    color:'#868686',
                    marginRight:'0',
                    transform:'rotate(-90deg)',
                });
				if($(this).scrollTop()==0){
						$("#toTop").hide();
					}
				$(window).scroll(function(event) {
					/* Act on the event */
					if($(this).scrollTop()==0){
						$("#toTop").hide();
					}
					if($(this).scrollTop()!=0){
						$("#toTop").show();
					}
				});	
					$("#toTop").click(function(event) {
								/* Act on the event */
								$("html,body").animate({
									scrollTop:"0px"},
									300
									)
							});
				}
		});