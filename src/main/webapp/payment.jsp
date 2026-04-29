
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook - Thanh toán</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-page="payment">
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

    <main class="page-shell narrow">
        <section class="page-title">
            <p class="eyebrow">UC07 - Thanh toán</p>
            <h1>Thanh toán</h1>
        </section>

        <section class="payment-card">
            <h2>Tóm tắt đặt vé</h2>
            <div id="paymentSummary" class="summary-lines"></div>
            <h2>Phương thức thanh toán</h2>
            <form id="paymentForm">
                <label class="radio-option">
                    <input type="radio" name="paymentMethod" value="Thanh toán tại quầy" checked>
                    Thanh toán tại quầy
                </label>
                <label class="radio-option">
                    <input type="radio" name="paymentMethod" value="Chuyển khoản ngân hàng">
                    Chuyển khoản ngân hàng
                </label>
                <label class="radio-option">
                    <input type="radio" name="paymentMethod" value="Ví điện tử">
                    Ví điện tử
                </label>
                <p id="paymentMessage" class="form-message"></p>
                <button class="btn btn-primary btn-full" type="submit">Xác nhận thanh toán</button>
            </form>
        </section>
    </main>

    <script src="js/main.js"></script>
</body>
</html>
