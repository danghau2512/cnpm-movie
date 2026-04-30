package Dao;

import Model.PaymentInfo;
import Util.JdbiConnector;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;

import java.math.BigDecimal;

public class PaymentDAO {
    private final Jdbi jdbi = JdbiConnector.getJdbi();

    public PaymentInfo findPaymentInfo(int bookingId) {
        String sql = """
                SELECT
                    b.id AS bookingId,
                    b.user_id AS userId,
                    b.booking_code AS bookingCode,
                    m.title AS movieTitle,
                    r.name AS roomName,
                    DATE_FORMAT(st.start_time, '%d/%m/%Y') AS showDate,
                    DATE_FORMAT(st.start_time, '%H:%i') AS showTime,
                    GROUP_CONCAT(se.seat_code ORDER BY se.seat_row, se.seat_number SEPARATOR ', ') AS seats,
                    b.quantity,
                    b.total_amount AS totalAmount,
                    FORMAT(b.total_amount, 0) AS totalText,
                    b.booking_status AS bookingStatus,
                    b.payment_status AS paymentStatus
                FROM bookings b
                JOIN showtimes st ON b.showtime_id = st.id
                JOIN movies m ON st.movie_id = m.id
                JOIN rooms r ON st.room_id = r.id
                JOIN booking_seats bs ON b.id = bs.booking_id
                JOIN seats se ON bs.seat_id = se.id
                WHERE b.id = :bookingId
                GROUP BY
                    b.id, b.user_id, b.booking_code, m.title, r.name,
                    st.start_time, b.quantity, b.total_amount,
                    b.booking_status, b.payment_status
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("bookingId", bookingId)
                        .registerRowMapper(BeanMapper.factory(PaymentInfo.class))
                        .mapTo(PaymentInfo.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void payAtCounter(int bookingId) {
        jdbi.useTransaction(handle -> {
            BigDecimal amount = handle.createQuery("""
                            SELECT total_amount
                            FROM bookings
                            WHERE id = :bookingId
                            """)
                    .bind("bookingId", bookingId)
                    .mapTo(BigDecimal.class)
                    .one();

            handle.createUpdate("""
                            DELETE FROM payments
                            WHERE booking_id = :bookingId
                            """)
                    .bind("bookingId", bookingId)
                    .execute();

            handle.createUpdate("""
                            INSERT INTO payments
                            (booking_id, payment_method, amount, payment_status, paid_at, transaction_code)
                            VALUES
                            (:bookingId, 'PAY_AT_COUNTER', :amount, 'PENDING', NULL, NULL)
                            """)
                    .bind("bookingId", bookingId)
                    .bind("amount", amount)
                    .execute();

            handle.createUpdate("""
                            UPDATE bookings
                            SET booking_status = 'PENDING',
                                payment_status = 'UNPAID'
                            WHERE id = :bookingId
                            """)
                    .bind("bookingId", bookingId)
                    .execute();
        });
    }

    public void payByVnpayDemo(int bookingId) {
        jdbi.useTransaction(handle -> {
            BigDecimal amount = handle.createQuery("""
                            SELECT total_amount
                            FROM bookings
                            WHERE id = :bookingId
                            """)
                    .bind("bookingId", bookingId)
                    .mapTo(BigDecimal.class)
                    .one();

            String transactionCode = "VNPAY_DEMO_" + System.currentTimeMillis();

            handle.createUpdate("""
                            DELETE FROM payments
                            WHERE booking_id = :bookingId
                            """)
                    .bind("bookingId", bookingId)
                    .execute();

            handle.createUpdate("""
                            INSERT INTO payments
                            (booking_id, payment_method, amount, payment_status, paid_at, transaction_code)
                            VALUES
                            (:bookingId, 'VNPAY', :amount, 'SUCCESS', NOW(), :transactionCode)
                            """)
                    .bind("bookingId", bookingId)
                    .bind("amount", amount)
                    .bind("transactionCode", transactionCode)
                    .execute();

            handle.createUpdate("""
                            UPDATE bookings
                            SET booking_status = 'CONFIRMED',
                                payment_status = 'PAID'
                            WHERE id = :bookingId
                            """)
                    .bind("bookingId", bookingId)
                    .execute();
        });
    }
    public void createVnpayPendingPayment(int bookingId) {
        jdbi.useTransaction(handle -> {
            java.math.BigDecimal amount = handle.createQuery("""
                        SELECT total_amount
                        FROM bookings
                        WHERE id = :bookingId
                        """)
                    .bind("bookingId", bookingId)
                    .mapTo(java.math.BigDecimal.class)
                    .one();

            handle.createUpdate("""
                        DELETE FROM payments
                        WHERE booking_id = :bookingId
                        """)
                    .bind("bookingId", bookingId)
                    .execute();

            handle.createUpdate("""
                        INSERT INTO payments
                        (booking_id, payment_method, amount, payment_status, paid_at, transaction_code)
                        VALUES
                        (:bookingId, 'VNPAY', :amount, 'PENDING', NULL, NULL)
                        """)
                    .bind("bookingId", bookingId)
                    .bind("amount", amount)
                    .execute();

            handle.createUpdate("""
                        UPDATE bookings
                        SET booking_status = 'PENDING',
                            payment_status = 'UNPAID'
                        WHERE id = :bookingId
                        """)
                    .bind("bookingId", bookingId)
                    .execute();
        });
    }

    public void confirmVnpayPayment(int bookingId, String transactionCode) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("""
                        UPDATE payments
                        SET payment_status = 'SUCCESS',
                            paid_at = NOW(),
                            transaction_code = :transactionCode
                        WHERE booking_id = :bookingId
                        """)
                    .bind("bookingId", bookingId)
                    .bind("transactionCode", transactionCode)
                    .execute();

            handle.createUpdate("""
                        UPDATE bookings
                        SET booking_status = 'CONFIRMED',
                            payment_status = 'PAID'
                        WHERE id = :bookingId
                        """)
                    .bind("bookingId", bookingId)
                    .execute();
        });
    }

    public void failVnpayPayment(int bookingId, String transactionCode) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("""
                        UPDATE payments
                        SET payment_status = 'FAILED',
                            paid_at = NULL,
                            transaction_code = :transactionCode
                        WHERE booking_id = :bookingId
                        """)
                    .bind("bookingId", bookingId)
                    .bind("transactionCode", transactionCode)
                    .execute();

            handle.createUpdate("""
                        UPDATE bookings
                        SET booking_status = 'CANCELLED',
                            payment_status = 'FAILED'
                        WHERE id = :bookingId
                        """)
                    .bind("bookingId", bookingId)
                    .execute();
        });
    }
}