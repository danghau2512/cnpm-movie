<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook - Đặt vé</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-page="booking">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/header.jsp" />
    <main class="page-shell">
        <section class="page-title">
            <p class="eyebrow">UC06 - Đặt vé</p>
            <h1>Chọn phim, suất chiếu và ghế</h1>
        </section>

        <section class="booking-layout">
            <div class="booking-panel">
                <label>Phim
                    <select id="bookingMovie"></select>
                </label>
                <label>Suất chiếu
                    <select id="bookingShowtime"></select>
                </label>
                <div class="legend">
                    <span><i class="seat available"></i> Còn trống</span>
                    <span><i class="seat selected"></i> Đang chọn</span>
                    <span><i class="seat booked"></i> Đã đặt</span>
                </div>
                <div class="screen">Màn hình</div>
                <div id="seatMap" class="seat-map" aria-label="Sơ đồ ghế"></div>
            </div>

            <aside class="summary-panel">
                <h2>Tóm tắt đặt vé</h2>
                <p><strong>Phim:</strong> <span id="summaryMovie">-</span></p>
                <p><strong>Suất chiếu:</strong> <span id="summaryShowtime">-</span></p>
                <p><strong>Ghế đã chọn:</strong> <span id="summarySeats">Chưa chọn</span></p>
                <p><strong>Tổng tiền:</strong> <span id="summaryTotal">0 VND</span></p>
                <button id="confirmBooking" class="btn btn-primary btn-full">Xác nhận đặt vé</button>
            </aside>
        </section>
        <jsp:include page="/footer.jsp" />

    </main>

    <script src="js/main.js"></script>
</body>
</html>
