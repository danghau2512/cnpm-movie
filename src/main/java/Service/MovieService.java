package Service;

import Dao.MovieDAO;
import Model.Movie;

import java.util.List;

public class MovieService {
    private final MovieDAO movieDAO = new MovieDAO();

    public List<Movie> getMovies(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return movieDAO.findAllNowShowing();
        }

        return movieDAO.searchMovies(keyword.trim());
    }
}