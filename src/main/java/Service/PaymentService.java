package Service;

import Dao.PaymentDAO;
import Model.PaymentInfo;

public class PaymentService {
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public PaymentInfo getPaymentInfo(int bookingId) {
        return paymentDAO.findPaymentInfo(bookingId);
    }

    public void processPayment(int bookingId, String method) {
        if ("PAY_AT_COUNTER".equals(method)) {
            paymentDAO.payAtCounter(bookingId);
            return;
        }

        if ("VNPAY".equals(method)) {
            paymentDAO.payByVnpayDemo(bookingId);
            return;
        }

        throw new RuntimeException("Phương thức thanh toán không hợp lệ.");
    }
}