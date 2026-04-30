package Controller;

import Model.PaymentInfo;
import Model.User;
import Service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/payment", "/payment-result"})
public class PaymentController extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
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

        paymentService.processPayment(bookingId, method);

        response.sendRedirect(request.getContextPath() + "/payment-result?bookingId=" + bookingId);
    }
}