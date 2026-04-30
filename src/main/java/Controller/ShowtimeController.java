package Controller;

import Model.Showtime;
import Service.ShowtimeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/showtimes"})
public class ShowtimeController extends HttpServlet {
    private final ShowtimeService showtimeService = new ShowtimeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String movieId = request.getParameter("movieId");

        List<Showtime> showtimes = showtimeService.getShowtimes(movieId);

        request.setAttribute("showtimes", showtimes);
        request.setAttribute("movieId", movieId);

        request.getRequestDispatcher("/showtimes.jsp")
                .forward(request, response);
    }
}