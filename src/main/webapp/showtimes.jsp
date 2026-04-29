<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook - Lịch chiếu</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-page="showtimes">
    <header class="site-header">
        <a class="logo" href="index.jsp">Cine<span>Book</span></a>
        <button class="menu-toggle" aria-label="Mở trình đơn">Trình đơn</button>
        <nav class="main-nav">
            <a href="index.jsp">Trang chủ</a>
            <a href="movies.jsp">Phim</a>
            <a href="showtimes.html" class="active">Lịch chiếu</a>
            <a href="booking.jsp">Đặt vé</a>
        </nav>
        <div class="header-actions">
            <a class="btn btn-ghost" href="login.jsp">Đăng nhập</a>
            <a class="btn btn-primary" href="register.jsp">Đăng ký</a>
        </div>
    </header>

    <main class="page-shell">
        <section class="page-title">
            <p class="eyebrow">UC05 - Xem lịch chiếu</p>
            <h1>Lịch chiếu theo ngày</h1>
        </section>
        <div id="dateTabs" class="date-tabs"></div>
        <div id="showtimeList" class="showtime-list"></div>
    </main>

    <script src="js/main.js"></script>
</body>
</html>
