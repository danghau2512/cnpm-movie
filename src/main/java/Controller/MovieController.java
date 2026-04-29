package Controller;

import Model.Movie;
import Service.MovieService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/movies"})
public class MovieController extends HttpServlet {
    private final MovieService movieService = new MovieService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");

        List<Movie> movies = movieService.getMovies(keyword);

        request.setAttribute("movies", movies);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/movies.jsp")
                .forward(request, response);
    }
}