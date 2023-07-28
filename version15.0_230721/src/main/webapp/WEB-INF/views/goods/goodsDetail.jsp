<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" 	isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="goods"  value="${goodsMap.goodsVO}"  />
<c:set var="imageList"  value="${goodsMap.imageList }"  />
<link href="${contextPath}/resources/css/goods_detail_review.css" rel="stylesheet" type="text/css">
 <%
     //치환 변수 선언합니다.
      //pageContext.setAttribute("crcn", "\r\n"); //개행문자
      pageContext.setAttribute("crcn" , "\n"); //Ajax로 변경 시 개행 문자 
      pageContext.setAttribute("br", "<br/>"); //br 태그
%>  
<html>
<head>
<style>
#layer {
	z-index: 2;
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
}

#popup {
	z-index: 3;
	position: fixed;
	text-align: center;
	left: 50%;
	top: 45%;
	width: 300px;
	height: 200px;
	background-color: #ccffff;
	border: 3px solid #87cb42;
}

#close {
	z-index: 4;
	float: right;
}
</style>
<script type="text/javascript">
	function add_cart(goods_id) {
		var cart_goods_qty = $("#order_goods_qty").val();
		
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/cart/addGoodsInCart.do",
			data : {
				goods_id:goods_id,
				cart_goods_qty:cart_goods_qty
				
			},
			success : function(data, textStatus) {
				//alert(data);
			//	$('#message').append(data);
				if(data.trim()=='add_success'){
					imagePopup('open', '.layer01');	
				}else if(data.trim()=='already_existed'){
					alert("이미 카트에 등록된 상품입니다.");	
				}
				
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
			}
		}); //end ajax	
	}

	function imagePopup(type) {
		if (type == 'open') {
			// 팝업창을 연다.
			jQuery('#layer').attr('style', 'visibility:visible');

			// 페이지를 가리기위한 레이어 영역의 높이를 페이지 전체의 높이와 같게 한다.
			jQuery('#layer').height(jQuery(document).height());
		}

		else if (type == 'close') {

			// 팝업창을 닫는다.
			jQuery('#layer').attr('style', 'visibility:hidden');
		}
	}
	
function fn_order_each_goods(goods_id,goods_title,goods_sales_price,fileName){
	var _isLogOn=document.getElementById("isLogOn");
	var isLogOn=_isLogOn.value;
	
	 if(isLogOn=="false" || isLogOn=='' ){
		alert("로그인 후 주문이 가능합니다!!!");
	} 
	
	
		var total_price,final_total_price;
		var order_goods_qty=document.getElementById("order_goods_qty");
		
		var formObj=document.createElement("form");
		var i_goods_id = document.createElement("input"); 
    var i_goods_title = document.createElement("input");
    var i_goods_sales_price=document.createElement("input");
    var i_fileName=document.createElement("input");
    var i_order_goods_qty=document.createElement("input");

    
    i_goods_id.name="goods_id";
    i_goods_title.name="goods_title";
    i_goods_sales_price.name="goods_sales_price";
    i_fileName.name="goods_fileName";
    i_order_goods_qty.name="order_goods_qty";
    
    
    i_goods_id.value=goods_id;
    i_order_goods_qty.value=order_goods_qty.value;
    i_goods_title.value=goods_title;
    i_goods_sales_price.value=goods_sales_price;
    i_fileName.value=fileName;
    
    formObj.appendChild(i_goods_id);
    formObj.appendChild(i_goods_title);
    formObj.appendChild(i_goods_sales_price);
    formObj.appendChild(i_fileName);
    formObj.appendChild(i_order_goods_qty);

    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${contextPath}/order/orderEachGoods.do";
    formObj.submit();
	}	
	
function openImagePopup(imageUrl) {
    // 팝업 창 옵션 설정
    var options = "width=500,height=500";
    
    // 팝업 창 열기
    var popupWindow = window.open(imageUrl, "popup", options);
    
    // 팝업 창 포커스
    popupWindow.focus();
}

document.addEventListener('DOMContentLoaded', function() {
	  var commentElements = document.getElementsByClassName("comment");
	  for (var i = 0; i < commentElements.length; i++) {
	    var commentElement = commentElements[i];
	    if (commentElement.innerText.trim() === "") {
	      var trElement = commentElement.closest(".review_comment");
	      trElement.style.display = "none";
	    }
	  }
	});
</script>
</head>
<body>
<div id="container">
	<div id="content">
		<div class="goodsDetail-wrap">
			<div class="goodsDetail-title">
				<h1>맛있는 사료</h1>
			</div>
			<div class="goodsDetail-subTitle">
				<div>
					<p>사료 &gt; 강아지 &gt; 습식</p>
					<p>${goods.goods_title }</p>
					<p>${goods.goods_writer} &nbsp; ${goods.goods_publisher}</p>
				</div>
				<div id="goods_visual">
				<figure>
					<img alt="HTML5 &amp; CSS3" src="${contextPath}/thumbnails.do?goods_id=${goods.goods_id}&fileName=${goods.goods_fileName}">
				</figure>
			</div>
			</div>
			
			<div id="detail_table">
				<table class="list_view">
					<tbody>
						<tr>
							<td class="fixed">정가</td>
							<td class="active"><span >
							   <fmt:formatNumber  value="${goods.goods_price}" type="number" var="goods_price" />
						         ${goods_price}원
							</span></td>
						</tr>
						<tr class="dot_line">
							<td class="fixed">판매가</td>
							<td class="active">
								<span><fmt:formatNumber  value="${goods.goods_price*0.9}" type="number" var="discounted_price" />${discounted_price}원(10%할인)</span>
							</td>
						</tr>
						<tr>
							<td class="fixed">포인트적립</td>
							<td class="active">${goods.goods_point}P(10%적립)</td>
						</tr>
						<tr class="dot_line">
							<td class="fixed">포인트 추가적립</td>
							<td class="fixed">만원이상 구매시 1,000P, 5만원이상 구매시 2,000P추가적립 편의점 배송 이용시 300P 추가적립</td>
						</tr>
						<tr>
							<td class="fixed">배송료</td>
							<td class="fixed"><strong>무료</strong></td>
						</tr>
						<tr>
							<td class="fixed">배송안내</td>
							<td class="fixed"><strong>[당일배송]</strong> 당일배송 서비스 시작!<br> <strong>[휴일배송]</strong>
								휴일에도 배송받는 Bookshop</TD>
						</tr>
						<tr>
							<td class="fixed">도착예정일</td>
							<td class="fixed">지금 주문 시 내일 도착 예정</td>
						</tr>
						<tr>
							<td class="fixed">수량</td>
							<td class="fixed">
						      	<select style="width: 60px;" id="order_goods_qty">
								    <option>1</option>
									<option>2</option>
									<option>3</option>
									<option>4</option>
									<option>5</option>
						     	</select>
							 </td>
						</tr>
					</tbody>
				</table>
				<ul class="goodsDetail-btn">
					<li><a class="buy" href="javascript:fn_order_each_goods('${goods.goods_id }','${goods.goods_title }','${goods.goods_sales_price}','${goods.goods_fileName}');">구매하기 </a></li>
					<li><a class="cart" href="javascript:add_cart('${goods.goods_id }')">장바구니</a></li>				
					<li><a class="wish" href="#">위시리스트</a></li>
				</ul>
			</div>
			<div class="clear"></div>
			
			<!-- 내용 들어 가는 곳 -->
			<div id="container">
				<ul class="tabs">
					<li><a href="#tab1">상품소개</a></li>
					<li><a href="#tab2">리뷰(<c:out value="${reviewCount}" />)</a></li>
					<li><a href="#tab3">상품문의</a></li>
				</ul>
				<div class="tab_container">
					<div class="tab_content" id="tab1">
						<p>${fn:replace(goods.goods_intro,crcn,br)}</p>
						<c:forEach var="image" items="${imageList }">
							<img 
								src="${contextPath}/download.do?goods_id=${goods.goods_id}&fileName=${image.fileName}" data-goods-id="${goods.goods_id}">
						</c:forEach>
					</div>
					<div class="tab_content" id="tab2">
						<h4>리뷰</h4>
						<div>
							<h1>리뷰 평점 <c:out value='${averageReviewStar}'/>점</h1>
						</div>
						<div class="star-ratings">                    
		                <div class="star-ratings-fill space-x-2 text-lg" style="width:<c:out value='${averageReviewStar*20}' />%;">
		                    <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
		                </div>
		                <div class="star-ratings-base space-x-2 text-lg">
		                    <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
		                </div>
		            </div>
						
					<table id="review">
			        <c:forEach var="list" items="${goodsReviewList}">
			            <tr>
			                <td id="first-td">            
			                    <div class="star-ratings">                    
			                        <div class="star-ratings-fill space-x-2 text-lg" style="width: ${list.review_star * 20}%;">
			                            <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
			                        </div>
			                        <div class="star-ratings-base space-x-2 text-lg">
			                            <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
			                        </div>
			                    </div>
			                </td>
			                <td><img src="${contextPath}/reviewthumbnails.do?review_id=${list.review_id}&fileName=${list.fileName}" style="width: 90%; cursor: pointer;" onclick="openImagePopup('${contextPath}/reviewOriginalthumbnails.do?review_id=${list.review_id}&fileName=${list.fileName}')"></td>
			                <td>
			                    ${list.review_content}
			                </td>
			                <td>
			                	  ${list.member_name}
			                </td>
			                <td><fmt:formatDate value="${list.review_date}" pattern = "yyyy-MM-dd"/></td>
			            </tr>
		            	<tr class="review_comment">
							  <td>
							    └ 리뷰 답글:
							  </td>
							  <td colspan="4">
							    <p class="comment">${list.review_comment}</p>
							  </td>
							</tr>
					</c:forEach>
			        </table>
					</div>
					<div class="tab_content" id="tab3">
						<form action="/customer/qnaWrite.do" method="post">
						<input type="hidden" name="goods_id" value="${goods.goods_id}">
							<button type="submit">상품문의 작성하기</button>
						</form>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div id="layer" style="visibility: hidden">
				<!-- visibility:hidden 으로 설정하여 해당 div안의 모든것들을 가려둔다. -->
				<div id="popup">
					<!-- 팝업창 닫기 버튼 -->
					<a href="javascript:" onClick="javascript:imagePopup('close', '.layer01');">
						<img src="${contextPath}/resources/image/close.png" id="close" />
					</a> 
					<br />
					<p class="alert">장바구니에 담았습니다.</p>
					<br>
					<form action='${contextPath}/cart/myCartList.do'  >				
						<input  type="submit" value="장바구니 보기">
					</form>	
				</div>
			</div>
		</div>
	</div>
</div>		
</body>
</html>
<input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>
