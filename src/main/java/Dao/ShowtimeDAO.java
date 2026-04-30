package Dao;

import Model.Showtime;
import Util.JdbiConnector;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;

import java.util.List;

public class ShowtimeDAO {
    private final Jdbi jdbi = JdbiConnector.getJdbi();

    public List<Showtime> findAllOpen() {
        String sql = """
                SELECT
                    s.id,
                    s.movie_id AS movieId,
                    s.room_id AS roomId,
                    m.title AS movieTitle,
                    r.name AS roomName,
                    DATE_FORMAT(s.start_time, '%d/%m/%Y') AS showDate,
                    DATE_FORMAT(s.start_time, '%H:%i') AS showTime,
                    s.price,
                    FORMAT(s.price, 0) AS priceText,
                    s.status
                FROM showtimes s
                JOIN movies m ON s.movie_id = m.id
                JOIN rooms r ON s.room_id = r.id
                WHERE s.status = 'OPEN'
                ORDER BY s.start_time ASC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .registerRowMapper(BeanMapper.factory(Showtime.class))
                        .mapTo(Showtime.class)
                        .list()
        );
    }

    public List<Showtime> findByMovieId(int movieId) {
        String sql = """
                SELECT
                    s.id,
                    s.movie_id AS movieId,
                    s.room_id AS roomId,
                    m.title AS movieTitle,
                    r.name AS roomName,
                    DATE_FORMAT(s.start_time, '%d/%m/%Y') AS showDate,
                    DATE_FORMAT(s.start_time, '%H:%i') AS showTime,
                    s.price,
                    FORMAT(s.price, 0) AS priceText,
                    s.status
                FROM showtimes s
                JOIN movies m ON s.movie_id = m.id
                JOIN rooms r ON s.room_id = r.id
                WHERE s.status = 'OPEN'
                AND s.movie_id = :movieId
                ORDER BY s.start_time ASC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("movieId", movieId)
                        .registerRowMapper(BeanMapper.factory(Showtime.class))
                        .mapTo(Showtime.class)
                        .list()
        );
    }
    public Showtime findById(int showtimeId) {
        String sql = """
            SELECT
                s.id,
                s.movie_id AS movieId,
                s.room_id AS roomId,
                m.title AS movieTitle,
                r.name AS roomName,
                DATE_FORMAT(s.start_time, '%d/%m/%Y') AS showDate,
                DATE_FORMAT(s.start_time, '%H:%i') AS showTime,
                s.price,
                FORMAT(s.price, 0) AS priceText,
                s.status
            FROM showtimes s
            JOIN movies m ON s.movie_id = m.id
            JOIN rooms r ON s.room_id = r.id
            WHERE s.id = :showtimeId
            """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("showtimeId", showtimeId)
                        .registerRowMapper(BeanMapper.factory(Showtime.class))
                        .mapTo(Showtime.class)
                        .findOne()
                        .orElse(null)
        );
    }
}