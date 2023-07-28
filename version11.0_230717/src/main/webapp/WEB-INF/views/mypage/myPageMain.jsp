<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	 
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<c:if test="${message=='cancel_order'}">
	<script>
	window.onload=function()
	{
	  init();
	}
	
	function init(){
		alert("주문을 취소했습니다.");
	}
	</script>
</c:if>
<script>
function fn_cancel_order(order_id){
	var answer=confirm("주문을 취소하시겠습니까?");
	if(answer==true){
		var formObj=document.createElement("form");
		var i_order_id = document.createElement("input"); 
	    
	    i_order_id.name="order_id";
	    i_order_id.value=order_id;
		
	    formObj.appendChild(i_order_id);
	    document.body.appendChild(formObj); 
	    formObj.method="post";
	    formObj.action="${contextPath}/mypage/cancelMyOrder.do";
	    formObj.submit();	
	}
}

</script>
</head>
<body>
<div id="container">
	<div id="content">
		<div class="mypage-wrap">
			<div class="mypage-title">
				<h1>최근주문내역</h1>
			</div>
			<table class="list_view">
				<tbody align=center >
					<tr style="background:#33ff00" >
						<td>주문번호</td>
						<td>주문일자</td>
						<td>주문상품</td>
						<td>주문상태</td>
						<td>주문취소</td>
						<td>리뷰</td>
					</tr>
			   		<c:choose>
				    <c:when test="${ empty myOrderList  }">
						<tr>
						  <td colspan=5 class="fixed">
						  <strong>주문한 상품이 없습니다.</strong>
						  </td>
						</tr>
				    </c:when>
					<c:otherwise>
						<c:forEach var="item" items="${myOrderList }"  varStatus="i">
 							<c:choose> 
								<c:when test="${ pre_order_id != item.order_id}">
				           			<c:choose>
				          				<c:when test="${item.delivery_state=='delivery_prepared' }">
	            							<tr  bgcolor="lightgreen">    
				          				</c:when>
						          		<c:when test="${item.delivery_state=='finished_delivering' }">
											<tr bgcolor="lightgray">    
						          		</c:when>
		          						<c:otherwise>
								            <tr  bgcolor="orange">   
							          	</c:otherwise>
				        			</c:choose> 
									<tr>
							        	<td>
									    	<a href="${contextPath}/mypage/myOrderDetail.do?order_id=${item.order_id }"><span>${item.order_id }</span>  </a>
									  	</td>
									 	<td><span>${item.pay_order_time }</span></td>
										<td align="left">
								   			<strong>
										      	<c:forEach var="item2" items="${myOrderList}" varStatus="j">
											        <c:if  test="${item.order_id ==item2.order_id}" >
											          <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item2.goods_id }">${item2.goods_title }/${item.order_goods_qty }개</a><br>
										       		</c:if>   
												</c:forEach>
											</strong>
										</td>
										<td>
									  		<c:choose>
												<c:when test="${item.delivery_state=='delivery_prepared' }">
												  배송준비중
												</c:when>
												<c:when test="${item.delivery_state=='delivering' }">
												  배송중
												</c:when>
												<c:when test="${item.delivery_state=='finished_delivering' }">
												  배송완료
												</c:when>
												<c:when test="${item.delivery_state=='cancel_order' }">
												  주문취소
												</c:when>
												<c:when test="${item.delivery_state=='returning_goods' }">
												  반품완료
												</c:when>
											</c:choose>
										</td>
										<td>
										  	<c:choose>
											 	<c:when test="${item.delivery_state=='delivery_prepared'}">
												     <input  type="button" onClick="fn_cancel_order('${item.order_id}')" value="주문취소"  />
											 	</c:when>
											 	<c:otherwise>
												    <input  type="button" onClick="fn_cancel_order('${item.order_id}')" value="주문취소" disabled />
											 	</c:otherwise>
											</c:choose>
										</td>
										<td>
											<c:set var="reviewExists" value="false" />
											<c:forEach var="review" items="${reviewList}">
												<c:if test="${review.order_id == item.order_id}">
												  <c:set var="reviewExists" value="true" />
												</c:if>
											</c:forEach>
											<c:choose>
												<c:when test="${reviewExists}">
												  <span>리뷰쓰기 완료</span>
												</c:when>
												<c:otherwise>
												  	<a href="${contextPath}/customer/reviewWrite.do?goods_id=${item.goods_id}&order_id=${item.order_id}">리뷰쓰기</a>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
		       						<c:set  var="pre_order_id" value="${item.order_id}" />
				      				</c:when>
				 				</c:choose>
							</c:forEach>
						</c:otherwise>
					</c:choose> 	    
				</tbody>
			</table>
		</div>
	</div>
</div>
	

</body>
</html>
