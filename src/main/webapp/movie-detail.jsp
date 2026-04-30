<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>CineBook - Chi tiết phim</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<style>
    .trailer-modal {
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.82);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 9999;
        padding: 24px;
    }

    .trailer-modal.show {
        display: flex;
    }

    .trailer-box {
        position: relative;
        width: min(900px, 95vw);
        aspect-ratio: 16 / 9;
        background: #000;
        border-radius: 14px;
        border: 1px solid rgba(240, 184, 74, 0.45);
        box-shadow: 0 25px 80px rgba(0, 0, 0, 0.65);
    }

    .trailer-box iframe {
        width: 100%;
        height: 100%;
        border: none;
        border-radius: 14px;
    }

    .trailer-close {
        position: absolute;
        top: -44px;
        right: 0;
        width: 38px;
        height: 38px;
        border: none;
        border-radius: 50%;
        background: #d92525;
        color: #fff;
        font-size: 26px;
        font-weight: 700;
        cursor: pointer;
    }
</style>
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

                <c:if test="${not empty movie.trailerUrl}">
                    <button type="button"
                            class="btn btn-ghost"
                            onclick="openTrailer('${movie.trailerUrl}')">
                        Trailer
                    </button>
                </c:if>

                <a class="btn btn-ghost"
                   href="${pageContext.request.contextPath}/movies">
                    Quay lại danh sách
                </a>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/footer.jsp" />

<div id="trailerModal" class="trailer-modal">
    <div class="trailer-box">
        <button type="button" class="trailer-close" onclick="closeTrailer()">×</button>

        <iframe id="trailerFrame"
                src=""
                title="Movie trailer"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
        </iframe>
    </div>
</div>

<script>
    function openTrailer(url) {
        const modal = document.getElementById("trailerModal");
        const frame = document.getElementById("trailerFrame");

        frame.src = url + "?autoplay=1";
        modal.style.display = "flex";
    }

    function closeTrailer() {
        const modal = document.getElementById("trailerModal");
        const frame = document.getElementById("trailerFrame");

        frame.src = "";
        modal.style.display = "none";
    }

    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById("trailerModal");

        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                closeTrailer();
            }
        });
    });
</script>
</body>
</html>