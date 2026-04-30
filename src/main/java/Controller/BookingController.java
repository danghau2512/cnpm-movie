package Controller;

import Model.Seat;
import Model.Showtime;
import Model.User;
import Service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showBookingPage(request, response, null);
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

        int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
        String[] seatIdValues = request.getParameterValues("seatIds");

        List<Integer> seatIds = new ArrayList<>();

        if (seatIdValues != null) {
            for (String value : seatIdValues) {
                seatIds.add(Integer.parseInt(value));
            }
        }

        try {
            int bookingId = bookingService.createBooking(currentUser.getId(), showtimeId, seatIds);

            response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId);

        } catch (RuntimeException e) {
            showBookingPage(request, response, e.getMessage());
        }
    }

    private void showBookingPage(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String showtimeIdRaw = request.getParameter("showtimeId");

        if (showtimeIdRaw == null || showtimeIdRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/showtimes");
            return;
        }

        int showtimeId = Integer.parseInt(showtimeIdRaw);

        Showtime showtime = bookingService.getShowtimeDetail(showtimeId);
        List<Seat> seats = bookingService.getSeatsByShowtime(showtimeId);

        if (showtime == null) {
            response.sendRedirect(request.getContextPath() + "/showtimes");
            return;
        }

        request.setAttribute("showtime", showtime);
        request.setAttribute("seats", seats);
        request.setAttribute("error", error);

        request.getRequestDispatcher("/booking.jsp")
                .forward(request, response);
    }
}