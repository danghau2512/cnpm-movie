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

    .page-title {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        column-gap: 18px;
        row-gap: 10px;
    }

    .page-title h1,
    .page-title p {
        grid-column: 1 / -1;
    }

    .page-title label {
        min-width: 0;
    }

    @media (max-width: 700px) {
        .page-title {
            grid-template-columns: 1fr;
        }
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

    <div class="movie-grid" id="movieList">
        <c:choose>
            <c:when test="${empty movies}">
                <p class="empty-message">
                    Không tìm thấy phim phù hợp. Hãy thử tên phim khác.
                </p>
            </c:when>

            <c:otherwise>
                <c:forEach var="movie" items="${movies}">
                    <div class="movie-card" data-movie-card data-genre="${movie.genreNames}" data-rating="${movie.ageRating}">
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

        <p class="empty-message hidden" id="noFilteredMovies">
            KhÃ´ng cÃ³ phim phÃ¹ há»£p vá»›i bá»™ lá»c Ä‘ang chá»n.
        </p>
    </div>
</main>

<jsp:include page="/footer.jsp" />

<script>
    document.addEventListener("DOMContentLoaded", function () {
        var genreFilter = document.getElementById("genreFilter");
        var ratingFilter = document.getElementById("ratingFilter");
        var movieCount = document.querySelector(".movie-count");
        var noFilteredMovies = document.getElementById("noFilteredMovies");
        var movieCards = Array.prototype.slice.call(document.querySelectorAll("[data-movie-card]"));

        if (!genreFilter || !ratingFilter || !movieCount) {
            return;
        }

        function getGenres(card) {
            return (card.dataset.genre || "")
                .split(",")
                .map(function (genre) {
                    return genre.trim();
                })
                .filter(Boolean);
        }

        function addOptions(select, values) {
            values
                .filter(function (value, index, array) {
                    return value && array.indexOf(value) === index;
                })
                .sort(function (first, second) {
                    return first.localeCompare(second, "vi");
                })
                .forEach(function (value) {
                    var option = document.createElement("option");
                    option.value = value;
                    option.textContent = value;
                    select.appendChild(option);
                });
        }

        addOptions(genreFilter, movieCards.flatMap(getGenres));
        addOptions(ratingFilter, movieCards.map(function (card) {
            return card.dataset.rating || "";
        }));

        function filterMovies() {
            var selectedGenre = genreFilter.value;
            var selectedRating = ratingFilter.value;
            var visibleCount = 0;

            movieCards.forEach(function (card) {
                var matchesGenre = !selectedGenre || getGenres(card).indexOf(selectedGenre) !== -1;
                var matchesRating = !selectedRating || card.dataset.rating === selectedRating;
                var isVisible = matchesGenre && matchesRating;

                card.classList.toggle("hidden", !isVisible);
                if (isVisible) {
                    visibleCount += 1;
                }
            });

            movieCount.textContent = "CÃ³ " + visibleCount + " phim Ä‘Æ°á»£c hiá»ƒn thá»‹.";
            if (noFilteredMovies) {
                noFilteredMovies.classList.toggle("hidden", visibleCount > 0);
            }
        }

        genreFilter.addEventListener("change", filterMovies);
        ratingFilter.addEventListener("change", filterMovies);
    });
</script>

</body>
</html>
