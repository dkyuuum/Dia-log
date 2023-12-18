<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="model.dto.contents.Contents"%>
<%@ page import="model.dto.review.Review"%>
<%@ page import="java.util.*"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<!DOCTYPE html>
<html>
<head>
<%
List<Contents> contentList = (List<Contents>) request.getAttribute("contentList");
List<Map<String, Object>> reviewList = (List<Map<String, Object>>) request.getAttribute("reviewList");

/* System.out.println("reviewList: " + reviewList); */
%>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ContentsList</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<link rel="stylesheet"
	href="<c:url value='/css/contents/contentsList.css' />" type="text/css">
<%
/* if (contentList != null) { */
ObjectMapper mapper = new ObjectMapper();
String jsonContentList = mapper.writeValueAsString(contentList);
String jsonReviewList = mapper.writeValueAsString(reviewList);
%>
<script>
		var contentList = JSON.parse('<%=jsonContentList%>');
		var reviewList = JSON.parse('<%=jsonReviewList%>')
//		console.log({"JSON_contentList": contentList});
		console.log('Review List:', reviewList);

		var cId = 0;
		
        function updateModalContent(contentId) {
            cId = contentId;
            console.log(cId);

            var content = contentList.find(
            		function (c) {
                		return c.contentId == contentId;
            		}
            	);

            localStorage.setItem("contentId", contentId);

            if (content) {
                // 모달의 제목, 이미지 등을 업데이트 
                document.getElementById('exampleModalLabel').innerText = content.title;
                document.getElementById('content-genre').innerText = content.genre;
                document.getElementById('content-image').src = content.contentImg;
            }
            
            /* $.ajax({
                type: 'GET',
                url: '/contents/reviewList',
                data: { contentId: contentId },
                dataType: 'json',
                success: function (reviews) {
                	console.log(reviews);
                
                	$(reviews).each(function(){
						console.log(this.detail);       	
        			});
                },
                error: function () {
                    console.error('Failed to fetch reviews.');
                }
            });  */
            console.log(cId);
        
            fetchReviews(cId);
        }
        
        function fetchReviews(contentId) {
            fetch("<c:url value='/contents/reviewList'/>?contentId=" + encodeURIComponent(contentId), {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json;charset=UTF-8'
                },
            })
            .then(response => {
                console.log('Raw Response:', response);
                return response.json();
            })
            .then(data => {
                console.log('Parsed JSON:', data);
                
                const review = data.map(review => '- '+review.detail+'\n\n').join('');
                
                document.getElementById('content-review').innerText = review
            })
            .catch(error => {
                console.error('Error fetching reviews:', error.message);
                console.error(error.stack);
            });
        }
  

</script>
</head>
<body>
	<%
	if (contentList != null && !contentList.isEmpty()) {
		Iterator<Contents> iterator = contentList.iterator();

		int index = 1;
	%>
	<div class="gallery">
		<div class="container text-center">
			<%
			while (iterator.hasNext()) {
				Contents content = iterator.next();
				/* 
				String title = content.getTitle();
				String img = content.getContentImg();
				String genre = content.getGenre();
				 */
				if (index % 5 == 1) {
			%>
			<div class="row">
				<%
				}
				%>
				<div onclick="updateModalContent(<%=content.getContentId()%>)"
					class="col">
					<article class="card" data-bs-toggle="modal"
						data-bs-target="#exampleModal">
						<figure>
							<img src="<%=content.getContentImg()%>"
								alt="<%=content.getGenre()%>">
							<figcaption>
								<p class="h6"><%=content.getTitle()%></p>
							</figcaption>
						</figure>
					</article>
				</div>

				<div class="modal fade" id="exampleModal" tabindex="-1"
					aria-labelledby="exampleModalLabel" aria-hidden="true">
					<input type="hidden" id="contentId"
						value="<%=content.getContentId()%>">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h1 class="modal-title fs-5" id="exampleModalLabel"></h1>
							</div>
							<div class="modal-body">
								<form>
									<div class="mb-3">
										<label for="recipient-name" class="col-form-label"></label> <img
											style="width: 220px; height: 260px" id="content-image"
											src="<%=content.getContentImg()%>">
									</div>
									<div class="mb-3">
										<label for="recipient-name" class="col-form-label">[genre]</label>
										<p id="content-genre" />
									</div>
									<div class="mb-3">
										<label for="message-text" class="col-form-label">[review]</label>
										<p id="content-review" />
									</div>
								</form>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-danger"
									onclick="alert('담기 완료')">diary 담기</button>
							</div>
						</div>
					</div>
				</div>
				<%
				index++;
				}
				%>
				<%
				if (index % 5 == 1) {
				%>
			</div>
			<%
			}
			%>
		</div>
	</div>
	<%
	}
	%>

</body>
</html>

