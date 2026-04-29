<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook - Kết quả thanh toán</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-page="payment-result">
    <header class="site-header">
        <a class="logo" href="index.jsp">Cine<span>Book</span></a>
        <button class="menu-toggle" aria-label="Mở trình đơn">Trình đơn</button>
        <nav class="main-nav">
            <a href="index.jsp">Trang chủ</a>
            <a href="movies.jsp">Phim</a>
            <a href="showtimes.jsp">Lịch chiếu</a>
            <a href="booking.jsp">Đặt vé</a>
        </nav>
        <div class="header-actions">
            <a class="btn btn-ghost" href="login.jsp">Đăng nhập</a>
            <a class="btn btn-primary" href="register.jsp">Đăng ký</a>
        </div>
    </header>

    <main class="result-page">
        <section class="result-card">
            <div class="success-mark">Xong</div>
            <p class="eyebrow">Thanh toán thành công</p>
            <h1>Vé của bạn đã sẵn sàng</h1>
            <div id="ticketDetails" class="ticket-details"></div>
            <a class="btn btn-primary" href="index.jsp">Về trang chủ</a>
        </section>
    </main>

    <script src="js/main.js"></script>
</body>
</html>
