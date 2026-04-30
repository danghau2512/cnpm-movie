package Controller;

import Model.PaymentInfo;
import Model.User;
import Service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/payment", "/payment-result", "/vnpay-return"})
public class PaymentController extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/vnpay-return".equals(path)) {
            handleVnpayReturn(request, response);
            return;
        }

        User currentUser = (User) request.getSession().getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        PaymentInfo paymentInfo = paymentService.getPaymentInfo(bookingId);

        if (paymentInfo == null || paymentInfo.getUserId() != currentUser.getId()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("paymentInfo", paymentInfo);

        if ("/payment".equals(path)) {
            request.getRequestDispatcher("/payment.jsp")
                    .forward(request, response);
        } else {
            request.getRequestDispatcher("/payment-result.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User currentUser = (User) request.getSession().getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String method = request.getParameter("paymentMethod");

        PaymentInfo paymentInfo = paymentService.getPaymentInfo(bookingId);

        if (paymentInfo == null || paymentInfo.getUserId() != currentUser.getId()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if ("PAY_AT_COUNTER".equals(method)) {
            paymentService.processPayAtCounter(bookingId);
            response.sendRedirect(request.getContextPath() + "/payment-result?bookingId=" + bookingId);
            return;
        }

        if ("VNPAY".equals(method)) {
            String paymentUrl = paymentService.createVnpayPaymentUrl(bookingId, request);
            response.sendRedirect(paymentUrl);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId);
    }

    private void handleVnpayReturn(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Map<String, String> params = new HashMap<>();

        request.getParameterMap().forEach((key, values) -> {
            if (values != null && values.length > 0) {
                params.put(key, values[0]);
            }
        });

        try {
            int bookingId = paymentService.handleVnpayReturn(params);
            response.sendRedirect(request.getContextPath() + "/payment-result?bookingId=" + bookingId);
        } catch (RuntimeException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}