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
<style>
    .movie-poster {
        height: 260px;
        position: relative;
        overflow: hidden;
        border-radius: 0.45rem;
        background: linear-gradient(135deg, #2b1010, #15151d);
    }

    .movie-poster-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
        border-radius: 0.45rem;
    }

    .movie-poster::after {
        content: "";
        position: absolute;
        inset: 0;
        background: linear-gradient(180deg, transparent 45%, rgba(0, 0, 0, 0.75));
        pointer-events: none;
    }

    .age-tag {
        position: absolute;
        top: 12px;
        left: 12px;
        z-index: 2;
        background: #f5c542;
        color: #111827;
        padding: 6px 10px;
        border-radius: 8px;
        font-weight: 800;
    }

    .poster-placeholder {
        height: 100%;
        padding: 18px;
        display: flex;
        align-items: flex-end;
        background: linear-gradient(135deg, #4c0519, #b91c1c 45%, #f59e0b);
    }

    .poster-placeholder h3 {
        position: relative;
        z-index: 2;
        color: #ffffff;
        font-size: 22px;
    }
</style>
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
                        <div class="movie-poster">
                            <span class="age-tag">${movie.ageRating}</span>

                            <c:choose>
                                <c:when test="${not empty movie.posterUrl}">
                                    <img src="${movie.posterUrl}" alt="${movie.title}" class="movie-poster-img">
                                </c:when>

                                <c:otherwise>
                                    <div class="poster-placeholder">
                                        <h3>${movie.title}</h3>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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