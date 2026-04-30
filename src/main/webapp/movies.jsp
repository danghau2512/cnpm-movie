<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook - Danh sách phim</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="css/movie.css">
</head>

<body data-page="movies">

<jsp:include page="/header.jsp" />

<main class="page-shell">
    <section class="page-title">
        <h1>Danh sách phim</h1>
        <p class="muted">
            Người dùng có thể xem danh sách phim đang chiếu và tìm kiếm phim theo tên.
        </p>
        <label>Thể loại
            <select id="genreFilter">
                <option value="">Tất cả thể loại</option>
            </select>
        </label>
        <label>Độ tuổi
            <select id="ratingFilter">
                <option value="">Tất cả độ tuổi</option>
            </select>
        </label>
    </section>



    <p class="muted movie-count">
        Có ${movies.size()} phim được hiển thị.
    </p>

    <div class="movie-grid">
        <c:choose>
            <c:when test="${empty movies}">
                <p class="empty-message">
                    Không tìm thấy phim phù hợp. Hãy thử tên phim khác.
                </p>
            </c:when>

            <c:otherwise>
                <c:forEach var="movie" items="${movies}">
                    <div class="movie-card">
                        <div class="movie-poster"
                             style="--poster-bg: linear-gradient(135deg, #1b0b0b, #8a2e16, #d67a28);">
                            <span class="age-tag">${movie.ageRating}</span>

                            <h3>${movie.title}</h3>
                        </div>

                        <div class="movie-info">
                            <h3>${movie.title}</h3>

                            <p>
                                Thời lượng: ${movie.durationMinutes} phút
                            </p>

                            <p>
                                Độ tuổi: ${movie.ageRating}
                            </p>
                            <p>Thể loại : ${movie.genreNames}</p>

                            <p>
                                    ${movie.shortDescription}
                            </p>

                            <div class="movie-actions">
                                <a class="btn btn-ghost"
                                   href="${pageContext.request.contextPath}/movie-detail?id=${movie.id}">
                                    Chi tiết
                                </a>

                                <a class="btn btn-primary"
                                   href="${pageContext.request.contextPath}/showtimes?movieId=${movie.id}">
                                    Đặt vé
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/footer.jsp" />

</body>
</html>