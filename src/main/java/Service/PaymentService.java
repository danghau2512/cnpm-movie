package Service;

import Dao.PaymentDAO;
import Model.PaymentInfo;
import Util.VnpayConfig;
import Util.VnpayUtil;
import jakarta.servlet.http.HttpServletRequest;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

public class PaymentService {
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public PaymentInfo getPaymentInfo(int bookingId) {
        return paymentDAO.findPaymentInfo(bookingId);
    }

    public void processPayAtCounter(int bookingId) {
        paymentDAO.payAtCounter(bookingId);
    }

    public String createVnpayPaymentUrl(int bookingId, HttpServletRequest request) {
        PaymentInfo info = paymentDAO.findPaymentInfo(bookingId);

        if (info == null) {
            throw new RuntimeException("KhÃ´ng tÃ¬m tháº¥y thÃ´ng tin Ä‘áº·t vÃ©.");
        }

        paymentDAO.createVnpayPendingPayment(bookingId);

        String returnUrl = request.getScheme() + "://"
                + request.getServerName()
                + ":"
                + request.getServerPort()
                + request.getContextPath()
                + "/vnpay-return";

        BigDecimal totalAmount = info.getTotalAmount();

        long amount = totalAmount.longValue() * 100;
        String vnpTxnRef = bookingId + "_" + System.currentTimeMillis();
        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version", VnpayConfig.VNP_VERSION);
        params.put("vnp_Command", VnpayConfig.VNP_COMMAND);
        params.put("vnp_TmnCode", VnpayConfig.VNP_TMN_CODE);
        params.put("vnp_Amount", String.valueOf(amount));
        params.put("vnp_CurrCode", VnpayConfig.VNP_CURR_CODE);
        params.put("vnp_TxnRef", vnpTxnRef);
        params.put("vnp_OrderInfo", "Thanh toan ve xem phim " + info.getBookingCode());
        params.put("vnp_OrderType", VnpayConfig.VNP_ORDER_TYPE);
        params.put("vnp_Locale", VnpayConfig.VNP_LOCALE);
        params.put("vnp_ReturnUrl", returnUrl);
        params.put("vnp_IpAddr", VnpayUtil.getIpAddress(request));
        params.put("vnp_CreateDate", VnpayUtil.getCurrentDate());

        return VnpayUtil.buildPaymentUrl(params);
    }

    public int handleVnpayReturn(Map<String, String> params) {
        boolean validSignature = VnpayUtil.verifyReturnUrl(params);

        if (!validSignature) {
            throw new RuntimeException("Sai chá»¯ kÃ½ VNPay.");
        }

        String txnRef = params.get("vnp_TxnRef");
        int bookingId = Integer.parseInt(txnRef.split("_")[0]);
        String responseCode = params.get("vnp_ResponseCode");
        String transactionStatus = params.get("vnp_TransactionStatus");
        String transactionCode = params.get("vnp_TransactionNo");

        if ("00".equals(responseCode) && "00".equals(transactionStatus)) {
            paymentDAO.confirmVnpayPayment(bookingId, transactionCode);
        } else {
            paymentDAO.failVnpayPayment(bookingId, transactionCode);
        }

        return bookingId;
    }
}
