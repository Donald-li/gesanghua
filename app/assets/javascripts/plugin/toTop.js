jQuery(document).ready(function($) {	
			if($("meta[name=toTop]").attr("content")=="true"){
				$("<div id='toTop'><span class='iconfont icon-arrow-right toTop'></span></div>").appendTo('body');
				$("#toTop").css({
					width: '40px',
					height: '40px',
					bottom:'400px',
					right:'15px',
					position:'fixed',
					cursor:'pointer',
					zIndex:'999999',
                    background:'#fff',
                    border:'1px solid #e6e6e6',
                    textAlign:'center',
                    lineHeight:'40px'
				});
                $(".toTop").css({
                    fontSize:'14px',
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
									666
									)
							});
				}
		});