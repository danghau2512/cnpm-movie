package Service;

import Dao.ShowtimeDAO;
import Model.Showtime;

import java.util.List;

public class ShowtimeService {
    private final ShowtimeDAO showtimeDAO = new ShowtimeDAO();

    public List<Showtime> getShowtimes(String movieIdRaw) {
        if (movieIdRaw == null || movieIdRaw.trim().isEmpty()) {
            return showtimeDAO.findAllOpen();
        }

        int movieId = Integer.parseInt(movieIdRaw);
        return showtimeDAO.findByMovieId(movieId);
    }
}