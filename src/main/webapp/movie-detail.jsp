<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>CineBook - Chi tiết phim</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body data-page="movie-detail">

<jsp:include page="/header.jsp" />

<main class="page-shell">
    <section class="page-title">
        <p class="eyebrow">UC04 - Xem chi tiết phim</p>
        <h1>${movie.title}</h1>
        <p class="muted">
            Xem thông tin chi tiết của phim trước khi chọn lịch chiếu và đặt vé.
        </p>
    </section>

    <section class="detail-layout">
        <div class="detail-poster movie-detail-poster">
            <c:choose>
                <c:when test="${not empty movie.posterUrl}">
                    <img src="${movie.posterUrl}" alt="${movie.title}">
                </c:when>

                <c:otherwise>
                    <div class="poster-placeholder">
                        <span>${movie.ageRating}</span>
                        <h2>${movie.title}</h2>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="detail-content">
            <h2>${movie.title}</h2>

            <div class="meta detail-meta">
                <span>${movie.durationMinutes} phút</span>
                <span>${movie.ageRating}</span>
                <span>${movie.genreNames}</span>
                <c:if test="${not empty movie.releaseDate}">
                    <span>Khởi chiếu: ${movie.releaseDate}</span>
                </c:if>
            </div>

            <h3>Mô tả ngắn</h3>
            <p class="muted">
                ${movie.shortDescription}
            </p>

            <h3>Nội dung phim</h3>
            <p class="muted movie-description">
                ${movie.description}
            </p>

            <div class="detail-actions">
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/showtimes?movieId=${movie.id}">
                    Xem lịch chiếu
                </a>

                <a class="btn btn-ghost"
                   href="${pageContext.request.contextPath}/movies">
                    Quay lại danh sách
                </a>

                <c:if test="${not empty movie.trailerUrl}">
                    <a class="btn btn-secondary"
                       href="${movie.trailerUrl}"
                       target="_blank">
                        Xem trailer
                    </a>
                </c:if>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/footer.jsp" />

</body>
</html>